(*
 *	Lexer.mli 
 *
 *	Contains interface for public functions from Lexer module.
 *
 *)

(* Only put shit in here that we actually need the client to see. *)
open Token;;

val get_lexeme: token -> string

val process_tokens_initializer: string -> token list
