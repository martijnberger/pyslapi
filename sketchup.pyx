# -*- coding: utf-8 -*-

from cpython.version cimport PY_MAJOR_VERSION
from cpython.ref cimport PyObject
from libcpp cimport bool
from cython.operator cimport dereference as deref, preincrement as inc
from libc.stdlib cimport malloc, free

from slapi.geometry cimport *
from slapi.slapi cimport *
from slapi.initialize cimport *
from slapi.defs cimport *
from slapi.unicodestring cimport *
from slapi.entities cimport *

cdef extern from "slapi/model/camera.h":

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



cdef extern from "slapi/model/model.h":
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

cdef extern from "slapi/model/mesh_helper.h":
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

cdef extern from "slapi/transformation.h":
    struct SUTransformation:
        double values[16] #; ///< Matrix values in column-major order.

cdef extern from "slapi/model/component_instance.h":
    SU_RESULT SUComponentInstanceGetName(SUComponentInstanceRef instance, SUStringRef* name)
    SU_RESULT SUComponentInstanceGetTransform(SUComponentInstanceRef instance, SUTransformation* transform);

def get_API_version():
    cdef size_t major, minor
    SUGetAPIVersion(&major, &minor)
    return (major,minor)

def __str_from_SU_RESULT(SU_RESULT r):
    if r is SU_ERROR_NONE:
        return "SU_ERROR_NONE"
    if r is SU_ERROR_NULL_POINTER_INPUT:
        return "SU_ERROR_NONE"
    if r is SU_ERROR_INVALID_INPUT:
        return "SU_ERROR_INVALID_INPUT"
    if r is SU_ERROR_NULL_POINTER_OUTPUT:
        return "SU_ERROR_NULL_POINTER_OUTPUT"
    if r is SU_ERROR_INVALID_OUTPUT:
        return "SU_ERROR_INVALID_OUTPUT"
    if r is SU_ERROR_OVERWRITE_VALID:
        return "SU_ERROR_OVERWRITE_VALID"
    if r is SU_ERROR_GENERIC:
        return "SU_ERROR_GENERIC"
    if r is SU_ERROR_SERIALIZATION:
        return "SU_ERROR_SERIALIZATION"
    if r is SU_ERROR_OUT_OF_RANGE:
        return "SU_ERROR_OUT_OF_RANGE"
    if r is SU_ERROR_NO_DATA:
        return "SU_ERROR_NO_DATA"
    if r is SU_ERROR_INSUFFICIENT_SIZE:
        return "SU_ERROR_INSUFFICIENT_SIZE"
    if r is SU_ERROR_UNKNOWN_EXCEPTION:
        return "SU_ERROR_UNKNOWN_EXCEPTION"
    if r is SU_ERROR_MODEL_INVALID:
        return "SU_ERROR_MODEL_INVALID"
    if r is SU_ERROR_MODEL_VERSION:
        return "SU_ERROR_MODEL_VERSION"

cdef StringRef2Py(SUStringRef& suStr):
    cdef size_t out_length = 0
    cdef SU_RESULT res = SUStringGetUTF8Length(suStr, &out_length)
    cdef char* out_char_array
    cdef size_t out_number_of_chars_copied
    if out_length == 0:
        return ""
    else:
        malloc(sizeof(char) * (out_length + 16))
        SUStringGetUTF8(suStr, out_length, out_char_array, &out_number_of_chars_copied)
        return out_char_array

cdef SUStringRef Py2StringRef(s):
    cdef SUStringRef out_string_ref
    cdef SU_RESULT res
    if type(s) is unicode:
        # fast path for most common case(s)
        res = SUStringCreateFromUTF8(&out_string_ref, <unicode>s)
    elif PY_MAJOR_VERSION < 3 and isinstance(s, bytes):
        # only accept byte strings in Python 2.x, not in Py3
        res = SUStringCreateFromUTF8(&out_string_ref,(<bytes>s).decode('ascii'))
    elif isinstance(s, unicode):
        # an evil cast to <unicode> might work here in some(!) cases,
        # depending on what the further processing does.  to be safe,
        # we can always create a copy instead
        res = SUStringCreateFromUTF8(&out_string_ref, unicode(s))
    else:
        raise TypeError("Cannot make sense of string {}".format(s))
    return out_string_ref

