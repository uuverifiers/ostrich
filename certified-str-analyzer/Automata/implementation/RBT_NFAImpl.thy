
section \<open> LTS by Hashmaps \<close>

theory RBT_NFAImpl 

imports  "Collections.Collections" 
          RBT_LTSImpl interval 
          NFAByLTS_Interval
begin

interpretation rs_nfa_defs: nfa_dfa_by_lts_interval_defs rs_ops rs_ops
                            rs_ops rs_lts_ops rs_lts_ops
  by intro_locales

type_synonym ('a,'b) rs_nfa = 
   "('a, unit) RBT.rbt \<times>
    ('a, ('b \<times> 'b, ('a, unit) RBT.rbt) RBT.rbt) RBT.rbt \<times>
    ('a, unit) RBT.rbt \<times> ('a, unit) RBT.rbt"


definition rs_nfa_\<alpha> :: "('q::{linorder, NFA_states},'a::linorder) 
      rs_nfa \<Rightarrow> ('q, 'a) NFA_rec" 
  where "rs_nfa_\<alpha> \<equiv> rs_nfa_defs.nfa_dfa_\<alpha>"

definition "rs_nfa_invar \<equiv> rs_nfa_defs.nfa_dfa_invar"
definition "rs_nfa_construct_interval \<equiv> rs_nfa_defs.nfa_construct_interval"
definition "rs_nfa_construct_reachable_interval \<equiv> 
            rs_nfa_defs.nfa_construct_reachable_interval rm_ops"

definition "rs_nfa_destruct \<equiv> rs_nfa_defs.nfa_destruct"

definition "rs_nfa_bool_comb_gen \<equiv> rs_nfa_defs.bool_comb_gen_impl rm_ops  
   rs_lts_succ_label_it rs_lts_succ_it" 

definition "rs_nfa_bool_comb \<equiv> rs_nfa_defs.bool_comb_impl rm_ops  
   rs_lts_succ_label_it rs_lts_succ_it" 

definition "rs_nfa_construct_reachable \<equiv> 
            rs_nfa_defs.nfa_construct_reachable rm_ops rs_lts_succ_label_it"

definition "rs_nfa_concate \<equiv> 
      rs_nfa_defs.nfa_concat_impl 
      rm_ops rs_lts_succ_label_it 
      rs_lts_succ_label_it rs_lts_connect_it" 

definition "rs_nfa_concate_rename \<equiv> 
      rs_nfa_defs.nfa_concat_rename_impl 
      rm_ops 
      rs_lts_succ_label_it 
      rs_lts_succ_label_it 
      rs_lts_connect_it
      (\<lambda> f S. rs.iteratei S (\<lambda> _. True) (\<lambda> b S'. rs.ins (f b) S') (rs.empty ()))
      rs_lts_image" 
  

                                        
