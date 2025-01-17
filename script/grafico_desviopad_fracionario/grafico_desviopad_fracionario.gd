extends Control

var num_readings_edit
var inputs_container
var resolution_edit
var create_inputs_button
var line_edit
var desvio_padrao_label
var media_label
var menor_valor_label
var maior_valor_label
var faixa_distribuicao_label
var resultados_label
var valores = []
var fonte: DynamicFont


const T_CRITICO_TABELA = {
	90: {
		1: 6.314,
		2: 2.920,
		3: 2.353,
		4: 2.132,
		5: 2.015,
		6: 1.943,
		7: 1.895,
		8: 1.860,
		9: 1.833,
		10: 1.812,
		12: 1.782,
		15: 1.753,
		20: 1.645,
		30: 1.697,
		40: 1.684,
	},
	95: {
		1: 12.706,
		2: 4.303,
		3: 3.182,
		4: 2.776,
		5: 2.571,
		6: 2.447,
		7: 2.365,
		8: 2.306,
		9: 2.262,
		10: 2.228,
		12: 2.179,
		15: 2.131,
		20: 2.086,
		30: 2.042,
		40: 2.021,
	},
	99: {
		1: 63.657,
		2: 9.925,
		3: 5.841,
		4: 4.604,
		5: 4.032,
		6: 3.707,
		7: 3.499,
		8: 3.355,
		9: 3.250,
		10: 3.169,
		12: 3.055,
		15: 2.947,
		20: 2.845,
		30: 2.750,
		40: 2.704,
	}
}

var nivel_confianca = 95  

func _ready():
	
	num_readings_edit = get_node("num_readings_edit")
	inputs_container = get_node("inputs_container")
	resolution_edit = get_node("updatebutton")
	create_inputs_button = get_node("create_inputs_button")
	desvio_padrao_label = get_node("desviopadraolabel")
	media_label = get_node("medialabel")
	menor_valor_label = get_node("menorvalorlabel")
	maior_valor_label = get_node("maiorvalorlabel")
	faixa_distribuicao_label = get_node("faixadistribuicaolabel")
	resultados_label = get_node("resultadoslabel")
	
	
	fonte = DynamicFont.new()
	fonte.font_data = load("res://path_to_your_font.tres") 
	fonte.size = 12
	
	
	var button = get_node("updatebutton")
	button.connect("pressed", self, "_on_updatebutton_pressed")
	
	$create_inputs_button.connect("pressed", self, "_on_create_inputs_button_pressed")
	get_node("button3").connect("pressed", self, "_on_confidence_button_pressed", [90])
	get_node("button4").connect("pressed", self, "_on_confidence_button_pressed", [95])
	get_node("button5").connect("pressed", self, "_on_confidence_button_pressed", [99])
	
func _on_confidence_button_pressed(nivel):
	nivel_confianca = nivel
	update_confidence_label()
	
	_on_updatebutton_pressed()

func update_confidence_label():
	$label.text = "Nível de Confiança: " + str(nivel_confianca) + "%"

func _on_create_inputs_button_pressed():
	# Remove all children from the container
	for child in inputs_container.get_children():
		inputs_container.remove_child(child)
		child.queue_free()
	
	var num_readings = num_readings_edit.text.to_int()
	for i in range(num_readings):
		var new_line_edit = LineEdit.new()
		new_line_edit.name = "input_%d" % i
		inputs_container.add_child(new_line_edit)

