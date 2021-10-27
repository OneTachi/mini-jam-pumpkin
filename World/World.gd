extends Node

onready var cerb = $Cerb
onready var player = $Player
onready var chance_text = $Cerb/Chances

var cerb_return
var cerb_att
var hasCerbDoneTurn = false
var text_status

var dir_keys = ['ui_left', 'ui_right', 'ui_up', 'ui_down']

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
		
		'attack':
			take_damage(cerb, 20, player.stats.base_dmg,1)
			take_damage(player, 30, cerb.stats.base_dmg, 1)
			text_status = "Attacked and hit!"
	do_cerb_turn(text_status)
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
	for i in range(5):
		var keys = dir_keys.duplicate()
		keys.shuffle()
		var direction = keys.pop_front()
	


func take_damage(who, iRange, base, multiplier):
	who.stats.health -= (randi() % iRange + base) * multiplier

func take_heal(who, iRange, base, multiplier):
	who.stats.health += (randi() % iRange + base) * multiplier
