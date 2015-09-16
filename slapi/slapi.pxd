# -*- coding: utf-8 -*-
from .defs cimport *
from .unicodestring cimport *


cdef extern from "SketchUpAPI/slapi.h":
    cdef enum SUResult:
        SU_ERROR_NONE = 0               #Indicates success
        SU_ERROR_NULL_POINTER_INPUT     # A pointer for a required input was NULL.
        SU_ERROR_INVALID_INPUT          # An API object input to the function was not created properly.
        SU_ERROR_NULL_POINTER_OUTPUT    # A pointer for a required output was NULL.
        SU_ERROR_INVALID_OUTPUT         # An API object to be written with output from the function was not created properly.
        SU_ERROR_OVERWRITE_VALID        # Indicates that an input object reference already references an object where it was expected to be \ref SU_INVALID.
        SU_ERROR_GENERIC                # Indicates an unspecified error.
        SU_ERROR_SERIALIZATION          # Indicate an error occurred during loading or
                                        # saving of a file.
        SU_ERROR_OUT_OF_RANGE           # An input contained a value that was outside the
                                        # range of allowed values.
        SU_ERROR_NO_DATA                # The requested operation has no data to return to the
                                        # user. This usually occurs when a request is made for
                                        # data that is only available conditionally.
        SU_ERROR_INSUFFICIENT_SIZE      # Indicates that the size of an output
                                        # parameter is insufficient.
        SU_ERROR_UNKNOWN_EXCEPTION      # An unknown exception occurred.
        SU_ERROR_MODEL_INVALID          # The model requested is invalid and cannot be loaded.
        SU_ERROR_MODEL_VERSION          # The model cannot be loaded or saved due to an


