extends Area2D

const speed = 200
var timer = 0
var dir = Vector2()
var explosion = preload("res://Player/LaserExplosion.tscn")

func _ready():
	add_to_group("laser")

func _process(delta):
	dir = dir.normalized() * speed * delta
	position += dir * speed * delta
	timer += delta
	if timer > .3:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_FireballAOE_body_entered(body):
	if body.is_in_group("enemy"):
		body.hurt(1)
		queue_free()
	var expl = explosion.instance()
	get_tree().get_root().add_child(expl)
	expl.global_position = global_position
	queue_free()
