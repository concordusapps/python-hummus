#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
from hummus import Document, Font


def main(filename):
    """
    Creates a PDF by embedding the first page from the given document and
    writes some text to it.

    @param[in] filename
        The source filename of the PDF document to embed.
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

            # Open the document to embed.
            with Document(filename, 'r') as embed:
                # Set the media box for the page to the same as the
                # page to embed.
                ctx.media_box = embed[0].media_box

                # Embed the document.
                ctx.embed(embed[0])

            # # Write some text.
            # ctx.add(Text('Hello World', font, size=14, x=100, y=60))


if __name__ == '__main__':
    if len(sys.argv) == 1:
        print('Specify filename to embed.')
        sys.exit(0)

    main(sys.argv[1])
