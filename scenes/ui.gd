extends CanvasLayer

@export var player: CharacterBody2D  # Set this in the Inspector
@onready var hearts = $Hearts.get_children()

func _ready() -> void:
	if player and player.health_component:
		player.health_component.health_changed.connect(update_hearts)
		update_hearts(player.health_component.get_health())
	else:
		push_warning("HealthComponent or Player not found!")

func update_hearts(current_health: int) -> void:
	print("🧠 update_hearts CALLED | Current Health:", current_health)
	for i in range(hearts.size()):
		print("🔍 Checking heart index:", i)
		
		var heart_sprite = hearts[i].get_node("AnimatedSprite2D")
		if heart_sprite:
			print("🎞️ Found AnimatedSprite2D in heart", i)

			if i < current_health:
				print("❤️ Playing 'full' animation on heart", i)
				heart_sprite.play("full")
			else:
				print("💔 Playing 'empty' animation on heart", i)
				heart_sprite.play("empty")
		else:
			print("⚠️ No AnimatedSprite2D found in heart", i)
