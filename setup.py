#! /usr/bin/env python
# -*- coding: utf-8 -*-
from setuptools import setup, find_packages, Extension
from pkgutil import get_importer
from collections import defaultdict
import subprocess
from fnmatch import fnmatch
from os.path import join
from functools import partial
import os


def prefix(prefix, filenames):
    return list(map(partial(join, prefix), filenames))


PKGCONFIG_TOKEN_MAP = {
    '-D': 'define_macros',
    '-I': 'include_dirs',
    '-L': 'library_dirs',
    '-l': 'libraries'
}


def pkgconfig(*packages):
    """
    Run the `pkg-config` utility to determine locations of includes,
    libraries, etc. for dependencies.
    """
    config = defaultdict(set)

    # Execute the command in a subprocess and communicate the output.
    command = "pkg-config --libs --cflags %s" % ' '.join(packages)
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    out, _ = process.communicate()

    # Clean the output.
    out = out.decode('utf8')
    out = out.replace('\\\"', "")

    # Iterate throught the tokens of the output.
    for token in out.split():
        key = PKGCONFIG_TOKEN_MAP.get(token[:2])
        if key:
            config[key].add(token[2:].strip())

    # Convert sets to lists.
    for name in config:
        config[name] = list(config[name])

    # Iterate and resolve define macros.
    macros = []
    for declaration in config['define_macros']:
        macro = tuple(declaration.split('='))
        if len(macro) == 1:
            macro += '',

        macros.append(macro)

    config['define_macros'] = macros

    # Return discovered configuration.
    return config

# Load the metadata for inclusion in the package.
# Navigate, import, and retrieve the metadata of the project.
meta = get_importer('src/hummus').find_module('meta').load_module('meta')

# Process the `pkg-config` utility and discover include and library
# directories.
config = pkgconfig('zlib', 'libtiff-4', 'freetype2')

# Add libjpeg (no .pc file).
config['libraries'].append('jpeg')

# Add hummus.
config['include_dirs'].insert(0, 'lib/hummus/PDFWriter')


