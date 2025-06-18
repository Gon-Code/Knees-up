extends RefCounted

func test_player_health():
	var player = load("res://Player.tscn").instantiate()
	player.health = 5
	player.take_damage(2)
	assert(player.health == 3)
