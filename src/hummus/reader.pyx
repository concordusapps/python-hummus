# -*- coding: utf-8 -*-
from hummus.document cimport *


cdef class Reader:
    """An interface to extract various bits of information from a PDF.

    @param[in] source
        A file-like object or a filename to the PDF to open.
    """

    cdef PDFWriter _handle

    def __cinit__(self, source):
        self._handle.CreateFormXObjectsFromPDF()
