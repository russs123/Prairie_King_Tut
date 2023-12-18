extends Node2D

@onready var main = get_node("/root/Main")

signal hit_p

var goblin_scene := preload("res://scenes/goblin.tscn")
var spawn_points := []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)

func _on_timer_timeout():
	#check how many enemies have already been created
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() < get_parent().max_enemies:
		#pick random spawn point
		var spawn = spawn_points[randi() % spawn_points.size()]
		#spawn enemy
		var goblin = goblin_scene.instantiate()
		goblin.position = spawn.position
		goblin.hit_player.connect(hit)
		main.add_child(goblin)
		goblin.add_to_group("enemies")

func hit():
	hit_p.emit()
