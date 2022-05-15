extends Position2D

onready var line = $CanvasLayer/Line2D

var direction = Vector2.RIGHT
var speed = 300
var velocity = Vector2.ZERO
var accelaration := 0.0

var turbulence := 2.0

var force_rotate = PI/3 # 顺时针转动

var target:Vector2 = Vector2(400,400)

var start_distance:float = 0
var start_pos:Vector2

var turn_factor = 1
var acceleration_factor = 0

var max_point_count := 100
var point_lifetime := 2.0

var target_diretion:Vector2
var target_distance:float 

func _ready():
	start_distance = global_position.distance_to(target)
	start_pos = global_position
	
	direction = direction.direction_to(target)
	
	var r = atan(direction.y/direction.x)
	
	r = r+force_rotate
	
	var r_y = sin(r)
	var r_x = cos(r)
	direction = Vector2(r_x,r_y)
	
	velocity = direction.normalized() * speed

func _physics_process(delta):
	var dis =  global_position.distance_to(target)
	if dis < 5.0:return
	
	turn_factor = ceil(1/(dis/start_distance))
	if turn_factor > 100:turn_factor = 100
	
	target_diretion = global_position.direction_to(target)
	direction = direction.linear_interpolate(target_diretion,delta*turn_factor)
	velocity = direction.normalized() * speed
	
	acceleration_factor = target_distance/500
	velocity *= 1+acceleration_factor
	
	global_position += velocity *delta
	
	if line.get_point_count() > max_point_count:
		line.remove_point(0)
		line.add_point(global_position)
	else:
		line.add_point(global_position)
	
	
	
	
func _process(_delta):
	target = get_global_mouse_position()

	
	
	start_distance = global_position.distance_to(target)
	start_pos = global_position
	
	target_distance = start_distance

#func _input(event):
#	if Input.is_action_just_pressed("click"):
		

