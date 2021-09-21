
open Trans;;
open String;;
open Char;;
open Str ;;
open Forward ;;
open Printf;;

exception Automata_less


module SS = Set.Make(String);;
module ConcatC = Map.Make(String);;
module ConcatR = Map.Make(String);;

let rec get_index_aux e l i = match l with [] -> -1 |  a :: rl -> (if a = e then i else (get_index_aux e rl (i + 1))) ;;
let get_index e l = get_index_aux e l 0;; 


let rec statesintrans t = 
            match t with
                [] -> []
             |  {origin=i;kind=_;toL=_} ::rs -> i :: statesintrans rs;;
        
let states at = match at with {init=_;trans=ts} -> statesintrans ts ;;

let rec acceptintrans t = 
            match t with
                [] -> []
             |  {origin=i;kind=0;toL=_} ::rs -> i :: acceptintrans rs
             |  {origin=i;kind=1;toL=_} ::rs -> acceptintrans rs
             |  {origin=i;kind=_;toL=_} ::rs -> acceptintrans rs;;

let rec acceptstates at =
            match at with {init=_;trans=ts} -> acceptintrans ts ;;

let initialstates at =
            match at with {init=s;trans=ts} -> s ;;


let rec output_intl oc l = match l with
            [] -> ()
         | x :: [] -> output_string oc (string_of_int (x ))
         | x :: rs -> output_string oc ((string_of_int(x))^"; ") ; output_intl oc rs ;;

let rec output_transitions oc ls = 
      match ls with
        [] -> ()
      | (s,l,t) :: [] -> output_string oc "(";
                 output_string oc (string_of_int (s));
                 output_string oc ",(";
                 output_string oc l;
                 output_string oc "),";
                 output_string oc (string_of_int (t));
                 output_string oc ")" ;
      | (s,l,t)::rs -> output_string oc "(";
                 output_string oc (string_of_int (s));
                 output_string oc ",(";
                 output_string oc l;
                 output_string oc "),";
                 output_string oc (string_of_int (t));
                 output_string oc ");" ;
                 output_transitions oc rs
                ;;



let rec init_states at = match at with {init = initstates; trans=_} -> initstates ;;

(************For HEX symbol and range*************)

let from = [| '0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'; 'A'; 'B'; 'C'; 'D'; 'E'; 'F' |] ;;
(*let To = [ 0 ;  1 ;  2 ;  3 ;  4 ;  5 ;  6 ;  7 ;  8;   9 ; 10; 11; 12; 13; 14; 15] ;; *)

let hexA c = 
    if c = from.(0) then 0
    else if c = from.(1) then 1
    else if c = from.(2) then 2
    else if c = from.(3) then 3
    else if c = from.(4) then 4
    else if c = from.(5) then 5
    else if c = from.(6) then 6
    else if c = from.(7) then 7
    else if c = from.(8) then 8
    else if c = from.(9) then 9
    else if c = 'a' then 10
    else if c = 'b' then 11
    else if c = 'c' then 12
    else if c = 'd' then 13
    else if c = 'e' then 14
    else if c = 'f' then 15
    else 0
    ;;

let l2int s = 
      (if length s == 1 then code (get s 0)
		else ((hexA (get s 2)) * 16 * 16 * 16 + (hexA (get s 3)) * 16 * 16 + (hexA (get s 4)) * 16 + (hexA (get s 5))))
     ;;




let rec gen_range bg ed = if bg == ed then concat "," [ string_of_int (ed); string_of_int (ed)]
                          else if bg < ed then concat "," [string_of_int bg; string_of_int ed ]
                          else "" ;;

let gen_label s = let ss = String.split_on_char '-' s in
if List.length ss == 1 then concat "," [ string_of_int(l2int (List.nth ss 0)); string_of_int(l2int (List.nth ss 0))]
else gen_range (l2int (List.nth ss 0)) (l2int (List.nth ss 1)) ;;


let rec trans1 s tos = match tos with [] -> [] |
                     {label=l;target=t} :: rs -> (s,gen_label l,t) :: trans1 s rs 

let rec trans2 t = 
            match t with
                [] -> []
             |  {origin=i;kind=_;toL=tos} ::rs -> (trans1 i tos) @ trans2 rs

let rec transitions at = match at with {init = initstates; trans=ts} -> trans2 ts ;;


       


let write_out oc at i = output_string oc ("let a" ^ string_of_int i ^ " = nfa_construct_reachable (nfa_construct ([], [") ;
(* output_intl oc (states at) ; *)
 print_string "number of transitions:" ; print_int (List.length (transitions at)) ; print_newline();
  output_transitions oc (transitions at);
			output_string oc ("], [") ;

   output_string oc (string_of_int (i * 1000) ^ "], [") ;
			output_intl oc (acceptstates at) ; output_string oc "] ));;" ;;
			
