extends Reference


var host :Node
var strategy 


func _init(_host):
	self.host = _host
	
func run_strategy():
	pass


func setup():
	var target = STRTarget.new()
	var location = STRAgentLocation.new()
	strategy = STRStrategy.new(host,target,location)

func change_strategy():
	pass
