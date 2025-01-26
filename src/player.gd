extends CharacterBody2D

func _ready() -> void:
	if GameManager.return_pos != null:
		self.position = GameManager.return_pos
