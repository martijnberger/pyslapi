# -*- coding: utf-8 -*-
from slapi.model.defs cimport *
from slapi.unicodestring cimport *

cdef extern from "SketchUpAPI/model/rendering_options.h":
    SU_RESULT SURenderingOptionsGetValue(SURenderingOptionsRef rendering_options, const char* key, SUTypedValueRef* value_out)
    SU_RESULT SURenderingOptionsSetValue(SURenderingOptionsRef rendering_options, const char* key, SUTypedValueRef value_in)

    # since SetchUp 2017, API 5.0
    SU_RESULT SURenderingOptionsGetNumKeys(SURenderingOptionsRef rendering_options, size_t* count)
    SU_RESULT SURenderingOptionsGetKeys(SURenderingOptionsRef rendering_options, size_t len, SUStringRef keys[], size_t* count)