extends Node

var current_level: Level

func _ready() -> void:
	var nodes = get_tree().get_nodes_in_group("level")
	if nodes.size() > 0:
		current_level = nodes[0]

func transition_to_level(level: PackedScene, player: PackedScene):
	if not level or not player:
		print("Error: Level or player PackedScene is null")
		return
	
	var current_scene = get_tree().current_scene
	
	var new_level = level.instantiate() as Level
	if not new_level:
		print("Error: Failed to instantiate level or level is not of type Level")
		return
	
	get_tree().root.add_child(new_level)
	get_tree().current_scene = new_level
	
	if current_scene and current_scene != new_level:
		current_scene.queue_free()
	
	await get_tree().process_frame
	new_level.prepare(player)
	current_level = new_level
	

func get_next_level():
	if current_level.next_level:
		return current_level.next_level
