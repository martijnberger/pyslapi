from slapi.model.defs cimport *
from slapi.geometry cimport *
from slapi.unicodestring cimport *
from slapi.transformation cimport SUTransformation

cdef extern from "SketchUpAPI/model/axes.h":
    SUEntityRef SUAxesToEntity(SUAxesRef axes)
    SUAxesRef SUAxesFromEntity(SUEntityRef entity)
    SUDrawingElementRef SUAxesToDrawingElement(SUAxesRef axes)
    SUAxesRef SUAxesFromDrawingElement(SUDrawingElementRef drawing_elem)
    SU_RESULT SUAxesCreate(SUAxesRef* axes)
    SU_RESULT SUAxesCreateCustom(SUAxesRef* axes,
                             const SUPoint3D* origin,
                             const SUVector3D* xaxis,
                             const SUVector3D* yaxis,
                             const SUVector3D* zaxis)
    SU_RESULT SUAxesRelease(SUAxesRef* axes)
    SU_RESULT SUAxesGetOrigin(SUAxesRef axes, SUPoint3D* origin)
    SU_RESULT SUAxesSetOrigin(SUAxesRef axes, const SUPoint3D* origin)
    SU_RESULT SUAxesGetXAxis(SUAxesRef axes, SUVector3D* axis)
    SU_RESULT SUAxesGetYAxis(SUAxesRef axes, SUVector3D* axis)
    SU_RESULT SUAxesGetZAxis(SUAxesRef axes, SUVector3D* axis)
    SU_RESULT SUAxesSetAxesVecs(SUAxesRef axes,
                            const SUVector3D* xaxis,
                            const SUVector3D* yaxis,
                            const SUVector3D* zaxis)
    SU_RESULT SUAxesGetTransform(SUAxesRef axes,
                                 SUTransformation* transform);
    SU_RESULT SUAxesGetPlane(SUAxesRef axes, SUPlane3D* plane)

