extends Label

func _process(delta):
	text = ("Score: " + str(Global.points))
	if Input.is_action_just_pressed("restart"):
		Global.points = 0
