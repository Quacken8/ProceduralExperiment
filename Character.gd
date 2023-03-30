extends CharacterBody2D

@onready var collisionMask = self.collision_mask
var mousePosition = Vector2.ZERO
var toMouse = Vector2.ZERO
const MAXSPEED = 300
const CLOSEST_APPROACH_SQUARED = 10
const MAX_CHECK_ANGLE = PI/4
const SOD = preload("res://SecondOrderDynamics.gd")
var DynamicsHandler : SOD
@export_range(-1,2) var f:float = 2
@export_range(-1,2) var z:float = 2
@export_range(-1,2) var r:float = 0

@onready var hipNode = get_node("HipJoint")
@onready var footNode = get_node("UpperLeg/LowerLeg/Foot")
@onready var legVector = hipNode.global_position - footNode.global_position
@onready var LEG_LENGTH = legVector.length()


func _ready():
	DynamicsHandler = SOD.new(f, z, r, global_position)

func _physics_process(delta):
	mousePosition = get_global_mouse_position()
	global_position = DynamicsHandler.UpdateViaSOD(delta, mousePosition)
	
	var space_state = get_world_2d().direct_space_state
	
	var checkResult = null
	legVector = hipNode.global_position - footNode.global_position
	var legAngle = legVector.angle()+0.5*PI
	if legAngle > MAX_CHECK_ANGLE:
		checkResult = checkForGround(space_state, -MAX_CHECK_ANGLE)
	elif legAngle < -MAX_CHECK_ANGLE:
		checkResult = checkForGround(space_state, MAX_CHECK_ANGLE)
	if checkResult != null && not checkResult.is_empty():
		print(checkResult)


func checkForGround(space_state, check_angle):
	var hipPosition = hipNode.global_position
	var checkDirection = Vector2.DOWN.rotated(-check_angle)*LEG_LENGTH
	var query = PhysicsRayQueryParameters2D.create(hipPosition, hipPosition+checkDirection, collisionMask)
	var result = space_state.intersect_ray(query)
	
	return result

func step():
	pass
