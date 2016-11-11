# -*- coding: utf-8 -*-
from libcpp cimport bool
from libc.stdint cimport int16_t, int32_t, int64_t
from slapi.color cimport *
from slapi.model.defs cimport *
from slapi.unicodestring cimport *
from slapi.geometry cimport *

cdef extern from "SketchUpAPI/model/typed_value.h":
    cdef enum SUTypedValueType:
        SUTypedValueType_Empty = 0,
        SUTypedValueType_Byte,
        SUTypedValueType_Short,
        SUTypedValueType_Int32,
        SUTypedValueType_Float,
        SUTypedValueType_Double,
        SUTypedValueType_Bool,
        SUTypedValueType_Color,
        SUTypedValueType_Time,
        SUTypedValueType_String,
        SUTypedValueType_Vector3D,
        SUTypedValueType_Array

    SU_RESULT SUTypedValueCreate(SUTypedValueRef* typed_value)
    SU_RESULT SUTypedValueRelease(SUTypedValueRef* typed_value)
    SU_RESULT SUTypedValueGetType(SUTypedValueRef typed_value, SUTypedValueType* type)
    SU_RESULT SUTypedValueGetByte(SUTypedValueRef typed_value, char* byte_value)
    SU_RESULT SUTypedValueSetByte(SUTypedValueRef typed_value, char byte_value)
    SU_RESULT SUTypedValueGetInt16(SUTypedValueRef typed_value, int16_t* int16_value)
    SU_RESULT SUTypedValueSetInt16(SUTypedValueRef typed_value, int16_t int16_value)
    SU_RESULT SUTypedValueGetInt32(SUTypedValueRef typed_value, int32_t* int32_value)
    SU_RESULT SUTypedValueSetInt32(SUTypedValueRef typed_value, int32_t int32_value)
    SU_RESULT SUTypedValueGetFloat(SUTypedValueRef typed_value, float* float_value)
    SU_RESULT SUTypedValueSetFloat(SUTypedValueRef typed_value, float float_value)
    SU_RESULT SUTypedValueGetDouble(SUTypedValueRef typed_value, double* double_value)
    SU_RESULT SUTypedValueSetDouble(SUTypedValueRef typed_value, double double_value)
    SU_RESULT SUTypedValueGetBool(SUTypedValueRef typed_value, bool* bool_value)
    SU_RESULT SUTypedValueSetBool(SUTypedValueRef typed_value, bool bool_value)
    SU_RESULT SUTypedValueGetColor(SUTypedValueRef typed_value, SUColor* color)
    SU_RESULT SUTypedValueSetColor(SUTypedValueRef typed_value, const SUColor* color)
    SU_RESULT SUTypedValueGetTime(SUTypedValueRef typed_value, int64_t* time_value)
    SU_RESULT SUTypedValueSetTime(SUTypedValueRef typed_value, int64_t time_value)
    SU_RESULT SUTypedValueGetString(SUTypedValueRef typed_value, SUStringRef* string_value)
    SU_RESULT SUTypedValueSetString(SUTypedValueRef typed_value, const char* string_value)
    SU_RESULT SUTypedValueGetVector3d(SUTypedValueRef typed_value, double vector3d_value[3])
    SU_RESULT SUTypedValueSetVector3d(SUTypedValueRef typed_value, const double vector3d_value[3])
    SU_RESULT SUTypedValueSetUnitVector3d(SUTypedValueRef typed_value, const double vector3d_value[3])
    SU_RESULT SUTypedValueGetArrayItems(SUTypedValueRef typed_value, size_t len, SUTypedValueRef values[], size_t* count)
    SU_RESULT SUTypedValueSetArrayItems(SUTypedValueRef typed_value, size_t len, SUTypedValueRef values[])
    SU_RESULT SUTypedValueGetNumArrayItems(SUTypedValueRef typed_value, size_t* count)

