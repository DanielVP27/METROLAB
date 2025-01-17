extends Button

export var url = 'https://www.youtube.com/watch?v=wD6b0UqU2zg&list=PLRg3PROf4Xd1kSBuOMIab5blHrM5Gh8_m'

func _on_button_button_up():
	
	OS.shell_open(url)
	pass
