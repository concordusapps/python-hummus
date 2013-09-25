# -*- coding: utf-8 -*-
import six
import io
from wand import image as wand
from hummus.utils cimport to_string
from hummus.context cimport *
from hummus.writer cimport *
from hummus.stream import StreamByteReaderWithPosition


cdef class Image:
    """Represents a PDF image that can be embedded in a document.

    Note that hummus can only take TIFF and JPEG images natively. However
    this transparently applies an image magick stream using wand to
    allow any image format to be embedded.
    """

    cdef _stream

    def __cinit__(self, source, index=0):
        # Ensure the source is a stream.
        temp_stream = io.BytesIO()
        stream = source
        managed = False
        if isinstance(source, six.string_types):
            managed = True
            stream = open(source, 'rb')

        # Construct a wand image stream over the source.
        with wand.Image(file=stream) as image:
            if image.format != 'JPEG':
                # Convert the image to JPEG and save it into the byte stream.
                with image.Image(image.sequence[index]).convert('jpeg') as o:
                    o.save(file=temp_stream)

            else:
                # Don't try and convert a JPEG image because PDF hates
                # image magick JPEGs.
                stream.seek(0)
                temp_stream.write(stream.read())

        if managed:
            # Close our stream.
            stream.close()

        # Construct a streaming reader from the stream.
        temp_stream.seek(0)
        self._stream = StreamByteReaderWithPosition(temp_stream)

    def __enter__(self):
        return self

    def __exit__(self, *args):
        pass

    def embed_to(self, Context ctx):
        cdef PDFFormXObject* obj
        cdef ResourcesDictionary* resources
        cdef ByteReaderWithPosition base_reader
        cdef PythonByteReaderWithPosition* stream_handle = NULL

        # Create the PDF XObject from the stream.
        base_reader = <ByteReaderWithPosition>self._stream
        stream_handle = base_reader._handle
        obj = ctx._writer.CreateFormXObjectFromJPGStream(stream_handle)

        # Place the image on the page.
        ctx._handle.q()
        #void cm(float, float, float, float, float, float)
        ctx._handle.cm(1, 0, 0, 1, 0, 0)
        resources = &(ctx._page._handle.GetResourcesDictionary())
        ctx._handle.Do(resources.AddFormXObjectMapping(obj.GetObjectID()))
        ctx._handle.Q()
