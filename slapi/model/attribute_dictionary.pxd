from slapi.model.defs cimport *
from slapi.unicodestring cimport *

cdef extern from "SketchUpAPI/model/attribute_dictionary.h":
    SUEntityRef SUAttributeDictionaryToEntity(SUAttributeDictionaryRef dictionary)
    SUAttributeDictionaryRef SUAttributeDictionaryFromEntity(SUEntityRef entity)
    SU_RESULT SUAttributeDictionaryGetName(SUAttributeDictionaryRef dictionary, SUStringRef* name)
    SU_RESULT SUAttributeDictionarySetValue(SUAttributeDictionaryRef dictionary, const char* key, SUTypedValueRef value_in)
    SU_RESULT SUAttributeDictionaryGetValue(SUAttributeDictionaryRef dictionary, const char* key, SUTypedValueRef* value_out)
    SU_RESULT SUAttributeDictionaryGetNumKeys (SUAttributeDictionaryRef dictionary, size_t *count)
    SU_RESULT SUAttributeDictionaryGetKeys(SUAttributeDictionaryRef dictionary, size_t len, SUStringRef keys[], size_t* count)