cdef class Point2D:
    cdef SUPoint2D p

    def __cinit__(self, double x, double y):
        self.p.x = x
        self.p.y = y

    property x:
        def __get__(self): return self.p.x
        def __set__(self, double x): self.p.x = x

    property y:
        def __get__(self): return self.p.y
        def __set__(self, double y): self.p.y = y

cdef class Point3D:
    cdef SUPoint3D p

    def __cinit__(self, double x, double y, double z):
        self.p.x = x
        self.p.y = y
        self.p.z = z

    property x:
        def __get__(self): return self.p.x
        def __set__(self, double x): self.p.x = x

    property y:
        def __get__(self): return self.p.y
        def __set__(self, double y): self.p.y = y

    property z:
        def __get__(self): return self.p.z
        def __set__(self, double z): self.p.z = z

cdef class Vector3D:
    cdef SUVector3D p

    def __cinit__(self, double x, double y, double z):
        self.p.x = x
        self.p.y = y
        self.p.z = z

    property x:
        def __get__(self): return self.p.x
        def __set__(self, double x): self.p.x = x

    property y:
        def __get__(self): return self.p.y
        def __set__(self, double y): self.p.y = y

    property z:
        def __get__(self): return self.p.z
        def __set__(self, double z): self.p.z = z


cdef class Plane3D:
    cdef Plane3D p
    cdef bool cleanup

    def __cinit__(self, double a, double b, double c, double d):
        self.p.a = a
        self.p.b = b
        self.p.c = c
        self.p.d = d

    property a:
        def __get__(self): return self.p.a
        def __set__(self, double a): self.p.a = a

    property b:
        def __get__(self): return self.p.b
        def __set__(self, double b): self.p.b = b

    property c:
        def __get__(self): return self.p.c
        def __set__(self, double c): self.p.c = c

    property d:
        def __get__(self): return self.p.d
        def __set__(self, double d): self.p.d = d


cdef class Camera:
    cdef SUCameraRef camera

    def __cinit__(self):
        self.camera.ptr = <void *> 0

    cdef set_ptr(self, void* ptr):
        self.camera.ptr = ptr

    def GetOrientation(self):
        cdef SUPoint3D position
        cdef SUPoint3D target
        cdef SUVector3D up_vector
        cdef SU_RESULT r = SUCameraGetOrientation(self.camera, &position, &target, &up_vector)
        if(r != 0):
            raise Exception("SUCameraGetOrientation" +  __str_from_SU_RESULT(r) )
        return (position.x, position.y, position.z), (target.x, target.y, target.z), (up_vector.x, up_vector.y, up_vector.z)


cdef class Instance:
    cdef SUComponentInstanceRef instance

    def __cinit__(self):
        self.instance.ptr = <void *> 0

    def __dealloc__(self):
        pass
        #print("~Instance {} ".format(hex(<int> self.instance.ptr)))

    def getName(self):
        cdef SUStringRef n
        n.ptr = <void*>0
        SUStringCreate(&n)
        SUComponentInstanceGetName(self.instance, &n)
        return StringRef2Py(n)

cdef instance_from_ptr(SUComponentInstanceRef& r):
    res = Instance()
    res.instance.ptr = r.ptr
    #print("Instance {}".format(hex(<int> r.ptr)))
    return res


