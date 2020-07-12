(*
 *	Parser.ml 
 *
 *	Contains implementation of all functions and attribute of Parser module.
 *
 *)

(* TODO: Consider seeing if I can migrate the S-Expression stuff to its own class. *)
(* TODO: "Value" is gonna need to change a lot when s_value becomes a string as well*)

open Token;;

type s_expression =
	| Value of { value: float }
	| Boolean of { boolean: bool }
	| Symbol of { symbol: string }
	| Definition of
	{
		variable: string;
		expression: s_expression;
	} 
	| Conditional of 
	{ 
		condition: s_expression; 
		conseq: s_expression;
		alt: s_expression;
	}
	| Lambda of 
	{
		args: string list;
		procedure: s_expression;
	}
	| Func_Call of
	{
		name: s_expression;
		args: s_expression list;
	}

type s_expr_processor =
{
	source: token list;
	current: int;
}

(* 
 * Input: token list
 * Returns: s_expression * token list
 * Does: Given a valid sequence of tokens, produces a corresponding
 * AST.  If sequence is not valid, error is raised.
 *)
let rec tokens_to_s_expr list_of_tokens =
	match list_of_tokens with
	| ({ generic_type = LEFT_PAREN; _ } :: remaining_tokens) -> 
		(match remaining_tokens with
		| ({ generic_type = IF; _ } :: remaining_tokens) -> tokens_to_s_expr_if remaining_tokens
		| ({ generic_type = LAMBDA; _ } :: remaining_tokens) -> tokens_to_s_expr_lambda remaining_tokens
		| ({ generic_type = DEFINE; _ } :: remaining_tokens) -> tokens_to_s_expr_define remaining_tokens
		| ({ generic_type = SYMBOL; literal_type = Some (SYMBOL_LITERAL symbol_string); _ } :: remaining_tokens) -> tokens_to_s_expr_func_call remaining_tokens
		| _ -> failwith "Syntax error.")

	| ({ generic_type = NUMBER; literal_type = Some (NUMBER_LITERAL number_float); _ } :: remaining_tokens) -> (Value { value = number_float }, remaining_tokens)
	| ({ generic_type = BOOLEAN bool_value; _ } :: remaining_tokens) -> (Boolean { boolean = bool_value }, remaining_tokens)
	| ({ generic_type = SYMBOL; literal_type = Some (SYMBOL_LITERAL symbol_string); _ } :: remaining_tokens) -> (Symbol { symbol = symbol_string }, remaining_tokens)

	| _ -> failwith "Syntax error."

(*
 * Input: token list
 * Returns: s_expression * token list
 * Does: Recurses appropriately to create a well formed "COnditional" struct.
 *)
and tokens_to_s_expr_if remaining_tokens =
	let (s_condition, remaining_tokens) = tokens_to_s_expr remaining_tokens in
	let (s_conseq, remaining_tokens) = tokens_to_s_expr remaining_tokens in
	let (s_alt, remaining_tokens) = tokens_to_s_expr remaining_tokens in
	match remaining_tokens with
	| ({ generic_type = RIGHT_PAREN; _ } :: remaining_tokens) ->
		(
			Conditional 
			{
				condition = s_condition;
				conseq = s_conseq;
				alt = s_alt;
			},
			remaining_tokens
		)
	| _ -> failwith "Syntax error."

(*
 * Input: token list
 * Returns: s_expression * token list
 * Does: Recurses appropriately to create a well formed "Lambda" struct.
 *)
and tokens_to_s_expr_lambda list_of_tokens =
	match list_of_tokens with
	| ({ generic_type = LEFT_PAREN; _ } :: remaining_tokens) ->

		(*
		 * Input: string list, token list
		 * Returns: string list * token list
		 * Does: Iterates down a list of tokens and adds symbols to a list until a "RIGHT_PAREN" token is reached.  If any other token 
		 * is found, an error is thrown.
		 *)
		let rec collect_symbols list_of_symbols list_of_tokens =
			(match list_of_tokens with
			| ({ generic_type = RIGHT_PAREN; _ } :: remaining_tokens) -> (list_of_symbols, remaining_tokens)
			| ({ generic_type = SYMBOL; literal_type = Some (SYMBOL_LITERAL symbol_string); _ } :: remaining_tokens) -> collect_symbols (symbol_string :: list_of_symbols) remaining_tokens
			| _ -> failwith "Syntax error.") in
		let (list_of_symbols, remaining_tokens) = collect_symbols [] remaining_tokens in
		let (lambda_expr, remaining_tokens) = tokens_to_s_expr remaining_tokens in
		(match remaining_tokens with
		| ({ generic_type = RIGHT_PAREN; _ } :: remaining_tokens) -> 
			(
				Lambda
				{
					args = list_of_symbols;
					procedure = lambda_expr;
				},
				remaining_tokens
			)
		| _ -> failwith "Syntax error.")
	| _ -> failwith "Syntax error."

(*
 * Input: token list
 * Returns: s_expression * token list
 * Does: Recurses appropriately to create a well formed "Definition" struct.
 *)
and tokens_to_s_expr_define list_of_tokens =
	match list_of_tokens with
	| ({ generic_type = SYMBOL; literal_type = Some (SYMBOL_LITERAL symbol_string); _ } :: remaining_tokens) ->
		let (s_expr, remaining_tokens) = tokens_to_s_expr remaining_tokens in
		(match remaining_tokens with
		| ({ generic_type = RIGHT_PAREN; _ } :: remaining_tokens) ->
			(
				Definition
				{
					variable = symbol_string;
					expression = s_expr;
				},
				remaining_tokens
			)
		| _ -> failwith "Syntax error.")
	| _ -> failwith "Syntax error."

(*
 * Input: token list
 * Returns: s_expression * token list
 * Does: Recurses appropriately to create a well formed "Func_Call" struct.
 *)
and tokens_to_s_expr_func_call list_of_tokens =
	let (func_name, remaining_tokens) = tokens_to_s_expr list_of_tokens in

	(*
	 * Input: token list
	 * Returns: s_expression list * token list
	 * Does: Iterates down a list of tokens and evaluates expressions to add to a list until a "RIGHT_PAREN" token is reached.  If any other token 
	 * is found, an error is thrown.
	 *)
	let rec collect_args list_of_args list_of_tokens =
		(match list_of_tokens with
			| ({ generic_type = RIGHT_PAREN; _} :: remaining_tokens) -> (list_of_args, remaining_tokens)
			| _ ->
				let (next_arg, remaining_tokens) = tokens_to_s_expr list_of_tokens in
				collect_args (next_arg :: list_of_args) remaining_tokens) in

	let (func_args, remaining_tokens) = collect_args [] remaining_tokens in
	(
		Func_Call
		{
			name = func_name;
			args = func_args;
		},
		remaining_tokens
	)
