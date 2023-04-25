@icon("res://state_machine.svg")
class_name StateMachine

extends Node

signal on_state_change(state:State)

var state:State = null
var state_previous:State = null

var state_name: String:
	get:
		return state.name if state else ""
	set(value):
		var new_state = find_child(value, false)
		if not new_state:
			print("[StateMachine] state not found: ", value)
		set_state(new_state)

var state_name_previous:String:
	get:
		return state_previous.name if state_previous else ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_state(new_state:State):
	if new_state.parent != self:
		print("[StateMachine] state is not a valid child: ", new_state)
		
	if not new_state:
		state = null
		print("[StateMachine] state set to null")
		

func has_state(name:String)->bool:
	return find_child(name, false) != null
