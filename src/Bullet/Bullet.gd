extends Area2D

onready var smoke_trail = $SmokeTrail

var direction := Vector2.RIGHT
var speed := 50

var is_dead:= false

func _ready():
	get_node("AnimationPlayer").play("explore")
func _process(_delta):
	if is_dead:queue_free()
	position += direction * speed 
	smoke_trail.add_point(global_position)
	direction = direction.rotated(rand_range(-0.4,0.4))
