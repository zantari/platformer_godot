extends Node2D

const bullet_scene: PackedScene = preload("res://Scenes/bullet.tscn")
const punch_scene: PackedScene = preload("res://Scenes/punch.tscn")

func _ready() -> void:
	get_tree().call_group('UI', 'setCurrLevel', 2)

func _on_player_shoot(pos: Vector2, facing_right) -> void:
	
	var bullet = bullet_scene.instantiate()
	var direction = 1 if facing_right else -1
	bullet.direction = direction
	$Bullets.add_child(bullet)
	bullet.position = pos + Vector2(7 * direction, 0)
	


func _on_player_punch(pos: Vector2, facing_right) -> void:
	var punch = punch_scene.instantiate()
	var direction = 1 if facing_right else -1
	punch.direction = direction
	$".".add_child(punch)
	punch.position = pos + Vector2(7 * direction, 0)
	


func _on_water_zone_body_entered(body: Node2D) -> void:
	
	if 'get_damage' in body:
		body.get_damage(1000)
		


func _on_portal_body_entered(body: Node2D) -> void:
	
	if body.has_method("player"):	
		body.set_physics_process(false)
		
		var tween = create_tween().set_parallel(true)
		
		
		var duration = randf_range(0.6, 1.2)
		
		
		var random_pos = global_position + Vector2(randf_range(-5, 5), randf_range(-5, 20))
		tween.tween_property(body, "global_position", random_pos, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		
		
		var random_rot = deg_to_rad(randf_range(360, 1200) * [-1, 1].pick_random())
		tween.tween_property(body, "rotation", random_rot, duration)
		
		# Reszta standardowo
		tween.tween_property(body, "scale", Vector2.ZERO, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_property(body, "modulate:a", 0.0, duration)

		await tween.finished
		if PlayerData.getLevel()<2:
			PlayerData.addLevel()
		get_tree().change_scene_to_file("res://Scenes/won.tscn")
