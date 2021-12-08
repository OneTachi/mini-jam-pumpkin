extends RichTextLabel

onready var parent_timer = $'../../Timer'

var timer_is_on = false

#Inefficent but lets run with it for now
func _physics_process(delta):
	var times = parent_timer.get_time_left()
	self.text = str(times)
