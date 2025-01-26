extends Node2D

@onready
var fish_sprite: Sprite2D = get_node("Fish")
@onready
var dialog_runner: DialogueRunner = get_node("Control/BattleMenu/MainBox/DialogueRunner")
@onready
var bubble_label: Label = get_node("Control/BattleMenu/Bubble Counter/BubbleLabel")

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
	self.dialog_runner.AddCommandHandlerCallable("lose_air", self.lose_air)
	

func lose_air(turns: int) -> void:
	GameManager.bubble_timer -= turns
	self.bubble_label.text = str(GameManager.bubble_timer)
	if GameManager.bubble_timer <= 0:
		GameManager.leave_battle()
		# TODO: play dialog when losing?

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dialogue_runner_on_dialogue_complete() -> void:
	GameManager.leave_battle()
