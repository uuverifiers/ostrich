(*  
    Authors:     Shuanglong Kan <shuanglong@uni-kl.de>        
*)

theory Forward_Analysis_Impl

imports "../Forward_Analysis" NFAByLTS_Interval
        RBT_LTSImpl RBT_NFAImpl interval NFAByLTS_Interval
begin

locale Forward_Analysis_Impl =
   nfa: nfa_dfa_by_lts_interval_defs s_ops ss_ops l_ops d_nfa_ops dd_nfa_ops +
    s: StdSet s_ops +
    ss: StdSet ss_ops +
    l: StdSet l_ops  +
    d_nfa: StdLTS d_nfa_ops elemI +
    dd_nfa: StdLTS dd_nfa_ops elemI  +
    sss: StdSet sss_ops +
    sp: StdSet sp_ops +    
    rc: StdMap rc_ops +
    rm: StdMap rm_ops +
    qm: StdMap qm_ops (* The index max *) 
    for s_ops::"('q::{NFA_states},'q_set,_) set_ops_scheme"
    and ss_ops::"('q \<times> 'q,'qq_set,_) set_ops_scheme"
    and l_ops::"('a ::linorder,'a_set,_) set_ops_scheme"
    and d_nfa_ops::"('q,'a \<times> 'a,'a,'d_nfa,_) lts_ops_scheme"
    and dd_nfa_ops::"('q \<times> 'q,'a \<times> 'a,'a,'dd_nfa,_) lts_ops_scheme" and
    sss_ops::"('v::linorder, 'v_set,_) set_ops_scheme" and
    sp_ops::"('v \<times> 'v, 'v_v_set,_) set_ops_scheme" and
    rm_ops :: "('v, 'q_set \<times> 'd_nfa \<times> 'q_set \<times> 'q_set, 'mm, _) map_ops_scheme" and
    qm_ops :: "('i, 'q::{NFA_states}, 'm, _) map_ops_scheme" and
    rc_ops :: "('v, 'v_v_set, 'mc, _) map_ops_scheme" 
begin

definition compute_dependent_impl where
  "compute_dependent_impl v rc = 
   (if rc.lookup v rc \<noteq> None then 
       FOREACH {e. e \<in> sp.\<alpha> (the (rc.lookup v rc))} 
           (\<lambda> (v1, v2) S. RETURN (sss.ins v1 (sss.ins v2 S)))
           (sss.empty ())
    else RETURN (sss.empty ()))"


