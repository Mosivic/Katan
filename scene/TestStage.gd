extends Node2D

export(Array,String,MULTILINE) var arr

var Bullet = preload("res://src/Bullet/Bullet.tscn")

var Firedeco = preload("res://src/Bullet/Firedeco.tscn")

func _input(event):
#if event.is_action_pressed("click"):

#		var bullet = Bullet.instance()
#		bullet.position = get_global_mouse_position()
#		bullet.direction = Vector2.RIGHT.rotated(rand_range(-0.2,0.2))
#		add_child(bullet)
	pass
