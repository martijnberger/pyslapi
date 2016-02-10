# -*- coding: utf-8 -*-
from libcpp cimport bool
from slapi.model.defs cimport *
from slapi.geometry cimport *

cdef extern from "SketchUpAPI/model/drawing_element.h":
    SUEntityRef SUDrawingElementToEntity(SUDrawingElementRef elem)
    SUDrawingElementRef SUDrawingElementFromEntity(SUEntityRef entity)
    SURefType SUDrawingElementGetType(SUDrawingElementRef elem)
    SU_RESULT SUDrawingElementGetBoundingBox(SUDrawingElementRef elem, SUBoundingBox3D* bbox)
    SU_RESULT SUDrawingElementGetMaterial(SUDrawingElementRef elem, SUMaterialRef* material)
    SU_RESULT SUDrawingElementSetMaterial(SUDrawingElementRef elem, SUMaterialRef material)
    SU_RESULT SUDrawingElementGetLayer(SUDrawingElementRef elem, SULayerRef* layer)
    SU_RESULT SUDrawingElementSetLayer(SUDrawingElementRef elem, SULayerRef layer)
    SU_RESULT SUDrawingElementSetHidden(SUDrawingElementRef elem, bool hide_flag)
    SU_RESULT SUDrawingElementGetHidden(SUDrawingElementRef elem, bool* hide_flag)
    SU_RESULT SUDrawingElementSetCastsShadows(SUDrawingElementRef elem, bool casts_shadows_flag)
    SU_RESULT SUDrawingElementGetCastsShadows(SUDrawingElementRef elem, bool* casts_shadows_flag)
    SU_RESULT SUDrawingElementSetReceivesShadows(SUDrawingElementRef elem, bool receives_shadows_flag)
    SU_RESULT SUDrawingElementGetReceivesShadows(SUDrawingElementRef elem, bool* receives_shadows_flag)