(*
 *	Parser.mli
 *
 *	Contains interface for public functions from Parser module.
 *
 *)
open Token;;
open SExpression;;

val tokens_to_s_expr: token list -> s_expression * token list