
theory RBT_LTSImpl

imports LTSByMap LTSGA LTS_Impl
begin

subsection \<open> LTS \<close>
interpretation rs_lts_defs: ltsbm_defs rm_ops rm_ops rs_ops 
  apply intro_locales
  done


definition "rs_lts_\<alpha> \<equiv> rs_lts_defs.ltsbm_\<alpha>"
definition "rs_lts_invar \<equiv> rs_lts_defs.ltsbm_invar"
definition "rs_lts_empty \<equiv> rs_lts_defs.ltsbm_empty"

schematic_goal lts_empty_code:"rs_lts_empty = ?code_lts_empty"
  unfolding rs_lts_empty_def rs_lts_defs.ltsbm_empty_def
  by (rule refl)+

lemmas rs_lts_empty_code [code] = lts_empty_code 

definition "rs_lts_add \<equiv> rs_lts_defs.ltsbm_add"

schematic_goal lts_add_code: "rs_lts_add = ?code_lts_add"
  unfolding rs_lts_add_def rs_lts_defs.ltsbm_add_def
  by (rule refl)+

lemmas rs_lts_add_code [code] = lts_add_code 

term rs_lts_defs.ltsbm_it
term rs_iteratei
definition "rs_lts_add_succs \<equiv> rs_lts_defs.ltsbm_add_succs"
definition "rs_lts_delete \<equiv> rs_lts_defs.ltsbm_delete"
definition "rs_lts_it \<equiv> rs_lts_defs.ltsbm_it rm_iteratei 
                                    rm_iteratei rs_iteratei"
definition "rs_lts_filter_it \<equiv> rs_lts_defs.ltsbm_filter_it 
                          rm_iteratei rm_iteratei rs_iteratei"

definition "rs_lts_to_list \<equiv> ltsga_to_list rs_lts_it"
definition "rs_lts_to_collect_list \<equiv> ltsga_to_collect_list rs_lts_to_list"
definition "rs_lts_succ_it \<equiv> rs_lts_defs.ltsbm_succ_it rm.iteratei rs_iteratei"
definition "rs_lts_succ_label_it \<equiv> 
    rs_lts_defs.ltsbm_succ_label_it rm_iteratei rs_iteratei"

definition "rs_lts_connect_it \<equiv> 
    rs_lts_defs.ltsbm_connect_it rm_iteratei rs_iteratei"

term rs_lts_defs.filter

schematic_goal lts_succ_label_it_code:"rs_lts_succ_label_it = 
  ?code_lts_succ_label_it"
  unfolding rs_lts_succ_label_it_def 
  rs_lts_defs.ltsbm_succ_label_it_def
  by (rule refl)+

lemmas rs_lts_succ_label_it_code [code] = lts_succ_label_it_code



schematic_goal lts_connect_it_code:"rs_lts_connect_it = 
  ?code_lts_connect_it"
  unfolding rs_lts_connect_it_def rs_lts_defs.filter_def
  rs_lts_defs.ltsbm_connect_it_def
  by (rule refl)+

lemmas rs_lts_connect_it_code [code] = lts_connect_it_code



schematic_goal lts_succ_it_code:"rs_lts_succ_it = ?code_lts_succ_it"
  unfolding rs_lts_succ_it_def rs_lts_defs.ltsbm_succ_it_def
  by (rule refl)+

lemmas rs_lts_succ_it_code [code] = lts_succ_it_code

definition "rs_lts_succ_it_bex \<equiv> rs_lts_defs.ltsbm_succ_it_bex rm.iteratei rs_iteratei"
definition "rs_lts_from_list \<equiv>  ltsga_from_list rs_lts_empty rs_lts_add"
definition "rs_lts_succ_ball \<equiv> ltsga_succ_ball rs_lts_succ_it"
definition "rs_lts_succ_bex \<equiv> ltsga_succ_bex rs_lts_succ_it_bex"
definition "rs_lts_reverse \<equiv> ltsga_reverse rs_lts_empty rs_lts_add rs_lts_it"
definition "rs_lts_filter \<equiv> ltsga_filter rs_lts_empty rs_lts_add rs_lts_filter_it"
definition "rs_lts_image_filter \<equiv> ltsga_image_filter rs_lts_empty rs_lts_add rs_lts_filter_it"
definition "rs_lts_image \<equiv> ltsga_image rs_lts_image_filter"

