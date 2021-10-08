extends Node

onready var cerb = $Cerb
onready var player = $Player
onready var chance_text = $Cerb/Chances

var cerb_return
var cerb_att
var hasCerbDoneTurn = false

enum {
	guard,
	attack
}

var playerInput

func _ready():
	do_cerb_turn()

func turn_manager(type, option):
	playerInput = type
	
	match playerInput:
		
		guard:
			if option == cerb_att:
				player.stats.health += randomizeFunction(50, 25, 1)
				cerb.stats.health -= randomizeFunction(20, player.stats.base_dmg, 2)
				do_cerb_turn() 
		
		attack:
			pass

func do_cerb_turn():
	cerb_return = cerb.do_turn()
	cerb_att = cerb_return[0]
	print([cerb_return])
	hasCerbDoneTurn = true
	
	#TODO Put tagios
	chance_text.parse_bbcode(str(cerb_return[1]) + ' ' + str(cerb_return[2]) + ' ' + str(cerb_return[3]))

func do_player_turn():
	if hasCerbDoneTurn == false:
		do_cerb_turn()
	

func randomizeFunction(iRange, base, multiplier):
	return ((randi() % iRange + base) * multiplier)
