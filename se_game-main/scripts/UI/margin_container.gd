extends MarginContainer

@export var margin_value = 100
@export var margin_left = -1 
@export var margin_right = -1 
@export var margin_top = -1 
@export var margin_bottom = -1 

func _ready() -> void:
	if margin_left == -1:
		add_theme_constant_override("margin_left", margin_value)
	else:
		add_theme_constant_override("margin_left", margin_left)

	if margin_right == -1:
		add_theme_constant_override("margin_right", margin_value)
	else:
		add_theme_constant_override("margin_right", margin_right)

	if margin_top == -1:
		add_theme_constant_override("margin_top", margin_value)
	else:
		add_theme_constant_override("margin_top", margin_top)

	if margin_bottom == -1:
		add_theme_constant_override("margin_bottom", margin_value)
	else:
		add_theme_constant_override("margin_bottom", margin_bottom)
