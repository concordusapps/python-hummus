# -*- coding: utf-8 -*-
from hummus.interface import ByteWriter, ByteWriterWithPosition


class StreamByteWriter(ByteWriter):

    def __init__(self, stream):
        #! The file-like object to send writes to.
        self._stream = stream

    def write(self, data):
        return self._stream.write(data)


class StreamByteWriterWithPosition(ByteWriterWithPosition):

    def __init__(self, stream):
        #! The file-like object to send writes to.
        self._stream = stream

    def write(self, data):
        return self._stream.write(data)

    def tell(self):
        return self._stream.tell()
