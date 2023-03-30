var xp : Vector2 # previous input
var y  : Vector2 # current target
var yd : Vector2 # current targets velocity
var k1 : float # dynamics constants
var k2 : float
var k3 : float

func _init(f:float, z:float, r:float, x0:Vector2):
	# This bad boy gets u a differential equation that can be used for procedural dynamics of stuff
	# use f as frequency, z as damping and r as reaction to initial change
	self.k1 = z/(PI * f)
	self.k2 = 1/((2*PI*f)*(2*PI*f))
	self.k3 = r * z / (2 * PI * f)
	# initialize 
	
	self.xp = x0
	self.y = x0
	self.yd = Vector2.ZERO

func UpdateViaSOD(delta:float, x:Vector2, xd = Vector2.ZERO):
	if (xd == Vector2.ZERO): # estimates velocity 
		xd = (x-xp)/delta
		xp = x
	self.y = self.y+delta*self.yd 
	self.yd = self.yd + delta*(x + k3*xd - self.y - k1*self.yd)/k2
	return self.y