(* 
definition "rs_dfa_construct_reachable_fun \<equiv> NFAGA.construct_by_fun rs_dfa_construct_reachable rs_iteratei"
definition "rs_nfa_normalise \<equiv> rs_nfa_defs.normalise_impl rm_ops rs_lts_succ_label_it rs_dlts_succ_label_it"
definition "rs_nfa_reverse \<equiv> rs_nfa_defs.reverse_impl rs_lts_dlts_reverse"
definition "rs_nfa_complement \<equiv> rs_nfa_defs.complement_impl"
definition "rs_nfa_is_deterministic \<equiv> rs_nfa_defs.is_deterministic_impl rs_lts_succ_it"
definition "rs_nfa_bool_comb_gen \<equiv> rs_nfa_defs.bool_comb_gen_impl rm_ops  
   rs_lts_succ_label_it rs_lts_succ_it rs_dlts_succ_label_it rs_dlts_succ_it
   rs_dlts_succ_label_it rs_dlts_succ_it" 
definition "rs_nfa_bool_comb \<equiv> rs_nfa_defs.bool_comb_impl rm_ops  
   rs_lts_succ_label_it rs_lts_succ_it rs_dlts_succ_label_it rs_dlts_succ_it
   rs_dlts_succ_label_it rs_dlts_succ_it" 
 definition "rs_nfa_right_quotient_lists \<equiv> rs_nfa_defs.right_quotient_lists_impl
   rm_ops rs_lts_filter_it rs_dlts_filter_it"
definition "rs_nfa_determinise \<equiv> rs_nfa_defs.determinise_impl rm_ops rm_ops
  rs_iteratei rs_iteratei rs_iteratei rs_iteratei rs_lts_succ_it rs_dlts_succ_it"
definition "rs_nfa_Brzozowski \<equiv> NFAGA.Brzozowski_impl rs_nfa_reverse rs_nfa_determinise"
definition "rs_nfa_Hopcroft \<equiv> nfa_dfa_by_lts_defs.Hopcroft_minimise_impl rs_ops rs_ops rm_ops rm_ops rs_iteratei
   rs_image rs_lts_reverse rs_lts_dlts_reverse rs_lts_succ_it rs_image
   rs_dlts_lts_image rs_dlts_image"
definition "rs_nfa_Hopcroft_NFA \<equiv> \<lambda>A. rs_nfa_Hopcroft (rs_nfa_determinise A)"
*)

lemmas rs_nfa_defs =
  rs_nfa_\<alpha>_def
  rs_nfa_invar_def 
  rs_nfa_construct_interval_def
  rs_nfa_destruct_def
  rs_nfa_construct_reachable_interval_def
  rs_nfa_bool_comb_gen_def
  rs_nfa_bool_comb_def
  rs_nfa_concate_def
  rs_nfa_concate_rename_def
  rs_nfa_construct_reachable_def
  (* rs_dfa_construct_def
  rs_nfa_destruct_def
  rs_nfa_destruct_simple_def
  rs_nfa_states_no_def
  rs_nfa_labels_no_def
  rs_nfa_trans_no_def
  rs_nfa_initial_no_def
  rs_nfa_final_no_def
  rs_nfa_accept_def
  rs_nfa_rename_labels_gen_def
  rs_nfa_rename_labels_def
  rs_nfa_construct_reachable_def
  rs_dfa_construct_reachable_def
  rs_dfa_construct_reachable_fun_def
  rs_nfa_normalise_def
  rs_nfa_reverse_def
  rs_nfa_complement_def
  rs_nfa_is_deterministic_def
  rs_nfa_bool_comb_gen_def
  rs_nfa_bool_comb_def
  rs_nfa_right_quotient_lists_def
  rs_nfa_determinise_def
  rs_nfa_Brzozowski_def
  rs_nfa_Hopcroft_def
  rs_nfa_Hopcroft_NFA_def *)


lemmas rs_nfa_impl = rs_nfa_defs.automaton_by_lts_correct [folded rs_nfa_defs]
interpretation rs_nfa: nfa rs_nfa_\<alpha> rs_nfa_invar  
  using rs_nfa_impl .

lemmas rs_nfa_construct_interval_code [code] = 
        rs_nfa_defs.nfa_construct_interval_code [folded rs_nfa_defs]
lemmas rs_nfa_construct_interval_impl = 
        rs_nfa_defs.nfa_construct_interval_correct[folded rs_nfa_defs]
interpretation rs_nfa: nfa_from_list_interval 
              rs_nfa_\<alpha> rs_nfa_invar rs_nfa_construct_interval
  using rs_nfa_construct_interval_impl .
  
lemmas rs_nfa_construct_reachable_interval_code [code] = 
      rs_nfa_defs.nfa_construct_reachable_interval_code 
  [of rm_ops, folded rs_nfa_defs]
lemmas rs_nfa_construct_reachable_interval_impl = 
      rs_nfa_defs.nfa_construct_reachable_interval_correct
   [OF rm.StdMap_axioms, folded rs_nfa_defs]
