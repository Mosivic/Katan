extends KinematicBody2D


onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
onready var hit_box = $HitBox
onready var state_machine = $StateMachine

export(NodePath) var target_path



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

func _ready():
	randomize()
	chase_target = get_node(target_path)
	state_machine.set_default_state("Idle")


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





