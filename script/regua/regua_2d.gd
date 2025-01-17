extends Node2D

# Propriedades da régua
var comprimento_regua = 850

# Leitura inicial
var leitura_atual = 0.0

# Referências aos sprites e ao Label
var sprite_regua: Sprite
var sprite_seta: Sprite
var label_leitura: Label

# Variável para controlar o arraste da seta
var arrastando = false

func _ready():
	# Obter referências aos sprites e ao Label
	sprite_regua = $regua
	sprite_seta = $seta
	label_leitura = $resultado

	# Configurar a escala da régua
	sprite_regua.scale = Vector2(comprimento_regua / sprite_regua.texture.get_width(), 1)

func _process(delta):
	# Atualizar a posição da seta
	if not arrastando:
		sprite_seta.position.x = leitura_atual

	# Atualizar o texto do Label para exibir a leitura atual
	label_leitura.text = str(leitura_atual)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		var sprite_rect = sprite_seta.get_rect()
		var sprite_global_rect = Rect2(sprite_seta.global_position, sprite_rect.size)
		if sprite_global_rect.has_point(mouse_pos):
			arrastando = true

	if event is InputEventMouseMotion and arrastando:
		var mouse_pos = get_global_mouse_position()
		leitura_atual = clamp(mouse_pos.x, 0, comprimento_regua)
		sprite_seta.position.x = leitura_atual

	if event is InputEventMouseButton and not event.pressed and arrastando:
		arrastando = false
