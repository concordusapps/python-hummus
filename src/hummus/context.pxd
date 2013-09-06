# -*- coding: utf-8 -*-
from hummus.document cimport PDFWriter


cdef extern from "PageContentContext.h":

    cdef cppclass PageContentContext:
        pass


cdef class Context:
    cdef PDFWriter* _document
    cdef PageContentContext* _handle
