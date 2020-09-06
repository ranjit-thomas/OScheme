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

let test_boolean test_ctxt =
	let expected_s_expression = Boolean true in
	let list_of_tokens = 
	[ 
		{ 
			generic_type = BOOLEAN (true);
			literal_type = None;
			lexeme = "true";
			line = 1;
		}
	]
	in
	let (actual_s_expression, list_of_tokens) = tokens_to_s_expr list_of_tokens in
	let _ = assert_equal actual_s_expression expected_s_expression in
	assert_equal list_of_tokens []

let test_symbol test_ctxt =
	let expected_s_expression = Symbol "hello" in
	let list_of_tokens = 
	[ 
		{ 
			generic_type = SYMBOL;
			literal_type = Some (SYMBOL_LITERAL "hello");
			lexeme = "hello";
			line = 1;
		}
	]
	in
	let (actual_s_expression, list_of_tokens) = tokens_to_s_expr list_of_tokens in
	let _ = assert_equal actual_s_expression expected_s_expression in
	assert_equal list_of_tokens []

let test_definition test_ctxt =
	let expected_s_expression = Definition { variable = Symbol "x" ; expression = Value 2. } in
	let list_of_tokens = 
	[ 
		{
			generic_type = LEFT_PAREN;
			literal_type = None;
			lexeme = "(";
			line = 1;
		};
		{
			generic_type = DEFINE;
			literal_type = None;
			lexeme = "define*";
			line = 1;
		};
		{ 
			generic_type = SYMBOL;
			literal_type = Some (SYMBOL_LITERAL "x");
			lexeme = "x";
			line = 1;
		};
		{
			generic_type = NUMBER;
			literal_type = Some (NUMBER_LITERAL 2.);
			lexeme = "2";
			line = 1;
		};
		{
			generic_type = RIGHT_PAREN;
			literal_type = None;
			lexeme = ")";
			line = 1;
		}
	]
	in
	let (actual_s_expression, list_of_tokens) = tokens_to_s_expr list_of_tokens in
	let _ = assert_equal actual_s_expression expected_s_expression in
	assert_equal list_of_tokens []

let test_func_call test_ctxt =
	let expected_s_expression = Func_Call { proc = Symbol "test_proc" ; args = [Symbol "x"; Symbol "y"] } in
	let list_of_tokens = 
	[ 
		{
			generic_type = LEFT_PAREN;
			literal_type = None;
			lexeme = "(";
			line = 1;
		};
		{
			generic_type = SYMBOL;
			literal_type = Some (SYMBOL_LITERAL "test_proc");
			lexeme = "test_proc";
			line = 1;
		};
		{ 
			generic_type = SYMBOL;
			literal_type = Some (SYMBOL_LITERAL "x");
			lexeme = "x";
			line = 1;
		};
		{ 
			generic_type = SYMBOL;
			literal_type = Some (SYMBOL_LITERAL "y");
			lexeme = "y";
			line = 1;
		};
		{
			generic_type = RIGHT_PAREN;
			literal_type = None;
			lexeme = ")";
			line = 1;
		}
	]
	in
	let (actual_s_expression, list_of_tokens) = tokens_to_s_expr list_of_tokens in
	let _ = assert_equal actual_s_expression expected_s_expression in
	assert_equal list_of_tokens []

let test_conditional test_ctxt =
	let expected_s_expression = Conditional { cond = Symbol "test_cond" ; conseq = Symbol "test_conseq"; alt = Symbol "test_alt" } in
	let list_of_tokens = 
	[ 
		{
			generic_type = LEFT_PAREN;
			literal_type = None;
			lexeme = "(";
			line = 1;
		};
		{
			generic_type = IF;
			literal_type = None;
			lexeme = "if*";
			line = 1;
		};
		{
			generic_type = SYMBOL;
			literal_type = Some (SYMBOL_LITERAL "test_cond");
			lexeme = "test_cond";
			line = 1;
		};
		{ 
			generic_type = SYMBOL;
			literal_type = Some (SYMBOL_LITERAL "test_conseq");
			lexeme = "test_conseq";
			line = 1;
		};
		{ 
			generic_type = SYMBOL;
			literal_type = Some (SYMBOL_LITERAL "test_alt");
			lexeme = "test_alt";
			line = 1;
		};
		{
			generic_type = RIGHT_PAREN;
			literal_type = None;
			lexeme = ")";
			line = 1;
		}
	]
	in
	let (actual_s_expression, list_of_tokens) = tokens_to_s_expr list_of_tokens in
	let _ = assert_equal actual_s_expression expected_s_expression in
	assert_equal list_of_tokens []

let test_lambda test_ctxt =
	let expected_s_expression = Lambda { args = [Symbol "x"; Symbol "y"]; proc = Symbol "test_proc" } in
	let list_of_tokens = 
	[ 
		{
			generic_type = LEFT_PAREN;
			literal_type = None;
			lexeme = "(";
			line = 1;
		};
		{
			generic_type = LAMBDA;
			literal_type = None;
			lexeme = "lambda*";
			line = 1;
		};
		{
			generic_type = LEFT_PAREN;
			literal_type = None;
			lexeme = "(";
			line = 1;
		};
		{
			generic_type = SYMBOL;
			literal_type = Some (SYMBOL_LITERAL "x");
			lexeme = "x";
			line = 1;
		};
		{ 
			generic_type = SYMBOL;
			literal_type = Some (SYMBOL_LITERAL "y");
			lexeme = "y";
			line = 1;
		};
		{
			generic_type = RIGHT_PAREN;
			literal_type = None;
			lexeme = ")";
			line = 1;
		};
		{ 
			generic_type = SYMBOL;
			literal_type = Some (SYMBOL_LITERAL "test_proc");
			lexeme = "test_proc";
			line = 1;
		};
		{
			generic_type = RIGHT_PAREN;
			literal_type = None;
			lexeme = ")";
			line = 1;
		}
	]
	in
	let (actual_s_expression, list_of_tokens) = tokens_to_s_expr list_of_tokens in
	let _ = assert_equal actual_s_expression expected_s_expression in
	assert_equal list_of_tokens []

let test_fail_with_premature_right_paren test_ctxt = assert_raises (Failure "Premature right paren.") (fun () -> tokens_to_s_expr [{ generic_type = RIGHT_PAREN; literal_type = None; lexeme = ")"; line = 1 }])

let all_tests =
	"all_tests" >::: 
	[
		"test_value" >:: test_value;
		"test_boolean" >:: test_boolean;
		"test_symbol" >:: test_symbol;
		"test_definition" >:: test_definition;
		"test_func_call" >:: test_func_call;
		"test_conditional" >:: test_conditional;
		"test_lambda" >:: test_lambda;
		"test_fail_with_premature_right_paren" >:: test_fail_with_premature_right_paren;
	]

let () =
	run_test_tt_main all_tests