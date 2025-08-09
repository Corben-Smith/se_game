extends Node

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
