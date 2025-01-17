extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_area2d_mouse_entered():
	$label.text = "Escala graduada no sistema métrico."
	$label.show()
	$area2d/indicarlabel.show()

func _on_area2d_mouse_exited():
	$label.hide()
	$area2d/indicarlabel.hide()

func _on_area2d2_mouse_entered():
	$label2.text = "Escala graduada no sistema inglês."
	$label2.show()
	$area2d2/indicarlabelbaixo.show()

func _on_area2d2_mouse_exited():
	$label2.hide()
	$area2d2/indicarlabelbaixo.hide()
