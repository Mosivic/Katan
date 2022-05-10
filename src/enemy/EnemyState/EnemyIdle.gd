extends StateTask

onready var actor = get_node("../..")


func physics_process_task(delta):
	actor.animation_player.play("idle")

	# Check range -> Chase
	if actor.is_on_target_range():
		state_machine.select("Chase")

	actor.change_state_time -= delta
	# Time out -> Run
	if actor.change_state_time <= 0:
		actor.change_state_time = actor.natrue_change_state_time
		actor.direction = Vector2(rand_range(-1,1),rand_range(-1,1)).normalized()
		actor.velocity = actor.speed * actor.direction
		state_machine.select("Run")

