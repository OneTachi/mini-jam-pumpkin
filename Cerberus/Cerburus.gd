extends KinematicBody2D

var type_of_attack
var total_chance

var stats = {
	'health': 1000
}


#creates type of attack + chances
func do_turn():
	#Creates Chances
	randomize()
	total_chance = 100
	var first_head_chance = randi() % 30 + 20
	total_chance -= first_head_chance
	var second_head_chance = randi() % total_chance
	total_chance -= second_head_chance
	var third_head_chance = total_chance
	
	#Assign value to type_of_attack
	type_of_attack = assign_attack(first_head_chance, second_head_chance, third_head_chance)
	return [type_of_attack, first_head_chance, second_head_chance, third_head_chance]


func assign_attack(first, second, third):
	var roll_of_die = randi() % 100 + 1
	
	if roll_of_die <= first:
		return "first"
	elif roll_of_die <= first + second:
		return "second"
	else:
		return "third"
