extends KinematicBody2D

onready var sprite = $Sprite
onready var animation_player =  $AnimationPlayer
onready var one_state = $OneState

var speed = 80
var velocity = Vector2.ZERO

var uim = UIM.new()

func _ready():
	uim.is_can_catched = false
	setup_state()


func _process(_delta):
	caculate_velocity()

func caculate_velocity():
	var dir = get_global_mouse_position() - global_position
	if dir.length() <= 12:
		velocity = Vector2.ZERO
	else:
		velocity = dir.normalized() * speed
	
	
	if velocity.x > 0:
		sprite.flip_h = true
		$HitBox.scale =  Vector2(-1,1)
	else:
		sprite.flip_h = false
		$HitBox.scale =  Vector2(1,1)


	if velocity == Vector2.ZERO:
		one_state.change_state(["idle"])
	else:
		one_state.change_state(["run"])
	
	if Input.is_action_just_pressed("click"):
		one_state.change_state(["attack"])
	
	velocity = move_and_slide(velocity)


# -----------------------

func setup_state():
	one_state.set_state_func(funcref(self,"idle"),["idle"],one_state.FUNC_TYPE.SHOT)
	one_state.set_state_func(funcref(self,"run"),["run"],one_state.FUNC_TYPE.SHOT)
	one_state.set_state_func(funcref(self,"attack"),["attack"],one_state.FUNC_TYPE.SHOT)
	
	
func idle():
	animation_player.play("idle")


func run():
	animation_player.play("run")


func attack():
	animation_player.play("attack")


# -----------------------

func _on_AnimationPlayer_animation_finished(_anim_name):
	pass


func _on_HurtBox_area_entered(_area):
	var area_name = _area.name
	if area_name == "HitBox":
		print(_area.name + "玩家被怪物击中了~~~")
