# -*- coding: utf-8 -*-
from libcpp cimport bool
from .defs cimport *
from .geometry cimport *

cdef extern from "SketchUpAPI/model/camera.h":

    SU_RESULT SUCameraCreate(SUCameraRef* camera)
    SU_RESULT SUCameraRelease(SUCameraRef* camera)
    SU_RESULT SUCameraGetOrientation(SUCameraRef camera, SUPoint3D* position, SUPoint3D* target, SUVector3D* up_vector)
    SU_RESULT SUCameraSetOrientation(SUCameraRef camera, const SUPoint3D* position, const SUPoint3D* target, const SUVector3D* up_vector)
    SU_RESULT SUCameraSetPerspectiveFrustumFOV(SUCameraRef camera, double fov)
    SU_RESULT SUCameraGetPerspectiveFrustumFOV(SUCameraRef camera, double* fov)
    SU_RESULT SUCameraGetAspectRatio(SUCameraRef camera, double* aspect_ratio)
    #SU_RESULT SUCameraSetAspectRatio(SUCameraRef camera, double aspect_ratio) Does not exist in SU 2015 SDK ?
    SU_RESULT SUCameraSetOrthographicFrustumHeight(SUCameraRef camera, double height)
    SU_RESULT SUCameraGetOrthographicFrustumHeight(SUCameraRef camera, double* height)
    SU_RESULT SUCameraSetPerspective(SUCameraRef camera, bool perspective)
    SU_RESULT SUCameraGetPerspective(SUCameraRef camera, bool* perspective)