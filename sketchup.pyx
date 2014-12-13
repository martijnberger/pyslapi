# -*- coding: utf-8 -*-

from cpython.version cimport PY_MAJOR_VERSION
from cpython.ref cimport PyObject
from libcpp cimport bool
from cython.operator cimport dereference as deref, preincrement as inc
from libc.stdlib cimport malloc, free

from slapi.slapi cimport *
from slapi.initialize cimport *
from slapi.defs cimport *
from slapi.unicodestring cimport *
from slapi.entities cimport *
from slapi.camera cimport *
from slapi.model cimport *

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
    SUEntityRef SUComponentInstanceToEntity(SUComponentInstanceRef instance);
    SU_RESULT SUComponentInstanceGetDefinition(SUComponentInstanceRef instance, SUComponentDefinitionRef* component)

cdef extern from "slapi/model/component_definition.h":
    cdef enum SUSnapToBehavior:
            SUSnapToBehavior_None = 0,
            SUSnapToBehavior_Any,
            SUSnapToBehavior_Horizontal,
            SUSnapToBehavior_Vertical,
            SUSnapToBehavior_Sloped
    cdef struct SUComponentBehavior:
        SUSnapToBehavior component_snap
        bool component_cuts_opening
        bool component_always_face_camera
        bool component_shadows_face_sun
    SUEntityRef SUComponentDefinitionToEntity(SUComponentDefinitionRef comp_def)
    SUComponentDefinitionRef SUComponentDefinitionFromEntity(SUEntityRef entity)
    SUDrawingElementRef SUComponentDefinitionToDrawingElement(SUComponentDefinitionRef comp_def)
    SUComponentDefinitionRef SUComponentDefinitionFromDrawingElement(SUDrawingElementRef drawing_elem)
    SU_RESULT SUComponentDefinitionCreate(SUComponentDefinitionRef* comp_def)
    SU_RESULT SUComponentDefinitionRelease(SUComponentDefinitionRef* comp_def)
    SU_RESULT SUComponentDefinitionGetName(SUComponentDefinitionRef comp_def, SUStringRef* name)
    SU_RESULT SUComponentDefinitionSetName(SUComponentDefinitionRef comp_def, const char* name)
    SU_RESULT SUComponentDefinitionGetGuid(SUComponentDefinitionRef comp_def, SUStringRef* guid_ref)
    SU_RESULT SUComponentDefinitionGetEntities(SUComponentDefinitionRef comp_def, SUEntitiesRef* entities)
    SU_RESULT SUComponentDefinitionGetDescription(SUComponentDefinitionRef comp_def, SUStringRef* desc)
    SU_RESULT SUComponentDefinitionSetDescription(SUComponentDefinitionRef comp_def, const char* desc)
    SU_RESULT SUComponentDefinitionCreateInstance(SUComponentDefinitionRef comp_def, SUComponentInstanceRef* instance)
    SU_RESULT SUComponentDefinitionGetBehavior(SUComponentDefinitionRef comp_def, SUComponentBehavior* behavior)
    SU_RESULT SUComponentDefinitionSetBehavior(SUComponentDefinitionRef comp_def, const SUComponentBehavior* behavior)
    SU_RESULT SUComponentDefinitionApplySchemaType(SUComponentDefinitionRef comp_def,SUSchemaRef schema_ref, SUSchemaTypeRef schema_type_ref)


def get_API_version():
    cdef size_t major, minor
    SUGetAPIVersion(&major, &minor)
    return (major,minor)

cdef __str_from_SU_RESULT(SU_RESULT r):
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
        out_char_array = <char*>malloc(sizeof(char) * (out_length *2))
        SUStringGetUTF8(suStr, out_length, out_char_array, &out_number_of_chars_copied)
        try:
            py_result = out_char_array[:out_number_of_chars_copied]
        finally:
            free(out_char_array)
        return py_result

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

    property name:
        def __get__(self):
            cdef SUStringRef n
            n.ptr = <void*>0
            SUStringCreate(&n)
            SUComponentInstanceGetName(self.instance, &n)
            return StringRef2Py(n)

    property entity:
        def __get__(self):
            cdef SUEntityRef ref
            ref = SUComponentInstanceToEntity(self.instance)
            res = Entity()
            res.entity.ptr = ref.ptr
            return res

    property definition:
        def __get__(self):
            cdef SUComponentDefinitionRef component
            component.ptr = <void*>0
            SUComponentInstanceGetDefinition(self.instance, &component)
            c = Component()
            c.comp_def.ptr = component.ptr
            return c

cdef instance_from_ptr(SUComponentInstanceRef& r):
    res = Instance()
    res.instance.ptr = r.ptr
    #print("Instance {}".format(hex(<int> r.ptr)))
    return res

cdef class Component:
    cdef SUComponentDefinitionRef comp_def

    def __cinit__(self):
         self.comp_def.ptr = <void *> 0

    property entities:
        def __get__(self):
            cdef SUEntitiesRef e
            e.ptr = <void*>0
            SUComponentDefinitionGetEntities(self.comp_def, &e);
            res = Entities()
            res.set_ptr(e.ptr)
            return res


cdef class Entity:
    cdef SUEntityRef entity

    def __cinit__(self):
        pass

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
