extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_save"):
		PersistentManager.save_data()
	if event.is_action_pressed("debug_load"):
		PersistentManager.load_checkpoint()
