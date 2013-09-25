# -*- coding: utf-8 -*-
from libcpp.string cimport string
from libcpp.pair cimport pair
from libcpp.list cimport list
from hummus.interface cimport *
from hummus.context cimport PageContentContext
from hummus.page cimport *


cdef extern from "PDFWriter.h" namespace "PDFPageRange":
    ctypedef int ERangeType

    ERangeType eRangeTypeAll
    ERangeType eRangeTypeSpecific


cdef extern from "PDFFormXObject.h":

    cdef cppclass PDFFormXObject:
        int GetObjectID()


cdef extern from "PDFWriter.h":

    ctypedef int EPDFVersion

    EPDFVersion ePDFVersion10
    EPDFVersion ePDFVersion11
    EPDFVersion ePDFVersion12
    EPDFVersion ePDFVersion13
    EPDFVersion ePDFVersion14
    EPDFVersion ePDFVersion15
    EPDFVersion ePDFVersion16
    EPDFVersion ePDFVersion17

    ctypedef int EPDFPageBox

    EPDFPageBox ePDFPageBoxMediaBox
    EPDFPageBox ePDFPageBoxCropBox
    EPDFPageBox ePDFPageBoxBleedBox
    EPDFPageBox ePDFPageBoxTrimBox
    EPDFPageBox ePDFPageBoxArtBox

    cdef cppclass PDFUsedFont:
        pass

    ctypedef pair[long, long] ULongAndULong
    ctypedef list[ULongAndULong] ULongAndULongList

    ctypedef long ObjectIDType
    ctypedef list[ObjectIDType] ObjectIDTypeList
    ctypedef pair[int, ObjectIDTypeList] EStatusCodeAndObjectIDTypeList

    cdef cppclass PDFPageRange:
        ERangeType mType
        ULongAndULongList mSpecificRanges

    cdef cppclass PDFWriter:

        int StartPDF(string filename, EPDFVersion)
        int EndPDF()

        int StartPDFForStream(PythonByteWriterWithPosition*, EPDFVersion)
        int EndPDFForStream()

        int Reset()

        PageContentContext* StartPageContentContext(PDFPage*)
        int EndPageContentContext(PageContentContext*)

        int WritePageAndRelease(PDFPage*)
        int WritePage(PDFPage*)

        PDFUsedFont* GetFontForFile(string filename, int index=0)

        PDFFormXObject* CreateFormXObjectFromJPGFile(const string&)

        PDFFormXObject* CreateFormXObjectFromJPGStream(
            PythonByteReaderWithPosition*)

        EStatusCodeAndObjectIDTypeList CreateFormXObjectsFromPDF(
            const string&, const PDFPageRange&, EPDFPageBox)

        EStatusCodeAndObjectIDTypeList CreateFormXObjectsFromPDF(
            PythonByteReaderWithPosition*, const PDFPageRange&, EPDFPageBox)
