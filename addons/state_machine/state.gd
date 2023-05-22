@icon("res://addons/state_machine/state.svg")
class_name State
extends Node

signal on_enter
signal on_exit
signal on_update(delta:float)

# set to true if the state can be reactivated even if it is already active. So enter will get called again
@export var allow_reenter:bool = false

@export var verbose_name:String = ""

######### Auto show hide node paths
# TODO: actually export an array of nodes and not paths, but this is buggy ATM but should be fixed in godot 4.1
# a list of nodes that get called .show() on enter and .hide() on exit 
@export var nodes_sync:Array[NodePath] = []

# a list of nodes that get called .show() on enter
@export var nodes_show:Array[NodePath] = []

# a list of nodes that get called .hide() on enter
@export var nodes_hide:Array[NodePath] = []

func name_formatted():
	return name if verbose_name.is_empty() else verbose_name

func _prefix():
	return "[State: %s] " % name_formatted()

# age of this state
var age:float = 0

# activate this state in the state manager
func activate():
	var state_machine = get_state_machine()
	if not state_machine:
		return
	state_machine.state = self	

# called when the state manager wants to enter this state
func request_enter():
	confirm_enter()

# Called when the state gets activated
func enter():
	pass
	
# called when the state manager wants to exit this state
func request_exit():
	confirm_exit()

# called when the state gets deactivated
func exit() -> void:
	pass

# called on every frame update
func update(delta:float) -> void:
	pass

# utilities
func get_state_machine()->StateMachine:
	var parent = get_parent()
	if is_instance_of(parent, StateMachine):
		return parent
	print(_prefix(), "Cannot retrieve associated state machine")
	return null

########################################################################
## these are internal properties and methods of the state machine system

# confirm that this state can enter
func confirm_enter() -> void:
	if _confirm_enter_callback == null or _confirm_enter_callback.is_null():
		print(_prefix(), "Cannot confirm enter, callback is null")
		return
	_confirm_enter_callback.call()
		

# confirm that this state can exit
func confirm_exit() -> void:
	if _confirm_exit_callback == null or _confirm_exit_callback.is_null():
		print(_prefix(), "Cannot confirm exit, callback is null")
		return
	_confirm_exit_callback.call()

var _confirm_enter_callback = Callable()
var _confirm_exit_callback = Callable()

### helper
func _resolve_node_paths(paths_a:Array[NodePath])->Array[Node]:
	var ret:Array[Node] = []
	for p in paths_a:
		var node = get_node(p)
		if node:
			ret.append(node)
	return ret
