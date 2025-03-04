extends CharacterBody2D

const SPEED = 300.0
const initalJumpForce = -150.0
const jumpPower = -300.0
const jumpTimerThreshold = 0.1
const coyoteFrames = 6

var last_floor = false
var jumping = false
var coyote = false

var jumpVelocity:float = 0.0
var jumpTimer:float = 0.0

func _ready() -> void:
	$CoyoteTimer.wait_time = coyoteFrames / 60.0
	print($CoyoteTimer.wait_time)


func _physics_process(delta: float) -> void:
	

	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)

	if is_on_floor():
		jumpTimer = 0.0
		coyote = false
		jumping = false

	if not is_on_floor() && !coyote:
		velocity += get_gravity() * delta

	if not is_on_floor() and last_floor and not jumping:
		coyote = true
		print("timer started")
		$CoyoteTimer.start()	

	print("is on floor: %s" % is_on_floor())
	if Input.is_action_just_pressed("Fire") and (is_on_floor() or coyote):
		print("just jumped")
		velocity.y = initalJumpForce - abs(direction / 3) 
		jumpVelocity = jumpPower
		jumping = true
		coyote = false

	if (Input.is_action_pressed("Fire") && jumping && jumpTimer < jumpTimerThreshold):
		velocity.y = jumpVelocity
		jumpTimer += delta
	
	if (!Input.is_action_pressed("Fire") && is_on_floor()):
		jumpTimer = 0.0
		jumpVelocity = 0.0


	move_and_slide()
	last_floor = is_on_floor()
	print(coyote)



func _on_coyote_timer_timeout() -> void:
	print("timer ended")
	coyote = false
