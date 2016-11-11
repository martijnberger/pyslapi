# -*- coding: utf-8 -*-
ctypedef unsigned char SUByte

cdef extern from "SketchUpAPI/color.h":
    ctypedef struct SUColor:
        SUByte red,
        SUByte green,
        SUByte blue,
        SUByte alpha