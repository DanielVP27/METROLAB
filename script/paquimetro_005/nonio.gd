extends Sprite

const Parametros = preload("res://script/paquimetro_005/parametros_005.gd")

onready var dragging = false
onready var delta = Vector2(0, 0)
const SNAP_POSITIONS = [411, 444, 539]  
const SNAP_THRESHOLD = 10  
const SNAP_SPEED = 1  

const a = Parametros.F / (Parametros.cur_max_x - Parametros.cur_min_x)
const b = -a * Parametros.cur_min_x

func _on_area2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		dragging = event.pressed
		if event.pressed:
			delta = event.position - $".".position

func _process(_dt):
	var cur_pos_es = a * $".".position.x + b
	
	$"../vetor_escala".text = "passou de: " + str(floor(cur_pos_es))
	
	var vetor_cur = [cur_pos_es]
	for tick in range(0, Parametros.cur_num_div):
		vetor_cur.append(vetor_cur[tick] + Parametros.cur_dx_mm)
		
	$"../vetor_nonio".text = "cur: " + str(vetor_cur)
	
	var pos_alinhamento = find_alinhamento(vetor_cur)

	var leitura = floor(cur_pos_es) + pos_alinhamento * Parametros.cur_res
	var leitura_str = "%0.2f" % leitura  
	$"../resultado".text = "Leitura: " + leitura_str.replace(".", ",") + " mm"
	
	if dragging:
		var new_position = get_viewport().get_mouse_position() - delta
		
		if new_position.x < Parametros.cur_min_x:
			new_position.x = Parametros.cur_min_x
			
		if new_position.x > Parametros.cur_max_x:
			new_position.x = Parametros.cur_max_x
		

		$".".position.x = lerp($".".position.x, new_position.x, SNAP_SPEED)
		$".".position.x = clamp($".".position.x, Parametros.cur_min_x, Parametros.cur_max_x)


		if abs($".".position.x - snap_to_nearest($".".position.x)) < SNAP_THRESHOLD:
			$".".position.x = lerp($".".position.x, snap_to_nearest($".".position.x), SNAP_SPEED)

func snap_to_nearest(value):
	var closest_snap = value
	var min_distance = INF
	
	for snap in SNAP_POSITIONS:
		var distance = abs(value - snap)
		if distance < min_distance:
			min_distance = distance
			closest_snap = snap
	
	return closest_snap

func find_alinhamento(vetor):
	var index_min = -1
	var delta_min = INF
	
	for i in range(len(vetor)):
		var x = vetor[i]
		var y = round(vetor[i])
		var diff = abs(x - y)
		if diff < delta_min:
			index_min = i
			delta_min = diff
		
	assert(index_min != -1)
	
	return index_min
