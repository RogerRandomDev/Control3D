extends Node3D

func _ready():
	
	ScreenView.updateCamera()
	for child in get_children():
		if !child.has_method("createShape"):continue
		child.connect("mouseEntered",updateChild)
		child.connect("mouseExited",updateChild)
		child.connect("cameraEntered",updateChild)
		child.connect("cameraExited",updateChild)
		child.connect("cameraUpdate",updateCameraMove)
		child.connect("mouseUpdate",updateMouseMove)
	_on_check_box_toggled(true)

func updateChild(child):
	child.get_node("Label3d").text=(
		"I am:\n"+
		("Hovered\n" if child.inMouse else "")+
		("Camera Focused" if child.inCamera else "")
		)

func updateCameraMove(event):
	$Label2.text=event.get_debug()
	
func updateMouseMove(event):
	$Label2.text=event.get_debug()


func _on_check_box_toggled(button_pressed):
	ScreenView.toggleControlVisibility(button_pressed)
