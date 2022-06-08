class_name KinematicObject
extends KinematicBody2D

# 速度 标量
var speed := 20.0
# 速度 矢量
var velocity := Vector2.ZERO
# 加速度
var accelaration := 0.0
# 速度方向
var direction := Vector2.RIGHT
# 目标位置
var target_position := Vector2.ZERO


# Chimaera 相关变量

var brain = null
export(bool) var is_brain := false
export(bool) var is_can_caught := false
var is_caught := false

export(NodePath) var chimaera_path
var chimaera
 
var collision_radius := 5.0

export(bool) var is_enable_state_machine := false
export(NodePath) var machine_path
var machine
export(NodePath) var default_state_path 

# 检测是否启用状态机StateMachine, 然后启动状态机
# 检测是否能被抓取, 然后检查必须的被抓取状态
func _ready():
	if is_enable_state_machine:
		machine = get_node(machine_path)
		
		assert(machine != null ,name+": 未添加StateMachine节点路径")
		assert(default_state_path != "", name+":未分配StateMachine初始状态.")
		
		machine.launch(get_node(default_state_path).name,self)
		
	if is_can_caught:
		assert(machine.has_state("Caught"),name + ": 未添加StateMachine的Caught状态.")
	
	if is_brain:
		assert(machine.has_state("ChimaeraBrain"),name + ": 未添加StateMachine的ChimaeraBrain状态.")

func get_collision_radius():
	return collision_radius


func set_state_caught(_brain):
	brain = _brain
	is_can_caught = false
	is_caught = true
	machine.select("Caught")
	pass
