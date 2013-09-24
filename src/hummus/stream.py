# -*- coding: utf-8 -*-
from hummus.interface import (ByteWriter, ByteWriterWithPosition,
                              ByteReader, ByteReaderWithPosition)


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


class StreamByteReader(ByteReader):

    def __init__(self, stream):
        #! The file-like object to send reads to.
        self._stream = stream

        #! Have we hit the end of the stream.
        self._end = False

    def read(self, size):
        data = self._stream.read(size)
        if size != 0 and data == '':
            self._end = True
        return data

    def __bool__(self):
        return self._end


class StreamByteReaderWithPosition(ByteReaderWithPosition):

    def __init__(self, stream):
        #! The file-like object to send reads to.
        self._stream = stream

        #! Have we hit the end of the stream.
        self._end = False

    def read(self, size):
        data = self._stream.read(size)
        if size != 0 and data == '':
            self._end = True
        return data

    def __bool__(self):
        return self._end

    def seek(self, offset, whence=0):
        self._stream.seek(offset, whence)

    def tell(self):
        return self._stream.tell()
