extends Control
class_name DialogueBox

@export var dialogue_text: Label
@export var dialogue_name: Label
@export var stream_player: AudioStreamPlayer

@export var arrow: TextureRect

var blip: AudioStream

signal finished_dialogue

# var lines: Array = []
# var current_line := 0
var is_active := false
var is_typing := false
var full_text := ""
var type_speed := 0.05 # seconds between letters
var prepared: bool = false 

func setup(speaker: String, set_blip: AudioStream = null, portrait: Texture = null) -> void:
	is_active = true
	dialogue_name.text = speaker
	blip = set_blip
	stream_player.stream = blip

	if portrait:
		$Panel/MarginContainer/HBoxContainer3/NPCIcon.texture = portrait


func _ready():
	arrow.visible = false
	pass

func feed(line):
	_show_line(line)

func _show_line(line):
	dialogue_text.text = ""
	is_typing = true
	prepared = false
	_type_text(line)

func _type_text(line: String):
	for i in line.length():
		if blip && line[i] != " ":
			play_sound_with_random_pitch()
		dialogue_text.text += line[i]
		await get_tree().create_timer(type_speed).timeout
		if not is_typing:
			dialogue_text.text = line
			break
	is_typing = false
	prepared = true

func _on_next_pressed():
	if is_typing:
		is_typing = false  # Fast-forward typing
	# else:
	#     current_line += 1
	#     _show_line()

func _input(event):
	if is_active and event.is_action_pressed("interact"):
		_on_next_pressed()

func end_dialogue():
	is_active = false
	emit_signal("finished_dialogue")

func reset_dialogue():
	is_active = false

func _process(delta: float) -> void:
	if prepared:
		arrow.visible = true
	else:
		arrow.visible = false 

func play_sound_with_random_pitch():
	var min_pitch = 0.90
	var max_pitch = 1.1
	stream_player.pitch_scale = randf_range(min_pitch, max_pitch)
	stream_player.play()
