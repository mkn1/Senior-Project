extends Area2D

const speed = 150
#var fire_time : float = 1.5
var FIRE_RATE : float = .20 # shoots every 1/5 a second
var dir = Vector2()
var explosion = preload("res://Player/LaserExplosion.tscn")
#onready var mouse_pos = null

func _ready():
	add_to_group("laser")
#	mouse_pos = get_local_mouse_position()

#   homing onto mouse
#   dir = dir.move_toward(get_local_mouse_position(), delta)
#	dir = dir.normalized() * speed * delta
#	position += dir * speed * delta

func _process(delta):
	dir = dir.move_toward(get_local_mouse_position(), delta)
	dir = dir.normalized() * speed * delta
	position += dir * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_DefaultLaser_body_entered(body):
	if body.is_in_group("enemy"):
		body.hurt(1)
		queue_free()
	var expl = explosion.instance()
	get_tree().get_root().add_child(expl)
	expl.global_position = global_position
	queue_free()
