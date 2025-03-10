extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !GameManager.game_started:
		get_tree().paused = true
		grab_focus()
	else:
		$"../../..".hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		pass


func _on_pressed() -> void:
	get_tree().paused = false
	GameManager.game_started = true
	$"../../..".hide()
