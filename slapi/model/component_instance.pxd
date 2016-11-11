# -*- coding: utf-8 -*-
from libcpp cimport bool
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
    SU_RESULT SUComponentInstanceSetLocked(SUComponentInstanceRef instance, bool lock) # API 4.0
    SU_RESULT SUComponentInstanceIsLocked(SUComponentInstanceRef instance, bool* is_locked) # API 4.0
    SU_RESULT SUComponentInstanceSaveAs(SUComponentInstanceRef instance, const char* file_path)
    SU_RESULT SUComponentInstanceComputeVolume(SUComponentInstanceRef instance, const SUTransformation* transform, double* volume) # API 4.0
    SU_RESULT SUComponentInstanceCreateDCInfo(SUComponentInstanceRef instance, SUDynamicComponentInfoRef* dc_info) # API 4.0
    SU_RESULT SUComponentInstanceCreateClassificationInfo(SUComponentInstanceRef instance, SUClassificationInfoRef* classification_info) # API 5.0
    SU_RESULT SUComponentInstanceGetNumAttachedInstances(SUComponentInstanceRef instance, size_t* count)
    SU_RESULT SUComponentInstanceGetAttachedInstances(SUComponentInstanceRef instance, size_t len, SUComponentInstanceRef instances[], size_t* count)