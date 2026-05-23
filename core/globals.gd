extends Node
#переменая принимающая случаные значения
var rng = RandomNumberGenerator.new()
#функция для получения случайного значения
func _ready():
	#rng.seed = -8573975902024941043
	rng.randomize()
	#print_debug(rng.seed)
