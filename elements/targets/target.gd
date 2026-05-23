extends CharacterBody2D
class_name Target
# укажем константы для нужных значений
const EXPLOSION_TIME := 1.0 # время для таймера взрыва
const GENERATION_LIMIT := 100 # Предел попыток генерации обектов на мешени
const KNIFE_POSITION = Vector2(0, 180) # позиция ножа при столкновении с мишенью
const APPLE_POSITION = Vector2(0, 176) # позиция яблока на мишени
const OBJECT_MARGIN := 0.96 # величина обекта в радианах

#создадим переменные в которые подгружаем сцены яблока и ножа и дугие характеристики
var knife_scene : PackedScene = load("res://elements/knife/knife.tscn")
var apple_scene : PackedScene = load("res://elements/apple/apple.tscn")

var speed := PI #скорость

 # обьявим элементы сцены для проверки готовности
@onready var items_container := $ItemsContainer #укажем расположения контейнера для ножей сцены
@onready var sprite := $Sprite2D #спрайт сцены мишени
@onready var knife_particles := $KnifeParticles2D #сцена разлёта ножей
@onready var  particles_target_parts := [
	$TargetParticles2D,
	$TargetParticles2D2,
	$TargetParticles2D3
] #разлёт частей мешени


#функция для кол-ва ножей и яблок
func _ready():
	add_default_items(3, 6)	
	#await get_tree().create_timer(1).timeout
	#explode()

#указываем скорость вращения мишени
func _physics_process(delta: float):
	rotation += speed * delta
	
#функция для взрыва частиц
func explode ():
	sprite.hide() #прячем спрайт мишени
	items_container.hide() #прячем объекты контейнера
	# зададим анимацию плавного исчезновения мишени
	var tween := create_tween()
	# пройдём по элементам частей мишени в цикле
	for target_particles_part in particles_target_parts:
		tween.parallel().tween_property(target_particles_part, "modulate", Color("ffffff00"), EXPLOSION_TIME)
		target_particles_part.emitting = true  #запустим анимацию для частей мишени 
	# зададим анимацию плавного исчезновения ножей
	knife_particles.rotation = -rotation # вращение частиц ножей
	knife_particles.emitting = true  # #запустим анимацию для частиц ножей
	tween.parallel().tween_property(knife_particles, "modulate", Color("ffffff00"), EXPLOSION_TIME)
	# запустим 
	tween.play() #анимации сработают паралельно после работы play
	
#напишем функцию для добавления ножей
func add_object_with_pivot(object: Node2D, object_rotation: float):
	var pivot := Node2D.new() #создаём новую ноду (нож или яблоко)
	pivot.rotation = object_rotation #добавляем ноде вращение
	pivot.add_child(object) # Добавление объекта как дочернего узла к опоре:
	items_container.add_child(pivot) #добавим нож в контейнер

#функция для добавлея яблок и ножей на мишень в случайном месте
func add_default_items(knives: int, apples: int):
	var occupied_rotations := [] #создаём пустой список, куда будем добавлять занятые места
	for i in range(knives): # для элемента в указанном диапазоне
		var pivot_rotation = get_free_random_ratation(occupied_rotations) #получаем координаты
		if pivot_rotation == null:  #если количество попыток больше константы вернём функцию
			return
		occupied_rotations.append(pivot_rotation) # добавляем к списку новые координаты объекта
		var knife = knife_scene.instantiate() # добавим сцену ножа
		knife.position = KNIFE_POSITION # укажем позицию ножа
		add_object_with_pivot(knife, pivot_rotation) # 
	
	for i in range(apples):
		var pivot_rotation = get_free_random_ratation(occupied_rotations)
		if pivot_rotation == null:
			return
		occupied_rotations.append(pivot_rotation)
		var apple = apple_scene.instantiate()
		apple.position = APPLE_POSITION
		add_object_with_pivot(apple, pivot_rotation)
	
	#функция для генерации случайных значений ножей и яблок
func get_free_random_ratation(occupied_rotations: Array, generation_attempts = 0): #передаём массив с занятыми местами и номер текущей попытки
	#остановим процес при избытке попыток
	if generation_attempts >= GENERATION_LIMIT:
		return null
	#создадим случайное значение созданной ранее функцией из глобал в диапазоне размер объекта
	var random_rotation = Globals.rng.randf_range(OBJECT_MARGIN / 2, PI * 2 - (OBJECT_MARGIN / 2)) #получаем значение от 0 до 360
	
	for occupied in occupied_rotations: 
#проверям, если случайное число между растоянием существующих объектов то запускаем функцию снова иначе выводим координаты
		if random_rotation <= occupied + OBJECT_MARGIN / 2.0 and random_rotation >= occupied - OBJECT_MARGIN / 2.0:
			#повторяем поиск свободного места и увеличиваем значение счётчика на 1
			return get_free_random_ratation(occupied_rotations, generation_attempts + 1)
	#выводим координаты
	#print(random_rotation)
	return random_rotation
