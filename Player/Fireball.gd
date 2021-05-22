extends Area2D

const speed = 150
#var fire_time : float = 1.5
var FIRE_RATE : float = .75 # shoots every 3/4 a second
var dir = Vector2()
var explosion = preload("res://Player/LaserExplosion.tscn")
var AOE = preload("res://Player/FireballAOE.tscn")

func _ready():
	add_to_group("laser")

func _process(delta):
	dir = dir.move_toward(get_local_mouse_position(), delta)
	dir = dir.normalized() * speed * delta
	position += dir * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Fireball_body_entered(body):
	var AOE1 = AOE.instance()
	var AOE2 = AOE.instance()
	var AOE3 = AOE.instance()
	if body.is_in_group("enemy"):
		body.hurt(4)
		queue_free()
		get_parent().add_child(AOE1)
		get_parent().add_child(AOE2)
		get_parent().add_child(AOE3)
		AOE1.global_position = $FirePoint.global_position
		AOE2.global_position = $FirePoint2.global_position
		AOE3.global_position = $FirePoint3.global_position
	var expl = explosion.instance()
	get_tree().get_root().add_child(expl)
	expl.global_position = global_position
	queue_free()
