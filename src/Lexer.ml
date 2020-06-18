(*
 *	Lexer.ml 
 *
 *	Contains implementation of all functions and attribute of Lexer module.
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

	(* Token that explicitly marks the end of the file. *)
	| EOF

type token_literal_type = SYMBOL_LITERAL of string | NUMBER_LITERAL of int

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

(*
 * Input: token
 * Output: string
 * Does: Returns the lexeme attribute of a token.  Allows us to keep the "token" type hidden.
 *)
 let get_lexeme processed_token = processed_token.lexeme

(*
 * Input: token_processor
 * Returns: bool
 * Does: Checks the "source" attribute of token_processor to see if it's finished parsing the string.
 *)
let is_finished master_token_processor = master_token_processor.current >= (String.length master_token_processor.source)

(*
 * Input: token_processor
 * Returns: char Option
 * Does: Returns (if no out of bounds exception) option of the next char in the source string.
 *)
let get_next_char master_token_processor = 
	try Some(String.get master_token_processor.source (master_token_processor.current - 1)) with Invalid_argument _ -> None

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
	(* 
	 * IMPORTANT: I am constructing the list of tokens in the reverse order.  This means I MUST
	 * remember to reverse list once entire list has been created.
	 *)
	master_token_processor with tokens =
	(
		{
			generic_type = new_token_type;
			literal_type = new_token_literal_type;
			lexeme = new_token_lexeme;
			line = new_token_line;
		}
		:: master_token_processor.tokens
	)
}

(*
 * Input: token_processor
 * Returns: token_processor
 * Does: Updates input to a include a new token, and then returns the (updated) token_processor.
 *)
let process_token master_token_processor = 
	let master_token_processor = advance master_token_processor
	in 
		match get_next_char master_token_processor with
		| Some '(' -> add_token LEFT_PAREN None "(" master_token_processor.line master_token_processor
		| Some ')' -> add_token RIGHT_PAREN None ")" master_token_processor.line master_token_processor
		| _ -> failwith "Invalid character."

(*
 * Input: string
 * Returns: token list
 * Does: Creates a list of tokens by parsing the string representation of a Scheme program.
 *)
let rec process_tokens master_token_processor =  
	if (is_finished master_token_processor) then List.rev master_token_processor.tokens else
		let new_token_processor = { master_token_processor with start = master_token_processor.current }
		in process_tokens (process_token new_token_processor)

(*
 * Input: string
 * Returns: token list
 * Does: Initializes a new token_processor that will be used in the recursive "process_tokens" function.
 *)
let process_tokens_initializer input_string =
	process_tokens { source = input_string; start = 0; current = 0; line = 1; tokens = [] }
