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
from slapi.component cimport *
from slapi.material cimport *
from slapi.group cimport *
from slapi.texture cimport *

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


cdef double m(double v):
    """
    :param v: value to be converted from inches to meters
    :return: value in meters
    """
    return <double>0.0254 * v

def get_API_version():
    cdef size_t major, minor
    SUGetAPIVersion(&major, &minor)
    return (major,minor)

cdef check_result(SU_RESULT r):
    if not r is SU_ERROR_NONE:
        print(__str_from_SU_RESULT(r))
        raise IOError("Sketchup library giving unexpected results")


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

    def __cinit__(self, double x=0, double y=0, double z=0):
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
        check_result(SUCameraGetOrientation(self.camera, &position, &target, &up_vector))
        return (m(position.x), m(position.y), m(position.z)), \
               (m(target.x), m(target.y), m(target.z)), \
               (up_vector.x, up_vector.y, up_vector.x)

    property fov:
        def __get__(self):
            cdef double fov
            check_result(SUCameraGetPerspectiveFrustumFOV(self.camera, &fov))
            return fov




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

    property transform:
        def __get__(self):
            cdef SUTransformation transform
            check_result(SUComponentInstanceGetTransform(self.instance, &transform))
            res = []
            for i in range(12):
                res.append(transform.values[i])
            for i in range(12,15,1):
                res.append(m(transform.values[i]))
            res.append(transform.values[15])
            return res

cdef instance_from_ptr(SUComponentInstanceRef r):
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


cdef class Group:
    cdef SUGroupRef group

    def __cinit__(self):
        pass

    property name:
        def __get__(self):
            cdef SUStringRef n
            n.ptr = <void*>0
            SUStringCreate(&n)
            check_result(SUGroupGetName(self.group, &n))
            return StringRef2Py(n)

    property transform:
        def __get__(self):
            cdef SUTransformation transform
            check_result(SUGroupGetTransform(self.group, &transform))
            res = []
            for i in range(12):
                res.append(transform.values[i])
            for i in range(12,15,1):
                res.append(m(transform.values[i]))
            res.append(transform.values[15])
            return res

    property entities:
        def __get__(self):
            cdef SUEntitiesRef entities
            entities.ptr = <void*> 0
            check_result(SUGroupGetEntities(self.group, &entities))
            res = Entities()
            res.set_ptr(entities.ptr)
            return res

    def __repr__(self):
        return "Group {} \n\ttransform {}".format(self.name, self.transform)



cdef group_from_ptr(SUGroupRef r):
    res = Group()
    res.group.ptr = r.ptr
    return res

cdef class Entity:
    cdef SUEntityRef entity

    def __cinit__(self):
        pass


cdef class Face:
    cdef SUFaceRef face_ref

    def __cinit__(self):
        self.face_ref.ptr = <void *> 0


    property triangles:
        def __get__(self):
            cdef SUMeshHelperRef mesh_ref
            mesh_ref.ptr = <void*> 0
            check_result(SUMeshHelperCreate(&mesh_ref, self.face_ref))
            cdef size_t triangle_count = 0
            cdef size_t vertex_count = 0
            check_result(SUMeshHelperGetNumTriangles(mesh_ref, &triangle_count))
            check_result(SUMeshHelperGetNumVertices(mesh_ref, &vertex_count))
            cdef size_t* indices = <size_t*>malloc(triangle_count * 3 * sizeof(size_t) )
            cdef size_t index_count = 0
            check_result(SUMeshHelperGetVertexIndices(mesh_ref, triangle_count * 3, indices, &index_count))
            cdef size_t got_vertex_count = 0
            cdef SUPoint3D* vertices = <SUPoint3D*>malloc(sizeof(SUPoint3D) * vertex_count)
            check_result(SUMeshHelperGetVertices(mesh_ref, vertex_count, vertices, &got_vertex_count))
            #SU_RESULT SUMeshHelperGetFrontSTQCoords(SUMeshHelperRef mesh_ref, size_t len, SUPoint3D stq[], size_t* count)
            #SU_RESULT SUMeshHelperGetBackSTQCoords(SUMeshHelperRef mesh_ref, size_t len, SUPoint3D stq[], size_t* count)
            #SU_RESULT SUMeshHelperGetNormals(SUMeshHelperRef mesh_ref, size_t len, SUVector3D normals[], size_t* count)
            vertices_list = []
            for i in range(got_vertex_count):
                vertices_list.append((m(vertices[i].x), m(vertices[i].y), m(vertices[i].z)))
            triangles_list = []
            for ii in range(index_count / 3):
                i = ii * 3
                triangles_list.append( (indices[i], indices[i+1], indices[i+2]) )

            return (vertices_list, triangles_list)

    def __repr__(self):
        v, t = self.triangles
        return "Face with {} triangles {} vertices\n {} {}".format(len(t), len(v), v, t)


cdef face_from_ptr(SUFaceRef& r):
    res = Face()
    res.face_ref.ptr = r.ptr
    return res

