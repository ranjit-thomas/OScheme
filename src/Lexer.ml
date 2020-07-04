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
 * Does: Returns (if no out of bounds exception) option of the current char in the source string.
 *)
let get_current_char master_token_processor = 
	try Some(String.get master_token_processor.source (master_token_processor.current - 1)) with Invalid_argument _ -> None

(*
 * Input: token_processor
 * Returns: token_processor
 * Does: Incriments the "current" attribute of a token_processor and then returns said token_processor updated.
 *)
let advance master_token_processor = { master_token_processor with current = master_token_processor.current + 1 }

(*
 * Input: token_processor
 * Returns: char Option
 * Does: Returns (if no out of bounds exception) option of the next char in the source string.
 *)
let get_next_char master_token_processor =
	try Some(String.get master_token_processor.source master_token_processor.current) with Invalid_argument _ -> None



(* MIGHT NOT NEED NEXT FUNCTIONS!!!! *)

(*
 * Input: char, token_processor
 * Returns: bool * token_processor
 * Does: Looks to see if the next char of an input string is matched with what's expected.
 *)
let find_match char_to_match master_token_processor =
	if is_finished master_token_processor then (false, master_token_processor) else
		match get_next_char master_token_processor with
		| Some (next_char) when next_char = char_to_match -> (true, advance master_token_processor)
		| _ -> (false, master_token_processor)
(*
 * Input: token_type, token_literal_type option, string, int, token_processor
 * Returns: token_processor
 * Does: Takes a list of attributes for a token, constructs a token, and adds said token to the list of 
 * tokens in the token_processor.  Updated token_processor is returned.
 *)
let add_token new_token_type new_token_literal_type new_token_lexeme master_token_processor =
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
			line = master_token_processor.line;
		}
		:: master_token_processor.tokens
	)
}

(* 
 * Input: none
 * Returns: token
 * Does: Generates the "eof" token.
 *)
let new_eof_token = { generic_type = EOF; literal_type = None; lexeme = "done!"; line = 0}

(*
 * Input: char option
 * Returns: bool
 * Does: Returns true iff the char option passed in is a digit by looking at its asccii value
 *)
let is_digit character =
	match character with
	| Some c when c >= '0' && c <= '9' -> true
	| _ -> false

(*
 * Input: token_processor
 * Returns: token_processor
 * Does: Advances "current" attribute of token_processor until a non-digit is arrived at. 
 *)
let rec collect_digits master_token_processor =
	if is_digit (get_next_char master_token_processor) then collect_digits (advance master_token_processor) else master_token_processor

(*
 * Input: token_processor
 * Returns: token_processor
 * Does: Iff the current char is a ".", the token_processor's "current" attribute is advanced till
 * it arrives at a non-digit char... this is done by calling "collect_digits" again.
 *)
let collect_decimal master_token_processor =
	match get_next_char master_token_processor with
	| Some '.' ->
		let new_token_processor = advance master_token_processor in
		if is_digit (get_next_char new_token_processor) then collect_digits (advance new_token_processor) else master_token_processor
	| _ -> master_token_processor

(*
 * Input: token_processor
 * Returns: token_processor
 * Does: Parses the input_string until a non-digit char is reached, then returns token_processor that 
 * includes new token for the number that was just parsed.
 *)
let add_number_token master_token_processor =
	(* 
	 * A new token_processor will be generated by calling "collect digits" once... which will continue
	 * recursing until, it gets to a non-digit.  Then, if the next char is a ".", the "collect digits"
	 * function will again be called (all this done via the "collect_decimal" function).
	 *)
	let master_token_processor = collect_decimal (collect_digits master_token_processor) in
	let number_as_string = String.sub master_token_processor.source master_token_processor.start (master_token_processor.current - master_token_processor.start) in
	let number_as_float = float_of_string number_as_string in
	add_token NUMBER (Some (NUMBER_LITERAL number_as_float)) number_as_string master_token_processor

(*
 * Input: char option
 * Returns: bool
 * Does: Returns true iff the char option passed in is a an alphabetic character by looking at its asccii value
 *)
let is_alpha character =
	match character with
	| Some c when c >= 'a' && c <= 'z' -> true
	| Some c when c >= 'A' && c <= 'Z' -> true
	| Some c when c = '_' || c = '-' -> true
	| _ -> false

(*
 * Input: token_processor
 * Returns: token_processor
 * Does: Parses the input_string until a non-alpha char is reached, then returns token_processor that 
 * includes new token for the number that was just parsed. 
 *)
let rec add_symbol_token master_token_processor =
	if (is_alpha (get_next_char master_token_processor)) then add_symbol_token (advance master_token_processor)
else
	let symbol_string = String.sub master_token_processor.source master_token_processor.start (master_token_processor.current - master_token_processor.start) in
	match symbol_string with
	(* Since OCaml has only a few basic keywords, we begin with special cases so that they're corresponding
	   tokens can be processed. *)
	| "if" -> add_token IF None "if*" master_token_processor
	| "define" -> add_token DEFINE None "define*" master_token_processor
	| "lambda" -> add_token LAMBDA None "lambda*" master_token_processor
	| "quote" -> add_token QUOTE None "quote*" master_token_processorß
	| _ -> add_token SYMBOL (Some (SYMBOL_LITERAL symbol_string)) symbol_string master_token_processor

(*
 * Input: token_processor
 * Returns: token_processor
 * Does: Updates input to a include a new token, and then returns the (updated) token_processor.
 *)
let process_token master_token_processor = 
	let master_token_processor = advance master_token_processor
	in 
		match get_current_char master_token_processor with
		(* The following white space tokens don't need to update the token_processor *)
		| Some ' ' -> master_token_processor
		| Some '\r' -> master_token_processor
		| Some '\t' -> master_token_processor

		(* Newline doesn't add any tokens, just incriments the line attribute. *)
		| Some '\n' -> { master_token_processor with line = master_token_processor.line + 1 }

		| Some '(' -> add_token LEFT_PAREN None "(" master_token_processor
		| Some ')' -> add_token RIGHT_PAREN None ")" master_token_processor
		| numb when is_digit numb -> add_number_token master_token_processor
		| alpha when is_alpha alpha -> add_symbol_token master_token_processor
		| _ -> failwith "Invalid character."

(*
 * Input: string
 * Returns: token list
 * Does: Creates a list of tokens by parsing the string representation of a Scheme program.
 *)
let rec process_tokens master_token_processor =  
	if (is_finished master_token_processor) then List.rev (new_eof_token :: master_token_processor.tokens) else
		let new_token_processor = { master_token_processor with start = master_token_processor.current } in 
		process_tokens (process_token new_token_processor)

(*
 * Input: string
 * Returns: token list
 * Does: Initializes a new token_processor that will be used in the recursive "process_tokens" function.
 *)
let process_tokens_initializer input_string =
	process_tokens { source = input_string; start = 0; current = 0; line = 1; tokens = [] }
