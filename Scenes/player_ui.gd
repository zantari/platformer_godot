extends Control

var currentPoints = 0
var deaths = 0
var currLevel = 0

func setCurrLevel(level):
	currLevel = level
	$CanvasLayer/MarginContainer2/Label.text = "Level: "+ str(currLevel)

func setPoints(points):
	currentPoints = points

func add_death():
	deaths+=1
func add_points():
	currentPoints+=1


	


func _process(delta: float) -> void:
	if deaths<=10:
		$CanvasLayer/MarginContainer3/HBoxContainer/Label.text = "0" + str(deaths)
	else:
		$CanvasLayer/MarginContainer3/HBoxContainer/Label.text = str(deaths)
	if(PlayerData.getMoney()>=10):
		$CanvasLayer/MarginContainer/HBoxContainer/Label.text = str(currentPoints)
	else:
		$CanvasLayer/MarginContainer/HBoxContainer/Label.text = "0"+str(currentPoints)
	

func _on_button_pressed() -> void:
	$CanvasLayer/Button.release_focus() # TO WYWALA FOCUS Z PRZYCISKU
	
	get_tree().call_group("Player", "kill")
	$CanvasLayer/Button.disabled = true
	
	await get_tree().create_timer(2.0).timeout
	
	$CanvasLayer/Button.disabled  = false
