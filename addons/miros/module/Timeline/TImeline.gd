extends Reference
class_name Timeline

enum TIMELINE_STATE{
	NULL,
	PLAYING,
	PAUSED,
	FINISHED,
}

var timelineName:String
var timeline:Array = []
var liveTime:float = 0
var index:int = 0

func Execute(delta)->int:
	liveTime += delta
	var isAllOver = false
	for t in timeline:
		if liveTime>=t["stamp"]:
			var action=t["action"]
			var state = action.actionState
			if state == action.ACTION_STATE.SUCCEED or state == action.ACTION_STATE.FAILED:
				isAllOver = true
			else:
				action.execute(delta)
		else:
			continue
	if isAllOver == false:
		return TIMELINE_STATE.PLAYING
	else:
		return TIMELINE_STATE.FINISHED



# 添加自动插入时间戳
func AddStampAuto(stamp:float,action:Reference):
	var t = {"stamp":stamp,"action":action}
	var size = timeline.size()
	#时间戳正序插入
	if size == 0:
		timeline.append(t)
	else:
		if stamp >= timeline[size-1]["stamp"]:
			timeline.append(t)
		else:
			var i = size-1
			while(1):
				if stamp >= timeline[i]["stamp"] or i==0:
					timeline.insert(i,t)
					break
				else:
					i-=1

# 删除时间戳
func RemoveStamp(stamp:float):
	var size = timeline.size()
	for i in range(0,size):
		if timeline[i]["stamp"] == stamp:
			timeline.remove(i)
			break
