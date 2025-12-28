extends Area2D
var direction := 1


func _ready() -> void:
	$Sprite2D.flip_h = direction<0
	print("punch!")
func _on_durability_timeout() -> void:
	queue_free()

func punch():
	pass