let rec write_out_automata al oc i =
      match al with [] -> ()
    | at :: res -> write_out oc at i; output_string oc "\n"; write_out_automata res oc (i+1) ;;
			


let header = "open Forward;; \n";;

let rec construct_product oc i = match i with
        1 -> output_string oc "a0"
      | i when i > 1 -> output_string oc "nfa_concate ";
                        output_string oc "a";
                        output_string oc (string_of_int (i-1));
                        output_string oc " " ;
                        construct_product oc (i-1) 
      | _ -> raise Automata_less ;; 

(*
let convert_one s =
  let oc = open_out (s ^ ".ml") in
  let ic = open_in (s) in
         
        output_string oc header;
        let lexbuf = Lexing.from_channel ic in
        let result = Ori.automataEnd Orilex.lexer lexbuf in
        write_out_automata result oc 0; 
        output_string oc "let product = "; 
        construct_product oc (List.length result);
        output_string oc ";;\n";
        output_string oc "print_auto (nfa_destruct product) ;;\n"; 
        close_out oc ; close_in ic;;
*)

let convert_one s = ();;

let f e ol = match ol with None -> Some [e] | Some l -> Some (e :: l) ;;

let rec genStrCon cons = match cons with
                  [] -> (SS.empty, ConcatC.empty, ConcatR.empty)
                | a :: rcons ->
		  let (reSS, reC, reR) = genStrCon rcons in 
		    (match a with
			   Strconcat (v1,v2,v3) ->
			     (SS.add v3 (SS.add v2 (SS.add v1 reSS)),
			      ConcatC.update v1 (f (v2, v3)) reC,
			      reR
			      ) |
                            Regexcon (v, aut) -> 
                             (SS.add v reSS,
                              reC,
                              ConcatR.update v (f aut) reR)
			      
                     ) ;;

let print_set s = List.iter (fun s -> print_string s; print_string "; ") (SS.elements s) ;;
let print_mapc s = List.iter (fun (s1,s2) -> print_string s1; print_string "-->";
				  (List.iter (fun (s1,s2) -> print_string s1; print_string " . ";
						  print_string s2; print_string "\n") s2);
						 print_string "; \n") (ConcatC.bindings s) ;;

let genv s l = "v" ^ (string_of_int (get_index s l)) ;;
						 

let rec genPair ls l = match ls with
    [] -> []
   |(s1,s2)::rs -> (z_to_int (get_index s1 l), z_to_int (get_index s2 l)) :: (genPair rs l);;

let rec out_mapc s l = match s with
    [] -> []
   |(s1,s2) :: rs -> (z_to_int (get_index s1 l), genPair s2 l) :: out_mapc rs l ;;


let rec count_mapcl s l = match s with
    [] -> 0
   |(s1,s2) :: rs -> (List.length s2) + (count_mapcl rs l) ;;

let rec count_mapc s l = count_mapcl (ConcatC.bindings s) l;;
   
let rec gen_mapc s l = out_mapc (ConcatC.bindings s) l ;;
                      
						 
let print_auto at = print_string ("nfa_construct ([], [") ;

			print_string ("], [") ;
   print_string (string_of_int (0) ^ "], [") ;
   output_intl stdout (acceptstates at) ; print_string "] );;" ;;

let rec transitions_string ls = 
      match ls with
        [] -> ""
      | (s,l,t) :: [] -> "(" ^ (string_of_int (s)) ^  ",(" ^ l ^ ")," ^ (string_of_int (t)) ^ ")" ;
      | (s,l,t)::rs -> "(" ^ (string_of_int (s)) ^ ",(" ^ l ^ ")," ^ (string_of_int (t)) ^ ");" ^ transitions_string rs
      ;;

let get_interval s = let l = String.split_on_char ',' s in
      (int_of_string (List.nth l 0), int_of_string (List.nth l 1));;
      
let rec transitions_list ls = 
      match ls with
        [] -> []
      | (s,l,t) :: [] -> [(s, get_interval l, t)]
      | (s,l,t)::rs -> (s, get_interval l, t) :: (transitions_list rs) ;;


let rec intl_string  l = match l with
            [] -> ""
         | x :: [] -> (string_of_int (x))
         | x :: rs -> ((string_of_int(x)) ^ "; ") ^ (intl_string rs) ;;
   

	 
