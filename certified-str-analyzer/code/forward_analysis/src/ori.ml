type token =
  | Lrange
  | Label of (
# 30 "ori.mly"
        string
# 7 "ori.ml"
)
  | Lint of (
# 31 "ori.mly"
        int
# 12 "ori.ml"
)
  | Leol
  | LAutomaton
  | Lsingle of (
# 33 "ori.mly"
        string
# 19 "ori.ml"
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
# 44 "ori.ml"
)
  | Lvar of (
# 39 "ori.mly"
        string
# 49 "ori.ml"
)
  | Lresult of (
# 40 "ori.mly"
        string
# 54 "ori.ml"
)

open Parsing
let _ = parse_error;;
# 3 "ori.mly"

open Trans ;;
open String;;
open Char ;;

let rec dtox s = Printf.sprintf "\\u%04x" s ;;

let rec str_code_l1 i s = if i >= ((String.length s) ) then []
       		      	else ( (((code (get s i))) ::
			      (str_code_l1 (i+1) s))) ;;


let label2kind l = match l with 
       "accept"  -> 0
     | "reject"  -> 1
     |   _       -> 2 ;;

let rec consTrans i l = match l with
    [] -> [{origin = i; kind = 0; toL = []}]
   | a :: rl -> ({origin = i; kind = 1; toL = [{label =  dtox a; target = (i + 1)}]} :: (consTrans (i+1) rl));;
   
let consAuto l = if l = [] then {init = [0]; trans = [{origin = 0; kind = 0; toL = []}]}
    	       	 else {init = [0]; trans = (consTrans 0 l)} ;;

# 84 "ori.ml"
let yytransl_const = [|
  257 (* Lrange *);
  260 (* Leol *);
  261 (* LAutomaton *);
  263 (* LState *);
  264 (* LInitial *);
  265 (* Lconcat *);
  266 (* Lin *);
  267 (* Lleft *);
  268 (* LLleft *);
  269 (* Lright *);
  270 (* LRright *);
  271 (* LReject *);
  272 (* LEOF *);
  273 (* Lcomm *);
  274 (* LBleft *);
  275 (* LBright *);
  276 (* LBrightComm *);
  277 (* LArrow *);
  278 (* LAccept *);
  279 (* Lsep *);
  280 (* Lsepa *);
  281 (* Lassign *);
  282 (* Leq *);
    0|]

let yytransl_block = [|
  258 (* Label *);
  259 (* Lint *);
  262 (* Lsingle *);
  283 (* Lstr *);
  284 (* Lvar *);
  285 (* Lresult *);
    0|]

let yylhs = "\255\255\
\001\000\001\000\002\000\002\000\004\000\004\000\003\000\003\000\
\003\000\006\000\007\000\007\000\005\000\005\000\008\000\010\000\
\010\000\009\000\009\000\011\000\012\000\013\000\013\000\014\000\
\015\000\015\000\015\000\016\000\016\000\016\000\016\000\016\000\
\016\000\016\000\016\000\016\000\016\000\016\000\016\000\017\000\
\000\000"

let yylen = "\002\000\
\003\000\002\000\001\000\002\000\001\000\001\000\009\000\004\000\
\003\000\002\000\001\000\002\000\004\000\003\000\004\000\001\000\
\001\000\001\000\002\000\000\000\007\000\001\000\002\000\000\000\
\003\000\003\000\004\000\001\000\001\000\001\000\001\000\001\000\
\001\000\001\000\001\000\001\000\001\000\001\000\001\000\003\000\
\002\000"

let yydefred = "\000\000\
\000\000\000\000\006\000\005\000\041\000\000\000\000\000\000\000\
\002\000\000\000\004\000\000\000\000\000\000\000\001\000\000\000\
\009\000\000\000\000\000\000\000\000\000\000\000\000\000\008\000\
\014\000\000\000\000\000\000\000\018\000\000\000\000\000\000\000\
\000\000\013\000\019\000\000\000\015\000\000\000\000\000\017\000\
\016\000\000\000\000\000\000\000\007\000\000\000\028\000\038\000\
\039\000\030\000\031\000\029\000\032\000\033\000\034\000\035\000\
\036\000\037\000\021\000\022\000\000\000\000\000\000\000\023\000\
\000\000\000\000\000\000\040\000\025\000\000\000\026\000\027\000"

let yydgoto = "\002\000\
\005\000\006\000\007\000\008\000\017\000\000\000\000\000\022\000\
\028\000\042\000\029\000\030\000\059\000\060\000\061\000\062\000\
\063\000"

