@icon("res://state.svg")
class_name State
extends Node

signal on_enter
signal on_exit
signal on_update(delta:float)

@export var allow_reset:bool = false

var age:float = 0

# Called when the state gets activated
func enter() -> void:
	pass # Replace with function body.

# called when the state gets deactivated
func exit() -> void:
	pass

func update(delta) -> void:
	pass
