# -*- coding: utf-8 -*-
from libcpp cimport bool
from .defs cimport *
from .unicodestring cimport *
from .geometry cimport *

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
    SU_RESULT SUComponentDefinitionGetBehavior(SUComponentDefinitionRef comp_def, SUComponentBehavior* behavior)
    SU_RESULT SUComponentDefinitionSetBehavior(SUComponentDefinitionRef comp_def, const SUComponentBehavior* behavior)
    SU_RESULT SUComponentDefinitionApplySchemaType(SUComponentDefinitionRef comp_def,SUSchemaRef schema_ref, SUSchemaTypeRef schema_type_ref)


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