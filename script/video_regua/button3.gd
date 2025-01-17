extends Button

export var url = 'https://www.youtube.com/watch?v=sh7Sr4-RIfM&list=PLeG_dAglpVo6mg0Y4MIkwiAu7dwnC7ZX2'

func _on_button3_button_up():
	
	OS.shell_open(url)
	pass
