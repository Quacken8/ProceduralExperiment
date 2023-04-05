extends CharacterBody2D

@onready var collisionMask = self.collision_mask
var mousePosition = Vector2.ZERO
var toMouse = Vector2.ZERO
const MAXSPEED = 100.0
const TURNING_WEIGHT = 0.2
const CLOSEST_APPROACH_SQUARED = 10
const MAX_CHECK_ANGLE = PI/4
const GRAVITY = 10

@onready var hipNode = get_node("HipJoint")
@onready var footNode = get_node("UpperLeg/LowerLeg/Foot")
@onready var legVector = hipNode.global_position - footNode.global_position
@onready var LEG_LENGTH = legVector.length()

const SOD = preload("res://SecondOrderDynamics.gd")
var DynamicsHandler : SOD
@export_range(-1,2) var f:float = 2
@export_range(-1,2) var z:float = 2
@export_range(-1,2) var r:float = 0
@onready var parentNode = get_parent()
const ROTATION_SPEED = 2.2

func _ready():
	DynamicsHandler = SOD.new(f, z, r, global_position)


func _physics_process(delta):
	#body movement
	var leftPressed = int(Input.is_action_pressed("ui_left"))
	var rightPressed= int(Input.is_action_pressed("ui_right"))
	var onFloor = int(is_on_floor())
	velocity.x = lerp(velocity.x, MAXSPEED*(rightPressed-leftPressed), TURNING_WEIGHT)
	if not onFloor:
		velocity.y += GRAVITY
	move_and_slide()
	
	var shouldStep = checkForStep()
	if shouldStep != 0:
		takeStep(shouldStep)

func takeStep(shouldStep: int):
	footNode.global_position = Vector2.DOWN.rotated(MAX_CHECK_ANGLE*shouldStep)

func checkForStep():
	# returns 0 if u dont have to step, 1 if u need to step left, -1 if u need to step right
	var hipToFoot = hipNode.global_postion - footNode.global_position
	if abs(hipToFoot.angle + PI) < MAX_CHECK_ANGLE:
		return 0
	return sign(hipToFoot.angle + PI)

func checkForGround(space_state, check_angle):
	var hipPosition = hipNode.global_position
	var checkDirection = Vector2.DOWN.rotated(-check_angle)*LEG_LENGTH
	var query = PhysicsRayQueryParameters2D.create(hipPosition, hipPosition+checkDirection, collisionMask )
	var result = space_state.intersect_ray(query)
	
	return result

func step():
	pass
