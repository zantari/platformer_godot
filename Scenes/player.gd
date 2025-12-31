extends CharacterBody2D

var checkpoint :Vector2 = Vector2(277.0, 507.0)

var cooldown = 0.1
var direction_x = 0.0
var facing_right = true
var speed = 100
var jump_height = -300
var can_shoot = true
var healthPlus = 3
var max_health = 20
var has_gun = false
var is_classic_attack=false

signal shoot(pos: Vector2, direction)
signal punch(pos: Vector2, direction)

var health:int = max_health
var vulnerable = true

func _ready() -> void:
	$CooldownBar.visible = false
 
func _process(_delta: float) -> void:
	update_health()
	get_input()
	apply_gravity()
	get_facing_direction()
	get_animation()

	
	velocity.x = direction_x * speed
	
	move_and_slide()
	
	
	
	if !$Timers/Cooldown_punch_timer.is_stopped():
		var timer = $Timers/Cooldown_punch_timer
		var coolDownBar = $CooldownBar
		var left = $Timers/Cooldown_punch_timer.time_left
		coolDownBar.visible = true
		
		
		coolDownBar.max_value = timer.wait_time
		coolDownBar.value = timer.time_left
		
		
		
		
	if !$Timers/Cooldown_gun_timer.is_stopped():
		var timer = $Timers/Cooldown_gun_timer
		var coolDownBar = $CooldownBar
		var left = $Timers/Cooldown_gun_timer.time_left
		coolDownBar.visible = true
		
		
		coolDownBar.max_value = timer.wait_time
		coolDownBar.value = timer.time_left
		
		

func get_input():
	direction_x = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_height
	if Input.is_action_just_pressed("shoot"):
		
		if can_shoot and has_gun:
			shoot.emit(global_position, facing_right)
			can_shoot=false
			$Timers/Cooldown_gun_timer.start()
			$Timers/FireTimer.start()
			$Fire.get_child(facing_right).show()
		elif can_shoot and !has_gun and is_classic_attack == false:
			punch.emit(global_position, facing_right)
			
			is_classic_attack = true
			$AnimatedSprite2D.play("basic_attack")
			can_shoot=false
			$Timers/Cooldown_punch_timer.start()
			$Timers/FireTimer.start()
			$Timers/AttackTimer.start()
			$Attack.get_child(!facing_right).show()
			

	

func get_facing_direction():
	if direction_x != 0:
		facing_right = direction_x >=0

func get_animation():
	var animation = 'idle'
	if is_classic_attack:	
		animation = 'basic_attack'
		
	else:
		
		if not is_on_floor():
			animation = 'jump'
		elif direction_x !=0:
			animation = 'walk'
		if has_gun:
			animation+='_gun'
	
	
	$AnimatedSprite2D.animation = animation
	$AnimatedSprite2D.flip_h = !facing_right

func apply_gravity():
	velocity.y+=10


func _on_cooldown_punch_timer_timeout() -> void:
	$CooldownBar.visible = false
	can_shoot = true
func _on_cooldown_gun_timer_timeout() -> void:
	$CooldownBar.visible = false
	can_shoot = true


func _on_fire_timer_timeout() -> void:
	if has_gun:
		for child in $Fire.get_children():
			child.hide()
	else:
		for child in $Attack.get_children():
			child.hide()
		

func get_damage(dmg):
	
	if vulnerable:
		health -= dmg
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
		tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
		vulnerable = false
		$Timers/invTimer.start()


func _on_inv_timer_timeout() -> void:
	vulnerable = true


func _on_attack_timer_timeout() -> void:
	is_classic_attack = false



func update_health():
	var healthbar = $HealthBar
	healthbar.max_value = max_health
	healthbar.value = health
	if health >= max_health:
		healthbar.visible = false
	else:
		healthbar.visible = true
	if health<0:
		get_tree().call_group('UI', 'add_death')
		
		health = max_health
		position = checkpoint

func _on_regin_timer_timeout() -> void:
	if health<=max_health:
			health = health+healthPlus

func player():
	pass
