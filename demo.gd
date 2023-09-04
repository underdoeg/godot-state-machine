extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$state_machine.state_name = "nothing"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_state_machine_state_changed(state):
	print("============= DEMO STATE CHANGE LISTENER: ", state.name)
