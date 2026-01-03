extends Area2D

var max_health = 2
var health : float = max_health
var direction_x:int = 1
var speed:int = 30 


func _on_area_entered(area: Area2D) -> void:
	$AudioStreamPlayer2D.play()
	if area.has_method("punch"):
		health-=1.5
	else:
		health -=3
	
	
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
	
	area.queue_free()

func _process(delta: float) -> void:
	update_health()
	check_death()
	
	var player = get_tree().get_first_node_in_group("Player")
	
	if player:
		
		var dist_x = player.global_position.x - global_position.x
		var target_dir = 0
		
		
		if abs(dist_x) > 5:
			target_dir = sign(dist_x)
		else:
			target_dir = 0 
		
		if target_dir != 0:
			direction_x = target_dir
			$AnimatedSprite2D.flip_h = direction_x < 0
		
		var can_move = true
		
		
		if target_dir == 0:
			can_move = false
		
		
		if direction_x == -1:
			if $LeftCliffArea.get_overlapping_bodies().is_empty():
				can_move = false 
				
		elif direction_x == 1: 
			if $RightCliffArea.get_overlapping_bodies().is_empty():
				can_move = false 
		
		if can_move:
			$AnimatedSprite2D.play("walk")
			position.x += speed * direction_x * delta
		else:
			$AnimatedSprite2D.play("stand")

func check_death():
	if health<=0:
		$AudioStreamPlayer2D.play()
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if 'get_damage' in body:
		body.get_damage(18)
		set_deferred("monitoring", false) 
		await get_tree().create_timer(1.0).timeout
		set_deferred("monitoring", true)


func _on_border_area_2d_body_entered(body: Node2D) -> void:
	pass 

func _on_left_cliff_area_body_exited(body: Node2D) -> void:
	pass

func _on_right_cliff_area_body_exited(body: Node2D) -> void:
	pass

func update_health():
	var healthbar = $HealthBar
	healthbar.max_value = max_health
	healthbar.value = health
	if health >= max_health:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regin_timer_timeout() -> void:
	if health<=max_health:
			health = health+0.3
			
func get_dmg(dmg):
	health = health-dmg
