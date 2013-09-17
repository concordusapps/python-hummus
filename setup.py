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


def find(directory, patterns):
    result = []
    for node, _, filenames in os.walk(directory):
        for filename in filenames:
            for pattern in patterns:
                if fnmatch(filename, pattern):
                    result.append(join(node, filename))

    return result


class lazy(object):

    def __init__(self, function):
        self._function = function
        self._args = [], {}
        self._result = None

    def __len__(self):
        return self.__len__()

    def __iter__(self):
        return self.__iter__()

    def __getattribute__(self, name):
        if not name.startswith('__') and name.startswith('_'):
            return super(lazy, self).__getattribute__(name)

        if self._result is None:
            self._result = self._function(*self._args[0], **self._args[1])

        return getattr(self._result, name)

    def __call__(self, *args, **kwargs):
        self._args = args, kwargs
        return self


# Navigate, import, and retrieve the metadata of the project.
meta = get_importer('src/hummus').find_module('meta').load_module('meta')


def make_config():
    from pkgconfig import parse

    # Process the `pkg-config` utility and discover include and library
    # directories.
    config = {}
    for lib in ['zlib', 'libtiff-4', 'freetype2']:
        config.update(parse(lib))

    # Add libjpeg (no .pc file).
    config['libraries'].add('jpeg')

    # List-ify config for setuptools.
    for key in config:
        config[key] = list(config[key])

    # Add hummus.
    config['include_dirs'].insert(0, 'lib/hummus/PDFWriter')
    config['include_dirs'].insert(0, 'lib/python')

    # Add local library.
    config['include_dirs'].insert(0, 'src')

    # Return built config.
    return config


@lazy
def make_extension(name, sources=None, cython=True):
    # Resolve extension location from name.
    location = join('src', *name.split('.'))
    location += '.pyx' if cython else '.cpp'

    # Create and return the extension.
    return Extension(
        name=name,
        sources=sources + [location] if sources else [location],
        language='c++',
        **make_config())


@lazy
def make_library(name, directory):
    patterns = ['*.cxx', '*.cpp']
    return [name, dict(sources=find(directory, patterns), **make_config())]


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
    setup_requires=[
        'setuptools_cython',
        'pkgconfig'
    ],
    install_requires=[
    ],
    extras_require={
        'test': ['pytest'],
    },
    libraries=[
        make_library('hummus', 'lib/hummus/PDFWriter'),
    ],
    ext_modules=[
        make_extension('hummus.document'),
        make_extension('hummus.rectangle'),
        make_extension('hummus.page'),
        make_extension('hummus.context'),
        make_extension(
            name='hummus.interface',
            sources=find('lib/python/interface', ['*.cxx'])),
    ]
)
