(*
 *	OScheme.ml 
 *
 *	Contains "int main" function that functions as interpereter.  Opens and reads the contents 
 *  of any file read at the command line.  If no filename is called, program is run interactively.
 *
 *)
open Token;;

let run input =
	let tokens = Lexer.process_tokens_initializer input in 
	let _ = List.iter (fun token -> print_endline token.lexeme) tokens in
	let (_, _) = Parser.tokens_to_s_expr tokens in
	()
	
let run_interactive _ =
	print_endline "Enter input below:";
	while true do
		let new_instruction = read_line ()
		in run new_instruction
	done

let run_with_file filename =
	let file_pointer = open_in filename in
	(* attempt to read entire file *)
    try
  		let line_size = in_channel_length file_pointer in
     	let line = really_input_string file_pointer line_size in
      	run line;
      	flush stdout;
      	close_in file_pointer
    with e ->
      close_in_noerr file_pointer;
      raise e

(* might want to figure out how to make this an official "main" function *)
 let _ = 
 	match Array.length Sys.argv with
 		| 1 -> run_interactive ()
 		| 2 -> run_with_file (Array.get Sys.argv 1)
 		| _ -> print_endline "Usage: OScheme [filename]" ; exit 64;