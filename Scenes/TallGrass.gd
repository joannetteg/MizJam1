extends Area2D

signal trigger_battle(roll)

func roll_d20():
	var randomRoll = round(rand_range(0, 21))
	return randomRoll

func _on_TallGrass_body_entered(body):
	if body.name == "Player":
		print("Player in Grass")
		var currentRoll = roll_d20()
		print(currentRoll)
		if currentRoll == 18:
			#print("Easy Fight")
			emit_signal("trigger_battle", currentRoll)
		if currentRoll == 19:
			#print("Medium Fight")
			emit_signal("trigger_battle", currentRoll)
		if currentRoll == 20:
			#print("Hard Fight")
			emit_signal("trigger_battle", currentRoll)
			
