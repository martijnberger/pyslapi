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
import time
import sketchup
import mathutils
from mathutils import Matrix, Vector
from bpy.types import Operator, AddonPreferences
from bpy.props import StringProperty, IntProperty, BoolProperty
from bpy_extras.io_utils import ImportHelper, unpack_list, unpack_face_list
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
        self.filepath = '/tmp/untitled.skp'
        self.name_mapping = {}

    def set_filename(self, filename):
        self.filepath = filename
        self.basepath, self.skp_filename = os.path.split(self.filepath)
        return self # allow chaining

    def load(self, context, **options):
        """load a sketchup file"""
        self.context = context

        SketchupLog('importing skp %r' % self.filepath)

        addon_name = __name__.split('.')[0]
        self.prefs = addon_prefs = context.user_preferences.addons[addon_name].preferences

        time_main = time.time()

        try:
            skp_model = sketchup.Model.from_file(self.filepath)
        except Exception as e:
            SketchupLog('Error reading input file: %s' % self.filepath)
            SketchupLog(e)
            return {'FINISHED'}
        self.skp_model = skp_model

        time_new = time.time()
        SketchupLog('Done parsing mxs %r in %.4f sec.' % (self.filepath, (time_new - time_main)))


        if options['import_camera']:
            active_cam = self.write_camera(skp_model.camera)
            context.scene.camera = active_cam

        self.write_entities(skp_model.Entities, "Sketchup", Matrix.Identity(4))

        return {'FINISHED'}


    def write_mesh_data(self, fs, name):
        verts = []
        faces = []

        for f in fs:
            vert_done = len(verts)
            v, tri = f.triangles
            for face in tri:
                faces.append((face[0] + vert_done, face[1] + vert_done, face[2] +vert_done ) )
            verts = verts + v


        me = bpy.data.meshes.new(name)
        me.vertices.add(len(verts))
        me.tessfaces.add(len(faces))

        me.vertices.foreach_set("co", unpack_list(verts))
        me.tessfaces.foreach_set("vertices_raw", unpack_face_list(faces))

        me.update(calc_edges=True)
        me.validate()
        return me, len(verts)

    def write_entities(self, entities, name, parent_tranform):
        print("Creating object -> {}".format(name))
        me, v = self.write_mesh_data(entities.faces, name)
        ob = bpy.data.objects.new(name, me)
        ob.matrix_world = parent_tranform
        me.update(calc_edges=True)
        self.context.scene.objects.link(ob)

        for group in entities.groups:
            t = group.transform
            trans = Matrix([[t[0], t[4],  t[8], t[12]],
                            [t[1], t[5],  t[9], t[13]],
                            [t[2], t[6], t[10], t[14]],
                            [t[3], t[7], t[11], t[15]]] )
            self.write_entities(group.entities, "Group",parent_tranform * trans)

        for instance in entities.instances:
            t = instance.transform
            trans = Matrix([[t[0], t[4],  t[8], t[12]],
                            [t[1], t[5],  t[9], t[13]],
                            [t[2], t[6], t[10], t[14]],
                            [t[3], t[7], t[11], t[15]]] )# * transform
            self.write_entities(instance.definition.entities, "Component",parent_tranform * trans)

        return ob





    def write_camera(self, camera):
        pos, target, up = camera.GetOrientation()
        bpy.ops.object.add(type='CAMERA', location=pos)
        ob = self.context.object
        z = (mathutils.Vector(pos) - mathutils.Vector(target)).normalized()
        x = mathutils.Vector(up).cross(z).normalized()
        y = x.cross(z)

        ob.matrix_world.col[0] = x.resized(4)
        ob.matrix_world.col[1] = y.resized(4)
        ob.matrix_world.col[2] = z.resized(4)

        cam = ob.data
        cam.lens = camera.fov
        cam.clip_end = self.prefs.camera_far_plane
        cam.name = "Active Camera"



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