# -*- coding: utf-8 -*-
from libcpp cimport bool
from slapi.model.defs cimport *
from slapi.geometry cimport *

cdef extern from "SketchUpAPI/model/geometry_input.h":
    ctypedef struct SULoopInputRef:
        void *ptr

    ctypedef struct SUMaterialInput:
        size_t num_uv_coords
        SUPoint2D uv_coords[4]
        size_t vertex_indices[4]
        SUMaterialRef material

    SU_RESULT SUGeometryInputCreate(SUGeometryInputRef* geom_input)
    SU_RESULT SUGeometryInputRelease(SUGeometryInputRef* geom_input)
    SU_RESULT SUGeometryInputAddVertex(SUGeometryInputRef geom_input, const SUPoint3D* point)
    SU_RESULT SUGeometryInputSetVertices(SUGeometryInputRef geom_input, size_t num_vertices, const SUPoint3D points[])
    SU_RESULT SULoopInputCreate(SULoopInputRef* loop_input)
    SU_RESULT SULoopInputRelease(SULoopInputRef* loop_input)
    SU_RESULT SULoopInputAddVertexIndex(SULoopInputRef loop_input, size_t vertex_index)
    SU_RESULT SULoopInputEdgeSetHidden(SULoopInputRef loop_input, size_t edge_index, bool hidden)
    SU_RESULT SULoopInputEdgeSetSoft(SULoopInputRef loop_input, size_t edge_index, bool soft)
    SU_RESULT SULoopInputEdgeSetSmooth(SULoopInputRef loop_input, size_t edge_index, bool smooth)
    SU_RESULT SULoopInputAddCurve(SULoopInputRef loop_input, size_t first_edge_index, size_t last_edge_index)
    SU_RESULT SUGeometryInputAddFace(SUGeometryInputRef geom_input, SULoopInputRef* outer_loop, size_t* added_face_index)
    SU_RESULT SUGeometryInputFaceSetReverse(SUGeometryInputRef geom_input, size_t face_index, bool reverse)
    SU_RESULT SUGeometryInputFaceSetLayer(SUGeometryInputRef geom_input, size_t face_index, SULayerRef layer)
    SU_RESULT SUGeometryInputFaceAddInnerLoop(SUGeometryInputRef geom_input, size_t face_index, SULoopInputRef* loop_input)
    SU_RESULT SUGeometryInputFaceSetFrontMaterial(SUGeometryInputRef geom_input, size_t face_index, const SUMaterialInput* material_input)
    SU_RESULT SUGeometryInputFaceSetBackMaterial(SUGeometryInputRef geom_input, size_t face_index, const SUMaterialInput* material_input)
