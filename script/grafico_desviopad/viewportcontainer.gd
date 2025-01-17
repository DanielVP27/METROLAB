extends ViewportContainer

# Referência ao nó que contém o conteúdo para rolar
export var content_node : Control

# Velocidade de rolagem
var scroll_speed = 100  # Pixels por segundo

func _ready():
	if not content_node:
		print("Erro: content_node não definido!")

func _process(delta):
	if content_node:
		# Atualiza a posição do conteúdo para rolar para baixo
		content_node.position.y += scroll_speed * delta
		
		# Opcional: Adicione limites à rolagem, se necessário
		# Se o conteúdo rolar além de um certo ponto, você pode limitar o offset
		var max_scroll_y = 1000  # Ajuste conforme necessário
		if content_node.position.y > max_scroll_y:
			content_node.position.y = max_scroll_y