setup(
    name='hummus',
    version=meta.version,
    description=meta.description,
    author='Concordus Applications',
    author_email='support@concordusapps.com',
    url='https://github.com/concordusapps/python-hummus',
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 3.3',
    ],
    package_dir={'hummus': 'src/hummus'},
    packages=find_packages('src'),
    install_requires=[
    ],
    extras_require={
        'test': [
            'pytest',
            'pytest-pep8',
            'pytest-cov'
        ],
    },
    ext_modules=[
        Extension(
            name='_hummus',
            sources=prefix('lib/hummus/PDFWriter', [
               'AbstractContentContext.cpp',
               'AbstractWrittenFont.cpp',
               'ANSIFontWriter.cpp',
               'Ascii7Encoding.cpp',
               'CatalogInformation.cpp',
               'CFFANSIFontWriter.cpp',
               'CFFDescendentFontWriter.cpp',
               'CFFEmbeddedFontWriter.cpp',
               'CFFFileInput.cpp',
               'CFFPrimitiveReader.cpp',
               'CFFPrimitiveWriter.cpp',
               'CharStringType1Interpreter.cpp',
               'CharStringType1Tracer.cpp',
               'CharStringType2Flattener.cpp',
               'CharStringType2Interpreter.cpp',
               'CharStringType2Tracer.cpp',
               'CIDFontWriter.cpp',
               'CMYKRGBColor.cpp',
               'DescendentFontWriter.cpp',
               'DictionaryContext.cpp',
               'DocumentContext.cpp',
               'FontDescriptorWriter.cpp',
               'FreeTypeFaceWrapper.cpp',
               'FreeTypeOpenTypeWrapper.cpp',
               'FreeTypeType1Wrapper.cpp',
               'FreeTypeWrapper.cpp',
               'GraphicState.cpp',
               'GraphicStateStack.cpp',
               'IndirectObjectsReferenceRegistry.cpp',
               'InfoDictionary.cpp',
               'InputAscii85DecodeStream.cpp',
               'InputBufferedStream.cpp',
               'InputByteArrayStream.cpp',
               'InputCharStringDecodeStream.cpp',
               'InputDCTDecodeStream.cpp',
               'InputFile.cpp',
               'InputFileStream.cpp',
               'InputFlateDecodeStream.cpp',
               'InputLimitedStream.cpp',
               'InputPFBDecodeStream.cpp',
               'InputPredictorPNGAverageStream.cpp',
               'InputPredictorPNGNoneStream.cpp',
               'InputPredictorPNGOptimumStream.cpp',
               'InputPredictorPNGPaethStream.cpp',
               'InputPredictorPNGSubStream.cpp',
               'InputPredictorPNGUpStream.cpp',
               'InputPredictorTIFFSubStream.cpp',
               'InputStreamSkipperStream.cpp',
               'InputStringBufferStream.cpp',
               'JPEGImageHandler.cpp',
               'JPEGImageInformation.cpp',
               'JPEGImageParser.cpp',
               'Log.cpp',
               'MD5Generator.cpp',
               'ObjectsContext.cpp',
               'OpenTypeFileInput.cpp',
               'OpenTypePrimitiveReader.cpp',
               'OutputBufferedStream.cpp',
               'OutputFile.cpp',
               'OutputFileStream.cpp',
               'OutputFlateDecodeStream.cpp',
               'OutputFlateEncodeStream.cpp',
               'OutputStreamTraits.cpp',
               'OutputStringBufferStream.cpp',
               'PageContentContext.cpp',
               'PageTree.cpp',
               'ParsedPrimitiveHelper.cpp',
               'PDFArray.cpp',
               'PDFBoolean.cpp',
               'PDFDate.cpp',
               'PDFDictionary.cpp',
               'PDFDocEncoding.cpp',
               'PDFDocumentCopyingContext.cpp',
               'PDFDocumentHandler.cpp',
               'PDFFormXObject.cpp',
               'PDFHexString.cpp',
               'PDFImageXObject.cpp',
               'PDFIndirectObjectReference.cpp',
               'PDFInteger.cpp',
               'PDFLiteralString.cpp',
               'PDFName.cpp',
               'PDFNull.cpp',
               'PDFObject.cpp',
               'PDFObjectParser.cpp',
               'PDFPage.cpp',
               'PDFPageInput.cpp',
               'PDFPageMergingHelper.cpp',
               'PDFParser.cpp',
               'PDFParserTokenizer.cpp',
               'PDFReal.cpp',
               'PDFRectangle.cpp',
               'PDFStream.cpp',
               'PDFStreamInput.cpp',
               'PDFSymbol.cpp',
               'PDFTextString.cpp',
               'PDFUsedFont.cpp',
               'PDFWriter.cpp',
               'PFMFileReader.cpp',
               'PrimitiveObjectsWriter.cpp',
               'PSBool.cpp',
               'RefCountObject.cpp',
               'ResourcesDictionary.cpp',
               'StandardEncoding.cpp',
               'StateReader.cpp',
               'StateWriter.cpp',
               'TIFFImageHandler.cpp',
               'TiffUsageParameters.cpp',
               'Timer.cpp',
               'TimersRegistry.cpp',
               'Trace.cpp',
               'TrailerInformation.cpp',
               'TrueTypeANSIFontWriter.cpp',
               'TrueTypeDescendentFontWriter.cpp',
               'TrueTypeEmbeddedFontWriter.cpp',
               'TrueTypePrimitiveWriter.cpp',
               'Type1Input.cpp',
               'Type1ToCFFEmbeddedFontWriter.cpp',
               'Type1ToType2Converter.cpp',
               'Type2CharStringWriter.cpp',
               'UnicodeString.cpp',
               'UppercaseSequance.cpp',
               'UsedFontsRepository.cpp',
               'WinAnsiEncoding.cpp',
               'WrittenFontCFF.cpp',
               'WrittenFontTrueType.cpp',
               'XObjectContentContext.cpp',
            ]), **config)
    ]
)

