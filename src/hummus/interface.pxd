# -*- coding: utf-8 -*-
from cpython.ref cimport PyObject


cdef extern from "IOBasicTypes.h":
    ctypedef unsigned char Byte "unsigned char"
    ctypedef unsigned char const_Byte "const unsigned char"

    ctypedef size_t LongBufferSizeType
    ctypedef long LongFilePositionType


cdef extern from "interface/PythonByteWriter.h":

    cdef cppclass PythonByteWriter:
        PythonByteWriter(PyObject* obj)
        LongBufferSizeType Write(const Byte* stream, LongBufferSizeType size)


cdef extern from "interface/PythonByteWriterWithPosition.h":

    cdef cppclass PythonByteWriterWithPosition:
        PythonByteWriterWithPosition(PyObject* obj)
        LongBufferSizeType Write(const Byte* stream, LongBufferSizeType size)
        LongFilePositionType GetCurrentPosition()


cdef extern from "interface/PythonByteReader.h":

    cdef cppclass PythonByteReader:
        PythonByteReader(PyObject* obj)
        LongBufferSizeType Read(Byte* stream, LongBufferSizeType size)


cdef class ByteWriter:
    cdef PythonByteWriter* _handle


cdef class ByteWriterWithPosition:
    cdef PythonByteWriterWithPosition* _handle


cdef class ByteReader:
    cdef PythonByteReader* _handle


#cdef class ByteReaderWithPosition:
#    cdef PythonByteReaderWithPosition* _handle
