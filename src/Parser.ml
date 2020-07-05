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
		proc_name: string;
		args: s_expression list;
	}
	| EOF

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
let rec tokens_to_s_expr paren_to_match list_of_tokens =
	match list_of_tokens with
	| (current_token :: remaining_tokens) -> 
		(match current_token with
		(* Handle list shit here
		| { generic_type = LEFT_PAREN; _ } -> 
			let list_of_s_expr = [] in*)

		| { generic_type = SYMBOL; literal_type = Some (SYMBOL_LITERAL symbol_string); _ } -> (Symbol { symbol = symbol_string }, remaining_tokens)
		| { generic_type = NUMBER; literal_type = Some (NUMBER_LITERAL number_float); _ } -> (Value { value = number_float }, remaining_tokens)

		| { generic_type = IF; _ } -> 
			let (s_condition, remaining_tokens) = tokens_to_s_expr paren_to_match remaining_tokens in
			let (s_conseq, remaining_tokens) = tokens_to_s_expr paren_to_match remaining_tokens in
			let (s_alt, remaining_tokens) = tokens_to_s_expr paren_to_match remaining_tokens in
			(
				Conditional 
				{
					condition = s_condition;
					conseq = s_conseq;
					alt = s_alt;
				},
				remaining_tokens
			)

		| _ -> failwith "blah di blooh di blahß")
	| _ -> failwith "poopie"

