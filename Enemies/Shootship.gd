extends KinematicBody2D

var player = null # detects player to ram into
var velocity = Vector2.ZERO
var move_speed = 50
var HP = 8
var explosion = preload("res://Player/Explosion.tscn")
var e_laser = preload("res://Enemies/EnemyLaser.tscn")
var fireballPowerup = preload("res://Player/FireballPickup.tscn")
var healthPickup = preload("res://Player/HealthPickup.tscn")
var timer = 0
var FIRE_RATE = 1
var points = 500
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

	timer += delta
	if timer > FIRE_RATE:
		timer = 0
		fire()
	if velocity and velocity.collider.has_method("p_kill"):
		velocity.collider.p_hurt(1)

func fire():
	var las = e_laser.instance()
	get_parent().add_child(las)
	las.global_position = $Firepoint.global_position
	var dir = (get_tree().get_nodes_in_group("player")[0].global_position - global_position)
	las.global_rotation = dir.angle() + PI / 2.0
	las.dir = (get_tree().get_nodes_in_group("player")[0].global_position - global_position).normalized()

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
	var drop_chance = randi() % 10
	if drop_chance == 0:
		var drop = fireballPowerup.instance()
		drop.global_position = global_position
		get_tree().get_root().get_node("World").add_child(drop)
	if drop_chance == 1:
		var drop = healthPickup.instance()
		drop.global_position = global_position
		get_tree().get_root().get_node("World").add_child(drop)
