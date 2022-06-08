extends KinematicObject

onready var sprite = $Sprite
onready var animation_player =  $AnimationPlayer



func _on_HurtBox_area_entered(_area):
	var area_name = _area.name
	if area_name == "HitBox":
		print(_area.name + "玩家被怪物击中了~~~")
	
