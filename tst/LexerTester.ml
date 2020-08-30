(*
 *	LexerTester.ml 
 *
 *	Contains unit tests for Lexer.
 *
 *)
open OUnit2;;
open Lexer;;
open Token;;

let test_whitespace test_ctxt = assert_equal (process_tokens_initializer " ") []

let test_carriage_return test_ctxt = assert_equal (process_tokens_initializer "\r") []

let test_tab test_ctxt = assert_equal (process_tokens_initializer "\t") []

let test_newline test_ctxt = assert_equal (process_tokens_initializer "\n") []

let test_left_paren test_ctxt = 
	let expected_token =
	{
		generic_type = LEFT_PAREN;
		literal_type = None;
		lexeme = "(";
		line = 1;
	}
	in 
	match process_tokens_initializer "(" with
	| (actual_token :: _ ) -> assert (token_compare actual_token expected_token)
	| _ -> failwith "Error in test implimentation."

let test_right_paren test_ctxt =
	let expected_token =
	{
		generic_type = RIGHT_PAREN;
		literal_type = None;
		lexeme = ")";
		line = 1;
	}
	in 
	match process_tokens_initializer ")" with
	| (actual_token :: _ ) -> assert (token_compare actual_token expected_token)
	| _ -> failwith "Error in test implimentation."

let test_boolean_true test_ctxt =
	let expected_token =
	{
		generic_type = BOOLEAN true;
		literal_type = None;
		lexeme = "true";
		line = 1;
	}
	in 
	match process_tokens_initializer "#t" with
	| (actual_token :: _ ) -> assert (token_compare actual_token expected_token)
	| _ -> failwith "Error in test implimentation."

let test_boolean_false test_ctxt =
	let expected_token =
	{
		generic_type = BOOLEAN false;
		literal_type = None;
		lexeme = "false";
		line = 1;
	}
	in 
	match process_tokens_initializer "#f" with
	| (actual_token :: _ ) -> assert (token_compare actual_token expected_token)
	| _ -> failwith "Error in test implimentation."

let test_fail_with_lone_pound test_ctxt = assert_raises (Failure "Lone '#' character.") (fun () -> process_tokens_initializer "#3")

let test_number test_ctxt =
	let expected_token =
	{
		generic_type = NUMBER;
		literal_type = Some (NUMBER_LITERAL 8.);
		lexeme = "8";
		line = 1;
	}
	in 
	match process_tokens_initializer "8" with
	| (actual_token :: _ ) -> assert (token_compare actual_token expected_token)
	| _ -> failwith "Error in test implimentation."

let test_symbol test_ctxt =
	let expected_token =
	{
		generic_type = SYMBOL;
		literal_type = Some (SYMBOL_LITERAL "dog");
		lexeme = "dog";
		line = 1;
	}
	in 
	match process_tokens_initializer "dog" with
	| (actual_token :: _ ) -> assert (token_compare actual_token expected_token)
	| _ -> failwith "Error in test implimentation."

let test_if test_ctxt = 
	let expected_token =
	{
		generic_type = IF;
		literal_type = None;
		lexeme = "if*";
		line = 1;
	}
	in 
	match process_tokens_initializer "if" with
	| (actual_token :: _ ) -> assert (token_compare actual_token expected_token)
	| _ -> failwith "Error in test implimentation."

let test_define test_ctxt = 
	let expected_token =
	{
		generic_type = DEFINE;
		literal_type = None;
		lexeme = "define*";
		line = 1;
	}
	in 
	match process_tokens_initializer "define" with
	| (actual_token :: _ ) -> assert (token_compare actual_token expected_token)
	| _ -> failwith "Error in test implimentation."

let test_lambda test_ctxt = 
	let expected_token =
	{
		generic_type = LAMBDA;
		literal_type = None;
		lexeme = "lambda*";
		line = 1;
	}
	in 
	match process_tokens_initializer "lambda" with
	| (actual_token :: _ ) -> assert (token_compare actual_token expected_token)
	| _ -> failwith "Error in test implimentation."

let test_quote test_ctxt = 
	let expected_token =
	{
		generic_type = QUOTE;
		literal_type = None;
		lexeme = "quote*";
		line = 1;
	}
	in 
	match process_tokens_initializer "quote" with
	| (actual_token :: _ ) -> assert (token_compare actual_token expected_token)
	| _ -> failwith "Error in test implimentation."

let test_fail_with_invalid_char test_ctxt = assert_raises (Failure "Invalid character.") (fun () -> process_tokens_initializer "&")

let all_tests =
	"all_tests" >::: 
	[
		"test_whitespace" >:: test_whitespace;
		"test_carriage_return" >:: test_carriage_return;
		"test_tab" >:: test_tab;
		"test_newline" >:: test_newline;
		"test_left_paren" >:: test_left_paren;
		"test_right_paren" >:: test_right_paren;
		"test_boolean_true" >:: test_boolean_true;
		"test_boolean_false" >:: test_boolean_false;
		"test_fail_with_lone_pound" >:: test_fail_with_lone_pound;
		"test_number" >:: test_number;
		"test_symbol" >:: test_symbol;
		"test_if" >:: test_if;
		"test_define" >:: test_define;
		"test_lambda" >:: test_lambda;
		"test_quote" >:: test_quote;
		"test_fail_with_invalid_char" >:: test_fail_with_invalid_char
	]

let () =
	run_test_tt_main all_tests
