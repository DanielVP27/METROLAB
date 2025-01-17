extends Sprite

var dragging = false
var drag_offset = Vector2.ZERO  

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				var mouse_pos = get_global_mouse_position()
				if is_mouse_over_sprite(mouse_pos):
					dragging = true
					drag_offset = mouse_pos - global_position  
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset  

func is_mouse_over_sprite(mouse_pos):
	var sprite_rect = Rect2(global_position - (texture.get_size() * global_scale) / 2, texture.get_size() * global_scale)
	return sprite_rect.has_point(mouse_pos)


const SNAP_POSITIONS_1 = [282]  
const SNAP_MARGIN = 15  

func _process(_dt):
	
	snap_to_nearest_value()

func snap_to_nearest_value():
	var closest_position = position.x
	var min_distance = SNAP_MARGIN

	for snap_pos in SNAP_POSITIONS_1:
		var distance = abs(position.x - snap_pos)
		if distance < min_distance:
			min_distance = distance
			closest_position = snap_pos

	
	if min_distance < SNAP_MARGIN:
		position.x = closest_position
