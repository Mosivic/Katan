extends Node2D


onready var CatchArea = $CatchArea

var compoents := {}
var catched_singles := []

func _ready():
	CatchArea.monitoring = true

func _process(delta):
	assemble_single_to_compoent()

func resgister_compoent(compoent):
	compoents[compoent.name] = {
		"ref": compoent,
		"type":compoent.type
	}

func assemble_single_to_compoent():
	while true:
		if catched_singles.size() == 0:break
		var single = catched_singles[-1]
		for key in compoents.keys():
			var ref = compoents[key]["ref"]
			var result = ref.assemble_single(single)
			# 分配成功, 继续下次while循环
			if result:
				print("Catch Succeed with name: " + single.name + " by Compoent: " + key)
				catched_singles.pop_back()
				break
		# 分配失败,跳出while循环
		break



# body must have "token" property and can be catched
func _on_CatchArea_body_entered(body):
	if not "token" in body: return
	if body.token.is_can_catched == false: return
	
	catched_singles.append(body)
	



