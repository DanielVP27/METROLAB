extends Sprite
const Parametros_regua = preload("res://script/regua_05/parametros_regua05.gd")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var dragging = false
onready var delta = Vector2(0, 0)

const a = Parametros_regua.R / (Parametros_regua.cur_max_xregua - Parametros_regua.cur_min_xregua)
const b = - a * Parametros_regua.cur_min_xregua

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_area2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		dragging = event.pressed
		if event.pressed:
			delta = event.position - $".".position
			
func escala_05():
	var cur_pos_es = a * $".".position.x + b

	$"../qual_passou".text = "passou de: " + str(floor(cur_pos_es))

	var pos_alinhamento = find_alinhamento(cur_pos_es)

	var leitura = floor(cur_pos_es) + pos_alinhamento * 0.5 
	if pos_alinhamento == 0.5:
		leitura = floor(cur_pos_es) + 0.5


	var leitura_str = str("%0.1f" % leitura).replace(".", ",")
	$"../leitura".text = "Leitura: " + leitura_str + " mm"

func _process(_dt):
	escala_05()
	
	if dragging:
		var new_position = get_viewport().get_mouse_position() - delta
		
		if new_position.x < Parametros_regua.cur_min_xregua:
			new_position.x = Parametros_regua.cur_min_xregua
			
		if new_position.x > Parametros_regua.cur_max_xregua:
			new_position.x = Parametros_regua.cur_max_xregua
		
		$".".position.x = new_position.x
		
func find_alinhamento(pos):
	var valor_inteiro = floor(pos)
	var fracao = pos - valor_inteiro

	if fracao <= 0.25:
		return 0
	elif fracao >= 0.75:
		return 1
	else:
		return 0.5
