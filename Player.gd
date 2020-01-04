extends "res://Viking.gd"


func _input(event):
	$Jump.play()
	if event.is_action_pressed("ui_up"):
		bash()
	elif event.is_action_pressed("ui_right"):
		strike()
	elif event.is_action_pressed("ui_down"):
		shield()
