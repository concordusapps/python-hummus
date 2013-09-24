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
    with open('output.pdf', 'wb') as stream, Document(stream) as document:

        # Initialize a new page and begin its context.
        with document.Page() as ctx:

            # Embed the document from a memory stream.
            with open(filename, 'rb') as instream:
                ctx.embed_document(instream, page=4)

            # Write some text.
            ctx.write_text('Hello World', font, size=14, x=100, y=60)


if __name__ == '__main__':
    if len(sys.argv) == 1:
        print('Specify filename to embed.')
        sys.exit(0)

    main(sys.argv[1])
