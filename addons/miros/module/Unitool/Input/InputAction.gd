extends Node
class_name InputAction

######################
## ver 0.1
## 用于自定义输入, 先在InputMap设置action,然后对action和执行函数function进行bind绑定
## 这里的function称为 "输入执行函数" 
## 同一输入指令的执行函数可以绑定多个, 但一个执行函数的动作名只能唯一
######################

var functions:Dictionary = {} 

func _ready():
	bind("ui_up","test",funcref(self,"test"))
	bind("ui_up","test2",funcref(self,"test2"))

func _process(delta):
	if functions.size() == 0:return
	for value in functions.values():
		if Input.is_action_just_pressed(value["action"]):
			var function:FuncRef = value["function"]
			function.call_func()

## action: 输入指令
## name : 动作名
## function : 执行函数
# @action
func bind(action:String,name:String,function:FuncRef):
	functions[name] = {"action":action,"function":function} 
	

func remove_bind(name:String):
	if functions.has(name):
		functions.erase(name)
	
func test():
	print("hello")	

func test2():
	print("我日你奶奶!")

func _notification(what):
	pass
