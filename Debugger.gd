extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var eo = ExpressionObject.new()
	var stk = Stack.new()
	
	eo.add_token("1")
	eo.add_token("+")
	eo.add_token("5")
	eo.add_token("*")
	eo.add_token("[")
	eo.add_token("2")
	eo.add_token("-")
	eo.add_token("8")
	eo.add_token("]")
	
	eo.get_postfix_expression()
	eo.evaluate_expression()
	
	eo.print_expressions()
	
	print(eo.get_evaluation())
	
