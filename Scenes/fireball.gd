extends Area2D

var direction := 1
var dmg = 20
@export var speed = 100

func _ready() -> void:
	
	$Sprite2D.flip_h = direction>0
	


func _process(delta: float) -> void:
	position.x += speed *direction* delta
	


func _on_body_entered(body: Node2D) -> void:
	
	if body.has_method("player"):
		
		body.get_damage(dmg)
		queue_free()
		


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("bullet"):
		
		area.queue_free()
		queue_free()
