type token =
  | Lrange
  | Label of (
# 30 "ori.mly"
        string
# 7 "ori.mli"
)
  | Lint of (
# 31 "ori.mly"
        int
# 12 "ori.mli"
)
  | Leol
  | LAutomaton
  | Lsingle of (
# 33 "ori.mly"
        string
# 19 "ori.mli"
)
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
  | Lstr of (
# 38 "ori.mly"
        int list
# 44 "ori.mli"
)
  | Lvar of (
# 39 "ori.mly"
        string
# 49 "ori.mli"
)
  | Lresult of (
# 40 "ori.mly"
        string
# 54 "ori.mli"
)

val strCons :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> (Trans.str_cons list) * string
