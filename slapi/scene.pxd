# -*- coding: utf-8 -*-
from libcpp cimport bool
from .defs cimport *
from .unicodestring cimport *

cdef extern from "slapi/model/scene.h":
    SUEntityRef SUSceneToEntity(SUSceneRef scene)
    SUSceneRef SUSceneFromEntity(SUEntityRef entity)
    SU_RESULT SUSceneCreate(SUSceneRef* scene)
    SU_RESULT SUSceneRelease(SUSceneRef* scene)
    SU_RESULT SUSceneGetUseCamera(SUSceneRef scene, bool* use_camera)
    SU_RESULT SUSceneGetCamera(SUSceneRef scene, SUCameraRef* camera)
    SU_RESULT SUSceneGetName(SUSceneRef scene, SUStringRef* name)
    SU_RESULT SUSceneSetName(SUSceneRef scene, const char* scene_name)
    SU_RESULT SUSceneGetRenderingOptions(SUSceneRef scene, SURenderingOptionsRef* options)
    SU_RESULT SUSceneGetShadowInfo(SUSceneRef scene, SUShadowInfoRef* shadow_info)
    SU_RESULT SUSceneGetUseShadowInfo(SUSceneRef scene, bool* use_shadow_info)
    SU_RESULT SUSceneSetUseShadowInfo(SUSceneRef scene, bool use_shadow_info)