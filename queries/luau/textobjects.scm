(function_declaration
  body: (block) @function.inner) @function.outer

(function_definition
  body: (block) @function.inner) @function.outer

(parameters
  (parameter) @parameter.inner)

(parameters
  (parameter) @parameter.outer)

(arguments
  (_) @parameter.inner)

(arguments
  (_) @parameter.outer)

(function_call) @call.outer

(function_call
  arguments: (arguments) @call.inner)

(table_constructor) @class.outer

(table_constructor
  (field) @class.inner)

(if_statement) @conditional.outer

(if_statement
  consequence: (block) @conditional.inner)

(elseif_statement) @conditional.outer

(elseif_statement
  consequence: (block) @conditional.inner)

(else_statement) @conditional.outer

(else_statement
  body: (block) @conditional.inner)

(for_statement) @loop.outer

(for_statement
  body: (block) @loop.inner)

(while_statement) @loop.outer

(while_statement
  body: (block) @loop.inner)

(return_statement) @return.outer

(return_statement
  (expression_list) @return.inner)

(comment) @comment.outer

(_
  (block) @block.inner) @block.outer
