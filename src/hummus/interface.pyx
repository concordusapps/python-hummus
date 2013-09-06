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
