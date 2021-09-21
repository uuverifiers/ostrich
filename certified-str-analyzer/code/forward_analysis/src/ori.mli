type token =
  | Lrange
  | Label of (string)
  | Lint of (int)
  | Leol
  | LAutomaton
  | Lsingle of (string)
  | LState
  | LInitial
  | Lconcat
  | Lin
  | Lleft
  | LLleft
  | Lright
  | LRright
  | LReject
  | LEOF
  | Lcomm
  | LBleft
  | LBright
  | LBrightComm
  | LArrow
  | LAccept
  | Lsep
  | Lsepa
  | Lassign
  | Leq
  | Lstr of (int list)
  | Lvar of (string)
  | Lresult of (string)

val strCons :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> (Trans.str_cons list) * string
