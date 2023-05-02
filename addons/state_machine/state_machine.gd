@icon("res://state_machine.svg")
class_name StateMachine

extends Node

signal on_state_change(state:State)

# helper class to store active state
class _StateHandler:
	var state:State
	var enter_requested:bool = false
	var enter_confirmed:bool = false
	var exit_requested:bool = false
	var exit_confirmed:bool = false
	
	func _init(s:State):
		state = s
		state._confirm_enter_callback = request_enter_confirmed
		state._confirm_exit_callback = request_exit_confirmed
	
	func request_enter():
		state.age = 0
		state.request_enter()
		enter_requested = true
	
	func request_enter_confirmed():
		enter_confirmed = true
	
	func enter():
		state.age = 0
		
		# show nodes
		for node in state._resolve_node_paths(state.nodes_hide):
			node.hide()
			
		for node in state._resolve_node_paths(state.nodes_show):
			node.show()
			
		for node in state._resolve_node_paths(state.nodes_sync):
			node.show()
		
		# call enter
		state.enter()
		state.on_enter.emit()
	
	func request_exit():
		state.request_exit()
		exit_requested = true
	
	func request_exit_confirmed():
		exit_confirmed = true
		# TODO: maybe only exit after the new state is completely ready? not sure yet
		exit()
	
	func exit():
		# hide nodes
		for node in state._resolve_node_paths(state.nodes_sync):
			node.hide()
		
		state.on_exit.emit()
		state.exit()
			
	func update(delta):
		state.on_update.emit(delta)
		state.update(delta)
		state.age += delta

var _state_active:_StateHandler = null
var _state_active_pending:_StateHandler = null
var _state_previous:_StateHandler = null

@export var verbose_name:String = ""
@export var enable_console_print:bool = true
# get / setter
var state_name: String:
	get:
		return _state_active.state.name if _state_active else ""
	set(value):
		var new_state = find_child(value, false)
		if not new_state:
			console_print( "state not found: ", value)
		set_state(new_state)
		
@export var state: State:
	get:
		return get_state()
	set(value):
		set_state(value)

var state_previous:State:
	get:
		return _state_previous.state if _state_previous else null

var state_pending:State:
	get:
		return _state_active_pending.state if _state_active_pending else null

## methods
func name_formatted():
	return name if verbose_name.is_empty() else verbose_name

func _prefix():
	return "[StateMachine: %s] " % name_formatted()

func console_print(msg1, msg2=null):
	if not enable_console_print:
		return
	if msg2:
		print(_prefix(), msg1, msg2)
	else:
		print(_prefix(), msg1)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):

	# check for pending state changes
	if _state_active_pending:
		if not _state_active_pending.enter_requested:
			_state_active_pending.request_enter()
	
		if _state_active:
			if not _state_active.exit_requested:
				_state_active.request_exit()
		
		if _state_active_pending.enter_confirmed and (not _state_active or _state_active.exit_confirmed):
			_state_previous = _state_active
			_state_active = _state_active_pending
			
			# TODO: exit the previous state only when the new state is ready? for now it get exited immediately after confirming
#			if _state_previous:
#				_state_previous.exit()
#				console_print( "state exited: ", _state_previous.state.name)
			_state_active.enter()
			console_print( "state entered: ", state_name)
			_state_active_pending = null
			
			# emit state change
			on_state_change.emit(state)
			
	else:
		# update existing state
		if _state_active:
			_state_active.update(delta)

func set_state(new_state:State) -> bool:
	if not new_state:
		console_print( "set state: new state is null -> abort")
		return false
	
	var state_machine := new_state.get_state_machine()
	if state_machine != self:
		console_print( "set state: state belongs to a different state machine: ", state_machine.name if state_machine else "null")
		return false
	
	console_print( "request state: ", new_state.name)
	
	if _state_active_pending:
		console_print( "warning - another state change request has not yet completed, will abort request")
		return false
	
	if get_state() == new_state:
		if not new_state.allow_reenter:
			console_print( "state is already active and does not allow reenter: ", new_state.name)
			return false
		# just call enter again and reset the age
		_state_active.enter()
		return true
		
	_state_active_pending = _StateHandler.new(new_state)
	return true
	
func get_state()->State:
	return _state_active.state if _state_active else null

# check if a state exists
func has_state(name:String)->bool:
	var child = find_child(name, false)
	return child != null and is_instance_of(child, State)

# get a list of states
func get_states()->Array[State]:
	# could also be simplified / casted to the right array 
	# if we just assume every child is always a State 
	# (should always be the case, but no checks in place ATM)
	var states:Array[State] = []
	for child in get_children():
		if is_instance_of(child, State):
			states.append(child)
	return states
