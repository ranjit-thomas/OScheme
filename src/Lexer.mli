(*
 *	Lexer.mli 
 *
 *	Contains interface for all functions and attributes of Lexer class.
 *
 *)

(* Only put shit in here that we actually need the client to see. *)

type token

val get_lexeme: token -> string

val process_tokens_initializer: string -> token list
