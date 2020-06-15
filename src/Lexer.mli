(*
 *	Lexer.mli 
 *
 *	Contains interface for all functions and attributes of Lexer class.
 *
 *)

(* Only put shit in here that we actually need the client to see. *)

type token_type

type token_literal_type

type token

type token_processor

val is_finished: token_processor -> bool

val process_token: token_processor -> token_processor

val add_token: token_type -> token_literal_type option -> string -> int -> token_processor -> token_processor

val process_tokens: string -> token list