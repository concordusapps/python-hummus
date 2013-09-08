# -*- coding: utf-8 -*-
from .meta import version as __version__, description as __doc__  # NOQA
from .document import Document
from .page import Page
from .rectangle import Rectangle
from .font import Font

__all__ = [
    'Document',
    'Page',
    'Rectangle',
    'Font'
]
