#
# 子节点名字不能重复
class_name StateMachine
extends Node

var state_tree:Dictionary
var state_array:Array

var current_state_node:StateTask
var current_state:String = name
var default_state:String 

var is_pause := true
var host:KinematicObject


func _ready():
	host = get_parent()
	build_state_tree(self,"")

func launch(default:String,_host):
	default_state = default
	current_state = default
	current_state_node = find_node(default)
	host = _host
	is_pause = false

func run():
	is_pause = false

func pause():
	is_pause = true

# 返回上一级
func backward():
	var left_state = state_tree[current_state]["left"]
	if left_state == name:
		_switch_state(default_state)
	else:
		_switch_state(left_state)

# 选择
func select(state:String):
	_switch_state(state)
	

func _switch_state(to:String,from:String=current_state):
	var from_state_node = find_node(from)
	var to_state_node = find_node(to)
	from_state_node.exit()
	to_state_node.enter()
	current_state = to
	current_state_node = to_state_node

func _process(delta):
	check_and_run(delta,false)


func _physics_process(delta):
	check_and_run(delta,true)

# 检测是否能继续运行
func check_and_run(delta,is_physics:bool):
	if is_pause:
		return
	current_state_node.execute(is_physics,delta)
	

func has_state(_name:String):
	return state_array.has(_name)

func build_state_tree(current:Node,left:String):
	var children = current.get_children()

	var right:Array
	for child in children:
		if child is StateTask:
			child.host = host
			child.connect("select",self,"select")
			child.connect("back",self,"back")

			right.append(child.name)
			build_state_tree(child,current.name)
	state_tree[current.name] = {
		"left":left,
		"right":right,
	}
	state_array.append(current.name)

