# -*- coding: utf-8 -*-
from libcpp cimport bool

cdef extern from "SketchUpAPI/utils/math_helprs.h":
    double DegreesToRadians(double value)
    double RadiansToDegrees(double value)
    bool Equals(double val1, double val2)
    bool LessThan(double val1, double val2)
    bool LessThanOrEqual(double val1, double val2)
    bool GreaterThan(double val1, double val2)
    bool GreaterThanOrEqual(double val1, double val2)