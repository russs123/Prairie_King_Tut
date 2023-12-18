extends Node

var wave : int
var difficulty : float
const DIFF_MULTIPLIER : float = 1.2
var max_enemies : int
var lives : int

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	$GameOver/Button.pressed.connect(new_game)

func new_game():
	lives = 3
	wave = 1
	difficulty = 10.0
	$EnemySpawner/Timer.wait_time = 1.0
	reset()

func reset():
	max_enemies = int(difficulty)
	$Player.reset()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("items", "queue_free")
	$Hud/LivesLabel.text = "X " + str(lives)
	$Hud/WaveLabel.text = "WAVE: " + str(wave)
	$Hud/EnemiesLabel.text = "X " + str(max_enemies)
	$GameOver.hide()
	get_tree().paused = true
	$RestartTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_wave_completed():
		wave += 1
		#adjust difficulty
		difficulty *= DIFF_MULTIPLIER
		if $EnemySpawner/Timer.wait_time > 0.25:
			$EnemySpawner/Timer.wait_time -= 0.05
		get_tree().paused = true
		$WaveOverTimer.start()

func _on_enemy_spawner_hit_p():
	lives -= 1
	$Hud/LivesLabel.text = "X " + str(lives)
	get_tree().paused = true
	if lives <= 0:
		$GameOver/WavesSurvivedLabel.text = "WAVES SURVIVED: " + str(wave - 1)
		$GameOver.show()
	else:
		$WaveOverTimer.start()

func _on_wave_over_timer_timeout():
	reset()

func _on_restart_timer_timeout():
	get_tree().paused = false

func is_wave_completed():
	var all_dead = true
	var enemies = get_tree().get_nodes_in_group("enemies")
	#check if all enemies have spawned first
	if enemies.size() == max_enemies:
		for e in enemies:
			if e.alive:
				all_dead = false
		return all_dead
	else:
		return false
