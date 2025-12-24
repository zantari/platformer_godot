extends Camera2D
var base_res = Vector2(1600, 900)
var base_zoom = 6.0

func _process(_delta):
	var current_res = get_viewport().get_visible_rect().size
	# Liczymy stosunek obecnej szerokości do bazowej
	var scale_factor = current_res.x / base_res.x
	
	# Ustawiamy zoom (im większy ekran, tym większy mnożnik zooma)
	var new_zoom = base_zoom * scale_factor
	zoom = Vector2(new_zoom, new_zoom)
