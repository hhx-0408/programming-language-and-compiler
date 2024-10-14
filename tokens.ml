type token =
  | KEYWORD of string
  | OPERATOR of string
  | IDENTIFIER of string
  | NUMBER of int
  | STRING_LITERAL of string
  | MUSICNOTE of string
  | DURATION of string
  | LPAREN       
  | RPAREN        
  | SEMICOLON     
  | COMMA         

exception LexingError of string  (* Error message for lexing issues *)