lemma compute_dependent_correct :
  fixes v rc rc'
  assumes rc_OK: "(rc v \<noteq> None \<longleftrightarrow> rc.lookup v rc' \<noteq> None) \<and>
                  (the (rc v) = sp.\<alpha> (the (rc.lookup v rc'))) \<and>
                  (rc v = None \<longleftrightarrow> (rc.lookup v rc') = None)"
  shows "compute_dependent_impl v rc' \<le> \<Down> (build_rel sss.\<alpha> sss.invar)
         (compute_dependent_abstract v rc)"
  unfolding compute_dependent_abstract_def
            compute_dependent_impl_def
  apply (refine_rcg)
  apply (simp only: rc_OK)
  apply (subgoal_tac "inj_on id {e. e \<in> sp.\<alpha> (the (rc.lookup v rc'))}")
  apply assumption
  apply (simp add: rc_OK)
  apply (insert rc_OK)[1]
  apply simp
  apply (simp add: br_def sss.correct)
  defer
  apply (simp add: br_def sss.correct)
  by (simp add: br_def sss.correct)
  

schematic_goal compute_dependent_impl_code: 
  fixes D_it1 :: "'v \<Rightarrow> 'v_v_set \<Rightarrow> ('v \<times> 'v, 'v_set) set_iterator"
assumes D_it1_OK [rule_format, refine_transfer]: 
         "set_iterator (D_it1 v (the (rc.lookup v rc))) 
          {e. e \<in> sp.\<alpha> (the (rc.lookup v rc))}"
shows "RETURN ?f \<le> compute_dependent_impl v rc"
  unfolding compute_dependent_impl_def
  apply (unfold split_def snd_conv fst_conv prod.collapse)
  apply (rule refine_transfer | assumption | erule conjE)+
  done


definition compute_ready_set_impl where
  "compute_ready_set_impl 
   SI rc SR = 
   FOREACH {v. v \<in> (sss.\<alpha> SI)} 
   (\<lambda> v S.  
    do {  
          c \<leftarrow> compute_dependent_impl v rc;
          (if sss.subset c SR then RETURN (sss.ins v S) else RETURN S)
    }) (sss.empty ())"


lemma compute_ready_set_impl_correct:
  assumes SI_OK: "SI' = sss.\<alpha> SI" and
          rc_OK: "\<And> v. (rc v \<noteq> None \<longleftrightarrow> rc.lookup v rc' \<noteq> None) \<and>
                  (the (rc v) = sp.\<alpha> (the (rc.lookup v rc'))) \<and>
                  (rc v = None \<longleftrightarrow> (rc.lookup v rc') = None)" and
          rc_OK1: "rc.invar rc'" and
          rc_OK2: "sss.invar SR" and
          SR_OK: "SR' = sss.\<alpha> SR"
  shows "compute_ready_set_impl SI rc' SR \<le> \<Down> (build_rel sss.\<alpha> sss.invar)
         (compute_ready_set_abstract SI' rc SR')"
  unfolding compute_ready_set_abstract_def
            compute_ready_set_impl_def
  apply (refine_rcg)
  apply (subgoal_tac "inj_on id {v. v \<in> sss.\<alpha> SI}")
  apply assumption
  apply (simp add: SI_OK)
  apply (simp add: SI_OK)
  apply (simp add: br_def sss.correct)
  apply (subgoal_tac "
    compute_dependent_impl x rc'
       \<le> \<Down> (build_rel sss.\<alpha> sss.invar) (compute_dependent_abstract x' rc)")
      apply assumption
proof -
  {
    fix x it \<sigma> x' it' \<sigma>'
    show "x' = id x \<Longrightarrow>
       x \<in> it \<Longrightarrow>
       x' \<in> it' \<Longrightarrow>
       it' = id ` it \<Longrightarrow>
       it \<subseteq> {v. v \<in> sss.\<alpha> SI} \<Longrightarrow>
       it' \<subseteq> {v. v \<in> SI'} \<Longrightarrow>
       \<sigma>' =
       {v \<in> SI' - it'. v \<in> dom rc \<longrightarrow> (\<forall>(v1, v2)\<in>the (rc v). v1 \<in> SR' \<and> v2 \<in> SR')} \<Longrightarrow>
       (\<sigma>, \<sigma>') \<in> br sss.\<alpha> sss.invar \<Longrightarrow>
       compute_dependent_impl x rc'
       \<le> \<Down> (br sss.\<alpha> sss.invar) (compute_dependent_abstract x' rc)"
    proof -
    assume p1: "x' = id x"
    from this
    show "compute_dependent_impl x rc'
       \<le> \<Down> (br sss.\<alpha> sss.invar) (compute_dependent_abstract x' rc)"
      using compute_dependent_correct[of rc x rc', OF rc_OK[of x]]
      by simp
  qed
  }
  {
    fix x it \<sigma> x' it' \<sigma>' c ca
    assume t1: "(c, ca) \<in> br sss.\<alpha> sss.invar"   
    from this have t1: "ca = sss.\<alpha> c" and
                   t2: "sss.invar c"
       apply (simp add: br_def)
       using t1 by (simp add: br_def)
    from SR_OK this sss.correct(28)[OF t2 rc_OK2]
    show "sss.subset c SR = (ca \<subseteq> SR')"
      by simp
  }
  {
    fix x it \<sigma> x' it' \<sigma>' c ca
    show "x' = id x \<Longrightarrow>
       x \<in> it \<Longrightarrow>
       x' \<in> it' \<Longrightarrow>
       it' = id ` it \<Longrightarrow>
       it \<subseteq> {v. v \<in> sss.\<alpha> SI} \<Longrightarrow>
       it' \<subseteq> {v. v \<in> SI'} \<Longrightarrow>
       \<sigma>' =
       {v \<in> SI' - it'. v \<in> dom rc \<longrightarrow> (\<forall>(v1, v2)\<in>the (rc v). v1 \<in> SR' \<and> v2 \<in> SR')} \<Longrightarrow>
       (\<sigma>, \<sigma>') \<in> br sss.\<alpha> sss.invar \<Longrightarrow>
       (c, ca) \<in> br sss.\<alpha> sss.invar \<Longrightarrow>
       sss.subset c SR \<Longrightarrow> ca \<subseteq> SR' \<Longrightarrow> (sss.ins x \<sigma>, \<sigma>' \<union> {x'}) \<in> br sss.\<alpha> sss.invar"
    proof -
    assume p1: "(\<sigma>, \<sigma>') \<in> br sss.\<alpha> sss.invar" and
           p2: "x' = id x" and
           p3: "x \<in> it" and
           p4: "x' \<in> it'" and
           p5: "it' = id ` it"
    from p2 have x_eq_x': "x = x'" by simp
    from p1 have t1: "sss.\<alpha> \<sigma> = \<sigma>'" and 
                 t2: "sss.invar \<sigma>"
       apply (simp add: br_def)
       using p1 by (simp add: br_def)
     from x_eq_x' t1 t2
     show "(sss.ins x \<sigma>, \<sigma>' \<union> {x'}) \<in> br sss.\<alpha> sss.invar"
       apply (simp add: br_def)
       using sss.correct
       by fastforce qed
  }
qed

schematic_goal compute_ready_set_impl_aux: 
  fixes D_it1 :: "'v_set \<Rightarrow> ('v, 'v_set) set_iterator" and
        D_it2 :: "'v \<Rightarrow> 'mc \<Rightarrow> ('v \<times> 'v, 'v_set) set_iterator"
assumes D_it1_OK[rule_format, refine_transfer]: 
         "set_iterator (D_it1 SI) 
          {v. v \<in> sss.\<alpha> SI}" and
        D_it2_OK [rule_format,refine_transfer]: 
         "\<And> v. v \<in> dom (rc.\<alpha> rc) \<longrightarrow> (set_iterator (D_it2 v rc) 
          {e. e \<in> sp.\<alpha> (the (rc.lookup v rc))})" and
        rc_OK [rule_format, refine_transfer]:
         "\<And> v \<sigma>. rc.lookup v rc \<noteq> None \<Longrightarrow>  v \<in> dom (rc.\<alpha> rc)"
shows "RETURN ?f \<le> compute_ready_set_impl SI rc SR"
 unfolding compute_ready_set_impl_def compute_dependent_impl_def
  apply (unfold split_def snd_conv fst_conv prod.collapse)
  apply (rule refine_transfer | assumption | erule conjE )+
  done

definition lookup_aux where
    "lookup_aux v rc = rc.lookup v rc"

schematic_goal lookup_aux_code :
    "lookup_aux v rc = ?XXX1"
  unfolding lookup_aux_def
  by (rule refl)+


definition lang_var_impl where "
  lang_var_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa 
               it_1_nfa' it_2_nfa' it_3_nfa im1 im2 a b v RC rm  = 
  FOREACH {e. e \<in> sp.\<alpha> (RC)}
          (\<lambda> (v1, v2) Aut. 
           do {
                RETURN 
                (nfa.bool_comb_impl qm_ops1 it_1_nfa it_2_nfa (\<and>) Aut
                     (nfa.nfa_concat_rename_impl 
                     qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
                     (\<lambda> q. (a, q))
                     (\<lambda> q. (b, q))
                     (the (rm.lookup v1 rm))
                     (the (rm.lookup v2 rm))))
           }) 
          (the (rm.lookup v rm))"



schematic_goal lang_var_impl_code: 
  fixes D_it1 :: "'v_v_set \<Rightarrow> 
                   ('v \<times> 'v, 'q_set \<times> 'd_nfa \<times> 'q_set \<times> 'q_set) set_iterator"
assumes D_it1_OK [rule_format, refine_transfer]: 
         "set_iterator (D_it1 RC) 
          {e. e \<in> sp.\<alpha> RC}"
shows "RETURN ?f \<le> lang_var_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa 
               it_1_nfa' it_2_nfa' it_3_nfa im1 im2 a b v RC rm"
  unfolding lang_var_impl_def 
  apply (unfold split_def snd_conv fst_conv prod.collapse)
  apply (rule refine_transfer | assumption | erule conjE)+
  done


schematic_goal lang_var_code :
  "lang_var_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa 
               it_1_nfa' it_2_nfa' it_3_nfa im1 im2 a b v SC rm = ?XXX1"
  unfolding lang_var_impl_def nfa.bool_comb_impl_code
            nfa.nfa_concat_impl_code          
  by (rule refl)+



definition map_nfa_rel where
    "map_nfa_rel \<alpha> = {(m2, m1). (\<forall> v. m1 v \<noteq> None \<longleftrightarrow> rm.lookup v m2 \<noteq> None) \<and> 
                             (\<forall> v. m1 v \<noteq> None \<longrightarrow> 
                             NFA_isomorphic_wf (\<alpha> (the (rm.lookup v m2))) 
                                               (the (m1 v)))}"
term Pair

definition L_eq where
           "L_eq \<alpha> invar = {(x, y). \<L> y = \<L> (\<alpha> x) \<and> NFA y \<and>invar x}"


lemma language_var_impl_correct :
   fixes \<alpha>1 :: "('q,'a::linorder,'nfa) nfa_\<alpha>"
     and \<alpha>2 :: "('q,'a::linorder,'nfa) nfa_\<alpha>"
   assumes RC_ok: "{e. e \<in> RC'} = {e. e \<in> sp.\<alpha> RC}
                  \<and> (\<forall> (v1, v2) \<in> RC'. v1 \<in> dom rm' \<and> v2 \<in> dom rm')"
      and rm_ok: "v \<in> dom rm' \<and> 
                  (\<forall> v. (rm' v) \<noteq> None \<longleftrightarrow> (rm.lookup v rm) \<noteq> None) \<and>
                  (\<forall> v. rm' v \<noteq> None \<longrightarrow> NFA (the (rm' v)) \<and> 
                        \<L> (the (rm' v)) = 
                        \<L> (nfa.nfa.nfa_\<alpha> (the (rm.lookup v rm))) \<and>
                        nfa.nfa.nfa_invar_NFA (the (rm.lookup v rm)))"
    and qm_ops_OK: "StdMap qm_ops1"
    and it_1_nfa_OK: "lts_succ_label_it nfa.d_nfa.\<alpha> nfa.d_nfa.invar it_1_nfa"
    and it_2_nfa_OK: "lts_succ_it nfa.d_nfa.\<alpha> nfa.d_nfa.invar it_2_nfa"
    and \<Delta>_\<A>1: "\<And> n1. nfa.nfa.nfa_invar_NFA n1 \<Longrightarrow> 
          \<exists>D1. {(q, semI a, q')| q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa.nfa.nfa_\<alpha> n1) \<and>
               finite D1"
    and \<Delta>_\<A>2: "\<And> n2. nfa.nfa.nfa_invar_NFA n2 \<Longrightarrow> 
          \<exists>D2. {(q, semI a, q')| q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa.nfa_\<alpha> n2) \<and>
               finite D2"
    and \<Delta>_it_ok1: "\<And> q D1 n1. {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa.nfa_\<alpha> n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa.nfa_invar_NFA n1 \<Longrightarrow>
       set_iterator_genord (it_1_nfa (nfa.nfa.nfa_trans n1) q) {(a, q'). (q, a, q') \<in> D1}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok2: "\<And> q D2 n2 a. {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = 
       \<Delta> (nfa.nfa.nfa_\<alpha> n2) \<Longrightarrow>
       finite D2 \<Longrightarrow>
       nfa.nfa.nfa_invar_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_2_nfa (nfa.nfa.nfa_trans n2) q a) 
    {(a, q'). (q, a, q') \<in> D2}
        (\<lambda>_ _. True)" and
    sem_OK: "\<And>n1 n2 D1 D2.
      {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa.nfa.nfa_\<alpha> n1) \<Longrightarrow>
      {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa.nfa_\<alpha> n2) \<Longrightarrow>
      nfa.nfa.nfa_invar_NFA n1 \<Longrightarrow>
      nfa.nfa.nfa_invar_NFA n2 \<Longrightarrow>
      \<forall>q a b aa ba q'.
         (q, ((a, b), aa, ba), q')
         \<in> {(q, a, q').
             (q, a, q')
             \<in> {((q1, q2), (a1, a2), q1', q2') |q1 a1 q1' q2 a2 q2'.
                 (q1, a1, q1') \<in> D1 \<and> (q2, a2, q2') \<in> D2}} \<longrightarrow>
         a \<le> b \<and> aa \<le> ba"       
    and qm_ops2_OK: "StdMap qm_ops2"
    and wf_target: "nfa_dfa_by_lts_interval_defs s_ops ss_ops l_ops d_nfa_ops dd_nfa_ops"
    and im_OK: "set_image nfa.s.\<alpha> nfa.s.invar (set_op_\<alpha> ss_ops) (set_op_invar ss_ops) im1"
    and im2_OK: "lts_image nfa.d_nfa.\<alpha> nfa.d_nfa.invar 
                 (clts_op_\<alpha> dd_nfa_ops) (clts_op_invar dd_nfa_ops) im2"
    and it_1_nfa'_OK: "lts_succ_label_it nfa.dd_nfa.\<alpha> nfa.dd_nfa.invar it_1_nfa'"
    and it_2_nfa'_OK: "lts_succ_label_it nfa.dd_nfa.\<alpha> nfa.dd_nfa.invar it_2_nfa'"
    and it_3_nfa_OK: "lts_connect_it nfa.dd_nfa.\<alpha> nfa.dd_nfa.invar 
                                     nfa.ss.\<alpha> nfa.ss.invar it_3_nfa"
    and \<Delta>_\<A>1': "\<And> n1. nfa.nfa_invarp_NFA n1 \<Longrightarrow> 
          \<exists>D1. {(q, semI a, q')| q a q'. (q, a, q') \<in> D1} = 
                \<Delta> (nfa.nfa_\<alpha>p n1) \<and>
               finite D1"
    and \<Delta>_\<A>2': "\<And> n2. nfa.nfa_invarp_NFA n2 \<Longrightarrow> 
          \<exists>D2. {(q, semI a, q')| q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha>p n2) \<and>
               finite D2"
    and \<Delta>_it_ok1': "\<And> q D1 n1. {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa_\<alpha>p n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa_invarp_NFA n1 \<Longrightarrow>
       set_iterator_genord (it_1_nfa' (nfa.nfa.nfa_transp 
                    n1) q) {(a, q')| a q'. 
          (q, a, q') \<in> D1}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok2': "\<And> q D2 n2. {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = 
       \<Delta> (nfa.nfa_\<alpha>p n2) \<Longrightarrow>
       finite D2 \<Longrightarrow>
       nfa.nfa_invarp_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_2_nfa' (nfa.nfa.nfa_transp 
              n2) q) 
    {(a, q')| a q'. (q, a, q') \<in> D2}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok3: "\<And> q D1 n1 n2. 
       {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa_\<alpha>p n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa_invarp_NFA n1 \<Longrightarrow>
       nfa.nfa_invarp_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_3_nfa (nfa.nfa.nfa_transp n1) 
                                     (nfa.nfa.nfa_acceptingp n1)
                                     (nfa.nfa.nfa_initialp n2)
                                      q)
       {(a, q')| a q' q''. (q, a, q'') \<in> D1 \<and> q'' \<in> (nfa.ss.\<alpha> (nfa.nfa.nfa_acceptingp n1))
                                   \<and> q' \<in> (nfa.ss.\<alpha> (nfa.nfa.nfa_initialp n2))}
        (\<lambda>_ _. True)"
    and inj_12: "\<And> q n1 n2 D1 D2. 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (nfa.nfa_\<alpha>p n1) \<and> finite D1 \<Longrightarrow> 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha>p n2) \<and> finite D2 \<Longrightarrow>
      nfa.nfa_invarp_NFA n1 \<Longrightarrow> nfa.nfa_invarp_NFA n2 \<Longrightarrow>
      inj_on (\<lambda>(a, y). (semI a, y))
      {(a, q').
       (q, a, q')
        \<in> {(q, a, q').
          (q, a, q') \<in> D1 \<or>
          (q, a, q') \<in> D2 \<or>
          (q, a, q')
            \<in> {uu.
              \<exists>q a q' q''.
                 uu = (q, a, q') \<and>
                 (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (nfa.nfa_\<alpha>p n1) \<and> q' \<in> \<I> (nfa.nfa_\<alpha>p n2)}}}"
    and a_neq_b: "a \<noteq> b"
  shows "lang_var_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa 
               it_1_nfa' it_2_nfa' it_3_nfa im1 im2 a b v RC rm 
        \<le> \<Down> (L_eq nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar) 
        (lang_var v RC' rm' a b)"
  unfolding lang_var_def lang_var_impl_def
  apply (refine_rcg)
  apply (subgoal_tac "inj_on id {e. e \<in> sp.\<alpha> RC}")
  apply assumption
  apply simp  
  using RC_ok apply simp
  apply (insert rm_ok)[1]
  apply (simp add: L_eq_def nfa.nfa_dfa_\<alpha>_def 
                   nfa.nfa_dfa_invar_def)
  apply (simp add: rm_ok domIff)
proof -
  fix x it \<sigma> x' it' \<sigma>' x1 x2 x1a x2a 
  show "x' = id x \<Longrightarrow>
       x \<in> it \<Longrightarrow>
       x' \<in> it' \<Longrightarrow>
       it' = id ` it \<Longrightarrow>
       it \<subseteq> {e. e \<in> sp.\<alpha> RC} \<Longrightarrow>
       it' \<subseteq> {e. e \<in> RC'} \<Longrightarrow>
       \<forall>w. NFA \<sigma>' \<and>
           NFA_accept \<sigma>' w =
           (NFA_accept (the (rm' v)) w \<and>
            (\<forall>(v1, v2)\<in>RC' - it'.
                \<exists>w1 w2.
                   NFA_accept (the (rm' v1)) w1 \<and>
                   NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2)) \<Longrightarrow>
       (\<sigma>, \<sigma>') \<in> L_eq nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar \<Longrightarrow>
       x' = (x1, x2) \<Longrightarrow>
       x = (x1a, x2a) \<Longrightarrow>
       (nfa.bool_comb_impl qm_ops1 it_1_nfa it_2_nfa (\<and>) \<sigma>
         (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
           (Pair a) (Pair b) (the (local.rm.lookup x1a rm))
           (the (local.rm.lookup x2a rm))),
        NFA_product \<sigma>'
         (NFA_normalise_states
           (efficient_NFA_concatenation (NFA_rename_states (the (rm' x1)) (Pair a))
             (NFA_rename_states (the (rm' x2)) (Pair b)))))
       \<in> L_eq nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar"
  proof -
  assume p1: " x' = id x"
     and p2: "x \<in> it"
     and p3: "x' \<in> it'"
     and p4: "it' = id ` it"
     and p5: "it \<subseteq> {e. e \<in> sp.\<alpha> RC}"
     and p6: "it' \<subseteq> {e. e \<in> RC'}"
     and p7: "x' = (x1, x2)"
     and p8: "x = (x1a, x2a)"
     and p9: "(\<sigma>, \<sigma>') \<in> L_eq nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar"
  
  from nfa.bool_comb_impl_correct
      [of qm_ops1, OF qm_ops_OK it_1_nfa_OK
          it_2_nfa_OK ] \<Delta>_\<A>1 \<Delta>_\<A>2 \<Delta>_it_ok1 \<Delta>_it_ok2 sem_OK
  have c1: " nfa_bool_comb_same nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar
     (nfa.bool_comb_impl qm_ops1 it_1_nfa it_2_nfa)"
    by auto

  from c1 have c0: "(\<forall>n1 n2 bc.
      nfa.nfa_dfa_invar n1 \<longrightarrow>
      nfa.nfa_dfa_invar n2 \<longrightarrow>
      nfa.nfa_dfa_invar (nfa.bool_comb_impl qm_ops1 it_1_nfa it_2_nfa bc n1 n2) \<and>
      NFA_isomorphic_wf
       (nfa.nfa_dfa_\<alpha> (nfa.bool_comb_impl qm_ops1 it_1_nfa it_2_nfa bc n1 n2))
       (efficient_bool_comb_NFA bc (nfa.nfa_dfa_\<alpha> n1) (nfa.nfa_dfa_\<alpha> n2)))"
    unfolding nfa_bool_comb_same_def nfa_bool_comb_def nfa_bool_comb_axioms_def
              efficient_bool_comb_NFA_def
    by auto
  let ?f1 = "(\<lambda>q. (a, q))"
  let ?f2 = "(\<lambda>q. (b, q))"
  have inj_f1: "inj ?f1"
    by auto

   have inj_f2: "inj ?f2"
     by auto
   from a_neq_b
   have Q1Q2_empty: "\<And> n1 n2. ?f1 ` \<Q> (nfa.nfa.nfa_\<alpha> n1) \<inter> 
                               ?f2 ` \<Q> (nfa.nfa.nfa_\<alpha> n2) = {}"
     by blast

  from nfa.nfa_concat_rename_impl_correct
      [of qm_ops2, OF qm_ops2_OK wf_target im_OK im2_OK inj_f1 inj_f2
          it_1_nfa'_OK it_2_nfa'_OK it_3_nfa_OK \<Delta>_\<A>1' \<Delta>_\<A>2' \<Delta>_it_ok1'
          \<Delta>_it_ok2' \<Delta>_it_ok3 inj_12]
  have c2: "\<And>n1 n2.
     nfa_concat_rename_same (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar
    (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2)"
    using Q1Q2_empty by blast
  from c2 inj_f1 inj_f2 Q1Q2_empty 
  have c3: "(\<forall>n1 n2.
        nfa.nfa_dfa_invar n1 \<longrightarrow>
        nfa.nfa_dfa_invar n2 \<longrightarrow>
        inj_on (\<lambda>q. (a,q)) (\<Q> (nfa.nfa_dfa_\<alpha> n1)) \<longrightarrow>
        inj_on (\<lambda>q. (b,q)) (\<Q> (nfa.nfa_dfa_\<alpha> n2)) \<longrightarrow>
        (\<lambda>q. (a, q)) ` \<Q> (nfa.nfa_dfa_\<alpha> n1) \<inter> (\<lambda>q. (b, q)) ` \<Q> (nfa.nfa_dfa_\<alpha> n2) =
        {} \<longrightarrow>
        nfa.nfa_dfa_invar
         (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
           (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) n1 n2) \<and>
        NFA_isomorphic_wf
         (nfa.nfa_dfa_\<alpha>
           (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
             (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) n1 n2))
         (efficient_NFA_rename_concatenation (\<lambda>q. (a, q)) (\<lambda>q. (b, q))
           (nfa.nfa_dfa_\<alpha> n1) (nfa.nfa_dfa_\<alpha> n2)))"
    unfolding nfa_concat_rename_same_def
              nfa_concat_rename_def
              nfa_concat_rename_axioms_def
    by simp
  from inj_f1 
  have inj_f1': "\<And> n1. inj_on (\<lambda>q. (a, q)) (\<Q> (nfa.nfa_dfa_\<alpha> n1))"
    by auto

  from inj_f2 
  have inj_f2': "\<And> n1. inj_on (\<lambda>q. (b, q)) (\<Q> (nfa.nfa_dfa_\<alpha> n1))"
    by auto

  thm c3 inj_f1' inj_f2' Q1Q2_empty 
  have c3: "(\<forall>n1 n2.
        nfa.nfa_dfa_invar n1 \<longrightarrow>
        nfa.nfa_dfa_invar n2 \<longrightarrow>
        nfa.nfa_dfa_invar
         (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
           (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) n1 n2) \<and>
        NFA_isomorphic_wf
         (nfa.nfa_dfa_\<alpha>
           (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
             (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) n1 n2))
         (efficient_NFA_rename_concatenation (\<lambda>q. (a, q)) (\<lambda>q. (b, q))
           (nfa.nfa_dfa_\<alpha> n1) (nfa.nfa_dfa_\<alpha> n2)))"
    apply (rule_tac allI impI)+
  proof -
    fix n1 n2
    assume p1: "nfa.nfa_dfa_invar n1"
       and p2: "nfa.nfa_dfa_invar n2"

    from c3 p1 p2
      have "inj_on (\<lambda>q. (a, q)) (\<Q> (nfa.nfa_dfa_\<alpha> n1)) \<longrightarrow>
       inj_on (\<lambda>q. (b, q)) (\<Q> (nfa.nfa_dfa_\<alpha> n2)) \<longrightarrow>
       (\<lambda>q. (a, q)) ` \<Q> (nfa.nfa_dfa_\<alpha> n1) \<inter> (\<lambda>q. (b, q)) ` \<Q> (nfa.nfa_dfa_\<alpha> n2) =
       {} \<longrightarrow>
       nfa.nfa_dfa_invar
        (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
          (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) n1 n2) \<and>
       NFA_isomorphic_wf
        (nfa.nfa_dfa_\<alpha>
          (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
            (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) n1 n2))
        (efficient_NFA_rename_concatenation (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) (nfa.nfa_dfa_\<alpha> n1)
          (nfa.nfa_dfa_\<alpha> n2))"
        by blast
      from this inj_f1'[of n1] inj_f2'[of n2] Q1Q2_empty[of n1 n2]
      have "(\<lambda>q. (a, q)) ` \<Q> (nfa.nfa_dfa_\<alpha> n1) \<inter> (\<lambda>q. (b, q)) ` \<Q> (nfa.nfa_dfa_\<alpha> n2) = {} \<longrightarrow>
    nfa.nfa_dfa_invar
     (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
       (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) n1 n2) \<and>
    NFA_isomorphic_wf
     (nfa.nfa_dfa_\<alpha>
       (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
         (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) n1 n2))
     (efficient_NFA_rename_concatenation (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) (nfa.nfa_dfa_\<alpha> n1)
       (nfa.nfa_dfa_\<alpha> n2))"
        by auto
      from this Q1Q2_empty[of n1 n2]
      have "nfa.nfa_dfa_invar
     (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
       (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) n1 n2) \<and>
    NFA_isomorphic_wf
     (nfa.nfa_dfa_\<alpha>
       (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
         (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) n1 n2))
     (efficient_NFA_rename_concatenation (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) (nfa.nfa_dfa_\<alpha> n1)
       (nfa.nfa_dfa_\<alpha> n2))"
        unfolding nfa.nfa_dfa_\<alpha>_def
        by auto
      from this
    show "nfa.nfa_dfa_invar
        (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
          (Pair a) (Pair b) n1 n2) \<and>
       NFA_isomorphic_wf
        (nfa.nfa_dfa_\<alpha>
          (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
            (Pair a) (Pair b) n1 n2))
        (efficient_NFA_rename_concatenation (Pair a) (Pair b) (nfa.nfa_dfa_\<alpha> n1)
          (nfa.nfa_dfa_\<alpha> n2))"
      by auto
  qed
  have x1x1a : "x1 = x1a"
  using p1 p7 p8 by auto
  have x2x2a : "x2 = x2a"
    using p1 p7 p8 by auto

  let ?x1 = "the (rm' x1)"
  let ?x11 = "(the (local.rm.lookup x1a rm))"
  let ?x22 = "(the (local.rm.lookup x2a rm))"
  let ?x2 = "the (rm' x2)"

  from RC_ok rm_ok p2 p8 p5 p6
  have c11: "nfa.nfa_dfa_invar ?x11"
    by (metis (no_types, lifting) case_prodD domIff nfa.nfa_dfa_invar_def subset_Collect_conv)
  from RC_ok rm_ok p2 p8 p5 p6
  have c12: "nfa.nfa_dfa_invar ?x22"
    by (metis (no_types, lifting) case_prodD domIff nfa.nfa_dfa_invar_def subset_Collect_conv)

  from c3 c11 c12 have
  s1: "nfa.nfa_dfa_invar
    (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
    (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) ?x11 ?x22)"
    by blast

  from c3 c11 c12 have
  c3': "NFA_isomorphic_wf
        (nfa.nfa_dfa_\<alpha>
          (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
            (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) ?x11 ?x22))
        (efficient_NFA_rename_concatenation (\<lambda>q. (a, q)) (\<lambda>q. (b, q)) 
          (nfa.nfa_dfa_\<alpha> ?x11)
          (nfa.nfa_dfa_\<alpha> ?x22))"
    by blast

  from this
  have L_eq1: "\<L> (nfa.nfa_dfa_\<alpha>
                 (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
                 ?f1 ?f2 ?x11 ?x22)) = 
               \<L> (efficient_NFA_rename_concatenation ?f1 ?f2 
                  (nfa.nfa_dfa_\<alpha> ?x11)
                  (nfa.nfa_dfa_\<alpha> ?x22))"
    using NFA_isomorphic_wf_\<L> by blast
  from p9
  have NFA0: "\<L> (nfa.nfa_dfa_\<alpha> \<sigma>) = \<L> \<sigma>' \<and> NFA \<sigma>' \<and> nfa.nfa_dfa_invar \<sigma>"
    unfolding L_eq_def
    by auto

  from RC_ok rm_ok 
  have NFAx1: "NFA (the (rm' x1))"
    by (metis (no_types, lifting) case_prodD domIff p2 p5 p8 subset_Collect_conv x1x1a)
 
  from RC_ok rm_ok
  have NFAx2: "NFA (the (rm' x2))"
    by (metis (no_types, lifting) case_prodD domIff p2 p5 p8 subset_Collect_conv x2x2a)
 
  from Q1Q2_empty a_neq_b
  have "\<Q> (NFA_rename_states (the (rm' x1)) (Pair a)) \<inter>
    \<Q> (NFA_rename_states (the (rm' x2)) (Pair b)) =
    {}"
    unfolding NFA_rename_states_def
    apply simp
    by auto
    

  from NFA_rename_states___is_well_formed[of "the (rm' x1)" "Pair a", OF NFAx1]
       NFA_rename_states___is_well_formed[of "the (rm' x2)" "Pair b", OF NFAx2]
       efficient_NFA_concatenation___is_well_formed
       [of "(NFA_rename_states (the (rm' x1)) (Pair a))" 
           "(NFA_rename_states (the (rm' x2)) (Pair b))"]
       this
  have NFA1: "NFA (NFA_normalise_states
           (efficient_NFA_concatenation (NFA_rename_states (the (rm' x1)) (Pair a))
               (NFA_rename_states (the (rm' x2)) (Pair b))))"
    by (meson NFA_isomorphic_wf_alt_def NFA_isomorphic_wf_normalise_states)  

  from NFA0 
  have NFA2: "NFA \<sigma>'"
    by simp
  from \<L>_NFA_product[of \<sigma>', OF NFA2 NFA1]
  have su1: "\<L> (NFA_product \<sigma>'
         (NFA_normalise_states
           (efficient_NFA_concatenation (NFA_rename_states (the (rm' x1)) (Pair a))
             (NFA_rename_states (the (rm' x2)) (Pair b))))) = 
        \<L> \<sigma>' \<inter> 
        \<L> ((NFA_normalise_states
           (efficient_NFA_concatenation (NFA_rename_states (the (rm' x1)) (Pair a))
               (NFA_rename_states (the (rm' x2)) (Pair b)))))"
    using \<open>NFA (NFA_rename_states (the (rm' x1)) (Pair a))\<close> \<open>NFA (NFA_rename_states (the (rm' x2)) (Pair b))\<close> \<open>\<Q> (NFA_rename_states (the (rm' x1)) (Pair a)) \<inter> \<Q> (NFA_rename_states (the (rm' x2)) (Pair b)) = {}\<close> efficient_NFA_concatenation___is_well_formed by force    

  from p2 p5 p8 p9 x1x1a x2x2a RC_ok rm_ok 
  have cc1: "\<L> (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x1a rm))) = \<L> ?x1"
    by (metis (no_types, lifting) case_prodD domIff nfa.nfa_dfa_\<alpha>_def subset_Collect_conv)

  from p2 p5 p8 p9 x1x1a x2x2a RC_ok rm_ok 
  have cc2: "\<L> (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x2a rm))) = \<L> ?x2"
    by (metis (no_types, lifting) case_prodD domIff nfa.nfa_dfa_\<alpha>_def subset_Collect_conv)

  from cc1 cc2
  have cc3: "\<L> (efficient_bool_comb_NFA (\<and>) (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x1a rm)))
        (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x2a rm))))
        = \<L> (efficient_bool_comb_NFA (\<and>) ?x1 ?x2)"
    by (metis (no_types, lifting) NFA_isomorphic_wf_\<L> NFA_product___isomorphic_wf NFAx1 NFAx2 \<L>_NFA_product c11 c12 nfa.automaton_by_lts_correct nfa.nfa_is_wellformed)


  let ?NFA1 = "(nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
           (Pair a) (Pair b) (the (local.rm.lookup x1a rm))
           (the (local.rm.lookup x2a rm)))"

  from NFA0
  have q1: "nfa.nfa_dfa_invar \<sigma>"
    by simp
  from c3 c11 c12
  have "nfa.nfa_dfa_invar ?NFA1"
    by blast


  from  c0 this q1
  have "nfa.nfa_dfa_invar ?NFA1 \<and>
        NFA_isomorphic_wf
        (nfa.nfa_dfa_\<alpha> (nfa.bool_comb_impl qm_ops1 it_1_nfa it_2_nfa (\<and>) \<sigma> ?NFA1))
        (efficient_bool_comb_NFA (\<and>) (nfa.nfa_dfa_\<alpha> \<sigma>) (nfa.nfa_dfa_\<alpha> ?NFA1))"
    by blast
  
  from this cc3
  have cc4: "\<L> (nfa.nfa_dfa_\<alpha> (nfa.bool_comb_impl qm_ops1 it_1_nfa it_2_nfa (\<and>) \<sigma> ?NFA1))
       = \<L> (efficient_bool_comb_NFA (\<and>) (nfa.nfa_dfa_\<alpha> \<sigma>) (nfa.nfa_dfa_\<alpha> ?NFA1))"
    using NFA_isomorphic_wf_\<L> by blast

  have "\<L> (efficient_bool_comb_NFA (\<and>) (nfa.nfa_dfa_\<alpha> \<sigma>) (nfa.nfa_dfa_\<alpha> ?NFA1))
        = \<L> (nfa.nfa_dfa_\<alpha> \<sigma>) \<inter> \<L>(nfa.nfa_dfa_\<alpha> ?NFA1)"
    by (metis (no_types, lifting) NFA_isomorphic_wf_\<L> NFA_product___isomorphic_wf \<L>_NFA_product nfa.automaton_by_lts_correct nfa.nfa_is_wellformed q1 s1)

  from this cc4
  have su3: "\<L> (nfa.nfa_dfa_\<alpha> ((nfa.bool_comb_impl qm_ops1 it_1_nfa it_2_nfa (\<and>) \<sigma>
         (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
           (Pair a) (Pair b) (the (local.rm.lookup x1a rm))
           (the (local.rm.lookup x2a rm)))))) = 
        \<L> (nfa.nfa_dfa_\<alpha> \<sigma>) \<inter> \<L> (nfa.nfa_dfa_\<alpha> ?NFA1)"
    by blast

  have su2: "\<L> (nfa.nfa_dfa_\<alpha> \<sigma>) = \<L> \<sigma>'"
    using NFA0 by linarith

  from x1x1a
  have t1': "\<L> (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x1a rm))) = \<L> (the (rm' x1))"
    using cc1 by blast

  from x2x2a
  have t2': "\<L> (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x2a rm))) = \<L> (the (rm' x2))"
    using cc2 by blast

  have a1: "NFA ?x1"
    using NFAx1 
    by blast

  have a2: "NFA (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x1a rm)))"
    by (meson c11 nfa.automaton_by_lts_correct nfa.nfa_is_wellformed)


  have a3: "NFA ?x2"
    using NFAx2 
    by blast

  have a4: "NFA (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x2a rm)))"
    by (meson c12 nfa.automaton_by_lts_correct nfa.nfa_is_wellformed)

  have u1: "NFA_is_equivalence_rename_fun ?x1 (Pair a)"
    using NFA_is_equivalence_rename_fun_def by blast

  have u2: "NFA_is_equivalence_rename_fun 
            (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x1a rm))) (Pair a)"
    using NFA_is_equivalence_rename_fun_def by blast

  from t1' a1 a2 NFA.\<L>_rename_iff[OF a1 u1]
       NFA.\<L>_rename_iff[OF a2 u2]
  have uu1: "\<L> (NFA_rename_states (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x1a rm))) (Pair a)) = 
        \<L> (NFA_rename_states ?x1 (Pair a))"
    by blast

  have u3: "NFA_is_equivalence_rename_fun ?x2 (Pair b)"
    using NFA_is_equivalence_rename_fun_def by blast

  have u4: "NFA_is_equivalence_rename_fun 
            (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x2a rm))) (Pair b)"
    using NFA_is_equivalence_rename_fun_def by blast


  from t2' NFA.\<L>_rename_iff[OF a3 u3]
       NFA.\<L>_rename_iff[OF a4 u4]
  have uu2: "\<L> (NFA_rename_states (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x2a rm))) (Pair b)) = 
        \<L> (NFA_rename_states ?x2 (Pair b))"
    by blast
    

  have tmp1: "NFA (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x1a rm)))"
    using a2 by linarith
  from 
    this
    NFA_rename_states___is_well_formed[OF this, of "(Pair a)"]
  have tmp1:
   "NFA (NFA_rename_states (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x1a rm))) (Pair a))"
    by simp

  have tmp2: "NFA (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x2a rm)))"
    using a4 by blast
  from this
    NFA_rename_states___is_well_formed[OF this, of "(Pair b)"]
  have tmp2: 
    "NFA (NFA_rename_states (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x2a rm))) (Pair b))"
    by simp

  from a_neq_b
  have tmp3: "\<Q> (NFA_rename_states (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x1a rm))) (Pair a)) \<inter>
  \<Q> (NFA_rename_states (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x2a rm))) (Pair b)) =
  {}"
    unfolding NFA_rename_states_def
    apply simp
    by fastforce


  from \<L>_NFA_concatenation[OF tmp1 tmp2 tmp3]
  have uu2: "\<L> (NFA_concatenation
         (NFA_rename_states (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x1a rm))) (Pair a))
         (NFA_rename_states (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x2a rm))) (Pair b))) = 
        \<L> (NFA_concatenation (NFA_rename_states ?x1 (Pair a))
          (NFA_rename_states ?x2 (Pair b)))"
    using \<L>_NFA_concatenation \<open>NFA (NFA_rename_states (the (rm' x1)) (Pair a))\<close> \<open>NFA (NFA_rename_states (the (rm' x2)) (Pair b))\<close> \<open>\<Q> (NFA_rename_states (the (rm' x1)) (Pair a)) \<inter> \<Q> (NFA_rename_states (the (rm' x2)) (Pair b)) = {}\<close> uu1 uu2 by fastforce
  
  from c3' NFA1 
  have uu3: "\<L> (NFA_concatenation
           (NFA_rename_states (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x1a rm))) (Pair a))
           (NFA_rename_states (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup x2a rm))) (Pair b))) = 
        \<L> (nfa.nfa_dfa_\<alpha>
         (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
           (Pair a) (Pair b) (the (local.rm.lookup x1a rm))
           (the (local.rm.lookup x2a rm))))"
    unfolding efficient_NFA_rename_concatenation_def
    by (metis L_eq1 NFA_remove_unreachable_states_\<L> efficient_NFA_rename_concatenation_def)

  have "NFA (NFA_concatenation (NFA_rename_states (the (rm' x1)) (Pair a))
             (NFA_rename_states (the (rm' x2)) (Pair b)))"
    by (meson NFA_concatenation___is_well_formed \<open>NFA (NFA_rename_states (the (rm' x1)) (Pair a))\<close> \<open>NFA (NFA_rename_states (the (rm' x2)) (Pair b))\<close> \<open>\<Q> (NFA_rename_states (the (rm' x1)) (Pair a)) \<inter> \<Q> (NFA_rename_states (the (rm' x2)) (Pair b)) = {}\<close>)

  from x1x1a x2x2a t1' t2' uu2 this
       NFA_remove_unreachable_states___is_well_formed[OF this]
       NFA_normalise_states_\<L>
       NFA_remove_unreachable_states_\<L>
  have "\<L> (NFA_normalise_states
     (efficient_NFA_concatenation (NFA_rename_states (the (rm' x1)) (Pair a))
       (NFA_rename_states (the (rm' x2)) (Pair b)))) = 
        \<L> (NFA_concatenation
         (NFA_rename_states (the (rm' x1)) (Pair a))
         (NFA_rename_states (the (rm' x2)) (Pair b)))"
    unfolding efficient_NFA_rename_concatenation_def
              efficient_NFA_concatenation_def
    by blast
 
    from uu3 uu2 this
  have "\<L> (NFA_normalise_states
     (efficient_NFA_concatenation (NFA_rename_states (the (rm' x1)) (Pair a))
       (NFA_rename_states (the (rm' x2)) (Pair b)))) = 
        \<L> (nfa.nfa_dfa_\<alpha> ?NFA1)"
    unfolding efficient_NFA_rename_concatenation_def
              efficient_NFA_concatenation_def
    by blast


  from this su1 su2 su3
  have fn1:"\<L> (NFA_product \<sigma>'
         (NFA_normalise_states
           (efficient_NFA_concatenation (NFA_rename_states (the (rm' x1)) (Pair a))
             (NFA_rename_states (the (rm' x2)) (Pair b))))) = 
        \<L> (nfa.nfa_dfa_\<alpha>
         (nfa.bool_comb_impl qm_ops1 it_1_nfa it_2_nfa (\<and>) \<sigma>
           (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
             (Pair a) (Pair b) (the (local.rm.lookup x1a rm))
             (the (local.rm.lookup x2a rm)))))"
    by blast

  from NFA_product_NFA[OF NFA2 NFA1]
  have fn2: "NFA (NFA_product \<sigma>'
        (NFA_normalise_states
        (efficient_NFA_concatenation (NFA_rename_states (the (rm' x1)) (Pair a))
          (NFA_rename_states (the (rm' x2)) (Pair b)))))"
    by blast

  have  "nfa.nfa_dfa_invar ?NFA1" 
    using s1 by linarith

  from this
  have fn3: "nfa.nfa_dfa_invar (nfa.bool_comb_impl qm_ops1 it_1_nfa it_2_nfa (\<and>) \<sigma>
        (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2 (Pair a)
        (Pair b) (the (local.rm.lookup x1a rm)) (the (local.rm.lookup x2a rm))))"
    using c0 q1 by blast

  from fn1 fn2 fn3
  show "(nfa.bool_comb_impl qm_ops1 it_1_nfa it_2_nfa (\<and>) \<sigma>
         (nfa.nfa_concat_rename_impl qm_ops2 it_1_nfa' it_2_nfa' it_3_nfa im1 im2
           (Pair a) (Pair b) (the (local.rm.lookup x1a rm))
           (the (local.rm.lookup x2a rm))),
        NFA_product \<sigma>'
         (NFA_normalise_states
           (efficient_NFA_concatenation (NFA_rename_states (the (rm' x1)) (Pair a))
             (NFA_rename_states (the (rm' x2)) (Pair b)))))
       \<in> L_eq nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar"
    unfolding L_eq_def
    by blast
qed qed





definition language_vars_impl where "
  language_vars_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa 
                     it_1_nfa' it_2_nfa' it_3_nfa im1 im2 a b SI rc rm = 
  FOREACH {v. v \<in> sss.\<alpha> SI} (\<lambda> v rm. do {
       if ((rc.lookup v rc) \<noteq> None) then 
        do {
            a \<leftarrow> (lang_var_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa 
                                it_1_nfa' it_2_nfa' it_3_nfa im1 im2 a b v 
                                (the (rc.lookup v rc)) rm);
                                RETURN (rm.update v a rm)
           }
       else RETURN rm
  }) rm"

definition rm_eq_rel where
    "rm_eq_rel \<alpha> invar = {(rm, rm'). 
                            (rm.invar rm) \<and>
                            (\<forall> v. rm.lookup v rm \<noteq> None \<longleftrightarrow> rm' v \<noteq> None) \<and>
                            (\<forall> v. rm' v \<noteq> None \<longrightarrow> 
                            ((the (rm.lookup v rm)), (the (rm' v))) \<in> L_eq \<alpha> invar)}"

lemma language_vars_impl_correct :
   fixes \<alpha>1 :: "('q,'a::linorder,'nfa) nfa_\<alpha>"
     and \<alpha>2 :: "('q,'a::linorder,'nfa) nfa_\<alpha>"
   assumes 
      SI_ok: "{v. v \<in> SI'} = {v. v \<in> sss.\<alpha> SI}" 
    and rc_ok : "(\<forall> v. rc' v \<noteq> None \<longleftrightarrow> rc.lookup v rc \<noteq> None) \<and>
                  (\<forall> v. v \<in> dom rc' \<longrightarrow>
                  {e. e \<in> the (rc' v)} = {e. e \<in> sp.\<alpha> (the (rc.lookup v rc))}
                  \<and> (\<forall> (v1, v2) \<in> the (rc' v). v1 \<in> dom rm' \<and> v2 \<in> dom rm'))"
    and rm_ok: "(rm.invar rm) \<and> 
                (\<forall> v. (rm' v) \<noteq> None \<longleftrightarrow> (rm.lookup v rm) \<noteq> None) \<and>
                (\<forall> v. rm' v \<noteq> None \<longrightarrow> NFA (the (rm' v)) \<and> 
                        \<L> (the (rm' v)) = 
                        \<L> (nfa.nfa.nfa_\<alpha> (the (rm.lookup v rm))) \<and>
                        nfa.nfa.nfa_invar_NFA (the (rm.lookup v rm)))"
    and qm_ops_OK: "StdMap qm_ops1"
    and it_1_nfa_OK: "lts_succ_label_it nfa.d_nfa.\<alpha> nfa.d_nfa.invar it_1_nfa"
    and it_2_nfa_OK: "lts_succ_it nfa.d_nfa.\<alpha> nfa.d_nfa.invar it_2_nfa"
    and \<Delta>_\<A>1: "\<And> n1. nfa.nfa.nfa_invar_NFA n1 \<Longrightarrow> 
          \<exists>D1. {(q, semI a, q')| q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa.nfa.nfa_\<alpha> n1) \<and>
               finite D1"
    and \<Delta>_\<A>2: "\<And> n2. nfa.nfa.nfa_invar_NFA n2 \<Longrightarrow> 
          \<exists>D2. {(q, semI a, q')| q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa.nfa_\<alpha> n2) \<and>
               finite D2"
    and \<Delta>_it_ok1: "\<And> q D1 n1. {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa.nfa_\<alpha> n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa.nfa_invar_NFA n1 \<Longrightarrow>
       set_iterator_genord (it_1_nfa (nfa.nfa.nfa_trans n1) q) {(a, q'). (q, a, q') \<in> D1}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok2: "\<And> q D2 n2 a. {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = 
       \<Delta> (nfa.nfa.nfa_\<alpha> n2) \<Longrightarrow>
       finite D2 \<Longrightarrow>
       nfa.nfa.nfa_invar_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_2_nfa (nfa.nfa.nfa_trans n2) q a) 
    {(a, q'). (q, a, q') \<in> D2}
        (\<lambda>_ _. True)" and
    sem_OK: "\<And>n1 n2 D1 D2.
      {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa.nfa.nfa_\<alpha> n1) \<Longrightarrow>
      {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa.nfa_\<alpha> n2) \<Longrightarrow>
      nfa.nfa.nfa_invar_NFA n1 \<Longrightarrow>
      nfa.nfa.nfa_invar_NFA n2 \<Longrightarrow>
      \<forall>q a b aa ba q'.
         (q, ((a, b), aa, ba), q')
         \<in> {(q, a, q').
             (q, a, q')
             \<in> {((q1, q2), (a1, a2), q1', q2') |q1 a1 q1' q2 a2 q2'.
                 (q1, a1, q1') \<in> D1 \<and> (q2, a2, q2') \<in> D2}} \<longrightarrow>
         a \<le> b \<and> aa \<le> ba"       
    and qm_ops2_OK: "StdMap qm_ops2"
    and wf_target: "nfa_dfa_by_lts_interval_defs s_ops ss_ops l_ops d_nfa_ops dd_nfa_ops"
    and im_OK: "set_image nfa.s.\<alpha> nfa.s.invar (set_op_\<alpha> ss_ops) (set_op_invar ss_ops) im1"
    and im2_OK: "lts_image nfa.d_nfa.\<alpha> nfa.d_nfa.invar 
                 (clts_op_\<alpha> dd_nfa_ops) (clts_op_invar dd_nfa_ops) im2"
    and it_1_nfa'_OK: "lts_succ_label_it nfa.dd_nfa.\<alpha> nfa.dd_nfa.invar it_1_nfa'"
    and it_2_nfa'_OK: "lts_succ_label_it nfa.dd_nfa.\<alpha> nfa.dd_nfa.invar it_2_nfa'"
    and it_3_nfa_OK: "lts_connect_it nfa.dd_nfa.\<alpha> nfa.dd_nfa.invar 
                                     nfa.ss.\<alpha> nfa.ss.invar it_3_nfa"
    and \<Delta>_\<A>1': "\<And> n1. nfa.nfa_invarp_NFA n1 \<Longrightarrow> 
          \<exists>D1. {(q, semI a, q')| q a q'. (q, a, q') \<in> D1} = 
                \<Delta> (nfa.nfa_\<alpha>p n1) \<and>
               finite D1"
    and \<Delta>_\<A>2': "\<And> n2. nfa.nfa_invarp_NFA n2 \<Longrightarrow> 
          \<exists>D2. {(q, semI a, q')| q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha>p n2) \<and>
               finite D2"
    and \<Delta>_it_ok1': "\<And> q D1 n1. {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa_\<alpha>p n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa_invarp_NFA n1 \<Longrightarrow>
       set_iterator_genord (it_1_nfa' (nfa.nfa.nfa_transp 
                    n1) q) {(a, q')| a q'. 
          (q, a, q') \<in> D1}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok2': "\<And> q D2 n2. {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = 
       \<Delta> (nfa.nfa_\<alpha>p n2) \<Longrightarrow>
       finite D2 \<Longrightarrow>
       nfa.nfa_invarp_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_2_nfa' (nfa.nfa.nfa_transp 
              n2) q) 
    {(a, q')| a q'. (q, a, q') \<in> D2}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok3: "\<And> q D1 n1 n2. 
       {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa_\<alpha>p n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa_invarp_NFA n1 \<Longrightarrow>
       nfa.nfa_invarp_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_3_nfa (nfa.nfa.nfa_transp n1) 
                                     (nfa.nfa.nfa_acceptingp n1)
                                     (nfa.nfa.nfa_initialp n2)
                                      q)
       {(a, q')| a q' q''. (q, a, q'') \<in> D1 \<and> q'' \<in> (nfa.ss.\<alpha> (nfa.nfa.nfa_acceptingp n1))
                                   \<and> q' \<in> (nfa.ss.\<alpha> (nfa.nfa.nfa_initialp n2))}
        (\<lambda>_ _. True)"
    and inj_12: "\<And> q n1 n2 D1 D2. 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (nfa.nfa_\<alpha>p n1) \<and> finite D1 \<Longrightarrow> 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha>p n2) \<and> finite D2 \<Longrightarrow>
      nfa.nfa_invarp_NFA n1 \<Longrightarrow> nfa.nfa_invarp_NFA n2 \<Longrightarrow>
      inj_on (\<lambda>(a, y). (semI a, y))
      {(a, q').
       (q, a, q')
        \<in> {(q, a, q').
          (q, a, q') \<in> D1 \<or>
          (q, a, q') \<in> D2 \<or>
          (q, a, q')
            \<in> {uu.
              \<exists>q a q' q''.
                 uu = (q, a, q') \<and>
                 (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (nfa.nfa_\<alpha>p n1) \<and> q' \<in> \<I> (nfa.nfa_\<alpha>p n2)}}}"
    and a_neq_b: "a \<noteq> b"
  shows "language_vars_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa 
                     it_1_nfa' it_2_nfa' it_3_nfa im1 im2 a b SI rc rm
        \<le> \<Down> (rm_eq_rel nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar) 
        (language_vars SI' rc' rm' a b)"
  unfolding language_vars_impl_def
            language_vars_def
  apply (refine_rcg)
  apply (subgoal_tac "inj_on id {v. v \<in> sss.\<alpha> SI}")
  apply assumption
  apply fastforce
  using SI_ok apply simp
  unfolding rm_eq_rel_def L_eq_def
  using rm_ok
  apply (simp add: rm_ok nfa.nfa_dfa_\<alpha>_def nfa.nfa_dfa_invar_def)
  using rc_ok 
  apply (simp add: domIff)
 apply (subgoal_tac 
        "lang_var_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa it_1_nfa' it_2_nfa' it_3_nfa im1
        im2 a b x (the (rc.lookup x rc)) \<sigma>
       \<le> \<Down> (L_eq nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar) 
            (lang_var x' (the (rc' x')) \<sigma>' a b)")
    apply fastforce
proof -
  {
    fix x it \<sigma> x' it' \<sigma>'
    assume p1: "x' = id x"
       and p2: "x \<in> it"
       and p3: "x' \<in> it'"
       and p4: "it' = id ` it"
       and p5: "it \<subseteq> {v. v \<in> sss.\<alpha> SI}"
       and p6: "it' \<subseteq> {v. v \<in> SI'}" 
       and p7: "SI' \<subseteq> dom \<sigma>' \<and>
       dom \<sigma>' = dom rm' \<and>
       (\<forall>v. v \<in> dom \<sigma>' \<longrightarrow> NFA (the (\<sigma>' v))) \<and>
       (\<forall>v\<in>it'. the (\<sigma>' v) = the (rm' v)) \<and>
       (\<forall>v. v \<notin> SI' \<longrightarrow> the (\<sigma>' v) = the (rm' v)) \<and>
       (\<forall>x\<in>SI' - it'.
           NFA (the (\<sigma>' x)) \<and>
           (\<forall>w. NFA_accept (the (\<sigma>' x)) w =
                (NFA_accept (the (rm' x)) w \<and>
                 (x \<in> dom rc' \<longrightarrow>
                  (\<forall>(v1, v2)\<in>the (rc' x).
                      \<exists>w1 w2.
                         NFA_accept (the (\<sigma>' v1)) w1 \<and>
                         NFA_accept (the (\<sigma>' v2)) w2 \<and> w = w1 @ w2)))))" 
       and p8: "(\<sigma>, \<sigma>')
       \<in> {(rm, rm').
            rm.invar rm \<and>
           (\<forall>v. (local.rm.lookup v rm \<noteq> None) = (rm' v \<noteq> None)) \<and>
           (\<forall>v. rm' v \<noteq> None \<longrightarrow>
                (the (local.rm.lookup v rm), the (rm' v))
                \<in> {(x, y).
                    \<L> y = \<L> (nfa.nfa_dfa_\<alpha> x) \<and> NFA y \<and> nfa.nfa_dfa_invar x})}"
       and p9: "rc.lookup x rc \<noteq> None"
       and p10: "x' \<in> dom rc'"

    
    have pre1: "{e. e \<in> the (rc' x')} = {e. e \<in> sp.\<alpha> (the (rc.lookup x rc))} \<and>
          (\<forall>(v1, v2)\<in>the (rc' x'). v1 \<in> dom \<sigma>' \<and> v2 \<in> dom \<sigma>')"
      using p1 p10 p7 rc_ok by auto

    have pre2: "x \<in> dom \<sigma>' \<and>
    (\<forall>v. (\<sigma>' v \<noteq> None) = (local.rm.lookup v \<sigma> \<noteq> None)) \<and>
    (\<forall>v. \<sigma>' v \<noteq> None \<longrightarrow>
     NFA (the (\<sigma>' v)) \<and>
     \<L> (the (\<sigma>' v)) = \<L> (nfa.nfa.nfa_\<alpha> (the (local.rm.lookup v \<sigma>))) \<and>
     nfa.nfa.nfa_invar_NFA (the (local.rm.lookup v \<sigma>)))"
      apply (rule conjI)
       defer
      apply (rule conjI)
    proof - 
    {
      from p2 p4 p5 p6  
      have "x \<in> SI'"
        by (simp add: in_mono)
      from this p7 
      show "x \<in>  dom \<sigma>'"
        by auto
    }
    {
      from p8
      show "\<forall>v. (\<sigma>' v \<noteq> None) = (local.rm.lookup v \<sigma> \<noteq> None)"  
        by simp
    }
    {
      from p8
      show "\<forall>v. \<sigma>' v \<noteq> None \<longrightarrow>
        NFA (the (\<sigma>' v)) \<and>
        \<L> (the (\<sigma>' v)) = \<L> (nfa.nfa.nfa_\<alpha> (the (local.rm.lookup v \<sigma>))) \<and>
        nfa.nfa.nfa_invar_NFA (the (local.rm.lookup v \<sigma>))"
        using nfa.nfa_dfa_\<alpha>_def nfa.nfa_dfa_invar_def by auto
    } qed
      
      


    from language_var_impl_correct[of 
          "(the (rc' x'))" "the (rc.lookup x rc)" \<sigma>' x \<sigma> qm_ops1
          it_1_nfa it_2_nfa qm_ops2 im1 im2 it_1_nfa' it_2_nfa' it_3_nfa,
          OF pre1 pre2 qm_ops_OK it_1_nfa_OK it_2_nfa_OK
          \<Delta>_\<A>1 \<Delta>_\<A>2 \<Delta>_it_ok1 \<Delta>_it_ok2 sem_OK qm_ops2_OK wf_target
          im_OK im2_OK it_1_nfa'_OK it_2_nfa'_OK it_3_nfa_OK \<Delta>_\<A>1'
          \<Delta>_\<A>2' \<Delta>_it_ok1' \<Delta>_it_ok2' \<Delta>_it_ok3 inj_12 a_neq_b] p1
    show "lang_var_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa it_1_nfa' it_2_nfa' it_3_nfa im1
        im2 a b x (the (rc.lookup x rc)) \<sigma>
       \<le> \<Down> (L_eq nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar) (lang_var x' (the (rc' x')) \<sigma>' a b)"
      by auto
  }
  {
    fix x it \<sigma> x' it' \<sigma>' a aa

    show "x' = id x \<Longrightarrow>
       x \<in> it \<Longrightarrow>
       x' \<in> it' \<Longrightarrow>
       it' = id ` it \<Longrightarrow>
       it \<subseteq> {v. v \<in> sss.\<alpha> SI} \<Longrightarrow>
       it' \<subseteq> {v. v \<in> SI'} \<Longrightarrow>
       SI' \<subseteq> dom \<sigma>' \<and>
       dom \<sigma>' = dom rm' \<and>
       (\<forall>v. v \<in> dom \<sigma>' \<longrightarrow> NFA (the (\<sigma>' v))) \<and>
       (\<forall>v\<in>it'. the (\<sigma>' v) = the (rm' v)) \<and>
       (\<forall>v. v \<notin> SI' \<longrightarrow> the (\<sigma>' v) = the (rm' v)) \<and>
       (\<forall>x\<in>SI' - it'.
           NFA (the (\<sigma>' x)) \<and>
           (\<forall>w. NFA_accept (the (\<sigma>' x)) w =
                (NFA_accept (the (rm' x)) w \<and>
                 (x \<in> dom rc' \<longrightarrow>
                  (\<forall>(v1, v2)\<in>the (rc' x).
                      \<exists>w1 w2.
                         NFA_accept (the (\<sigma>' v1)) w1 \<and>
                         NFA_accept (the (\<sigma>' v2)) w2 \<and> w = w1 @ w2))))) \<Longrightarrow>
       (\<sigma>, \<sigma>')
       \<in> {(rm, rm').
           local.rm.invar rm \<and>
           (\<forall>v. (local.rm.lookup v rm \<noteq> None) = (rm' v \<noteq> None)) \<and>
           (\<forall>v. rm' v \<noteq> None \<longrightarrow>
                (the (local.rm.lookup v rm), the (rm' v))
                \<in> {(x, y).
                    \<L> y = \<L> (nfa.nfa_dfa_\<alpha> x) \<and> NFA y \<and> nfa.nfa_dfa_invar x})} \<Longrightarrow>
       rc.lookup x rc \<noteq> None \<Longrightarrow>
       x' \<in> dom rc' \<Longrightarrow>
       (a, aa) \<in> L_eq nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar \<Longrightarrow>
       RETURN (local.rm.update x a \<sigma>)
       \<le> \<Down> {(rm, rm').
             local.rm.invar rm \<and>
             (\<forall>v. (local.rm.lookup v rm \<noteq> None) = (rm' v \<noteq> None)) \<and>
             (\<forall>v. rm' v \<noteq> None \<longrightarrow>
                  (the (local.rm.lookup v rm), the (rm' v))
                  \<in> {(x, y). \<L> y = \<L> (nfa.nfa_dfa_\<alpha> x) \<and> NFA y \<and> nfa.nfa_dfa_invar x})}
           (SPEC (\<lambda>rm'. new_language_map \<sigma>' rm' x' aa) \<bind> RETURN)"
    proof -
    assume p1: "x' = id x"
       and p2: "x \<in> it"
       and p3: "x' \<in> it'"
       and p4: "it' = id ` it"
       and p5: "it \<subseteq> {v. v \<in> sss.\<alpha> SI}"
       and p6: "it' \<subseteq> {v. v \<in> SI'}"
       and p7: "SI' \<subseteq> dom \<sigma>' \<and>
       dom \<sigma>' = dom rm' \<and>
       (\<forall>v. v \<in> dom \<sigma>' \<longrightarrow> NFA (the (\<sigma>' v))) \<and>
       (\<forall>v\<in>it'. the (\<sigma>' v) = the (rm' v)) \<and>
       (\<forall>v. v \<notin> SI' \<longrightarrow> the (\<sigma>' v) = the (rm' v)) \<and>
       (\<forall>x\<in>SI' - it'.
           NFA (the (\<sigma>' x)) \<and>
           (\<forall>w. NFA_accept (the (\<sigma>' x)) w =
                (NFA_accept (the (rm' x)) w \<and>
                 (x \<in> dom rc' \<longrightarrow>
                  (\<forall>(v1, v2)\<in>the (rc' x).
                      \<exists>w1 w2.
                         NFA_accept (the (\<sigma>' v1)) w1 \<and>
                         NFA_accept (the (\<sigma>' v2)) w2 \<and> w = w1 @ w2)))))"
        and p8: "rc.lookup x rc \<noteq> None"
        and p9: " x' \<in> dom rc'"
        and p10: "(a, aa) \<in> L_eq nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar"
        and p11: "(\<sigma>, \<sigma>')
    \<in> {(rm, rm').
        local.rm.invar rm \<and>
        (\<forall>v. (local.rm.lookup v rm \<noteq> None) = (rm' v \<noteq> None)) \<and>
        (\<forall>v. rm' v \<noteq> None \<longrightarrow>
             (the (local.rm.lookup v rm), the (rm' v))
             \<in> {(x, y). \<L> y = \<L> (nfa.nfa_dfa_\<alpha> x) \<and> NFA y \<and> nfa.nfa_dfa_invar x})}"
    show "RETURN (local.rm.update x a \<sigma>)
    \<le> \<Down> {(rm, rm').
          local.rm.invar rm \<and>
          (\<forall>v. (local.rm.lookup v rm \<noteq> None) = (rm' v \<noteq> None)) \<and>
          (\<forall>v. rm' v \<noteq> None \<longrightarrow>
               (the (local.rm.lookup v rm), the (rm' v))
               \<in> {(x, y). \<L> y = \<L> (nfa.nfa_dfa_\<alpha> x) \<and> NFA y \<and> nfa.nfa_dfa_invar x})}
        (SPEC (\<lambda>rm'. new_language_map \<sigma>' rm' x' aa) \<bind> RETURN)"
      apply simp
    proof -
      let ?rm = "local.rm.update x a \<sigma>"
      let ?rm' = "\<sigma>' (x' \<mapsto> aa)"
      from p1 p3 p6 SI_ok
      have "x' \<in> SI'"
        by blast
      from this p7
      have "x' \<in> dom \<sigma>'"
        by blast
      from this
      have rm'_def:
      "new_language_map \<sigma>' ?rm' x' aa"
        unfolding new_language_map_def
        by (simp add: insert_absorb)
      have c11: "rm.invar ?rm \<and>
          (\<forall>v. (\<exists> Q D I F. local.rm.lookup v ?rm = Some (Q, D, I, F)) =
               (\<exists>y. ?rm' v = Some y)) \<and>
          (\<forall>v. (\<exists>y. ?rm' v = Some y) \<longrightarrow>
               \<L> (the (?rm' v)) = \<L> (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup v ?rm))) \<and>
               NFA (the (?rm' v)) \<and> nfa.nfa_dfa_invar (the (local.rm.lookup v ?rm)))"
        apply (rule conjI)
        using p11 
        using local.rm.update_correct(2) apply auto[1]
      proof 
        { 
          show "\<forall>v. (\<exists>Q D I F. local.rm.lookup v (local.rm.update x a \<sigma>) = 
              Some (Q, D, I, F)) =
              (\<exists>y. (\<sigma>'(x' \<mapsto> aa)) v = Some y)"
          proof
            fix v
            have t1: "x \<in> dom \<sigma>'"
              using \<open>x' \<in> dom \<sigma>'\<close> p1 by auto
            from p11
            have p11': "rm.invar \<sigma> \<and>
                       (local.rm.lookup v \<sigma> \<noteq> None) = (\<sigma>' v \<noteq> None)"
              by blast
            from this t1 p1 show
            "(\<exists>Q D I F. local.rm.lookup v (local.rm.update x a \<sigma>) = Some (Q, D, I, F)) =
             (\<exists>y. (\<sigma>'(x' \<mapsto> aa)) v = Some y)"
            proof (cases "v \<in> dom \<sigma>'")
              case True
              from this 
              have t1: "(\<exists>y. (\<sigma>' v) = Some y)"
                by blast
              from this have c2: "(\<exists>y. (\<sigma>'(x' \<mapsto> aa)) v = Some y)"
                by fastforce
              from t1 p11' rm.correct(6)[of \<sigma> x a]
              have "(local.rm.lookup v \<sigma> \<noteq> None)"
                by auto
              from this 
              have "(\<exists>Q D I F. local.rm.lookup v \<sigma> = Some (Q D I F))"
                by force
              from this p11' rm.correct(6)[of \<sigma> x a]
                   rm.correct
              have "(\<exists>y. local.rm.lookup v (local.rm.update x a \<sigma>) = 
                    Some y)"
                by (metis (no_types, lifting) map_upd_Some_unfold)
              from this c2
              have "\<exists>Q D I F. local.rm.lookup v (local.rm.update x a \<sigma>) = 
                    Some (Q, D, I, F)"
                by auto
              from this c2
              show ?thesis 
                by auto
            next
              case False
              then show ?thesis
                using local.rm.lookup_correct local.rm.update_correct(1) local.rm.update_correct(2) p1 p11' t1 by auto
           qed qed
         }
         {
           show "\<forall>v. (\<exists>y. (\<sigma>'(x' \<mapsto> aa)) v = Some y) \<longrightarrow>
              \<L> (the ((\<sigma>'(x' \<mapsto> aa)) v)) =
              \<L> (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup v (local.rm.update x a \<sigma>)))) \<and>
              NFA (the ((\<sigma>'(x' \<mapsto> aa)) v)) \<and>
              nfa.nfa_dfa_invar (the (local.rm.lookup v (local.rm.update x a \<sigma>)))"
             apply (rule_tac allI impI)+
           proof 
             {
               fix v
               assume pc1: "\<exists>y. (\<sigma>'(x' \<mapsto> aa)) v = Some y"
               show "\<L> (the ((\<sigma>'(x' \<mapsto> aa)) v)) =
                     \<L> (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup v 
                        (local.rm.update x a \<sigma>))))"
               proof (cases "v \<in> dom \<sigma>'")
                 case True
                 from this p11
                 have \<L>1: "rm.invar \<sigma> \<and> \<L> (the ((\<sigma>') v)) =
                       \<L> (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup v \<sigma>)))"
                   using \<open>x' \<in> dom \<sigma>'\<close> by blast
                 from this p10 L_eq_def[of nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar]
                 have \<L>2: "\<L> aa = \<L> (nfa.nfa_dfa_\<alpha> a)"
                   by blast
                 from this \<L>1 rm.correct 
                 show ?thesis 
                   using p1 by auto
               next
                 case False
                 from this
                 show ?thesis using \<open>x' \<in> dom \<sigma>'\<close> 
                   using pc1 by auto
               qed                
             } 
             {
               fix v
               assume pd1: "\<exists>y. (\<sigma>'(x' \<mapsto> aa)) v = Some y"

               from this have v\<sigma>': "v \<in> dom \<sigma>'"
                 by (metis \<open>x' \<in> dom \<sigma>'\<close> domI domIff dom_fun_upd insert_absorb)
               from p10 p1
               have \<L>1: "NFA (the ((\<sigma>'(x' \<mapsto> aa)) x')) \<and>
               nfa.nfa_dfa_invar (the (local.rm.lookup x (local.rm.update x a \<sigma>)))"
                 unfolding L_eq_def
                 using local.rm.lookup_correct local.rm.update_correct(1) local.rm.update_correct(2) p11 by auto

               from v\<sigma>'
               have "\<sigma>' v \<noteq> None"
                  by blast

               from p11 this
               have "rm.invar \<sigma> \<and> NFA (the (\<sigma>' v)) \<and>
               nfa.nfa_dfa_invar (the (local.rm.lookup v (\<sigma>)))"
                 apply (rule_tac conjI)
                 apply blast
                 by auto
               from this \<L>1
               show "NFA (the ((\<sigma>'(x' \<mapsto> aa)) v)) \<and>
               nfa.nfa_dfa_invar (the (local.rm.lookup v (local.rm.update x a \<sigma>)))"
                 using local.rm.lookup_correct local.rm.update_correct(1) local.rm.update_correct(2) by auto
             } qed
         } qed

    from rm'_def
    have c12: "RETURN ?rm' \<le> (SPEC (\<lambda>rm'. new_language_map \<sigma>' rm' x' aa))" 
      by auto
    from c11 this
    have "RETURN (local.rm.update x a \<sigma>)
    \<le> \<Down> {(rm, rm').
          local.rm.invar rm \<and>
          (\<forall>v. (\<exists>a aa ab b. local.rm.lookup v rm = Some (a, aa, ab, b)) =
               (\<exists>y. rm' v = Some y)) \<and>
          (\<forall>v. (\<exists>y. rm' v = Some y) \<longrightarrow>
               \<L> (the (rm' v)) = \<L> (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup v rm))) \<and>
               NFA (the (rm' v)) \<and> nfa.nfa_dfa_invar (the (local.rm.lookup v rm)))}
        (RETURN ?rm')"
      by simp

    from this c12
    show "RETURN (local.rm.update x a \<sigma>)
    \<le> \<Down> {(rm, rm').
          local.rm.invar rm \<and>
          (\<forall>v. (\<exists>a aa ab b. local.rm.lookup v rm = Some (a, aa, ab, b)) =
               (\<exists>y. rm' v = Some y)) \<and>
          (\<forall>v. (\<exists>y. rm' v = Some y) \<longrightarrow>
               \<L> (the (rm' v)) = \<L> (nfa.nfa_dfa_\<alpha> (the (local.rm.lookup v rm))) \<and>
               NFA (the (rm' v)) \<and> nfa.nfa_dfa_invar (the (local.rm.lookup v rm)))}
        (SPEC (\<lambda>rm'. new_language_map \<sigma>' rm' x' aa))"
    using ref_two_step by blast
qed qed } qed



schematic_goal language_vars_impl: 
  fixes D_it1 :: "'v_set \<Rightarrow> ('v, 'mm) set_iterator" and
        D_it2 :: "'v \<Rightarrow> 'mc \<Rightarrow> 
                   ('v \<times> 'v, 'q_set \<times> 'd_nfa \<times> 'q_set \<times> 'q_set) set_iterator"
assumes D_it1_OK[rule_format, refine_transfer]: 
         "set_iterator (D_it1 SI) 
          {v. v \<in> sss.\<alpha> SI}" and
        D_it2_OK [rule_format, refine_transfer]: 
         "\<And> v rc. (set_iterator (D_it2 v rc) 
                    {e. e \<in> sp.\<alpha> (the (rc.lookup v rc))})"
shows "RETURN ?f \<le> language_vars_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa 
                     it_1_nfa' it_2_nfa' it_3_nfa im1 im2 a b SI rc rm"
  unfolding language_vars_impl_def lang_var_impl_def nfa.bool_comb_impl_code
            nfa.bool_comb_impl.simps nfa.bool_comb_gen_impl_code
            nfa.bool_comb_gen_impl.simps bool_comb_impl_aux_def
            nfa.nfa.NFA_construct_reachable_prod_interval_impl_code_def
            nfa.nfa.NFA_construct_reachable_interval_impl_code_def
            nfa.nfa_concat_impl_code nfa.nfa_concat_impl.simps
            nfa.nfa_concat_gen_impl.simps nfa.nfa.nfa_selectors_def
            concat_impl_aux_def 
  apply (unfold split_def snd_conv fst_conv prod.collapse
                nfa.nfa.rename_states_gen_impl.simps)
  apply (rule refine_transfer | assumption | erule conjE)+
  done



definition forward_analysis_impl where
  "forward_analysis_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa 
                     it_1_nfa' it_2_nfa' it_3_nfa im1 im2 a b 
                     S rc rm = 
   WHILET (\<lambda> (S, rm, R). \<not> (sss.isEmpty S)) (\<lambda> (S, rm, R). do {
      S' \<leftarrow> compute_ready_set_impl S rc R; 
     rm' \<leftarrow> language_vars_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa 
                     it_1_nfa' it_2_nfa' it_3_nfa im1 im2 a b S' rc rm;
   RETURN (sss.diff S S', rm', sss.union R S')}) (S, rm, sss.empty ())"

definition foward_rel where
 "foward_rel \<alpha> invar = {((x1,x2,x3),(y1,y2,y3)). 
                          (x2,y2) \<in> rm_eq_rel nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar \<and>
                          y1 = sss.\<alpha> x1 \<and> y3 = sss.\<alpha> x3 \<and> sss.invar x1 \<and> sss.invar x3}"

lemma forward_analysis_impl_correct:
  assumes S_OK: "S' = sss.\<alpha> S \<and> sss.invar S" and 
         rc_OK: "(\<And>v. (rc' v \<noteq> None) = (rc.lookup v rc \<noteq> None) \<and>
                  the (rc' v) = sp.\<alpha> (the (rc.lookup v rc)) \<and>
                  (rc' v = None) = (rc.lookup v rc = None))" and
         rc_invar: "rc.invar rc" and 
         rc_OK2: "(\<forall>v. (rc' v \<noteq> None) = (rc.lookup v rc \<noteq> None)) \<and>
         (\<forall>v. v \<in> dom rc' \<longrightarrow>
         {e. e \<in> the (rc' v)} = {e. e \<in> sp.\<alpha> (the (rc.lookup v rc))} \<and>
         (\<forall>(v1, v2)\<in>the (rc' v). v1 \<in> dom rm' \<and> v2 \<in> dom rm'))" and
         rm'_ok: "dom rm' = S'" and
         rm_ok: "(rm.invar rm) \<and>  
                (\<forall> v. (rm' v) \<noteq> None \<longleftrightarrow> (rm.lookup v rm) \<noteq> None) \<and>
                (\<forall> v. rm' v \<noteq> None \<longrightarrow> NFA (the (rm' v)) \<and> 
                        \<L> (the (rm' v)) = 
                        \<L> (nfa.nfa.nfa_\<alpha> (the (rm.lookup v rm))) \<and>
                        nfa.nfa.nfa_invar_NFA (the (rm.lookup v rm)))"
    and qm_ops_OK: "StdMap qm_ops1"
    and it_1_nfa_OK: "lts_succ_label_it nfa.d_nfa.\<alpha> nfa.d_nfa.invar it_1_nfa"
    and it_2_nfa_OK: "lts_succ_it nfa.d_nfa.\<alpha> nfa.d_nfa.invar it_2_nfa"
    and \<Delta>_\<A>1: "\<And> n1. nfa.nfa.nfa_invar_NFA n1 \<Longrightarrow> 
          \<exists>D1. {(q, semI a, q')| q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa.nfa.nfa_\<alpha> n1) \<and>
               finite D1"
    and \<Delta>_\<A>2: "\<And> n2. nfa.nfa.nfa_invar_NFA n2 \<Longrightarrow> 
          \<exists>D2. {(q, semI a, q')| q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa.nfa_\<alpha> n2) \<and>
               finite D2"
    and \<Delta>_it_ok1: "\<And> q D1 n1. {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa.nfa_\<alpha> n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa.nfa_invar_NFA n1 \<Longrightarrow>
       set_iterator_genord (it_1_nfa (nfa.nfa.nfa_trans n1) q) {(a, q'). (q, a, q') \<in> D1}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok2: "\<And> q D2 n2 a. {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = 
       \<Delta> (nfa.nfa.nfa_\<alpha> n2) \<Longrightarrow>
       finite D2 \<Longrightarrow>
       nfa.nfa.nfa_invar_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_2_nfa (nfa.nfa.nfa_trans n2) q a) 
    {(a, q'). (q, a, q') \<in> D2}
        (\<lambda>_ _. True)" and
    sem_OK: "\<And>n1 n2 D1 D2.
      {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa.nfa.nfa_\<alpha> n1) \<Longrightarrow>
      {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa.nfa_\<alpha> n2) \<Longrightarrow>
      nfa.nfa.nfa_invar_NFA n1 \<Longrightarrow>
      nfa.nfa.nfa_invar_NFA n2 \<Longrightarrow>
      \<forall>q a b aa ba q'.
         (q, ((a, b), aa, ba), q')
         \<in> {(q, a, q').
             (q, a, q')
             \<in> {((q1, q2), (a1, a2), q1', q2') |q1 a1 q1' q2 a2 q2'.
                 (q1, a1, q1') \<in> D1 \<and> (q2, a2, q2') \<in> D2}} \<longrightarrow>
         a \<le> b \<and> aa \<le> ba"       
    and qm_ops2_OK: "StdMap qm_ops2"
    and wf_target: "nfa_dfa_by_lts_interval_defs s_ops ss_ops l_ops d_nfa_ops dd_nfa_ops"
    and im_OK: "set_image nfa.s.\<alpha> nfa.s.invar (set_op_\<alpha> ss_ops) (set_op_invar ss_ops) im1"
    and im2_OK: "lts_image nfa.d_nfa.\<alpha> nfa.d_nfa.invar 
                 (clts_op_\<alpha> dd_nfa_ops) (clts_op_invar dd_nfa_ops) im2"
    and it_1_nfa'_OK: "lts_succ_label_it nfa.dd_nfa.\<alpha> nfa.dd_nfa.invar it_1_nfa'"
    and it_2_nfa'_OK: "lts_succ_label_it nfa.dd_nfa.\<alpha> nfa.dd_nfa.invar it_2_nfa'"
    and it_3_nfa_OK: "lts_connect_it nfa.dd_nfa.\<alpha> nfa.dd_nfa.invar 
                                     nfa.ss.\<alpha> nfa.ss.invar it_3_nfa"
    and \<Delta>_\<A>1': "\<And> n1. nfa.nfa_invarp_NFA n1 \<Longrightarrow> 
          \<exists>D1. {(q, semI a, q')| q a q'. (q, a, q') \<in> D1} = 
                \<Delta> (nfa.nfa_\<alpha>p n1) \<and>
               finite D1"
    and \<Delta>_\<A>2': "\<And> n2. nfa.nfa_invarp_NFA n2 \<Longrightarrow> 
          \<exists>D2. {(q, semI a, q')| q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha>p n2) \<and>
               finite D2"
    and \<Delta>_it_ok1': "\<And> q D1 n1. {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa_\<alpha>p n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa_invarp_NFA n1 \<Longrightarrow>
       set_iterator_genord (it_1_nfa' (nfa.nfa.nfa_transp 
                    n1) q) {(a, q')| a q'. 
          (q, a, q') \<in> D1}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok2': "\<And> q D2 n2. {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = 
       \<Delta> (nfa.nfa_\<alpha>p n2) \<Longrightarrow>
       finite D2 \<Longrightarrow>
       nfa.nfa_invarp_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_2_nfa' (nfa.nfa.nfa_transp 
              n2) q) 
    {(a, q')| a q'. (q, a, q') \<in> D2}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok3: "\<And> q D1 n1 n2. 
       {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa_\<alpha>p n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa_invarp_NFA n1 \<Longrightarrow>
       nfa.nfa_invarp_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_3_nfa (nfa.nfa.nfa_transp n1) 
                                     (nfa.nfa.nfa_acceptingp n1)
                                     (nfa.nfa.nfa_initialp n2)
                                      q)
       {(a, q')| a q' q''. (q, a, q'') \<in> D1 \<and> q'' \<in> (nfa.ss.\<alpha> (nfa.nfa.nfa_acceptingp n1))
                                   \<and> q' \<in> (nfa.ss.\<alpha> (nfa.nfa.nfa_initialp n2))}
        (\<lambda>_ _. True)"
    and inj_12: "\<And> q n1 n2 D1 D2. 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (nfa.nfa_\<alpha>p n1) \<and> finite D1 \<Longrightarrow> 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha>p n2) \<and> finite D2 \<Longrightarrow>
      nfa.nfa_invarp_NFA n1 \<Longrightarrow> nfa.nfa_invarp_NFA n2 \<Longrightarrow>
      inj_on (\<lambda>(a, y). (semI a, y))
      {(a, q').
       (q, a, q')
        \<in> {(q, a, q').
          (q, a, q') \<in> D1 \<or>
          (q, a, q') \<in> D2 \<or>
          (q, a, q')
            \<in> {uu.
              \<exists>q a q' q''.
                 uu = (q, a, q') \<and>
                 (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (nfa.nfa_\<alpha>p n1) \<and> q' \<in> \<I> (nfa.nfa_\<alpha>p n2)}}}"
    and a_neq_b: "a \<noteq> b"
  shows "forward_analysis_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa 
                     it_1_nfa' it_2_nfa' it_3_nfa im1 im2 a b 
                     S rc rm
        \<le> \<Down> (foward_rel nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar) 
        (Forward_Analysis S' rc' rm' a b)"
  unfolding forward_analysis_impl_def Forward_Analysis_def
  apply (refine_rcg)
  unfolding foward_rel_def
  apply simp
  apply (rule_tac conjI)
  unfolding rm_eq_rel_def L_eq_def
  using rm_ok S_OK 
  apply simp
  apply (simp add: nfa.nfa_dfa_\<alpha>_def nfa.nfa_dfa_invar_def)
  using S_OK sss.correct 
  apply blast
  using S_OK sss.correct 
  apply force
  apply (subgoal_tac 
             "compute_ready_set_impl x1b rc x2c \<le> \<Down> (build_rel sss.\<alpha> sss.invar)
              (compute_ready_set_abstract x1 rc' x2a)")
  apply assumption 
  defer
  apply (subgoal_tac 
        "language_vars_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa it_1_nfa' it_2_nfa' it_3_nfa
        im1 im2 a b S'a rc x1c
        \<le> \<Down> (rm_eq_rel nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar) 
        (language_vars S'aa rc' x1a a b)")
  apply assumption 
  defer
  defer
proof -
  {
    fix x x' x1 x2 x1a x2a x1b x2b x1c x2c
    assume p1: "(x, x')
       \<in> {((x1, x2, x3), y1, y2, y3).
           (x2, y2)
           \<in> {(rm, rm').
               local.rm.invar rm \<and>
               (\<forall>v. (local.rm.lookup v rm \<noteq> None) = (rm' v \<noteq> None)) \<and>
               (\<forall>v. rm' v \<noteq> None \<longrightarrow>
                    (the (local.rm.lookup v rm), the (rm' v))
                    \<in> {(x, y).
                        \<L> y = \<L> (nfa.nfa_dfa_\<alpha> x) \<and> NFA y \<and> nfa.nfa_dfa_invar x})} \<and>
           y1 = sss.\<alpha> x1 \<and> y3 = sss.\<alpha> x3 \<and> sss.invar x1 \<and> sss.invar x3}" and
    p2 : "case x of (S, rm, R) \<Rightarrow> \<not> sss.isEmpty S" and
    p3 : "case x' of (S1, rm1, R) \<Rightarrow> S1 \<noteq> {}" and
    p4 : "x2 = (x1a, x2a)" and
    p5 : "x' = (x1, x2)" and
    p6 : "x2b = (x1c, x2c)" and
    p7 : "x = (x1b, x2b)" 
    from this
    have pc1: "x1 = sss.\<alpha> x1b"
      by fastforce
    from p1 p4 p5 p6 p7
    have pc2: "sss.invar x2c"
      by fastforce
    from p1 p4 p5 p6 p7
    have pc3: "x2a = sss.\<alpha> x2c"
      by fastforce
    from compute_ready_set_impl_correct
        [of x1 x1b rc' rc x2c x2a, OF pc1 rc_OK rc_invar pc2 pc3]
    show "compute_ready_set_impl x1b rc x2c
       \<le> \<Down> (br sss.\<alpha> sss.invar) (compute_ready_set_abstract x1 rc' x2a)"
      by simp
  }
  {
    fix x x' x1 x2  x2a x1b x2b x1c x2c S'a S'aa
    fix x1a :: "'v \<Rightarrow> ('n::NFA_states, 'a) NFA_rec option"
    assume p1: "(x, x')
       \<in> {((x1, x2, x3), y1, y2, y3).
           (x2, y2)
           \<in> {(rm, rm').
               local.rm.invar rm \<and>
               (\<forall>v. (local.rm.lookup v rm \<noteq> None) = (rm' v \<noteq> None)) \<and>
               (\<forall>v. rm' v \<noteq> None \<longrightarrow>
                    (the (local.rm.lookup v rm), the (rm' v))
                    \<in> {(x, y).
                        \<L> y = \<L> (nfa.nfa_dfa_\<alpha> x) \<and> NFA y \<and> nfa.nfa_dfa_invar x})} \<and>
           y1 = sss.\<alpha> x1 \<and> y3 = sss.\<alpha> x3 \<and> sss.invar x1 \<and> sss.invar x3}" and
      p2 : "(S'a, S'aa) \<in> br sss.\<alpha> sss.invar" and
      p3 : "x2 = (x1a, x2a)" and
      p4 : "x' = (x1, x2)" and
      p5 : "x2b = (x1c, x2c)" and
      p6 : "x = (x1b, x2b)" and
      p7 : "case x' of
       (S1, rm1, R) \<Rightarrow>
         S' = S1 \<union> R \<and>
         S1 \<inter> R = {} \<and>
         dom rc' \<subseteq> S' \<and>
         dom rm' = S' \<and>
         dom rm1 = S' \<and>
         closureR R rc' \<and>
         (\<forall>v. v \<in> dom rm1 \<longrightarrow> NFA (the (rm1 v))) \<and>
         (\<forall>v\<in>S1. the (rm1 v) = the (rm' v)) \<and>
         (\<forall>x\<in>S' - S1.
             NFA (the (rm1 x)) \<and>
             (\<forall>w. NFA_accept (the (rm1 x)) w =
                  (NFA_accept (the (rm' x)) w \<and>
                   (x \<in> dom rc' \<longrightarrow>
                    (\<forall>(v1, v2)\<in>the (rc' x).
                        \<exists>w1 w2.
                           NFA_accept (the (rm1 v1)) w1 \<and>
                           NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2)))))"
    from p2 have pre1: "{v. v \<in> S'aa} = {v. v \<in> sss.\<alpha> S'a}"
      unfolding br_def
      by simp
    

    from p7 p4 p2 p3
    have cu1: "dom x1a = S'"
      by fastforce
    from this
    have pre2: "(\<forall>v. (rc' v \<noteq> None) = (rc.lookup v rc \<noteq> None)) \<and>
          (\<forall>v. v \<in> dom rc' \<longrightarrow>
              {e. e \<in> the (rc' v)} = {e. e \<in> sp.\<alpha> (the (rc.lookup v rc))} \<and>
           (\<forall>(v1, v2)\<in>the (rc' v). v1 \<in> dom x1a \<and> v2 \<in> dom x1a))"
      apply (rule_tac conjI)
      using p1 rc_OK2
      apply simp
      apply (rule allI)+
    proof 
      fix v
      assume pp1: "v \<in> dom rc'"
      show "{e. e \<in> the (rc' v)} = {e. e \<in> sp.\<alpha> (the (rc.lookup v rc))} \<and>
         (\<forall>(v1, v2)\<in>the (rc' v). v1 \<in> dom x1a \<and> v2 \<in> dom x1a)"
        apply (rule conjI)
        using pp1 rc_OK2 apply simp
        using pp1 rc_OK2 cu1 rm'_ok
        by blast
    qed

  from p1 p2 p3 p4 p7 p5 p6
  have "local.rm.invar x1c \<and>
            (\<forall>v. (local.rm.lookup v x1c \<noteq> None) = (x1a v \<noteq> None)) \<and>
            (\<forall>v. x1a v \<noteq> None \<longrightarrow>
                 (the (local.rm.lookup v x1c), the (x1a v))
                 \<in> {(x, y).
                     \<L> y = \<L> (nfa.nfa_dfa_\<alpha> x) \<and> NFA y \<and> nfa.nfa_dfa_invar x})"  
    by auto
  from this
  have pre3: "local.rm.invar x1c \<and>
              (\<forall>v. (x1a v \<noteq> None) = (local.rm.lookup v x1c \<noteq> None)) \<and>
              (\<forall>v. x1a v \<noteq> None \<longrightarrow>  NFA (the (x1a v)) \<and>
               \<L> (the (x1a v)) = \<L> (nfa.nfa.nfa_\<alpha> (the (local.rm.lookup v x1c))) \<and>
               nfa.nfa.nfa_invar_NFA (the (local.rm.lookup v x1c)))"
    unfolding nfa.nfa.nfa_invar_NFA_def nfa.nfa_dfa_invar_def
    by (simp add: nfa.nfa_dfa_\<alpha>_def)

  note language_vars_impl_correct = language_vars_impl_correct
      [of S'aa S'a rc' rc x1a x1c  qm_ops1 it_1_nfa it_2_nfa qm_ops2 
          im1 im2 it_1_nfa' it_2_nfa' it_3_nfa a b, OF pre1 pre2 pre3 qm_ops_OK it_1_nfa_OK it_2_nfa_OK \<Delta>_\<A>1 \<Delta>_\<A>2 \<Delta>_it_ok1 \<Delta>_it_ok2
          sem_OK qm_ops2_OK wf_target im_OK im2_OK it_1_nfa'_OK it_2_nfa'_OK
          it_3_nfa_OK \<Delta>_\<A>1' \<Delta>_\<A>2' \<Delta>_it_ok1' \<Delta>_it_ok2' \<Delta>_it_ok3 inj_12 a_neq_b]
    from this
    show "language_vars_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa it_1_nfa' it_2_nfa' it_3_nfa
        im1 im2 a b S'a rc x1c
       \<le> \<Down> (rm_eq_rel nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar) (language_vars S'aa rc' x1a a b)"
      by fastforce
  }
  {
    fix x x' x1 x2 x1a x2a x1b x2b x1c x2c S'a S'aa rm'a rm'aa
    assume p1: "(x, x')
       \<in> {((x1, x2, x3), y1, y2, y3).
           (x2, y2)
           \<in> {(rm, rm').
               local.rm.invar rm \<and>
               (\<forall>v. (local.rm.lookup v rm \<noteq> None) = (rm' v \<noteq> None)) \<and>
               (\<forall>v. rm' v \<noteq> None \<longrightarrow>
                    (the (local.rm.lookup v rm), the (rm' v))
                    \<in> {(x, y).
                        \<L> y = \<L> (nfa.nfa_dfa_\<alpha> x) \<and> NFA y \<and> nfa.nfa_dfa_invar x})} \<and>
           y1 = sss.\<alpha> x1 \<and> y3 = sss.\<alpha> x3 \<and> sss.invar x1 \<and> sss.invar x3}" and
       p2: "x2 = (x1a, x2a)" and
       p3: "x' = (x1, x2)" and
       p4: "x2b = (x1c, x2c)" and
       p5: "x = (x1b, x2b)" and
       p6:  "(rm'a, rm'aa) \<in> rm_eq_rel nfa.nfa_dfa_\<alpha> nfa.nfa_dfa_invar" and
       p7: "(S'a, S'aa) \<in> br sss.\<alpha> sss.invar"
    show "((sss.diff x1b S'a, rm'a, sss.union x2c S'a), x1 - S'aa, rm'aa, x2a \<union> S'aa)
       \<in> {((x1, x2, x3), y1, y2, y3).
           (x2, y2)
           \<in> {(rm, rm').
               local.rm.invar rm \<and>
               (\<forall>v. (local.rm.lookup v rm \<noteq> None) = (rm' v \<noteq> None)) \<and>
               (\<forall>v. rm' v \<noteq> None \<longrightarrow>
                    (the (local.rm.lookup v rm), the (rm' v))
                    \<in> {(x, y).
                        \<L> y = \<L> (nfa.nfa_dfa_\<alpha> x) \<and> NFA y \<and> nfa.nfa_dfa_invar x})} \<and>
           y1 = sss.\<alpha> x1 \<and> y3 = sss.\<alpha> x3 \<and> sss.invar x1 \<and> sss.invar x3}"
      apply simp
      apply (rule conjI)+
      using p6 unfolding rm_eq_rel_def
      apply simp
      apply (rule conjI)
      using p6 unfolding rm_eq_rel_def
      apply simp
      apply (rule conjI)
      using p6 unfolding rm_eq_rel_def L_eq_def
      apply simp
    proof -
     {
       from p1 p2 p3 p4 p5 
       have tmp1: "x1 = sss.\<alpha> x1b \<and> x2a = sss.\<alpha> x2c \<and> sss.invar x1b \<and> sss.invar x2c"
         by blast
       from p7
       have tmp2: "S'aa = sss.\<alpha> S'a \<and> sss.invar S'a"
         unfolding br_def
         by blast
       from tmp1 tmp2 sss.correct
       show "x1 - S'aa = sss.\<alpha> (sss.diff x1b S'a) \<and>
             x2a \<union> S'aa = sss.\<alpha> (sss.union x2c S'a) \<and>
             sss.invar (sss.diff x1b S'a) \<and> sss.invar (sss.union x2c S'a)"         
       proof -
         show ?thesis
           using sss.diff_correct(1) sss.diff_correct(2) 
                 sss.union_correct(1) sss.union_correct(2) tmp1 tmp2 
                 by presburger
             qed
     } qed
  } qed

schematic_goal forward_analysis_impl: 
  fixes D_it1 :: "'v_set \<times> 'mm \<times> 'v_set \<Rightarrow> ('v, 'v_set) set_iterator" and
        D_it2 :: "'v \<Rightarrow> 'mc \<Rightarrow> ('v \<times> 'v, 'v_set) set_iterator" and
        D_it3 :: "'v_set \<Rightarrow> ('v, 'mm) set_iterator" and
        D_it4 :: "'v \<Rightarrow> 'mc \<Rightarrow> 
                   ('v \<times> 'v, 'q_set \<times> 'd_nfa \<times> 'q_set \<times> 'q_set) set_iterator" 
assumes D_it1_OK [rule_format, refine_transfer]: 
         "\<And> x. set_iterator (D_it1 x) 
          {v. v \<in> sss.\<alpha> (fst x)}" and
        D_it2_OK [rule_format, refine_transfer]: 
         "\<And> v rc . v \<in> dom (rc.\<alpha> rc) \<longrightarrow> (set_iterator (D_it2 v rc) 
          {e. e \<in> sp.\<alpha> (the (rc.lookup v rc))})" and
        D_it3_OK [rule_format, refine_transfer]: 
         "\<And>sp. set_iterator (D_it3 sp) 
          {v. v \<in> sss.\<alpha> sp}" and
        D_it4_OK [rule_format, refine_transfer]: 
         "\<And> v rc. (set_iterator (D_it4 v rc) 
                    {e. e \<in> sp.\<alpha> (the (rc.lookup v rc))})" and
        rc_OK [rule_format, refine_transfer]:
         "\<And>x xa \<sigma>. rc.lookup xa rc \<noteq> None \<Longrightarrow> xa \<in> dom (rc.\<alpha> rc)"
shows "RETURN ?f \<le> forward_analysis_impl qm_ops1 qm_ops2 it_1_nfa it_2_nfa 
                     it_1_nfa' it_2_nfa' it_3_nfa im1 im2 a b SI rc rm"
  unfolding forward_analysis_impl_def 
  unfolding language_vars_impl_def
            compute_dependent_impl_def 
            lang_var_impl_def 
            compute_ready_set_impl_def 
            nfa.bool_comb_impl_code
            nfa.bool_comb_impl.simps nfa.bool_comb_gen_impl_code
            nfa.bool_comb_gen_impl.simps bool_comb_impl_aux_def 
            nfa.nfa.NFA_construct_reachable_prod_interval_impl_code_def
            nfa.nfa.NFA_construct_reachable_interval_impl_code_def
            nfa.nfa_concat_impl_code nfa.nfa_concat_impl.simps
            nfa.nfa_concat_gen_impl.simps nfa.nfa.nfa_selectors_def
            concat_impl_aux_def 
            nfa.nfa_concat_rename_impl.simps 
  apply (unfold split_def snd_conv fst_conv prod.collapse)
  apply (rule refine_transfer | assumption | erule conjE)+
  done



definition forward_analysis_impl_code where
  "forward_analysis_impl_code qm_ops1 qm_ops2 
     it_1_nfa it_2_nfa it_1_nfa' it_2_nfa'
     it_3_nfa D_it1 D_it2 D_it3 D_it4 im1 im2 a b SI rc rm = 
     (while (\<lambda>p. \<not> sss.isEmpty (fst p))
    (\<lambda>x. let xa = D_it1 x (\<lambda>_. True)
                   (\<lambda>xa \<sigma>.
                       let xb = if rc.lookup xa rc \<noteq> None
                                then D_it2 xa rc (\<lambda>_. True)
                                      (\<lambda>xb \<sigma>'. sss.ins (fst xb) (sss.ins (snd xb) \<sigma>'))
                                      (sss.empty ())
                                else sss.empty ()
                       in if sss.subset xb (snd (snd x)) then sss.ins xa \<sigma> else \<sigma>)
                   (sss.empty ());
             xb = D_it3 xa (\<lambda>_. True)
                   (\<lambda>xb \<sigma>.
                       if rc.lookup xb rc \<noteq> None
                       then let xc = D_it4 xb rc (\<lambda>_. True)
                                      (\<lambda>xc \<sigma>'.
                                          let p =
    foldl
     (\<lambda>p q. ((map_op_update_dj qm_ops1 (id q) (states_enumerate (snd (fst p)))
               (fst (fst p)),
              Suc (snd (fst p))),
             nfa.s.ins_dj (states_enumerate (snd (fst p))) (snd p)))
     ((map_op_empty qm_ops1 (), 0), nfa.s.empty ())
     (List.product (nfa.s.to_list (fst (snd (snd \<sigma>'))))
       (nfa.s.to_list
         (fst (snd (snd (let nA1 =
                               nfa.rename_states_impl im1 im2
                                (the (local.rm.lookup (fst xc) \<sigma>)) (Pair a);
                             AA2 =
                               nfa.rename_states_impl im1 im2
                                (the (local.rm.lookup (snd xc) \<sigma>)) (Pair b);
                             p = foldl
                                  (\<lambda>p q. ((map_op_update_dj qm_ops2 (id q)
(states_enumerate (snd (fst p))) (fst (fst p)),
                                           Suc (snd (fst p))),
                                          nfa.s.ins_dj (states_enumerate (snd (fst p)))
                                           (snd p)))
                                  ((map_op_empty qm_ops2 (), 0), nfa.s.empty ())
                                  (if \<not> nfa.ss.isEmpty
                                          (nfa.ss.inter (nfa.nfa.nfa_initialp nA1)
(nfa.nfa.nfa_acceptingp nA1))
                                   then nfa.ss.to_list (nfa.nfa.nfa_initialp nA1) @
                                        nfa.ss.to_list (nfa.nfa.nfa_initialp AA2)
                                   else nfa.ss.to_list (nfa.nfa.nfa_initialp nA1));
                             p = worklist (\<lambda>_. True)
                                  (\<lambda>p q. let r =
   the (map_op_lookup qm_ops2 (id q) (fst (fst p)))
                                         in if nfa.s.memb r (fst (snd p)) then (p, [])
else let pa = tri_union_iterator (it_1_nfa' (nfa.nfa.nfa_transp nA1))
               (it_2_nfa' (nfa.nfa.nfa_transp AA2))
               (it_3_nfa (nfa.nfa.nfa_transp nA1) (nfa.nfa.nfa_acceptingp nA1)
                 (nfa.nfa.nfa_initialp AA2))
               q (\<lambda>_. True)
               (\<lambda>p pa.
                   if nempI (fst p)
                   then let r'_opt =
                              map_op_lookup qm_ops2 (id (snd p)) (fst (fst pa));
                            pb = if r'_opt = None
                                 then let r'' = states_enumerate (snd (fst pa))
                                      in ((map_op_update_dj qm_ops2 (id (snd p)) r''
(fst (fst pa)),
                                           Suc (snd (fst pa))),
                                          r'')
                                 else (fst pa, the r'_opt)
                        in (fst pb, nfa.d_nfa.add r (fst p) (snd pb) (fst (snd pa)),
                            snd p # snd (snd pa))
                   else pa)
               (fst p, fst (snd (snd p)), [])
     in ((fst pa, nfa.s.ins_dj r (fst (snd p)), fst (snd pa), fst (snd (snd (snd p))),
          if nfa.ss.memb q (nfa.nfa.nfa_acceptingp AA2)
          then nfa.s.ins_dj r (snd (snd (snd (snd p)))) else snd (snd (snd (snd p)))),
         snd (snd pa)))
                                  ((fst p, nfa.s.empty (), nfa.d_nfa.empty, snd p,
                                    nfa.s.empty ()),
                                   if \<not> nfa.ss.isEmpty
                                          (nfa.ss.inter (nfa.nfa.nfa_initialp nA1)
(nfa.nfa.nfa_acceptingp nA1))
                                   then nfa.ss.to_list (nfa.nfa.nfa_initialp nA1) @
                                        nfa.ss.to_list (nfa.nfa.nfa_initialp AA2)
                                   else nfa.ss.to_list (nfa.nfa.nfa_initialp nA1))
                         in snd (fst p)))))));
  p = worklist (\<lambda>_. True)
       (\<lambda>p q. let r = the (map_op_lookup qm_ops1 (id q) (fst (fst p)))
              in if nfa.s.memb r (fst (snd p)) then (p, [])
                 else let pa = product_iterator (it_1_nfa (fst (snd \<sigma>')))
                                (it_2_nfa
                                  (fst (snd (let nA1 =
       nfa.rename_states_impl im1 im2 (the (local.rm.lookup (fst xc) \<sigma>))
        (Pair a);
     AA2 =
       nfa.rename_states_impl im1 im2 (the (local.rm.lookup (snd xc) \<sigma>))
        (Pair b);
     p = foldl
          (\<lambda>p q. ((map_op_update_dj qm_ops2 (id q) (states_enumerate (snd (fst p)))
                    (fst (fst p)),
                   Suc (snd (fst p))),
                  nfa.s.ins_dj (states_enumerate (snd (fst p))) (snd p)))
          ((map_op_empty qm_ops2 (), 0), nfa.s.empty ())
          (if \<not> nfa.ss.isEmpty
                  (nfa.ss.inter (nfa.nfa.nfa_initialp nA1) (nfa.nfa.nfa_acceptingp nA1))
           then nfa.ss.to_list (nfa.nfa.nfa_initialp nA1) @
                nfa.ss.to_list (nfa.nfa.nfa_initialp AA2)
           else nfa.ss.to_list (nfa.nfa.nfa_initialp nA1));
     p = worklist (\<lambda>_. True)
          (\<lambda>p q. let r = the (map_op_lookup qm_ops2 (id q) (fst (fst p)))
                 in if nfa.s.memb r (fst (snd p)) then (p, [])
                    else let pa = tri_union_iterator
                                   (it_1_nfa' (nfa.nfa.nfa_transp nA1))
                                   (it_2_nfa' (nfa.nfa.nfa_transp AA2))
                                   (it_3_nfa (nfa.nfa.nfa_transp nA1)
                                     (nfa.nfa.nfa_acceptingp nA1)
                                     (nfa.nfa.nfa_initialp AA2))
                                   q (\<lambda>_. True)
                                   (\<lambda>p pa.
                                       if nempI (fst p)
                                       then let r'_opt =
      map_op_lookup qm_ops2 (id (snd p)) (fst (fst pa));
    pb = if r'_opt = None
         then let r'' = states_enumerate (snd (fst pa))
              in ((map_op_update_dj qm_ops2 (id (snd p)) r'' (fst (fst pa)),
                   Suc (snd (fst pa))),
                  r'')
         else (fst pa, the r'_opt)
in (fst pb, nfa.d_nfa.add r (fst p) (snd pb) (fst (snd pa)), snd p # snd (snd pa))
                                       else pa)
                                   (fst p, fst (snd (snd p)), [])
                         in ((fst pa, nfa.s.ins_dj r (fst (snd p)), fst (snd pa),
                              fst (snd (snd (snd p))),
                              if nfa.ss.memb q (nfa.nfa.nfa_acceptingp AA2)
                              then nfa.s.ins_dj r (snd (snd (snd (snd p))))
                              else snd (snd (snd (snd p)))),
                             snd (snd pa)))
          ((fst p, nfa.s.empty (), nfa.d_nfa.empty, snd p, nfa.s.empty ()),
           if \<not> nfa.ss.isEmpty
                  (nfa.ss.inter (nfa.nfa.nfa_initialp nA1) (nfa.nfa.nfa_acceptingp nA1))
           then nfa.ss.to_list (nfa.nfa.nfa_initialp nA1) @
                nfa.ss.to_list (nfa.nfa.nfa_initialp AA2)
           else nfa.ss.to_list (nfa.nfa.nfa_initialp nA1))
 in snd (fst p)))))
                                q (\<lambda>_. True)
                                (\<lambda>p pa.
                                    if nempI (intersectI (fst (fst p)) (snd (fst p)))
                                    then let r'_opt =
   map_op_lookup qm_ops1 (id (snd p)) (fst (fst pa));
 pb = if r'_opt = None
      then let r'' = states_enumerate (snd (fst pa))
           in ((map_op_update_dj qm_ops1 (id (snd p)) r'' (fst (fst pa)),
                Suc (snd (fst pa))),
               r'')
      else (fst pa, the r'_opt)
                                         in (fst pb,
 nfa.d_nfa.add r (intersectI (fst (fst p)) (snd (fst p))) (snd pb) (fst (snd pa)),
 snd p # snd (snd pa))
                                    else pa)
                                (fst p, fst (snd (snd p)), [])
                      in ((fst pa, nfa.s.ins_dj r (fst (snd p)), fst (snd pa),
                           fst (snd (snd (snd p))),
                           if nfa.s.memb (fst q) (snd (snd (snd \<sigma>'))) \<and>
                              nfa.s.memb (snd q)
                               (snd (snd (snd (let nA1 =
         nfa.rename_states_impl im1 im2 (the (local.rm.lookup (fst xc) \<sigma>))
          (Pair a);
       AA2 =
         nfa.rename_states_impl im1 im2 (the (local.rm.lookup (snd xc) \<sigma>))
          (Pair b);
       p = foldl
            (\<lambda>p q. ((map_op_update_dj qm_ops2 (id q) (states_enumerate (snd (fst p)))
                      (fst (fst p)),
                     Suc (snd (fst p))),
                    nfa.s.ins_dj (states_enumerate (snd (fst p))) (snd p)))
            ((map_op_empty qm_ops2 (), 0), nfa.s.empty ())
            (if \<not> nfa.ss.isEmpty
                    (nfa.ss.inter (nfa.nfa.nfa_initialp nA1)
                      (nfa.nfa.nfa_acceptingp nA1))
             then nfa.ss.to_list (nfa.nfa.nfa_initialp nA1) @
                  nfa.ss.to_list (nfa.nfa.nfa_initialp AA2)
             else nfa.ss.to_list (nfa.nfa.nfa_initialp nA1));
       p = worklist (\<lambda>_. True)
            (\<lambda>p q. let r = the (map_op_lookup qm_ops2 (id q) (fst (fst p)))
                   in if nfa.s.memb r (fst (snd p)) then (p, [])
                      else let pa = tri_union_iterator
                                     (it_1_nfa' (nfa.nfa.nfa_transp nA1))
                                     (it_2_nfa' (nfa.nfa.nfa_transp AA2))
                                     (it_3_nfa (nfa.nfa.nfa_transp nA1)
                                       (nfa.nfa.nfa_acceptingp nA1)
                                       (nfa.nfa.nfa_initialp AA2))
                                     q (\<lambda>_. True)
                                     (\<lambda>p pa.
                                         if nempI (fst p)
                                         then let r'_opt =
        map_op_lookup qm_ops2 (id (snd p)) (fst (fst pa));
      pb = if r'_opt = None
           then let r'' = states_enumerate (snd (fst pa))
                in ((map_op_update_dj qm_ops2 (id (snd p)) r'' (fst (fst pa)),
                     Suc (snd (fst pa))),
                    r'')
           else (fst pa, the r'_opt)
  in (fst pb, nfa.d_nfa.add r (fst p) (snd pb) (fst (snd pa)), snd p # snd (snd pa))
                                         else pa)
                                     (fst p, fst (snd (snd p)), [])
                           in ((fst pa, nfa.s.ins_dj r (fst (snd p)), fst (snd pa),
                                fst (snd (snd (snd p))),
                                if nfa.ss.memb q (nfa.nfa.nfa_acceptingp AA2)
                                then nfa.s.ins_dj r (snd (snd (snd (snd p))))
                                else snd (snd (snd (snd p)))),
                               snd (snd pa)))
            ((fst p, nfa.s.empty (), nfa.d_nfa.empty, snd p, nfa.s.empty ()),
             if \<not> nfa.ss.isEmpty
                    (nfa.ss.inter (nfa.nfa.nfa_initialp nA1)
                      (nfa.nfa.nfa_acceptingp nA1))
             then nfa.ss.to_list (nfa.nfa.nfa_initialp nA1) @
                  nfa.ss.to_list (nfa.nfa.nfa_initialp AA2)
             else nfa.ss.to_list (nfa.nfa.nfa_initialp nA1))
   in snd (fst p)))))
                           then nfa.s.ins_dj r (snd (snd (snd (snd p))))
                           else snd (snd (snd (snd p)))),
                          snd (snd pa)))
       ((fst p, nfa.s.empty (), nfa.d_nfa.empty, snd p, nfa.s.empty ()),
        List.product (nfa.s.to_list (fst (snd (snd \<sigma>'))))
         (nfa.s.to_list
           (fst (snd (snd (let nA1 =
                                 nfa.rename_states_impl im1 im2
                                  (the (local.rm.lookup (fst xc) \<sigma>)) (Pair a);
                               AA2 =
                                 nfa.rename_states_impl im1 im2
                                  (the (local.rm.lookup (snd xc) \<sigma>)) (Pair b);
                               p = foldl
                                    (\<lambda>p q. ((map_op_update_dj qm_ops2 (id q)
  (states_enumerate (snd (fst p))) (fst (fst p)),
 Suc (snd (fst p))),
nfa.s.ins_dj (states_enumerate (snd (fst p))) (snd p)))
                                    ((map_op_empty qm_ops2 (), 0), nfa.s.empty ())
                                    (if \<not> nfa.ss.isEmpty
(nfa.ss.inter (nfa.nfa.nfa_initialp nA1) (nfa.nfa.nfa_acceptingp nA1))
                                     then nfa.ss.to_list (nfa.nfa.nfa_initialp nA1) @
                                          nfa.ss.to_list (nfa.nfa.nfa_initialp AA2)
                                     else nfa.ss.to_list (nfa.nfa.nfa_initialp nA1));
                               p = worklist (\<lambda>_. True)
                                    (\<lambda>p q. let r =
     the (map_op_lookup qm_ops2 (id q) (fst (fst p)))
                                           in if nfa.s.memb r (fst (snd p)) then (p, [])
  else let pa = tri_union_iterator (it_1_nfa' (nfa.nfa.nfa_transp nA1))
                 (it_2_nfa' (nfa.nfa.nfa_transp AA2))
                 (it_3_nfa (nfa.nfa.nfa_transp nA1) (nfa.nfa.nfa_acceptingp nA1)
                   (nfa.nfa.nfa_initialp AA2))
                 q (\<lambda>_. True)
                 (\<lambda>p pa.
                     if nempI (fst p)
                     then let r'_opt =
                                map_op_lookup qm_ops2 (id (snd p)) (fst (fst pa));
                              pb = if r'_opt = None
                                   then let r'' = states_enumerate (snd (fst pa))
                                        in ((map_op_update_dj qm_ops2 (id (snd p))
  r'' (fst (fst pa)),
 Suc (snd (fst pa))),
r'')
                                   else (fst pa, the r'_opt)
                          in (fst pb, nfa.d_nfa.add r (fst p) (snd pb) (fst (snd pa)),
                              snd p # snd (snd pa))
                     else pa)
                 (fst p, fst (snd (snd p)), [])
       in ((fst pa, nfa.s.ins_dj r (fst (snd p)), fst (snd pa), fst (snd (snd (snd p))),
            if nfa.ss.memb q (nfa.nfa.nfa_acceptingp AA2)
            then nfa.s.ins_dj r (snd (snd (snd (snd p)))) else snd (snd (snd (snd p)))),
           snd (snd pa)))
                                    ((fst p, nfa.s.empty (), nfa.d_nfa.empty, snd p,
                                      nfa.s.empty ()),
                                     if \<not> nfa.ss.isEmpty
(nfa.ss.inter (nfa.nfa.nfa_initialp nA1) (nfa.nfa.nfa_acceptingp nA1))
                                     then nfa.ss.to_list (nfa.nfa.nfa_initialp nA1) @
                                          nfa.ss.to_list (nfa.nfa.nfa_initialp AA2)
                                     else nfa.ss.to_list (nfa.nfa.nfa_initialp nA1))
                           in snd (fst p)))))))
                                          in snd (fst p))
                                      (the (local.rm.lookup xb \<sigma>))
                            in local.rm.update xb xc \<sigma>
                       else \<sigma>)
                   (fst (snd x))
         in (sss.diff (fst x) xa, xb, sss.union (snd (snd x)) xa))
    (SI, rm, sss.empty ()))"

schematic_goal forward_analysis_code :
  "forward_analysis_impl_code qm_ops1 qm_ops2 
     it_1_nfa it_2_nfa it_1_nfa' it_2_nfa'
     it_3_nfa D_it1 D_it2 D_it3 D_it4 SI rc rm = ?XXX1"
  unfolding forward_analysis_impl_code_def          
  by (rule refl)+

definition comp_indegree_v_imp  where
  "comp_indegree_v_imp v rc =
   (if ((rc.lookup v rc) \<noteq> None) then 
   FOREACH {e. e \<in> sp.\<alpha> (the (rc.lookup v rc))} 
           (\<lambda> (v1, v2) L. RETURN (v1 # v2 # L)) []
    else 
        RETURN []
    )"

lemma comp_indegree_v_imp_correct :
  fixes v rc rc'
  assumes rc_OK: "(rc v \<noteq> None \<longleftrightarrow> rc.lookup v rc' \<noteq> None) \<and>
                  (the (rc v) = sp.\<alpha> (the (rc.lookup v rc'))) \<and>
                  (rc v = None \<longleftrightarrow> (rc.lookup v rc') = None)"
  shows "(comp_indegree_v_imp v rc') \<le> \<Down> Id  (comp_indegree_v v rc)"
   unfolding comp_indegree_v_def
             comp_indegree_v_imp_def
  apply (refine_rcg)
   using rc_OK apply simp
   apply (subgoal_tac "inj_on id {e. e \<in> sp.\<alpha> (the (rc.lookup v rc'))}")
   apply assumption 
   apply simp
   using rc_OK apply simp
   apply simp
   by auto

definition comp_indegree_imp where
  "comp_indegree_imp S rc = 
    FOREACH 
    {v. v \<in> sss.\<alpha> S}
    (\<lambda> v l. do {
        l' \<leftarrow> comp_indegree_v_imp v rc;
        RETURN (l' @ l)
    }) []"

lemma comp_indegree_imp_correct :
  fixes S S' rc rc'
  assumes  S_ok: "S = sss.\<alpha> S'" and
          rc_OK: "\<And> v. v \<in> S \<longrightarrow> ((rc v \<noteq> None \<longleftrightarrow> rc.lookup v rc' \<noteq> None) \<and>
                  (the (rc v) = sp.\<alpha> (the (rc.lookup v rc'))) \<and>
                  (rc v = None \<longleftrightarrow> (rc.lookup v rc') = None))"
  shows "(comp_indegree_imp S' rc') \<le> \<Down> Id  (comp_indegree S rc)"
   unfolding comp_indegree_def
             comp_indegree_imp_def
   apply (refine_rcg)
   apply (subgoal_tac "inj_on id {v. v \<in> sss.\<alpha> S'}")
   apply assumption   
   using rc_OK apply simp
   using S_ok apply simp
   using rc_OK apply simp
   apply simp
   apply (subgoal_tac 
        "comp_indegree_v_imp x rc' \<le> \<Down> Id (comp_indegree_v x rc)")
   apply assumption
   using comp_indegree_v_imp_correct
   apply (meson rc_OK subsetD)
   by simp 

definition indegree_imp where
"indegree_imp S rc = do {
  res \<leftarrow> comp_indegree_imp S rc;
  if distinct res then RETURN True else RETURN False
}"


lemma indegree_imp_correct :
  fixes S S' rc rc'
  assumes  S_ok: "S = sss.\<alpha> S'" and
          rc_OK: "\<And> v. v \<in> S \<longrightarrow> ((rc v \<noteq> None \<longleftrightarrow> rc.lookup v rc' \<noteq> None) \<and>
                  (the (rc v) = sp.\<alpha> (the (rc.lookup v rc'))) \<and>
                  (rc v = None \<longleftrightarrow> (rc.lookup v rc') = None))"
  shows "(indegree_imp S' rc') \<le> \<Down> Id  (indegree S rc)"
   unfolding indegree_imp_def
             indegree_def
   apply (refine_rcg)
   apply (subgoal_tac "comp_indegree_imp S' rc' \<le> \<Down> Id (comp_indegree S rc)")
   apply assumption   
   using rc_OK S_ok comp_indegree_imp_correct
   apply simp
   by simp


schematic_goal indegree_imp_code :
  fixes D_it1 :: "'v_set \<Rightarrow> ('v, 'v list) set_iterator" and
        D_it2 :: "'v \<Rightarrow> 'mc \<Rightarrow> ('v \<times> 'v, 'v list) set_iterator"
assumes D_it1_OK[rule_format, refine_transfer]: 
         "set_iterator (D_it1 S) 
          {v. v \<in> sss.\<alpha> S}" and
        D_it2_OK [rule_format,refine_transfer]: 
         "\<And> v. v \<in> dom (rc.\<alpha> rc) \<longrightarrow> (set_iterator (D_it2 v rc) 
          {e. e \<in> sp.\<alpha> (the (rc.lookup v rc))})" and
        rc_OK [rule_format, refine_transfer]:
         "\<And> v \<sigma>. rc.lookup v rc \<noteq> None \<Longrightarrow>  v \<in> dom (rc.\<alpha> rc)"
  shows "RETURN ?f \<le> indegree_imp S rc"
  unfolding indegree_imp_def comp_indegree_imp_def
            comp_indegree_v_imp_def
  apply (unfold split_def snd_conv fst_conv prod.collapse)
  apply (rule refine_transfer | assumption | erule conjE)+ 
  done

definition indegree_code where
"indegree_code it1 it2 S rc= (let x = it1 S (\<lambda>_. True)
            (\<lambda>x \<sigma>. let xa = if rc.lookup x rc \<noteq> None
                            then it2 x rc (\<lambda>_. True)
                                  (\<lambda>xa \<sigma>'. fst xa # snd xa # \<sigma>') []
                            else []
                   in xa @ \<sigma>)
            []
   in if distinct x then True else False)"

schematic_goal uniq_indegree_code :
  "indegree_code it1 it2 S rc = ?XXX1"
  unfolding indegree_code_def          
  by (rule refl)+
  

definition gen_S_from_list where
    "gen_S_from_list l = List.foldl (\<lambda> S a. sss.ins a S) (sss.empty ()) l"


schematic_goal gen_S_from_list_code :
    "gen_S_from_list l = ?XXX1"
  unfolding gen_S_from_list_def
  by (rule refl)+

definition S_to_list where
    "S_to_list s = sss.to_list s"

schematic_goal S_to_list_code :
    "S_to_list s = ?XXX1"
  unfolding S_to_list_def
  by (rule refl)+

term rm.update
definition gen_rm_from_list where
    "gen_rm_from_list l = List.foldl (\<lambda> M a. rm.update (fst a) (snd a) 
    M) (rm.empty ()) l"



schematic_goal gen_rm_from_list_code :
    "gen_rm_from_list l = ?XXX1"
  unfolding gen_rm_from_list_def
  by (rule refl)+

definition rm_to_list where
    "rm_to_list l = rm.to_list l"

schematic_goal rm_to_list_code :
    "rm_to_list l = ?XXX1"
  unfolding rm_to_list_def
  by (rule refl)+

term List.foldl

definition rc_to_list where
    "rc_to_list l = List.foldl (\<lambda> l1 s. (fst s, sp.\<alpha> (snd s)) # l1) [] (rc.to_list l)"

schematic_goal rc_to_list_code :
    "rc_to_list l = ?XXX1"
  unfolding rc_to_list_def
  by (rule refl)+


definition gen_rc_from_list where
    "gen_rc_from_list l = List.foldl (\<lambda> M a. rc.update (fst a) 
    (List.foldl (\<lambda> S a. sp.ins a S) (sp.empty ()) (snd a)) M) 
    (rc.empty ()) l"


schematic_goal gen_rc_from_list_code :
    "gen_rc_from_list l = ?XXX1"
  unfolding gen_rc_from_list_def
  by (rule refl)+


end

term Forward_Analysis_Impl

interpretation forward_analysis_impl_defs: 
        Forward_Analysis_Impl rs_ops rs_ops rs_ops rs_lts_ops 
                              rs_lts_ops rs_ops rs_ops rm_ops rm_ops rm_ops
  by intro_locales

definition lookup_aux where
      "lookup_aux = forward_analysis_impl_defs.lookup_aux"

schematic_goal lookup_aux_code :
  "lookup_aux v rc = ?XXX1"
  unfolding lookup_aux_def forward_analysis_impl_defs.lookup_aux_def
  by (rule refl)+

definition rs_gen_S_from_list where
      "rs_gen_S_from_list = forward_analysis_impl_defs.gen_S_from_list"

definition rs_rm_to_list where
      "rs_rm_to_list = forward_analysis_impl_defs.rm_to_list"

definition rs_rc_to_list where
      "rs_rc_to_list = forward_analysis_impl_defs.rc_to_list"

definition rs_gen_rm_from_list where
      "rs_gen_rm_from_list = forward_analysis_impl_defs.gen_rm_from_list"

definition rs_indegree where
      "rs_indegree = 
            forward_analysis_impl_defs.indegree_code 
            (\<lambda> x. rs_iteratei x)
            (\<lambda> v rc. rs_iteratei (the (lookup_aux v rc)))"

term forward_analysis_impl_defs.gen_rc_from_list
definition rs_gen_rc_from_list where
      "rs_gen_rc_from_list = forward_analysis_impl_defs.gen_rc_from_list"


definition rs_S_to_list where
      "rs_S_to_list = forward_analysis_impl_defs.S_to_list"



definition "rs_forward_analysis =
            forward_analysis_impl_defs.forward_analysis_impl_code
            rm_ops rm_ops rs_lts_succ_label_it rs_lts_succ_it
            rs_lts_succ_label_it rs_lts_succ_label_it 
            rs_lts_connect_it 
            (\<lambda> x. rs_iteratei (fst x))
            (\<lambda> v rc. rs_iteratei (the (lookup_aux v rc)))
            (\<lambda> x. rs_iteratei x)
            (\<lambda> v rc. rs_iteratei (the (lookup_aux v rc)))
            (\<lambda> f S. rs.iteratei S (\<lambda> _. True) (\<lambda> b S'. rs.ins (f b) S') (rs.empty ()))
            rs_lts_image"

lemmas compute_ready_set_defs =
  lookup_aux_def
  rs_forward_analysis_def
  rs_gen_S_from_list_def
  rs_gen_rm_from_list_def
  rs_gen_rc_from_list_def
  rs_S_to_list_def
  rs_rm_to_list_def
  rs_rc_to_list_def
  rs_indegree_def


 



lemmas rs_lookup_aux_code [code] = 
      forward_analysis_impl_defs.lookup_aux_code[folded compute_ready_set_defs]


lemmas rs_forward_analysis_code [code] = 
       forward_analysis_impl_defs.forward_analysis_code [of
       rm_ops 
       rm_ops 
       rs_lts_succ_label_it 
       rs_lts_succ_it
       rs_lts_succ_label_it 
       rs_lts_succ_label_it 
       rs_lts_connect_it
       "(\<lambda> x. rs_iteratei (fst x))"
       "(\<lambda> v rc. rs_iteratei (the (lookup_aux v rc)))"
       "rs_iteratei"
       "(\<lambda> v rc. rs_iteratei (the (lookup_aux v rc)))"
       "\<lambda> f S. rs.iteratei S (\<lambda> _. True) (\<lambda> b S'. rs.ins (f b) S') (rs.empty ())"
       rs_lts_image
        ,
        folded compute_ready_set_defs]

lemmas rs_gen_S_from_list_code [code]= 
    forward_analysis_impl_defs.gen_S_from_list_code[folded compute_ready_set_defs]
lemmas rs_S_to_list_code [code]= 
    forward_analysis_impl_defs.S_to_list_code[folded compute_ready_set_defs]

lemmas rs_gen_rm_from_list_code [code]= 
    forward_analysis_impl_defs.gen_rm_from_list_code[folded compute_ready_set_defs]

lemmas rs_rm_to_list_code [code]= 
    forward_analysis_impl_defs.rm_to_list_code[folded compute_ready_set_defs]

lemmas rs_rc_to_list_code [code]= 
    forward_analysis_impl_defs.rc_to_list_code[folded compute_ready_set_defs]


lemmas rs_gen_rc_from_list_code [code]= 
    forward_analysis_impl_defs.gen_rc_from_list_code[folded compute_ready_set_defs]

lemmas rs_indegree_code [code] = 
      forward_analysis_impl_defs.uniq_indegree_code 
      [of "(\<lambda> x. rs_iteratei x)" 
          "(\<lambda> v rc. rs_iteratei (the (lookup_aux v rc)))", 
          folded compute_ready_set_defs]


end


