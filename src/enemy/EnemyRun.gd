extends StateTask

onready var actor = get_node("../..")

func physics_process_task(delta):
	actor.animation_player.play("run")
	actor.velocity = actor.move_and_slide(actor.velocity)
	
	if actor.velocity.x > 0 :
		actor.sprite.flip_h = true
	else:
		actor.sprite.flip_h = false
	
	actor.change_state_time -= delta

	# Check range -> Chase
	if actor.is_on_target_range():
		state_machine.select("Chase")

	# Time out -> Run
	if actor.change_state_time <= 0:
		actor.change_state_time = actor.natrue_change_state_time
		state_machine.select("Run")
