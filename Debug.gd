extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_save"):
		print("Attempting to Save")
		PersistentManager.save_data("savetest.save")
		print("aftersave")
	if event.is_action_pressed("debug_load"):
		print("Attempting to Load")
		PersistentManager.load_data("savetest.save")
		print("afterload")
