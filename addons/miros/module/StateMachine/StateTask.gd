class_name StateTask
extends Node

signal select
signal back

var host:KinematicObject

func execute(is_physics:bool,delta:float):
	if is_physics:
		_physics_process_task(delta)
	else:
		_process_task(delta)

func enter():
	#print(host.name + " is enter State: " + name)
	_enter_task()

func exit():
	#print(host.name + " is exit State: " + name)
	_exit_task()

func _enter_task():
	return

func _exit_task():
	return 

func _physics_process_task(delta):
	return

func _process_task(_delta):
	return
