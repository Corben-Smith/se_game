extends Resource 
class_name Interaction

var seq: Array = []
var seq_index: int = 0

signal completed

func next():
	if seq_index >= len(seq):
		completed.emit()
		return

	var e = seq[seq_index]
	e.do()

	seq_index += 1
	if seq_index >= len(seq):
		completed.emit()
		return

func add_to_seq(item: InteractionEvent):
	seq.append(item)
