extends CanvasLayer

var main_menu_scene: PackedScene = preload("res://main_menu.tscn")
var settings_menu_scene: PackedScene = preload("res://settings.tscn")
var new_game_menu_scene: PackedScene = preload("res://new_game_menu.tscn")

var new_game_button: Button
var settings_button: Button
var load_button: Button
var exit_button: Button

var current_screen: Control 

func _ready() -> void:
	spawn_main_menu()



func spawn_main_menu():
	if current_screen: 
		current_screen.queue_free()

	var menu = main_menu_scene.instantiate()

	new_game_button = menu.new_game_button
	settings_button = menu.settings_button
	load_button = menu.load_button
	exit_button = menu.exit_button

	settings_button.pressed.connect(settings_clicked)
	new_game_button.pressed.connect(new_game_clicked)
	load_button.pressed.connect(load_clicked)
	exit_button.pressed.connect(exit_clicked)

	add_child(menu)
	current_screen = menu

func spawn_settings_menu():
	if current_screen: 
		current_screen.queue_free()

	var menu = settings_menu_scene.instantiate()

	menu.get_node_or_null("MarginContainer/VBoxContainer/Back").pressed.connect(volume_exit_clicked)

	add_child(menu)
	current_screen = menu

func spawn_new_game_menu():
	if current_screen: 
		current_screen.queue_free()

	var menu = new_game_menu_scene.instantiate()

	menu.get_node_or_null("CenterContainer/VBoxContainer/Slot1").pressed.connect(new_slot_one_pressed)
	menu.get_node_or_null("CenterContainer/VBoxContainer/Slot2").pressed.connect(new_slot_two_pressed)
	menu.get_node_or_null("CenterContainer/VBoxContainer/Slot3").pressed.connect(new_slot_three_pressed)

	add_child(menu)
	current_screen = menu

func volume_exit_clicked():
	spawn_main_menu()

func new_slot_one_pressed():
	PersistentManager.save_num = 1
	PersistentManager.load_data()

func new_slot_two_pressed():
	PersistentManager.save_num = 2
	PersistentManager.load_data()

func new_slot_three_pressed():
	PersistentManager.save_num = 3
	PersistentManager.load_data()

func settings_clicked():
	spawn_settings_menu()

func new_game_clicked():
	spawn_new_game_menu()

func load_clicked():
	print("load_clicked")

func exit_clicked():
	get_tree().quit()
	pass
