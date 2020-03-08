# -*- coding: utf-8 -*-
from libcpp cimport bool
from slapi.model.defs cimport *
from slapi.geometry cimport *
from slapi.transformation cimport SUTransformation
from slapi.unicodestring cimport *
from slapi.model.geometry_input cimport *

cdef extern from "SketchUpAPI/model/face.h":
    SUEntityRef SUFaceToEntity(SUFaceRef face)
    SUFaceRef SUFaceFromEntity(SUEntityRef entity)
    SUDrawingElementRef SUFaceToDrawingElement(SUFaceRef face)
    SUFaceRef SUFaceFromDrawingElement(SUDrawingElementRef drawing_elem)
    SU_RESULT SUFaceCreate(SUFaceRef* face,const SUPoint3D vertices3d[], SULoopInputRef* outer_loop)
    SU_RESULT SUFaceCreateSimple(SUFaceRef* face, const  SUPoint3D vertices3d[], size_t len)
    SU_RESULT SUFaceGetNormal(SUFaceRef face, SUVector3D* normal)
    SU_RESULT SUFaceRelease(SUFaceRef* face)
    SU_RESULT SUFaceGetNumEdges(SUFaceRef face, size_t* count)
    SU_RESULT SUFaceGetEdges(SUFaceRef face, size_t len, SUEdgeRef edges[],  size_t* count)
    SU_RESULT SUFaceGetPlane(SUFaceRef face, SUPlane3D* plane)
    SU_RESULT SUFaceGetNumVertices(SUFaceRef face, size_t* count)
    SU_RESULT SUFaceGetVertices(SUFaceRef face, size_t len, SUVertexRef vertices[], size_t* count)
    SU_RESULT SUFaceGetOuterLoop(SUFaceRef face, SULoopRef* loop)
    SU_RESULT SUFaceGetNumInnerLoops(SUFaceRef face, size_t* count)
    SU_RESULT SUFaceGetInnerLoops(SUFaceRef face, size_t len, SULoopRef loops[], size_t* count)
    SU_RESULT SUFaceAddInnerLoop(SUFaceRef face, const SUPoint3D vertices3d[], SULoopInputRef* loop)
    SU_RESULT SUFaceGetNumOpenings(SUFaceRef face, size_t* count)
    SU_RESULT SUFaceGetOpenings(SUFaceRef face, size_t len, SUOpeningRef openings[], size_t* count)
    SU_RESULT SUFaceGetFrontMaterial(SUFaceRef face, SUMaterialRef* material)
    SU_RESULT SUFaceSetFrontMaterial(SUFaceRef face, SUMaterialRef material)
    SU_RESULT SUFaceGetBackMaterial(SUFaceRef face, SUMaterialRef* material)
    SU_RESULT SUFaceSetBackMaterial(SUFaceRef face, SUMaterialRef material)
    SU_RESULT SUFaceIsFrontMaterialAffine(SUFaceRef face, bool* is_affine)
    SU_RESULT SUFaceIsBackMaterialAffine(SUFaceRef face, bool* is_affine)
    SU_RESULT SUFaceGetArea(SUFaceRef face, double* area)
    SU_RESULT SUFaceGetAreaWithTransform(SUFaceRef face, const SUTransformation* transform, double *area) # API 4.0
    SU_RESULT SUFaceIsComplex(SUFaceRef face, bool* is_complex)
    SU_RESULT SUFaceGetUVHelper(SUFaceRef face, bool front, bool back, SUTextureWriterRef texture_writer,  SUUVHelperRef* uv_helper)
    SU_RESULT SUFaceGetUVHelperWithTextureHandle(SUFaceRef face,  bool front, bool back, SUTextureWriterRef texture_writer, long textureHandle,  SUUVHelperRef* uv_helper)
    SU_RESULT SUFaceGetNumAttachedDrawingElements(SUFaceRef face, size_t* count) # API 4.0
    SU_RESULT SUFaceGetAttachedDrawingElements(SUFaceRef face, size_t len, SUDrawingElementRef elems[], size_t* count) # API 4.0
    SU_RESULT SUFaceReverse(SUFaceRef face)
