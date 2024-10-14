(* lexer.ml *)

open Tokens

exception LexingError of string  (* Error message for lexing issues *)

let lex source =
  let length = String.length source in
  let tokens = ref [] in
  let pos = ref 0 in

  (* Helper functions to classify characters *)
  let is_letter c =
    ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') in

  let is_digit c =
    '0' <= c && c <= '9' in

  let is_whitespace c =
    c = ' ' || c = '\t' || c = '\n' || c = '\r' in

  let is_accidental c =
    c = '#' || c = '-' || c = '_' in

  let is_identifier_char c =
    is_letter c || is_digit c || c = '_' in

  (* Function to skip whitespace *)
  let rec skip_whitespace () =
    while !pos < length && is_whitespace source.[!pos] do
      pos := !pos + 1
    done in

  (* Function to match a keyword *)
  let match_keyword word =
    match String.lowercase_ascii word with
    | "instrument" | "bpm" | "play" | "repeat" | "end" | "title" | "composer" ->
        KEYWORD word
    | "whole" | "half" | "quarter" | "eighth" | "sixteenth" ->
        DURATION word
    | _ ->
        IDENTIFIER word in

  (* Function to match a music note *)
  let match_music_note () =
    let start_pos = !pos in
    let buffer = Buffer.create 4 in

    (* State 0: Expecting first letter of solfege *)
    if !pos < length && is_letter source.[!pos] then begin
      Buffer.add_char buffer source.[!pos];
      pos := !pos + 1
    end else
      raise (LexingError (Printf.sprintf "Invalid music note at position %d" start_pos));

    (* State 1: Expecting second letter of solfege *)
    if !pos < length && is_letter source.[!pos] then begin
      Buffer.add_char buffer source.[!pos];
      pos := !pos + 1
    end else begin
      pos := start_pos;  (* Reset position *)
      raise (LexingError (Printf.sprintf "Invalid music note at position %d" start_pos))
    end;

    (* State 2: Expecting digit for octave *)
    if !pos < length && is_digit source.[!pos] then begin
      Buffer.add_char buffer source.[!pos];
      pos := !pos + 1
    end else begin
      pos := start_pos;  (* Reset position *)
      raise (LexingError (Printf.sprintf "Invalid music note at position %d" start_pos))
    end;

    (* State 3: Expecting accidental *)
    if !pos < length && is_accidental source.[!pos] then begin
      Buffer.add_char buffer source.[!pos];
      pos := !pos + 1
    end else begin
      pos := start_pos;  (* Reset position *)
      raise (LexingError (Printf.sprintf "Invalid music note at position %d" start_pos))
    end;

    (* Validate the music note *)
    let note = Buffer.contents buffer in
    let solfege = String.sub note 0 2 in
    let valid_solfege = ["do"; "re"; "mi"; "fa"; "so"; "la"; "ti"] in
    if List.mem (String.lowercase_ascii solfege) valid_solfege then
      MUSICNOTE note
    else begin
      pos := start_pos;  (* Reset position *)
      raise (LexingError (Printf.sprintf "Invalid solfege \"%s\" in music note at position %d" solfege start_pos))
    end in

  (* Function to read an identifier *)
  let read_identifier () =
    let buffer = Buffer.create 10 in
    while !pos < length && is_identifier_char source.[!pos] do
      Buffer.add_char buffer source.[!pos];
      pos := !pos + 1
    done;
    Buffer.contents buffer in

  (* Function to read a number *)
  let read_number () =
    let buffer = Buffer.create 10 in
    while !pos < length && is_digit source.[!pos] do
      Buffer.add_char buffer source.[!pos];
      pos := !pos + 1
    done;
    int_of_string (Buffer.contents buffer) in

  (* Function to read a string literal *)
  let read_string_literal () =
    let buffer = Buffer.create 10 in
    pos := !pos + 1;  (* Skip opening quote *)
    while !pos < length && source.[!pos] <> '"' && source.[!pos] <> '\n' && source.[!pos] <> '\r' do
      Buffer.add_char buffer source.[!pos];
      pos := !pos + 1
    done;
    if !pos >= length || source.[!pos] <> '"' then
      raise (LexingError "String literal not terminated before end of line")
    else
      pos := !pos + 1;  (* Skip closing quote *)
    Buffer.contents buffer in

  (* Main lexing loop *)
  while !pos < length do
    skip_whitespace ();

    if !pos < length then
      let c = source.[!pos] in
      if is_letter c then begin
        (* Attempt to match a music note *)
        let start_pos = !pos in
        try
          let token = match_music_note () in
          tokens := token :: !tokens
        with
        | LexingError _ ->
            (* Not a music note, reset position and read as identifier or keyword *)
            pos := start_pos;
            let word = read_identifier () in
            tokens := match_keyword word :: !tokens
      end else if is_digit c then begin
        (* Read a number *)
        let number = read_number () in
        tokens := NUMBER number :: !tokens
      end else begin
        (* Match single-character tokens or operators *)
        match c with
        | '=' | ':' ->
            tokens := OPERATOR (String.make 1 c) :: !tokens;
            pos := !pos + 1
        | '"' ->
            (* Read string literal *)
            let str_literal = read_string_literal () in
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
        | _ when is_whitespace c ->
            pos := !pos + 1
        | _ ->
            raise (LexingError (Printf.sprintf "Invalid character '%c' at position %d" c !pos))
      end
  done;
  List.rev !tokens
