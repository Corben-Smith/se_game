extends Area2D

var floating = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	print("mewo")
	if body.is_in_group("player"):
		print("mewo")
		PersistentManager.save_data()
		PersistentManager.checkpoint = self

		indicate()

@onready var tween = create_tween()

func indicate() -> void:
	tween = create_tween()
	var spr = self.get_node("AnimatedSprite2D") as AnimatedSprite2D

	var original_y = position.y
	# Create an infinite bobbing loop
	tween.set_loops()  # Infinite loop
	tween.tween_property(self, "position:y", original_y - bob_height, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", original_y, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


# Customize these
@export var bob_height := 20.0     # How far to move up/down
@export var duration := 1.5        # Duration for one direction (up or down)
@export var delay := 0.0           # Optional delay between bobs
