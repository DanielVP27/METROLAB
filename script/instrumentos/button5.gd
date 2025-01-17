extends Button

export var url = 'https://forms.gle/9eF26P5v8V92yNe76'

func _on_button5_button_up():
	
	OS.shell_open(url)
	pass
