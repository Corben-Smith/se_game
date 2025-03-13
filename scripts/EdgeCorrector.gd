extends Node2D
class_name EdgeCorrector

@export var left_inner: RayCast2D = self.get_node_or_null("Left Inner")
@export var left_outer: RayCast2D = self.get_node_or_null("Left Outer")
@export var right_inner: RayCast2D = self.get_node_or_null("Right Inner")
@export var right_outer: RayCast2D = self.get_node_or_null("Right Outer")

@export var actor: Node2D = self.get_parent()

func _ready() -> void:
    left_outer.add_exception(actor)
    left_inner.add_exception(actor)
    right_outer.add_exception(actor)
    right_inner.add_exception(actor)

func _physics_process(delta: float) -> void:
    if left_outer.is_colliding() && !left_inner.is_colliding():
        print("moving left")
        actor.global_position.x += 4
        
    if right_outer.is_colliding() && !right_inner.is_colliding():
        print("moving right")
        actor.global_position.x -= 4
