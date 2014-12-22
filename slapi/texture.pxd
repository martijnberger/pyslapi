# -*- coding: utf-8 -*-
from libcpp cimport bool
from .defs cimport *
from .unicodestring cimport *
from .geometry cimport *

cdef extern from "slapi/model/texture.h":
    SUEntityRef SUTextureToEntity(SUTextureRef texture)
    SUTextureRef SUTextureFromEntity(SUEntityRef entity)
    SU_RESULT SUTextureCreateFromImageData(SUTextureRef* texture, size_t width, size_t height, size_t bits_per_pixel, SUByte pixel_data[])
    SU_RESULT SUTextureCreateFromFile(SUTextureRef* texture, const char* file_path, double s_scale, double t_scale)
    SU_RESULT SUTextureRelease(SUTextureRef* texture)
    SU_RESULT SUTextureGetDimensions(SUTextureRef texture, size_t* width, size_t* height, double* s_scale, double* t_scale)
    SU_RESULT SUTextureGetImageDataSize(SUTextureRef texture,  size_t* data_size, size_t* bits_per_pixel)
    SU_RESULT SUTextureGetImageData(SUTextureRef texture, size_t data_size, SUByte pixel_data[])
    SU_RESULT SUTextureWriteToFile(SUTextureRef texture, const char* file_path)
    SU_RESULT SUTextureGetFileName(SUTextureRef texture,  SUStringRef* file_name)
    SU_RESULT SUTextureGetUseAlphaChannel(SUTextureRef texture, bool* alpha_channel_used)

cdef extern from "slapi/model/texture_writer.h":
    SU_RESULT SUTextureWriterCreate(SUTextureWriterRef* writer)
    SU_RESULT SUTextureWriterRelease(SUTextureWriterRef* writer)
    SU_RESULT SUTextureWriterLoadEntity(SUTextureWriterRef writer, SUEntityRef entity, long* texture_id)
    SU_RESULT SUTextureWriterLoadFace(SUTextureWriterRef writer, SUFaceRef face, long* front_texture_id, long* back_texture_id)
    SU_RESULT SUTextureWriterGetNumTextures(SUTextureWriterRef writer, size_t* count)
    SU_RESULT SUTextureWriterWriteTexture(SUTextureWriterRef writer, long texture_id, const char* path, bool reduce_size)
    SU_RESULT SUTextureWriterWriteAllTextures(SUTextureWriterRef writer, const char* directory)
    SU_RESULT SUTextureWriterIsTextureAffine(SUTextureWriterRef writer, long texture_id, bool* is_affine)
    SU_RESULT SUTextureWriterGetTextureFilePath(SUTextureWriterRef writer, long texture_id, SUStringRef* file_path)
    SU_RESULT SUTextureWriterGetFrontFaceUVCoords(SUTextureWriterRef writer, SUFaceRef face, size_t len, const SUPoint3D points[], SUPoint2D uv_coords[])
    SU_RESULT SUTextureWriterGetBackFaceUVCoords(SUTextureWriterRef writer, SUFaceRef face, size_t len, const SUPoint3D points[], SUPoint2D uv_coords[])
    SU_RESULT SUTextureWriterGetTextureIdForEntity(SUTextureWriterRef writer, SUEntityRef entity, long* texture_id)
    SU_RESULT SUTextureWriterGetTextureIdForFace(SUTextureWriterRef writer, SUFaceRef face, bool front, long* texture_id)
