extends CanvasLayer

onready var arrow = $line2d
onready var label = $"../label"

func _ready():
	arrow.width = 2
	arrow.default_color = Color(1, 0, 0)  # Vermelho
	label.visible = false

func show_label_and_draw_arrow(label_pos: Vector2, area_pos: Vector2):
	label.position = label_pos
	label.visible = true
	
	arrow.clear_points()
	arrow.add_point(area_pos)
	arrow.add_point(label_pos)
