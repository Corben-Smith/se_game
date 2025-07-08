# This node need to be set in the autoloadtab as "PersistentManager";
# it keep track of all persistent_object across your game and keep data
#
# Remember to save it's data with your game save
extends Node

signal saving
signal loading

var persistent_object : Dictionary = {};
var save_num: int

# Return if a data with specifie UID exist
func has(uid : String) -> bool:
	return (uid in persistent_object.keys())

# Return data from a specifie UID. Throw an error if it doesn't exist
func get_object(uid : String):
	assert(has(uid), "No persistent object with specified uid exist : " + uid);
	return persistent_object[uid]

# Save data for the specifie UID.
func save(uid : String, data : Dictionary) -> void:
	persistent_object[uid] = data

# Use this function to load and save data to your game file
# You can use it as it is or change it to include data in your own save system
# Load data before loading a scene containing a persistent object as it load data on ready.

func load_data() -> void:
	var access: FileAccess = FileAccess.open("user://" + "savefile" + str(save_num) + ".png", FileAccess.READ)
	var json: String = access.get_as_text()
	persistent_object = JSON.parse_string(json)
	access.close()
	loading.emit()

func save_data() -> void:
	saving.emit()
	await get_tree().create_timer(1).timeout
	var json: String = JSON.stringify(persistent_object)
	var access: FileAccess = FileAccess.open("user://" + "savefile" + str(save_num) + ".png" , FileAccess.WRITE)
	access.store_string(json)
	access.close()
