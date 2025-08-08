extends Control

@export var new_game_button: Button
@export var settings_button: Button
@export var load_button: Button
@export var exit_button: Button

func _ready() -> void:
	new_game_button = get_node_or_null("CenterContainer/VBoxContainer/New Game")
	settings_button = get_node_or_null("CenterContainer/VBoxContainer/Settings")
	load_button = get_node_or_null("CenterContainer/VBoxContainer/Load Previous Games")
	exit_button = get_node_or_null("CenterContainer/VBoxContainer/Exit")
