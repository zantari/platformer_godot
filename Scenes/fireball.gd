extends Area2D

var direction := 1
var dmg = 20
var speed = 100

func _ready() -> void:
	
	$Sprite2D.flip_h = direction>0
	


func _process(delta: float) -> void:
	position.x += 100*direction*delta
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		var diff_x = player.global_position.x - global_position.x
		var diff_y = player.global_position.y - global_position.y
		
		if abs(diff_x) <= 30 and abs(diff_y) <= 50:
			if not $AudioStreamPlayer2D.playing:
				$AudioStreamPlayer2D.pitch_scale = randf_range(1.7, 1.8)
				$AudioStreamPlayer2D.play()
	
	


func _on_body_entered(body: Node2D) -> void:
	
	if body.has_method("player"):
		
		body.get_damage(dmg)
		queue_free()
		


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("bullet"):
		
		area.queue_free()
		queue_free()
