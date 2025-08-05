extends Node2D

var index = 0
@export var characters:Array[Node2D] = []

func _ready() -> void:
	_arrow_position()

func _select_character():
	pass

func _on_left_pressed() -> void:
	index = index - 1 
	if index < 0 :
		index = len(characters) -1
	_arrow_position()

func _on_right_pressed() -> void:
	index = index + 1 
	if index > len(characters) - 1 :
		index = 0
	_arrow_position()

func _on_select_pressed() -> void:
	_select_character()

@export var arrow:Node2D

func _arrow_position():
	arrow.global_position = characters[index].global_position

