extends StateTask

var run_speed = 80

func _physics_process_task(delta):
	host.animation_player.play("run")
	var distance = host.global_position.distance_to(host.get_global_mouse_position() )
	host.direction =  host.global_position.direction_to(host.get_global_mouse_position() )
	if distance <= 12:
		host.velocity = Vector2.ZERO
		host.direction = Vector2.ZERO
		emit_signal("select","Idle")
	else:
		host.velocity = host.direction * run_speed
		host.move_and_slide(host.velocity)
