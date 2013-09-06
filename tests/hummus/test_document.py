# -*- coding: utf-8 -*-
import hummus
from tempfile import NamedTemporaryFile
import os


def assert_pdf(filename):
    with open(filename, 'rb') as stream:
        assert stream.read(8) == b'%PDF-1.7'


def test_document_file():
    with NamedTemporaryFile(delete=False) as stream:
        # Run through a normal cycle.
        document = hummus.Document(filename=stream.name)
        document.begin()
        document.end()

    # Open and test the file.
    assert_pdf(stream.name)

    # Remove the file.
    os.remove(stream.name)


def test_document_stream():
    with NamedTemporaryFile(delete=False) as stream:
        # Run through a normal cycle.
        document = hummus.Document(stream)
        document.begin()
        document.end()

    # Open and test the file.
    assert_pdf(stream.name)

    # Remove the file.
    os.remove(stream.name)
