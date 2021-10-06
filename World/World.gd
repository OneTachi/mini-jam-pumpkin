extends Node

onready var cerb = $Cerb
onready var player = $Player

var cerb_att
var hasCerbDoneTurn = false

func _ready():
	pass

func turn_manager():
	pass

func do_cerb_turn():
	cerb_att = cerb.do_turn()
	hasCerbDoneTurn = true

func do_player_turn():
	if hasCerbDoneTurn == false:
		do_cerb_turn()
	
