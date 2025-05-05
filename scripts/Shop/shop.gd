extends CanvasLayer

var currentItem = 0
var select = 0


func _on_close_pressed() -> void:
	$Anim.play("TransOut")


func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "TransOut":
		get_tree().paused = false
		self.visible = false

func switchItem(select):
	for i in range(ShopManager.items.size()):
		if select == i:
			currentItem = select
			get_node("Control/Name").text = ShopManager.items[currentItem]["Name"]
			get_node("Control/Des").text = ShopManager.items[currentItem]["Des"]
			get_node("Control/Des").text += "\nCost: " + str(ShopManager.items[currentItem]["Cost"])
			get_node("Control/Sprite2D").texture = ShopManager.items[currentItem]["Icon"]
			print(ShopManager.items[currentItem])


func _on_next_pressed() -> void:
	switchItem(currentItem + 1)

func _on_prev_pressed() -> void:
	switchItem(currentItem - 1)


func _on_buy_pressed() -> void:
	var hasItem = false
	if ShopManager.gold > ShopManager.items[currentItem]["Cost"]:
		for i in ShopManager.inventory:
			if ShopManager.inventory[i]["Name"] == ShopManager.items[currentItem]["Name"]:
				ShopManager.inventory[i]["Count"] += 1
				hasItem = true
		if hasItem == false:
			var tempDic = ShopManager.items[currentItem]
			tempDic["Count"] = 1
			ShopManager.inventory[ShopManager.inventory.size()] = tempDic
		ShopManager.gold -= ShopManager.items[currentItem]["Cost"]
	print(ShopManager.inventory)
	
