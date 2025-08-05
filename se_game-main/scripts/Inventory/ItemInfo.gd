extends CanvasLayer

var itemName = ""
var itemDes = ""
var itemCost = 0
var itemCount = 0

func updateInfo():
	get_node("Title").text = itemName
	get_node("Des").text = itemDes + "\nCost: " + str(itemCost)
	

func _on_close_pressed() -> void:
	$Anim.play("TransOut")

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "TransOut":
		#get_node("../").process_mode = Node.PROCESS_MODE_ALWAYS
		self.visible = false

func _on_use_pressed() -> void:
	for i in range(ShopManager.inventory.size()):
		if ShopManager.inventory[i].item.item_name == itemName:
			itemCount -= 1
			if itemCount == 0:
				# Remove item from inventory, then update the inventory
				ShopManager.inventory.remove_at(i)
			else:
				ShopManager.inventory[i].count -= 1
			get_node("../InvContainer").fillInventorySlots()
			break
