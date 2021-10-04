theory LTSGA
imports LTSSpec "Collections.SetSpec"
begin



subsection \<open> add successors \<close>


  lemma ltsga_it_implies_finite :
    "lts_iterator \<alpha> invar it \<Longrightarrow>
     finite_lts \<alpha> invar"
    unfolding finite_lts_def lts_iterator_def set_iterator_genord_def
    apply auto
  done


  definition ltsga_add_succs ::
    "('V,'W,'L) lts_add \<Rightarrow> ('V,'W,'L) lts_add_succs" where
    "ltsga_add_succs a v e vs l = foldl (\<lambda>l v'. a v e v' l) l vs"

  lemma ltsga_add_succs_correct:
    fixes \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    assumes add_OK: "lts_add \<alpha> invar a"
    shows "lts_add_succs \<alpha> invar (ltsga_add_succs a)"
  proof 
    fix l v e vs
    assume invar: "invar l"

    note add_OK' = lts_add.lts_add_correct [OF add_OK]

    from invar 
    have "invar (ltsga_add_succs a v e vs l) \<and>
           (\<alpha> (ltsga_add_succs a v e vs l) =
            \<alpha> l \<union> {(v, e, v') |v'. v' \<in> set vs})"
    unfolding ltsga_add_succs_def
      by (induct vs arbitrary: l)
         (auto simp add: add_OK')
    thus "invar (ltsga_add_succs a v e vs l)"
         "\<alpha> (ltsga_add_succs a v e vs l) =
          \<alpha> l \<union> {(v, e, v') |v'. v' \<in> set vs}" 
    by simp_all
  qed

subsection \<open> connection to lists \<close>

definition ltsga_from_list :: 
    "('V,'W,'L) lts_empty \<Rightarrow> ('V,'W,'L) lts_add \<Rightarrow> ('V,'W,'L) lts_from_list"
  where 
    "ltsga_from_list e a ll \<equiv> 
    foldl (\<lambda>l vev. a (fst vev) (fst (snd vev)) (snd (snd vev)) l) e ll"
  
lemma ltsga_from_list_correct:
    fixes \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    assumes "lts_empty \<alpha> invar e"
    assumes "lts_add \<alpha> invar a"
    shows "lts_from_list \<alpha> invar (ltsga_from_list e a)"
  proof -
    interpret 
      lts_empty \<alpha> invar e + 
      lts_add \<alpha> invar a
      by fact+

    {
      fix ll
      have "invar (ltsga_from_list e a ll) \<and>
            \<alpha> (ltsga_from_list e a ll) = set ll"
        unfolding ltsga_from_list_def
        apply (induct ll rule: rev_induct)
          apply (simp add: lts_empty_correct)
          apply (simp add: lts_add_correct split: prod.split)
      done
    }
    thus ?thesis
      by unfold_locales simp_all
  qed


  definition ltsga_to_list :: 
    "('V,'W,_,'L) lts_it \<Rightarrow> ('V,'W,'L) lts_to_list"
    where "ltsga_to_list it \<equiv> iterate_to_list \<circ> it"

  lemma ltsga_to_list_correct:
    fixes \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    assumes it_OK: "lts_iterator \<alpha> invar it"
    shows "lts_to_list \<alpha> invar (ltsga_to_list it)"  
  proof -
    note it_OK' = lts_iterator.lts_it_correct [OF it_OK]
    note to_list = iterate_to_list_genord_correct [OF it_OK']
    
    from to_list show ?thesis
      unfolding lts_to_list_def ltsga_to_list_def o_def by simp
  qed



  subsection \<open> reverse \<close>

  definition ltsga_reverse :: 
    "('V, 'W, 'L2) lts_empty \<Rightarrow> 
     ('V, 'W, 'L2) lts_add \<Rightarrow> 
     ('V,'W,_,'L1) lts_it \<Rightarrow> ('V,'W,'L1,'L2) lts_reverse"
    where "ltsga_reverse e a it l \<equiv> 
           it l (\<lambda>_. True) (\<lambda>(v, e, v') l'. a v' e v l') e"

  lemma ltsga_reverse_correct :
    fixes \<alpha>1 :: "('V,'W,'L1) lts_\<alpha>"
    fixes \<alpha>2 :: "('V,'W,'L2) lts_\<alpha>"
    assumes "lts_empty \<alpha>2 invar2 e"
    assumes "lts_add \<alpha>2 invar2 a"
    assumes "lts_iterator \<alpha>1 invar1 it"
    shows "lts_reverse \<alpha>1 invar1 \<alpha>2 invar2 (ltsga_reverse e a it)"
  proof -
    interpret 
      lts_empty \<alpha>2 invar2 e + 
      lts_add \<alpha>2 invar2 a +
      lts_iterator \<alpha>1 invar1 it
      by fact+

    {
      fix l
      assume invar_l: "invar1 l"
      have set_iterator_it: "set_iterator (it l) (\<alpha>1 l)"
        unfolding set_iterator_def 
        apply (simp add: lts_it_correct[of l, OF invar_l])
        done
      have "invar2 (ltsga_reverse e a it l) \<and>
            \<alpha>2 (ltsga_reverse e a it l) = {(v', e, v) |v e v'. (v, e, v') \<in> \<alpha>1 l}"
        unfolding ltsga_reverse_def
    
       
        apply (rule_tac set_iterator_no_cond_rule_P[OF set_iterator_it, where 
                 ?I="\<lambda>it \<sigma>. invar2 \<sigma> \<and> 
                             \<alpha>2 \<sigma> = {(v', e, v) |v e v'. (v, e, v') \<in> (\<alpha>1 l) - it}"])
        apply (auto simp add: lts_add_correct lts_empty_correct invar_l)
      done
    }
    thus ?thesis
      by unfold_locales simp_all
  qed

subsection \<open> Quantifiers \<close>

term iterate_bex

  definition "ltsga_succ_ball it l P v e \<equiv> iterate_ball (it l v e) P"
  definition "ltsga_succ_bex it s l P v e \<equiv> iterate_bex (it s l v e) P"
  definition "ltsga_pre_ball it l P v' e \<equiv> iterate_ball (it l v' e) P"
  definition "ltsga_pre_bex it l P v' e \<equiv> iterate_bex (it l v' e) P"

  

  lemma ltsga_succ_ball_correct:
    fixes \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    assumes it_OK: "lts_succ_it \<alpha> invar it"
    shows "lts_succ_ball \<alpha> invar (ltsga_succ_ball it)"  
  proof -
    note step1 = lts_succ_it.lts_succ_it_correct [OF it_OK]
    note step2 = iterate_ball_correct [OF step1]
    thm step2
    thus ?thesis
      unfolding lts_succ_ball_def ltsga_succ_ball_def iterate_ball_def
      apply simp
      done
  qed

  lemma ltsga_succ_bex_correct:
    fixes \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    assumes it_OK: "lts_succ_it_bex \<alpha> invar sat it"
    shows "lts_succ_bex \<alpha> invar sat (ltsga_succ_bex it)"  
  proof -
    note step1 = lts_succ_it_bex.lts_succ_it_bex_correct [OF it_OK]
    note step2 = iterate_bex_correct [OF step1]
    thus ?thesis
      unfolding lts_succ_bex_def ltsga_succ_bex_def by auto
  qed

  lemma ltsga_pre_ball_correct:
    fixes \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    assumes it_OK: "lts_pre_it \<alpha> invar it"
    shows "lts_pre_ball \<alpha> invar (ltsga_pre_ball it)"  
  proof -
    note step1 = lts_pre_it.lts_pre_it_correct [OF it_OK]
    note step2 = iterate_ball_correct [OF step1]
    thus ?thesis
      unfolding lts_pre_ball_def ltsga_pre_ball_def by simp
  qed

  lemma ltsga_pre_bex_correct:
    fixes \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    assumes it_OK: "lts_pre_it \<alpha> invar it"
    shows "lts_pre_bex \<alpha> invar (ltsga_pre_bex it)"  
  proof -
    note step1 = lts_pre_it.lts_pre_it_correct [OF it_OK]
    note step2 = iterate_bex_correct [OF step1]
    thus ?thesis
      unfolding lts_pre_bex_def ltsga_pre_bex_def by simp
  qed

  subsection \<open> iterators \<close>

  definition ltsga_iterator where
    "ltsga_iterator it = it (\<lambda>_. True) (\<lambda>_. True) (\<lambda>_. True) (\<lambda>_. True)"

  lemma ltsga_iterator_correct:
    fixes \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    assumes it_OK: "lts_filter_it \<alpha> invar it"
    shows "lts_iterator \<alpha> invar (ltsga_iterator it)"  
  proof (rule lts_iterator.intro)
    fix l
    assume "invar l"
    thm lts_filter_it.lts_filter_it_correct
    from lts_filter_it.lts_filter_it_correct [OF it_OK, OF `invar l`,
      of "\<lambda>_. True" "\<lambda>_. True" "\<lambda>_. True" "\<lambda>_. True", folded ltsga_iterator_def]
    show "set_iterator_genord (ltsga_iterator it l) (\<alpha> l) (\<lambda>_ _. True)" 
      unfolding set_iterator_def
      apply (auto)
      done
  qed


  subsection \<open> image and filter \<close>

  definition ltsga_image_filter where
    "ltsga_image_filter e a it f P_v1 P_e P_v2 P l = 
      (it::('V,'W,'\<sigma>,'L) lts_filter_it) P_v1 P_e P_v2 P l (\<lambda>_. True) 
      (\<lambda>vev l. let (v, e, v') = f vev in a v e v' l) e"

  definition ltsga_filter where
    "ltsga_filter e a it = ltsga_image_filter e a it id"

  lemma ltsga_image_filter_correct :
    fixes \<alpha>1 :: "('V1,'W1,'L1) lts_\<alpha>"
    fixes \<alpha>2 :: "('V2,'W2,'L2) lts_\<alpha>"
    assumes "lts_empty \<alpha>2 invar2 e"
    assumes "lts_add \<alpha>2 invar2 a"
    assumes "lts_filter_it \<alpha>1 invar1 it"
    shows "lts_image_filter \<alpha>1 invar1 \<alpha>2 invar2 (ltsga_image_filter e a it)"
  proof
    interpret 
      lts_empty \<alpha>2 invar2 e + 
      lts_add \<alpha>2 invar2 a +
      lts_filter_it \<alpha>1 invar1 it
      by fact+

    fix l P_v1 P_e P_v2 P and f :: "('V1 \<times> 'W1 \<times> 'V1) \<Rightarrow> ('V2 \<times> 'W2 \<times> 'V2)"
    assume invar: "invar1 l"

    have it1: "set_iterator (it P_v1 P_e P_v2 P l)
                     {(v1, e, v2). (v1, e, v2) \<in> \<alpha>1 l \<and> P_v1 v1 \<and> P_e e \<and> 
                        P_v2 v2 \<and> P (v1, e, v2)}" 
    using lts_filter_it_correct [of l P_v1 P_e P_v2 P, OF invar] 
    unfolding set_iterator_def by auto

    have "(\<lambda>S \<sigma>. invar2 \<sigma> \<and> \<alpha>2 \<sigma> = f ` S) {
          (v1, e, v2). (v1, e, v2) \<in> \<alpha>1 l \<and> P_v1 v1 \<and> P_e e \<and> P_v2 v2 \<and> P (v1, e, v2)} 
             (ltsga_image_filter e a it f P_v1 P_e P_v2 P l)"
      unfolding ltsga_image_filter_def
      apply (rule set_iterator_no_cond_rule_insert_P 
                [OF it1, where I = "(\<lambda>S \<sigma>. invar2 \<sigma> \<and> \<alpha>2 \<sigma> = f ` S)"])
         apply (simp_all add: lts_empty_correct lts_add_correct
         split: prod.splits)
    done
    thus "invar2 (ltsga_image_filter e a it f P_v1 P_e P_v2 P l)"
         "\<alpha>2 (ltsga_image_filter e a it f P_v1 P_e P_v2 P l) =
          f ` {(v1, e, v2). (v1, e, v2) \<in> \<alpha>1 l \<and> P_v1 v1 \<and> P_e e \<and> P_v2 v2 \<and> P (v1, e, v2)}" 
      by simp_all
  qed

  lemma ltsga_filter_correct :
    fixes \<alpha> :: "('V1,'W1,'L1) lts_\<alpha>"
    assumes e_OK: "lts_empty \<alpha> invar e"
    assumes a_OK: "lts_add \<alpha> invar a"
    assumes it_OK: "lts_filter_it \<alpha> invar it"
    shows "lts_filter \<alpha> invar (ltsga_filter e a it)"
    using ltsga_image_filter_correct [OF e_OK a_OK it_OK]
    unfolding lts_filter_def lts_image_filter_def ltsga_filter_def
    by simp



  lemma lts_image_filter_inj_on_id:
    "lts_image_filter_inj_on id S"
    unfolding lts_image_filter_inj_on_def by auto


  definition ltsga_image where
    "ltsga_image imf f = imf f (\<lambda>_. True) (\<lambda>_. True) (\<lambda>_. True) (\<lambda>_. True)"

  lemma ltsga_image_correct :
    "lts_image_filter \<alpha>1 invar1 \<alpha>2 invar2 imf \<Longrightarrow>
     lts_image \<alpha>1 invar1 \<alpha>2 invar2 (ltsga_image imf)"
  unfolding lts_image_filter_def lts_image_def ltsga_image_def by simp



type_synonym
  ('s,'a,'\<sigma>) iteratori = "'s \<Rightarrow> ('a,'\<sigma>) set_iterator"



locale set_iterate = finite_set +
  constrains \<alpha> :: "'s \<Rightarrow> 'x set"
  fixes iterate :: "('s,'x,'\<sigma>) iteratori"
 (* "The iterator is specified by its invariant proof rule" *)
  assumes iterate_rule: "\<lbrakk> 
    invar S; 
    I (\<alpha> S) \<sigma>0; 
    \<And> x it \<sigma>. \<lbrakk> x \<in> it; it \<subseteq> \<alpha> S; I it \<sigma> \<rbrakk> \<Longrightarrow> I (it - {x}) (f x \<sigma>)
  \<rbrakk> \<Longrightarrow> I {} (iterate S (\<lambda>_.True) f \<sigma>0)"
begin

  lemma iterate_rule_P:
    assumes A: 
      "invar S" 
      "I (\<alpha> S) \<sigma>0"
      "\<And>x it \<sigma>. \<lbrakk> x \<in> it; it \<subseteq> \<alpha> S; I it \<sigma> \<rbrakk> \<Longrightarrow> I (it - {x}) (f x \<sigma>)"
    assumes C: 
      "\<And>\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>"
    shows 
      "P (iterate S (\<lambda>_. True)f \<sigma>0)"
    using C[OF iterate_rule[OF A(1), of I, OF A(2,3)]]
    by force

  text \<open> Instead of keeping track of the elements that still need to be
    processed, the invariant may also talk about the already processed elements \<close>
  lemma iterate_rule_insert_P:
    assumes A: 
      "invar S" 
      "I {} \<sigma>0"
      "!!x it \<sigma>. \<lbrakk> x \<in> (\<alpha> S - it); it \<subseteq> \<alpha> S; I it \<sigma> \<rbrakk> \<Longrightarrow> I (insert x it) (f x \<sigma>)"
    assumes C: 
      "!!\<sigma>. I (\<alpha> S) \<sigma> \<Longrightarrow> P \<sigma>"
    shows 
      "P (iterate S (\<lambda>_. True)f \<sigma>0)"
  proof -
    let ?I' = "\<lambda>it \<sigma>. I (\<alpha> S - it) \<sigma>"

    have pre :"\<And>x it \<sigma>. \<lbrakk> x \<in> it; it \<subseteq> \<alpha> S; ?I' it \<sigma> \<rbrakk> \<Longrightarrow> ?I' (it - {x}) (f x \<sigma>)"
    proof -
      fix x it \<sigma>
      assume AA : "x \<in> it" "it \<subseteq> \<alpha> S" "?I' it \<sigma>"  

      from AA(1) AA(2) have "\<alpha> S - (it - {x}) = insert x (\<alpha> S - it)" by auto
      moreover
      note A(3) [of x "\<alpha> S - it" "\<sigma>"] AA
      ultimately show "?I' (it - {x}) (f x \<sigma>)"
        by auto
    qed

    note iterate_rule_P [of S ?I' \<sigma>0 f P] pre
    thus "P (iterate S (\<lambda>_. True)f \<sigma>0)" using A C by auto
  qed
end

subsection \<open>All successors of a set\<close>

text \<open> Iterators visit each element exactly once.
          For getting all the successors of a set of nodes, it is therefore benefitial
          to collect the successors in a set and then later iterate over this set. \<close>


  definition ltsga_set_succs where
    "ltsga_set_succs 
       (v_ops :: ('V, 'V_set, _) set_ops_scheme)
       (succ_it :: ('V, 'E, 'W,'V_set,'L) lts_succ_it_bex)
       (v_it :: ('V_set2,'V,'V_set) iteratori) 
       (d :: 'L) 
        sat
        V 
        e 
     = 
     (v_it  V (\<lambda>_. True) (\<lambda>v. succ_it sat d v e (\<lambda>_. True) 
            (set_op_ins v_ops)) (set_op_empty v_ops ()))"
 
  lemma ltsga_set_succs_correct :
    fixes \<alpha> :: "('V,'W,'L) lts_\<alpha>"
      and v_ops :: "('V, 'V list, _) set_ops_scheme"
      and v2_ops :: "('V, 'V_set2, _) set_ops_scheme"
      and succ_it :: "('V,'E,'W,'V list,'L) lts_succ_it_bex"
      and v_it :: "('V_set2,'V,'V list) iteratori"
      and e V sat
    assumes succ_it_OK: "lts_succ_it_bex \<alpha> invar sat succ_it"
        and set_OK: "StdSet v_ops"
        and set_OK2: "StdSet v_ops2"
        and it_OK: " set_iterate (set_op_\<alpha> v_ops2) (set_op_invar v_ops2) v_it"
        and invar_d: "invar d"           
        and invar_V: "set_op_invar v_ops2 V"
    defines "res \<equiv> ltsga_set_succs v_ops succ_it v_it d sat V e"
    shows "set_op_invar v_ops res"
          "set_op_\<alpha> v_ops res = {v' |v v' ee. (v, ee, v') \<in> \<alpha> d \<and> 
                      (sat e ee)  \<and> v \<in> set_op_\<alpha> v_ops2 V}"
   proof -
     interpret v: StdSet v_ops by fact
     interpret v2: StdSet v_ops2 by fact

     define inner where "inner = 
        (\<lambda>v s. succ_it sat d v e (\<lambda>_. True) (\<lambda>x s. v.ins x s) s)"

     from lts_succ_it_bex.lts_succ_it_bex_correct[OF succ_it_OK, OF invar_d, of _ e]
     have succ_it_OK': "\<And>v. set_iterator (succ_it sat d v e) 
                              {v' |v' ee. (v, ee, v') \<in> \<alpha> d \<and> (sat e ee)}"
       by simp

     { fix v s                                              
       assume invar_s: "v.invar s"
 
       let ?I = "\<lambda>S \<sigma>. v.invar \<sigma> \<and> v.\<alpha> \<sigma> = v.\<alpha> s \<union> S"
       thm set_iterator_no_cond_rule_insert_P
       have "?I {v' | v' ee. (v, ee, v') \<in> \<alpha> d \<and> (sat e ee)} (inner v s)"
         apply (unfold inner_def)
         apply (rule set_iterator_no_cond_rule_insert_P [OF succ_it_OK', where I = ?I])
         apply (simp_all add: invar_s v.correct)
       done
     } note inner_OK = this
     
    

     let ?I2 = "\<lambda>S \<sigma>. v.invar \<sigma> \<and> 
        v.\<alpha> \<sigma> = {v' |v ee v'. (v, ee, v') \<in> \<alpha> d \<and> sat e ee \<and> v \<in> S}"
     have "?I2 (v2.\<alpha> V) (v_it V (\<lambda>_. True) (\<lambda>v s. inner v s) (v.empty ()))"
       apply (rule set_iterate.iterate_rule_insert_P 
                [OF it_OK, OF invar_V, where I = ?I2])
       apply (simp_all add: v.correct inner_OK)
         apply auto
     done

     thus "v.invar res"
          "v.\<alpha> res = {v' |v  v' ee. (v, ee, v') \<in> \<alpha> d \<and> sat e ee \<and> v \<in> v2.\<alpha> V}"
       unfolding inner_def res_def ltsga_set_succs_def
       by simp_all
   qed



 definition ltsga_to_collect_list ::
  "('V,'W,'L) lts_to_list \<Rightarrow> 
   ('V,'W,'L) lts_to_collect_list"
where "ltsga_to_collect_list to_list l \<equiv> (to_list l)"

 thm lts_to_collect_list.lts_to_collect_list_correct
 thm lts_to_list.lts_to_list_correct

  lemma ltsga_to_collect_list_correct:
    fixes \<alpha> :: "('V,'W,'L) lts_\<alpha>"
    assumes to_list_OK: "lts_to_list \<alpha> invar to_list"
    shows "lts_to_collect_list \<alpha> invar (ltsga_to_collect_list to_list)"
    unfolding lts_to_list_def lts_to_collect_list_def
              ltsga_to_collect_list_def
    apply (rule allI)+
    using lts_to_list.lts_to_list_correct[OF to_list_OK]
    by simp
  
end
