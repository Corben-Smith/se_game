extends Node

var current_level = null
var player_data = {}
var level_paths = {
	"level1": "res://scenes/levels/level1.tscn",
	"level2": "res://scenes/levels/level2.tscn",
}

func go_to_level(level_name):
	if current_level:
		current_level.queue_free()
	var scene = load(level_paths[level_name]).instantiate()
	get_tree().root.add_child(scene)
	current_level = scene
