(*  Title:       Code generation setup
    Authors:     Thomas Tuerk <tuerk@in.tum.de>
*)

header {* Setting up the code generation *}

theory Presburger_Test
imports Main 
        "../implementation/Presburger_Impl"
        "~~/src/HOL/Library/afp/Presburger-Automata/Exec"
begin



abbreviation "mk_DFA \<equiv> ahs_pres_pf_to_nfa 0"
definition eval_pf_dfa where
 "eval_pf_dfa pf = dfa_accepts (mk_dfa pf) []"

export_code ahs_pres_pf_to_nfa ahs_eval_pf eval_pf_dfa
 stamp stamp_false example example2 example2_false harrison1 harrison2
in SML file "~/Presburger.sml"

definition "test == mk_DFA stamp"
definition "test2 == 30::nat"

definition "

ML_val {*
  val mk_dfa = @{code ahs_pres_pf_to_nfa } 0;

  val a = mk_dfa @{code stamp};
  val accepts = @{code ahs_nfa_accept}

*}


export_code ahs_pres_pf_to_nfa  in SML file "/tmp/test.ML"

use  "/tmp/test.ML"

value [code] "mk_DFA stamp"
value "Impl_Brzozowski (mk_DFA stamp)"
value "mk_DFA stamp_false"
value "mk_DFA example"
value "mk_DFA example2"
value "mk_DFA example2_false"
value "mk_DFA harrison1"
value "mk_DFA harrison2"

value "eval_pf_DFA stamp"
value "eval_pf_DFA stamp_false"
value "eval_pf_DFA example"
value "eval_pf_DFA example2"
value "eval_pf_DFA example2_false"
value "eval_pf_DFA harrison1"
value "eval_pf_DFA harrison2"


value "mk_dfa stamp"
value "min_dfa (mk_dfa stamp)"
value "mk_dfa stamp_false"
value "mk_dfa example"
value "mk_dfa example2"
value "mk_dfa example2_false"
value "mk_dfa harrison1"
value "mk_dfa harrison2"

value "eval_pf_dfa stamp"
value "eval_pf_dfa stamp_false"
value "eval_pf_dfa example"
value "eval_pf_dfa example2"
value "eval_pf_dfa example2_false"
value "eval_pf_dfa harrison1"
value "eval_pf_dfa harrison2"


code_include SML "STArray"
{*
structure STArray = struct

datatype 'a Cell = Invalid | Value of 'a array;

exception AccessedOldVersion;

type 'a array = 'a Cell ref;

fun fromList l = ref (Value (Array.fromList l));
fun array (size, v) = ref (Value (Array.array (size,v)));
fun tabulate (size, f) = ref (Value (Array.tabulate(size, f)));
fun sub (ref Invalid, idx) = raise AccessedOldVersion |
    sub (ref (Value a), idx) = Array.sub (a,idx);
fun update (aref,idx,v) =
  case aref of
    (ref Invalid) => raise AccessedOldVersion |
    (ref (Value a)) => (
      aref := Invalid;
      Array.update (a,idx,v);
      ref (Value a)
    );

fun length (ref Invalid) = raise AccessedOldVersion |
    length (ref (Value a)) = Array.length a

fun grow (aref, i, x) = case aref of 
  (ref Invalid) => raise AccessedOldVersion |
  (ref (Value a)) => (
    let val len=Array.length a;
        val na = Array.array (len+i,x) 
    in
      aref := Invalid;
      Array.copy {src=a, dst=na, di=0};
      ref (Value na)
    end
    );

fun shrink (aref, sz) = case aref of
  (ref Invalid) => raise AccessedOldVersion |
  (ref (Value a)) => (
    if sz > Array.length a then 
      raise Size
    else (
      aref:=Invalid;
      ref (Value (Array.tabulate (sz,fn i => Array.sub (a,i))))
    )
  );

structure IsabelleMapping = struct
type 'a ArrayType = 'a array;

fun new_array (a:'a) (n:int) = array (n, a);

fun array_length (a:'a ArrayType) = length a;

fun array_get (a:'a ArrayType) (i:int) = sub (a, i);

fun array_set (a:'a ArrayType) (i:int) (e:'a) = update (a, i, e);

fun array_of_list (xs:'a list) = fromList xs;

fun array_grow (a:'a ArrayType) (i:int) (x:'a) = grow (a, i, x);

fun array_shrink (a:'a ArrayType) (sz:int) = shrink (a,sz);

end;

end;

structure FArray = struct
  datatype 'a Cell = Value of 'a Array.array | Upd of (int*'a*'a Cell ref);

  type 'a array = 'a Cell ref;

  fun array (size,v) = ref (Value (Array.array (size,v)));
  fun tabulate (size, f) = ref (Value (Array.tabulate(size, f)));
  fun fromList l = ref (Value (Array.fromList l));

  fun sub (ref (Value a), idx) = Array.sub (a,idx) |
      sub (ref (Upd (i,v,cr)),idx) =
        if i=idx then v
        else sub (cr,idx);

  fun length (ref (Value a)) = Array.length a |
      length (ref (Upd (i,v,cr))) = length cr;

  fun realize_aux (aref, v) =
    case aref of
      (ref (Value a)) => (
        let
          val len = Array.length a;
          val a' = Array.array (len,v);
        in
          Array.copy {src=a, dst=a', di=0};
          ref (Value a')
        end
      ) |
      (ref (Upd (i,v,cr))) => (
        let val res=realize_aux (cr,v) in
          case res of
            (ref (Value a)) => (Array.update (a,i,v); res)
        end
      );

  fun realize aref =
    case aref of
      (ref (Value _)) => aref |
      (ref (Upd (i,v,cr))) => realize_aux(aref,v);

  fun update (aref,idx,v) =
    case aref of
      (ref (Value a)) => (
        let val nref=ref (Value a) in
          aref := Upd (idx,Array.sub(a,idx),nref);
          Array.update (a,idx,v);
          nref
        end
      ) |
      (ref (Upd _)) =>
        let val ra = realize_aux(aref,v) in
          case ra of
            (ref (Value a)) => Array.update (a,idx,v);
          ra
        end
      ;

  fun grow (aref, inc, x) = case aref of 
    (ref (Value a)) => (
      let val len=Array.length a;
          val na = Array.array (len+inc,x) 
      in
        Array.copy {src=a, dst=na, di=0};
        ref (Value na)
      end
      )
  | (ref (Upd _)) => (
    grow (realize aref, inc, x)
  );

  fun shrink (aref, sz) = case aref of
    (ref (Value a)) => (
      if sz > Array.length a then 
        raise Size
      else (
        ref (Value (Array.tabulate (sz,fn i => Array.sub (a,i))))
      )
    ) |
    (ref (Upd _)) => (
      shrink (realize aref,sz)
    );

structure IsabelleMapping = struct
type 'a ArrayType = 'a array;

fun new_array (a:'a) (n:int) = array (n, a);

fun array_length (a:'a ArrayType) = length a;

fun array_get (a:'a ArrayType) (i:int) = sub (a, i);

fun array_set (a:'a ArrayType) (i:int) (e:'a) = update (a, i, e);

fun array_of_list (xs:'a list) = fromList xs;

fun array_grow (a:'a ArrayType) (i:int) (x:'a) = grow (a, i, x);

fun array_shrink (a:'a ArrayType) (sz:int) = shrink (a,sz);

end;
end;


*}

end
