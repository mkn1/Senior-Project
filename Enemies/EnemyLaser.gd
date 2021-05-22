extends Area2D

const speed = 100
var FIRE_RATE : int = 1 # shoots every second

func _ready():
	add_to_group("e_laser")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
