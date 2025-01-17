extends Sprite

var drag_offset = Vector2.ZERO
onready var dragging = false
onready var delta = Vector2(0, 0)

const xo = 85
const dxe = 135.0 / 16
const dxn = 127.0 / 8
const x_min = -17.0
const x_max = 912
const size_nonio = 9
const size_escala = 150
onready var xon = $".".position.x


const SNAP_POSITIONS = [147, 186, 281]  
const SNAP_THRESHOLD = 10  
const SNAP_SPEED = 1  

func _on_area2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		dragging = event.pressed
		if event.pressed:
			delta = event.position - $".".position

func index_mais_proximo(vetor, valor):
	var delta = 5
	var index = -1
	
	for i in range(vetor.size()):
		var cur_delta = abs(valor - vetor[i])
		if cur_delta < delta:
			delta = cur_delta
			index = i

	return [index, delta]

func acha_alinhamento(va, vb):
	var delta = INF
	var indexA = -1
	var indexB = -1
	
	for i in range(va.size()):
		var ret = index_mais_proximo(vb, va[i])
		if ret[1] < delta:
			delta = ret[1]
			indexA = i
			indexB = ret[0]

	return [indexA, indexB]

func mdc(a, b):
	var R = 0
	while (a % b) > 0:
		R = a % b
		a = b
		b = R
		
	return b

func acha_valor_escala(valor, vetor):
	var ret = 0
	
	for i in range(vetor.size()):
		if vetor[i] > valor:
			ret = i - 1
			break
	
	if ret < 0:
		ret = 0
	
	return ret

func codigo_mateus():
	var vetor_nonio = []
	vetor_nonio.resize(size_nonio)
	for i in range(0, size_nonio):
		vetor_nonio[i] = xo + i * dxn + $".".position.x - xon
	
	var vetor_escala = []
	vetor_escala.resize(size_escala)
	for i in range(0, size_escala):
		vetor_escala[i] = xo + i * dxe
	
	$"../vetor_escala".text = str(vetor_nonio)
	$"../vetor_nonio".text = str(vetor_escala)
	$"../x_tela".text = str(get_viewport().get_mouse_position().x)
	
	var ret = acha_alinhamento(vetor_nonio, vetor_escala)
	
	var pos_nonio = ret[0]
	var pos_escala = ret[1]
	
	$"../index_nonio".text = "index_nonio: " + str(pos_nonio)
	$"../index_escala".text = "index_escala: " + str(pos_escala)
	
	var valor_escala = acha_valor_escala(vetor_nonio[0], vetor_escala)
	
	var numerador = 8 * valor_escala + pos_nonio
	
	if numerador == 0:
		$"../resultado".text = "Leitura: " + "0"
	else:
		var divisor = mdc(numerador, 128)
		
		numerador = numerador / divisor
		var denominador = 128 / divisor

		var inteiro = floor(numerador / denominador)
		var fracionaria = numerador - inteiro * denominador
		
		if inteiro == 0:
			$"../resultado".text = "Leitura: " + str(fracionaria) + "/" + str(denominador) + "''"
		else:
			$"../resultado".text = "Leitura: " + str(inteiro) + " " + str(fracionaria) + "/" + str(denominador) + "''"

func _process(_dt):
	codigo_mateus()
	
	if dragging:
		var new_position = get_viewport().get_mouse_position() - delta
		
		if new_position.x < x_min:
			new_position.x = x_min
			
		if new_position.x > x_max:
			new_position.x = x_max
		

		$".".position.x = lerp($".".position.x, new_position.x, SNAP_SPEED)
		$".".position.x = clamp($".".position.x, x_min, x_max)
		

		position.x = $".".position.x


		if abs($".".position.x - snap_to_nearest($".".position.x)) < SNAP_THRESHOLD:
			$".".position.x = snap_to_nearest($".".position.x)

func snap_to_nearest(value):
	var closest_snap = value
	var min_distance = INF
	
	for snap in SNAP_POSITIONS:
		var distance = abs(value - snap)
		if distance < min_distance:
			min_distance = distance
			closest_snap = snap
	
	return closest_snap
