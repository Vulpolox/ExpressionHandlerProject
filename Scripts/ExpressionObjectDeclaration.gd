class_name ExpressionObjectDeclaration

# data members

var current_expression: Array # holds infix expression
var prefix_expression: Array # holds postfix expression
var postfix_expression: Array # holds prefix expression
var evaluation: float # holds the evaluated expression


# strings to use with the membership operator

var open_parentheses = "([{"
var closed_parentheses = ")]}"
var valid_operators = "*/+-"


# Constructor

func _init():
	self.current_expression = []
	self.postfix_expression = []
	self.prefix_expression = []
	self.evaluation = NAN


# Methods

# pre  -- takes a left and a right parenthesis
# post -- returns true if they match, else false
func is_matching_parentheses(left: String, right: String) -> bool:
	return false

# pre  -- takes no arguments
# post -- returns true if the parentheses are balanced in current_expression
func is_balanced() -> bool:
	return false

# pre  -- takes no arguments
# post -- clears expressions
func clear_expression() -> void:
	pass
	
# pre  -- takes no arguments
# post -- if is_balanced(), evaluates expression and stores result in evaluation
func evaluate_expression() -> void:
	pass
	
# pre  -- takes no arguments
# post -- if is_balanced(), creates a postfix expression and stores it in postfix_expression
func get_postfix_expression() -> void:
	pass

# pre  -- takes no arguments
# post -- if is_balanced(), creates a prefix expression and stores it in prefix_expression
func get_prefix_expression() -> void:
	pass

# pre  -- takes a String as an argument, token
# post -- pushes token to the back of current_expression
func add_token(toAdd: String) -> void:
	pass

# pre  -- takes no arguments
# post -- prints each expression type for debugging purposes
func print_expressions() -> void:
	pass
		
	
	

	

	