# -*- coding: utf-8 -*-


cdef extern from "PDFRectangle.h":

    cdef cppclass PDFRectangle:
        PDFRectangle(float x0, float y0, float x1, float y1)

        float LowerLeftX
        float LowerLeftY
        float UpperRightX
        float UpperRightY


cdef class Rectangle:
    cdef PDFRectangle* _handle
