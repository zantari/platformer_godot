extends Node2D
var levels = ["res://Scenes/level_1.tscn", "res://Scenes/LevelBG.tscn", "res://Scenes/level_3.tscn","res://Scenes/level_4.tscn" ]
func _ready() -> void:
	get_tree().call_group('UI', 'setPoints', PlayerData.getMoney())
	
	get_tree().call_group('UI', 'setCurrLevel', PlayerData.getLevel()+1)

func transition(body, level):
	body.set_physics_process(false)
		
	var tween = create_tween().set_parallel(true)
		
		
	var duration = randf_range(0.2, 1.2)
		
		
	var random_pos = global_position + Vector2(randf_range(-10, 10), randf_range(-10, 10))
	tween.tween_property(body, "global_position", random_pos, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		
		
	var random_rot = deg_to_rad(randf_range(360, 1200) * [-1, 1].pick_random())
	tween.tween_property(body, "rotation", random_rot, duration)
		
		# Reszta standardowo
	tween.tween_property(body, "scale", Vector2.ZERO, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(body, "modulate:a", 0.0, duration)

	await tween.finished
	get_tree().change_scene_to_file(levels[level])
	

func _on_level_1_body_entered(body: Node2D) -> void:
	if body.has_method("player"):	
		var levelId = 0
		transition(body, levelId)
		


func _on_level_2_body_entered(body: Node2D) -> void:
	if body.has_method("player"):	
		var levelId = 1
		transition(body, levelId)


func _on_level_3_body_entered(body: Node2D) -> void:
	if body.has_method("player"):	
		var levelId = 2
		transition(body, levelId)


func _on_level_4_body_entered(body: Node2D) -> void:
	if body.has_method("player"):	
		var levelId = 3
		transition(body, levelId)
