section \<open> Interface for Labelled Transition Systems \<close>

theory LTSSpec
  imports Main 
          "Collections.Iterator" Interval

begin
(* type_synonym ('V,'W,'L) lts_\<alpha> = "'L \<Rightarrow> ('V * 'W set * 'V) set" *)
  type_synonym ('V,'W,'L) lts_\<alpha> = "'L \<Rightarrow> ('V * 'W * 'V) set"
  locale lts =
    fixes \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes invar :: "'L \<Rightarrow> bool"

locale finite_lts = lts +
    assumes finite[simp, intro!]: "invar l \<Longrightarrow> finite (\<alpha> l)"

  type_synonym ('V,'W,'L) lts_empty  = "'L"
  locale lts_empty = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes empty :: "'L"
    assumes lts_empty_correct:
      "\<alpha> empty = {}"
      "invar empty"

(* type_synonym ('V,'W,'L) lts_add = "'V \<Rightarrow>'W set \<Rightarrow> 'V \<Rightarrow> 'L \<Rightarrow> 'L" *)
type_synonym ('V,'W,'L) lts_add = "'V \<Rightarrow>'W  \<Rightarrow> 'V \<Rightarrow> 'L \<Rightarrow> 'L"

  locale lts_add = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes add :: "('V,'W,'L) lts_add"
    assumes lts_add_correct:
      "invar l \<Longrightarrow> invar (add v e v' l)"
      "invar l \<Longrightarrow> \<alpha> (add v e v' l) = insert (v, e, v') (\<alpha> l)"

(* type_synonym ('V,'W,'L) lts_add_succs = "'V \<Rightarrow>'W set \<Rightarrow> 'V list \<Rightarrow> 'L \<Rightarrow> 'L" *)
type_synonym ('V,'W,'L) lts_add_succs = "'V \<Rightarrow>'W \<Rightarrow> 'V list \<Rightarrow> 'L \<Rightarrow> 'L"
  locale lts_add_succs = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes add_succs :: "('V,'W,'L) lts_add_succs"
    assumes lts_add_succs_correct:
      "invar l \<Longrightarrow> invar (add_succs v e vs l)"
      "invar l \<Longrightarrow> \<alpha> (add_succs v e vs l) = (\<alpha> l) \<union> {(v, e, v') | v'. v' \<in> set vs}"


type_synonym ('V,'W,'L) lts_delete = "'V \<Rightarrow>'W \<Rightarrow> 'V \<Rightarrow> 'L \<Rightarrow> 'L"
(* type_synonym ('V,'W,'L) lts_delete = "'V \<Rightarrow>'W set\<Rightarrow> 'V \<Rightarrow> 'L \<Rightarrow> 'L" *)
  locale lts_delete = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes delete :: "('V,'W,'L) lts_delete "
    assumes lts_delete_correct:
      "invar l \<Longrightarrow> invar (delete v e v' l)"
      "invar l \<Longrightarrow> \<alpha> (delete v e v' l) = (\<alpha> l) - {(v, e, v')}"

type_synonym ('V,'W,'\<sigma>,'L) lts_it = "'L \<Rightarrow> (('V \<times> 'W \<times> 'V),'\<sigma>) set_iterator"
(* type_synonym ('V,'W,'\<sigma>,'L) lts_it = "'L \<Rightarrow> (('V \<times> 'W set\<times> 'V),'\<sigma>) set_iterator"*)
  locale lts_iterator = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes it :: "('V,'W,'\<sigma>,'L) lts_it"
    assumes lts_it_correct:
      "invar l \<Longrightarrow> set_iterator_genord (it l) (\<alpha> l) (\<lambda>_ _. True)"

type_synonym ('V,'W,'\<sigma>,'L) lts_filter_it = 
         "('V \<Rightarrow> bool) \<Rightarrow> ('W  \<Rightarrow> bool) \<Rightarrow> ('V \<Rightarrow> bool) \<Rightarrow>
        (('V \<times> 'W \<times> 'V) \<Rightarrow> bool) \<Rightarrow> 'L \<Rightarrow> (('V \<times> 'W \<times> 'V),'\<sigma>) set_iterator"

(* type_synonym ('V,'W,'\<sigma>,'L) lts_filter_it = 
         "('V \<Rightarrow> bool) \<Rightarrow> ('W set \<Rightarrow> bool) \<Rightarrow> ('V \<Rightarrow> bool) \<Rightarrow>
        (('V \<times> 'W set\<times> 'V) \<Rightarrow> bool) \<Rightarrow> 'L \<Rightarrow> (('V \<times> 'W set\<times> 'V),'\<sigma>) set_iterator" *)


  locale lts_filter_it = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes filter_it :: "('V,'W,'\<sigma>,'L) lts_filter_it"
    assumes lts_filter_it_correct :
      "invar l \<Longrightarrow> set_iterator 
        (filter_it P_v1 P_e P_v2 P l) 
         {(v1, e, v2) . (v1, e, v2) \<in> (\<alpha> l) \<and> 
                         P_v1 v1 \<and> P_e e \<and> P_v2 v2 \<and> 
                         P (v1, e, v2)}"

type_synonym ('V,'W,'L) lts_filter = "('V \<Rightarrow> bool) \<Rightarrow> ('W  \<Rightarrow> bool) \<Rightarrow> ('V \<Rightarrow> bool) \<Rightarrow>
        (('V \<times> 'W  \<times> 'V) \<Rightarrow> bool) \<Rightarrow> 'L \<Rightarrow> 'L"
(* type_synonym ('V,'W,'L) lts_filter = "('V \<Rightarrow> bool) \<Rightarrow> ('W set \<Rightarrow> bool) \<Rightarrow> ('V \<Rightarrow> bool) \<Rightarrow>
        (('V \<times> 'W set \<times> 'V) \<Rightarrow> bool) \<Rightarrow> 'L \<Rightarrow> 'L" *)

  locale lts_filter = lts  +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>" 
    fixes filter :: "('V,'W,'L) lts_filter"
    assumes lts_filter_correct :
      "invar l \<Longrightarrow> invar (filter P_v1 P_e P_v2 P l)"
      "invar l \<Longrightarrow> \<alpha>(filter P_v1 P_e P_v2 P l) =
             {(v1, e, v2). (v1, e, v2) \<in> (\<alpha> l) \<and> P_v1 v1 \<and> 
               P_e e \<and> P_v2 v2 \<and> P (v1, e, v2)}"

  type_synonym ('V1,'W1,'L1,'V2,'W2,'L2) lts_image_filter = "
        (('V1 \<times> 'W1  \<times> 'V1) \<Rightarrow> ('V2 \<times> 'W2  \<times> 'V2)) \<Rightarrow>
        ('V1 \<Rightarrow> bool) \<Rightarrow> ('W1  \<Rightarrow> bool) \<Rightarrow> ('V1 \<Rightarrow> bool) \<Rightarrow>
        (('V1 \<times> 'W1  \<times> 'V1) \<Rightarrow> bool) \<Rightarrow> 'L1 \<Rightarrow> 'L2"

(*  type_synonym ('V1,'W1,'L1,'V2,'W2,'L2) lts_image_filter = "
        (('V1 \<times> 'W1 set \<times> 'V1) \<Rightarrow> ('V2 \<times> 'W2 set \<times> 'V2)) \<Rightarrow>
        ('V1 \<Rightarrow> bool) \<Rightarrow> ('W1 set \<Rightarrow> bool) \<Rightarrow> ('V1 \<Rightarrow> bool) \<Rightarrow>
        (('V1 \<times> 'W1 set \<times> 'V1) \<Rightarrow> bool) \<Rightarrow> 'L1 \<Rightarrow> 'L2"*) 

  locale lts_image_filter = lts \<alpha>1 invar1 + lts \<alpha>2 invar2 
    for \<alpha>1 :: "('V1,'W1,'L1) lts_\<alpha>" and invar1 and
        \<alpha>2 :: "('V2,'W2,'L2) lts_\<alpha>" and invar2 +
    fixes image_filter :: "('V1,'W1,'L1,'V2,'W2,'L2) lts_image_filter"
    assumes lts_image_filter_correct :
      "invar1 l \<Longrightarrow> invar2 (image_filter f P_v1 P_e P_v2 P l)"
      "invar1 l \<Longrightarrow> \<alpha>2(image_filter f P_v1 P_e P_v2 P l) =
         f ` {(v1, e, v2). (v1, e, v2) \<in> (\<alpha>1 l) \<and> P_v1 v1 \<and> 
               P_e e \<and> P_v2 v2 \<and> P (v1, e, v2)}"

  type_synonym ('V1,'W1,'L1,'V2,'W2,'L2) lts_image = "
        (('V1 \<times> 'W1  \<times> 'V1) \<Rightarrow> ('V2 \<times> 'W2  \<times> 'V2)) \<Rightarrow> 'L1 \<Rightarrow> 'L2"

 (* 
type_synonym ('V1,'W1,'L1,'V2,'W2,'L2) lts_image = "
        (('V1 \<times> 'W1 set \<times> 'V1) \<Rightarrow> ('V2 \<times> 'W2 set \<times> 'V2)) \<Rightarrow> 'L1 \<Rightarrow> 'L2" *)
  locale lts_image = lts \<alpha>1 invar1 + lts \<alpha>2 invar2 
    for \<alpha>1 :: "('V1,'W1,'L1) lts_\<alpha>" and invar1 and
        \<alpha>2 :: "('V2,'W2,'L2) lts_\<alpha>" and invar2 +
    fixes image :: "('V1,'W1,'L1,'V2,'W2,'L2) lts_image"
    assumes lts_image_correct :
      "invar1 l \<Longrightarrow> invar2 (image f l)"
      "invar1 l \<Longrightarrow> \<alpha>2(image f l) = f ` (\<alpha>1 l)"


  definition lts_image_filter_inj_on where
    "lts_image_filter_inj_on f A = 
         (\<forall>x\<in>A. \<forall>y\<in>A. (\<lambda>(v,e,v'). (v, e)) (f x) = (\<lambda>(v,e,v'). (v, e)) (f y) \<longrightarrow> 
               (\<lambda>(v,e,v'). (v, e)) x = (\<lambda>(v,e,v'). (v, e)) y)" 


 
  locale lts_inj_image_filter = lts \<alpha>1 invar1 + lts \<alpha>2 invar2 
    for \<alpha>1 :: "('V1,'W1,'L1) lts_\<alpha>" and invar1 and
        \<alpha>2 :: "('V2,'W2,'L2) lts_\<alpha>" and invar2 +
    fixes inj_image_filter 
    assumes lts_inj_image_filter_correct :
      "invar1 l \<Longrightarrow> lts_image_filter_inj_on f {(v1, e, v2). (v1, e, v2) \<in> (\<alpha>1 l) \<and> P_v1 v1 \<and> 
               P_e e \<and> P_v2 v2 \<and> P (v1, e, v2)} \<Longrightarrow> invar2 (inj_image_filter f P_v1 P_e P_v2 P l)"
      "invar1 l \<Longrightarrow> lts_image_filter_inj_on f {(v1, e, v2). (v1, e, v2) \<in> (\<alpha>1 l) \<and> P_v1 v1 \<and> 
               P_e e \<and> P_v2 v2 \<and> P (v1, e, v2)} \<Longrightarrow> \<alpha>2(inj_image_filter f P_v1 P_e P_v2 P l) =
         f ` {(v1, e, v2). (v1, e, v2) \<in> (\<alpha>1 l) \<and> P_v1 v1 \<and> 
               P_e e \<and> P_v2 v2 \<and> P (v1, e, v2)}"

  lemma lts_inj_image_filter_sublocale :
    "lts_image_filter \<alpha>1 invar1 \<alpha>2 invar2 image_filter \<Longrightarrow>
     lts_inj_image_filter \<alpha>1 invar1 \<alpha>2 invar2 image_filter"
  unfolding lts_image_filter_def lts_inj_image_filter_def by simp

  (* type_synonym ('V,'W,'\<sigma>,'L) lts_succ_label_it = 
    "'L \<Rightarrow> 'V \<Rightarrow> ('W set\<times>'V,'\<sigma>) set_iterator" *)

  type_synonym ('V,'W,'\<sigma>,'L) lts_succ_label_it = 
    "'L \<Rightarrow> 'V \<Rightarrow> ('W \<times>'V,'\<sigma>) set_iterator"

 locale lts_succ_label_it = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes succ_label_it :: "('V,'W,'\<sigma>,'L) lts_succ_label_it"
    assumes lts_succ_label_it_correct:
      "invar l \<Longrightarrow> set_iterator (succ_label_it l v) 
                      {(e, v') | e v'. (v, e, v') \<in> (\<alpha> l)}"

type_synonym ('V,'V_set,'W,'\<sigma>,'L) lts_connect_it = 
    "'L \<Rightarrow> 'V_set \<Rightarrow> 'V_set \<Rightarrow> 'V \<Rightarrow> ('W \<times>'V,'\<sigma>) set_iterator"
      
locale lts_connect_it = lts + 
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes \<alpha>_s :: "'V_set \<Rightarrow> 'V set"
    fixes invar1 :: "'V_set \<Rightarrow> bool"
    fixes succ_connect_it :: "('V,'V_set,'W,'\<sigma>,'L) lts_connect_it"
    assumes lts_connect_it_correct:
      "invar l1 \<Longrightarrow> invar1 B \<Longrightarrow> invar1 C \<Longrightarrow> set_iterator (succ_connect_it l1 B C v) 
                      {(e, v') | e v' v''. (v, e, v'') \<in> (\<alpha> l1) \<and> 
                                            v'' \<in> \<alpha>_s B \<and> v' \<in> \<alpha>_s C}"
    
    

type_synonym ('V,'W,'\<sigma>,'L) lts_pre_label_it =  "'L \<Rightarrow> 'V \<Rightarrow> ('V \<times>'W,'\<sigma>) set_iterator"
  locale lts_pre_label_it = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes pre_label_it :: "('V,'W,'\<sigma>,'L) lts_pre_label_it"
    assumes lts_pre_label_it_correct:
      "invar l \<Longrightarrow> set_iterator (pre_label_it l v') 
             {(v, e) | v e. (v, e, v') \<in> (\<alpha> l)}"

  type_synonym ('V,'W,'\<sigma>,'L) lts_succ_it = 
    "'L \<Rightarrow> 'V \<Rightarrow> 'W  \<Rightarrow> ('W \<times> 'V,'\<sigma>) set_iterator"
(* type_synonym ('V,'W,'\<sigma>,'L) lts_succ_it = 
    "'L \<Rightarrow> 'V \<Rightarrow> 'W set \<Rightarrow> ('W set \<times> 'V,'\<sigma>) set_iterator" *)
  locale lts_succ_it = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes succ_it :: "('V,'W,'\<sigma>,'L) lts_succ_it"
    assumes lts_succ_it_correct:
      "invar l \<Longrightarrow> set_iterator (succ_it l v e) 
                    {(e, v')| v' e. (v, e, v') \<in> (\<alpha> l)}"

  type_synonym ('V,'W,'\<sigma>,'L) lts_pre_it =  
     "'L \<Rightarrow> 'V \<Rightarrow> 'W  \<Rightarrow> ('V,'\<sigma>) set_iterator"
(*
 type_synonym ('V,'W,'\<sigma>,'L) lts_pre_it =  
     "'L \<Rightarrow> 'V \<Rightarrow> 'W set \<Rightarrow> ('V,'\<sigma>) set_iterator"
*)

  locale lts_pre_it = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes pre_it :: "('V,'W,'\<sigma>,'L) lts_pre_it"
    assumes lts_pre_it_correct:
      "invar l \<Longrightarrow> set_iterator (pre_it l v' e) {v | v. (v, e, v') \<in> (\<alpha> l)}"

type_synonym ('V,'W,'L) lts_succ_bquant = 
            "'L \<Rightarrow> ('W \<times> 'V \<Rightarrow> bool) \<Rightarrow> 'V \<Rightarrow> 'W  \<Rightarrow> bool"

(* type_synonym ('V,'W,'L) lts_succ_bquant = 
            "'L \<Rightarrow> ('W set \<times> 'V \<Rightarrow> bool) \<Rightarrow> 'V \<Rightarrow> 'W set \<Rightarrow> bool"
 *)

  locale lts_succ_ball = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes succ_ball :: "('V,'W,'L) lts_succ_bquant"
    assumes lts_succ_ball_correct:
      "invar l \<Longrightarrow> succ_ball l P v e \<longleftrightarrow> 
                    (\<forall> e v'. (v, e, v') \<in> (\<alpha> l) \<longrightarrow> P (e, v'))"

type_synonym ('V,'E,'W,'\<sigma>,'L) lts_succ_it_bex = 
    "('E \<Rightarrow> 'W \<Rightarrow> bool) \<Rightarrow> 'L \<Rightarrow> 'V \<Rightarrow> 'E \<Rightarrow> ('V,'\<sigma>) set_iterator"

(* type_synonym ('V,'W,'\<sigma>,'L) lts_succ_it_bex = 
    "'L \<Rightarrow> 'V \<Rightarrow> 'W \<Rightarrow> ('V,'\<sigma>) set_iterator" *)

locale lts_succ_it_bex = lts +
  constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
  fixes sat :: "'E \<Rightarrow> 'W \<Rightarrow> bool"
  fixes succ_it :: "('V,'E,'W,'\<sigma>,'L) lts_succ_it_bex"
  assumes lts_succ_it_bex_correct:
      "invar l \<Longrightarrow> set_iterator (succ_it sat l v a) 
                    {v'| v' e. (v, e, v') \<in> (\<alpha> l) \<and> (sat a e)}"

type_synonym ('V,'W,'E,'L) lts_succ_bex = 
            "('E \<Rightarrow> 'W \<Rightarrow> bool) \<Rightarrow> 'L \<Rightarrow> ('V \<Rightarrow> bool) \<Rightarrow> 'V \<Rightarrow> 'E \<Rightarrow> bool"

(* type_synonym ('V,'W,'L) lts_succ_bex = 
            "'L \<Rightarrow> ('V \<Rightarrow> bool) \<Rightarrow> 'V \<Rightarrow> 'W \<Rightarrow> bool" *)

locale lts_succ_bex = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes sat :: "'E \<Rightarrow> 'W \<Rightarrow> bool"
    fixes succ_bex :: "('V,'W,'E,'L) lts_succ_bex"
    assumes lts_succ_bex_correct:
      "invar l \<Longrightarrow> succ_bex sat l P v a \<longleftrightarrow> 
           (\<exists>v' e. (v, e, v') \<in> (\<alpha> l) \<and> (sat a e) \<and> P v')"

type_synonym ('V,'W,'L) lts_pre_bquant = "'L \<Rightarrow> ('V \<Rightarrow> bool) \<Rightarrow> 'V \<Rightarrow> 'W \<Rightarrow> bool"
(* type_synonym ('V,'W,'L) lts_pre_bquant = "'L \<Rightarrow> ('V \<Rightarrow> bool) \<Rightarrow> 'V \<Rightarrow> 'W set \<Rightarrow> bool" *)
  locale lts_pre_ball = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes pre_ball :: "('V,'W,'L) lts_pre_bquant"
    assumes lts_pre_ball_correct:
      "invar l \<Longrightarrow> pre_ball l P v' e \<longleftrightarrow> (\<forall>v. (v, e, v') \<in> (\<alpha> l) \<longrightarrow> P v)"

  locale lts_pre_bex = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes pre_bex :: "('V,'W,'L) lts_pre_bquant"
    assumes lts_pre_bex_correct:
      "invar l \<Longrightarrow> pre_bex l P v' e \<longleftrightarrow> (\<exists>v. (v, e, v') \<in> (\<alpha> l) \<and> P v)"

type_synonym ('V,'W,'L) lts_from_list = "('V \<times> 'W \<times> 'V) list \<Rightarrow> 'L"
(* type_synonym ('V,'W,'L) lts_from_list = "('V \<times> 'W set \<times> 'V) list \<Rightarrow> 'L" *)

  locale lts_from_list = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes from_list :: "('V,'W,'L) lts_from_list"
    assumes lts_from_list_correct:
      "invar (from_list ll)"
      "\<alpha> (from_list ll) = set ll"

type_synonym ('V,'W,'L) lts_to_collect_list = "'L \<Rightarrow> ('V \<times> 'W  \<times> 'V) list"
  locale lts_to_collect_list = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes to_collect_list :: "('V,'W,'L) lts_to_collect_list"
    assumes lts_to_collect_list_correct:
      "invar l \<Longrightarrow> \<alpha> l = {(v, es, v'). (v, es, v') \<in> set (to_collect_list l)}"
     (* "invar l \<Longrightarrow> distinct (map (\<lambda>vesv'. (fst vesv', snd (snd vesv'))) (to_collect_list l))"
*)


  
type_synonym ('V,'W,'L) lts_to_list = "'L \<Rightarrow> ('V \<times> 'W \<times> 'V) list"
(*  type_synonym ('V,'W,'L) lts_to_list = "'L \<Rightarrow> ('V \<times> 'W set \<times> 'V) list" *)
  locale lts_to_list = lts +
    constrains \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    fixes to_list :: "('V,'W,'L) lts_to_list"
    assumes lts_to_list_correct:
      "invar l \<Longrightarrow> set (to_list l) = \<alpha> l"
      "invar l \<Longrightarrow> distinct (to_list l)"


  type_synonym ('V,'W,'L1,'L2) lts_reverse = "'L1 \<Rightarrow> 'L2"
  locale lts_reverse = lts \<alpha>1 invar1 + lts \<alpha>2 invar2  
    for \<alpha>1 :: "('V,'W,'L1) lts_\<alpha>" and invar1 and
        \<alpha>2 :: "('V,'W,'L2) lts_\<alpha>" and invar2 +
    fixes reverse :: "('V,'W,'L1,'L2) lts_reverse"
    assumes lts_reverse_correct:
      "invar1 l \<Longrightarrow> invar2 (reverse l)"
      "invar1 l \<Longrightarrow> \<alpha>2 (reverse l) = {(v', e, v) | v e v'. (v, e, v') \<in> \<alpha>1 l}"

  section \<open> Record Based Interface \<close>
  record ('V,'W,'E,'L) common_lts_ops =
    clts_op_\<alpha> :: "('V,'W,'L) lts_\<alpha>"
    clts_op_invar :: "'L \<Rightarrow> bool"
    clts_op_empty :: "('V,'W,'L) lts_empty"
    clts_op_add :: "('V,'W,'L) lts_add"
    clts_op_add_succs :: "('V,'W,'L) lts_add_succs"
    clts_op_delete :: "('V,'W,'L) lts_delete"
    clts_op_to_list :: "('V,'W,'L) lts_to_list"
    clts_op_to_collect_list :: "('V,'W,'L) lts_to_collect_list"
    clts_op_succ_ball :: "('V,'W,'L) lts_succ_bquant"
    clts_op_succ_bex :: "('V,'W,'E,'L) lts_succ_bex"
(*
    clts_op_pre_ball :: "('V,'W,'L) lts_pre_bquant"
    clts_op_pre_bex :: "('V,'W,'L) lts_pre_bquant"
    clts_op_to_list :: "('V,'W,'L) lts_to_list" *)
    clts_op_from_list :: "('V,'W,'L) lts_from_list"
    (*clts_op_is_weak_det :: "'L \<Rightarrow> bool" *)
    clts_op_image_filter :: "('V,'W,'L,'V,'W,'L) lts_image_filter"
    clts_op_image :: "('V,'W,'L,'V,'W,'L) lts_image"
    clts_op_filter :: "('V,'W,'L) lts_filter"
    

  record ('V,'W, 'E, 'L) lts_ops = "('V, 'W, 'E, 'L) common_lts_ops"  +
    lts_op_reverse :: "('V,'W,'L,'L) lts_reverse"

(*
  record ('V,'W,'L) dlts_ops = "('V, 'W, 'L) common_lts_ops"  +
    dlts_op_succ :: "('V,'W,'L) dlts_succ"
*)

  locale StdCommonLTSDefs =
    fixes ops :: "('V,'W,'E,'L,'m) common_lts_ops_scheme"
     and  sat :: "'E \<Rightarrow> 'W \<Rightarrow> bool"
  begin
    abbreviation \<alpha> where "\<alpha> \<equiv> clts_op_\<alpha> ops"
    abbreviation invar where "invar \<equiv> clts_op_invar ops"
    abbreviation empty where "empty \<equiv> clts_op_empty ops"
    abbreviation add where "add \<equiv> clts_op_add ops"
    abbreviation add_succs where "add_succs \<equiv> clts_op_add_succs ops"
    abbreviation delete where "delete \<equiv> clts_op_delete ops"
    abbreviation from_list where "from_list \<equiv> clts_op_from_list ops"
(*  abbreviation from_collect_list where "from_collect_list \<equiv> clts_op_from_collect_list ops" 
    abbreviation to_list where "to_list \<equiv> clts_op_to_list ops" *)
    abbreviation to_collect_list where "to_collect_list \<equiv> clts_op_to_collect_list ops" 
    abbreviation succ_ball where "succ_ball \<equiv> clts_op_succ_ball ops"
    abbreviation succ_bex where "succ_bex \<equiv> clts_op_succ_bex ops"
(*
    abbreviation pre_ball where "pre_ball \<equiv> clts_op_pre_ball ops"
    abbreviation pre_bex where "pre_bex \<equiv> clts_op_pre_bex ops" 
    abbreviation is_weak_det where "is_weak_det \<equiv> clts_op_is_weak_det ops"
    *)
    abbreviation image_filter where "image_filter \<equiv> clts_op_image_filter ops"
    abbreviation filter where "filter \<equiv> clts_op_filter ops"
    abbreviation image where "image \<equiv> clts_op_image ops"
  end

  locale StdLTSDefs = StdCommonLTSDefs +
    constrains ops :: "('V,'W,'E,'L,'m) lts_ops_scheme"
  begin
    abbreviation reverse where "reverse \<equiv> lts_op_reverse ops"
end

(*
  locale StdDLTSDefs = StdCommonLTSDefs +
    constrains ops :: "('V,'W,'L,'m) dlts_ops_scheme"
  begin
    abbreviation succ where "succ \<equiv> dlts_op_succ ops"
  end
*)

  locale StdCommonLTS = StdCommonLTSDefs +
    finite_lts \<alpha> invar +
    lts_empty \<alpha> invar empty +
(*    lts_to_list \<alpha> invar to_list + *)
    lts_to_collect_list \<alpha> invar to_collect_list + 
    lts_succ_ball \<alpha> invar succ_ball +
 (*   lts_pre_ball \<alpha> invar pre_ball + *)
    lts_succ_bex \<alpha> invar sat succ_bex   +
 (*   lts_pre_bex \<alpha> invar pre_bex + *)
    lts_delete \<alpha> invar delete +
    lts_filter \<alpha> invar filter (*  +
    lts_inj_image_filter \<alpha> invar  \<alpha> invar image_filter *)
  begin
    lemmas correct_common = lts_empty_correct  
    (*   lts_to_list_correct  *)
       lts_succ_ball_correct (* lts_pre_ball_correct *)
       lts_succ_bex_correct (* lts_pre_bex_correct *) 
       lts_delete_correct 
       (* lts_inj_image_filter_correct *) lts_filter_correct 
  end

 locale StdLTS = StdLTSDefs +
    finite_lts \<alpha> invar +
    lts_empty \<alpha> invar empty +
    (* lts_to_list \<alpha> invar to_list + *)
    lts_to_collect_list \<alpha> invar to_collect_list + 
    lts_succ_ball \<alpha> invar succ_ball +
(*    lts_pre_ball \<alpha> invar pre_ball + *)
    lts_succ_bex \<alpha> invar sat succ_bex +
(*    lts_pre_bex \<alpha> invar pre_bex + *)
    lts_add \<alpha> invar add +
    lts_add_succs \<alpha> invar add_succs +
    lts_delete \<alpha> invar delete +
    lts_from_list \<alpha> invar from_list +
(*  lts_from_collect_list \<alpha> invar from_collect_list + 
    lts_is_weak_det \<alpha> invar is_weak_det +  *)
    lts_filter \<alpha> invar filter +
    lts_image_filter \<alpha> invar \<alpha> invar image_filter +
    lts_image \<alpha> invar \<alpha> invar image +
    lts_reverse \<alpha> invar \<alpha> invar reverse
begin

lemmas correct =
       lts_empty_correct  
       (* lts_to_list_correct *) 
       lts_succ_ball_correct 
       (* lts_pre_ball_correct *)
       lts_succ_bex_correct 
       (* lts_pre_bex_correct *)
       lts_add_correct 
       lts_add_succs_correct 
       lts_delete_correct 
       lts_from_list_correct
       lts_reverse_correct 
       (* lts_from_collect_list_correct *)
       (* lts_is_weak_det_correct  
         *) 
       lts_image_filter_correct
       lts_filter_correct 
       lts_image_correct
  end

  lemma StdLTS_sublocale : "StdLTS ops sat \<Longrightarrow> StdCommonLTS ops sat"
    unfolding StdLTS_def StdCommonLTS_def
    by (simp add: (* lts_add_sublocale 
                  lts_add_succs_sublocale  
                  lts_from_list_sublocale lts_from_collect_list_sublocale *)
                  lts_inj_image_filter_sublocale (* dlts_image_filter_sublocale 
                  dlts_image_sublocale *)
                  )

  sublocale StdLTS < StdCommonLTS using StdLTS_sublocale [OF StdLTS_axioms] .


end
