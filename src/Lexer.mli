(*
 *	Lexer.mli 
 *
 *	Contains interface for all functions and attributes of Lexer class.
 *
 *)

type token_type

type token_literal_type

type token

type token_processor

val process_tokens: string -> token list

val is_finished: token_processor -> bool