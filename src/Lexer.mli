(*
 *	Lexer.mli 
 *
 *	Contains interface for public functions from Lexer module.
 *
 *)

open Token;;

val get_lexeme: token -> string

val process_tokens_initializer: string -> token list
