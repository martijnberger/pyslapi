# -*- coding: utf-8 -*-
from slapi.model.defs cimport *

cdef extern from "SketchUpAPI/color.h":
    ctypedef struct SUColor:
        SUByte red,
        SUByte green,
        SUByte blue,
        SUByte alpha