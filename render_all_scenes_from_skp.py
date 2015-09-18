import sketchup
import tempfile
import subprocess

blender = "/Applications/blender.app/Contents/MacOS/blender"

fname = 'test layers en camera.skp'

m = sketchup.Model.from_file(fname)

todo_scenes = [s.name for s in m.scenes]




for scene_name in todo_scenes:
    temp = tempfile.NamedTemporaryFile()
    with open("temp_render.py", "w") as f:

        fstr = """# Command "blender -b your_file.blend -P render_all_cameras.py  cameras=east" will render "east.01" and "east.02" cameras.
# Command "blender -b your_file.blend -P render_all_cameras.py  cameras=01" will render "east.01" and "west.01.02" cameras.


import bpy, sys
from bpy import data, ops, props, types, context

print("AA")

bpy.ops.import_scene.skp(filepath=\"{fname}\",
                         import_scene=\"{name}\",
                         scenes_as_camera=False, import_camera=True,
                         reuse_material=True)

print("BA")

#bpy.context.user_preferences.system.compute_device_type = 'CUDA'

#bpy.data.scenes['Scene'].render.use_border = False
bpy.data.scenes['Scene'].render.resolution_percentage = 100
bpy.data.scenes['Scene'].cycles.samples = 50
print('Setting render tile to 256x256')
bpy.data.scenes['Scene'].cycles.tile_x = 256
bpy.data.scenes['Scene'].cycles.tile_y = 256

bpy.data.scenes['Scene'].render.filepath = '{name}.png'

print(context)
print("BA")

context.scene.camera = bpy.data.objects['{name}']

bpy.ops.wm.save_as_mainfile( filepath="test.blend")

bpy.ops.render.render( write_still=True )
print('Done!')
    """.format(name=scene_name, fname=fname)

        f.writelines(fstr)

    subprocess.call([blender, "-b", "-P", "{}".format("temp_render.py")])

print("DONE")


