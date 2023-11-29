extends Node

class Stack:
	
	#data members
	var data
	
	#constructor
	func _init():
		data = []
		
	#methods
	
	# pre  -- takes a value
	# post -- adds an element to the stack
	func push(toAdd) -> void:
		pass
	
	# pre  -- takes no arguments
	# post -- removes an element from the stack
	func pop() -> void:
		pass
	
	# pre  -- takes no arguments
	# post -- returns true if data.empty() returns true, otherwise false
	func empty() -> bool:
		return false
	
	# pre  -- takes no arguments
	# post -- returns the top element from the stack
	func top() -> Variant:
		return null