func _on_updatebutton_pressed():
	
	valores = []
	for input in inputs_container.get_children():
		if input is LineEdit:
			var valor_str = input.text.strip_edges()  
			if not valor_str.empty():
				valores.append(fracao_para_decimal(valor_str))
	
	
	if valores.size() < 2:
		$resultadoslabel.text = "Número insuficiente de valores"
		return
	
	
	var media = calcular_media(valores)
	var menor_valor = valores.min()
	var maior_valor = valores.max()
	var desvio_padrao = calcular_desvio_padrao(valores, media)
	var resolucao = 0.05 
	var resolucao_str = resolution_edit.text.strip_edges()
	var resolucao_decimal = parse_fraction(resolucao_str)
	var graus_liberdade = valores.size() - 1
	var t_critico = obter_t_critico(nivel_confianca, graus_liberdade)
	if desvio_padrao == 0:
		desvio_padrao = resolucao
		$desviopadraolabel.text = "Desvio Padrão: RESOLUÇÃO"
		$resultadoslabel.text = "RM = " + "(" + to_fraction(media) + " ± " + resolucao_str + ")" + " '' "
		$menorvalorlabel.text = "Menor valor: " + str(menor_valor)
		$maiorvalorlabel.text = "Menor valor: " + str(maior_valor)
		$medialabel.text = "Média: " + decimal_para_fracao(media)
		$label.text = "t de Student: " + str(t_critico)  
	else:
		if t_critico == null:
			$resultadoslabel.text = "Valor crítico t não disponível para esses graus de liberdade."
			return
		
		var margem_erro = desvio_padrao * t_critico
		var intervalo_inferior = media - margem_erro
		var intervalo_superior = media + margem_erro
	

		$desviopadraolabel.text = "Desvio Padrão: " + str(desvio_padrao)
		$medialabel.text = "Média: " + decimal_para_fracao(media)
		$menorvalorlabel.text = "Menor valor: " + str(menor_valor)
		$maiorvalorlabel.text = "Menor valor: " + str(maior_valor)
		$resultadoslabel.text = "RM = " + "(" + decimal_para_fracao(media) + " ± " + decimal_para_fracao(desvio_padrao * t_critico) + ")" + " ''"
		$label.text = "t de Student: " + str(t_critico)  

	
	update()

func obter_t_critico(nivel_confianca, graus_liberdade):
	if T_CRITICO_TABELA.has(nivel_confianca):
		if T_CRITICO_TABELA[nivel_confianca].has(graus_liberdade):
			return T_CRITICO_TABELA[nivel_confianca][graus_liberdade]
		else:
			return null  
	else:
		return null  

func _draw():
	
	var width = rect_size.x
	var height = rect_size.y
	
	
	draw_rect(Rect2(0, 0, width, height), Color(1, 1, 1))
	
	
	draw_line(Vector2(50, height - 50), Vector2(width - 50, height - 50), Color(0, 0, 0), 2)
	draw_line(Vector2(50, height - 50), Vector2(50, 50), Color(0, 0, 0), 2)
	

	if todos_valores_iguais(valores):
		return
	
	if valores.size() < 2:
		draw_string(fonte, Vector2(width / 2, height / 2), "Gráfico Incompleto", Color(1, 0, 0))
		return
	
	
	var valor_min = valores[0]
	var valor_max = valores[0]
	
	for valor in valores:
		if valor < valor_min:
			valor_min = valor
		if valor > valor_max:
			valor_max = valor
	
	
	var valor_min_ajustado = floor(valor_min * 2) / 2
	var valor_max_ajustado = ceil(valor_max * 2) / 2
	
	
	valor_min_ajustado -= 0
	valor_max_ajustado += 0

	
	var media = calcular_media(valores)
	var desvio_padrao = calcular_desvio_padrao(valores, media)
	if desvio_padrao > 0:
		draw_bell_curve(media, desvio_padrao, valor_min_ajustado, valor_max_ajustado, 50, width - 50, height - 50)
	
	
	for valor in valores:
		var x = 50 + (valor - valor_min_ajustado) / (valor_max_ajustado - valor_min_ajustado) * (width - 100)
		var y = height - 50
		draw_circle(Vector2(x, y), 5, Color(1, 0, 0))
	
	
	var x_media = 50 + (media - valor_min_ajustado) / (valor_max_ajustado - valor_min_ajustado) * (width - 100)
	draw_line(Vector2(x_media, height - 50), Vector2(x_media, 50), Color(0, 0, 1), 2)

	
	var x_desvio_padrao_pos = 50 + ((media + desvio_padrao) - valor_min_ajustado) / (valor_max_ajustado - valor_min_ajustado) * (width - 100)
	var x_desvio_padrao_neg = 50 + ((media - desvio_padrao) - valor_min_ajustado) / (valor_max_ajustado - valor_min_ajustado) * (width - 100)
	draw_line(Vector2(x_desvio_padrao_pos, height - 50), Vector2(x_desvio_padrao_pos, 50), Color(0, 1, 0), 2)
	draw_line(Vector2(x_desvio_padrao_neg, height - 50), Vector2(x_desvio_padrao_neg, 50), Color(0, 1, 0), 2)
	
	
	var passo = 0.5
	var valor_atual = ceil(valor_min_ajustado / passo) * passo
	
	while valor_atual <= valor_max_ajustado:
		var x_pos = map_range(valor_atual, valor_min_ajustado, valor_max_ajustado, 50, width - 50)
		draw_line(Vector2(x_pos, height - 50), Vector2(x_pos, 50), Color(0.5, 0.5, 0.5, 0.5), 1)
		draw_string(fonte, Vector2(x_pos + 5, height - 30), str(valor_atual), Color(0.5, 0.5, 0.5))
		valor_atual += passo
		
