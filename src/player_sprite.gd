extends AnimatedSprite2D

var facing := Global.HDirs.LEFT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_movement_facing_changed(previous: Global.HDirs, new: Global.HDirs) -> void:
	self.facing = new


func _on_movement_movement_state_changed(previous: Movement.State, new: Movement.State) -> void:
	if new == Movement.State.IDLE:
		self.animation = "default"
	elif new in [Movement.State.RUNNING, Movement.State.FALLING, Movement.State.JUMPING]:
		if self.facing == Global.HDirs.LEFT:
			self.play("walk_right")
		else:
			self.play("walk_left")
	elif new == Movement.State.FAST_FALLING:
		self.animation = "dive"
