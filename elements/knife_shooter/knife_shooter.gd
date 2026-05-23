extends Node2D
#пропишем откуда будем подгружать элементы для ножа
var knife_scene := preload("res://elements/knife/knife.tscn")

@onready var knife := $Knife #Нож текущей сцены
@onready var timer := $Timer #таймер текущей сцены

# функция создания ножа
func create_new_knife():
	knife = knife_scene.instantiate() #создаём сцену с ножом
	add_child(knife) #добавляем созданную сцену с ножом

#пропишем функцию для отсеживания нажатия на экран
func _input(event: InputEvent):
	#если есть нажатие таймер меньше 0 то запускаем нож и начинаем работу одноразового таймер
	if event is InputEventScreenTouch and event.is_pressed() and timer.time_left <= 0:
		knife.throw() #запускаем нож
		timer.start() #запускаем таймер заново

#функция где по окончанию таймера создаём новый нож
func _on_timer_timeout():
	create_new_knife()
