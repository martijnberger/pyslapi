# -*- coding: utf-8 -*-
from libcpp cimport bool
from slapi.model.defs cimport *
from slapi.unicodestring cimport *
from slapi.geometry cimport *

cdef extern from "SketchUpAPI/model/entities.h":
    SU_RESULT SUEntitiesFill(SUEntitiesRef entities, SUGeometryInputRef geom_input, bool weld_vertices)
    SU_RESULT SUEntitiesGetBoundingBox(SUEntitiesRef entities, SUBoundingBox3D* bbox)
    SU_RESULT SUEntitiesGetNumFaces(SUEntitiesRef entities, size_t* count)
    SU_RESULT SUEntitiesGetFaces(SUEntitiesRef entities, size_t len,  SUFaceRef faces[], size_t*  count)
    SU_RESULT SUEntitiesGetNumCurves(SUEntitiesRef entities, size_t* count)
    SU_RESULT SUEntitiesGetCurves(SUEntitiesRef entities, size_t len, SUCurveRef curves[], size_t* count)
    SU_RESULT SUEntitiesGetNumGuidePoints(SUEntitiesRef entities, size_t* count)
    SU_RESULT SUEntitiesGetGuidePoints(SUEntitiesRef entities, size_t len, SUGuidePointRef guide_points[], size_t* count)
    SU_RESULT SUEntitiesGetNumEdges(SUEntitiesRef entities,  bool standalone_only, size_t* count)
    SU_RESULT SUEntitiesGetEdges(SUEntitiesRef entities, bool standalone_only, size_t len, SUEdgeRef edges[], size_t* count)
    SU_RESULT SUEntitiesGetNumPolyline3ds(SUEntitiesRef entities, size_t* count)
    SU_RESULT SUEntitiesGetPolyline3ds(SUEntitiesRef entities, size_t len, SUPolyline3dRef lines[], size_t* count)
    SU_RESULT SUEntitiesAddFaces(SUEntitiesRef entities, size_t len, const SUFaceRef faces[])
    SU_RESULT SUEntitiesAddCurves(SUEntitiesRef entities, size_t len, const SUCurveRef curves[])
    SU_RESULT SUEntitiesAddGuidePoints(SUEntitiesRef entities, size_t len, const SUGuidePointRef guide_points[])
    SU_RESULT SUEntitiesAddGroup(SUEntitiesRef entities, SUGroupRef group)
    SU_RESULT SUEntitiesAddImage(SUEntitiesRef entities, SUImageRef image)
    SU_RESULT SUEntitiesAddInstance(SUEntitiesRef entities, SUComponentInstanceRef instance, SUStringRef* name)
    SU_RESULT SUEntitiesGetNumGroups(SUEntitiesRef entities, size_t* count)
    SU_RESULT SUEntitiesGetGroups(SUEntitiesRef entities, size_t len, SUGroupRef groups[], size_t* count)
    SU_RESULT SUEntitiesGetNumImages(SUEntitiesRef entities, size_t* count)
    SU_RESULT SUEntitiesGetImages(SUEntitiesRef entities,  size_t len, SUImageRef images[], size_t* count)
    SU_RESULT SUEntitiesGetNumInstances(SUEntitiesRef entities, size_t* count)
    SU_RESULT SUEntitiesGetInstances(SUEntitiesRef entities, size_t len, SUComponentInstanceRef instances[], size_t* count)