lemmas rs_nfa_construct_reachable_interval_no_enc_impl = 
   nfa_construct_no_enc_default [OF rs_nfa_construct_reachable_interval_impl]

lemmas rs_nfa_construct_reachable_prod_interval_code [code] = 
      rs_nfa_defs.nfa_construct_reachable_prod_interval_code 
  [of rm_ops, folded rs_nfa_defs]
lemmas rs_nfa_construct_reachable_prod_interval_impl = 
      rs_nfa_defs.nfa_construct_reachable_interval_correct
   [OF rm.StdMap_axioms, folded rs_nfa_defs]
lemmas rs_nfa_construct_reachable_prod_interval_no_enc_impl = 
   nfa_construct_no_enc_default [OF rs_nfa_construct_reachable_prod_interval_impl]

lemmas rs_nfa_bool_comb_gen_code [code] = 
    rs_nfa_defs.bool_comb_gen_impl_code [of rm_ops
rs_lts_succ_label_it rs_lts_succ_it, folded rs_nfa_defs]

lemmas rs_nfa_bool_comb_gen_impl  = rs_nfa_defs.bool_comb_gen_impl_correct
   [unfolded rs_lts_ops_unfold,
    OF rm.StdMap_axioms rs_lts_succ_label_it_impl rs_lts_succ_it_impl, 
        folded rs_nfa_defs]

lemmas rs_nfa_destruct_code [code] = 
      rs_nfa_defs.nfa_destruct_code [folded rs_nfa_defs]


lemmas rs_nfa_bool_comb_code [code] = rs_nfa_defs.bool_comb_impl_code [of rm_ops
rs_lts_succ_label_it rs_lts_succ_it, folded rs_nfa_defs]
lemmas rs_nfa_bool_comb_impl = rs_nfa_defs.bool_comb_impl_correct
   [unfolded rs_lts_ops_unfold,
    OF rm.StdMap_axioms rs_lts_succ_label_it_impl rs_lts_succ_it_impl, 
    folded rs_nfa_defs]

lemmas  rs_lts_connect_it_impl_unfold = 
    rs_lts_connect_it_impl[unfolded rs_lts_defs.s3_\<alpha>_def rs_lts_defs.s3_invar_def]

lemmas rs_nfa_concate_code [code] = rs_nfa_defs.nfa_concat_impl_code [of rm_ops
rs_lts_succ_label_it rs_lts_succ_label_it rs_lts_connect_it, folded rs_nfa_defs]

lemmas rs_nfa_construct_reachable_code [code] = 
       rs_nfa_defs.nfa_construct_reachable_code[of rm_ops rs_lts_succ_label_it,
       folded rs_nfa_defs]

lemmas rs_nfa_concate_rename_code [code] = 
  rs_nfa_defs.nfa_concat_impl_rename_code [of rm_ops
rs_lts_succ_label_it rs_lts_succ_label_it rs_lts_connect_it
  "(\<lambda> f S. rs.iteratei S (\<lambda> _. True) (\<lambda> b S'. rs.ins (f b) S') (rs.empty ()))"
  rs_lts_image, 
  folded rs_nfa_defs]

lemmas rs_nfa_concate_impl = rs_nfa_defs.nfa_concat_impl_correct
   [unfolded rs_lts_ops_unfold,
    OF rm.StdMap_axioms rs_lts_succ_label_it_impl rs_lts_succ_label_it_impl
        rs_lts_connect_it_impl_unfold, 
    folded rs_nfa_defs]