let auto_string at =  "(nfa_construct_reachable (nfa_construct ([], [" ^
   (transitions_string (transitions at)) ^
		        "], [" ^ (intl_string (initialstates at)) ^ "], [" ^
   intl_string (acceptstates at) ^ "])))" ;;

let gen_aut at = nfa_construct_reachable (nfa_construct ([], transitions_list (transitions at), initialstates at, acceptstates at));;

let search_index r s = try search_forward r s 0 with Not_found -> -1 ;;

let splitAT s = let ic = open_in s in 
    let cnt = ref 0 in 
    try
    let reg1 = regexp "The following 2 automata have empty intersection:" in
    while true do
        let line = input_line ic in let bi = search_index reg1 line in 
            if bi <> -1 then (
                let oc = open_out (s^(string_of_int (!cnt))^"a") in 
                let reg2 = regexp "========\\|sat" in 
                let line1 = ref (input_line ic) in let bi1 = ref (search_index reg2 !line1) in 
                cnt := !cnt + 1;
                while !bi1 = -1 do
                   output_string oc (!line1^"\n");
                   line1 := input_line ic ;
                   bi1 := (search_index reg2 !line1)
                done;
                close_out oc;
            ) else ()
     done
     with End_of_file -> ( close_in ic;
        let i = ref 0 in
        while !i < !cnt do 
             convert_one (s^(string_of_int (!i))^"a");
             i := !i + 1
        done 
     );;

let rec gen_concate l = match l with
      [] -> raise Automata_less
    | [a] -> auto_string a 
    |  a :: rl -> "(nfa_product "^ " " ^ auto_string a ^ " " ^ gen_concate rl ^ ")";;

let rec out_S oc l sl = match l with
      [] -> ()
    | a :: rl -> (output_string oc ("let " ^ (genv a sl) ^ " = (" ^ "z_to_int " ^ (string_of_int (get_index a sl)) ^ ");;\n");
                  out_S oc rl sl);;
    
let out_mapr oc s l = output_string oc "[" ; (List.iter (fun (s1,s2) -> output_string oc "("; output_string oc (genv s1 l);
					                                  output_string oc ",";
				                output_string oc (gen_concate s2);
					        output_string oc "); \n") (ConcatR.bindings s)) ; output_string oc "]" ;;

let rec gen_concater l = match l with
      [] -> raise Automata_less
    | [a] -> gen_aut a
    |  a :: rl -> nfa_product (gen_aut a) (gen_concater rl) ;;


let rec gen_maprs s l = 
        match s with
         [] -> []
       | (s1,s2) :: rs -> (z_to_int (get_index s1 l), gen_concater s2) :: gen_maprs rs l;;

let gen_mapr s l = gen_maprs (ConcatR.bindings s) l;;

let count_aut at = print_int (List.length (transitions_list (transitions at))) ;;
         
let rec count_concater l = match l with
      [] -> raise Automata_less
    | [a] -> count_aut a; print_string ";\n"
    |  a :: rl -> ((count_aut a); print_string ", "; (count_concater rl)) ;;


let rec count_maprs s l = 
        match s with
         [] -> ()
       | (s1,s2) :: rs -> (print_int (get_index s1 l); print_string ",\n number of transitions:\n";
				     count_concater s2; print_newline ();
			   count_maprs rs l);;

let count_mapr s l = count_maprs (ConcatR.bindings s) l;;
       



let rec full_rm sl rm = match sl with
[] -> rm
| a :: rl -> (if ConcatR.mem a rm then (full_rm rl rm) else (full_rm rl (ConcatR.add a [{init=[0];trans=[{origin=0;kind=0;
                  toL = [{label = "\\u0000-\\uffff"; target = 0}]}]}] rm)));;


let rec gen_intl b e = (if b = e then [e] else (b :: (gen_intl (b+1) e)));;

let rec inL e l = match l with [] -> false | a :: rl -> (if a = e then true else inL e rl) ;;

let rec checkcomplete_aux l s = match l with
         [] -> (true, s)
    | (b1,b2) :: rl -> (if (inL b1 s) || (inL b2 s) then (false, s)
                      else (checkcomplete_aux rl (b1::b2::s))) ;;

let rec checkcomplete l s = match l with
         [] -> true
    | (a, l) :: rl -> (let re = checkcomplete_aux l s in if (fst re) then checkcomplete rl (snd re) else false) ;;


let rec check_unsat_number1 ic =
let fst = input_line ic in
let snd = input_line ic in
let third = input_line ic in
   (if fst <> "end" then
      (fst, snd, third) :: (check_unsat_number1 ic)
    else []);;

