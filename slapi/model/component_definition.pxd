# -*- coding: utf-8 -*-
from libcpp cimport bool
from slapi.model.defs cimport *
from slapi.unicodestring cimport *
from slapi.geometry cimport *

from libc.time cimport tm


cdef extern from "SketchUpAPI/model/component_definition.h":
    cdef enum SUSnapToBehavior:
            SUSnapToBehavior_None = 0,
            SUSnapToBehavior_Any,
            SUSnapToBehavior_Horizontal,
            SUSnapToBehavior_Vertical,
            SUSnapToBehavior_Sloped

    cdef struct SUComponentBehavior:
        SUSnapToBehavior component_snap
        bool component_cuts_opening
        bool component_always_face_camera
        bool component_shadows_face_sun
        size_t component_no_scale_mask

    cdef enum SUComponentType:
        SUComponentType_Normal, # Regular component definition
        SUComponentType_Group   # Group definition

    SUEntityRef SUComponentDefinitionToEntity(SUComponentDefinitionRef comp_def)
    SUComponentDefinitionRef SUComponentDefinitionFromEntity(SUEntityRef entity)
    SUDrawingElementRef SUComponentDefinitionToDrawingElement(SUComponentDefinitionRef comp_def)
    SUComponentDefinitionRef SUComponentDefinitionFromDrawingElement(SUDrawingElementRef drawing_elem)
    SU_RESULT SUComponentDefinitionCreate(SUComponentDefinitionRef* comp_def)
    SU_RESULT SUComponentDefinitionRelease(SUComponentDefinitionRef* comp_def)
    SU_RESULT SUComponentDefinitionGetName(SUComponentDefinitionRef comp_def, SUStringRef* name)
    SU_RESULT SUComponentDefinitionSetName(SUComponentDefinitionRef comp_def, const char* name)
    SU_RESULT SUComponentDefinitionGetGuid(SUComponentDefinitionRef comp_def, SUStringRef* guid_ref)
    SU_RESULT SUComponentDefinitionGetEntities(SUComponentDefinitionRef comp_def, SUEntitiesRef* entities)
    SU_RESULT SUComponentDefinitionGetDescription(SUComponentDefinitionRef comp_def, SUStringRef* desc)
    SU_RESULT SUComponentDefinitionSetDescription(SUComponentDefinitionRef comp_def, const char* desc)
    SU_RESULT SUComponentDefinitionCreateInstance(SUComponentDefinitionRef comp_def, SUComponentInstanceRef* instance)
    SU_RESULT SUComponentDefinitionGetNumUsedInstances(SUComponentDefinitionRef comp_def, size_t* count) # API 5.0
    SU_RESULT SUComponentDefinitionGetNumInstances(SUComponentDefinitionRef comp_def, size_t* count) # API 5.0
    SU_RESULT SUComponentDefinitionGetInstances(SUComponentDefinitionRef comp_def, size_t len, SUComponentInstanceRef instances[], size_t* count) # API 5.0
    SU_RESULT SUComponentDefinitionGetBehavior(SUComponentDefinitionRef comp_def, SUComponentBehavior* behavior)
    SU_RESULT SUComponentDefinitionSetBehavior(SUComponentDefinitionRef comp_def, const SUComponentBehavior* behavior)
    SU_RESULT SUComponentDefinitionApplySchemaType(SUComponentDefinitionRef comp_def,SUSchemaRef schema_ref, SUSchemaTypeRef schema_type_ref)
    SU_RESULT SUComponentDefinitionIsInternal(SUComponentDefinitionRef comp_def, bool* is_internal) # API 4.0
    SU_RESULT SUComponentDefinitionGetPath(SUComponentDefinitionRef comp_def, SUStringRef* path) # API 4.0
    SU_RESULT SUComponentDefinitionGetLoadTime(SUComponentDefinitionRef comp_def, tm* load_time) # API 4.0
    SU_RESULT SUComponentDefinitionGetNumOpenings(SUComponentDefinitionRef comp_def, size_t* count) # API 4.0
    SU_RESULT SUComponentDefinitionGetOpenings(SUComponentDefinitionRef comp_def, size_t len, SUOpeningRef openings[], size_t* count) # API 4.0
    SU_RESULT SUComponentDefinitionGetInsertPoint(SUComponentDefinitionRef comp_def, SUPoint3D* point) # API 4.0
    SU_RESULT SUComponentDefinitionGetType(SUComponentDefinitionRef comp_def, SUComponentType* type) # API 4.0
    SU_RESULT SUComponentDefinitionOrientFacesConsistently(SUComponentDefinitionRef comp_def) # API 4.0
    SU_RESULT SUComponentDefinitionSetInsertPoint(SUComponentDefinitionRef comp_def, SUPoint3D* point) # API 4.0
    SU_RESULT SUComponentDefinitionSetAxes(SUComponentDefinitionRef comp_def, SUAxesRef axes) # API 4.0


