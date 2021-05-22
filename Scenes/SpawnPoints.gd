extends Node2D

var start_spawn_rate = 4.0
var end_spawn_rate = 1.0 # consider changing to 0
var cur_spawn_rate = start_spawn_rate
var time_til_max_difficulty = 250.0
var spawn_time = 0.0
var game_time = 0.0

onready var spawn_points = $SpawnPoints.get_children()

var block_ship = preload("res://Enemies/Blockship.tscn")
var shoot_ship = preload("res://Enemies/Shootship.tscn")
var ram_ship = preload("res://Enemies/Ramship.tscn")

func _process(delta):
	game_time += delta
	# t acts as variable to raise difficulty as time goes on
	var t = clamp(game_time / time_til_max_difficulty, 0.0, 1.0)
	cur_spawn_rate = lerp(start_spawn_rate, end_spawn_rate, t)
	
	spawn_time += delta
	if spawn_time > cur_spawn_rate:
		spawn_time = 0.0
		spawn()

func spawn():
	for spawn_point in spawn_points:
		if randi() % 3 == 0:
			var ship = null
			#if randi() % 3 == 0:
				#ship = block_ship.instance()
			if randi() % 2 == 0:
				ship = shoot_ship.instance()
			else:
				ship = ram_ship.instance()
			get_tree().get_root().get_node("World").add_child(ship)
			ship.add_to_group("delete_on_restart")
			ship.global_position = spawn_point.global_position
