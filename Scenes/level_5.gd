extends Node2D
const bullet_scene: PackedScene = preload("res://Scenes/bullet.tscn")
const punch_scene: PackedScene = preload("res://Scenes/punch.tscn")

func _ready() -> void:
	get_tree().call_group('UI', 'setCurrLevel', "COMING SOON")
func _on_killzone_body_entered(body: Node2D) -> void:
	if 'get_damage' in body:
		
		body.get_damage(1000)


func _on_back_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Scenes/won.tscn")


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
	
