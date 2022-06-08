extends StateTask



func _physics_process_task(delta):
	host.animation_player.play("run")
	host.velocity = host.move_and_slide(host.velocity)
	
	if host.velocity.x > 0 :
		host.sprite.flip_h = true
	else:
		host.sprite.flip_h = false
	
	host.change_state_time -= delta

	# Check range -> Chase
	if host.is_on_target_range():
		emit_signal("select","Chase")

	# Time out -> Run
	if host.change_state_time <= 0:
		host.change_state_time = host.natrue_change_state_time
		emit_signal("select","Idle")
