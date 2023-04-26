# Simple State Machine for Godot 4

Each state machine consists of a StateMachine node with any amount of child State nodes.  

Each state script can automatically call hide() or show() on nodes when entering. 

State scripts can be extended for custom enter(), update() or exit() code.  

The addon also includes a control node for debugging a StateMachine and triggering states manually  

