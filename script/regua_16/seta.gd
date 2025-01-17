extends Sprite


const Parametros_regua = preload("res://script/regua_16/parametros_16.gd")
const a = Parametros_regua.R / (Parametros_regua.cur_max_xregua - Parametros_regua.cur_min_xregua)
const b = -a * Parametros_regua.cur_min_xregua


onready var dragging = false
onready var delta = Vector2(0, 0)

func _ready():
	pass

func _on_area2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		dragging = event.pressed
		if event.pressed:
			delta = event.position - $".".position

func _process(_delta):
	var cur_pos_es = a * $".".position.x + b


	$"../qual_passou".text = "Polegadas inteiras: " + str(floor(cur_pos_es))


	var pos_alinhamento = find_alinhamento(cur_pos_es)


	$"../leitura".text = "Polegadas fracionárias: " + pos_alinhamento + "''"


	if dragging:
		var new_position = get_viewport().get_mouse_position() - delta
		if new_position.x < Parametros_regua.cur_min_xregua:
			new_position.x = Parametros_regua.cur_min_xregua
		if new_position.x > Parametros_regua.cur_max_xregua:
			new_position.x = Parametros_regua.cur_max_xregua
		$".".position.x = new_position.x
		

func find_alinhamento(pos):
	var polegadas = floor(pos)
	var fracao = pos - polegadas


	var numerador = round(fracao * 32)
	var denominador = 32


	var gcd = find_gcd(numerador, denominador)
	numerador /= gcd
	denominador /= gcd

	return str(numerador) + "/" + str(denominador)


func find_gcd(a, b):
	while b != 0:
		var temp = b
		b = fmod(a, b)
		a = temp
	return a
