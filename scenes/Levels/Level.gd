extends Node2D
class_name Level

@export var spawn_point: Node2D 
@export var camera_manager: CameraManager

func _ready() -> void:
	pass

func get_spawn_point() -> Node2D:
	if not spawn_point:
		print("Warning: No spawn point set for level")
		return self
	return spawn_point 

func prepare(player: PackedScene) -> void:
	if UI_Manager:
		UI_Manager.setup_level_ui()
	else:
		print("Warning: UI_Manager not found")

	if not player:
		print("Error: Player PackedScene is null")
		return
		
	var player_inst = player.instantiate() as Player
	if not player_inst:
		print("Error: Failed to instantiate player or player is not of type Player")
		return
		
	GlobalReferences.player = player_inst

	var spawn_pos = get_spawn_point()
	if spawn_pos:
		player_inst.global_position = spawn_pos.global_position
	
	add_child(player_inst)

	if not camera_manager:
		camera_manager = find_child("CameraManager") as CameraManager
		if not camera_manager:
			print("Warning: No CameraManager found in level")

	if camera_manager:
		camera_manager.player = player_inst
	else:
		print("Warning: No camera manager available for player setup")

	

func get_camera_manager() -> CameraManager:
	return camera_manager
