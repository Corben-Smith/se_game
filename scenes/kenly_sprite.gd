extends Sprite2D

@onready var tween = create_tween()

# Customize these
@export var bob_height := 10.0     # How far to move up/down
@export var duration := 1.5        # Duration for one direction (up or down)
@export var delay := 0.0           # Optional delay between bobs

func _ready():
	start_bobbing()

func start_bobbing():
	var original_y = position.y
	# Create an infinite bobbing loop
	tween.set_loops()  # Infinite loop
	tween.tween_property(self, "position:y", original_y - bob_height, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", original_y, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
