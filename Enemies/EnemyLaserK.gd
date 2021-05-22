extends KinematicBody2D
var dir = Vector2()
const speed = 100
onready var idleAnimation = $AnimatedSprite.play("default")

func _physics_process(delta):
	var velocity = move_and_collide(dir * delta * speed)

func _process(delta):
	idleAnimation

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.p_hurt(1)
		queue_free()
	if body.is_in_group("env"):
		queue_free()