(*
interpretation rs_nfa: 
 nfa_bool_comb_same rs_nfa_\<alpha> rs_nfa_invar rs_nfa_bool_comb  
   using rs_nfa_bool_comb_impl .

lemmas rs_nfa_bool_comb_gen_code [code] = rs_nfa_defs.bool_comb_gen_impl_code [of rm_ops
rs_lts_succ_label_it rs_lts_succ_it rs_dlts_succ_label_it rs_dlts_succ_it
   rs_dlts_succ_label_it rs_dlts_succ_it, folded rs_nfa_defs]
lemmas rs_nfa_bool_comb_gen_impl  = rs_nfa_defs.bool_comb_gen_impl_correct
   [unfolded rs_lts_ops_unfold rs_dlts_ops_unfold rs_ops_unfold,
    OF rmr.StdMap_axioms rs_lts_succ_label_it_impl rs_lts_succ_it_impl
       rs_dlts_succ_label_it_impl rs_dlts_succ_it_impl
        rs_dlts_succ_label_it_impl rs_dlts_succ_it_impl, folded rs_nfa_defs]

lemmas rs_nfa_bool_comb_code [code] = rs_nfa_defs.bool_comb_impl_code [of rm_ops
rs_lts_succ_label_it rs_lts_succ_it rs_dlts_succ_label_it rs_dlts_succ_it
   rs_dlts_succ_label_it rs_dlts_succ_it, folded rs_nfa_defs]
lemmas rs_nfa_bool_comb_impl = rs_nfa_defs.bool_comb_impl_correct
   [unfolded rs_lts_ops_unfold rs_dlts_ops_unfold rs_ops_unfold,
    OF rmr.StdMap_axioms rs_lts_succ_label_it_impl rs_lts_succ_it_impl
       rs_dlts_succ_label_it_impl rs_dlts_succ_it_impl
        rs_dlts_succ_label_it_impl rs_dlts_succ_it_impl, folded rs_nfa_defs]
interpretation rs_nfa!: 
 nfa_bool_comb_same rs_nfa_\<alpha> rs_nfa_invar rs_nfa_bool_comb  
   using rs_nfa_bool_comb_impl .

lemmas rs_nfa_right_quotient_lists_code [code] = rs_nfa_defs.right_quotient_lists_impl_code [of rm_ops
rs_lts_filter_it rs_dlts_filter_it, folded rs_nfa_defs]
lemmas rs_nfa_right_quotient_lists_impl = rs_nfa_defs.right_quotient_lists_impl_correct
   [unfolded rs_lts_ops_unfold rs_dlts_ops_unfold rs_ops_unfold,
    OF rmr.StdMap_axioms rs_lts_filter_it_impl rs_dlts_filter_it_impl, folded rs_nfa_defs]
interpretation rs_nfa!: 
 nfa_right_quotient_lists rs_nfa_\<alpha> rs_nfa_invar rs_nfa_\<alpha> rs_nfa_invar rs_nfa_right_quotient_lists   
   using rs_nfa_right_quotient_lists_impl .

lemmas rs_nfa_determinise_code [code] =  rs_nfa_defs.determinise_impl_code [of rm_ops rm_ops
  rs_iteratei rs_iteratei rs_iteratei rs_iteratei rs_lts_succ_it rs_dlts_succ_it , 
  folded rs_nfa_defs, unfolded rs_nfa_defs.NFA_construct_reachable_impl_code_def]
lemmas rs_nfa_determinise_impl = rs_nfa_defs.determinise_impl_correct
   [unfolded rs_lts_ops_unfold rs_dlts_ops_unfold rs_ops_unfold,
    OF rs_iteratei_impl rs_iteratei_impl rs_iteratei_impl rs_iteratei_impl
       rs_lts_succ_it_impl rs_dlts_succ_it_impl rmr.StdMap_axioms rmr.StdMap_axioms, folded rs_nfa_defs]
interpretation rs_nfa!: 
 nfa_determinise rs_nfa_\<alpha> rs_nfa_invar rs_nfa_\<alpha> rs_nfa_invar rs_nfa_determinise    
   using rs_nfa_determinise_impl .


lemmas rs_nfa_Brzozowski_code [code] = NFAGA.Brzozowski_impl_def [of rs_nfa_reverse rs_nfa_determinise, folded rs_nfa_defs]
lemmas rs_nfa_Brzozowski_impl = NFAGA.Brzozowski_impl_correct [OF rs_nfa_reverse_impl rs_nfa_determinise_impl, folded rs_nfa_defs]
interpretation rs_nfa_min_Brzozowski!: 
 nfa_minimise rs_nfa_\<alpha> rs_nfa_invar rs_nfa_\<alpha> rs_nfa_invar rs_nfa_Brzozowski     
   using rs_nfa_Brzozowski_impl .


lemmas rs_nfa_Hopcroft_code [code] = rs_nfa_defs.Hopcroft_minimise_impl_code
[of rm_ops rm_ops rs_iteratei 
   rs_image rs_lts_reverse rs_lts_dlts_reverse rs_lts_succ_it rs_image
   rs_dlts_lts_image rs_dlts_image, folded rs_nfa_defs]
lemmas rs_nfa_Hopcroft_impl = rs_nfa_defs.Hopcroft_minimise_impl_correct [OF rsr.StdSet_axioms
  rmr.StdMap_axioms rmr.StdMap_axioms, unfolded rs_ops_unfold rs_lts_ops_unfold rs_dlts_ops_unfold,
  OF rs_iteratei_impl  rs_image_impl rs_image_impl
     rs_dlts_lts_image_impl rs_dlts_image_impl rs_lts_succ_it_impl 
     rs_lts_reverse_impl rs_lts_dlts_reverse_impl, folded rs_nfa_defs]
interpretation rs_nfa_min_Hopcroft!: 
 dfa_minimise rs_nfa_\<alpha> rs_nfa_invar rs_nfa_\<alpha> rs_nfa_invar rs_nfa_Hopcroft
   using rs_nfa_Hopcroft_impl .

lemmas rs_nfa_Hopcroft_NFA_code [code] = rs_nfa_Hopcroft_NFA_def
lemmas rs_nfa_Hopcroft_NFA_impl = NFAGA_minimisation_with_determinisation [OF rs_nfa_determinise_impl rs_nfa_Hopcroft_impl,
unfolded o_def, folded rs_nfa_defs]
interpretation rs_nfa_min_Hopcroft_NFA!: 
 nfa_minimise rs_nfa_\<alpha> rs_nfa_invar rs_nfa_\<alpha> rs_nfa_invar rs_nfa_Hopcroft_NFA
   using rs_nfa_Hopcroft_NFA_impl .
*)

