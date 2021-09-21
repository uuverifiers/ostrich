
{
   open Ori;;
   open Char;;
   open String;;
   let string_chars s = String.sub s 1 ((String.length s)-2) ;;

   exception SmtStrExcep of string
   

   let rec str_code_l i s = if i >= ((String.length s) - 1) then []
       		      	else (let fste = (get s i) in
  			      if fste <> '\"' then
			           (((code (get s i))) ::
			           (str_code_l (i+1) s))
			      else if (fste = '\"' && (i + 1) < (String.length s) - 1 && (get s (i+1) = '\"'))
			      	   then (code '\"' :: (str_code_l (i+2) s))
			      else
			           raise (SmtStrExcep "smt string format has problems")
			     ) ;;

   exception Eof

}

rule lexer = parse
       [' ' '\t' '\n']		        {lexer lexbuf}
     | "// Forward propagation can prove that the constraints are unsat" {Lresult "unsat"}
     | "// Forward propagation is inconclusive" {Lresult "sat"}
     | "Automaton"			{LAutomaton}
     | "state"				{LState}
     | "concat"				{Lconcat}
     | "initial"			{LInitial}
     | "accept"				{LAccept}
     | "reject"				{LReject}
     | "singleton: " ['\x00'-'\x09' '\x0b'-'\x7c' '\x7e'-'\xff']*    {Lsingle (String.sub (Lexing.lexeme lexbuf) 11
       		     		    		         (length  (Lexing.lexeme lexbuf) - 11))}
     | "in"				{Lin}
     | "->"				{LArrow}
     | "\\u" ['0'-'9' 'a'-'f']+		{Label (Lexing.lexeme lexbuf)}
     | ":="				{Lassign}
     | "=="				{Leq}
     | ":"				{Lsep}
     | "("				{LLleft}
     | ")"				{LRright}
     | "{"				{LBleft}
     | '}' [' ' '\t' '\n']* ';'			{LBrightComm}
     | "}"				{LBright}
     | "["				{Lleft}
     | "]"				{Lright}
     | "-"				{Lrange}
     | ";"				{Lsepa}
     | ","				{Lcomm}
     | ['0'-'9']+			{Lint (int_of_string (Lexing.lexeme lexbuf))}
     | ['A'-'Z' 'a'-'z' '0'-'9'] ['A'-'Z' 'a'-'z' '0'-'9' '_']+
       		      		        {let s = (Lexing.lexeme lexbuf) in (Lvar s)}
     | '\"' ([^ '"']* ("\"\"")* [^ '"']*)* '\"'     {Lstr (str_code_l 1 (Lexing.lexeme lexbuf))}
     | ['\x00'-'\xff']                  {Label (Lexing.lexeme lexbuf)}
     | eof				{LEOF} 


     