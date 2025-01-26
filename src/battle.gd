extends Node2D

@onready
var fish_sprite: Sprite2D = get_node("Fish")
@onready
var dialog_runner: DialogueRunner = get_node("Control/BattleMenu/MainBox/DialogueRunner")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fish := GameManager.current_fish
	self.fish_sprite.texture = fish.texture
	if fish.recruit_id != "WhatLiesAbove":
		self.fish_sprite.modulate = fish.modulate
	else:
		$background.visible = false
		$evil_background.visible = true
	self.dialog_runner.StartDialogue(fish.start_node)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dialogue_runner_on_dialogue_complete() -> void:
	GameManager.leave_battle()
