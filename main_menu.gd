extends Control

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test_world.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://settings.tscn")

func _on_load_previous_games_pressed() -> void:
	get_tree().change_scene_to_file("res://load_previous_games.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
