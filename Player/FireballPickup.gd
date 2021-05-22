extends Area2D

func _ready():
	add_to_group("powerup")
	$AnimatedSprite.play("default")

func _on_FireballPickup_body_entered(body):
	if body.is_in_group("player"):
		body.fireball_powerup()
		body.levelUp()
		queue_free()
