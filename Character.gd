extends CharacterBody2D

var mousePosition = Vector2.ZERO
var toMouse = Vector2.ZERO
const MAXSPEED = 300
const CLOSEST_APPROACH_SQUARED = 10


func _physics_process(_delta):
	
	
	# move to mouse and if close enough dont move at all
	mousePosition = get_global_mouse_position()
	toMouse = mousePosition-global_position
	if toMouse.length_squared()<CLOSEST_APPROACH_SQUARED:
		toMouse = Vector2.ZERO
	if toMouse.length_squared()>1:
		toMouse = toMouse.normalized()
	velocity = toMouse*MAXSPEED
	
	move_and_slide()
