# -*- coding: utf-8 -*-
from libcpp cimport bool
from slapi.model.defs cimport *
from slapi.unicodestring cimport *

cdef extern from "SketchUpAPI/model/layer.h":
    SUEntityRef SULayerToEntity(SULayerRef layer)
    SULayerRef SULayerFromEntity(SUEntityRef entity)
    SU_RESULT SULayerCreate(SULayerRef* layer)
    SU_RESULT SULayerRelease(SULayerRef* layer)
    SU_RESULT SULayerGetName(SULayerRef layer, SUStringRef* name)
    SU_RESULT SULayerSetName(SULayerRef layer, const char* name)
    SU_RESULT SULayerGetMaterial(SULayerRef layer, SUMaterialRef* material)
    SU_RESULT SULayerGetVisibility(SULayerRef layer, bool* visible)
    SU_RESULT SULayerSetVisibility(SULayerRef layer, bool visible)