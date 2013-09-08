# -*- coding: utf-8 -*-
from subprocess import Popen, PIPE


def find_font(family, weight="normal", slant="roman"):
    # Generate the query string for font-config.
    query = ':family=%s:weight=%s:slant=%s' % (family, weight, slant)

    # Ask font-config to see if we can match a font.
    process = Popen(['fc-match', '-s', query, 'file'], stdout=PIPE)
    out, _ = process.communicate()

    # Parse the output.
    out = out.decode('utf8')
    data = out.split()[0]
    if data:
        return data[6:]


class Font:

    def __init__(self, family, size=12, bold=False, italic=False):
        # Find the font.
        self.file = find_font(
            family,
            weight='bold' if bold else 'normal',
            slant='italic' if italic else 'roman')

        # Store properties of the font.
        self.family = family
        self.size = size
        self.bold = bold
        self.italic = italic

    def __repr__(self):
        return '<Font(%r)>' % self.file
