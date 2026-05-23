extends Node

var rng = RandomNumberGenerator.new()

func _ready():
	#rng.seed = -8573975902024941043
	rng.randomize()
	#print_debug(rng.seed)
