extends Control

# Referência ao Label
onready var label = $label

# Velocidade do movimento do texto
var speed = 100.0

# Posição inicial fora da tela
var start_y: float

func _ready():
	# Armazena a posição inicial do Label
	start_y = rect_size.y + label.rect_size.y
	label.rect_position.y = start_y

func _process(delta: float):
	# Move o Label para cima
	label.rect_position.y -= speed * delta
	
	# Quando o Label sair da tela, reseta sua posição para baixo novamente
	if label.rect_position.y < -label.rect_size.y:
		label.rect_position.y = start_y
