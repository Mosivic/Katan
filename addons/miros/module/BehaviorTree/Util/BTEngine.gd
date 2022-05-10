extends Node
class_name BTEngine

const BTClassBD = preload("res://addons/miros/module/BehaviorTree/Util/BTClassDB.gd")
const ActionBD = preload("res://addons/miros/module/Action/ActionBD.gd")



var current_node_data:Dictionary
var current_task_state:int
var road:Array
# 拥有者
var actor:Node
# 引擎结点数据
var nodes_data:Dictionary
# 行为参数
var blackboard:Reference
# 是否激活
var is_active:bool=false setget set_active



func _init(graph_data:Dictionary,_blackboard:Reference):
	self.blackboard = _blackboard
	self.actor = blackboard.data["actor"]
	self.name = "BTEngine"
	init_engine_data(graph_data)
	actor.add_child(self)


func _process(delta):
	if is_active :
		task_state_check()
		run_process(delta)

func _physics_process(delta):
	if is_active:
		run_physics_process(delta)


func run_process(delta):
	current_task_state = current_node_data["node"].Run(self,false,delta)

func run_physics_process(delta):
	current_task_state =  current_node_data["node"].Run(self,true,delta)


func task_state_check():
	match current_task_state:
		STATE.TASK_STATE.NULL:
			pass
		STATE.TASK_STATE.RUNNING:
			pass
		STATE.TASK_STATE.SUCCEED:
			print("BTEngine: "+current_node_data["name"]+" is succeed.")
			switch_node(current_task_state)
		STATE.TASK_STATE.FAILED:
			print("BTEngine: "+current_node_data["name"]+" is failed.")
			switch_node(current_task_state)

#
func switch_node(task_state:int):
	var to_node_name:String
	match task_state:
		STATE.TASK_STATE.SUCCEED:
			to_node_name = current_node_data["node"].Next(self)
		STATE.TASK_STATE.FAILED:
			to_node_name = current_node_data["node"].Last(self)
	if to_node_name == "":
		set_active(false)
	else:
		road.append(current_node_data["name"])
		current_node_data = nodes_data[to_node_name]
		reset_node(current_node_data)
		current_task_state = STATE.TASK_STATE.NULL



func reset_node(node_data:Dictionary):
	node_data["action"].Reset()
	for child_node_name in node_data["children_node"]:
		nodes_data[child_node_name]["action"].Reset()


# 生成action,重建graph_data
# 给原有的data上添加实例化的action引用
func init_engine_data(graph_data:Dictionary):
	for key in graph_data.keys():
		var action_name = graph_data[key]["action_name"]
		var action_args = graph_data[key]["action_args"]
		var node_class = graph_data[key]["node_class"]
		var decorators_type = graph_data[key]["decorators"]
		# 添加 action引用
		var action = ActionBD.Actions[action_name].new(action_args,blackboard)
		graph_data[key]["action"] = action
		# 添加 node引用
		var node = get_node_script(node_class)
		graph_data[key]["node"] = node
		# 添加 decorators引用
		var decorators:Array
		for decorator_type in decorators_type:
			var decorator = get_decorator_script(decorator_type)
			decorators.append(decorator)
			
		if node_class == "Root":
			current_node_data = graph_data[key]
	nodes_data = graph_data
	

func reset_task_action(node_data):
	node_data["action"].Reset() 


func set_active(v:bool):
	is_active = v

func get_node_script(_class:String):
	var node = load(BTClassBD.BTNodeClass[_class])
	return node

func get_decorator_script(_type:String):
	var decorator = load(BTClassBD.BTDecoratorType[_type])
	return decorator

func Get_node_data_by_name(_name):
	return nodes_data[_name]
	
