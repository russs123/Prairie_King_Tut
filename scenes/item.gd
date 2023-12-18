extends Area2D

@onready var main = get_node("/root/Main")
@onready var lives_label = get_node("/root/Main/Hud/LivesLabel")

var item_type : int # 0: coffee, 1: health, 2: gun

var coffee_box = preload("res://assets/items/coffee_box.png")
var health_box = preload("res://assets/items/health_box.png")
var gun_box = preload("res://assets/items/gun_box.png")
var textures = [coffee_box, health_box, gun_box]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = textures[item_type]

func _on_body_entered(body):
	#coffee
	if item_type == 0:
		body.boost()
	#health
	elif item_type == 1:
		main.lives += 1
		lives_label.text = "X " + str(main.lives)
	#gun
	elif item_type == 2:
		body.quick_fire()
	#delete item
	queue_free()
