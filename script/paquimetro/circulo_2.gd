extends Sprite

var dragging = false
var drag_offset = Vector2.ZERO  # Renamed from offset to avoid conflict

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				var mouse_pos = get_global_mouse_position()
				if is_mouse_over_sprite(mouse_pos):
					dragging = true
					drag_offset = mouse_pos - global_position  # Use renamed variable
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset  # Use renamed variable

func is_mouse_over_sprite(mouse_pos):
	var sprite_rect = Rect2(global_position - (texture.get_size() * global_scale) / 2, texture.get_size() * global_scale)
	return sprite_rect.has_point(mouse_pos)

# Define the allowed snap positions and margin
const SNAP_POSITIONS_1 = [192]  # Add all positions where you want the sprite to snap
const SNAP_MARGIN = 15  # Margin within which the sprite will snap

func _process(_dt):
	# Adjust the position to snap to the nearest value
	snap_to_nearest_value()

func snap_to_nearest_value():
	var closest_position = position.x
	var min_distance = SNAP_MARGIN

	for snap_pos in SNAP_POSITIONS_1:
		var distance = abs(position.x - snap_pos)
		if distance < min_distance:
			min_distance = distance
			closest_position = snap_pos

	# If the minimum distance is less than the margin, adjust the position
	if min_distance < SNAP_MARGIN:
		position.x = closest_position
