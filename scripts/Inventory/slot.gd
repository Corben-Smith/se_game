extends Panel

var itemName = ""
var itemDes = ""
var itemCost = 0
var itemCount = 0
var hasItem = false
var mouseEntered = false

func _process(delta):
	if hasItem == true:
		get_node("Icon").show()
		get_node("Count").show()
	else:
		get_node("Icon").hide()
		get_node("Count").hide()


func _on_mouse_entered() -> void:
	if hasItem == true:
		print(itemName)
		mouseEntered = true
	

func _on_mouse_exited() -> void:
	mouseEntered = false

func _input(event):
	if event.is_action_pressed("left_mouse"):
		if mouseEntered:
			print("Left click successful")
			get_node("../../ItemInfo/Icon").texture = get_node("Icon").texture
			get_node("../../ItemInfo").itemName = itemName
			get_node("../../ItemInfo").itemDes = itemDes
			get_node("../../ItemInfo").itemCost = itemCost
			get_node("../../ItemInfo").itemCount = itemCount
			get_node("../../ItemInfo").visible = true
			get_node("../../ItemInfo/Anim").play("TransIn")
			get_node("../../ItemInfo").updateInfo()
			#get_node("../../").process_mode = Node.PROCESS_MODE_DISABLED
