extends Area2D
class_name CameraZone

@export var pos: Node2D
var zoom: Vector2
@export var zoom_x: float = 1.0
@export var zoom_y: float = 1.0

signal player_entered(pos)
signal player_exited(pos)


func _ready() -> void:
    zoom.x = zoom_x
    zoom.y = zoom_y

    if !pos:
        if $CameraPosition:
            pos = $CameraPosition
        else:
            push_error("no pos specified or found")


func _on_body_entered(body:Node2D) -> void:
    if body.is_in_group("player"):
        emit_signal("player_entered", self)

func _on_body_exited(body:Node2D) -> void:
    if body.is_in_group("player"):
        emit_signal("player_exited", self)

