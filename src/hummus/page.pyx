# -*- coding: utf-8 -*-
from cython.operator import dereference as deref
from hummus.page cimport *
from hummus.rectangle cimport Rectangle


cdef class Page:

    def __init__(self):
        self._handle = new PDFPage()

    def __dealloc__(self):
        if self._handle != NULL:
            del self._handle

    property media_box:

        def __get__(self):
            cdef PDFRectangle* handle
            cdef Rectangle result

            handle = <PDFRectangle*>&self._handle.GetMediaBox()
            result = Rectangle(handle.LowerLeftX, handle.LowerLeftY,
                               handle.UpperRightX, handle.UpperRightY)

            return result

        def __set__(self, Rectangle value):
            self._handle.SetMediaBox(deref(value._handle))
