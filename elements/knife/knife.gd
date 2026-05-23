extends CharacterBody2D
#параметры ножа, назначаем переменные
enum State { IDLE, FLY_TO_TARGET, FLY_AWAY } #укажем 3 возможных состояния ножа
var state := State.IDLE #состояния ножа по умолчанию IDLE, бездействует

var speed := 4500.0 #скорость ножа
var fly_away_direction := Vector2.DOWN #по умолчанию летит вниз, но будет изменён на случайню сторону позже в коде
var fly_away_speed := 1000.0 # скорость полёта ножа в сторону
var fly_away_rotation_speed := 1500.0 # скорость вращения ножа
var fly_away_deviation := PI / 4.0 # угол отклоенения ножа в сторону

#пропишем физику ножа, выполняет условия в зависимости от состояния ножа
func _physics_process(delta: float):
	#вызовем условную конструкцию match
	match  state:
		#попадание в мишень
		State.FLY_TO_TARGET:
			var collision = move_and_collide(Vector2.UP * speed * delta)
			if collision:
				handle_collision(collision)
		#отскок от ножа
		State.FLY_AWAY:
			#укажем угола откланения ножа 
			global_position += fly_away_direction * fly_away_speed * delta
			#укажем скорость вращения отброшеного ножа
			rotation += fly_away_rotation_speed * delta

#функция для перевода ножа в другое состояние
func change_state(new_state:State):
	state = new_state
			
#пропишем функцию которая переводит статус ножа в FLY_TO_TARGET, полёт в цель
func throw():
	change_state(State.FLY_TO_TARGET)

#функция для отскока ножа при столкновении с ножом
func  throw_away(direction: Vector2):
	#делаем диапазон отклонения случайным
	var direction_deviation = Globals.rng.randf_range(-fly_away_deviation, fly_away_deviation)
	fly_away_direction = direction.rotated(direction_deviation)
	change_state(State.FLY_AWAY)
	
#Функция для столкновения ножа с мишенью
func handle_collision(collision: KinematicCollision2D):
	var collider := collision.get_collider() #получаем переменную со столкновением
	if collider is Target: #проверяем класс переменной с колизией и если это мишень то исполняем
		add_knife_to_target(collider) #добавляем ножи к мишени
		#меняем состояние ножа если объект столкновения мишень на бездействие
		change_state(State.IDLE)
	else:
		#иначе вызывает функцию для отскока ножей вызывая нормаль (вектор отклонения от объекта столкновения)
		throw_away(collision.get_normal()) 

#функция для добавления ножа в мишень
func add_knife_to_target(target: Target):
	#убираем обект ножа который мы метнули
	get_parent().remove_child(self)
	#определяем позицию ножа по константе 
	global_position = Target.KNIFE_POSITION
	rotation = 0
	#добавляем обект убраного ножа в мишень
	target.add_object_with_pivot(self, -target.rotation)
