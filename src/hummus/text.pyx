# -*- coding: utf-8 -*-
import six
from hummus import Font
from hummus.utils cimport *
from hummus.context cimport *


cdef class Text:
    cdef string _text
    cdef string _font
    cdef int _size
    cdef int _x
    cdef int _y
    cdef int _mode

    def __cinit__(self, text, font='arial', size=10, x=0, y=0, mode=2):
        # Ensure we have a valid font.
        if isinstance(font, six.string_types):
            font = Font(font)
            if not font:
                raise ValueError('Not a valid font family', font)

        # Store properties.
        self._text = to_string(text)
        self._font = to_string(font.file)
        self._size = size
        self._mode = mode
        self._x = x
        self._y = y

    def add_to(self, Context ctx):
        cdef PDFUsedFont* font

        # Create a font object from the passed font.
        font = ctx._writer.GetFontForFile(self._font)
        if font is NULL:
            raise ValueError('Font not recognized by PDF', self._font)

        # Perform the write operation.
        ctx._handle.BT()
        ctx._handle.k(0, 0, 0, 1)
        ctx._handle.Tf(font, self._size)
        ctx._handle.Tm(1, 0, 0, 1, self._x, self._y)
        ctx._handle.Tr(self._mode)
        ctx._handle.Tj(self._text)
        ctx._handle.ET()
