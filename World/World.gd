extends Node

onready var cerb = $Cerb
onready var player = $Player
onready var chance_text = $Cerb/Chances
onready var arrow_sprite = $Arrow
onready var timer = $Timer

var cerb_return
var cerb_att
var hasCerbDoneTurn = false
var text_status

var debug_number = 0

var dir_keys = ['ui_left', 'ui_right', 'ui_up', 'ui_down']
var arrow_rotations = {
	'ui_left': 180,
	'ui_right': 0,
	'ui_up': -90,
	'ui_down': 90, 
}
var combat_turn = 0
var neededInputKey
var in_combat = false
var won_combat = 0 

enum {
	guard,
	attack
}

var playerInput

func _ready():
	do_cerb_turn('None')

func turn_manager(type, option):
	playerInput = type
	#print(str(option) + ' ' + str(cerb_att))
	match playerInput:
		'guard':
			if option == cerb_att:
				take_heal(player, 50, 25, 1)
				take_damage(cerb, 20, player.stats.base_dmg, 2)
				text_status = 'Guarded!'
			else:
				take_damage(player, 60, cerb.stats.base_dmg, 1)
				text_status = 'Missed Guard...'
			do_cerb_turn(text_status)
		
		'attack':
			neededInputKey = null
			if combat_turn > 4:
				in_combat = false
				won_combat = 0
				combat_turn = 0
			else:
				do_combat()
				in_combat = true
			
				#TODO After battle stuff
			
			#take_damage(cerb, 20, player.stats.base_dmg,1)
			#take_damage(player, 30, cerb.stats.base_dmg, 1)
			#text_status = "Attacked and hit!"
	check_win()

func do_cerb_turn(status):
	cerb_return = cerb.do_turn()
	cerb_att = cerb_return[0]
	
	#TODO Put tagios
	chance_text.parse_bbcode('Head Chances: ' + str(cerb_return[1]) + ' ' 
	+ str(cerb_return[2]) + ' ' + str(cerb_return[3]) +
	 '\nCerburus Health: ' + str(cerb.stats.health) + '\nHealth: ' 
	+ str(player.stats.health) + '\nStatus: ' + str(status))

func check_win():
	if cerb.stats.health <= 0:
		print('You Win!')
	elif player.stats.health <= 0:
		print('You lose...')

#TODO
func do_combat():
	var keys = dir_keys.duplicate()
	keys.shuffle()
	var direction = keys.pop_front()
	neededInputKey = direction
	pop_key(direction)
	debug_number += 1
	print(debug_number)

func pop_key(dir):
	arrow_sprite.rotation_degrees = arrow_rotations[dir] 
	timer.start(1)

func handle_input(key):
	if !in_combat:
		return
	handle_one_combat_result(null)

func handle_one_combat_result(result):
	combat_turn += 1
	timer.stop()
	if result == 'loss':
		loss_in_combat()
	else:
		win_in_combat()

func loss_in_combat():
	print('L')
	turn_manager('attack', null)

func win_in_combat():
	won_combat += 1
	turn_manager('attack', null)

func take_damage(who, iRange, base, multiplier):
	who.stats.health -= (randi() % iRange + base) * multiplier

func take_heal(who, iRange, base, multiplier):
	who.stats.health += (randi() % iRange + base) * multiplier

func _unhandled_input(event):
	if event is InputEventKey && neededInputKey != null:
		if event.is_action_pressed(neededInputKey):
			handle_input(event)


func _on_Timer_timeout():
	handle_one_combat_result('loss')
