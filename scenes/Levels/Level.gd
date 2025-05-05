extends Node2D
class_name Level

@export var spawn_point: Node2D 
@export var camera_manager: CameraManager = null

func _ready() -> void:
    if !camera_manager:
        camera_manager = $CameraManager

func get_spawn_point():
    return spawn_point 

func get_camera_manager():
    return camera_manager

