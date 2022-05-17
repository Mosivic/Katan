extends StateTask



func _enter_task():
	host.animation_player.play("attack")
	
	var dir = host.chase_target.global_position - host.global_position
	if dir.x > 0:
		host.sprite.flip_h = true
		host.hit_box.scale = Vector2(-1,1)
	else:
		host.sprite.flip_h = false
		host.hit_box.scale = Vector2(1,1)
	

func _process_task(_delta):
	if not host.animation_player.is_playing():
		emit_signal("select","Idle")
	
