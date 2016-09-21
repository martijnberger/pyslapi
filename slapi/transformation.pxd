# -*- coding: utf-8 -*-

cdef extern from "SketchUpAPI/transformation.h":
    struct SUTransformation:
        double values[16] #; ///< Matrix values in column-major order.