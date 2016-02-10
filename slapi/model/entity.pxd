# -*- coding: utf-8 -*-
from libc.stdint cimport int32_t
from slapi.model.defs cimport *

cdef extern from "SketchUpAPI/model/entity.h":
    SURefType SUEntityGetType(SUEntityRef entity)
    SU_RESULT SUEntityGetID(SUEntityRef entity, int32_t* entity_id)
    SU_RESULT SUEntityGetNumAttributeDictionaries(SUEntityRef entity, size_t* count)
    SU_RESULT SUEntityGetAttributeDictionaries(SUEntityRef entity, size_t len, SUAttributeDictionaryRef dictionaries[], size_t* count)
    SU_RESULT SUEntityGetAttributeDictionary(SUEntityRef entity, const char* name, SUAttributeDictionaryRef* dictionary)