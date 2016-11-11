# -*- coding: utf-8 -*-
from libcpp cimport bool
from slapi.model.defs cimport *
from slapi.unicodestring cimport *
from slapi.geometry cimport *

cdef extern from "SketchUpAPI/model/texture.h":
    SUEntityRef SUTextureToEntity(SUTextureRef texture)
    SUTextureRef SUTextureFromEntity(SUEntityRef entity)
    SU_RESULT SUTextureCreateFromImageRep(SUTextureRef* texture, SUImageRepRef image)   # API 5.0
    SU_RESULT SUTextureCreateFromFile(SUTextureRef* texture, const char* file_path, double s_scale, double t_scale)
    SU_RESULT SUTextureRelease(SUTextureRef* texture)
    SU_RESULT SUTextureGetDimensions(SUTextureRef texture, size_t* width, size_t* height, double* s_scale, double* t_scale)
    SU_RESULT SUTextureGetImageRep(SUTextureRef texture, SUImageRepRef* image) # API 5.0
    SU_RESULT SUTextureWriteToFile(SUTextureRef texture, const char* file_path)
    SU_RESULT SUTextureSetFileName(SUTextureRef texture, const char* name) # API 5.0
    SU_RESULT SUTextureGetFileName(SUTextureRef texture,  SUStringRef* file_name)
    SU_RESULT SUTextureGetUseAlphaChannel(SUTextureRef texture, bool* alpha_channel_used)

    # depecated
    SU_RESULT SUTextureCreateFromImageData(SUTextureRef* texture, size_t width, size_t height, size_t bits_per_pixel, SUByte pixel_data[])
    SU_RESULT SUTextureGetImageDataSize(SUTextureRef texture,  size_t* data_size, size_t* bits_per_pixel)
    SU_RESULT SUTextureGetImageData(SUTextureRef texture, size_t data_size, SUByte pixel_data[])

