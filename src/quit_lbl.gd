extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		pass


func _on_pressed() -> void:
	$"../../../../../AudioStreamPlayer2".play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
