#####################################
# 时间轴工具 - 用于指定函数在某时刻运行
# ver0.1 By Mosiv 2022/04/22
#####################################
extends Node
class_name TimelineManager

var timelines:Dictionary
var timelinesON:Dictionary

func _process(delta):
	execute(delta)


func execute(delta):
	if timelinesON.size() == 0: return
	for timeline in timelinesON.values():
		timeline.Execute(delta)


func RunTimeline(name:String):
	if timelinesON.has(name) or !timelines.has(name):
		return
	timelinesON[name] = timelines[name]


func AddTimeline(name:String,timeline:Timeline):
	if timelines.has(name):
		print("TimelineManager:Timeline "+name+" already exists!")
	else:
		timelines[name] = timeline

func RemoveTimeLine(name:String):
	if timelines.has(name):
		timelines.erase(name)
	else:
		print("TimelineManager:Timeline "+name+" not exists!")

