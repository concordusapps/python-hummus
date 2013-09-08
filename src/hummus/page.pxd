# -*- coding: utf-8 -*-
from libcpp.string cimport string
from hummus.rectangle cimport PDFRectangle


cdef extern from "ResourcesDictionary.h":

    ctypedef long ObjectIDType

    cdef cppclass ResourcesDictionary:

        string AddFormXObjectMapping(ObjectIDType)


cdef extern from "PDFPage.h":

    cdef cppclass PDFPage:

        void SetMediaBox(const PDFRectangle& inMediaBox)
        PDFRectangle& GetMediaBox()

        ResourcesDictionary& GetResourcesDictionary()

cdef class Page:
    cdef PDFPage* _handle
