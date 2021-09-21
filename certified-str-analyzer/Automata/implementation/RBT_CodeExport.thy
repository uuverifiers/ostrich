(*  
    Authors:     Shuanglong Kan <shuanglong@uni-kl.de>
                 Thomas Tuerk <tuerk@in.tum.de>             
*)

section \<open> Export Code with RBTs \<close>

theory RBT_CodeExport
imports Main 
        RBT_NFAImpl
        Forward_Analysis_Impl
begin


export_code
  prod_encode
  rs_nfa_construct_interval
  rs_nfa_bool_comb
  rs_nfa_destruct
  rs_nfa_concate
  rs_nfa_concate_rename
  rs_S_to_list 
  rs_gen_rm_from_list 
  rs_gen_rc_from_list 
  rs_gen_S_from_list 
  rs_forward_analysis 
  rs_rm_to_list
  rs_rc_to_list
  rs_nfa_construct_reachable
  rs_indegree
in OCaml module_name "Automata_lib"



end