cdef class Entities:
    cdef SUEntitiesRef entities

    def __cinit__(self):
        self.entities.ptr = <void *> 0

    cdef set_ptr(self, void* ptr):
        self.entities.ptr = ptr

    def NumFaces(self):
        cdef size_t count = 0
        cdef SU_RESULT res = SUEntitiesGetNumFaces(self.entities, &count)
        return count

    def NumCurves(self):
        cdef size_t count = 0
        cdef SU_RESULT res = SUEntitiesGetNumCurves(self.entities, &count)
        return count

    def NumGuidePoints(self):
        cdef size_t count = 0
        cdef SU_RESULT res = SUEntitiesGetNumGuidePoints(self.entities, &count)
        return count

    def NumEdges(self, bool standalone_only=False):
        cdef size_t count = 0
        cdef SU_RESULT res = SUEntitiesGetNumEdges(self.entities, standalone_only, &count)
        return count

    def NumPolyline3ds(self):
        cdef size_t count = 0
        cdef SU_RESULT res = SUEntitiesGetNumPolyline3ds(self.entities, &count)
        return count

    def NumGroups(self):
        cdef size_t count = 0
        cdef SU_RESULT res = SUEntitiesGetNumGroups(self.entities, &count)
        return count

    def NumImages(self):
        cdef size_t count = 0
        cdef SU_RESULT res = SUEntitiesGetNumImages(self.entities, &count)
        return count

    def NumInstances(self):
        cdef size_t count = 0
        cdef SU_RESULT res = SUEntitiesGetNumInstances(self.entities, &count)
        return count

    def Instances(self):
        cdef size_t len = 0
        cdef SU_RESULT res1 = SUEntitiesGetNumInstances(self.entities, &len)
        cdef SUComponentInstanceRef * instances = <SUComponentInstanceRef*>malloc(sizeof(SUComponentInstanceRef) * len)
        cdef size_t count = 0
        cdef SU_RESULT res = SUEntitiesGetInstances(self.entities, len, instances, &count)
        for i in range(count):
            yield instance_from_ptr(instances[i])
        #free(instances)

cdef class Model:
    cdef SUModelRef model

    def __cinit__(self):
        self.model.ptr = <void *> 0


    cdef set_ptr(self, void* ptr):
        self.model.ptr = ptr

    @staticmethod
    def from_file(filename):
        res = Model()
        cdef SUModelRef m
        m.ptr = <void*> 0
        py_byte_string = filename.encode('UTF-8')
        cdef const char* f = py_byte_string
        cdef SU_RESULT r = SUModelCreateFromFile(&m, f)
        if(r != 0):
            raise Exception( __str_from_SU_RESULT(r) )
        res.set_ptr(m.ptr)
        return res

    def NumMaterials(self):
        cdef size_t count = 0
        cdef SU_RESULT r = SUModelGetNumMaterials (self.model, &count)
        if(r != 0):
            raise Exception("SUModelGetNumMaterials" +  __str_from_SU_RESULT(r) )
        return count

    def NumComponentDefinitions(self):
        cdef size_t count = 0
        cdef SU_RESULT r = SUModelGetNumComponentDefinitions (self.model, &count)
        if(r != 0):
            raise Exception("SUModelGetNumComponentDefinitions" +  __str_from_SU_RESULT(r) )
        return count

    def NumScenes(self):
        cdef size_t count = 0
        cdef SU_RESULT r = SUModelGetNumScenes (self.model, &count)
        if(r != 0):
            raise Exception("SUModelGetNumScenes" +  __str_from_SU_RESULT(r) )
        return count

    def NumLayers(self):
        cdef size_t count = 0
        cdef SU_RESULT r = SUModelGetNumLayers (self.model, &count)
        if(r != 0):
            raise Exception("SUModelGetNumLayers" +  __str_from_SU_RESULT(r) )
        return count

    def NumAttributeDictionaries(self):
        cdef size_t count = 0
        cdef SU_RESULT r = SUModelGetNumAttributeDictionaries (self.model, &count)
        if(r != 0):
            raise Exception("NumAttributeDictionaries" +  __str_from_SU_RESULT(r) )
        return count


    property Camera:
        def __get__(self):
            cdef SUCameraRef c
            c.ptr = <void*> 0
            cdef SU_RESULT r = SUModelGetCamera(self.model, &c)
            if(r != 0):
                raise Exception("SUModelGetCamera" +  __str_from_SU_RESULT(r) )
            res = Camera()
            res.set_ptr(c.ptr)
            return res

    property Entities:
        def __get__(self):
            cdef SUEntitiesRef entities
            entities.ptr = <void*> 0
            cdef SU_RESULT r = SUModelGetEntities(self.model, &entities)
            if(r != 0):
                raise Exception("SUModelGetEntities" +  __str_from_SU_RESULT(r) )
            res = Entities()
            res.set_ptr(entities.ptr)
            return res
