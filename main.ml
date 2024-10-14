(* main.ml *)

open Lexer
open Tokens

(* Function to convert tokens to string for display *)
let string_of_token token =
  match token with
  | KEYWORD kw -> Printf.sprintf "<KEYWORD, \"%s\">" kw
  | OPERATOR op -> Printf.sprintf "<OPERATOR, \"%s\">" op
  | IDENTIFIER id -> Printf.sprintf "<IDENTIFIER, \"%s\">" id
  | NUMBER n -> Printf.sprintf "<NUMBER, \"%d\">" n
  | STRING_LITERAL s -> Printf.sprintf "<STRING_LITERAL, \"%s\">" s
  | MUSICNOTE note -> Printf.sprintf "<MUSICNOTE, \"%s\">" note
  | DURATION dur -> Printf.sprintf "<DURATION, \"%s\">" dur
  | LPAREN -> "<LPAREN, \"(\">"
  | RPAREN -> "<RPAREN, \")\">"
  | SEMICOLON -> "<SEMICOLON, \";\">"
  | COMMA -> "<COMMA, \",\">"
(* Main function to read from file, run lexer, and print tokens *)
let () =
  if Array.length Sys.argv < 2 then
    Printf.printf "Usage: %s <input_file>\n" Sys.argv.(0)
  else
    let filename = Sys.argv.(1) in
    (* Use Arg.read_arg to read the content of the file *)
    let lines = Array.to_list (Arg.read_arg filename) in
    let source = String.concat "\n" lines in  (* Join lines into a single string *)

    try
      let tokens = lex source in
      List.iter (fun token ->
        let token_str = string_of_token token in
        Printf.printf "%s\n" token_str;
      ) tokens
    with
    | LexingError msg ->
        Printf.printf "LexingError: %s\n" msg
(* let () =
  if Array.length Sys.argv < 2 then
    Printf.printf "Usage: %s <input_file>\n" Sys.argv.(0)
  else
    let filename = Sys.argv.(1) in
    (* Read the content of the file *)
    let ic = open_in filename in
    let buffer = Buffer.create 500 in
    (try
       while true do
         let line = input_line ic in
         Buffer.add_string buffer line;
         Buffer.add_char buffer '\n';  (* Preserve line breaks *)
       done
     with End_of_file -> ());
    close_in ic;
    let source = Buffer.contents buffer in

    (* Lex the source code *)
    try
      let tokens = lex source in
      List.iter (fun token ->
        let token_str = string_of_token token in
        Printf.printf "%s\n" token_str;
      ) tokens
    with
    | LexingError msg ->
        Printf.printf "LexingError: %s\n" msg *)
