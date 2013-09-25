#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
from hummus import Document, Font, Text, Image, Rectangle


def main(filename):
    """
    Creates a PDF by embedding the first page from the given image and
    writes some text to it.

    @param[in] filename
        The source filename of the image to embed.
    """

    # Prepare font.
    font_family = 'arial'
    font = Font(font_family, bold=True)
    if not font:
        raise RuntimeError('No font found for %r' % font_family)

    # Initialize PDF document on a stream.
    with Document('output.pdf') as document:

        # Initialize a new page and begin its context.
        with document.Page() as ctx:

            # Open the image to embed.
            with Image(filename) as embed:

                # Set the media box for the page to the same as the
                # image to embed.
                ctx.box = embed.box

                # Embed the image.
                ctx.embed(embed)

            # Write some text.
            ctx.add(Text('Hello World', font, size=14, x=100, y=60))


if __name__ == '__main__':
    if len(sys.argv) == 1:
        print('Specify filename to embed.')
        sys.exit(0)

    main(sys.argv[1])
