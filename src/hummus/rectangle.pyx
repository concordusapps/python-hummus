# -*- coding: utf-8 -*-
from hummus.rectangle cimport *


cdef class Rectangle:

    def __init__(
            self,
            float left=0,
            float top=0,
            float right=0,
            float bottom=0):
        self._handle = new PDFRectangle(left, top, right, bottom)

    def __dealloc__(self):
        if self._handle != NULL:
            del self._handle

    property left:

        def __get__(self):
            return self._handle.LowerLeftX

        def __set__(self, value):
            self._handle.LowerLeftX = value

    property top:

        def __get__(self):
            return self._handle.LowerLeftY

        def __set__(self, value):
            self._handle.LowerLeftY = value

    property right:

        def __get__(self):
            return self._handle.UpperRightX

        def __set__(self, value):
            self._handle.UpperRightX = value

    property bottom:

        def __get__(self):
            return self._handle.UpperRightY

        def __set__(self, value):
            self._handle.UpperRightY = value
