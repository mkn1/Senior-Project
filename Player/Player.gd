extends KinematicBody2D

signal player_stats_changed
const MOVE_SPEED = 150
const speedup = 2
onready var invulnerability_timer = $Invuln_Timer
var timer = 0
var slow_time_charge = .15
var slow_time_limit = .75 # roughly 3 seconds of time slow 
var slow_time_cur = .75
var velocity = Vector2.ZERO
var maxHP = 5
var HP = 5
var weaponType = 1 # 1 = default laser, 2 = fireball, 3 = y
var maxHP_Counter = 0 # keeps track of HP level up

var laser = preload("res://Player/DefaultLaser.tscn")
var fireball = preload("res://Player/Fireball.tscn")
var explosion = preload("res://Player/Explosion.tscn")

var dead = false

func _ready():
	emit_signal("player_stats_changed", self)
	add_to_group("player")

func _process(delta):
	look_at(get_global_mouse_position())
	timer += delta
	if not dead and Input.is_action_pressed("shoot"):
		shoot()

func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if (slow_time_cur < slow_time_limit && !Input.is_action_pressed("slow_time")):
		slow_time_cur += (delta * slow_time_charge) 
		emit_signal("player_stats_changed", self)
	if (slow_time_cur < slow_time_limit):
		print(slow_time_cur)
	$AnimatedSprite.play("default")
	if dead:
		return
	var move_vec = Vector2()
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
		#$AnimatedSprite.play("turnLeft")
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
		#$AnimatedSprite.play("turnRight")
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("slow_time"): # fix so force disables button clicked after held down
		slowTime()
		if (slow_time_cur > 0):
			slow_time_cur -= delta
			emit_signal("player_stats_changed", self)
		if (slow_time_cur > delta):
			print(slow_time_cur)
	if Input.is_action_just_released("slow_time"):
		resumeTime()
	if Input.is_action_just_released("speed_boost"):
		resumeTime()
	move_vec = move_vec.normalized() * MOVE_SPEED
	if Input.is_action_pressed("speed_boost"):
		speedTime()
	move_and_collide(delta * move_vec)

func speedTime():
		Engine.time_scale = 1.5

func slowTime():
	if (slow_time_cur > 0):
		Engine.time_scale = 0.25
	else:
		Engine.time_scale = 1
#	slow_time_cur
#		slow_time
#		Engine.time_scale = 1
	
func resumeTime():
	Engine.time_scale = 1

func shoot():
	var weapon = null
	if weaponType == 1:
		weapon = laser.instance()
		if weapon.FIRE_RATE > timer:
			return
		timer = 0
		get_parent().add_child(weapon)
		weapon.transform = $Player.transform
		weapon.position = $FirePoint.global_position
	if weaponType == 2: # fireball
		weapon = fireball.instance()
		if weapon.FIRE_RATE > timer:
			return
		timer = 0
		get_parent().add_child(weapon)
		weapon.transform = $Player.transform
		weapon.global_position = $FirePoint2.global_position
	if weaponType == 3: # homing bullet
		return
	if weaponType == 4: # laser
		return

func fireball_powerup():
	weaponType = 2

func health_pickup():
	if HP < maxHP:
		HP += 1
		emit_signal("player_stats_changed", self)

func p_hurt(dmg):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		invuln()
		HP -= dmg
		emit_signal("player_stats_changed", self)
	invuln()
	#$AnimationPlayer.play("hurt")
	#invuln()
	if HP == 0:
		p_kill()

func levelUp():
	maxHP_Counter += 1
	if maxHP_Counter == 3:
		maxHP += 1
		HP = maxHP
		emit_signal("player_stats_changed", self)
		maxHP_Counter = 0

func invuln():
	modulate.a = .5
	$CollisionShape2D.disabled = true
	$Invuln_Timer.start();

func _on_Invuln_Timer_timeout():
	$CollisionShape2D.disabled = false
	modulate.a = 1

func p_kill():
	var expl = explosion.instance()
	get_tree().get_root().add_child(expl)
	expl.global_position = global_position
	$AnimatedSprite.hide()
	dead = true
