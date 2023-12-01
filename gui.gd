extends CanvasLayer

var input_string: String = "" # string for storing token inputs from button presses
var input_panel # for storing a reference to the input panel
var output_panel # for storing a reference to the output panel
var converted_flag: bool = false # keeps track of whether the expression has successfully been converted
var expression = ExpressionObject.new() # for storing and manipulating the expression

func _ready():
	
	# store token and operation buttons in variables
	var token_buttons = get_tree().get_nodes_in_group("tokens")
	var operation_buttons = get_tree().get_nodes_in_group("operations")
	
	# connect token_buttons' "pressed" signal to the token_button_pressed function
	for button in token_buttons:
		var button_string: String = button.get_text()
		button.pressed.connect(token_button_pressed.bind(button_string))
	
	# connect operation_buttons' "pressed" signal to the operation_button_pressed function
	for button in operation_buttons:
		var button_string: String = button.get_text()
		button.pressed.connect(operation_button_pressed.bind(button_string))
		
	# get references to the input and output panels
	input_panel = $InputLabel
	output_panel = $OutputLabel


# function for handling token button presses
func token_button_pressed(button_string: String) -> void:
	
	converted_flag = false # modified expression, so need to convert it again
	input_string += button_string
	input_panel.set_text(input_string)


# function for handling operation button presses
func operation_button_pressed(button_string: String):
	
	match button_string:
		
		"CLEAR":
			input_panel.set_text("")
			output_panel.set_text("")
			input_string = ""
			expression.clear_expression()
			converted_flag = false
			
		"CHECK IF BALANCED":
			check_if_set()
			
			if expression.is_balanced():
				output_panel.set_text("EXPRESSION IS BALANCED")
			else:
				output_panel.set_text("EXPRESSION IS UNBALANCED")
			
		"EVALUATE":
			check_if_set()
			
			if not expression.is_balanced():
				output_panel.set_text("CANNOT EVALUATE, EXPRESSION IS UNBALANCED")
			else:
				expression.get_postfix_expression()
				expression.evaluate_expression()
				output_panel.set_text(str(expression.get_evaluation()))
				
		"CONVERT TO POSTFIX":
			check_if_set()
			
			if not expression.is_balanced():
				output_panel.set_text("CANNOT EVALUATE, EXPRESSION IS UNBALANCED")
			else:
				expression.get_postfix_expression()
				var postfix = expression.get_postfix()
				output_panel.set_text(postfix)
		
		"CONVERT TO PREFIX":
			check_if_set()
			
			if not expression.is_balanced():
				output_panel.set_text("CANNOT EVALUATE, EXPRESSION IS UNBALANCED")
			else:
				expression.get_prefix_expression()
				var prefix = expression.get_prefix()
				output_panel.set_text(prefix)


# function for parsing input string into tokens
func parse_input(input: String) -> Array:
	
	var output_tokens = []
	var current_number: String = "" # for keeping track of multi-digit numbers
	
	for i in range(input.length()):
		
		# if the current char is a number
		if input[i].is_valid_int():
			current_number += input[i]
			continue
		
		# if the boundary between a number and a non-number is found, add the number and the non-number as separate tokens
		elif not input[i].is_valid_int() and current_number.is_valid_int():
			output_tokens.append(current_number)
			output_tokens.append(input[i])
			current_number = ""
		
		# if there isn't a multi-digit number being created
		else:
			output_tokens.append(input[i])
	
	# add the remaining number after the loop finishes executing if it exists
	if current_number != "":
		output_tokens.append(current_number)
		
	return output_tokens

# function for seeing if the expression has been converted and set to the ExpressionObject's current_expression
func check_if_set() -> void:
	
	if not converted_flag:
		var to_set: Array = parse_input(input_string)
		expression.set_current_expression(to_set)
		converted_flag = true
