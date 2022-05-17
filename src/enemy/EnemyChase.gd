extends StateTask


func _physics_process_task(_delta):
	host.animation_player.play("run")
	if host.velocity.x > 0 :
		host.sprite.flip_h = true
	else:
		host.sprite.flip_h = false
	host.direction = (host.chase_target.global_position - host.global_position).normalized()
	host.velocity = host.chase_speed * host.direction
	host.velocity = host.move_and_slide(host.velocity)
	
	# Check Range ->Attack/Idle
	if host.is_on_attack_range():
		emit_signal("select","Attack")
	if not host.is_on_target_range():
		emit_signal("select","Idle")
