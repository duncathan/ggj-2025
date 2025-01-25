class_name PlayerControls
extends Node2D

@onready
var Parent := get_parent() as CharacterBody2D
@onready
var MovementController := get_parent().get_node("Movement") as Movement

#func _ready():
	#for c in get_parent().get_children():
		#if c is Movement:
			#MovementController = c
			#break

@export_range(0, 1, 0.1)
var max_sens := 0.9
func _physics_process(delta):
	# put max speed at 90% of the analog stick
	MovementController.moveRight = min(Input.get_action_strength("game_right") / max_sens, 1.0)
	MovementController.moveLeft = min(Input.get_action_strength("game_left") / max_sens, 1.0)
	MovementController.beginJump = Input.is_action_just_pressed("game_jump")
	MovementController.holdJump = Input.is_action_pressed("game_jump")
	MovementController.drop = Input.is_action_pressed("game_down") and \
			Input.is_action_just_pressed("game_jump")
	MovementController.fastFall = Input.is_action_pressed("game_down")
