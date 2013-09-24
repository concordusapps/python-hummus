# -*- coding: utf-8 -*-
from cpython.ref cimport PyObject
from hummus.interface cimport *


cdef class ByteWriter:

    def __cinit__(self):
        self._handle = new PythonByteWriter(<PyObject*>self)

    def __dealloc__(self):
        if self._handle != NULL:
            del self._handle

    def write(self, chunk):
        # Default implementation does nothing.
        return 0


cdef public api size_t _hummus_bw_write(
        object self, const_Byte* data, int size):
    return self.write(data[:size])


cdef class ByteWriterWithPosition:

    def __cinit__(self):
        self._handle = new PythonByteWriterWithPosition(<PyObject*>self)

    def __dealloc__(self):
        if self._handle != NULL:
            del self._handle

    def write(self, chunk):
        # Default implementation does nothing.
        return 0

    def tell(self):
        # Default implementation does nothing.
        return 0


cdef public api size_t _hummus_bw_tell(object self):
    return self.tell()


cdef class ByteReader:

    def __cinit__(self):
        self._handle = new PythonByteReader(<PyObject*>self)

    def __dealloc__(self):
        if self._handle != NULL:
            del self._handle

    def read(self, size):
        # Default implementation does nothing.
        return ''

    def __bool__(self):
        # Default implementation does nothing.
        return False


cdef public api size_t _hummus_br_read(object self, Byte* data, int size):
    return 0


cdef public api size_t _hummus_br_eof(object self):
    return bool(self)
