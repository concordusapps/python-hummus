# -*- coding: utf-8 -*-
from libcpp.string cimport string
from hummus.interface cimport PythonByteWriterWithPosition


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

    cdef cppclass PDFWriter:

        int StartPDF(string filename, EPDFVersion)
        int EndPDF()

        int StartPDFForStream(PythonByteWriterWithPosition*, EPDFVersion)
        int EndPDFForStream()

        int Reset()
