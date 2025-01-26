extends Node

const battle := preload("res://src/battle.tscn")
const overworld := preload("res://src/main_scene.tscn")
const win_screen := preload("res://src/winScreen.tscn")

var current_fish: FishProperties

var return_pos = null

var game_started = false

var recruits: Dictionary = {
	"Breathing": false,
	"Austere": false,
	"Hand": false,
	"Boyfriends": false,
	"WhatLiesAbove": false,
}

func total_recruits() -> int:
	var i := 0
	for x in recruits.values():
		if x:
			i += 1
	return i

var bubble_timer := 10

func start_battle(fish: FishProperties):
	self.current_fish = fish
	self.return_pos = fish.return_pos
	self.bubble_timer = 10
	get_tree().call_deferred("change_scene_to_packed", battle)

func leave_battle():
	if self.bubble_timer > 10:
		# win the battle
		self.recruits[self.current_fish.recruit_id] = true
		if self.current_fish.recruit_id == "WhatLiesAbove":
			get_tree().call_deferred("change_scene_to_packed", win_screen)
			return
	get_tree().call_deferred("change_scene_to_packed", overworld)
