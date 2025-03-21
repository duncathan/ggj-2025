extends Node2D

@onready
var fish_sprite: Sprite2D = get_node("Fish")
@onready
var dialog_runner: DialogueRunner = get_node("Control/BattleMenu/MainBox/DialogueRunner")
@onready
var line_view: LineView = get_node("Control/BattleMenu/MainBox/HBoxContainer/PanelContainer/LineView")
@onready
var bubble_label: Label = get_node("Control/BattleMenu/Bubble Counter/BubbleLabel")

var should_reset: bool = true

const boss_music = preload("res://assets/music/dark-piano-ambient-background-music-wasteland-275331.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fish := GameManager.current_fish
	self.fish_sprite.texture = fish.texture
	if fish.recruit_id != "WhatLiesAbove":
		self.fish_sprite.modulate = fish.modulate
	else:
		self.fish_sprite.modulate = Color.WHITE
		$background.visible = false
		$evil_background.visible = true
		$AudioStreamPlayer.stream = boss_music
	
	$AudioStreamPlayer.play()
	
	self.dialog_runner.AddCommandHandlerCallable("lose_air", self.lose_air)
	self.dialog_runner.AddCommandHandlerCallable("blow_bubble", self.blow_bubble)
	
	self.dialog_runner.StartDialogue(fish.start_node)
	

func lose_air(turns: int) -> void:
	GameManager.bubble_timer -= turns
	self.bubble_label.text = str(GameManager.bubble_timer)
	if GameManager.bubble_timer <= 0:
		self.should_reset = false
		self.dialog_runner.Stop()
		self.dialog_runner.call_deferred("StartDialogue", "Lose")

func blow_bubble() -> void:
	# TODO: minigame? animation? something?
	self.should_reset = false
	self.dialog_runner.Stop()
	if GameManager.total_recruits() >= GameManager.current_fish.need_recruits:
		self.dialog_runner.call_deferred("StartDialogue", "Win")
	else:
		self.dialog_runner.call_deferred("StartDialogue", "BubbleFail")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("advance_dialog"):
		self.line_view.UserRequestedViewAdvancement()


func _on_dialogue_runner_on_dialogue_complete() -> void:
	if self.should_reset:
		GameManager.leave_battle()
	self.should_reset = true
