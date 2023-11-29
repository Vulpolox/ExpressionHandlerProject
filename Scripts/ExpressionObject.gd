class_name ExpressionObject extends "ExpressionObjectDeclaration.gd"

func is_matching_parentheses(left: String, right: String) -> bool:
	
	# if parentheses are not passed as arguments
	if self.open_parentheses.find(left) == -1 or self.closed_parentheses.find(right) == -1:
		print("error in is_matching_parentheses(); a parenthesis is not valid")
		print("left is " + left + " right is " + right)
		return false
	else:
		return right == self.closed_parentheses[self.open_parentheses.find(left)]


func is_balanced() -> bool:
	
	var parenthesis_stack = Stack.new()
	
	# iterate through every token in the current expression
	for token in self.current_expression:
		
		# if token is an open parenthesis
		if token in self.open_parentheses:
			parenthesis_stack.push(token) # add it to the stack
			
		# if token is a closed parenthesis
		elif token in self.closed_parentheses:
			
			# if a closed parenthesis is encountered before an open one of the same type
			if parenthesis_stack.empty():
				return false # expression is unbalanced
				
			# if top of the stack doesn't match with the token
			elif not is_matching_parentheses(parenthesis_stack.top(), token):
				return false # expression is unbalanced
				
			# if top of the stack matches with the token
			else:
				parenthesis_stack.pop() # remove the open parenthesis from the stack
	
	# if the stack is empty after iterating through all tokens
	if parenthesis_stack.empty():
		return true # expression is balanced
	
	return false # expression contains unpaired open parentheses and is unbalanced


func clear_expression() -> void:
	
	self.current_expression = []
	self.postfix_expression = []
	self.prefix_expression = []
	self.evaluation = NAN


func evaluate_expression() -> void:
	
	var operand_stack = Stack.new()
	var left: String
	var right: String
	
	# iterate through all tokens in the postfix expression
	for token in self.postfix_expression:
		
		# if the token is an operand, add it to the stack
		if token.is_valid_int():
			operand_stack.push(token)
		
		# if token is an operator
		elif token in self.valid_operators:
			right = operand_stack.top()
			operand_stack.pop()
			left = operand_stack.top()
			operand_stack.pop()
			
			# find the type of operator, do the operation, and push to the stack
			if token == "+":
				operand_stack.push(str(float(left) + float(right)))
			elif token == "-":
				operand_stack.push(str(float(left) - float(right)))
			elif token == "*":
				operand_stack.push(str(float(left) * float(right)))
			elif token == "/" and int(right) != 0:
				operand_stack.push(str(float(left) / float(right)))
			else: # division by 0
				self.evaluation = NAN
				return
	
	self.evaluation = float(operand_stack.top())


func get_postfix_expression() -> void:
	
	self.postfix_expression = []
	var matching_left_parenthesis: String
	
	# if the input expression is unbalanced
	if not self.is_balanced():
		self.postfix_expression.append("Cannot convert; expression is unbalanced")
		return
	
	var operator_stack = Stack.new()
	
	# iterate through each token in the infix expression
	for token in self.current_expression:
		
		# if the token is an operand
		if token.is_valid_int():
			self.postfix_expression.append(token) # push it to output
		
		# if token is an open parenthesis
		elif token in self.open_parentheses:
			operator_stack.push(token) # push it onto stack
		
		# if token is a closed parenthesis
		elif token in self.closed_parentheses:
		
			matching_left_parenthesis = self.open_parentheses[self.closed_parentheses.find(token)]
			
			
			# while top element in the stack isn't the matching left parenthesis
			while operator_stack.top() != matching_left_parenthesis:
				
				self.postfix_expression.append(operator_stack.top()) # add operators to output until opening par
				operator_stack.pop() # remove operator from stack
			operator_stack.pop() # remove left parenthesis from stack
		
		# if token is an operator
		elif token in self.valid_operators:
			
			# while stack is not empty and token precedence <= top stack precedence
			while not operator_stack.empty() and self.get_precedence(token) <= self.get_precedence(operator_stack.top()):
				
				self.postfix_expression.append(operator_stack.top()) # add operator from stack
				operator_stack.pop() # remove operator from stack
			operator_stack.push(token) # add the current token to the operator stack
		
	# add remaining operators in stack to expression
	while not operator_stack.empty():
		self.postfix_expression.append(operator_stack.top())
		operator_stack.pop()


