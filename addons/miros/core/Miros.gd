extends Node


var soundManager setget,GetSoundManager
var inputAction setget,GetInputAction
var gameTool setget,GetGameTool
var timeline setget,GetTimelineManager
var saveManager setget,GetSaveManager
var global setget ,GetGlobal
var actionManager setget ,GetActionManager

# 静态加载 - 手动添加
var modules:Dictionary = {
	"SoundManager":[soundManager,"res://addons/miros/module/Unitool/SoundManager.gd"],
	"InputAction":[inputAction,"res://addons/miros/module/Unitool/Input/InputAction.gd"],
	"GameTool":[gameTool,"res://addons/miros/module/Unitool/GameTool.gd"],
	"Global":[global,"res://addons/miros/module/Unitool/Global.gd"],
	"TimelineManager":[timeline,"res://addons/miros/module/Timeline/TimelineManager.gd"],
	"SaveManager":[saveManager,"res://addons/miros/module/Unitool/File/SaveManager.gd"],
	"ActionManager":[actionManager,"res://addons/miros/module/Action/ActionManager.gd"]
}



## 返回模块单例
func get_module(name:String):
	if modules.has(name):
		if modules[name][0] == null:
			var module = load(modules[name][1]).new()
			module.name = name
			add_child(module)
			modules[name][0] = module
			return module
		else:
			return modules[name][0]
	else:
		print("模块不存在："+name)
		return null

		
func GetInputAction():
	return get_module("InputAction") 
	
func GetSoundManager():
	return get_module("SoundManager") 
	
func GetGameTool():
	return get_module("GameTool")
	
func GetTimelineManager():
	return get_module("TimelineManager")
	
func GetSaveManager():
	return get_module("SaveManager")

func GetGlobal():
	return get_module("Global")

func GetActionManager():
	return get_module("ActionManager")
