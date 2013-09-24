# -*- coding: utf-8 -*-
from hummus.interface cimport *
from hummus.rectangle cimport PDFRectangle


cdef extern from "PDFObject.h":

    cdef cppclass PDFObject:
        pass


cdef extern from "PDFPageInput.h":

    cdef cppclass PDFPageInput:
        PDFPageInput(PDFParser* inParser, PDFObject* inPageObject)
        PDFRectangle GetMediaBox()


cdef extern from "PDFParser.h":

    cdef cppclass PDFParser:
        int StartPDFParsing(PythonByteReaderWithPosition* source)
        int GetPagesCount()

        PDFObject* ParsePage(int index)


cdef class Reader:
    cdef PDFParser _handle
    cdef _stream
    cdef bint _managed


cdef class PageInput:
    cdef PDFPageInput* _handle
    cdef int _index
    cdef Reader _parent
