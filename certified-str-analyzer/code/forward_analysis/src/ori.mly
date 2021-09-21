
%{

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

%}

%token Lrange
%token <string> Label
%token <int> Lint
%token Leol LAutomaton
%token <string> Lsingle
%token LState LInitial Lconcat Lin
%token Lleft LLleft Lright LRright LReject LEOF Lcomm LBleft LBright LBrightComm
%token LArrow
%token LAccept Lsep Lsepa Lassign Leq
%token <int list>Lstr
%token <string> Lvar
%token <string> Lresult


%nonassoc Lsepa
%nonassoc Lsep
%nonassoc LBright
%nonassoc LArrow
%nonassoc Lrange
%nonassoc Lint



%start strCons
%type <(Trans.str_cons list) * string> strCons


%%

strCons: strConss Lresult LEOF				{($1,$2)}
      |  strConss LEOF					{($1,"non")}
strConss:
	strCon					{[$1]}
      | strCon strConss             		{$1 :: $2}

Lid: Lvar      					{$1}
  |  Label   					{$1}

strCon:
	Lid Lassign Lconcat LLleft Lid Lcomm Lid LRright Lsepa   {Strconcat ($1, $5, $7)}
      | Lid Leq Lstr Lsepa  	       	     	 	 	 {Regexcon ($1, consAuto $3)}
      |	Lid Lin automaton 				 	 {Regexcon ($1, $3)}

	

automataEnd:
	automata LEOF				{$1}

automata :
     automaton 					{[$1]}
   | automaton automata			{ $1 :: $2 }


automaton:
         LBleft initstate transitions LBrightComm			{{init=$2; trans=$3}}
      |  LBleft Lsingle LBrightComm       				{consAuto (str_code_l1 0 $2)}
          



initstate:
     LInitial LState Lsep Lint		{[$4]}

tlabel:
     LAccept				       {"accept"}
   | LReject				       {"reject"}

transitions:
     epsilon				       { $1 }
   | transition transitions          {$1 :: $2}

epsilon:
                                               {  [] }


transition:
    LState Lint Lleft tlabel Lright Lsep ttos  {{origin=$2; kind=(label2kind $4); toL=$7}}

ttos:
     emptyto						{ $1}
   | tto ttos   					{ $1 :: $2 }

emptyto:
	                                        {[]}

tto:
     sspec LArrow Lint	  		{{label=$1; target=($3)}}
   | range LArrow Lint                  {{label=$1; target=($3)}}
   | sspec LArrow LArrow Lint		{{label=(String.concat "-" [$1;">"]); target=($4)}}
   
sspec:
     Lrange				{"\\u002d"}
   | Lright                             {"]"}
   | Lleft				{"["}
   | LLleft				{"("}
   | LRright				{")"}
   | Lcomm				{","}
   | LBleft				{"{"}
   | LBright				{"}"}
   | Lsep				{":"}
   | Lsepa				{";"}
   | Label				{$1}
   | Lint				{string_of_int $1}

range:
     sspec Lrange sspec		 {String.concat "-" [$1;$3]}


