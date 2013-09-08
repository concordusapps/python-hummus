# -*- coding: utf-8 -*-
from libcpp.string cimport string
from hummus.document cimport PDFWriter, PDFUsedFont
from hummus.page cimport Page


cdef extern from "PageContentContext.h":

    cdef cppclass PageContentContext:

        void BT()
        void ET()

        void k(float cyan, float magneta, float yellow, float black)

        void Tm(float A, float B, float C, float D, float E, float F)

        void Tj(string)

        void Tf(PDFUsedFont*, float size)

        void q()
        void Q()

        void Do(string)

cdef class Context:
    cdef PDFWriter* _document
    cdef Page _page
    cdef PageContentContext* _handle
