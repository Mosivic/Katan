extends StateTask

onready var actor = get_node("../..")

func task():
	actor.animation_player.play("attack")
	
	var dir = actor.chase_target.global_position - actor.global_position
	if dir.x > 0:
		actor.sprite.flip_h = true
		actor.hit_box.scale = Vector2(-1,1)
	else:
		actor.sprite.flip_h = false
		actor.hit_box.scale = Vector2(1,1)
	

func process_task(_delta):
	if not actor.animation_player.is_playing():
		state_machine.select("Idle")
	
