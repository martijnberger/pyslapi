# -*- coding: utf-8 -*-
from libcpp cimport bool
from slapi.model.defs cimport *
from slapi.unicodestring cimport *
from slapi.color cimport *

cdef extern from "SketchUpAPI/model/material.h":
    cdef enum SUMaterialType:
        SUMaterialType_Colored = 0, # Colored material
        SUMaterialType_Textured,    # Textured material
        SUMaterialType_ColorizedTexture #Colored and textured material

    SUEntityRef SUMaterialToEntity(SUMaterialRef material)
    SUMaterialRef SUMaterialFromEntity(SUEntityRef entity)
    SU_RESULT SUMaterialCreate(SUMaterialRef* material)
    SU_RESULT SUMaterialRelease(SUMaterialRef* material)
    SU_RESULT SUMaterialSetName(SUMaterialRef material, const char* name)
    SU_RESULT SUMaterialGetName(SUMaterialRef material, SUStringRef* name)
    SU_RESULT SUMaterialGetNameLegacyBehavior(SUMaterialRef material, SUStringRef* name) # API 5.0
    SU_RESULT SUMaterialSetColor(SUMaterialRef material, const SUColor* color)
    SU_RESULT SUMaterialGetColor(SUMaterialRef material, SUColor* color)
    SU_RESULT SUMaterialSetTexture(SUMaterialRef material, SUTextureRef texture)
    SU_RESULT SUMaterialGetTexture(SUMaterialRef material,  SUTextureRef* texture)
    SU_RESULT SUMaterialGetOpacity(SUMaterialRef material, double* alpha)
    SU_RESULT SUMaterialSetOpacity(SUMaterialRef material, double alpha)
    SU_RESULT SUMaterialGetUseOpacity(SUMaterialRef material, bool* use_opacity)
    SU_RESULT SUMaterialSetUseOpacity(SUMaterialRef material, bool use_opacity)
    SU_RESULT SUMaterialSetType(SUMaterialRef material, SUMaterialType type)
    SU_RESULT SUMaterialGetType(SUMaterialRef material, SUMaterialType* type)