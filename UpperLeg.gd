extends CharacterBody2D

const SOD = preload("res://SecondOrderDynamics.gd")
var DynamicsHandler : SOD
@export_range(-1,1) var f:float = 0
@export_range(-1,1) var z:float = 0
@export_range(-1,1) var r:float = 0 
@onready var parentNode = get_parent()

func _ready():
	DynamicsHandler = SOD.new(f, z, r, global_position)

func _process(delta):
	var parentPosition = parentNode.global_position
	var parentVelocity = parentNode.velocity
	global_position = DynamicsHandler.UpdateViaSOD(delta, parentPosition, parentVelocity)
	
	

