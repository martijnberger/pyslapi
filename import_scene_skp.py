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
    "name": "Sketchup importer",
    "author": "Martijn Berger",
    "version": (0, 0, 1, 'dev'),
    "blender": (2, 7, 2),
    "description": "import/export Sketchup skp files",
    "warning": "Very early preview",
    "wiki_url": "https://github.com/martijnberger/pyslapi",
    "tracker_url": "",
    "category": "Import-Export",
    "location": "File > Import"}

import bpy
import os
import time
import sketchup
import mathutils
from collections import OrderedDict, defaultdict
from mathutils import Matrix, Vector
from bpy.types import Operator, AddonPreferences
from bpy.props import StringProperty, IntProperty, BoolProperty
from bpy_extras.io_utils import ImportHelper, unpack_list, unpack_face_list
from extensions_framework import log


class keep_offset(defaultdict):
    def __init__(self):
        defaultdict.__init__(self, int)

    def __missing__(self, _):
        return defaultdict.__len__(self)

    def __getitem__(self, item):
        number = defaultdict.__getitem__(self, item)
        self[item] = number
        return number

class SketchupAddonPreferences(AddonPreferences):
    bl_idname = "import_scene_skp"

    camera_far_plane = IntProperty(name="Default Camera Distance", default=1250)
    draw_bounds = IntProperty(name="Draw object as bounds when over", default=5000)
    max_instance = IntProperty( name="Create DUPLI vert instance when count over", default=50)


    def draw(self, context):
        layout = self.layout
        layout.label(text="SKP import options:")
        layout.prop(self, "camera_far_plane")
        layout.prop(self, "draw_bounds")
        layout.prop(self, "max_instance")

def sketchupLog(*args):
    if len(args) > 0:
        log(' '.join(['%s'%a for a in args]), module_name='Sketchup')


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

        sketchupLog('importing skp %r' % self.filepath)

        addon_name = __name__.split('.')[0]
        self.prefs = addon_prefs = context.user_preferences.addons[addon_name].preferences

        time_main = time.time()

        try:
            skp_model = sketchup.Model.from_file(self.filepath)
        except Exception as e:
            sketchupLog('Error reading input file: %s' % self.filepath)
            sketchupLog(e)
            return {'FINISHED'}
        self.skp_model = skp_model

        time_new = time.time()
        sketchupLog('Done parsing skp %r in %.4f sec.' % (self.filepath, (time_new - time_main)))


        if options['import_camera']:
            active_cam = self.write_camera(skp_model.camera)
            context.scene.camera = active_cam

        self.write_materials(skp_model.materials)

        self.write_entities(skp_model.Entities, "Sketchup", Matrix.Identity(4))

        return {'FINISHED'}


    def write_materials(self,materials):
        self.materials = {'Material': bpy.data.materials['Material']}

        for mat in materials:

            name = mat.name

            if not name in bpy.data.materials:
                print(name, mat.color)
                bmat = bpy.data.materials.new(name)
                r, g, b, a = mat.color
                print(r,g,b)
                bmat.diffuse_color = (r / 256.0, g / 256.0, b / 256.0)
                bmat.use_nodes = True
                self.materials[name] = bmat
            else:
                self.materials[name] = bpy.data.materials[name]



    def write_mesh_data(self, fs, name, default_material='Material'):
        verts = []
        verts_extend = verts.extend
        faces = []
        mat_index = []
        mats = keep_offset()
        seen = {}

        for f in fs:
            vert_done = len(verts)
            vs, tri = f.triangles

            if f.material:
                mat_number = mats[f.material.name]
            else:
                mat_number = mats[default_material]

            new_verts = []

            mapping = {}
            not_mapped = vert_done
            for i, v in enumerate(vs):
                if v in seen:
                    mapping[i] = seen[v]
                else:
                    mapping[i] = not_mapped
                    not_mapped += 1
                    new_verts.append(v)


            for face in tri:
                faces.append((face[0] + vert_done, face[1] + vert_done, face[2] + vert_done ) )
                mat_index.append(mat_number)
            verts_extend(new_verts)

        if len(verts) == 0:
            return None, 0

        me = bpy.data.meshes.new(name)

        me.vertices.add(len(verts))
        me.tessfaces.add(len(faces))

        if len(mats) >= 1:
            mats_sorted = OrderedDict(sorted(mats.items(), key=lambda x: x[1]))
            for k in mats_sorted.keys():
                me.materials.append(self.materials[k])
        else:
            sketchupLog("WARNING OBJECT {} HAS NO MATERIAL".format(name))

        me.vertices.foreach_set("co", unpack_list(verts))
        me.tessfaces.foreach_set("vertices_raw", unpack_face_list(faces))
        me.tessfaces.foreach_set("material_index", mat_index)

        me.update(calc_edges=True)
        me.validate()
        return me, len(verts)

    def write_entities(self, entities, name, parent_tranform, default_material="Material"):
        print("Creating object -> {} with default mat {}".format(name, default_material))
        me, v = self.write_mesh_data(entities.faces, name, default_material=default_material)
        if me:
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
            mat = group.material
            mat_name = mat.name if mat else default_material
            if mat_name == "Material" and default_material != "Material":
                mat_name = default_material
            print("recurse with mat_name {}".format(mat_name))
            self.write_entities(group.entities, " G-" + group.name, parent_tranform * trans, default_material=mat_name)

        for instance in entities.instances:
            t = instance.transform
            trans = Matrix([[t[0], t[4],  t[8], t[12]],
                            [t[1], t[5],  t[9], t[13]],
                            [t[2], t[6], t[10], t[14]],
                            [t[3], t[7], t[11], t[15]]] )# * transform
            mat = instance.material
            mat_name = mat.name if mat else default_material
            if mat_name == "Material" and default_material != "Material":
                mat_name = default_material
            print("recurse with mat_name {}".format(mat_name))
            self.write_entities(instance.definition.entities, " I-" + instance.name ,parent_tranform * trans, default_material=mat_name)

        return





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

    import_camera = BoolProperty(name="Cameras", description="Import camera's", default=True)
    import_material = BoolProperty(name="Materials", description="Import materials's", default=True)
    import_meshes = BoolProperty(name="Meshes", description="Import meshes's", default=True)
    import_instances = BoolProperty(name="Instances", description="Import instances's", default=True)
    apply_scale = BoolProperty(name="Apply Scale", description="Apply scale to imported objects", default=True)
    handle_proxy_group = BoolProperty(name="Proxy", description="Attempt to find groups for meshes names *_proxy*",
                                      default=True,)

    def execute(self, context):
        keywords = self.as_keywords(ignore=("axis_forward",
                                            "axis_up",
                                            "filter_glob",
                                            "split_mode"))
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