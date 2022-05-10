extends "res://addons/miros/module/Action/ActionBase.gd"

func _init(arg:Dictionary,refs:Reference).(arg,refs):
	action_name = "Print"
	
func _action_process(delta):
	print(action_args["print"])


