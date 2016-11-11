# -*- coding: utf-8 -*-
from libcpp cimport bool
from libc.stdint cimport uint32_t
from slapi.model.defs cimport *
from slapi.unicodestring cimport *

cdef extern from "SketchUpAPI/model/scene.h":


    SUEntityRef SUSceneToEntity(SUSceneRef scene)
    SUSceneRef SUSceneFromEntity(SUEntityRef entity)
    SU_RESULT SUSceneCreate(SUSceneRef* scene)
    SU_RESULT SUSceneRelease(SUSceneRef* scene)
    SU_RESULT SUSceneGetUseCamera(SUSceneRef scene, bool* use_camera)
    SU_RESULT SUSceneSetUseCamera(SUSceneRef scene, bool use_camera)
    SU_RESULT SUSceneGetCamera(SUSceneRef scene, SUCameraRef* camera)
    SU_RESULT SUSceneSetCamera(SUSceneRef scene, SUCameraRef camera)
    SU_RESULT SUSceneGetName(SUSceneRef scene, SUStringRef* name)
    SU_RESULT SUSceneSetName(SUSceneRef scene, const char* scene_name)
    SU_RESULT SUSceneGetRenderingOptions(SUSceneRef scene, SURenderingOptionsRef* options)
    SU_RESULT SUSceneGetShadowInfo(SUSceneRef scene, SUShadowInfoRef* shadow_info)
    SU_RESULT SUSceneGetUseShadowInfo(SUSceneRef scene, bool* use_shadow_info)
    SU_RESULT SUSceneSetUseShadowInfo(SUSceneRef scene, bool use_shadow_info)
    SU_RESULT SUSceneGetUseRenderingOptions(SUSceneRef scene, bool* use_rendering_options) # API 4.0
    SU_RESULT SUSceneSetUseRenderingOptions(SUSceneRef scene, bool use_rendering_options) # API 4.0
    SU_RESULT SUSceneGetUseHiddenLayers(SUSceneRef scene, bool* use_hidden_layers) # API 4.0
    SU_RESULT SUSceneSetUseHiddenLayers(SUSceneRef scene, bool use_hidden_layers) # API 4.0
    SU_RESULT SUSceneGetNumLayers(SUSceneRef scene, size_t *count) # API 4.0
    SU_RESULT SUSceneGetLayers(SUSceneRef scene, size_t len, SULayerRef layers[], size_t*  count) # API 4.0
    SU_RESULT SUSceneAddLayer(SUSceneRef scene, SULayerRef layer) # API 4.0
    SU_RESULT SUSceneRemoveLayer(SUSceneRef scene, SULayerRef layer) # API 4.0
    SU_RESULT SUSceneClearLayers(SUSceneRef scene) # API 4.0
    SU_RESULT SUSceneGetAxes(SUSceneRef scene, SUAxesRef* axes) # API 4.0
    SU_RESULT SUSceneSetUseAxes(SUSceneRef scene, bool use_axes)  # API 5.0
    SU_RESULT SUSceneGetUseAxes(SUSceneRef scene, bool* use_axes)  # API 5.0
    SU_RESULT SUSceneGetNumHiddenEntities(SUSceneRef scene, size_t* count)  # API 5.0
    SU_RESULT SUSceneGetHiddenEntities(SUSceneRef scene, size_t len, SUEntityRef entities[], size_t* count)  # API 5.0
    SU_RESULT SUSceneSetFlags(SUSceneRef scene, uint32_t flags)  # API 5.0
    SU_RESULT SUSceneGetFlags(SUSceneRef scene, uint32_t* flags)  # API 5.0
    SU_RESULT SUSceneSetSketchAxesDisplayed(SUSceneRef scene, bool displayed)  # API 5.0
    SU_RESULT SUSceneGetSketchAxesDisplayed(SUSceneRef scene, bool* displayed)  # API 5.0
    SU_RESULT SUSceneGetPhotoMatchImageDisplayed(SUSceneRef scene, bool* displayed)  # API 5.0
    SU_RESULT SUSceneClearPhotoMatchImage(SUSceneRef scene)  # API 5.0
    SU_RESULT SUSceneGetStyle(SUSceneRef scene, SUStyleRef* style)  # API 5.0
    SU_RESULT SUSceneCopy(SUSceneRef scene, SUSceneRef copy_scene)  # API 5.0
    SU_RESULT SUSceneActivate(SUSceneRef scene)  # API 5.0