definition rs_nfa_ops :: 
    "('q::{linorder, NFA_states},'a::{linorder},('q,'a) rs_nfa) nfa_ops" where
   "rs_nfa_ops \<equiv> \<lparr>
    nfa_op_\<alpha> = rs_nfa_\<alpha>,
    nfa_op_invar = rs_nfa_invar,
    nfa_op_nfa_from_list_interval = rs_nfa_construct_interval,
    nfa_op_bool_comb = rs_nfa_bool_comb,
    nfa_op_concate = rs_nfa_concate
 \<rparr>" 

(*
    nfa_op_dfa_from_list = rs_dfa_construct,
    nfa_op_to_list = rs_nfa_destruct,
    nfa_op_to_list_simple = rs_nfa_destruct_simple,
    nfa_op_states_no = rs_nfa_states_no,
    nfa_op_labels_no = rs_nfa_labels_no,
    nfa_op_trans_no = rs_nfa_trans_no,
    nfa_op_initial_no = rs_nfa_initial_no,
    nfa_op_final_no = rs_nfa_final_no,
    nfa_op_accept = rs_nfa_accept,
    nfa_op_is_deterministic = rs_nfa_is_deterministic,
    nfa_op_rename_labels = rs_nfa_rename_labels,
    nfa_op_normalise = rs_nfa_normalise,
    nfa_op_reverse = rs_nfa_reverse,
    nfa_op_complement = rs_nfa_complement,
    
    nfa_op_determinise = rs_nfa_determinise,
    nfa_op_minimise_Brzozowski = rs_nfa_Brzozowski,
    nfa_op_minimise_Hopcroft = rs_nfa_Hopcroft,
    nfa_op_minimise_Hopcroft_NFA = rs_nfa_Hopcroft_NFA,
    nfa_op_right_quotient_lists = rs_nfa_right_quotient_lists *)

