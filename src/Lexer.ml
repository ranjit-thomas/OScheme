(*
 *	Lexer.ml 
 *
 *	Contains implementation of all functions and attribute of Lexer class.
 *
 *)

type token_type =
	| LEFT_PAREN,
	| RIGHT_PAREN,
	| SEMICOLON,
	| SINGLE_QUOTE

	(* literals *)
	| SYMBOL
	| NUMBER
	| STRING

type token_literal_type = SYMBOL_LITERAL of string | NUMBER_LITERAL of int | STRING_LITERAL of string

type token = 
{
	type: token_type;
	literal_type: token_literal_type;
	(* A lexeme is a substring that makes up a small block of the larger string that's being processed. *)
	(* We don't really need it to evaluate the program... helpful for debugging. *)
	lexeme: string;
	(* Line number is important for sending error messages. *)
	line: int;
}

type token_processor =
{
	source: string;
	start: int;
	current: int;
	line: int;
	tokens: token list; 
}

let is_finished some_token_processor = some_token_processor.current >= (String.length some_token_processor.source)



let process_tokens input_string =