lemmas rs_lts_defs_raw = 
(*  rs_lts_defs.ltsbm_empty_def_raw 
  rs_lts_defs.ltsbm_add_def_raw 
  rs_lts_defs.ltsbm_add_succs_def_raw 
  rs_lts_defs.ltsbm_delete_def_raw 
  rs_lts_defs.ltsbm_it_alt_def 
  rs_lts_defs.ltsbm_filter_it_alt_def 
  rs_lts_defs.ltsbm_succ_it_def_raw *)
  rs_lts_defs.ltsbm_succ_label_it_alt_def
(*  rs_lts_defs.ltsbm_pre_it_alt_def 
  rs_lts_defs.ltsbm_pre_label_it_alt_def 
  rs_lts_defs.ltsbm_is_weak_det_def_raw 
  ltsga_from_list_def_raw 
  ltsga_to_list_def_raw 
  ltsga_to_collect_list_def_raw 
  ltsga_succ_ball_def_raw 
  ltsga_succ_bex_def_raw 
  ltsga_pre_ball_def_raw 
  ltsga_pre_bex_def_raw 
  ltsga_reverse_def_raw  
  ltsga_image_filter_def_raw 
  ltsga_image_def_raw 
  ltsga_filter_def_raw 
  iterate_to_list_def_raw o_def
  iterate_ball_def_raw iterate_bex_def *)

lemmas rs_lts_defs = 
  rs_lts_\<alpha>_def
  rs_lts_invar_def
  rs_lts_empty_def
  rs_lts_add_def
  rs_lts_add_succs_def
  rs_lts_delete_def
  rs_lts_from_list_def
  rs_lts_it_def
  rs_lts_filter_it_def
  rs_lts_succ_it_def
  rs_lts_succ_label_it_def
  rs_lts_succ_ball_def
  rs_lts_succ_bex_def 
  rs_lts_filter_def
  rs_lts_reverse_def
  rs_lts_succ_it_bex_def
  rs_lts_image_filter_def
  rs_lts_image_def
  rs_lts_to_collect_list_def
  

lemmas [code] = rs_lts_defs [unfolded rs_lts_defs, simplified]

lemmas rs_lts_empty_impl = rs_lts_defs.ltsbm_empty_correct[folded rs_lts_defs]
interpretation rs_lts: lts_empty rs_lts_\<alpha> rs_lts_invar rs_lts_empty
  using rs_lts_empty_impl .


lemmas rs_lts_it_impl = rs_lts_defs.ltsbm_it_correct[folded rs_lts_defs, 
  OF rm_iteratei_impl rm_iteratei_impl rs_iteratei_impl,
  folded rs_lts_defs]

interpretation rs_lts: lts_empty rs_lts_\<alpha> rs_lts_invar rs_lts_empty 
  using rs_lts_empty_impl .

interpretation rs_lts: finite_lts rs_lts_\<alpha> rs_lts_invar
  using ltsga_it_implies_finite[OF rs_lts_it_impl] .

lemmas rs_lts_add_impl = rs_lts_defs.ltsbm_add_correct[folded rs_lts_defs]
interpretation rs_lts: lts_add rs_lts_\<alpha> rs_lts_invar rs_lts_add
  using rs_lts_add_impl .

lemmas rs_lts_add_succs_impl = rs_lts_defs.ltsbm_add_succs_correct[folded rs_lts_defs]
interpretation rs_lts: lts_add_succs rs_lts_\<alpha> rs_lts_invar rs_lts_add_succs
  using rs_lts_add_succs_impl .

lemmas rs_lts_delete_impl = rs_lts_defs.ltsbm_delete_correct[folded rs_lts_defs]
interpretation rs_lts: lts_delete rs_lts_\<alpha> rs_lts_invar rs_lts_delete 
  using rs_lts_delete_impl .



lemmas rs_lts_from_list_impl = 
  ltsga_from_list_correct [OF rs_lts_empty_impl rs_lts_add_impl, folded rs_lts_defs]
interpretation rs_lts: lts_from_list rs_lts_\<alpha> rs_lts_invar rs_lts_from_list 
  using rs_lts_from_list_impl .

lemmas rs_lts_filter_it_impl = rs_lts_defs.ltsbm_filter_it_correct[folded rs_lts_defs,  
  OF rm_iteratei_impl rm_iteratei_impl rs_iteratei_impl,
  folded rs_lts_defs]
interpretation rs_lts: lts_filter_it rs_lts_\<alpha> rs_lts_invar rs_lts_filter_it 
  using rs_lts_filter_it_impl .




lemmas rs_lts_succ_it_impl = rs_lts_defs.ltsbm_succ_it_correct[folded rs_lts_defs,
  OF rm_iteratei_impl, OF rs_iteratei_impl,
  folded rm_ops_def rs_ops_def rs_lts_defs]

