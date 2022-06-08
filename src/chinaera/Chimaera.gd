class_name Chimaera
extends Node2D

onready var CatchArea = $CatchArea

var compoents := {}
var caught_singles := []



func resgister_compoent(compoent):
	compoents[compoent.name] = {
		"ref": compoent,
		"type":compoent.type
	}

func set_catchArea_monitoring(v:bool):
	CatchArea.monitoring = v

func catching()->Node2D:
	while true:
		if caught_singles.size() == 0:break
		var single = caught_singles[-1]
		for key in compoents.keys():
			var ref = compoents[key]["ref"]
			var result = ref.assemble_single(single)
			# 分配成功, 继续下次while循环
			if result:
				#print("Catch Succeed with name: " + single.name + " by Compoent: " + key)
				caught_singles.pop_back()
				return single
				break
		# 分配失败,跳出while循环
		break
	return null


# body must can be caught
func _on_CatchArea_body_entered(body):
	if not "is_can_caught" in body: return
	if body.is_can_caught == false: return
	
	caught_singles.append(body)
	



