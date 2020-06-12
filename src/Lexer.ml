(*
 *	Lexer.ml 
 *
 *	Contains implementation of all functions and attribute of Lexer module.
 *
 *)

type token_type =
	| LEFT_PAREN,
	| RIGHT_PAREN,

	(* literals *)
	| SYMBOL
	| NUMBER

	(* keywords *)
	| IF
	| DEFINE

	(* Token that explicitly marks the end of the file. *)
	| EOF

type token_literal_type = SYMBOL_LITERAL of string | NUMBER_LITERAL of int

type token = 
{
	type: token_type;
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
	start: int;
	current: int;
	line: int;
	tokens: token list; 
}

(*
 * Input: token_processor
 * Returns: bool
 * Does: Checks the "source" attribute of token_processor to see if it's finished parsing the string.
 *)
let is_finished master_token_processor = some_token_processor.current >= (String.length some_token_processor.source)

(*
 * Input: token_processor
 * Returns: char Option
 * Does: Returns (if no out of bounds exception) option of the next char in the source string.
 *)
let get_next_char master_token_processor = 
	try Some (String.get master_token_processor.source master_token_processor.current) with Invalid_argument _ -> None

(*
 * Input: token_processor
 * Returns: token_processor
 * Does: Incriments the "current" attribute of a token_processor and then returns said token_processor updated.
 *)
let advance master_token_processor = { master_token_processor with current = master_token_processor.current + 1 }

(*
 * Input: token_type, token_literal_type option, string, int, token_processor
 * Returns: token_processor
 * Does: Takes a list of attributes for a token, constructs a token, and adds said token to the list of 
 * tokens in the token_processor.  Updated token_processor is returned.
 *)
let add_token new_token_type new_token_literal_type new_token_lexeme new_token_line master_token_processor =
 {
 	{
 		(* 
 		 * IMPORTANT: I am constructing the list of tokens in the reverse order.  This means I MUST
 		 * remember to reverse list once entire list has been created.
 		 *)
 		master_token_processor with tokens = master_token_processor.tokens ::
 			{
 				type = new_token_type;
 				literal_type = new_token_type;
 				lexeme = new_token_lexeme;
 				line = new_token_line;
 			}
 	}
 }

(*
 * Input: token_processor
 * Returns: token_processor
 * Does: Updates input to a include a new token, and then returns the (updated) token_processor.
 *)
let process_token 

