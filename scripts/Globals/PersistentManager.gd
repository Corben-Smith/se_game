extends Node

signal saving
signal loading

var persistent_object : Dictionary = {};
var save_num: int

var checkpoint = null

func has(uid : String) -> bool:
	return (uid in persistent_object.keys())

func get_object(uid : String):
	assert(has(uid), "No persistent object with specified uid exist : " + uid);
	return persistent_object[uid]

func save(uid : String, data : Dictionary) -> void:
	persistent_object[uid] = data


func load_data() -> void:
	var access: FileAccess = FileAccess.open("user://" + "savefile" + str(save_num) + ".png", FileAccess.READ)
	var json: String = access.get_as_text()
	persistent_object = JSON.parse_string(json)
	access.close()
	loading.emit()

func save_data() -> void:
	saving.emit()
	await get_tree().create_timer(1).timeout
	var save_info_dict= {"name": "Save One!!!"}

	persistent_object.merge(save_info_dict)
	var json: String = JSON.stringify(persistent_object)
	var access: FileAccess = FileAccess.open("user://" + "savefile" + str(save_num) + ".png" , FileAccess.WRITE)

	access.store_string(json)
	access.close()

func get_level():
	return preload("res://scenes/Levels/Level1.tscn")
