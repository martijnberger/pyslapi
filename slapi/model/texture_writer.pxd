# -*- coding: utf-8 -*-
from libcpp cimport bool
from slapi.model.defs cimport *
from slapi.unicodestring cimport *
from slapi.geometry cimport *

cdef extern from "SketchUpAPI/model/texture_writer.h":
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
