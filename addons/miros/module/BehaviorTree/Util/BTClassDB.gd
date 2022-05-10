extends Reference

const BTNodeClass = {
	Root = "res://addons/miros/module/BehaviorTree/Node/Root/BTRoot.gd",
	Action = "res://addons/miros/module/BehaviorTree/Node/Leaf/BTAction.gd",
	Condition = "res://addons/miros/module/BehaviorTree/Node/Leaf/BTCondition.gd",
	CompositeSequence = "res://addons/miros/module/BehaviorTree/Node/Composite/BTSequence.gd",
	CompositeParallel = "res://addons/miros/module/BehaviorTree/Node/Composite/BTParallel.gd",
	CompositeRandomSelector = "res://addons/miros/module/BehaviorTree/Node/Composite/BTRandomSelector.gd",
} 


const BTNodeType = {
	Root = "res://addons/miros/module/BehaviorTree/Node/Root/BTRoot.gd",
	Leaf = "res://addons/miros/module/BehaviorTree/Node/Leaf/BTLeafBase.gd",
	Decorator = "res://addons/miros/module/BehaviorTree/Node/Decorator/BTDecoratorBase.gd",
	Composite = "res://addons/miros/module/BehaviorTree/Node/Composite/BTCompositeBase.gd"
}


const BTDecoratorType = {
	Loop = "res://addons/miros/module/BehaviorTree/Node/Decorator/BTLoop.gd",
	Inverter = "res://addons/miros/module/BehaviorTree/Node/Decorator/BTInverter.gd",
}

## 判断节点是否为行为树节点
#static func is_bt_node(node:Node)->bool:
#	for n in BTNode.values():
#		if node is n:
#			return true
#	return false
