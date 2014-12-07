# -*- coding: utf-8 -*-

cdef extern from "slapi/initialize.h":
    void SUInitialize()
    void SUTerminate()
    void SUGetAPIVersion(size_t* major, size_t* minor)