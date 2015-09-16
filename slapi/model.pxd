# -*- coding: utf-8 -*-
from libcpp cimport bool
from .defs cimport *
from .geometry cimport *
from .unicodestring cimport *

cdef extern from "SketchUpAPI/model/model.h":
    enum SUEntityType "SUModelStatistics::SUEntityType":
        SUEntityType_Edge = 0,
        SUEntityType_Face
        SUEntityType_ComponentInstance
        SUEntityType_Group
        SUEntityType_Image
        SUEntityType_ComponentDefinition
        SUEntityType_Layer
        SUEntityType_Material
        SUNumEntityTypes

    struct SUModelStatistics:
        int entity_counts[<int>SUNumEntityTypes]

    enum SUModelUnits:
        SUModelUnits_Inches,
        SUModelUnits_Feet,
        SUModelUnits_Millimeters,
        SUModelUnits_Centimeters,
        SUModelUnits_Meters


    enum SUModelVersion:
        SUModelVersion_SU3,
        SUModelVersion_SU4,
        SUModelVersion_SU5,
        SUModelVersion_SU6,
        SUModelVersion_SU7,
        SUModelVersion_SU8,
        SUModelVersion_SU2013,
        SUModelVersion_SU2014,
        SUModelVersion_SU2015

    SU_RESULT SUModelCreate(SUModelRef* model)
    SU_RESULT SUModelCreateFromFile(SUModelRef* model, const char* file_path)
    SU_RESULT SUModelRelease(SUModelRef* model)
    SU_RESULT SUModelGetEntities(SUModelRef model, SUEntitiesRef* entities)
    SU_RESULT SUModelGetNumMaterials(SUModelRef model, size_t* count)
    SU_RESULT SUModelGetMaterials(SUModelRef model, size_t len, SUMaterialRef materials[], size_t* count)
    SU_RESULT SUModelAddMaterials(SUModelRef model, size_t len, const SUMaterialRef materials[])
    SU_RESULT SUModelGetNumComponentDefinitions(SUModelRef model, size_t* count)
    SU_RESULT SUModelGetComponentDefinitions(SUModelRef model, size_t len, SUComponentDefinitionRef components[], size_t* count)
    SU_RESULT SUModelAddComponentDefinitions(SUModelRef model, size_t len, const SUComponentDefinitionRef components[])
    SU_RESULT SUModelSaveToFile(SUModelRef model, const char* file_path)
    SU_RESULT SUModelSaveToFileWithVersion(SUModelRef model, const char* file_path, SUModelVersion version)
    SU_RESULT SUModelGetCamera(SUModelRef model, SUCameraRef* camera)
    SU_RESULT SUModelGetNumScenes(SUModelRef model, size_t* num_scenes)
    SU_RESULT SUModelGetNumLayers(SUModelRef model, size_t* count)
    SU_RESULT SUModelGetLayers(SUModelRef model, size_t len, SULayerRef layers[], size_t* count)
    SU_RESULT SUModelAddLayers(SUModelRef model, size_t len, const SULayerRef layers[])
    SU_RESULT SUModelGetDefaultLayer(SUModelRef model, SULayerRef* layer)
    SU_RESULT SUModelGetVersion(SUModelRef model, int* major, int* minor, int* build)
    SU_RESULT SUModelGetNumAttributeDictionaries(SUModelRef model, size_t* count)
    SU_RESULT SUModelGetAttributeDictionaries(SUModelRef model, size_t len, SUAttributeDictionaryRef dictionaries[], size_t* count)
    SU_RESULT SUModelGetAttributeDictionary(SUModelRef model, const char* name, SUAttributeDictionaryRef* dictionary)
    SU_RESULT SUModelGetLocation(SUModelRef model, SULocationRef* location)
    SU_RESULT SUModelGetStatistics(SUModelRef model, SUModelStatistics* statistics)
    SU_RESULT SUModelSetGeoReference(SUModelRef model, double latitude, double longitude, double altitude, bool is_z_value_centered, bool is_on_ocean_floor)
    SU_RESULT SUModelGetRenderingOptions(SUModelRef model, SURenderingOptionsRef* rendering_options)
    SU_RESULT SUModelGetShadowInfo(SUModelRef model, SUShadowInfoRef* shadow_info)
    SU_RESULT SUModelGetOptionsManager(SUModelRef model, SUOptionsManagerRef* options_manager)
    SU_RESULT SUModelGetNorthCorrection(SUModelRef model, double* north_correction)
    SU_RESULT SUModelMergeCoplanarFaces(SUModelRef model)
    SU_RESULT SUModelGetScenes(SUModelRef model, size_t len, SUSceneRef scenes[], size_t* count)
    SU_RESULT SUModelAddScenes(SUModelRef model, size_t len, const SUSceneRef scenes[])
    SU_RESULT SUModelAddMatchPhotoScene(SUModelRef model, const char* image_file, SUCameraRef camera, const char* scene_name, SUSceneRef *scene)
    SU_RESULT SUModelGetName(SUModelRef model, SUStringRef* name)
    SU_RESULT SUModelSetName(SUModelRef model, const char* name)
    SU_RESULT SUModelGetUnits(SUModelRef model, SUModelUnits* units)
    SU_RESULT SUModelGetClassifications(SUModelRef model, SUClassificationsRef* classifications)

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
    SU_RESULT SUFaceIsComplex(SUFaceRef face, bool* is_complex)
    SU_RESULT SUFaceGetUVHelper(SUFaceRef face, bool front, bool back, SUTextureWriterRef texture_writer,  SUUVHelperRef* uv_helper)
    SU_RESULT SUFaceGetUVHelperWithTextureHandle(SUFaceRef face,  bool front, bool back, SUTextureWriterRef texture_writer, long textureHandle,  SUUVHelperRef* uv_helper)


