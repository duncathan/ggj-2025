@tool
extends Node2D

@export
var fish_data: FishProperties

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint() and GameManager.recruits[self.fish_data.recruit_id]:
		queue_free()
		return
	
	self.modulate = self.fish_data.modulate


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if Engine.is_editor_hint():
		return
	GameManager.start_battle(self.fish_data)
