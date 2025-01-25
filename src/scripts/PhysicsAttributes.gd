class_name PhysicsAttributes
extends Resource


@export_range(0, 16, 0.1, "or_greater") var jump_height: float = 4:
	get:
		return jump_height * Global.TILE_SIZE

@export var jump_length: float = 5:
	get:
		return jump_height * Global.TILE_SIZE

@export var accel_run: float = 36:
	get:
		return accel_run * Global.TILE_SIZE

@export var decel_run: float = 120:
	get:
		return decel_run * Global.TILE_SIZE
		
@export var accel_air: float = 90:
	get:
		return accel_air * Global.TILE_SIZE

@export var decel_air: float = 60:
	get:
		return decel_air * Global.TILE_SIZE

@export var accel_gravity: float = 120:
	get:
		return accel_gravity * Global.TILE_SIZE

@export var accel_jump: float = 60:
	get:
		return accel_jump * Global.TILE_SIZE

@export var max_run_speed: float = 12:
	get:
		return max_run_speed * Global.TILE_SIZE
		
#@export var terminal_vel: float = 12:
#	get:
#		return terminal_vel * Global.TILE_SIZE

@export var COYOTE_TIME: float = 0.05:
	set(value):
		pass
#		Errors.read_only("COYOTE_TIME")

@export var DROPTHROUGH_TIME: float = 0.1:
	set(value):
		pass
#		Errors.read_only("DROPTHROUGH_TIME")

var jump_vel: Vector2:
	set(value):
		pass
		#Errors.read_only("jump_vel")
	get:
		# access self.var to use the getters
		return Vector2(2*(self.jump_length+Global.TILE_SIZE)-1, -sqrt(2*self.accel_jump*self.jump_height))
