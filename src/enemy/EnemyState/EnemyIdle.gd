extends StateTask


func _physics_process_task(delta):
	host.animation_player.play("idle")
	

	# Check range -> Chase
	if host.chase_target != null and host.is_on_target_range():
		emit_signal("select","Chase")


	host.change_state_time -= delta
	# Time out -> Run
	if host.change_state_time <= 0:
		host.change_state_time = host.natrue_change_state_time
		host.direction = Vector2(rand_range(-1,1),rand_range(-1,1)).normalized()
		host.velocity = host.speed * host.direction
		emit_signal("select","Run")
		

