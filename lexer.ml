open Tokens

(* check for a single char *)
let is_letter c =
  ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z')

let is_digit c =
  '0' <= c && c <= '9'

let is_whitespace c =
  c = ' ' || c = '\t' || c = '\n' || c = '\r'

let is_not_whitespace c= not (is_whitespace c)

let is_not_seperator c=
not (is_whitespace c) && c!=';'&&c!=','

(*# -> sharp, - -> natural, _ -> flat*)
let is_accidental c =
  c='#' || c='-' || c='_'
(*identifier could be letter, digit, or _*)
(* let is_identifier_char c =
  is_letter c || is_digit c || c = '_' *)
(*a valid musicnote char could be letter,digit, and accidental*)
(* let is_musicnote_char c =
  is_letter c || is_digit c || is_accidental c *)

(* read until some condition is not satisfied, function like another pointer, look ahead?*)
let read_until source pos length condition =
  let buffer = Buffer.create 10 in
  let rec loop pos =
    if pos < length && condition source.[pos] then
      (
      Buffer.add_char buffer source.[pos];
      loop (pos + 1)
      )
    else
      pos
  in
  let re = loop pos in
  (Buffer.contents buffer, re)

(* Function to check if a word is a valid music note *)
let is_valid_musicnote word =
  let length = String.length word in
  if length != 4 then false  (*since each music note is 2 char, 1 num, and 1 accidental(???)*)
  else
    let solfege = String.lowercase_ascii (String.sub word 0 2) in
    let solfeges = ["do"; "re"; "mi"; "fa"; "so"; "la"; "ti"] in
    if List.mem solfege solfeges then
      let octave = word.[2] in
      if is_digit octave && (octave >= '0' && octave <= '7') then(*restrict octave to be [0,7]*)
        let accidental = word.[3] in
        accidental = '#' || accidental = '_' || accidental = '-'
          (* If no accidental, just the note and octave are valid? adda branch? *)
      else false
    else false

(* Lexer scan char one by onen, use buffer store a word until meet a seperator, check for its token type *)
(*source is thhe input string in sourcefile*)
let lex source =
  let length = String.length source in
  let tokens = ref [] in
  let pos = ref 0 in

  (* Function to skip whitespace *)
  (* let rec skip_whitespace p =
    if p < length && is_whitespace source.[p] then
      skip_whitespace (p + 1)
    else
      p
  in *)
  let rec skip_whitespaces p=
    if p>=length||is_not_whitespace source.[p] then p
    else skip_whitespaces(p+1)
  in
  (* Main lexing loop *)
  while !pos < length do
    (* let (_,r)=read_until source !pos length ( is_not_whitespace) in
    pos :=r; *)
    pos := skip_whitespaces !pos;

    if !pos < length then
      let c = source.[!pos] in
      (*START WITH LETTER*)
      if is_letter c then begin
        (* Read letters, digits, and accidentals for possible music note *)
        (*read until seperator like space, comma, semicolon,TODO*)
        let (word, r) = read_until source !pos length is_not_seperator in
        pos := r;
        if is_valid_musicnote word then
          tokens := MUSICNOTE word :: !tokens
        else
          (*does not differentiate between lowercase or uppercase keyword,maybe should? TODO*)
          let word = String.lowercase_ascii word in 
          match word with
          | "instrument" | "bpm" | "play" | "repeat" | "end" | "title" | "composer" ->
              tokens := KEYWORD word :: !tokens
          | "whole" | "half" | "quarter" | "eighth" | "sixteenth" ->
              tokens := DURATION word :: !tokens
          | _ ->
              tokens := IDENTIFIER word :: !tokens
      end 
      (*START WITH DIGIT*)
      else if is_digit c then begin
        (* read until the number ennds *)
        let (num, r) = read_until source !pos length is_digit in
        pos :=r;
        let number = int_of_string num in
        tokens := NUMBER number :: !tokens
      end 
      else 
        (* Handle other tokens *)
        match c with
        | '=' | ':' ->
            tokens := OPERATOR (String.make 1 c) :: !tokens;
            pos := !pos + 1
        | '"' ->
            (* Handle string literals *)
            let buffer = Buffer.create 10 in
            pos := !pos + 1;  (* Skip opening quote *)
            let rec read_string () =
              if !pos >=length then raise (LexingError "Missing quote")
              else 
                let c = source.[!pos] in
                if c = '"' then (
                  pos := !pos + 1;  
                  Buffer.contents buffer
                )
                else (
                  Buffer.add_char buffer c;
                  pos := !pos + 1;
                  read_string ()
                )
              (* if !pos < length then
                let c = source.[!pos] in
                if c = '"' then begin
                  pos := !pos + 1;  
                  Buffer.contents buffer
                end else begin
                  Buffer.add_char buffer c;
                  pos := !pos + 1;
                  read_string ()
                end
              else
                raise (LexingError "Unterminated string literal") *)
            in
            let str_literal = read_string () in
            tokens := STRING_LITERAL str_literal :: !tokens
        | '(' ->
            tokens := LPAREN :: !tokens;
            pos := !pos + 1
        | ')' ->
            tokens := RPAREN :: !tokens;
            pos := !pos + 1
        | ';' ->
            tokens := SEMICOLON :: !tokens;
            pos := !pos + 1
        | ',' ->
            tokens := COMMA :: !tokens;
            pos := !pos + 1
        | _ ->
            let err_msg = Printf.sprintf "Invalid character '%c' at position %d" c !pos in
            raise (LexingError err_msg)
      
  done;
  List.rev !tokens
