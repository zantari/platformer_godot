extends Area2D

var max_health = 30
var health : float = max_health
var direction_x:int = 1
var speed:int = 30 
@onready var player  = get_tree().get_first_node_in_group('Player')
var follow_distance: int = 420
var is_following: bool = false
var can_move_left: bool = true
var can_move_right: bool = true
var dmg_punch = 15
var can_attack: bool = true
var can_move = true
var dist_view = 120

const FIREBALL_SCENE = preload("res://Scenes/fireball.tscn")


func _on_area_entered(area: Area2D) -> void:
	print("a;")
	if area.has_method("punch"):
		
		health-=1
	else:
		health -=3
	
	area.queue_free()
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
	
func _process(delta: float) -> void:
	update_health()
	check_death()
	if can_move:
	
		var current_dir = 0.0 
		
		if player:
			var dist = position.distance_to(player.position)
			var dir_x = sign(player.position.x - position.x)
			
			if dist <= dist_view:
		
				$AnimatedSprite2D.flip_h = dir_x > 0
				if can_attack:
					shoot_fireball(dir_x)
				if (dir_x > 0 and can_move_right) or (dir_x < 0 and can_move_left):
					position.x += dir_x * speed * delta
					current_dir = dir_x 
				
				update_animation(current_dir)
				return
		
		
		position.x += speed * direction_x * delta
		$AnimatedSprite2D.flip_h = direction_x > 0
		current_dir = direction_x
		
		update_animation(current_dir)
	else:
		$AnimatedSprite2D.play("attack")
	
	
	if !$Fireball_timer.is_stopped():
		var timer = $Fireball_timer
		var coolDownBar = $CooldownBar
		var left = $Fireball_timer.time_left
		coolDownBar.max_value = $Fireball_timer.wait_time
		coolDownBar.visible = true
		
		
		coolDownBar.max_value = timer.wait_time
		coolDownBar.value = timer.time_left

func shoot_fireball(dir):
	can_attack = false
	$Fireball_timer.start()
	$CooldownBar.visible = true
	var fireball = FIREBALL_SCENE.instantiate()
	fireball.direction = dir
	fireball.position = position + Vector2(dir * 3, 0) 
	get_parent().add_child(fireball)
	can_move = false
	$movement.start()
	$AnimatedSprite2D.play("attack")
	
	
	
func update_animation(dir):
	if dir != 0:
		$AnimatedSprite2D.play("walk") 
	else:
		
		$AnimatedSprite2D.play("stand")
	
func check_death():
	
	if health<=0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if 'get_damage' in body:
		body.get_damage(dmg_punch)

func _on_border_area_2d_body_entered(body: Node2D) -> void:
	direction_x *= -1
	$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
	


func _on_left_cliff_area_body_exited(_body):
	can_move_left = false
	is_following = false
	direction_x = 1 
	$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h

func _on_left_cliff_area_body_entered(_body):
	can_move_left = true

func _on_right_cliff_area_body_exited(_body):
	is_following = false
	can_move_right = false
	direction_x = -1 
	$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h

func _on_right_cliff_area_body_entered(_body):
	can_move_right = true


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
			health = health+3


func _on_fireball_timer_timeout() -> void:
	$CooldownBar.visible = false
	can_attack = true


func _on_movement_timeout() -> void:
	can_move = true
