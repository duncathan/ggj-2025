extends Node

const battle := preload("res://src/battle.tscn")
const overworld := preload("res://src/main_scene.tscn")

var current_fish: FishProperties

var return_pos = null

var recruits: Dictionary = {
	"Breathing": false,
	"Austere": false,
	"Hand": false,
	"Boyfriends": false,
	"WhatLiesAbove": false,
}

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
	get_tree().call_deferred("change_scene_to_packed", overworld)
