extends Node2D

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


var nivel_confianca = 95  # Valor inicial

func _ready():
	
	num_readings_edit = get_node("num_readings_edit")
	inputs_container = get_node("inputs_container")
	resolution_edit = get_node("lineeditreso")
	create_inputs_button = get_node("create_inputs_button")
	desvio_padrao_label = get_node("desviopadraolabel")
	media_label = get_node("medialabel")
	menor_valor_label = get_node("menorvalorlabel")
	maior_valor_label = get_node("maiorvalorlabel")
	faixa_distribuicao_label = get_node("faixadistribuicaolabel")
	resultados_label = get_node("resultadoslabel")
	
	
	var button = get_node("updatebutton")
	
	
	$create_inputs_button.connect("pressed", self, "_on_create_inputs_button_pressed")
	get_node("button4").connect("pressed", self, "_on_confidence_button_pressed", [90])
	get_node("button5").connect("pressed", self, "_on_confidence_button_pressed", [95])
	get_node("button6").connect("pressed", self, "_on_confidence_button_pressed", [99])
	
func _on_confidence_button_pressed(nivel):
	nivel_confianca = nivel
	update_confidence_label()
	
	_on_updatebutton_pressed()

func update_confidence_label():
	$label3.text = "Nível de Confiança: " + str(nivel_confianca) + "%"

func _on_create_inputs_button_pressed():
	
	for child in inputs_container.get_children():
		inputs_container.remove_child(child)
		child.queue_free()
	
	var num_readings = num_readings_edit.text.to_int()
	for i in range(num_readings):
		var new_line_edit = LineEdit.new()
		new_line_edit.name = "input_%d" % i
		new_line_edit.align = LineEdit.ALIGN_CENTER
		inputs_container.add_child(new_line_edit)
		
func ajustar_para_significativos(valor, referencia_str):
	
	var casas_decimais = 0
	if referencia_str.find(".") != -1:
		casas_decimais = referencia_str.split(".")[1].length()
	
	
	var fator = pow(10, casas_decimais)
	return round(valor * fator) / fator

func _on_updatebutton_pressed():
	valores = []
	var valor_referencia_str = ""  
	for input in inputs_container.get_children():
		if input is LineEdit:
			var valor_str = input.text.strip_edges()  
			if not valor_str.empty():
				valor_str = valor_str.replace(",", ".")
				valores.append(valor_str.to_float())
				if valor_str.find(".") != -1:
					valor_referencia_str = valor_str 
				
	if valores.size() < 2:
		$label4.text = "Número insuficiente de valores"
		return
	
	valores.sort()

	var graus_liberdade = valores.size() - 1
	var t_critico = obter_t_critico(nivel_confianca, graus_liberdade)
	var media = calcular_media(valores)
	var menor_valor = valores.min()
	var maior_valor = valores.max()
	var desvio_padrao = calcular_desvio_padrao(valores, media)
	var margem_erro = desvio_padrao * t_critico
	var resolucao = obter_resolucao(valores)

	var user_resolucao_str = resolution_edit.text.strip_edges()
	if user_resolucao_str.empty():
		user_resolucao_str = "0.01"
	user_resolucao_str = user_resolucao_str.replace(",", ".")
	var user_resolucao = user_resolucao_str.to_float()


	var user_resolucao_formatada = ajustar_para_significativos(user_resolucao, valor_referencia_str)

	var media_arredondada = arredondar_para_resolucao(media, user_resolucao_formatada)
	var margem_erro_arredondada = arredondar_para_resolucao(margem_erro, user_resolucao_formatada)

	if desvio_padrao == 0:
		$label2.text = "Desvio Padrão: RESOLUÇÃO"
		$label4.text = "RM = " + "(" + str(media) + " ± " + str(user_resolucao_formatada) + ")" + " mm"
		$label.text = "Média: " + str(media)
		$label5.text = "t de Student: " + str(t_critico)
	else:
		if t_critico == null:
			$label4.text = "Valor crítico t não disponível para esses graus de liberdade."
			return

		var intervalo_inferior = media - margem_erro
		var intervalo_superior = media + margem_erro

		$label2.text = "Desvio Padrão: " + str(desvio_padrao)
		$label.text = "Média: " + str(media_arredondada)
		$label4.text = "RM = " + "(" + str(media_arredondada) + " ± " + str(margem_erro_arredondada) + ")" + " mm"
		$label5.text = "t de Student: " + str(t_critico)
	
	update()


func calcular_media(valores):
	var soma = 0
	for valor in valores:
		soma += valor
	var media = soma / valores.size()
	return media


func calcular_desvio_padrao(valores, media):
	var soma = 0
	for valor in valores:
		soma += pow(valor - media, 2)
	return sqrt(soma / (valores.size() - 1))

func obter_t_critico(nivel_confianca, graus_liberdade):
	if T_CRITICO_TABELA.has(nivel_confianca):
		if T_CRITICO_TABELA[nivel_confianca].has(graus_liberdade):
			return T_CRITICO_TABELA[nivel_confianca][graus_liberdade]
		else:
			return null  
	else:
		return null  
		

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

func obter_resolucao(valores):
	var resolucao = 0.01
	for i in range(1, valores.size()):
		var diferenca = abs(valores[i] - valores[i - 1])
		if diferenca > 0 and diferenca < resolucao:
			resolucao = diferenca
	return resolucao


func _on_num_readings_edit_focus_entered():
	$num_readings_edit.clear()


func _on_lineeditreso_focus_entered():
	$lineeditreso.clear()

func arredondar_para_resolucao(valor, resolucao):
	return round(valor / resolucao) * resolucao
