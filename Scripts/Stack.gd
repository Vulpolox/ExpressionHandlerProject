class_name Stack extends "StackDeclaration.gd"

func push(toAdd: Variant) -> void:
	
	self.data.append(toAdd)
	

func pop() -> void:
	
	if self.empty():
		print("Cannot remove from empty stack")
	else:
		self.data.pop_back()
		

func empty() -> bool:
	
	return self.data.is_empty()


func top() -> Variant:
	
	if self.empty():
		print("Cannot access top element of empty stack")
		return null
	else:
		return self.data[-1]