let yysindex = "\005\000\
\254\254\000\000\000\000\000\000\000\000\247\254\254\254\005\255\
\000\000\249\254\000\000\015\255\027\255\239\254\000\000\026\255\
\000\000\025\255\014\255\019\255\034\255\035\255\254\254\000\000\
\000\000\020\255\041\255\028\255\000\000\035\255\029\255\042\255\
\036\255\000\000\000\000\254\254\000\000\013\255\037\255\000\000\
\000\000\039\255\030\255\032\255\000\000\000\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\255\004\255\038\255\000\000\
\000\255\001\255\046\255\000\000\000\000\047\255\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\248\254\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\033\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\033\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\009\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\009\255\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\049\000\000\000\004\000\000\000\000\000\000\000\000\000\
\027\000\000\000\000\000\000\000\253\255\000\000\000\000\251\255\
\000\000"

let yytablesize = 60
let yytable = "\003\000\
\047\000\048\000\049\000\069\000\065\000\001\000\009\000\003\000\
\015\000\019\000\050\000\051\000\052\000\053\000\012\000\024\000\
\054\000\055\000\056\000\010\000\003\000\070\000\057\000\058\000\
\066\000\004\000\031\000\040\000\024\000\013\000\014\000\020\000\
\016\000\021\000\041\000\018\000\023\000\024\000\025\000\039\000\
\026\000\027\000\032\000\033\000\037\000\036\000\038\000\034\000\
\071\000\072\000\043\000\044\000\020\000\045\000\046\000\011\000\
\035\000\064\000\067\000\068\000"

let yycheck = "\002\001\
\001\001\002\001\003\001\003\001\001\001\001\000\016\001\016\001\
\016\001\027\001\011\001\012\001\013\001\014\001\010\001\007\001\
\017\001\018\001\019\001\029\001\029\001\021\001\023\001\024\001\
\021\001\028\001\023\000\015\001\020\001\025\001\026\001\006\001\
\018\001\008\001\022\001\009\001\012\001\024\001\020\001\036\000\
\007\001\007\001\023\001\003\001\003\001\017\001\011\001\020\001\
\003\001\003\001\014\001\013\001\020\001\024\001\023\001\007\000\
\030\000\061\000\021\001\065\000"

let yynames_const = "\
  Lrange\000\
  Leol\000\
  LAutomaton\000\
  LState\000\
  LInitial\000\
  Lconcat\000\
  Lin\000\
  Lleft\000\
  LLleft\000\
  Lright\000\
  LRright\000\
  LReject\000\
  LEOF\000\
  Lcomm\000\
  LBleft\000\
  LBright\000\
  LBrightComm\000\
  LArrow\000\
  LAccept\000\
  Lsep\000\
  Lsepa\000\
  Lassign\000\
  Leq\000\
  "

let yynames_block = "\
  Label\000\
  Lint\000\
  Lsingle\000\
  Lstr\000\
  Lvar\000\
  Lresult\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'strConss) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 58 "ori.mly"
                                  ((_1,_2))
