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

func start_battle(fish: FishProperties):
	self.current_fish = fish
	self.return_pos = fish.return_pos
	get_tree().call_deferred("change_scene_to_packed", battle)

func lose_battle():
	# TODO: game over?
	leave_battle()

func win_battle():
	self.recruits[self.current_fish.recruit_id] = true
	leave_battle()

func leave_battle():
	get_tree().call_deferred("change_scene_to_packed", overworld)
