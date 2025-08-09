extends TextureRect

var tween: Tween
var base_y: float

@export var bob_height := 10.0
@export var duration := 1.5

func start_bobbing():
    base_y = global_position.y  # IMPORTANT: use global Y now

    if tween:
        tween.kill()
    tween = create_tween()

    tween.tween_property(self, "global_position:y", base_y - bob_height, duration) \
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(self, "global_position:y", base_y, duration) \
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

    tween.finished.connect(start_bobbing)

func reset_bob_base():
    start_bobbing()

