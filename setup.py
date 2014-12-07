# -*- coding: utf-8 -*-

__author__ = 'Martijn Berger'

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import platform


if platform.system() == 'Linux':
    libraries = ["slapi"]
    extra_compile_args=[]
    extra_link_args=['-Lbinaries/x86-64']
elif platform.system() == 'Darwin': # OS x
    libraries=["mxs"]
    extra_compile_args=[]
    extra_link_args=['-F.','-framework slapi']
else:
    libraries=["slapi"]
    extra_compile_args=['/Zp8']
    extra_link_args=['/LIBPATH:binaries/x64']

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

