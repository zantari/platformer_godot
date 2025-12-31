extends Area2D

var max_health = 5
var health : float = max_health
var direction_x:int = 1
var speed:int = 30 

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("punch"):
		print("gracz zajebal z piesci")
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
	position.x += speed * direction_x * delta
	
func check_death():
	
	if health<=0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if 'get_damage' in body:
		body.get_damage(8)

func _on_border_area_2d_body_entered(body: Node2D) -> void:
	direction_x *= -1
	$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
	


func _on_left_cliff_area_body_exited(body: Node2D) -> void:
	
	direction_x *= -1
	$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h


func _on_right_cliff_area_body_exited(body: Node2D) -> void:
	
	direction_x *= -1
	$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h


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
			health = health+0.1
