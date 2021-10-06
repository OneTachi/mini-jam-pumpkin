extends Node

signal done_turn(type, option)
onready var parent_node = get_node('../World')

var stats = {
	'health': 0,
	'base_dmg': 20
}

func _ready():
	self.connect('done_turn', parent_node, 'turn_manager')

func guard(option):
	if option == null:
		return
	
	emit_signal('done_turn', 'guard', option)
