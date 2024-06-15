@tool
extends Node

signal progressed(node: BaseNodeData)
signal ended

var current_dialogue: Dialogue = null
var current_node: BaseNodeData = null

func start_dialogue(dialogue: Dialogue):
	current_dialogue = dialogue
	print("dialogue ", dialogue)
	if dialogue.nodes:
		current_node = dialogue.nodes[0]
		print("current_node ", current_node)
		progressed.emit(current_node)

func progress(slot: int):
	var conn = current_dialogue.connections.filter(func(conn):
		return conn.from_node == current_node.guid and conn.from_port == slot
	)

	if conn.size() != 1:
		print("no singular connection found for ", current_node.guid, " and slot ", slot, ", ending dialogue")
		ended.emit()
		return
	
	var to = current_dialogue.nodes.filter(func(n):
		return n.guid == conn[0].to_node
	)

	if to.size() != 1:
		print("no singular node found with name ", conn[0].to_node, ", ending dialogue")
		ended.emit()
		return


	current_node = to[0]
	progressed.emit(current_node)