lemmas rs_lts_succ_it_bex_impl = 
      rs_lts_defs.ltsbm_succ_it_bex_correct[folded rs_lts_defs,
  OF rm_iteratei_impl rs_iteratei_impl,
  folded rm_ops_def rs_ops_def rs_lts_defs]

interpretation rs_lts: lts_succ_it rs_lts_\<alpha> rs_lts_invar rs_lts_succ_it 
  using rs_lts_succ_it_impl .

lemmas rs_lts_succ_label_it_impl = rs_lts_defs.ltsbm_succ_label_it_correct
       [folded rs_lts_defs,
  OF rm_iteratei_impl rs_iteratei_impl,
  folded rm_ops_def rs_ops_def rs_lts_defs]
interpretation rs_lts: lts_succ_label_it rs_lts_\<alpha> rs_lts_invar rs_lts_succ_label_it 
  using rs_lts_succ_label_it_impl .

lemmas rs_lts_connect_it_impl = rs_lts_defs.ltsbm_connect_it_correct
       [folded rs_lts_defs,
  OF rm_iteratei_impl rs_iteratei_impl,
  folded rm_ops_def rs_ops_def rs_lts_defs]


interpretation rs_lts: lts_connect_it rs_lts_\<alpha> rs_lts_invar 
                        rs_lts_defs.s3_\<alpha> rs_lts_defs.s3_invar 
                        rs_lts_connect_it 
  using rs_lts_connect_it_impl  
  unfolding rs_lts_connect_it_def .


lemmas rs_lts_succ_ball_impl = ltsga_succ_ball_correct [OF rs_lts_succ_it_impl, folded rs_lts_defs]
interpretation rs_lts: lts_succ_ball rs_lts_\<alpha> rs_lts_invar rs_lts_succ_ball 
  using rs_lts_succ_ball_impl .


interpretation rs_lts: lts_iterator rs_lts_\<alpha> rs_lts_invar rs_lts_it 
  by (simp add: rs_lts_it_impl)

lemmas rs_lts_reverse_impl = ltsga_reverse_correct [OF rs_lts_empty_impl rs_lts_add_impl 
   rs_lts_it_impl, folded rs_lts_defs]
interpretation rs_lts: lts_reverse rs_lts_\<alpha> rs_lts_invar rs_lts_\<alpha> rs_lts_invar rs_lts_reverse 
  by (simp add: rs_lts_reverse_impl)

lemmas rs_lts_filter_impl = ltsga_filter_correct [OF rs_lts_empty_impl
   rs_lts_add_impl rs_lts_filter_it_impl, folded rs_lts_filter_def]
interpretation rs_lts: lts_filter rs_lts_\<alpha> rs_lts_invar rs_lts_filter
  using rs_lts_filter_impl .


lemmas rs_lts_succ_bex_impl = ltsga_succ_bex_correct 
        [OF rs_lts_succ_it_bex_impl, folded rs_lts_defs ]
interpretation rs_lts: lts_succ_bex rs_lts_\<alpha> rs_lts_invar sat rs_lts_succ_bex
  using rs_lts_succ_bex_impl 
  by (auto)

lemmas rs_lts_image_filter_impl = ltsga_image_filter_correct [OF rs_lts_empty_impl
   rs_lts_add_impl rs_lts_filter_it_impl, folded rs_lts_image_filter_def]
interpretation rs_lts: lts_image_filter rs_lts_\<alpha> rs_lts_invar rs_lts_\<alpha> rs_lts_invar rs_lts_image_filter
  using rs_lts_image_filter_impl .

lemmas rs_lts_image_impl = ltsga_image_correct [OF rs_lts_image_filter_impl, folded rs_lts_image_def]
interpretation rs_lts: lts_image rs_lts_\<alpha> rs_lts_invar rs_lts_\<alpha> rs_lts_invar rs_lts_image
  using rs_lts_image_impl .

lemmas rs_lts_to_list_impl = ltsga_to_list_correct [OF rs_lts_it_impl, folded rs_lts_defs]
interpretation rs_lts: lts_to_list rs_lts_\<alpha> rs_lts_invar rs_lts_to_list
  using rs_lts_to_list_impl  by (simp add: rs_lts_to_list_def)

schematic_goal lts_to_list_code:"rs_lts_to_list = ?code_lts_empty"
  unfolding rs_lts_to_list_def ltsga_to_list_def
  by (rule refl)+

