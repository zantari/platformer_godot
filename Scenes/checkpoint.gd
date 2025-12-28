extends Area2D



func _on_body_entered(body: Node2D) -> void:
	
	if body.has_method("player"):
		body.checkpoint = Vector2(position.x, position.y-50)
		
