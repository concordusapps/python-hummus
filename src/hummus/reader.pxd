# -*- coding: utf-8 -*-
from libcpp.string cimport string
from hummus.interface cimport *
from hummus.rectangle cimport PDFRectangle


cdef extern from "PDFObject.h" namespace "PDFObject":

    ctypedef int EPDFObjectType

    EPDFObjectType ePDFObjectBoolean
    EPDFObjectType ePDFObjectLiteralString
    EPDFObjectType ePDFObjectHexString
    EPDFObjectType ePDFObjectNull
    EPDFObjectType ePDFObjectName
    EPDFObjectType ePDFObjectInteger
    EPDFObjectType ePDFObjectReal
    EPDFObjectType ePDFObjectArray
    EPDFObjectType ePDFObjectDictionary
    EPDFObjectType ePDFObjectIndirectObjectReference
    EPDFObjectType ePDFObjectStream
    EPDFObjectType ePDFObjectSymbol


cdef extern from "PDFObject.h":

    cdef cppclass PDFObject:
        void AddRef()
        void Release()
        int GetType()


cdef extern from "PDFDictionary.h":

    cdef cppclass PDFDictionary(PDFObject):
        bint Exists(string name)
        PDFObject* QueryDirectObject(const string& name)


cdef extern from "PDFDictionary.h":

    cdef cppclass PDFDictionary(PDFObject):
        bint Exists(string name)
        PDFObject* QueryDirectObject(const string& name)


cdef extern from "PDFInteger.h":

    cdef cppclass PDFInteger(PDFObject):
        int GetValue()


cdef extern from "PDFName.h":

    cdef cppclass PDFName(PDFObject):
        string GetValue()


cdef extern from "PDFArray.h":

    cdef cppclass PDFArray(PDFObject):
        PDFObject* QueryObject(long index)
        long GetLength()


cdef extern from "PDFStreamInput.h":

    cdef cppclass PDFStreamInput(PDFObject):
        size_t GetStreamContentStart()
        PDFDictionary* QueryStreamDictionary()


cdef extern from "PDFPageInput.h":

    cdef cppclass PDFPageInput:
        PDFPageInput(PDFParser* inParser, PDFObject* inPageObject)
        PDFRectangle GetMediaBox()


cdef extern from "PDFParser.h":

    cdef cppclass PDFParser:
        int StartPDFParsing(PythonByteReaderWithPosition* source)
        int GetPagesCount()

        bint IsEncrypted()

        PDFDictionary* ParsePage(int index)

        PDFObject* QueryDictionaryObject(PDFDictionary*,const string& name)
        PDFObject* QueryArrayObject(PDFArray*, long index)


cdef class Reader:
    cdef PDFParser* _handle
    cdef _stream
    cdef bint _managed


cdef class PageInput:
    cdef PDFPageInput* _handle
    cdef int _index
    cdef Reader _parent

    cdef bint _ref_has_text(self, PDFObject* ref)