cdef extern from  "SketchUpAPI/model/mesh_helper.h":
    SU_RESULT SUMeshHelperCreate(SUMeshHelperRef* mesh_ref, SUFaceRef face_ref)
    SU_RESULT SUMeshHelperCreateWithTextureWriter(SUMeshHelperRef* mesh_ref, SUFaceRef face_ref, SUTextureWriterRef texture_writer_ref)
    SU_RESULT SUMeshHelperCreateWithUVHelper(SUMeshHelperRef* mesh_ref, SUFaceRef face_ref, SUUVHelperRef uv_helper_ref)
    SU_RESULT SUMeshHelperRelease(SUMeshHelperRef* mesh_ref)
    SU_RESULT SUMeshHelperGetNumTriangles(SUMeshHelperRef mesh_ref, size_t* count)
    SU_RESULT SUMeshHelperGetNumVertices(SUMeshHelperRef mesh_ref, size_t* count)
    SU_RESULT SUMeshHelperGetVertexIndices(SUMeshHelperRef mesh_ref, size_t len, size_t indices[], size_t* count)
    SU_RESULT SUMeshHelperGetVertices(SUMeshHelperRef mesh_ref, size_t len, SUPoint3D vertices[], size_t* count)
    SU_RESULT SUMeshHelperGetFrontSTQCoords(SUMeshHelperRef mesh_ref, size_t len, SUPoint3D stq[], size_t* count)
    SU_RESULT SUMeshHelperGetBackSTQCoords(SUMeshHelperRef mesh_ref, size_t len, SUPoint3D stq[], size_t* count)
    SU_RESULT SUMeshHelperGetNormals(SUMeshHelperRef mesh_ref, size_t len, SUVector3D normals[], size_t* count)


cdef extern from "SketchUpAPI/model/mesh_helper.h":
    SU_RESULT SUMeshHelperCreate(SUMeshHelperRef* mesh_ref, SUFaceRef face_ref)
    SU_RESULT SUMeshHelperCreateWithTextureWriter(SUMeshHelperRef* mesh_ref, SUFaceRef face_ref, SUTextureWriterRef texture_writer_ref)
    SU_RESULT SUMeshHelperCreateWithUVHelper(SUMeshHelperRef* mesh_ref, SUFaceRef face_ref, SUUVHelperRef uv_helper_ref)
    SU_RESULT SUMeshHelperRelease(SUMeshHelperRef* mesh_ref)
    SU_RESULT SUMeshHelperGetNumTriangles(SUMeshHelperRef mesh_ref, size_t* count)
    SU_RESULT SUMeshHelperGetNumVertices(SUMeshHelperRef mesh_ref, size_t* count)
    SU_RESULT SUMeshHelperGetVertexIndices(SUMeshHelperRef mesh_ref, size_t len, size_t indices[], size_t* count)
    SU_RESULT SUMeshHelperGetVertices(SUMeshHelperRef mesh_ref, size_t len, SUPoint3D vertices[], size_t* count)
    SU_RESULT SUMeshHelperGetFrontSTQCoords(SUMeshHelperRef mesh_ref, size_t len, SUPoint3D stq[], size_t* count)
    SU_RESULT SUMeshHelperGetBackSTQCoords(SUMeshHelperRef mesh_ref, size_t len, SUPoint3D stq[], size_t* count)
    SU_RESULT SUMeshHelperGetNormals(SUMeshHelperRef mesh_ref, size_t len, SUVector3D normals[], size_t* count)

