extends InteractionEvent 
class_name Line

var contents: String = ""

func do(context: Dictionary = {}):
	box.feed(context.get)
