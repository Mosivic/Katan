extends CMRBase


func _ready():
	type = TYPE.HAND



func _input(event):
	if event.is_action_pressed("click"):
		hand_rotate()

func hand_rotate():
	for i in range(trans_points.size()-1):
		var t = (trans_points[i] as Vector2).rotated(PI/180 * i)
		trans_points[i] = t
		


