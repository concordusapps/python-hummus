# -*- coding: utf-8 -*-
from cpython.ref cimport PyObject
from libc.string cimport memcpy
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
    cdef bytes text = self.read(size)
    if text is None:
        return 0

    cdef Byte* content = text
    actual_size = len(text)
    memcpy(data, content, actual_size)
    return actual_size



cdef public api size_t _hummus_br_not_ended(object self):
    return bool(self)


cdef class ByteReaderWithPosition:

    def __cinit__(self):
        self._handle = new PythonByteReaderWithPosition(<PyObject*>self)

    def __dealloc__(self):
        if self._handle != NULL:
            del self._handle

    def read(self, size):
        # Default implementation does nothing.
        print('read', size)
        return ''

    def __bool__(self):
        # Default implementation does nothing.
        return False

    def seek(self, offset, whence=0):
        # Default implementation does nothing.
        pass

    def tell(self):
        # Default implementation does nothing.
        return 0


cdef public api void _hummus_br_seek_from_begin(object self, size_t offset):
    self.seek(offset)


cdef public api void _hummus_br_seek_from_end(object self, size_t offset):
    cdef int reverse = offset
    self.seek(-reverse, 2)


cdef public api void _hummus_br_seek(object self, size_t offset):
    self.seek(offset, 1)


cdef public api size_t _hummus_br_tell(object self):
    return self.tell()
