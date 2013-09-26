# -*- coding: utf-8 -*-
from hummus.interface import (ByteWriter, ByteWriterWithPosition,
                              ByteReader, ByteReaderWithPosition)


class StreamByteWriter(ByteWriter):

    def __init__(self, stream):
        #! The file-like object to send writes to.
        self._stream = stream

    def write(self, data):
        return self._stream.write(data)

    def close(self):
        self._stream.close()


class StreamByteWriterWithPosition(ByteWriterWithPosition):

    def __init__(self, stream):
        #! The file-like object to send writes to.
        self._stream = stream

    def write(self, data):
        return self._stream.write(data)

    def tell(self):
        return self._stream.tell()

    def close(self):
        self._stream.close()


class StreamByteReader(ByteReader):

    def __init__(self, stream):
        #! The file-like object to send reads to.
        self._stream = stream

        #! Figure out where the end marker should be.
        position = self._stream.tell()
        self._stream.seek(0, 2)
        self._end = self._stream.tell()
        self._stream.seek(position)

    def read(self, size):
        data = self._stream.read(size)
        return data

    def __bool__(self):
        return self._stream.tell() != self._end

    def close(self):
        self._stream.close()


class StreamByteReaderWithPosition(ByteReaderWithPosition):

    def __init__(self, stream):
        #! The file-like object to send reads to.
        self._stream = stream

        #! Figure out where the end marker should be.
        position = self._stream.tell()
        self._stream.seek(0, 2)
        self._end = self._stream.tell()
        self._stream.seek(position)

    def read(self, size):
        data = self._stream.read(size)
        return data

    def __bool__(self):
        return self._stream.tell() != self._end

    def seek(self, offset, whence=0):
        self._stream.seek(offset, whence)

    def tell(self):
        return self._stream.tell()

    def close(self):
        self._stream.close()
