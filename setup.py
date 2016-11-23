# -*- coding: utf-8 -*-

__author__ = 'Martijn Berger'

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import platform


if platform.system() == 'Linux':
    libraries = ["SketchUpAPI"]
    extra_compile_args=[]
    extra_link_args=['-Lbinaries/sketchup/x86-64']
elif platform.system() == 'Darwin': # OS x
    libraries=[]
    extra_compile_args=['-mmacosx-version-min=10.8', '-F.']
    extra_link_args=['-mmacosx-version-min=10.8', '-F','.','-framework','SketchUpAPI']
else:
    libraries=["SketchUpAPI"]
    extra_compile_args=['/Zp8']
    extra_link_args=['/LIBPATH:binaries/sketchup/x64/']

setup(
      name = "Sketchup",
      cmdclass = {"build_ext": build_ext},
      ext_modules = [Extension(
    "sketchup",                       # name of extension
    ["sketchup.pyx"],                 # filename of our Pyrex/Cython source
    language="c++",                     # this causes Pyrex/Cython to create C++ source
    include_dirs=["headers"],   # usual stuff
    libraries=libraries,              # ditto
    extra_compile_args=extra_compile_args,
    extra_link_args=extra_link_args,
    embedsignature=True
    )]
    )
#install_name_tool -change "@rpath/SketchUpAPI.framework/Versions/Current/SketchUpAPI" "@loader_path/SketchUpAPI.framework/Versions/Current/SketchUpAPI" sketchup.so
#install_name_tool -change "@rpath/SketchUpAPI.framework/Versions/A/SketchUpAPI" "@loader_path/SketchUpAPI.framework/Versions/A/SketchUpAPI" sketchup.cpython-35m-darwin.so
