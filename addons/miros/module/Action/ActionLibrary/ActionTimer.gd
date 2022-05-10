###
# 暂时器Action  By Mosiv 2022.04.23
# 需要传入参数time，指定暂停时间
###
extends "res://addons/miros/module/Action/ActionBase.gd"

func _init(arg:Dictionary,refs:Reference).(arg,refs):
	action_name = "Timer"
	
func _over_condition()->bool:
	if current_time >= action_args["time"]:
		print("Timer:had run time: "+ str(current_time))
		return true
	return false
