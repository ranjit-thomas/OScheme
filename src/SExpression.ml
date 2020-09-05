(*
 * SExpression.ml
 * 
 * Contains type defintions for a s_expression and all of its attributes.
 *
 *)

type s_expression =
	| Value of float
	| Boolean of bool
	| Symbol of string
	| Definition of
	{
		variable: string;
		expression: s_expression;
	} 
	| Func_Call of
	{
		proc: s_expression;
		args: s_expression list;
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