extends Area2D

func _ready():
	add_to_group("powerup")
	$AnimatedSprite.play("default")

func _on_HealthPickup_body_entered(body):
	if body.is_in_group("player"):
		body.health_pickup()
		queue_free()
