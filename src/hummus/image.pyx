# -*- coding: utf-8 -*-
import six
import io
from wand import image as wand
from hummus.utils cimport to_string
from hummus.context cimport *
from hummus.writer cimport *
from hummus.rectangle cimport *
from hummus.stream import StreamByteReaderWithPosition


cdef class Image:
    """Represents a PDF image that can be embedded in a document.

    Note that hummus can only take TIFF and JPEG images natively. However
    this transparently applies an image magick stream using wand to
    allow any image format to be embedded.
    """

    cdef _stream
    cdef Rectangle _box

    def __cinit__(self, source, index=0):
        # Ensure the source is a stream.
        temp_stream = io.BytesIO()

        # Construct a wand image stream over the source.
        key = 'filename' if isinstance(source, six.string_types) else 'file'
        with wand.Image(**{key: source}) as image:
            # Save the size of the image.
            self._box = Rectangle(bottom=image.height, right=image.width)

            # Set resolution units to undefined as PDF will embed a ghost
            # image if we do not. This is stupid by the way.
            image.units = 'undefined'
            image.resolution = 1
            # Convert the image to JPEG and save it into the byte stream.
            with wand.Image(image.sequence[index]) as o:
                o.format = 'jpeg'
                o.save(file=temp_stream)

        # # Construct a streaming reader from the stream.
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
        ctx._handle.cm(1, 0, 0, 1, 0, 0)
        resources = &(ctx._page._handle.GetResourcesDictionary())
        ctx._handle.Do(resources.AddFormXObjectMapping(obj.GetObjectID()))
        ctx._handle.Q()

    property box:

        def __get__(self):
            return self._box
