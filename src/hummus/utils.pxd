# -*- coding: utf-8 -*-
from libcpp.string cimport string


cdef inline string to_string(value):
    if not value:
        return None

    if isinstance(value, str):
        return <string>value.encode('utf8')

    return <string>value
