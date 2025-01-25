class_name Movement
extends Node

# both arguments are of type State
signal movement_state_changed(previous, new)
signal facing_changed(previous, new)

enum State {
	IDLE,
	RUNNING,
	JUMPING,
	FALLING,
	HITSTUN
}

@export
var physics: PhysicsAttributes

@export
var facing: Global.HDirs = Global.HDirs.RIGHT:
	set(new):
		emit_signal("facing_changed", facing, new)
		facing = new

var movement_state := State.IDLE:
	set(state):
		emit_signal("movement_state_changed", movement_state, state)
		movement_state = state

var snap_override = false

# ensure whatever sets these is on a lower process priority
var moveRight: float
var moveLeft: float
var beginJump: bool
var holdJump: bool
var drop: bool

var _jumping := false

var velocity: Vector2:
	set(value):
		Parent.velocity = value
	get:
		return Parent.velocity

var _coyote_time_active := true

@onready
var Parent := get_parent() as CharacterBody2D

func _physics_process(delta):
	var _velocity := velocity
	_velocity = _x_velocity(_velocity, delta)
	_velocity = _y_velocity(_velocity, delta)
	_velocity = _final_movement(_velocity, delta)
	snap_override = false

func _x_velocity(_velocity: Vector2, delta: float) -> Vector2:
	_velocity = Vector2(_velocity)
	# HORIZONTAL MOVEMENT
	# -------------------
	
	var is_on_floor = Parent.is_on_floor()
	
	# multiply by delta to convert to pixels/frame
	var accel_x = (physics.accel_run if is_on_floor else physics.accel_air) * delta
	var decel_x = (physics.decel_run if is_on_floor else physics.decel_air) * delta
	
	var max_speed = (physics.max_run_speed if is_on_floor else physics.jump_vel.x)
	max_speed *= max(moveRight, moveLeft) # analog strength of movement, if applicable
	
	# decelerate to standstill
	if moveRight == moveLeft:
		if moveRight || moveLeft:
			self.movement_state = State.RUNNING
		else:
			self.movement_state = State.IDLE
			
		if abs(velocity.x) > decel_x:
			_velocity.x -= decel_x * sign(_velocity.x)
		else:
			_velocity.x = 0
	else:
		if is_on_floor:
			self.movement_state = State.RUNNING
		if abs(velocity.x) > max_speed:
			_velocity.x -= decel_x * sign(_velocity.x)
		elif moveRight:
			if sign(_velocity.x) == -1:
				_velocity.x = min(_velocity.x + decel_x, max_speed)
			else:
				_velocity.x = min(_velocity.x + accel_x, max_speed)
			self.facing = Global.HDirs.RIGHT
		elif moveLeft:
			if sign(_velocity.x) == 1:
				_velocity.x = max(_velocity.x - decel_x, -max_speed)
			else:
				_velocity.x = max(_velocity.x - accel_x, -max_speed)
			self.facing = Global.HDirs.LEFT
	return _velocity

func _y_velocity(_velocity: Vector2, delta: float) -> Vector2:
	_velocity = Vector2(_velocity)
	# VERTICAL MOVEMENT
	# -----------------
	
	var is_on_floor = Parent.is_on_floor()
	
	if is_on_floor and not snap_override:
		_velocity.y = 8
		_jumping = false
		_coyote_time_active = true
		
		if drop:
			# feel free to reset the collision mask in additional ways in Parent
			Parent.set_collision_mask_value(Global.CollisionLayers.ENVIRONMENT_ONE_WAY, false)
			if $Dropthru.is_stopped():
				$Dropthru.start(physics.DROPTHROUGH_TIME)
	
	# need to assign this here because _jumping can be modified prior to this
	var moveJump := not drop and (beginJump or (_jumping and holdJump))
	
	# jumping
	if is_on_floor or _coyote_time_active:
		if moveJump:
			_velocity.y = physics.jump_vel.y
			_velocity.x = min(abs(_velocity.x), physics.jump_vel.x)*sign(_velocity.x)
			_jumping = true
			_coyote_time_active = false
	
	# airborne (check after jumping)
	if not is_on_floor:
		self.movement_state = State.JUMPING if _jumping else State.FALLING
		
		if _coyote_time_active and $Coyote.is_stopped():
			$Coyote.start(physics.COYOTE_TIME)
		
		var accel_y = physics.accel_jump*delta
		if not _jumping or not moveJump or _velocity.y >= 0:
			# gravity
			_jumping = false
			accel_y = physics.accel_gravity*delta

		_velocity.y = min(_velocity.y + accel_y, -physics.jump_vel.y)
	return _velocity

func _final_movement(_velocity: Vector2, delta: float) -> Vector2:
	_velocity = Vector2(_velocity)
	# FINAL MOVEMENT
	# --------------
	
	velocity = _velocity
	Parent.floor_snap_length = 0 if snap_override else Global.TILE_SIZE*0.5
	Parent.floor_constant_speed = true
	Parent.move_and_slide()
	
	var new_velocity = velocity
	
	# prevent extreme momentum from jumping up sloped walls
	if Parent.is_on_wall():
		new_velocity.y = max(_velocity.y, new_velocity.y)
	
	#rad2deg(collision.normal.rotated(deg2rad(90)).angle()) if collision else "None"
	#debug(str(new_velocity) + ", " + str(Parent.get_slide_collision_count()))
	return new_velocity

func _on_Coyote_timeout():
	_coyote_time_active = false

func _on_Dropthrough_timeout():
	Parent.set_collision_mask_value(Global.CollisionLayers.ENVIRONMENT_ONE_WAY, true)
