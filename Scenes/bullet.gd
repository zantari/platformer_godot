extends Area2D

var direction := 1
@export var speed = 300

func _ready() -> void:
	$Sprite2D.flip_h = direction<0


func _process(delta: float) -> void:
	position.x += speed *direction* delta


func _on_body_entered(body: Node2D) -> void:
	queue_free()
