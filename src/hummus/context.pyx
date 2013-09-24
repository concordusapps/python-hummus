# -*- coding: utf-8 -*-
from hummus.utils cimport to_string
from hummus.document cimport *
from hummus.page cimport *
from hummus.font import Font
from hummus.interface cimport (
    PythonByteReaderWithPosition, ByteReaderWithPosition)
from hummus.stream import StreamByteReaderWithPosition


cdef class Context:

    def __enter__(self):
        return self

    def close(self):
        # Release the page context.
        self._document.EndPageContentContext(self._handle)

        # Null the handles.
        self._document = NULL
        self._handle = NULL

    def __exit__(self, *args):
        self.close()

    property media_box:

        def __get__(self):
            return self._page.media_box

        def __set__(self, value):
            self._page.media_box = value

    def write_text(self, text, font, size=10, x=0, y=0):
        cdef PDFUsedFont* font_obj

        # Create a font object out of the passed python font.
        font_obj = self._document.GetFontForFile(to_string(font.file))
        if font_obj is NULL:
            raise ValueError('Font not recognized by PDF', font)

        # Prepare the context for writing text.
        self._handle.BT()

        self._handle.k(0, 0, 0, 1)
        self._handle.Tf(font_obj, size)
        self._handle.Tm(1, 0, 0, 1, x, y)
        self._handle.Tj(to_string(text))

        # Finish the text operation.
        self._handle.ET()

    def embed_document(self, source, page=0):
        cdef PDFPageRange page_range
        cdef ResourcesDictionary* resources
        cdef PythonByteReaderWithPosition* stream_handle = NULL
        cdef ByteReaderWithPosition base_reader

        # Construct a page range to extract from the PDF.
        # TODO: Allow specified range.
        page_range.mType = eRangeTypeSpecific
        page_range.mSpecificRanges = ((page, page),)

        if hasattr(source, 'read'):
            # Construct a streaming reader.
            reader = StreamByteReaderWithPosition(source)

            # Pull out the low-level handle.
            base_reader = <ByteReaderWithPosition>reader
            stream_handle = base_reader._handle

            # Extract page information from the PDF.
            status, pages = self._document.CreateFormXObjectsFromPDF(
                stream_handle, page_range, ePDFPageBoxMediaBox)

        else:
            # Extract page information from the PDF.
            status, pages = self._document.CreateFormXObjectsFromPDF(
                to_string(source), page_range, ePDFPageBoxMediaBox)

        if status < 0:
            raise ValueError(
                'Document not recognized as a valid PDF', source)

        # Prepare the context for the operation.
        self._handle.q()

        resources = &(self._page._handle.GetResourcesDictionary())
        self._handle.Do(resources.AddFormXObjectMapping(pages[0]))

        # Finish the operation.
        self._handle.Q()
