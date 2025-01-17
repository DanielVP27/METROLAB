extends Button

export var url = 'https://www.youtube.com/watch?v=Z3mzJAT_lxc&list=PLRg3PROf4Xd3mgGg6US1-DRwQ9tchpnvJ'

func _on_button2_button_up():
	
	OS.shell_open(url)
	pass
