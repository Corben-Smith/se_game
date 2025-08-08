extends Area2D
class_name Elevator

@export var target_scene_path: PackedScene = null # Set this in the inspector
@export var character_scene_path: PackedScene # Set this in the inspector

func _on_body_entered(body):
	print("print")
	if body.is_in_group("player") and target_scene_path and character_scene_path:
		var new_scene = target_scene_path.instantiate()
		if new_scene:
			get_tree().root.add_child(new_scene)

			var player = character_scene_path.instantiate()
			get_tree().root.add_child(player)

			var point: Node2D = new_scene.get_spawn_point()
			if point:
				player.global_position = point.global_position
			
			var camera_manager = new_scene.get_camera_manager()
			if camera_manager:
				camera_manager.player = player

			get_tree().current_scene.queue_free()
			get_tree().current_scene = new_scene
