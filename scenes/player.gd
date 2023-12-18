extends CharacterBody2D

signal shoot

const START_SPEED : int = 200
const BOOST_SPEED : int = 400
const NORMAL_SHOT : float = 0.5
const FAST_SHOT : float = 0.1
var speed : int
var can_shoot : bool
var screen_size : Vector2

func _ready():
	screen_size = get_viewport_rect().size
	reset()

func reset():
	can_shoot = true
	position = screen_size / 2
	speed = START_SPEED
	$ShotTimer.wait_time = NORMAL_SHOT

func get_input():
	#keyboard input
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir.normalized() * speed
	
	#mouse clicks
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir)
		can_shoot = false
		$ShotTimer.start()

func _physics_process(_delta):
	#player movement
	get_input()
	move_and_slide()
	
	#limit movemement to window size
	position = position.clamp(Vector2.ZERO, screen_size)
	
	#player rotation
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI / 4) / (PI / 4)
	angle = wrapi(int(angle), 0, 8)
	
	$AnimatedSprite2D.animation = "walk" + str(angle)
	
	#player animation
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1

func boost():
	$BoostTimer.start()
	speed = BOOST_SPEED

func quick_fire():
	$FastFireTimer.start()
	$ShotTimer.wait_time = FAST_SHOT

func _on_shot_timer_timeout():
	can_shoot = true

func _on_boost_timer_timeout():
	speed = START_SPEED

func _on_fast_fire_timer_timeout():
	$ShotTimer.wait_time = NORMAL_SHOT