# 243 "ori.ml"
               : (Trans.str_cons list) * string))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'strConss) in
    Obj.repr(
# 59 "ori.mly"
                           ((_1,"non"))
# 250 "ori.ml"
               : (Trans.str_cons list) * string))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'strCon) in
    Obj.repr(
# 61 "ori.mly"
            ([_1])
# 257 "ori.ml"
               : 'strConss))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'strCon) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'strConss) in
    Obj.repr(
# 62 "ori.mly"
                                      (_1 :: _2)
# 265 "ori.ml"
               : 'strConss))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 64 "ori.mly"
                    (_1)
# 272 "ori.ml"
               : 'Lid))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 65 "ori.mly"
                  (_1)
# 279 "ori.ml"
               : 'Lid))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 8 : 'Lid) in
    let _5 = (Parsing.peek_val __caml_parser_env 4 : 'Lid) in
    let _7 = (Parsing.peek_val __caml_parser_env 2 : 'Lid) in
    Obj.repr(
# 68 "ori.mly"
                                                          (Strconcat (_1, _5, _7))
# 288 "ori.ml"
               : 'strCon))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'Lid) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : int list) in
    Obj.repr(
# 69 "ori.mly"
                                                (Regexcon (_1, consAuto _3))
# 296 "ori.ml"
               : 'strCon))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Lid) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'automaton) in
    Obj.repr(
# 70 "ori.mly"
                                 (Regexcon (_1, _3))
# 304 "ori.ml"
               : 'strCon))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'automata) in
    Obj.repr(
# 75 "ori.mly"
                  (_1)
# 311 "ori.ml"
               : 'automataEnd))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'automaton) in
    Obj.repr(
# 78 "ori.mly"
                    ([_1])
# 318 "ori.ml"
               : 'automata))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'automaton) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'automata) in
    Obj.repr(
# 79 "ori.mly"
                          ( _1 :: _2 )
# 326 "ori.ml"
               : 'automata))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'initstate) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'transitions) in
    Obj.repr(
# 83 "ori.mly"
                                                    ({init=_2; trans=_3})
# 334 "ori.ml"
               : 'automaton))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 84 "ori.mly"
                                              (consAuto (str_code_l1 0 _2))
# 341 "ori.ml"
               : 'automaton))
; (fun __caml_parser_env ->
    let _4 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 90 "ori.mly"
                                ([_4])
# 348 "ori.ml"
               : 'initstate))
; (fun __caml_parser_env ->
    Obj.repr(
# 93 "ori.mly"
                       ("accept")
# 354 "ori.ml"
               : 'tlabel))
; (fun __caml_parser_env ->
    Obj.repr(
# 94 "ori.mly"
                       ("reject")
# 360 "ori.ml"
               : 'tlabel))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'epsilon) in
    Obj.repr(
# 97 "ori.mly"
                       ( _1 )
# 367 "ori.ml"
               : 'transitions))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'transition) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'transitions) in
    Obj.repr(
# 98 "ori.mly"
                                     (_1 :: _2)
# 375 "ori.ml"
               : 'transitions))
; (fun __caml_parser_env ->
    Obj.repr(
# 101 "ori.mly"
                                               (  [] )
# 381 "ori.ml"
               : 'epsilon))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'tlabel) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'ttos) in
    Obj.repr(
# 105 "ori.mly"
                                               ({origin=_2; kind=(label2kind _4); toL=_7})
# 390 "ori.ml"
               : 'transition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'emptyto) in
    Obj.repr(
# 108 "ori.mly"
                  ( _1)
# 397 "ori.ml"
               : 'ttos))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'tto) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'ttos) in
    Obj.repr(
# 109 "ori.mly"
                     ( _1 :: _2 )
# 405 "ori.ml"
               : 'ttos))
; (fun __caml_parser_env ->
    Obj.repr(
# 112 "ori.mly"
                                         ([])
# 411 "ori.ml"
               : 'emptyto))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'sspec) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 115 "ori.mly"
                           ({label=_1; target=(_3)})
# 419 "ori.ml"
               : 'tto))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'range) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 116 "ori.mly"
                                        ({label=_1; target=(_3)})
# 427 "ori.ml"
               : 'tto))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'sspec) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 117 "ori.mly"
                               ({label=(String.concat "-" [_1;">"]); target=(_4)})
# 435 "ori.ml"
               : 'tto))
; (fun __caml_parser_env ->
    Obj.repr(
# 120 "ori.mly"
               ("\\u002d")
# 441 "ori.ml"
               : 'sspec))
; (fun __caml_parser_env ->
    Obj.repr(
# 121 "ori.mly"
                                        ("]")
# 447 "ori.ml"
               : 'sspec))
; (fun __caml_parser_env ->
    Obj.repr(
# 122 "ori.mly"
              ("[")
# 453 "ori.ml"
               : 'sspec))
; (fun __caml_parser_env ->
    Obj.repr(
# 123 "ori.mly"
               ("(")
# 459 "ori.ml"
               : 'sspec))
; (fun __caml_parser_env ->
    Obj.repr(
# 124 "ori.mly"
                (")")
# 465 "ori.ml"
               : 'sspec))
; (fun __caml_parser_env ->
    Obj.repr(
# 125 "ori.mly"
              (",")
# 471 "ori.ml"
               : 'sspec))
; (fun __caml_parser_env ->
    Obj.repr(
# 126 "ori.mly"
               ("{")
# 477 "ori.ml"
               : 'sspec))
; (fun __caml_parser_env ->
    Obj.repr(
# 127 "ori.mly"
                ("}")
# 483 "ori.ml"
               : 'sspec))
; (fun __caml_parser_env ->
    Obj.repr(
# 128 "ori.mly"
             (":")
# 489 "ori.ml"
               : 'sspec))
; (fun __caml_parser_env ->
    Obj.repr(
# 129 "ori.mly"
              (";")
# 495 "ori.ml"
               : 'sspec))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 130 "ori.mly"
              (_1)
# 502 "ori.ml"
               : 'sspec))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 131 "ori.mly"
             (string_of_int _1)
# 509 "ori.ml"
               : 'sspec))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'sspec) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'sspec) in
    Obj.repr(
# 134 "ori.mly"
                          (String.concat "-" [_1;_3])
# 517 "ori.ml"
               : 'range))
(* Entry strCons *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let strCons (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : (Trans.str_cons list) * string)
