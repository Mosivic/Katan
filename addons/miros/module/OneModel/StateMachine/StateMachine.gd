#
# 子节点名字不能重复
class_name StateMachine
extends Node

var state_tree:Dictionary

var current_node:Node = self
var current_state:String = name

var default_state:String 

func _ready():
	build_state_tree(self,"")

func set_default_state(state:String):
	default_state = state
	current_state = state
	current_node = find_node(state)


# 返回上一级
func backward():
	var left_state = state_tree[current_state]["left"]
	if not left_state == name:
		current_state = default_state
		current_node = find_node(current_state)
	else:
		current_state = left_state
		current_node = find_node(current_state)

# 选择
func select(state:String):
	current_state = state
	current_node = find_node(current_state)
	

func _process(delta):
	if current_node.has_method("process_task"):
		current_node.process_task(delta)

func _physics_process(delta):
	if current_node.has_method("physics_process_task"):
		current_node.physics_process_task(delta)

func build_state_tree(current:Node,left:String):
	var children = current.get_children()

	var right:Array
	for child in children:
		right.append(child.name)
		build_state_tree(child,current.name)
	state_tree[current.name] = {
		"left":left,
		"right":right,
	}







