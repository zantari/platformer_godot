extends Area2D

var max_health = 20
var health : float = max_health
var direction_x: int = 1
var speed: int = 60 
var dist_view = 120
@onready var player = get_tree().get_first_node_in_group('Player')

var can_move_left: bool = true
var can_move_right: bool = true
var dmg_punch = 16
var can_attack: bool = true
var can_move: bool = true 

const FIREBALL_SCENE = preload("res://Scenes/arrow.tscn")
func _ready() -> void:
	$CooldownBar.max_value = $Fireball_timer.wait_time-0.5

func _process(delta: float) -> void:
	update_health()
	check_death()
	

	if not can_move:
		if $AnimatedSprite2D.animation != "attack":
			$AnimatedSprite2D.play("attack")
		
		
		if not $Fireball_timer.is_stopped():
			$CooldownBar.visible = true
			$CooldownBar.value = $Fireball_timer.time_left
			
		return

	
	if is_instance_valid(player):
		var dist = position.distance_to(player.position)
		
		if dist <= dist_view:
			
			var dir_x = sign(player.position.x - position.x)
			if dir_x != 0:
				$AnimatedSprite2D.flip_h = dir_x > 0
			
			
			if can_attack:
				shoot_fireball(dir_x)
				return
			
			
			if (dir_x > 0 and can_move_right) or (dir_x < 0 and can_move_left):
				position.x += dir_x * speed * delta
				update_animation(dir_x)
			else:
				update_animation(0) 
				
			return 

	
	position.x += speed * direction_x * delta
	$AnimatedSprite2D.flip_h = direction_x > 0
	update_animation(direction_x)

func shoot_fireball(_dir):
	can_attack = false
	can_move = false
	$AnimatedSprite2D.play("attack")
	
	
	$Fireball_timer.start()
	$movement.start()


func _on_animated_sprite_2d_frame_changed() -> void:
	
	if $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.frame == 2:
		var dir = 1
		if is_instance_valid(player):
			dir = sign(player.position.x - position.x)
		else:
			dir = 1 if $AnimatedSprite2D.flip_h else -1
			
		var fireball = FIREBALL_SCENE.instantiate()
		fireball.direction = dir
		fireball.position = position + Vector2(dir * 20, 0) 
		get_parent().add_child(fireball)

func update_animation(dir):
	if dir != 0:
		$AnimatedSprite2D.play("walk") 
	else:
		$AnimatedSprite2D.play("stand")

func _on_movement_timeout() -> void:
	can_move = true 

func _on_fireball_timer_timeout() -> void:
	$CooldownBar.visible = false
	can_attack = true


func update_health():
	var healthbar = $HealthBar
	healthbar.max_value = max_health
	healthbar.value = health
	healthbar.visible = health < max_health

func check_death():
	if health <= 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	print("gracz wszedl")
	if body.has_method("get_damage"):
		body.get_damage(dmg_punch)

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("punch"):
		health -= 4
	else:
		health -= 17
	area.queue_free()
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
	


func _on_border_area_2d_body_entered(_body):
	direction_x *= -1

func _on_left_cliff_area_body_exited(_body):
	can_move_left = false
	direction_x = 1 

func _on_left_cliff_area_body_entered(_body):
	can_move_left = true

func _on_right_cliff_area_body_exited(_body):
	can_move_right = false
	direction_x = -1 

func _on_right_cliff_area_body_entered(_body):
	can_move_right = true

func _on_regin_timer_timeout() -> void:
	if health <= max_health:
		health += 0.3
func get_dmg(dmg):
	health -= dmg
