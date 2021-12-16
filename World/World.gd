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
var neededInputKey
var inCombat = false
var combatTurn = -1
var wonAttacks = 0
var doesPlayerAttack

var tFights = ['defend', 'attack']
var nFights
var oFights = []


func _ready():
	arrow_sprite.visible = false
	do_cerb_turn('None')

func turn_manager(type, option):
	if !inCombat:
		create_fights()
	#var matchInput = oFights.pop_back() FOR NORMAL PURPOSE
	var matchInput = 'attack' #For Testing
	
	match matchInput:
		'defend':
			if option == cerb_att:
				take_heal(player, 50, 25, 1)
				take_damage(cerb, 20, player.stats.base_dmg, 2)
				text_status = 'Guarded!'
			else:
				take_damage(player, 60, cerb.stats.base_dmg, 1)
				text_status = 'Missed Guard...'
			do_cerb_turn(text_status)
		
		'attack':
			attack_manager(0)
	check_win()

func attack_manager(status, combat = inCombat):
	print(wonAttacks)
	if !combat:
		inCombat = true
	combatTurn += 1
	neededInputKey = null
	arrow_sprite.visible = false
	timer.stop()
	
	if status > 0: 
		wonAttacks += 1
	
	if combatTurn > 4:
		inCombat = false
		wonAttacks = 0
		combatTurn = -1 
	else: 
		timer.start(randi() % 2 + .1)

func check_win():
	if cerb.stats.health <= 0:
		print('You Win!')
	elif player.stats.health <= 0:
		print('You lose...')

#TODO
func do_attack():
	var keys = dir_keys.duplicate()
	keys.shuffle()
	var direction = keys.pop_front()
	neededInputKey = direction
	pop_key(direction)
	#debug_number += 1
	#print(debug_number)

func pop_key(dir):
	arrow_sprite.visible = true
	arrow_sprite.rotation_degrees = arrow_rotations[dir] 
	timer.start(rand_range(.2, 1))

func create_fights():
	oFights.clear()
	nFights = randi() % 4 + 1
	var fightArray = tFights.duplicate()
	fightArray.shuffle()
	for x in nFights:
		oFights.push_back(fightArray.pop_front())

func _unhandled_input(event):
	if event is InputEventKey && neededInputKey != null:
		if event.is_action_pressed(neededInputKey):
			if inCombat:
				attack_manager(1)

func _on_Timer_timeout():
	if neededInputKey != null:
		attack_manager(0)
	else:
		do_attack()

func do_cerb_turn(status):
	cerb_return = cerb.do_turn()
	cerb_att = cerb_return[0]
	
	#TODO Put tagios
	chance_text.parse_bbcode('Head Chances: ' + str(cerb_return[1]) + ' ' 
	+ str(cerb_return[2]) + ' ' + str(cerb_return[3]) +
	 '\nCerburus Health: ' + str(cerb.stats.health) + '\nHealth: ' 
	+ str(player.stats.health) + '\nStatus: ' + str(status))

func update_text():
	chance_text.parse_bbcode('Head Chances: ' + str(cerb_return[1]) + ' ' 
	+ str(cerb_return[2]) + ' ' + str(cerb_return[3]) +
	 '\nCerburus Health: ' + str(cerb.stats.health) + '\nHealth: ' 
	+ str(player.stats.health) + '\nStatus: ')

func take_damage(who, iRange, base, multiplier):
	who.stats.health -= (randi() % iRange + base) * multiplier

func take_heal(who, iRange, base, multiplier):
	who.stats.health += (randi() % iRange + base) * multiplier
