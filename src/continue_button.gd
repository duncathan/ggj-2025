extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var phase := float(Time.get_ticks_msec()) / 1000.0 * PI
	self.modulate.a = ((sin(phase) + 1.0) / 2) * 0.8 + 0.2
