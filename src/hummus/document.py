# -*- coding: utf-8 -*-
from hummus.writer import Writer
from hummus.reader import Reader


def Document(source, mode='w'):
    if mode == 'w':
        return Writer(source)

    if mode == 'r':
        return Reader(source)
