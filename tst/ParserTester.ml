(*
 *	ParserTester.ml 
 *
 *	Contains unit tests for Parser.
 *
 *)

open OUnit2;;
open Parser;;
open Token;;
open SExpression;;

let test_value test_ctxt =
	let expected_s_expression = Value 8. in
	let list_of_tokens = 
	[ 
		{ 
			generic_type = NUMBER;
			literal_type = Some (NUMBER_LITERAL 8.);
			lexeme = "8";
			line = 1;
		}
	]
	in
	let (actual_s_expression, list_of_tokens) = tokens_to_s_expr list_of_tokens in
	let _ = assert_equal actual_s_expression expected_s_expression in
	assert_equal list_of_tokens []

let all_tests =
	"all_tests" >::: 
	[
		"test_value" >:: test_value
	]

let () =
	run_test_tt_main all_tests