extends State
class_name Shooting_State 

@export var player: Player

@export var Bullet : PackedScene
@export var Shooting_Point: Node2D

var prev: String = ""

func enter(previous_state_path: String, data := {}) -> void:
	var b = Bullet.instantiate()
	get_tree().root.add_child(b)

	# b.damage = player.stats["projectile_damage"]
	# b.speed = player.stats["projectile_speed"]
	b.damage = 10 
	b.speed = 500
	b.direction = player.direction

	b.global_position = player.global_position + (Shooting_Point.position * player.direction.x)
	prev = previous_state_path

func _ready() -> void:
	if !player:
		player = get_parent().get_parent()
	pass


func handle_input(event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	emit_signal("transition", self, prev, {})

func physics_update(_delta: float) -> void:
	handle_horizontal_movement()
	pass

func handle_horizontal_movement():
	var direction := Input.get_axis("Left", "Right")


	if direction != 0:
		player.velocity.x = move_toward(player.velocity.x, direction * player.stats["max_speed"], player.stats["acceleration"])
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.stats["deacceleration"])

func exit() -> void:
	pass
