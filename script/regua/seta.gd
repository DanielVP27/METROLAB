extends Sprite
const Parametros_regua = preload("res://script/regua/parametros_regua.gd")

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
	
	var vetor_cur = [cur_pos_es]
	for tick in range(0, Parametros_regua.cur_num_div):
		vetor_cur.append(vetor_cur[tick] + Parametros_regua.cur_dx_mm)
		
	
	
	var pos_alinhamento = find_alinhamento(vetor_cur)

	var leitura = floor(cur_pos_es) + pos_alinhamento * Parametros_regua.cur_resregua
	$"../leitura".text = "Leitura: " + str(leitura) + " mm"

func _process(_dt):
	escala_05()
	
	if dragging:
		var new_position = get_viewport().get_mouse_position() - delta
		
		if new_position.x < Parametros_regua.cur_min_xregua:
			new_position.x = Parametros_regua.cur_min_xregua
			
		if new_position.x > Parametros_regua.cur_max_xregua:
			new_position.x = Parametros_regua.cur_max_xregua
		
		$".".position.x = new_position.x
		
func find_alinhamento(vetor):
	var index_min = -1;
	var delta_min = INF;
	
	for i in range(len(vetor)):
		var x = vetor[i]
		var y = round(vetor[i])
		var diff = abs(x - y)
		if diff < delta_min:
			index_min = i;
			delta_min = diff;
		
	assert(index_min != -1)
	
	return index_min
