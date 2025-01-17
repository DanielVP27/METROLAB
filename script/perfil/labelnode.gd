extends Node2D

onready var music_player = $audiostreamplayer
onready var label = $Label


var speed = 180.0


var start_y: float


var screen_height: float

func _ready():

	music_player.play()
	screen_height = get_viewport_rect().size.y
	

	start_y = screen_height
	position.y = start_y

func _process(delta: float):

	position.y -= speed * delta
	

	if position.y < -label.rect_size.y:
		position.y = start_y
