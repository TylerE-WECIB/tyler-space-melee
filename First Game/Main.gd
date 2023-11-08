extends Node

export(PackedScene) var mob_scene
var score = 0
var high_score = 0
var music_started = false
var random_noise

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_node("Player/Shine").connect("enemy_hit", self, "boost_score")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$DeathSound.play()
	$ScoreTimer.stop() # Replace with function body.
	$MobTimer.stop()
	$HUD.show_game_over(score, high_score)
	high_score = score if score > high_score else high_score

func new_game():
	if music_started == false:
		$Music.play()
		music_started = true
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score, high_score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score, high_score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func boost_score():
	score += 5
	if randi()%5+1 > 0:
		random_noise = randi()%7+1
		match random_noise:
			1:
				$FoxGrunt1.play()
			2:
				$FoxGrunt2.play()
			3:
				$FoxGrunt3.play()
			4:
				$FoxGrunt4.play()
			5:
				$FoxGrunt5.play()
			6:
				$FoxGrunt6.play()
			7:
				$FoxGrunt7.play()
	$HUD.update_score(score, high_score)
