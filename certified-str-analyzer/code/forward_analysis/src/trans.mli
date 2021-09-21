open String ;;

type tranto = {label:string;target:int}

type tran_def = {origin : int; kind : int;  toL:tranto list} ;;

type automata_def = {init: int list; trans: tran_def list};;

type str_cons = Strconcat of string * string * string
     	      | Regexcon  of string * automata_def
