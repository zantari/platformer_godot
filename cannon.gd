extends Area2D
const FIREBALL_SCENE = preload("res://Scenes/fireball.tscn")
@onready var player  = get_tree().get_first_node_in_group('Player')
var max_health = 10
var health = 10
var can_attack= true
var dist_view = 200

func _process(delta: float) -> void:
	update_health()
	check_death()
	if !$Fireball_timer.is_stopped():
		var timer = $Fireball_timer
		var coolDownBar = $CooldownBar
		var left = $Fireball_timer.time_left
		coolDownBar.max_value = $Fireball_timer.wait_time
		coolDownBar.visible = true
		
		
		coolDownBar.max_value = timer.wait_time
		coolDownBar.value = timer.time_left
	
	var current_dir = 0.0 
		
	if player:
		var dist = position.distance_to(player.position)
		var dir_x = sign(player.position.x - position.x)
			
		if dist <= dist_view:
		
			$Sprite2D.flip_h = dir_x > 0
			if can_attack:
				shoot_fireball(dir_x)
			
			return
	
	
	
	if !$Fireball_timer.is_stopped():
		var timer = $Fireball_timer
		var coolDownBar = $CooldownBar
		var left = $Fireball_timer.time_left
		coolDownBar.max_value = $Fireball_timer.wait_time
		coolDownBar.visible = true
		
		
		coolDownBar.max_value = timer.wait_time
		coolDownBar.value = timer.time_left




func _on_area_entered(area: Area2D) -> void:
	if area.has_method("punch"):
		
		health-=1
	else:
		health -=1.2
	
	area.queue_free()
	var tween = create_tween()
	tween.tween_property($Sprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($Sprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)

func _on_fireball_timer_timeout() -> void:
	$CooldownBar.visible = false
	can_attack = true
	
func shoot_fireball(dir):
	can_attack = false
	$Fireball_timer.start()
	$CooldownBar.visible = true
	var fireball = FIREBALL_SCENE.instantiate()
	fireball.direction = dir
	fireball.position = position + Vector2(dir * 3, 0) 
	get_parent().add_child(fireball)
	
	
	
func update_health():
	var healthbar = $HealthBar
	healthbar.max_value = max_health
	healthbar.value = health
	if health >= max_health:
		healthbar.visible = false
	else:
		healthbar.visible = true
func check_death():
	
	if health<=0:
		queue_free()
