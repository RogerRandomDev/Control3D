extends Camera3D

var sensitivity:float=0.0375
func _input(event)->void:
	if not event is InputEventMouseMotion||!Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):return
	var moveBy=event.relative*sensitivity
	rotation.y-=moveBy.x
