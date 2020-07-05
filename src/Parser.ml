(*
 *	Parser.ml 
 *
 *	Contains implementation of all functions and attribute of Parser module.
 *
 *)

(* TODO: Consider seeing if I can migrate the S-Expression stuff to its own class. *)
(* TODO: "Value" is gonna need to change a lot when s_value becomes a string as well*)

type s_expression =
	| List of s_expression list
	| Value of { value: int }
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

let tokens_to_s_expr some_list = List [ Value { value = 1 }; Value { value = 2} ]
