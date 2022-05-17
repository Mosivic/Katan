extends KinematicBody2D


onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
onready var hit_box = $HitBox
onready var machine = $StateMachine


var speed = 20
var chase_speed = 40

var velocity = Vector2.ZERO
var accelaration := 0.0
var direction = Vector2.RIGHT

var natrue_change_state_time = 2.0
var change_state_time = 2.0

var chase_target:Node2D = null

var find_range = 100
var attack_range = 20

var brain = null
var is_can_caught := true
var is_caught := false
var collision_radius := 5.0

var target_position := Vector2.ZERO

func _ready():
	randomize()
	var players = get_tree().get_nodes_in_group("Player")
	if not players.empty():
		chase_target = players[0]

	machine.launch("Idle",self)



func is_on_target_range()->bool:
	var distance = global_position.distance_to(chase_target.global_position)
	if distance <= find_range:
		return true
	return false

func is_on_attack_range()->bool:
	var distance = global_position.distance_to(chase_target.global_position)
	if distance <= attack_range:
		return true
	return false

func set_state_caught(_brain):
	brain = _brain
	is_can_caught = false
	is_caught = true
	machine.select("Caught")
	pass

func set_target_position(pos):
	target_position = pos

func get_collision_radius()->float:
	return collision_radius
