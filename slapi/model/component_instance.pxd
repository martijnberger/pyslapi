# -*- coding: utf-8 -*-
from slapi.model.defs cimport *
from slapi.unicodestring cimport *
from slapi.geometry cimport *
from slapi.transformation cimport SUTransformation

cdef extern from "SketchUpAPI/model/component_instance.h":
    SUEntityRef SUComponentInstanceToEntity(SUComponentInstanceRef instance)
    SUComponentInstanceRef SUComponentInstanceFromEntity(SUEntityRef entity)
    SUDrawingElementRef SUComponentInstanceToDrawingElement(SUComponentInstanceRef instance)
    SUComponentInstanceRef SUComponentInstanceFromDrawingElement(SUDrawingElementRef drawing_elem)
    SU_RESULT SUComponentInstanceSetName(SUComponentInstanceRef instance,const char* name)
    SU_RESULT SUComponentInstanceRelease(SUComponentInstanceRef* instance)
    SU_RESULT SUComponentInstanceGetName(SUComponentInstanceRef instance, SUStringRef* name)
    SU_RESULT SUComponentInstanceSetGuid(SUComponentInstanceRef instance, const char* guid)
    SU_RESULT SUComponentInstanceGetGuid(SUComponentInstanceRef instance, SUStringRef* guid)
    SU_RESULT SUComponentInstanceSetTransform(SUComponentInstanceRef instance,const SUTransformation* transform)
    SU_RESULT SUComponentInstanceGetTransform(SUComponentInstanceRef instance, SUTransformation* transform);
    SU_RESULT SUComponentInstanceGetDefinition(SUComponentInstanceRef instance, SUComponentDefinitionRef* component)