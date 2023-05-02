extends PanelContainer

@export var state_machine:StateMachine:
	get:
		return state_machine
	set(value):
		state_machine = value 

func _ready():
	
	if state_machine:
		_setup_state_machine()

func _setup_state_machine():
	if not state_machine:
		return
	
	%title.text = state_machine.name_formatted()
	
	for child in %state_buttons.get_children():
		child.queue_free()
	
	var states = state_machine.get_states()
	for state in states:
		var btn = Button.new()
		btn.text = state.name_formatted()
		btn.pressed.connect(state_machine.set_state.bind(state))
		%state_buttons.add_child(btn)

func _process(delta):
	if not state_machine:
		return
	
	var state = state_machine.state
	if state:
		%state.text = state.name_formatted()
		%state_age.text = "%s" % (roundf(state.age * 100)  / 100.)
	else:
		%state.text = "--"

	if state_machine.state_pending:
		%state_pending.text = state_machine.state_pending.name_formatted()
	else:
		%state_pending.text = "--"

	if state_machine.state_previous:
		%state_prev.text = state_machine.state_previous.name
	else:
		%state_prev.text = "--"
	
