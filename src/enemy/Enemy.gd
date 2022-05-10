extends KinematicBody2D

onready var one_state = $OneStateLite
onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
onready var hit_box = $HitBox

export(NodePath) var target_path



var speed = 20
var chase_speed = 40

var velocity = Vector2.ZERO
var accelaration := 0.0
var direction = Vector2.RIGHT

var natrue_change_state_time = 2.0
var change_state_time = 2.0

var chase_target:Node2D = null

var find_range = 400
var attack_range = 100 

func _ready():
	randomize()
	setup_state()
	chase_target = get_node(target_path)



func is_on_target_range()->bool:
	var distance = global_position.distance_to(chase_target.global_position)
	if distance <= find_range:
		return true
	return false

func is_on_attack_range()->bool:
	var distance = global_position.distance_to(chase_target.global_position)
	if distance <= find_range:
		return true
	return false

#---------------------------------
func setup_state():
	one_state.set_state_func(funcref(self,"idle"),"idle",one_state.FUNC_TYPE.PHYSICS_PROCESS)
	one_state.set_state_func(funcref(self,"run"),"run",one_state.FUNC_TYPE.PHYSICS_PROCESS)
	one_state.set_state_func(funcref(self,"chase"),"chase",one_state.FUNC_TYPE.PHYSICS_PROCESS)
	one_state.set_state_func(funcref(self,"attack"),"attack",one_state.FUNC_TYPE.SHOT)

	one_state.change_state("idle")



func idle():
	animation_player.play("idle")
	var delta = get_physics_process_delta_time()
	change_state_time -= delta
	
	# Check range -> Chase
	if is_on_target_range():
		one_state.change_state("chase")

	# Time out -> Run
	if change_state_time <= 0:
		change_state_time = natrue_change_state_time
		one_state.change_state("run")
		direction = Vector2(rand_range(-1,1),rand_range(-1,1)).normalized()
		velocity = speed * direction


func run():
	animation_player.play("run")
	velocity = move_and_slide(velocity)
	
	if velocity.x > 0 :
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	var delta = get_physics_process_delta_time()
	change_state_time -= delta

	# Check range -> Chase
	if is_on_target_range():
		one_state.change_state("chase")

	# Time out -> Run
	if change_state_time <= 0:
		change_state_time = natrue_change_state_time
		one_state.change_state("idle")

func attack():
	animation_player.play("attack")
	
	var dir = chase_target.global_position - global_position
	if dir.x > 0:
		sprite.flip_h = true
		hit_box.scale = Vector2(-1,1)
	else:
		sprite.flip_h = false
		hit_box.scale = Vector2(1,1)
	

func chase():
	animation_player.play("run")
	if velocity.x > 0 :
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	direction = (chase_target.global_position - global_position).normalized()
	velocity = chase_speed * direction
	velocity = move_and_slide(velocity)
	
	# Check Range ->Attack/Idle
	if is_on_attack_range():
		one_state.change_state("attack")
	if not is_on_target_range():
		one_state.change_state("idle")

#---------------------------------
func _on_attack_started():
	one_state.lock_state()

func _on_attack_overed():
	one_state.unlock_state()
	one_state.change_state("chase")


