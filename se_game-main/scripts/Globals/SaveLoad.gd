extends Node
class_name SaveLoadManager

var save_num: int = 1

var Characters: Dictionary
var Restore_State: Dictionary
var Npcs: Dictionary
var Flags: Dictionary
var persistant_nodes: Dictionary

func set_flag(flag: String, value: bool = true):
	Flags[flag] = value

func save_game():
	var save_file =  FileAccess.open("user://savegame"+ str(save_num) +".save", FileAccess.WRITE)

	var json_string = JSON.stringify(Characters)
	save_file.store_line(json_string)

	json_string = JSON.stringify(Restore_State)
	save_file.store_line(json_string)

	json_string = JSON.stringify(Npcs)
	save_file.store_line(json_string)

	json_string = JSON.stringify(Flags)
	save_file.store_line(json_string)

	var data = {}
	for node in get_tree().get_nodes_in_group("persistant"):
		if !node.has_method("save_data"):
			push_error(str(node.get_path()) + " has persistant class but does not have save_data method")
			continue
			
		data[node.get_path_to(get_tree().root)] = node.save_data()
	save_file.store_line(JSON.stringify(data))

	save_file.close()

func load_game():
	if not FileAccess.file_exists("user://savegame"+ str(save_num) +".save"):
		return



# func reset_flag(flag: String):
#     Flags[flag] = false 
