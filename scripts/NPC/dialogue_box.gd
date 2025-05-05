extends Control
class_name DialogueBox

@onready var dialogue_label = $Label

signal finished_dialogue

var lines: Array = []
var current_line := 0
var is_active := false
var is_typing := false
var full_text := ""
var type_speed := 0.03  # seconds between letters

func _ready():
	dialogue_label.connect("resized", Callable(self, "_on_label_resized"))
	visible = false
	var margin_size = 30.0
	dialogue_label.anchor_left = 0.5
	dialogue_label.anchor_right = 0.5
	dialogue_label.anchor_top = 1.0
	dialogue_label.anchor_bottom = 1.0
	dialogue_label.pivot_offset = Vector2(dialogue_label.size.x / 2, dialogue_label.size.y)
	dialogue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func start_dialogue(new_lines: Array, speaker: String = ""):
	lines = new_lines
	current_line = 0
	is_active = true
	visible = true
	_show_line()

func _show_line():
	if current_line < lines.size():
		full_text = lines[current_line]
		dialogue_label.text = ""
		is_typing = true
		_type_text()
	else:
		end_dialogue()

func _type_text():
	for i in full_text.length():
		dialogue_label.text += full_text[i]
		await get_tree().create_timer(type_speed).timeout
		if not is_typing:
			dialogue_label.text = full_text
			break
	is_typing = false

func _on_next_pressed():
	if is_typing:
		is_typing = false  # Fast-forward typing
	else:
		current_line += 1
		_show_line()

func _input(event):
	if is_active and event.is_action_pressed("interact"):
		_on_next_pressed()

func end_dialogue():
	is_active = false
	visible = false
	emit_signal("finished_dialogue")

func reset_dialogue():
	current_line = 0
	is_active = false
	visible = false

func _on_label_resized():
	print("resize")
	dialogue_label.pivot_offset = Vector2(dialogue_label.size.x / 2, dialogue_label.size.y)
