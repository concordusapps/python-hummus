# -*- coding: utf-8 -*-


cdef class Context:

    def __enter__(self):
        pass

    def close(self):
        # Release the page context.
        self._document.EndPageContentContext(self._handle)

        # Null the handles.
        self._document = NULL
        self._handle = NULL

    def __exit__(self, *args):
        self.close()
