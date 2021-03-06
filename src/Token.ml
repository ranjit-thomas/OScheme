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
	| BOOLEAN of bool
	(* keywords *)
	| IF
	| DEFINE
	| LAMBDA
	| QUOTE

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

let token_compare token_1 token_2 = (token_1.generic_type = token_2.generic_type) && (token_1.literal_type = token_2.literal_type) && (token_1.lexeme = token_2.lexeme) && (token_1.line = token_2.line)

(*
 * Input: token
 * Output: string
 * Does: Returns the lexeme attribute of a token.  Allows us to keep the "token" type hidden.
 *)
let get_lexeme processed_token = processed_token.lexeme