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
var checkMesh:MeshInstance3D

const mat=preload("res://addons/Control3D/checkAreaMat.tres")
var checkCollision:=CollisionShape3D.new()
@export var shape:Shape3D:
	set(value):
		shape=value
		updateControl(value)
		value.connect('changed',updateControl)
	get:return shape

var body:=StaticBody3D.new()
#creates the shape for collision
func createShape():pass

#updates the check shape and the debug collision mesh
func updateControl(newShape:Shape3D=null)->void:
	if newShape==null:newShape=shape
	checkCollision.shape=newShape
	var m=newShape.get_debug_mesh()
	checkMesh.mesh=m
	
	

func _init()->void:
	
	checkMesh=MeshInstance3D.new()
	body.collision_layer=ScreenView.mouseLayer
	body.collision_mask=0
	body.add_child(checkCollision)
	
	add_child(body)
	createShape()
	connectSignals()

#connects all the initialized signals at once
func connectSignals()->void:
	ScreenView.connect("updatedMouseFocus",updateMouseFocus)
	ScreenView.connect("updatedScreenFocus",updateScreenFocus)
	ScreenView.connect("toggleFocusBoxVisible",func(toggled):checkMesh.visible=toggled)

func _ready()->void:
	if shape!=null:updateControl()
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
	var cameraEvent=CameraEvent3D.new()
	cameraEvent.build(
		self,
		ScreenView.getOnScreen(global_position),
		ScreenView.getViewCenter()
	)
	if lastPos!=cameraEvent.position:emit_signal("cameraUpdate",cameraEvent)
	lastPos=cameraEvent.position

#updates the mouse motion using mouse events
func updateMouse(event):
	var mouseEvent=InputEventMouse3D.new()
	mouseEvent.build(self,event)
	emit_signal("mouseUpdate",mouseEvent)



func update()->void:
	pass


func get_class()->String:return "Control3D"