cdef class Entities:
    cdef SUEntitiesRef entities

    def __cinit__(self):
        self.entities.ptr = <void *> 0

    cdef set_ptr(self, void* ptr):
        self.entities.ptr = ptr

    def NumFaces(self):
        cdef size_t count = 0
        check_result(SUEntitiesGetNumFaces(self.entities, &count))
        return count

    def NumCurves(self):
        cdef size_t count = 0
        check_result(SUEntitiesGetNumCurves(self.entities, &count))
        return count

    def NumGuidePoints(self):
        cdef size_t count = 0
        check_result(SUEntitiesGetNumGuidePoints(self.entities, &count))
        return count

    def NumEdges(self, bool standalone_only=False):
        cdef size_t count = 0
        check_result(SUEntitiesGetNumEdges(self.entities, standalone_only, &count))
        return count

    def NumPolyline3ds(self):
        cdef size_t count = 0
        check_result(SUEntitiesGetNumPolyline3ds(self.entities, &count))
        return count

    def NumGroups(self):
        cdef size_t count = 0
        check_result(SUEntitiesGetNumGroups(self.entities, &count))
        return count

    def NumImages(self):
        cdef size_t count = 0
        check_result(SUEntitiesGetNumImages(self.entities, &count))
        return count

    def NumInstances(self):
        cdef size_t count = 0
        check_result(SUEntitiesGetNumInstances(self.entities, &count))
        return count

    property faces:
        def __get__(self):
            cdef size_t len = 0
            check_result(SUEntitiesGetNumFaces(self.entities, &len))
            cdef SUFaceRef * faces = <SUFaceRef*>malloc(sizeof(SUFaceRef) * len)
            cdef size_t count = 0
            check_result(SUEntitiesGetFaces(self.entities, len, faces, &count))
            for i in range(count):
                yield face_from_ptr(faces[i])
            #free(faces)

    property groups:
        def __get__(self):
            cdef size_t num_groups = 0
            check_result(SUEntitiesGetNumGroups(self.entities, &num_groups))
            cdef SUGroupRef* groups = <SUGroupRef*> malloc(sizeof(SUGroupRef) *num_groups)
            cdef size_t count = 0
            check_result(SUEntitiesGetGroups(self.entities, num_groups, groups, &count))
            for i in range(count):
                yield group_from_ptr(groups[i])
            free(groups)

    property instances:
        def __get__(self):
            cdef size_t num_instances = 0
            check_result(SUEntitiesGetNumInstances(self.entities, &num_instances))
            cdef SUComponentInstanceRef* instances = <SUComponentInstanceRef*> malloc(sizeof(SUComponentInstanceRef) *num_instances)
            cdef size_t count = 0
            check_result(SUEntitiesGetInstances(self.entities, num_instances,instances, &count))
            for i in range(count):
                yield instance_from_ptr(instances[i])
            free(instances)



cdef class Material:
    cdef SUMaterialRef material

    def __cinit__(self):
        self.material.ptr = <void *> 0

    property name:
        def __get__(self):
            cdef SUStringRef n
            n.ptr = <void*>0
            SUStringCreate(&n)
            check_result(SUMaterialGetName(self.material, &n))
            return StringRef2Py(n)


    property color:
        def __get__(self):
            cdef SUColor c
            check_result(SUMaterialGetColor(self.material, &c))
            return (c.red, c.green, c.blue, c.alpha)

    property opacity:
        def __get__(self):
            cdef double alpha
            check_result(SUMaterialGetOpacity(self.material, &alpha))
            return alpha

        def __set__(self,double alpha):
            check_result(SUMaterialSetOpacity(self.material, alpha))


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
        check_result(SUModelCreateFromFile(&m, f))
        res.set_ptr(m.ptr)
        return res

    def NumMaterials(self):
        cdef size_t count = 0
        check_result(SUModelGetNumMaterials (self.model, &count))
        return count

    def NumComponentDefinitions(self):
        cdef size_t count = 0
        check_result(SUModelGetNumComponentDefinitions (self.model, &count))
        return count

    def NumScenes(self):
        cdef size_t count = 0
        check_result(SUModelGetNumScenes (self.model, &count))
        return count

    def NumLayers(self):
        cdef size_t count = 0
        check_result(SUModelGetNumLayers (self.model, &count))
        return count

    def NumAttributeDictionaries(self):
        cdef size_t count = 0
        check_result(SUModelGetNumAttributeDictionaries (self.model, &count))
        return count


    property camera:
        def __get__(self):
            cdef SUCameraRef c
            c.ptr = <void*> 0
            check_result(SUModelGetCamera(self.model, &c))
            res = Camera()
            res.set_ptr(c.ptr)
            return res

    property Entities:
        def __get__(self):
            cdef SUEntitiesRef entities
            entities.ptr = <void*> 0
            check_result(SUModelGetEntities(self.model, &entities))
            res = Entities()
            res.set_ptr(entities.ptr)
            return res

    property materials:
        def __get__(self):
            cdef size_t num_materials = 0
            check_result(SUModelGetNumMaterials(self.model, &num_materials))
            cdef SUMaterialRef* materials = <SUMaterialRef*>malloc(sizeof(SUMaterialRef) * num_materials)
            cdef size_t count = 0
            check_result(SUModelGetMaterials(self.model, num_materials, materials, &count))
            for i in range(count):
                m = Material()
                m.material.ptr = materials[i].ptr
                yield m
            free(materials)




