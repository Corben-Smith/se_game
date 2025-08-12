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
	# return preload("res://scenes/Levels/LevelTutorial.tscn")
	return preload("res://scenes/Levels/Level4.tscn")

func respawn():
	print("no checpitn")
	if checkpoint:
		print("checpitn")
		UI_Manager.dim_screen(0.55)
		await create_timer_and_wait(0.5)
		GlobalReferences.player.global_position = checkpoint.global_position
		await create_timer_and_wait(0.25)
		UI_Manager.remove_dim(0.25)


	
		
func create_timer_and_wait(seconds: float) -> void:
	var timer = get_tree().create_timer(seconds)
	await timer.timeout


func _ready():
	# Uncomment these one at a time to test
	# test_save_and_load()
	test_has_and_get()
	# test_respawn_no_checkpoint()
	# test_respawn_with_checkpoint()

func test_save_and_load():
	save_num = 1
	print("--- TEST SAVE AND LOAD ---")
	save("player_stats", {"hp": 100, "mana": 50})
	save("inventory", {"items": ["sword", "shield"], "gold": 999})
	await save_data()
	
	# Clear and reload
	persistent_object.clear()
	await create_timer_and_wait(0.2)
	load_data()
	
	print("Loaded Data:", persistent_object)
	assert("player_stats" in persistent_object)
	assert("inventory" in persistent_object)

func test_has_and_get():
	save("test_uid", {"foo": "bar"})
	assert(has("test_uid"))
	var obj = get_object("test_uid")
	print("Retrieved:", obj)

func test_respawn_no_checkpoint():
	checkpoint = null
	await respawn()

func test_respawn_with_checkpoint():
	# Fake checkpoint node
	var cp = Node2D.new()
	cp.global_position = Vector2(100, 200)
	checkpoint = cp
	GlobalReferences.player = Node2D.new()
	GlobalReferences.player.global_position = Vector2.ZERO
	
	await respawn()
	print("Player Position after respawn:", GlobalReferences.player.global_position)
