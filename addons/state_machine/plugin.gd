@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("StateMachine", "Node", preload("state_machine.gd"), preload("state_machine.svg"))
	add_custom_type("State", "Node", preload("state.gd"), preload("state.svg"))


func _exit_tree():
	remove_custom_type("StateMachine")
	remove_custom_type("State")
