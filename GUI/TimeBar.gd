extends ColorRect

func _on_Player_player_stats_changed(var player):
	$Bar.rect_size.x = 72 * player.slow_time_cur / player.slow_time_limit
