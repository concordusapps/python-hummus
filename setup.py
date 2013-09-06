#! /usr/bin/env python
# -*- coding: utf-8 -*-
from setuptools import setup, find_packages, Extension
from pkgutil import get_importer
from collections import defaultdict
import subprocess
from fnmatch import fnmatch
from os.path import join
from functools import partial
# from distut.command import build_clib
from Cython.Build import cythonize
from Cython.Distutils import build_ext
import sys
import os


def prefix(prefix, filenames):
    return list(map(partial(join, prefix), filenames))


def find(directory, patterns):
    result = []
    for node, _, filenames in os.walk(directory):
        for filename in filenames:
            for pattern in patterns:
                if fnmatch(filename, pattern):
                    result.append(join(node, filename))

    return result


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
config['include_dirs'].insert(0, 'lib/python')

# Add local library.
config['include_dirs'].insert(0, 'src')

# Discover additional c++ sources for hummus.
sources = find('lib/python', ['*.cxx'])


def make_extension(name, sources=None, cython=True):
    # Resolve extension location from name.
    location = join('src', *name.split('.'))
    location += '.pyx' if cython else '.cpp'

    # Create and return the extension.
    return Extension(
        name=name,
        sources=sources + [location] if sources else [location],
        language='c++',
        **config)


def make_library(name, directory):
    patterns = ['*.cxx', '*.cpp']
    return [name, dict(sources=find(directory, patterns), **config)]


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
        'test': ['pytest'],
    },
    cmdclass={'build_ext': build_ext},
    libraries=[
        make_library('hummus', 'lib/hummus/PDFWriter'),
    ],
    ext_modules=[
        make_extension('hummus.document'),
        make_extension(
            name='hummus.interface',
            sources=find('lib/python/interface', ['*.cxx'])),
    ]
)

