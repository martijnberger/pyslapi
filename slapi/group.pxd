# -*- coding: utf-8 -*-
from .defs cimport *
from .unicodestring cimport *
from .geometry cimport *

cdef extern from "slapi/model/group.h":
    SUEntityRef SUGroupToEntity(SUGroupRef group)
    SUGroupRef SUGroupFromEntity(SUEntityRef entity)
    SUDrawingElementRef SUGroupToDrawingElement(SUGroupRef group)
    SUGroupRef SUGroupFromDrawingElement(SUDrawingElementRef drawing_elem)
    SU_RESULT SUGroupCreate(SUGroupRef* group)
    SU_RESULT SUGroupSetName(SUGroupRef group, const char* name)
    SU_RESULT SUGroupGetName(SUGroupRef group, SUStringRef* name)
    SU_RESULT SUGroupGetGuid(SUGroupRef group, SUStringRef* guid)
    SU_RESULT SUGroupSetGuid(SUGroupRef group, const char* guid_str)
    SU_RESULT SUGroupSetTransform(SUGroupRef group, const SUTransformation* transform)
    SU_RESULT SUGroupGetTransform(SUGroupRef group,  SUTransformation* transform)
    SU_RESULT SUGroupGetEntities(SUGroupRef group, SUEntitiesRef* entities)
    SU_RESULT SUGroupGetDefinition(SUGroupRef group, SUComponentDefinitionRef* component)




