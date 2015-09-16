# -*- coding: utf-8 -*-

cdef extern from "SketchUpAPI/initialize.h":
    void SUInitialize()
    void SUTerminate()
    void SUGetAPIVersion(size_t* major, size_t* minor)