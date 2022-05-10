extends StateTask


onready var actor = get_node("../..")

func physics_process_task(_delta):
	actor.animation_player.play("run")
	if actor.velocity.x > 0 :
		actor.sprite.flip_h = true
	else:
		actor.sprite.flip_h = false
	actor.direction = (actor.chase_target.global_position - actor.global_position).normalized()
	actor.velocity = actor.chase_speed * actor.direction
	actor.velocity = actor.move_and_slide(actor.velocity)
	
	# Check Range ->Attack/Idle
	if actor.is_on_attack_range():
		state_machine.select("Attack")
	if not actor.is_on_target_range():
		state_machine.select("Idle")
