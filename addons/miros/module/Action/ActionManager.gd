extends Node
class_name ActionManager


var actions:Dictionary ={}



# 添加Action
func AddAction(name:String,path:String):
	if not isExistActionByName(name):
		actions[name] = path
	else:
		print("ActionManager:addAction:action is exist")

# 根据名字删除Action
func RemoveAction(name:String):
	if isExistActionByName(name):
		actions.erase(name)
	else:
		print("ActionManager:removeAction:action is not exist")


func isExistActionByName(name:String):
	return actions.has(name)