lemma rs_nfa_ops_unfold[code_unfold] :
   "nfa_op_\<alpha> rs_nfa_ops = rs_nfa_\<alpha>"
   "nfa_op_invar rs_nfa_ops = rs_nfa_invar"
   "nfa_op_nfa_from_list_interval rs_nfa_ops = rs_nfa_construct_interval"
   "nfa_op_bool_comb rs_nfa_ops = rs_nfa_bool_comb"
   "nfa_op_concate rs_nfa_ops = rs_nfa_concate"
(*  "nfa_op_dfa_from_list rs_nfa_ops = rs_dfa_construct"
   "nfa_op_to_list rs_nfa_ops = rs_nfa_destruct"
   "nfa_op_to_list_simple rs_nfa_ops = rs_nfa_destruct_simple"
   "nfa_op_states_no rs_nfa_ops = rs_nfa_states_no"
   "nfa_op_labels_no rs_nfa_ops = rs_nfa_labels_no"
   "nfa_op_trans_no rs_nfa_ops = rs_nfa_trans_no"
   "nfa_op_initial_no rs_nfa_ops = rs_nfa_initial_no"
   "nfa_op_final_no rs_nfa_ops = rs_nfa_final_no"
   "nfa_op_accept rs_nfa_ops = rs_nfa_accept"
   "nfa_op_is_deterministic rs_nfa_ops = rs_nfa_is_deterministic"
   "nfa_op_rename_labels rs_nfa_ops = rs_nfa_rename_labels"
   "nfa_op_normalise rs_nfa_ops = rs_nfa_normalise"
   "nfa_op_reverse rs_nfa_ops = rs_nfa_reverse"
   "nfa_op_complement rs_nfa_ops = rs_nfa_complement"
   "nfa_op_determinise rs_nfa_ops = rs_nfa_determinise"
   "nfa_op_minimise_Brzozowski rs_nfa_ops = rs_nfa_Brzozowski"
   "nfa_op_minimise_Hopcroft rs_nfa_ops = rs_nfa_Hopcroft"
   "nfa_op_minimise_Hopcroft_NFA rs_nfa_ops = rs_nfa_Hopcroft_NFA"
   "nfa_op_right_quotient_lists rs_nfa_ops = rs_nfa_right_quotient_lists" *)
  by (simp_all add: rs_nfa_ops_def)

lemmas rs_nfa_impls =
  rs_nfa_impl 
  rs_nfa_construct_interval_impl
  rs_nfa_bool_comb_gen_impl
  rs_nfa_bool_comb_impl
  rs_nfa_concate_impl
(*
  rs_dfa_construct_impl
  rs_nfa_destruct_impl
  rs_nfa_destruct_simple_impl
  rs_nfa_stats_impl
  rs_nfa_accept_impl
  rs_nfa_is_deterministic_impl
  rs_nfa_rename_labels_impl
  rs_nfa_rename_labels_gen_impl
  rs_nfa_normalise_impl
  rs_nfa_complement_impl
  
  rs_nfa_determinise_impl
  rs_nfa_reverse_impl
  rs_nfa_right_quotient_lists_impl
  rs_nfa_Brzozowski_impl
  rs_nfa_Hopcroft_impl
  rs_nfa_Hopcroft_NFA_impl *)

lemma rs_nfa_StdNFA_impl: "StdNFA rs_nfa_ops"
  apply (rule StdNFA.intro)
  apply (simp_all add: rs_nfa_ops_def rs_nfa_impls)
done



end
