(*
 * Token.ml
 * 
 * Contains type defintions for a token and all of its attributes.
 *
 *)

type token_type =
	
	| LEFT_PAREN
	| RIGHT_PAREN

	(* literals *)
	| SYMBOL
	| NUMBER

	(* keywords *)
	| IF
	| DEFINE
	| LAMBDA
	| QUOTE

	(* Token that explicitly marks the end of the file. *)
	| EOF

type token_literal_type = SYMBOL_LITERAL of string | NUMBER_LITERAL of float

type token = 
{
	generic_type: token_type;
	literal_type: token_literal_type option;
	(* A lexeme is a substring that makes up a small block of the larger string that's being processed. *)
	(* We don't really need it to evaluate the program... helpful for debugging. *)
	lexeme: string;
	(* Line number is important for sending error messages. *)
	line: int;
}

type token_processor =
{
	source: string;
	(* 
	 * The reason we need a different variable for "start" and "current" has to do with when we're tokenizing
	 * multi-character operators or strings.
	 *)
	start: int;
	current: int;
	line: int;
	tokens: token list; 
}