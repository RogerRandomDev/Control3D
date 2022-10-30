@tool
extends Control3D
class_name ControlBox3D


@export var size:Vector3:
	set(value):
		size=value
		updateMesh()
	get:return size


#creates the shape for collision
func createShape():
	
	checkCollision.shape=BoxShape3D.new()
	body.add_child(checkCollision)

#updates the mesh size to match scale as well
func updateMesh()->void:
	
	checkCollision.shape.size=size
	if checkMesh.mesh==null:return
	checkMesh.mesh.size=size


func _ready():
	var mesh=BoxMesh.new()
	checkMesh.mesh=mesh
	mesh.material=mat
	updateMesh()
	super._ready()

func get_class()->String:return "ControlBox3D"
