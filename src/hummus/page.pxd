# -*- coding: utf-8 -*-
from hummus.rectangle cimport PDFRectangle


cdef extern from "PDFPage.h":

    cdef cppclass PDFPage:

        void SetMediaBox(const PDFRectangle& inMediaBox)
        PDFRectangle& GetMediaBox()


cdef class Page:
    cdef PDFPage* _handle
