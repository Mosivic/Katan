extends "res://addons/miros/module/Action/ActionBase.gd"

var actor:KinematicBody2D

export var speed := 500
export var angular_speed := 5.0

func _init(arg:Dictionary,refs:Reference).(arg,refs):
	action_name = "TopDownMove"

func _action_process(delta):
	pass

func _action_physics_process(delta):
	move(delta)



func _start_condition()->bool:
	actor = action_refs.data["actor"]
	return true
	
func _over_condition()->bool:
	return false


func move(delta):
	var rotate_direction := Input.get_action_strength("rotate_right") - Input.get_action_strength("rotate_left")
	actor.rotation += rotate_direction * angular_speed * delta

	var velocity := (Input.get_action_strength("down") - Input.get_action_strength("up")) * actor.transform.y * speed
	actor.move_and_slide(velocity)


# 在执行前准备
func _before_execute():
	print(action_args["111"])


