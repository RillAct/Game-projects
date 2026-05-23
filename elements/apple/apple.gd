extends Node2D

const EXPLOSION_TIME := 1.0 #время до врзыва частиц
#подготовка сцен
@onready var particles := [
	$AppleParticles2D,
	$AppleParticles2D2
	] # частицы с яблоками
@onready var sprite := $Sprite2D
#перменная содержит статус попал или нет, по умолчанию нет
var is_hited := false

# функция попадания ножа в яблоко
func _on_area_2d_body_entered(body):
	#если переменная is_hited имеет значение False
	if not is_hited:
		is_hited = true #переводим в попал
		sprite.hide() #прячем спрайт яблока
		var tween = create_tween() #создаём переменную с анимацией
		for particle in particles: #перебираем частицы яблок
			particle.emitting = true # объявляем готовность анимации
			tween.parallel().tween_property(particle, "modulate", Color("ffffff00"), EXPLOSION_TIME) #делаем частицы яблок прозрачными
			
		tween.play() #запускаем анимацию
		await tween.finished #ждём конца анимации
		queue_free() #безопасно удалим сцену
 
