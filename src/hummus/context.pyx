# -*- coding: utf-8 -*-
from hummus.utils cimport to_string
from hummus.writer cimport *
from hummus.page cimport *
from hummus.font import Font
from hummus.interface cimport *
from hummus.reader cimport PageInput


cdef class Context:

    def __enter__(self):
        return self

    def close(self):
        # Release the page context.
        self._writer.EndPageContentContext(self._handle)

        # Null the handles.
        self._writer = NULL
        self._handle = NULL

    def __exit__(self, *args):
        self.close()

    property box:

        def __get__(self):
            return self._page.box

        def __set__(self, value):
            self._page.box = value

    def add(self, element):
        element.add_to(self)

    def embed(self, element):
        element.embed_to(self)
