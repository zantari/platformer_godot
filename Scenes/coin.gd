extends Area2D
var can_collide=true
var speed = 3
var offset = 0.0
func _ready() -> void:

	speed = randf_range(3, 8)
	offset = randf_range(0, 10)


func _process(delta: float) -> void:

	position.y += sin(Time.get_ticks_msec() / 200.0 + offset)*speed*delta



func _on_body_entered(body: Node2D) -> void:
	if can_collide:
		if body.has_method("player"):
			$AudioStreamPlayer2D.pitch_scale = randf_range(1.4, 1.42)
			$AudioStreamPlayer2D.play()
			
			
			get_tree().call_group('UI', 'add_points')

			PlayerData.addMoney(1)

			print(PlayerData.getMoney())
			$Sprite2D.visible = false
			can_collide = false
			await get_tree().create_timer(1.5).timeout

			queue_free()
