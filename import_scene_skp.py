__author__ = 'Martijn Berger'
__license__ = "GPL"

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.

bl_info = {
    "name": "Sketchup importer/exporter",
    "author": "Martijn Berger",
    "version": (0, 0, 1, 'dev'),
    "blender": (2, 7, 2),
    "description": "import/export Sketchup skp files",
    "warning": "Very early preview",
    "wiki_url": "https://github.com/martijnberger/pyslapi",
    "tracker_url": "",
    "category": "Import-Export",
    "location": "File > Export"}

import bpy
import os
from . import sketchup
from bpy.types import Operator, AddonPreferences
from bpy.props import StringProperty, IntProperty, BoolProperty
from bpy_extras.io_utils import ImportHelper, axis_conversion
from extensions_framework import log



class SketchupAddonPreferences(AddonPreferences):
    bl_idname = "import_scene_skp"

    camera_far_plane = IntProperty(
            name="Default Camera Distance",
            default=1250,
            )
    draw_bounds = IntProperty(
            name="Draw object as bounds when over",
            default=5000,
            )
    max_instance = IntProperty(
            name="Create DUPLI vert instance when count over",
            default=50,
            )


    def draw(self, context):
        layout = self.layout
        layout.label(text="SKP import options:")
        layout.prop(self, "camera_far_plane")
        layout.prop(self, "draw_bounds")
        layout.prop(self, "max_instance")

def SketchupLog(*args, popup=False):
    if len(args) > 0:
        log(' '.join(['%s'%a for a in args]), module_name='Sketchup', popup=popup)


class SceneImporter():
    def __init__(self):
        self.filepath = '/tmp/untitled.mxs'
        self.name_mapping = {}

    def set_filename(self, filename):
        self.filepath = filename
        self.basepath, self.skp_filename = os.path.split(self.filepath)
        return self # allow chaining

    def load(self, context, **options):
        """load a sketchup file"""
        self.context = context
        return {'FINISHED'}


class ImportSKP(bpy.types.Operator, ImportHelper):
    """load a Trimble Sketchup SKP file"""
    bl_idname = "import_scene.skp"
    bl_label = "Import SKP"
    bl_options = {'PRESET', 'UNDO'}

    filename_ext = ".skp"

    filter_glob = StringProperty(
        default="*.SKP",
        options={'HIDDEN'},
    )

    import_camera = BoolProperty(
        name="Cameras",
        description="Import camera's",
        default=True,
    )

    import_material = BoolProperty(
        name="Materials",
        description="Import materials's",
        default=True,
    )

    import_meshes = BoolProperty(
        name="Meshes",
        description="Import meshes's",
        default=True,
    )

    import_instances = BoolProperty(
        name="Instances",
        description="Import instances's",
        default=True,
    )

    apply_scale = BoolProperty(
        name="Apply Scale",
        description="Apply scale to imported objects",
        default=True,
    )

    handle_proxy_group = BoolProperty(
        name="Proxy",
        description="Attempt to find groups for meshes names *_proxy*",
        default=True,
    )

    def execute(self, context):
        keywords = self.as_keywords(ignore=("axis_forward",
                                            "axis_up",
                                            "filter_glob",
                                            "split_mode",
            ))
        return SceneImporter().set_filename(keywords['filepath']).load(context, **keywords)

    def draw(self, context):
        layout = self.layout

        row = layout.row(align=True)
        row.prop(self, "import_camera")
        row.prop(self, "import_material")
        row = layout.row(align=True)
        row.prop(self, "import_meshes")
        row.prop(self, "import_instances")
        row = layout.row(align=True)
        row.prop(self, "handle_proxy_group")
        row.prop(self, "apply_scale")

def menu_func_import(self, context):
    self.layout.operator(ImportSKP.bl_idname, text="Import Sketchup Scene(.skp)")


# Registration
def register():
    bpy.utils.register_class(ImportSKP)
    bpy.types.INFO_MT_file_import.append(menu_func_import)
    bpy.utils.register_class(SketchupAddonPreferences)


def unregister():
    bpy.utils.unregister_class(ImportSKP)
    bpy.types.INFO_MT_file_import.remove(menu_func_import)
    bpy.utils.unregister_class(SketchupAddonPreferences)