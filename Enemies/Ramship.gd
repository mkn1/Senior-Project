extends KinematicBody2D

var player = null # initialize player to ram into
var velocity = Vector2.ZERO
var move_speed = 100
var HP = 5
var points = 100
var explosion = preload("res://Player/Explosion.tscn")
var healthPickup = preload("res://Player/HealthPickup.tscn")
onready var idleAnimation = $AnimatedSprite.play("default")

func _ready():
	add_to_group("enemy")

func _physics_process(delta):
	idleAnimation
	velocity = Vector2.ZERO
	face_player()
	
	if player != null:
		velocity = position.direction_to(player.global_position) * move_speed
	
	velocity = velocity.normalized()
	velocity = move_and_collide(velocity * move_speed * delta)
	if velocity and velocity.collider.has_method("p_kill"):
		velocity.collider.p_hurt(1)

func face_player():
	var dir = (get_tree().get_nodes_in_group("player")[0].global_position - global_position)
	self.global_rotation = dir.angle() + PI / 2.0

func hurt(dmg):
	HP -= dmg
	if HP <= 0:
		kill()

func kill():
	var expl = explosion.instance()
	get_tree().get_root().add_child(expl)
	expl.global_position = global_position
	drop()
	queue_free()
	Global.points += points

func _on_Area2D_area_entered(body):
	if body.name == "Player":
		player = body

func drop():
	var drop_chance = randi() % 20
	if drop_chance == 0:
		var drop = healthPickup.instance()
		drop.global_position = global_position
		get_tree().get_root().get_node("World").add_child(drop)
