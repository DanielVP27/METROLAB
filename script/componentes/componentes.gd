extends Node2D
	
func _on_area2dnonio_mouse_entered():
	$label.text = "Nônio: Responsável pelo princípio de funcionamento do instrumento, na escala em polegadas."
	$label.show()
	$"area2d(nonio)/indicarlabel".show()
func _on_area2dnonio_mouse_exited():
	$label.hide()
	$"area2d(nonio)/indicarlabel".hide()

func _on_area2d2_mouse_entered():
	$label5.text = "Nônio: Responsável pelo princípio de funcionamento do instrumento, na escala em milímetros."
	$label5.show()
	$area2d2/indicarlabelbaixo.show()

func _on_area2d2_mouse_exited():
	$label5.hide()
	$area2d2/indicarlabelbaixo.hide()



func _on_area2d3_mouse_entered():
	$label6.text = "Impulsor: Componente que irá ser impulsionado pelo polegar para deslocar o nônio."
	$label6.show()
	$area2d3/indicarlabelbaixo.show()
func _on_area2d3_mouse_exited():
	$label6.hide()
	$area2d3/indicarlabelbaixo.hide()



func _on_area2d4_mouse_entered():
	$label2.text = "Parafuso de fixação: Responsável por fixar o nônio."
	$label2.show()
	$area2d4/indicarlabel.show()
func _on_area2d4_mouse_exited():
	$label2.hide()
	$area2d4/indicarlabel.hide()



func _on_area2d5_mouse_entered():
	$label7.text = "Bicos: Responsável por medir dimensões externas."
	$label7.show()
	$area2d5/indicarlabelbaixo.show()

func _on_area2d5_mouse_exited():
	$label7.hide()
	$area2d5/indicarlabelbaixo.hide()



func _on_area2d6_mouse_entered():
	$label3.text = "Orelhas: Responsável por medir dimensões internas."
	$label3.show()
	$area2d6/indicarlabel.show()

func _on_area2d6_mouse_exited():
	$label3.hide()
	$area2d6/indicarlabel.hide()



func _on_area2d7_mouse_entered():
	$label4.text = "Escala principal: Escala graduada com sistema métrico e inglês."
	$label4.show()
	$area2d7/indicarlabel.show()

func _on_area2d7_mouse_exited():
	$label4.hide()
	$area2d7/indicarlabel.hide()



func _on_button_button_up():
	pass # Replace with function body.


func _on_button2_button_up():
	pass # Replace with function body.