func get_prefix_expression() -> void:
	
	self.prefix_expression = []
	
	# if the input expression is unbalanced
	if not self.is_balanced():
		self.prefix_expression.append("Cannot convert; expression is unbalanced")
		return

	var temp_expression = self.current_expression.duplicate()
	var adjusted_postfix = []
	
	temp_expression.reverse() # reverse order of infix expression
	
	# flip direction of all parentheses in flipped infix expression
	for i in range(temp_expression.size()):
		temp_expression[i] = self.flip_parentheses(temp_expression[i])
	
	## convert expression to postfix ##
	###################################
	
	
	var operator_stack = Stack.new()
	var matching_left_parenthesis
	
	# iterate through each token in the infix expression
	for token in temp_expression:
		
		# if the token is an operand
		if token.is_valid_int():
			adjusted_postfix.append(token) # push it to output
		
		# if token is an open parenthesis
		elif token in self.open_parentheses:
			operator_stack.push(token) # push it onto stack
		
		# if token is a closed parenthesis
		elif token in self.closed_parentheses:
		
			matching_left_parenthesis = self.open_parentheses[self.closed_parentheses.find(token)]
			
			# while top element in the stack isn't the matching left parenthesis
			while operator_stack.top() != matching_left_parenthesis and not operator_stack.empty():
				
				adjusted_postfix.append(operator_stack.top()) # add operators to output until opening par
				operator_stack.pop() # remove operator from stack
			operator_stack.pop() # remove left parenthesis from stack
		
		# if token is an operator
		elif token in self.valid_operators:
			
			# while stack is not empty and token precedence <= top stack precedence
			while not operator_stack.empty() and self.get_precedence(token) <= self.get_precedence(operator_stack.top()):
				
				adjusted_postfix.append(operator_stack.top()) # add operator from stack
				operator_stack.pop() # remove operator from stack
			operator_stack.push(token) # add the current token to the operator stack
		
	# add remaining operators in stack to expression
	while not operator_stack.empty():
		adjusted_postfix.append(operator_stack.top())
		operator_stack.pop()
		
	# flip order of this adjusted postfix expression; it is now prefix
	adjusted_postfix.reverse()
	self.prefix_expression = adjusted_postfix
	

func add_token(toAdd: String) -> void:
	
	self.current_expression.append(toAdd)


func print_expressions() -> void:
	
	print("Infix Expression:")
	print("   " + self.get_infix())
	print("Postfix Expression:")	
	print("   " + self.get_postfix())
	print("Prefix Expression:")
	print("   " + self.get_prefix())


func get_precedence(operator: String) -> int:
	
	if operator == "*" or operator == "/":
		return 2
	elif operator == "+" or operator == "-":
		return 1
	else:
		return 0

func flip_parentheses(parenthesis: String) -> String:
	
	if parenthesis in self.open_parentheses:
		return self.closed_parentheses[self.open_parentheses.find(parenthesis)]
	elif parenthesis in self.closed_parentheses:
		return self.open_parentheses[self.closed_parentheses.find(parenthesis)]
	else:
		return parenthesis # input was not a parenthesis

func get_infix() -> String:
	var out = ""
	for element in self.current_expression:
		out += (element + " ")
	return out


func get_postfix() -> String:
	var out = ""
	for element in self.postfix_expression:
		out += (element + " ")
	return out


func get_prefix() -> String:
	var out = ""
	for element in self.prefix_expression:
		out += (element + " ")
	return out


func get_evaluation() -> float:
	return self.evaluation
