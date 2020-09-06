(*
 * SExpression.mli
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
		variable: s_expression;
		expression: s_expression;
	} 
	| Func_Call of
	{
		proc: s_expression;
		args: s_expression list;
	}
	| Conditional of 
	{ 
		cond: s_expression; 
		conseq: s_expression;
		alt: s_expression;
	}
	| Lambda of 
	{
		args: s_expression list;
		proc: s_expression;
	}