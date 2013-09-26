# -*- coding: utf-8 -*-
from libcpp.string cimport string
from hummus.interface cimport *
from hummus.rectangle cimport PDFRectangle


cdef extern from "PDFObject.h":

    cdef cppclass PDFObject:
        void Release()
        int GetType()


cdef extern from "PDFDictionary.h":

    cdef cppclass PDFDictionary:
        void Release()
        bint Exists(string name)
        PDFObject* QueryDirectObject(const string& name)


cdef extern from "PDFInteger.h":

    cdef cppclass PDFInteger:
        void Release()
        int GetValue()


cdef extern from "PDFName.h":

    cdef cppclass PDFName:
        void Release()
        string GetValue()


cdef extern from "PDFStreamInput.h":

    cdef cppclass PDFStreamInput:
        size_t GetStreamContentStart()
        void Release()
        PDFDictionary* QueryStreamDictionary()


cdef extern from "PDFPageInput.h":

    cdef cppclass PDFPageInput:
        PDFPageInput(PDFParser* inParser, PDFObject* inPageObject)
        PDFRectangle GetMediaBox()


cdef extern from "PDFParser.h":

    cdef cppclass PDFParser:
        int StartPDFParsing(PythonByteReaderWithPosition* source)
        int GetPagesCount()

        PDFDictionary* ParsePage(int index)

        PDFObject* QueryDictionaryObject(PDFDictionary*,const string& name)


cdef class Reader:
    cdef PDFParser _handle
    cdef _stream
    cdef bint _managed


cdef class PageInput:
    cdef PDFPageInput* _handle
    cdef int _index
    cdef Reader _parent
