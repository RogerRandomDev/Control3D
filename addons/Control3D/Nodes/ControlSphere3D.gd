@tool
extends Control3D
class_name ControlSphere3D

@export var radius:float:
	set(value):
		radius=value
		updateMesh()
	get:return radius


#creates the shape for collision
func createShape():
	checkCollision.shape=SphereShape3D.new()
	body.add_child(checkCollision)



#updates the mesh size to match scale as well
func updateMesh()->void:
	
	checkCollision.shape.radius=radius/2
	if checkMesh.mesh==null:return
	checkMesh.mesh.radius=radius/2
	checkMesh.mesh.height=radius
	


func _ready():
	var mesh=SphereMesh.new()
	checkMesh.mesh=mesh
	mesh.material=mat
	updateMesh()
	super._ready()
	



func get_class()->String:return "ControlSphere3D"
