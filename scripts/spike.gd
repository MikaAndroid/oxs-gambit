extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.has_method("die"):
		print("Player terkena spike!")
		body.die()
