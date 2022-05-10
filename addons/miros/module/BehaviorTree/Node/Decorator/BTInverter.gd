extends "BTDecoratorBase.gd"



# 反转成功与失败的结果
static func _decorate(states:Array)->Array:
	for state in states:
		if state == STATE.ACTION_STATE.SUCCEED:
			state == STATE.ACTION_STATE.FAILED
		elif state == STATE.ACTION_STATE.FAILED:
			state == STATE.ACTION_STATE.SUCCEED
	return states
