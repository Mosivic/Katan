extends Position2D

onready var line = $Line2D

var direction = Vector2.RIGHT
var speed = 120
var velocity = Vector2.ZERO
var accelaration := 0.0
var max_point_count := 40
var point_lifetime := 2.0
var turbulence := 2.0

var force_rotate = PI/4

func _ready():
	velocity = speed * direction

func _physics_process(delta):
	
	pass
