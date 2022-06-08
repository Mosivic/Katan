extends StateTask

var cmr:Chimaera

func _enter_task():
	cmr = host.chimaera
	cmr.set_catchArea_monitoring(false)

func _process_task(_delta):
	var caught = cmr.catching()
	if caught != null:
		print()

func _exit_task():
	cmr.set_catchArea_monitoring(false)