let rec check_unsat_number2 ic =
let fst = input_line ic in
let snd = input_line ic in
   (if fst <> "end" then
      (fst, snd) :: (check_unsat_number2 ic)
    else []);;

   
let rec print_unsat_test1 l = match l with
    [] -> print_string "end\n"
  | (a,b,c)::rl -> (print_string a; print_string ", "; print_string b; print_string ","; print_string c; print_unsat_test1 rl);;

let rec print_unsat_test2 l = match l with
    [] -> print_string "end\n"
  | (a,b)::rl -> (print_string a; print_string ", "; print_string b; print_string ","; print_unsat_test2 rl);;

let rec check_unsat_an s l =
    match l with [] -> 0 | (a, b, c) :: rl -> (if s = a && b = "inconclusive" then 
     (print_string a; print_string "\n"; 1) else check_unsat_an s rl) ;;

let rec analysis_unsat l1 l2 = 
    match l1 with [] -> 0
  |   (a,b) :: rl -> (if b = "maybe_incomplete" then ((check_unsat_an a l2) + (analysis_unsat rl l2)) else analysis_unsat rl l2) ;;

let rec compute_time l n =
  match l with [] -> (0.0, n) | (a,b,c) ::rl  -> (if b <> "timeout" 
     then (let (r1,l1) = compute_time rl (n+1) in ((Float.of_string c) +. r1, l1) ) else compute_time rl n);;

let rec compute_substring l n =
  match l with [] -> (0.0, n) | (a,b,c) ::rl  -> (if (String.sub a 0 31) = "./extracted-constraints/sat/sma"
						      && b <> "timeout" && b <> "parser_error"
     then (let (r1,l1) = compute_substring rl (n+1) in ((Float.of_string c) +. r1, l1) ) else compute_substring rl n);;

let rec compute_timeout l =
  match l with [] -> print_string "end" | (a,b,c1) ::rl  -> (if b = "timeout"
     then (print_string a; print_newline ();
	    let ic = open_in (a) in
	    let lexbuf = Lexing.from_channel ic in
            let result = Ori.strCons Orilex.lexer lexbuf in
            let (s,c,r) = genStrCon (fst result) in
            let sl = SS.elements s in	   
            let s = gen_S_from_list (List.map z_to_int (gen_intl 0 (List.length sl - 1))) in
            let rc = gen_rc_from_list (gen_mapc c sl) in
                     ( print_int (List.length sl); print_newline ();
		       print_int (count_mapc c sl); (count_mapr r sl) ;close_in ic ; print_newline() ;
                       compute_timeout rl))  else compute_timeout rl);;
     

 (* 
let s1 = Sys.argv.(1) in
let s2 = Sys.argv.(2) in
let ic1 = open_in s1 in
let ic2 = open_in s2 in
let l1 = check_unsat_number2 ic1 in
let l2 = check_unsat_number1 ic2 in
 compute_timeout l2 ;; 
   let (r,l) = compute_time l2 0 in 
   let (r,l) = compute_substring l2 0 in
   (print_string (Float.to_string r); print_string "\n"; print_int l; print_string "\n");; 
 print_int (analysis_unsat l1 l2) ;; *)


   
 let convert_one_cons s =
  let ic = open_in (s) in
  let lexbuf = Lexing.from_channel ic in
  let result = Ori.strCons Orilex.lexer lexbuf in
  let (s,c,r) = genStrCon (fst result) in
  let sl = SS.elements s in
  let s = gen_S_from_list (List.map z_to_int (gen_intl 0 (List.length sl - 1))) in
  let rc = gen_rc_from_list (gen_mapc c sl)  in
  let rr = full_rm sl r in
  let rm = gen_rm_from_list (gen_mapr rr sl) in
  (let (s,(rm,r)) = forward_analysis (z_to_int 1) (z_to_int 2) s rc rm in
   (print_string (check_unsat_rm r rc (rm_to_list rm));
   close_in ic));;

 convert_one_cons Sys.argv.(1)  ;; 

let print_file s = 
    let ic = open_in s in
    let oc = open_out "intermediate.txt" in 
    try 
       let line = input_line ic in 
       fprintf oc "%s\n" line;   
       let line = input_line ic in
       fprintf oc "%s\n" line;
(*       print_endline line; *)
       flush stdout;
       close_in ic;
       close_out oc;
       print_string "unsat"
    with e ->
       close_in_noerr ic ;
       close_out_noerr oc;
       raise e;;


(* print_file Sys.argv.(1) ;; *)


(*
  (if checkcomplete (gen_mapc c sl) [] then print_string "complete" else print_string "maybe_incomplete");; 
*)
