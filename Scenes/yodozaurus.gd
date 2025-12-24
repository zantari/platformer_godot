extends Area2D

var max_health = 2
var health : float = max_health

var attack_dmg = 7
@export var marker1: Marker2D
@export var marker2: Marker2D
@onready var target = marker2
@onready var player  = get_tree().get_first_node_in_group('Player')
var speed = 35
var forward := true
var notice_radius = 80
func _ready():
	pass

func _process(delta: float) -> void:
	update_health()
	check_death()
	get_target()
	flip_logic()
	position += (target.position - position).normalized() * speed * delta

func flip_logic():
	$AnimatedSprite2D.flip_h = forward
	if position.distance_to(player.position)<notice_radius:
		$AnimatedSprite2D.flip_h = position.x < player.position.x
	
	
var is_waiting = false 

func get_target():
	if is_waiting: return 

	var dist_to_player = position.distance_to(player.position)

	if dist_to_player <= 4:
		target = marker2
		is_waiting = true
		await get_tree().create_timer(0.5).timeout
		
		is_waiting = false
		return 

	
	if forward and position.distance_to(marker2.position) < 10 or \
	   not forward and position.distance_to(marker1.position) < 10:
		forward = !forward

	if dist_to_player < notice_radius:
		target = player
	else:
		target = marker2 if forward else marker1

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("punch"):
		health-=1
	else:
		health -=2
	area.queue_free()
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
	

	
func check_death():
	if health<=0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if 'get_damage' in body:
		body.get_damage(attack_dmg)
		
		
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
			health = health+0.5
