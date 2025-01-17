extends Control

onready var sprite = $sprite
onready var label = $label
onready var line_edit = $lineedit


var perguntas = [
	{"imagem": "res://imagem/instrumentos/leituras/paq.png", "pergunta": "Qual a leitura correta em polegadas?", "resposta": "1 3/8"},
	{"imagem": "res://imagem/instrumentos/leituras/paq2.png", "pergunta": "Qual a resposta correta em milímetros?", "resposta": "40,00"},
	{"imagem": "res://imagem/instrumentos/leituras/reg.png", "pergunta": "Qual a resposta correta em milímetros?", "resposta": "40"},
	{"imagem": "res://imagem/instrumentos/leituras/reg2.png", "pergunta": "Qual a resposta correta em milímetros?", "resposta": "40,5"},
	{"imagem": "res://imagem/instrumentos/leituras/reg3.png", "pergunta": "Qual a resposta correta em polegadas?", "resposta": "1"},
	{"imagem": "res://imagem/instrumentos/leituras/reg4.png", "pergunta": "Qual a resposta correta em polegadas?", "resposta": "15/32"},
	{"imagem": "res://imagem/instrumentos/leituras/13805.png", "pergunta": "Qual a resposta correta em milímetros?", "resposta": "138,05"},
	{"imagem": "res://imagem/instrumentos/leituras/3106.png", "pergunta": "Qual a resposta correta em milímetros?", "resposta": "31,06"},
	{"imagem": "res://imagem/instrumentos/leituras/485.png", "pergunta": "Qual a resposta correta em milímetros?", "resposta": "48,5"},
	{"imagem": "res://imagem/instrumentos/leituras/60.png", "pergunta": "Qual a resposta correta em milímetros?", "resposta": "60,00"},
	{"imagem": "res://imagem/instrumentos/leituras/59.png", "pergunta": "Qual a resposta correta em milímetros?", "resposta": "59"},
	{"imagem": "res://imagem/instrumentos/leituras/438.png", "pergunta": "Qual a resposta correta em polegadas?", "resposta": "4 3/8"},
]
var indice_atual = 0
var zoom_factor = 1.0 
var initial_distance = 0.0



func _ready():
	embaralhar_perguntas()
	atualizar_pergunta()

func embaralhar_perguntas():
	perguntas.shuffle()

func atualizar_pergunta():
	sprite.texture = load(perguntas[indice_atual].imagem)
	label.text = perguntas[indice_atual].pergunta


func _on_lineedit_text_entered(new_text):
	pass 
	if new_text.strip_edges().to_lower() == perguntas[indice_atual].resposta.strip_edges().to_lower():
		
		indice_atual += 1
		if indice_atual >= perguntas.size():
			
			indice_atual = 0
		
		atualizar_pergunta()
		line_edit.clear() 
		$label2.text = ""
	else:
		$label2.text = "Resposta incorreta!"

func _on_button_button_up():
	pass 

func _input(event):
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP: 
			zoom_imagem(0.1)
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoom_imagem(-0.1)

	elif event is InputEventScreenTouch or event is InputEventScreenDrag:
		if Input.get_touch_count() == 2:
			var touch_1 = get_viewport().get_touch_position(0)
			var touch_2 = get_viewport().get_touch_position(1)
			
			var current_distance = touch_1.distance_to(touch_2)
			
			if event is InputEventScreenDrag and initial_distance > 0:
				var delta = (current_distance - initial_distance) * 0.005 
				zoom_imagem(delta)
			
			initial_distance = current_distance
			
	elif event is InputEventScreenTouch and not event.is_pressed():
		initial_distance = 0.0


func zoom_imagem(delta):
	zoom_factor += delta
	zoom_factor = clamp(zoom_factor, 0.5, 3.0) 
	sprite.rect_scale = Vector2(zoom_factor, zoom_factor)
