extends PanelContainer




func _get_script_func_name(node:Node)->Array:
	var functions = node.get_script().get_script_method_list()
	var names = []
	for f in functions:
		var n = f["name"]
		if not names.has(n):
			names.append(f["name"])
	return names
