extends Area2D


var speed = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += sin(Time.get_ticks_msec() / 200.0)*speed*delta


func _on_body_entered(body: Node2D) -> void:
	body.has_gun = true
	queue_free()
