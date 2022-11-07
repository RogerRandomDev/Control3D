extends Node3D

#signal is connected to all control3D objects
#they check if the given node is themselves
signal updatedMouseFocus(node:Node3D)
signal updatedScreenFocus(node:Node3D)
#toggles visibility of the control3D shapes in game
signal toggleFocusBoxVisible(toggled:bool)

#change this if you need the ray to shoot further
const rayRange=10000

#this changes the layer your Control nodes use to detect
const mouseLayer=2147483648

var currentCamera:Camera3D=null
var checkRay=PhysicsRayQueryParameters3D.new()

#purely for get_mouse_position here
var mouseHelp=Node2D.new()


#updates collision for the ray
func _init():checkRay.collision_mask=mouseLayer

#sets the default camera to use
func _ready():
	add_child(mouseHelp)
	updateCamera()

#just for short hand
func getMouse()->Vector2:return get_viewport().get_mouse_position()

#returns center Vector2 of the viewport resolution
func getViewCenter()->Vector2:return mouseHelp.get_viewport_rect().get_center()

#returns the given Vector3 as a screen position
func getOnScreen(global_pos:Vector3)->Vector2:return currentCamera.unproject_position(global_pos)


#updates the currentCamera to the active camera when called
#call this whenever changing active camera or scenes to make sure it is consistent
func updateCamera()->void:currentCamera=get_viewport().get_camera_3d()


#updates the ray for checking, defaults to the mouse position on screen
func updateRay(checkFrom:Vector2=getMouse()):
	checkRay.from=currentCamera.global_position
	var direction=currentCamera.project_ray_normal(checkFrom)
	checkRay.to=currentCamera.global_position+direction*rayRange




#updates the info on the current focus
func update()->void:
	var target=checkAt(getMouse())
	emit_signal("updatedMouseFocus",target)
	
	target=checkAt(get_viewport().get_visible_rect().get_center())
	emit_signal("updatedScreenFocus",target)


#returns the object at the given reference point on the screen
func checkAt(checkFrom:Vector2)->Node3D:
	var target=null
	updateRay(checkFrom)
	var check:=currentCamera.get_world_3d().direct_space_state.intersect_ray(checkRay)
	if check:target=check.collider.get_parent()
	return target


#updates the active object whenever the mouse is moved
func _input(event)->void:
	if not event is InputEventMouseMotion:return
	update()



#controls the visibility of control3D nodes
func toggleControlVisibility(toggled):emit_signal("toggleFocusBoxVisible",toggled)
