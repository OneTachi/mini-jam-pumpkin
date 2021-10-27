extends Node

signal done_turn(type, option)
onready var parent_node = get_node('/root/World')

var type_of_attack = null
var head_input = null

var stats = {
	'health': 500,
	'base_dmg': 20
}

func input_manager(option, number = head_input):
	type_of_attack = option
	head_input = number
	
	if (type_of_attack != null && head_input != null) || (type_of_attack == 'attack'):
		parent_node.turn_manager(type_of_attack, head_input)
		type_of_attack = null
		head_input = null


#Inputs
func guard_input():
	input_manager('guard')
func attack_input():
	input_manager('attack')
func head_one_input():
	input_manager(type_of_attack, 'first')
func head_two_input():
	input_manager(type_of_attack, 'second')
func head_three_input():
	input_manager(type_of_attack, 'third')
