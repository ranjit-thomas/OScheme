(*
 *	Parser.mli
 *
 *	Contains interface for public functions from Parser module.
 *
 *)
open Token;;

type s_expression

val tokens_to_s_expr: int -> token list -> s_expression * token list