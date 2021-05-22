extends KinematicBody2D

var entity = null # detects player to ram into
var velocity = Vector2.ZERO
var move_speed = 800
var HP = 10
var explosion = preload("res://Player/Explosion.tscn")
onready var idleAnimation = $AnimatedSprite.play("default")
onready var dir = (get_tree().get_nodes_in_group("player")[0].global_position - global_position)

func _ready():
	add_to_group("enemy")

func _physics_process(delta):
	idleAnimation
	velocity = Vector2.ZERO
	face_player()
	
	if entity != null:
		velocity = position.direction_to(entity.global_position) * move_speed
	
	velocity = velocity.normalized()
	velocity = move_and_collide(velocity * move_speed * delta)
	if velocity and velocity.collider.has_method("p_kill"):
		velocity.collider.p_hurt(1)

func hurt(dmg):
	HP -= dmg
	if HP <= 0:
		kill()

func face_player():
	var dir = (get_tree().get_nodes_in_group("player")[0].global_position - global_position)
	self.global_rotation = dir.angle() + PI / 2.0

func kill():
	var expl = explosion.instance()
	get_tree().get_root().add_child(expl)
	expl.global_position = global_position
	queue_free()

func _on_Area2D_area_entered(body):
	if body.is_in_group("laser"):
		move_speed = 800
		entity = body
	elif body.name == "Player":
		move_speed = 120
		entity = body