lemmas rs_lts_to_collect_list_impl = ltsga_to_collect_list_correct
  [OF rs_lts_to_list_impl, folded rs_lts_defs]
interpretation rs_lts: lts_to_collect_list rs_lts_\<alpha> rs_lts_invar rs_lts_to_collect_list
  using rs_lts_to_collect_list_impl 
  by (simp add: rs_lts_to_collect_list_def rs_lts_to_list_def)


schematic_goal lts_to_collect_list_code:"rs_lts_to_collect_list = ?code_lts_empty"
  unfolding rs_lts_to_collect_list_def rs_lts_to_list_def
  by (rule refl)+

schematic_goal lts_image_code: "rs_lts_image = ?code_lts_empty"
  unfolding rs_lts_image_def ltsga_image_def rs_lts_image_filter_def
            rs_lts_filter_it_def ltsga_image_filter_def
            rs_lts_defs.ltsbm_filter_it_def
            map_to_set_iterator_def
  by (rule refl)+

type_synonym ('V,'E) rs_lts = 
  "('V, ('E, ('V, unit) RBT.rbt) RBT.rbt) RBT.rbt"

definition rs_lts_ops :: 
  "('V::{linorder},'W::{linorder}, 'E, ('V,'W) rs_lts) lts_ops" where
   "rs_lts_ops \<equiv> \<lparr>
    clts_op_\<alpha> = rs_lts_\<alpha>,
    clts_op_invar = rs_lts_invar,
    clts_op_empty = rs_lts_empty,
    clts_op_add = rs_lts_add,
    clts_op_add_succs = rs_lts_add_succs,
    clts_op_delete = rs_lts_delete,
    clts_op_to_list = rs_lts_to_list,
    clts_op_to_collect_list = rs_lts_to_collect_list,
    clts_op_succ_ball = rs_lts_succ_ball,
    clts_op_succ_bex = rs_lts_succ_bex,
    clts_op_from_list = rs_lts_from_list,
    clts_op_image_filter = rs_lts_image_filter,
    clts_op_image = rs_lts_image,
    clts_op_filter = rs_lts_filter,
    lts_op_reverse = rs_lts_reverse \<rparr>"


lemma rs_lts_ops_unfold[code_unfold] :
    "clts_op_\<alpha> rs_lts_ops = rs_lts_\<alpha>"
    "clts_op_invar rs_lts_ops = rs_lts_invar"
    "clts_op_empty rs_lts_ops = rs_lts_empty"
    "clts_op_add rs_lts_ops = rs_lts_add"
    "clts_op_add_succs rs_lts_ops = rs_lts_add_succs"
    "clts_op_delete rs_lts_ops = rs_lts_delete"
    "clts_op_to_list rs_lts_ops = rs_lts_to_list"
    "clts_op_to_collect_list rs_lts_ops = rs_lts_to_collect_list"
    "clts_op_succ_ball rs_lts_ops = rs_lts_succ_ball"
    "clts_op_succ_bex rs_lts_ops = rs_lts_succ_bex"
    "clts_op_from_list rs_lts_ops = rs_lts_from_list"
    "clts_op_image_filter rs_lts_ops = rs_lts_image_filter"
    "clts_op_filter rs_lts_ops = rs_lts_filter"
    "clts_op_filter rs_lts_ops = rs_lts_filter"
    "lts_op_reverse rs_lts_ops = rs_lts_reverse"
  by (simp_all add: rs_lts_ops_def)


lemma rs_lts_impl: "StdLTS rs_lts_ops sat"
  apply (rule StdLTS.intro)
  apply (simp_all add: rs_lts_ops_def)
  apply unfold_locales
  done

interpretation rs_ltsr: StdLTS rs_lts_ops by (rule rs_lts_impl)

definition "rs_lts_is_reachable \<equiv> rs_ltsr.is_reachable_impl"
lemmas rs_lts_is_reachable_code[code] = 
      rs_ltsr.is_reachable_impl.simps [folded rs_lts_is_reachable_def rs_lts_defs, unfolded rs_lts_ops_unfold]
declare rs_lts_is_reachable_def [symmetric, code_unfold]

(*
definition "rs_lts_is_reachable \<equiv> rs_ltsr.is_reachable_impl"
lemmas rs_lts_is_reachable_code[code] = 
      rs_ltsr.is_reachable_impl.simps [folded rs_lts_is_reachable_def rs_lts_defs, unfolded rs_lts_ops_unfold]
declare rs_lts_is_reachable_def [symmetric, code_unfold]
*)

end
