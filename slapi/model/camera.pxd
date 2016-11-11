# -*- coding: utf-8 -*-
from libcpp cimport bool
from slapi.model.defs cimport *
from slapi.geometry cimport *
from slapi.transformation cimport *
from slapi.unicodestring cimport *

cdef extern from "SketchUpAPI/model/camera.h":

    SU_RESULT SUCameraCreate(SUCameraRef* camera)
    SU_RESULT SUCameraRelease(SUCameraRef* camera)
    SU_RESULT SUCameraGetOrientation(SUCameraRef camera, SUPoint3D* position, SUPoint3D* target, SUVector3D* up_vector)
    SU_RESULT SUCameraSetOrientation(SUCameraRef camera, const SUPoint3D* position, const SUPoint3D* target, const SUVector3D* up_vector)
    SU_RESULT SUCameraSetPerspectiveFrustumFOV(SUCameraRef camera, double fov)
    SU_RESULT SUCameraGetPerspectiveFrustumFOV(SUCameraRef camera, double* fov)
    SU_RESULT SUCameraGetAspectRatio(SUCameraRef camera, double* aspect_ratio)
    SU_RESULT SUCameraSetOrthographicFrustumHeight(SUCameraRef camera, double height)
    SU_RESULT SUCameraGetOrthographicFrustumHeight(SUCameraRef camera, double* height)
    SU_RESULT SUCameraSetPerspective(SUCameraRef camera, bool perspective)
    SU_RESULT SUCameraGetPerspective(SUCameraRef camera, bool* perspective)

    #since SketchUp 2017, API 5.0
    SU_RESULT SUCameraGetViewTransformation(SUCameraRef camera, SUTransformation* transformation)
    SU_RESULT SUCameraSetAspectRatio(SUCameraRef camera, double aspect_ratio)
    SU_RESULT SUCameraSetAspectRatio(SUCameraRef camera, double aspect_ratio)
    SU_RESULT SUCameraGetClippingDistances(SUCameraRef camera, double* znear, double* zfar)
    SU_RESULT SUCameraSetFOVIsHeight(SUCameraRef camera, bool is_fov_height)
    SU_RESULT SUCameraGetFOVIsHeight(SUCameraRef camera, bool* is_fov_height)
    SU_RESULT SUCameraSetImageWidth(SUCameraRef camera, double width)
    SU_RESULT SUCameraGetImageWidth(SUCameraRef camera, double* width)
    SU_RESULT SUCameraSetDescription(SUCameraRef camera, const char* desc)
    SU_RESULT SUCameraGetDescription(SUCameraRef camera, SUStringRef* desc)
    SU_RESULT SUCameraGetDirection(SUCameraRef camera, SUVector3D* direction)
    SU_RESULT SUCameraSet2D(SUCameraRef camera, bool make_2d)
    SU_RESULT SUCameraGet2D(SUCameraRef camera, bool* is_2d)
    SU_RESULT SUCameraSetScale2D(SUCameraRef camera, double scale)
    SU_RESULT SUCameraGetScale2D(SUCameraRef camera, double* scale)
    SU_RESULT SUCameraSetCenter2D(SUCameraRef camera, const SUPoint3D* center)
    SU_RESULT SUCameraGetCenter2D(SUCameraRef camera, SUPoint3D* center)
