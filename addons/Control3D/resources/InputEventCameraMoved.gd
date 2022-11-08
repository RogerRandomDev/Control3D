extends Object
class_name CameraEvent3D
var node:Node
var relative:Vector2
var position:Vector2
var center:Vector2
var event_type:String="CameraEvent"
func build(_node,pos,cen):
	node=_node
	position=pos;center=cen;
	relative=pos-cen

#returns it in a readable format
func get_debug():
	return "node: %s
	position: %s
	center: %s
	relative: %s
	event_type: %s"%[
		node.name,
		position,
		center,
		relative,
		getClass()
		]

func getClass()->String:return "CameraEvent3D"
