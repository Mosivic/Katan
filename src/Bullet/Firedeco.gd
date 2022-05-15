extends Node2D


onready var smoketail = $Line2D
onready var fire = $Fire


func _process(delta):
	smoketail.add_point(global_position)
	fire.scale = rand_range(0.2,0.1) * Vector2.ONE
