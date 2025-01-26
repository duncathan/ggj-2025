extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !GameManager.game_started:
		get_tree().paused = true
	else:
		$"../..".hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().paused = false
		GameManager.game_started = true
		$"../..".hide()