func todos_valores_iguais(lista):
	if lista.size() < 2:
		return true
	
	var primeiro_valor = lista[0]
	for valor in lista:
		if valor != primeiro_valor:
			return false
	
	return true
	
func calcular_media(valores):
	var soma = 0.0
	for valor in valores:
		soma += valor
	return soma / valores.size()

func calcular_desvio_padrao(valores, media):
	var soma_diferencas_quadrado = 0.0
	for valor in valores:
		var diferenca = valor - media
		soma_diferencas_quadrado += diferenca * diferenca
	return sqrt(soma_diferencas_quadrado / (valores.size() - 1))

func fracao_para_decimal(fracao):
	var partes = fracao.split("/")
	if partes.size() == 2:
		var numerador = partes[0].to_float()
		var denominador = partes[1].to_float()
		if denominador != 0:
			return numerador / denominador
		else:
			return 0  
	else:
		return fracao.to_float()

func decimal_para_fracao(decimal):
	var denominador = 128
	var numerador = round(decimal * denominador)
	var gcd = calcular_mdc(numerador, denominador)
	numerador /= gcd
	denominador /= gcd
	return str(numerador) + "/" + str(denominador)


func calcular_mdc(a, b):
	while b != 0:
		var temp = b
		b = fmod(a, b)
		a = temp
	return a
	

func draw_bell_curve(media, desvio_padrao, valor_min, valor_max, x_start, x_end, y_base):
	var segments = 100
	var step = (valor_max - valor_min) / segments
	var points = []
	
	for i in range(segments + 1):
		var x = map_range(i * step + valor_min, valor_min, valor_max, x_start, x_end)
		var y = y_base - gaussian_distribution(i * step + valor_min, media, desvio_padrao) * (y_base - 50)
		points.append(Vector2(x, y))
	
	draw_polyline(points, Color(0, 0, 1), 2)


func gaussian_distribution(x, media, desvio_padrao):
	var a = 1 / (desvio_padrao * sqrt(2 * PI))
	var b = pow(x - media, 2) / (2 * pow(desvio_padrao, 2))
	return a * exp(-b)


func map_range(value, input_start, input_end, output_start, output_end):
	return output_start + ((output_end - output_start) / (input_end - input_start)) * (value - input_start)


func _on_num_readings_edit_focus_entered():
	$num_readings_edit.clear()

func parse_fraction(fraction_str):
	var parts = fraction_str.split("/")
	if parts.size() == 2:
		var numerator = parts[0].to_float()
		var denominator = parts[1].to_float()
		return numerator / denominator
	return fraction_str.to_float()

func to_fraction(value):
	var numerator = int(value * 128)  # Por exemplo, para frações de 1/128
	var denominator = 128
	var gcd_value = gcd(numerator, denominator)
	numerator /= gcd_value
	denominator /= gcd_value
	return str(numerator) + "/" + str(denominator)

func gcd(a, b):
	while b != 0:
		var temp = b
		b = a % b
		a = temp
	return abs(a)


func _on_updatebutton_focus_entered():
	$updatebutton.clear()
