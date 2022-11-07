@tool
extends Node3D
class_name Control3D
#default enter/exit signals
signal mouseEntered(node)
signal mouseExited(node)
signal cameraEntered(node)
signal cameraExited(node)
#movement signals
signal mouseUpdate(dict)
signal cameraUpdate(dict)



var inCamera:bool=false
var inMouse:bool=false
#most used for the editor view
var checkMesh:MeshInstance3D=null
const mat=preload("res://addons/ScreenView3D/checkAreaMat.tres")
var checkCollision:CollisionShape3D=CollisionShape3D.new()
var body:StaticBody3D=null
#creates the shape for collision
func createShape():pass




func _init()->void:
	checkMesh=MeshInstance3D.new()
	body=StaticBody3D.new()
	body.collision_layer=ScreenView.mouseLayer
	body.collision_mask=0
	createShape()
	connectSignals()

#connects all the initialized signals at once
func connectSignals()->void:
	ScreenView.connect("updatedMouseFocus",updateMouseFocus)
	ScreenView.connect("updatedScreenFocus",updateScreenFocus)

func _ready()->void:
	add_child(body)
	ScreenView.connect("toggleFocusBoxVisible",func(toggled):checkMesh.visible=toggled)
	add_child(checkMesh);checkMesh.visible=Engine.is_editor_hint()
	




#updates if the mouse focus is self
func updateMouseFocus(newTarget):
	var newInMouse=newTarget==self
	if newInMouse!=inMouse:
		inMouse=newInMouse
		emit_signal("mouseEntered" if inMouse else "mouseExited",self)
		update()
	

var lastPos=Vector2.ZERO
#updates if the camera focus is self
func updateScreenFocus(newTarget):
	var newInCamera=newTarget==self
	if newInCamera!=inCamera:
		inCamera=newInCamera
		emit_signal("cameraEntered" if inCamera else "cameraExited",self)
		update()
	if inCamera:updateCamera()

func _input(event):
	if inMouse:updateMouse(event)

#updates based on center point of the camera
func updateCamera():
	var eventData={
		'event':"cameraMoved",
		'node':self,
		'position':ScreenView.getOnScreen(global_position),
		'center':ScreenView.getViewCenter()
		}
	eventData["offset"]=eventData.position-eventData.center
	if lastPos!=eventData.position:emit_signal("cameraUpdate",eventData)
	lastPos=eventData.position

#updates the mouse motion using mouse events
func updateMouse(event):
	
	var eventData={
		'event':event.get_class(),
		'node':self,
		'relative':event.get("relative"),
		'pressed':event.get("pressed"),
		'position':event.get("position"),
		"button_mask":event.get("button_mask")
		}
	emit_signal("mouseUpdate",eventData)



func update()->void:
	pass


func get_class()->String:return "Control3D"
