extends Node2D

var index := 0
@export var characters: Array[Node2D] = []
@export var arrow: TextureRect
@export var character_name: RichTextLabel

func _ready() -> void:
	_update_arrow_position()
	
	# Connect button signals if they exist in the scene
	if has_node("Left"):
		$Left.pressed.connect(_on_left_pressed)
	if has_node("Right"):
		$Right.pressed.connect(_on_right_pressed)
	if has_node("Select"):
		$Select.pressed.connect(_on_select_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		_on_left_pressed()
	elif event.is_action_pressed("ui_right"):
		_on_right_pressed()
	elif event.is_action_pressed("ui_accept"):
		_on_select_pressed()

func _on_left_pressed() -> void:
	index -= 1
	if index < 0:
		index = characters.size() - 1
	_update_arrow_position()

func _on_right_pressed() -> void:
	index += 1
	if index >= characters.size():
		index = 0
	_update_arrow_position()

func _on_select_pressed() -> void:
	_select_character()

func _update_arrow_position():
	arrow.global_position = characters[index].global_position
	if "reset_bob_base" in arrow:
		arrow.reset_bob_base()	# Keeps bobbing aligned if using bobbing script

	character_name.text = characters[index].name

func _select_character():

	var character_scene
	match characters[index].name.to_lower():
		"kenley":
			character_scene = preload("res://scenes/Kenley.tscn")
		"isaiah":
			character_scene = preload("res://scenes/Isaiah.tscn")
		_:
			character_scene = preload("res://scenes/Kenley.tscn")

	LevelManager.transition_to_level(PersistentManager.get_level(),character_scene)



