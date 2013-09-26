# -*- coding: utf-8 -*-
import zlib
import re
from hummus.interface cimport *
from hummus.reader cimport *
from hummus.writer cimport *
from hummus.stream import StreamByteReaderWithPosition
from hummus.rectangle cimport Rectangle, PDFRectangle
from hummus.page cimport *
from hummus.interface cimport *
from hummus.context cimport *


cdef class PageInput:
    """Represents a specific page of a parsed PDF document.

    This is lazily-evaluated for information. It can safely be used as
    a quick reference to a page in the parsed document.
    """

    def __cinit__(self, Reader parent, int index):
        self._index = index
        self._parent = parent

        if index >= len(parent):
            raise IndexError

    def __dealloc__(self):
        if self._handle != NULL:
            del self._handle

    property index:

        def __get__(self):
            return self._index

    property box:

        def __get__(self):
            cdef Rectangle result

            # Ensure we know what we are.
            self._parse()

            result = Rectangle.__new__(Rectangle)
            result._handle = new PDFRectangle(self._handle.GetMediaBox())
            return result

    def _parse(self):
        cdef PDFDictionary* _obj

        if self._handle == NULL:
            _obj = self._parent._handle.ParsePage(self._index)
            self._handle = new PDFPageInput(
                &self._parent._handle, <PDFObject*>_obj)

    def has_text(self):
        """Figure out if there is text in this page.
        """

        cdef PDFDictionary* obj
        cdef PDFStreamInput* contents
        cdef PDFDictionary* info
        cdef PDFObject* info_filter
        cdef PDFObject* info_length

        # Discover our contents.
        obj = self._parent._handle.ParsePage(self._index)
        contents = <PDFStreamInput*>self._parent._handle.QueryDictionaryObject(
            obj, 'Contents')

        if not contents:
            return False

        offset = contents.GetStreamContentStart()
        info = contents.QueryStreamDictionary()
        if not info.Exists('Length'):
            return False

        compressed = info.Exists('Filter')

        info_length = info.QueryDirectObject('Length')
        length = (<PDFInteger*>info_length).GetValue()
        if not length:
            return False

        # Release low-level data structures.
        info_length.Release()
        info.Release()
        obj.Release()
        contents.Release()

        # Read in data.
        current = self._parent._stream.tell()
        self._parent._stream.seek(offset)
        data = self._parent._stream.read(length)
        self._parent._stream.seek(current)

        # Decompress data if needed.
        if compressed:
            data = zlib.decompress(data)

        # Check for the Tj operator.
        return re.search('TJ', data.decode('utf8'), re.IGNORECASE) is not None

    def embed_to(self, Context ctx):
        cdef PDFPageRange page_range
        cdef ResourcesDictionary* resources
        cdef PythonByteReaderWithPosition* stream_handle = NULL
        cdef ByteReaderWithPosition base_reader
        cdef int current

        # Construct a page range to extract from the PDF.
        # TODO: Allow specified range.
        page_range.mType = eRangeTypeSpecific
        page_range.mSpecificRanges = ((self.index, self.index),)

        # Set the stream to the beginning.
        current = self._parent._stream.tell()
        self._parent._stream.seek(0)

        # Pull out the low-level handle.
        base_reader = <ByteReaderWithPosition>self._parent._stream
        stream_handle = base_reader._handle

        # Extract information from the PDF.
        status, pages = ctx._writer.CreateFormXObjectsFromPDF(
            stream_handle, page_range, ePDFPageBoxMediaBox)

        # Prepare the context for the operation.
        ctx._handle.q()

        resources = &(ctx._page._handle.GetResourcesDictionary())
        ctx._handle.Do(resources.AddFormXObjectMapping(pages[0]))

        # Finish the operation.
        ctx._handle.Q()

        # Reset the stream.
        self._parent._stream.seek(current)


cdef class Reader:
    """Reads basic metadata from a PDF document.

    @param[in] source
        A file-like object or a filename of the PDF document to read.
    """

    def __cinit__(self, source):
        cdef PythonByteReaderWithPosition* stream_handle = NULL
        cdef ByteReaderWithPosition base_reader
        cdef int status

        if hasattr(source, 'read'):
            # Construct a streaming reader from the stream.
            self._stream = StreamByteReaderWithPosition(source)

        else:
            # Construct a streaming reader from the stream.
            self._stream = StreamByteReaderWithPosition(open(source, 'rb'))
            self._managed = True

        # Pull out the low-level handle.
        base_reader = <ByteReaderWithPosition>self._stream
        stream_handle = base_reader._handle

        # Extract page information from the PDF.
        status = self._handle.StartPDFParsing(stream_handle)
        if status < 0:
            raise ValueError('Not a valid PDF document', source)

    def __enter__(self):
        return self

    def __exit__(self, *args):
        if self._managed:
            self._stream.close()

    def __len__(self):
        cdef int count = self._handle.GetPagesCount()
        return count

    def __getitem__(self, index):
        return PageInput(self, index)
