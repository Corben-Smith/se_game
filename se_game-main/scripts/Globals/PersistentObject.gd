@tool # made it a tool to allow quick generation of uid
class_name Persistent_Object extends Node

# Allow changing the target 
@export_enum("This", "Parent") var persistent_mode = 1;

@export var recreate_uid = false:
	set(value):
		print("UID Changed")
		recreate_uid = false
		uid = Persistent_Object.create_uid();

@export var uid = "";

@export var keys_to_save: Array[String] = []

var target = self
var destroyed = false

func _ready():
	# verify possible error
	if (persistent_mode == 1):
		# Get parent if mode is set to parent
		target = get_parent()
		# If parent is not a Node, switch back to 'this' mode
		# this can be change, it ensure you can save data below.
		if !(get_parent() is Node2D):
			printerr("Parent Node is not a Node2D, the persistent_mode is switch back to 'this'")
			persistent_mode = 0
			target = self

	# Check if data already exist and charge it if needed
	# if PersistentManager.has(uid):
	#     var data = PersistentManager.get_object(uid)
	#     if (data.destroyed): # data say that this node is destroyed
	#         return target.call_deferred("queue_free")
	#     else:
	#         load_data(data)
	# else: # Recreate a data in the manager
	#     resave()
	#
	# Connect changed properties to the save function if you need to save thing related to it
	# target.item_rect_changed.connect(resave)
	# target.visibility_changed.connect(resave)
	# target.tree_exiting.connect(resave);
	PersistentManager.saving.connect(saving)
	PersistentManager.loading.connect(loading)

func saving():
	PersistentManager.persistent_object[self.uid] = save_data()

func loading():
	var data = PersistentManager.get_object(self.uid)
	load_data(data)


func save_data(destroyed = false):
	if len(keys_to_save) <= 0:
		return _save_data_auto(destroyed)

	var data = {
		"destroyed": destroyed
	}

	for key in keys_to_save:
		for idek in target.get_property_list():
			if key == idek["name"]:
				data[key] = target.get(key)

	return data

func _save_data_auto(destroyed = false):
	var data = {
		"destroyed": destroyed
	}

	for prop_info in target.get_property_list():
		var attname = prop_info.name
		if attname == "destroyed":
			continue

		var value = target.get(attname)
		var t = typeof(value)
		if t in [TYPE_BOOL, TYPE_INT, TYPE_FLOAT, TYPE_STRING, TYPE_VECTOR2, TYPE_VECTOR3]:
			data[attname] = value

	return data

func load_data(data):
	for key in data.keys():
		if key == "destroyed":
			continue

		for thing in target.get_property_list():
			if key == thing["name"]:
				var value = data[key]
				var t = typeof(value)
				if t in [TYPE_BOOL, TYPE_INT, TYPE_FLOAT, TYPE_STRING, TYPE_VECTOR2, TYPE_VECTOR3]:
					target.set(key, value)

# # Contact with the manager
# func resave():
#     PersistentManager.save(uid, save_data(destroyed))

# Call this function to queue_free the target despite of the original queue_free function
func destroy():
	destroyed = true;
	target.call_deferred("queue_free")


####################################################################
# UID GENERATOR FROM https://github.com/binogure-studio/godot-uuid #
####################################################################

# MIT License

# Copyright (c) 2023 Xavier Sellier

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

const BYTE_MASK: int = 0b11111111


static func create_uid() -> String:
	var b = uuidbin();
	return '%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x' % [
	# low
	b[0], b[1], b[2], b[3],

	# mid
	b[4], b[5],

	# hi
	b[6], b[7],

	# clock
	b[8], b[9],

	# clock
	b[10], b[11], b[12], b[13], b[14], b[15]
  ]
static func uuidbin():
	# 16 random bytes with the bytes on index 6 and 8 modified
	return [
	  randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK,
	  randi() & BYTE_MASK, randi() & BYTE_MASK, ((randi() & BYTE_MASK) & 0x0f) | 0x40, randi() & BYTE_MASK,
	  ((randi() & BYTE_MASK) & 0x3f) | 0x80, randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK,
	  randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK,
	]
