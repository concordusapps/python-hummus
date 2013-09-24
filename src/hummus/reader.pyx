# -*- coding: utf-8 -*-
from hummus.interface cimport *
from hummus.reader cimport *
from hummus.writer cimport *
from hummus.stream import StreamByteReaderWithPosition
from hummus.rectangle cimport Rectangle, PDFRectangle


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

    property media_box:

        def __get__(self):
            cdef Rectangle result

            self._parse()

            result = Rectangle.__new__(Rectangle)
            result._handle = new PDFRectangle(self._handle.GetMediaBox())
            return result

    def _parse(self):
        cdef PDFObject* _obj

        if self._handle == NULL:
            _obj = self._parent._handle.ParsePage(self._index)
            self._handle = new PDFPageInput(&self._parent._handle, _obj)


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
