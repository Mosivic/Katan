extends Node


onready var CatchArea = $CatchArea


var core
var single_size := 0.0



var compoents := {}


func _ready():
	catch_single()

func resgister_compoent(compoent):
	compoents[compoent.name] = {
		"ref": compoent,
		"type":compoent.type
	}

func catch_single():
	CatchArea.monitoring = true

# body must have "uim" property and can be catched
func _on_CatchArea_body_entered(body):
	if not "uim" in body: return
	if body.uim.is_can_catched == false: return
	
	for c in compoents.values():
		var ref = c["ref"]
		var result = ref.assemble_single(body)
		if result == false:
			continue
		else:
			return
	print("Catch failed with " + body.name)
