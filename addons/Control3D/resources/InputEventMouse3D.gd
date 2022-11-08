class_name InputEventMouse3D

var node:Node
var position:Vector2
var relative:Vector2
var pressed:bool
var button_mask:int
var event_type:String=""

func build(_node,baseEvent):
	node=_node
	#tells what type of event it was originally
	#use this to determine the action type and how to react to it
	event_type="MouseMotion" if baseEvent is InputEventMouseMotion else "MouseButton"
	#the center of the event triggered node
	var center=ScreenView.getOnScreen(_node.global_position)
	position=baseEvent.get("position")
	relative=position-center
	if event_type!="MouseMotion":
		pressed=baseEvent.get("pressed")
		button_mask=baseEvent.get("button_mask")

#the debug format for the data of the event
func get_debug():
	var swapTo=[node.name,position,relative]
	
	if event_type=="MouseMotion":swapTo.append(getClass())
	else:swapTo.append_array([button_mask,pressed,getClass()])
	var swapping=("\nbutton_mask: %s\npressed: %s") if event_type=="MouseButton" else ""
	return ("node: %s\nposition: %s\nrelative: %s"+swapping+"
	event_type: %s") %swapTo

func getClass():return "InputEvent%s3D"%event_type
