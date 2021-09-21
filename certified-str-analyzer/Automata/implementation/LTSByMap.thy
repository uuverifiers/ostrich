text  "Implementing Labelled Transition Systems by Maps"
theory LTSByMap
imports "Collections.Collections"
  LTSSpec LTSGA Set_map_extend
begin



locale ltsbm_defs = 
  m1: StdMap m1_ops +
  m2: StdMap m2_ops +
  s3: StdSet s3_ops 
  for m1_ops::"('V::linorder,'m2,'m1,_) map_ops_scheme"
  and m2_ops::"('W,'s3,'m2,_) map_ops_scheme"
  and s3_ops::"('V,'s3,_) set_ops_scheme"
begin

definition ltsbm_\<alpha> :: "('V,'W,'m1) lts_\<alpha>" where
  "ltsbm_\<alpha> m1 \<equiv> {(v,w,v'). 
    \<exists> m2 s3. m1.\<alpha> m1 v = Some m2 \<and> m2.\<alpha> m2 w = Some s3 \<and> v' \<in> s3.\<alpha> s3}"

definition s3_\<alpha> where
  "s3_\<alpha> = s3.\<alpha>"

definition s3_invar where
  "s3_invar = s3.invar"

 definition "ltsbm_invar m1 \<equiv>
    m1.invar m1 \<and>
    (\<forall>m2 \<in> ran (m1.\<alpha> m1). m2.invar m2 \<and>
       (\<forall> s3 \<in> ran (m2.\<alpha> m2). s3.invar s3))"

  lemma ltsbm_invar_alt_def : 
    "ltsbm_invar m1 = 
     (m1.invar m1 \<and>
      (\<forall>v m2. m1.\<alpha> m1 v = Some m2 \<longrightarrow> (
         m2.invar m2 \<and> 
         (\<forall>w s3. m2.\<alpha> m2 w = Some s3 \<longrightarrow>
             s3.invar s3))))"
  unfolding ltsbm_invar_def 
  by (auto simp add: ran_def)

  lemma ltsbm_invar_alt_def2 : 
    "ltsbm_invar m1 = 
     (m1.invar m1 \<and>
      (\<forall>v m2. m1.lookup v m1 = Some m2 \<longrightarrow> (
         m2.invar m2 \<and> 
         (\<forall>w s3. m2.lookup w m2 = Some s3 \<longrightarrow>
             s3.invar s3))))"
  unfolding ltsbm_invar_alt_def 
  by (auto simp add: m1.correct m2.correct)

  definition ltsbm_empty :: "('V,'W,'m1) lts_empty" where 
    "ltsbm_empty \<equiv> m1.empty ()"

  lemma ltsbm_empty_correct: 
    "lts_empty ltsbm_\<alpha> ltsbm_invar ltsbm_empty"    
    unfolding lts_empty_def ltsbm_empty_def ltsbm_\<alpha>_def ltsbm_invar_def
    by (simp add: m1.correct)



  definition ltsbm_add :: "('V,'W,'m1) lts_add" where 
    "ltsbm_add v w v' l \<equiv>  
     case m1.lookup v l of 
        None \<Rightarrow> (m1.update v (m2.sng w (s3.sng v')) l) |
        Some m2 \<Rightarrow> (case m2.lookup w m2 of
          None \<Rightarrow>    m1.update v (m2.update w (s3.sng v')    m2) l |
          Some s3 \<Rightarrow> m1.update v (m2.update w (s3.ins v' s3) m2) l)"

  lemma ltsbm_add_correct:
    "lts_add ltsbm_\<alpha> ltsbm_invar ltsbm_add"
  proof
    fix l v w v'
    assume invar: "ltsbm_invar l"

    from invar
    show "ltsbm_invar (ltsbm_add v w v' l)"
      unfolding ltsbm_invar_alt_def ltsbm_add_def
      by (simp add: m1.correct m2.correct s3.correct 
               split: option.split if_split_asm)
    from invar 
    show "ltsbm_\<alpha> (ltsbm_add v w v' l) = insert (v, w, v') (ltsbm_\<alpha> l)"
      unfolding ltsbm_invar_alt_def ltsbm_\<alpha>_def ltsbm_add_def
      by (simp add: m1.correct m2.correct s3.correct set_eq_iff
               split: option.split if_split_asm)
  qed  
    

definition ltsbm_add_succs :: "('V,'W,'m1) lts_add_succs" where 
    "ltsbm_add_succs v w vs l \<equiv>  
     case m1.lookup v l of 
        None \<Rightarrow> (m1.update v (m2.sng w (s3.from_list vs)) l) |
        Some m2 \<Rightarrow> (case m2.lookup w m2 of
          None \<Rightarrow>    m1.update v (m2.update w (s3.from_list vs) m2) l |
          Some s3 \<Rightarrow> m1.update v (m2.update w (foldl (\<lambda>s3 v'. s3.ins v' s3) s3 vs) m2) l)"

  lemma ltsbm_add_succs_correct:
    "lts_add_succs ltsbm_\<alpha> ltsbm_invar ltsbm_add_succs"
  proof
    fix l v w vs
    assume invar: "ltsbm_invar l"
    define inner_add where "inner_add = (\<lambda>s3. foldl (\<lambda>s3 v'. s3.ins v' s3) s3 vs)" 
    have inner_add_fold : "\<And>s3. foldl (\<lambda>s3 v'. s3.ins v' s3) s3 vs = inner_add s3"
      unfolding inner_add_def by simp

    have inner_add_thm: "\<And>s3. s3.invar s3 \<Longrightarrow> 
      s3.invar (inner_add s3) \<and> s3.\<alpha> (inner_add s3) = s3.\<alpha> s3 \<union> set vs"
      unfolding inner_add_def
      apply (induct vs)
      apply (simp_all add: s3.correct)
    done

    from invar
    show "ltsbm_invar (ltsbm_add_succs v w vs l)"
      unfolding ltsbm_invar_alt_def2 ltsbm_add_succs_def
      by (simp add: m1.correct m2.correct s3.correct inner_add_fold inner_add_thm
               split: option.split if_split_asm)

    from invar 
    show "ltsbm_\<alpha> (ltsbm_add_succs v w vs l) = (ltsbm_\<alpha> l) \<union> {(v, w, v') |v'. v' \<in> set vs}"
      unfolding ltsbm_invar_alt_def ltsbm_\<alpha>_def ltsbm_add_succs_def
      by (simp add: m1.correct m2.correct s3.correct set_eq_iff inner_add_fold inner_add_thm
               split: option.split if_split_asm)
  qed
  definition ltsbm_delete :: "('V,'W,'m1) lts_delete" where 
    "ltsbm_delete v w v' m1 \<equiv>  
     case m1.lookup v m1 of 
        None \<Rightarrow> m1 |
        Some m2 \<Rightarrow> (case m2.lookup w m2 of
          None \<Rightarrow>    m1 |
          Some s3 \<Rightarrow> m1.update v (m2.update w (s3.delete v' s3) m2) m1)"

lemma ltsbm_delete_correct:
    "lts_delete ltsbm_\<alpha> ltsbm_invar ltsbm_delete"
proof
    fix l v w v'
    assume invar: "ltsbm_invar l"

    from invar
    show "ltsbm_invar (ltsbm_delete v w v' l)"
      unfolding ltsbm_invar_alt_def ltsbm_delete_def
      by (simp add: m1.correct m2.correct s3.correct
               split: option.split if_split_asm)

    from invar
    show "ltsbm_\<alpha> (ltsbm_delete v w v' l) = (ltsbm_\<alpha> l) - {(v, w, v')}"
      unfolding ltsbm_invar_alt_def ltsbm_\<alpha>_def ltsbm_delete_def
      by (simp add: m1.correct m2.correct s3.correct set_eq_iff
               split: option.split if_split_asm) auto
  qed

definition map_iterator_sat where
  "map_iterator_sat sat it_a it_b =
   set_iterator_image_filter (\<lambda>kvv'. if (sat (fst (fst kvv'))) 
      then Some (snd kvv') else None) 
    (set_iterator_product it_a (\<lambda>kv. it_b (snd kv)))"



definition ltsbm_succ_it_bex1 where
    "ltsbm_succ_it_bex1 it1 it2 sat m1 v e =
     (case m1.lookup v m1 of
         None \<Rightarrow> set_iterator_emp
       | Some m2 \<Rightarrow>  
             (map_iterator_sat (sat e) 
             (\<lambda> c f. it1 m2 c f) (\<lambda> s3 c f. it2 s3 c f)))"

definition ltsbm_succ_it_bex where
    "ltsbm_succ_it_bex it1 it2 sat m1 v e =
     (case m1.lookup v m1 of
         None \<Rightarrow> set_iterator_emp
       | Some m2 \<Rightarrow> (\<lambda> c f. it2 
          ((set_iterator_image_filter 
            (\<lambda> a. if (sat e (fst a)) then Some a else None) (it1 m2)) 
            (\<lambda>_ .True) 
            (\<lambda> e S. s3.union (snd e) S) (s3.empty ())) c f))"




lemma ltsbm_succ_it_bex_correct :
    fixes sat 
    assumes it1_OK: "map_iteratei m2.\<alpha> m2.invar it1"
    assumes it2_OK: "set_iteratei s3.\<alpha> s3.invar it2"
    shows "lts_succ_it_bex ltsbm_\<alpha> ltsbm_invar sat (ltsbm_succ_it_bex it1 it2)"
 unfolding lts_succ_it_bex_def
  proof (intro allI impI)
    fix l v a
    assume invar_l: "ltsbm_invar l"
    from invar_l have invar_m1: "m1.invar l"
      unfolding ltsbm_invar_def by simp

    show "set_iterator (ltsbm_succ_it_bex it1 it2 sat l v a) 
             {v'|v' e. (v, e, v') \<in> ltsbm_\<alpha> l \<and> sat a e}"
    proof (cases "m1.lookup v l")
      case None note m1_v_eq = this
      with invar_m1 have "{v'|v' e. (v, e, v') \<in> ltsbm_\<alpha> l \<and> sat a e} = {}"
        unfolding ltsbm_\<alpha>_def
         by (simp add: m1.correct)         
      thus ?thesis
        unfolding ltsbm_succ_it_bex_def
        apply (simp only: invar_m1)
        by (simp_all add: m1_v_eq set_iterator_emp_correct invar_m1)
    next
      case (Some m2) note m1_v_eq = this
      with invar_l have invar_m2: "m2.invar m2" 
        unfolding ltsbm_invar_alt_def 
        by (simp add: m1.correct)
    
      from it1_OK invar_m2 
      have it1_OK': "set_iterator 
                      (\<lambda> c f. it1 m2 c f) 
                      (map_to_set (m2.\<alpha> m2))"
        unfolding map_iteratei_alt_def map_to_set_iterator_def 
                  set_iteratei_def set_iteratei_axioms_def
        apply simp
        done
      from this have it1_OK'': "map_iterator (it1 m2)  (m2.\<alpha> m2)"
        by simp
      have it3_OK': "\<And>k s3. m2.\<alpha> m2 k = Some s3 \<Longrightarrow> 
           set_iterator (\<lambda>c f. it2 s3 c f) (s3.\<alpha> s3)"
      proof -
        fix k s3
        assume m2_k_eq: "m2.\<alpha> m2 k = Some s3"

        from invar_l invar_m1 invar_m2 m1_v_eq m2_k_eq 
        have invar_s3: "s3.invar s3"
          unfolding ltsbm_invar_alt_def
          by (simp add: m1.correct m2.correct)

        with it2_OK show "set_iterator (\<lambda>c f. it2 s3 c f) (s3.\<alpha> s3)"
          unfolding set_iteratei_alt_def by simp
      qed
      from it1_OK[unfolded map_iteratei_def 
                  map_iteratei_axioms_def] invar_m2
      have mi1: "map_iterator (it1 m2) (m2.\<alpha> m2)" by simp

      let ?g = "(\<lambda>aa. if sat a (fst aa) then Some aa else None)"
      have inj_g: "inj_on ?g
                (map_to_set (m2.\<alpha> m2) \<inter> dom ?g)" 
        by (smt IntD2 domIff inj_on_def option.inject)

      from set_iterator_image_filter_correct[OF mi1 inj_g]
      have "\<exists>l. distinct l \<and>
       {y. \<exists>x. x \<in> map_to_set (m2.\<alpha> m2) \<and>
               (if sat a (fst x) then Some x else None) = Some y} =
       set l \<and>
       sorted_wrt (\<lambda>_ _. True) l \<and>
       set_iterator_image_filter (\<lambda>aa. if sat a (fst aa) then Some aa else None)
        (it1 m2) =
       foldli l"
        unfolding set_iterator_def set_iterator_genord_def
        by simp

      
      from this obtain l0 where t1: "
        distinct l0 \<and>
       {y. \<exists>x. x \<in> map_to_set (m2.\<alpha> m2) \<and>
               (if sat a (fst x) then Some x else None) = Some y} =
       set l0 \<and>
       sorted_wrt (\<lambda>_ _. True) l0 \<and>
       set_iterator_image_filter (\<lambda>aa. if sat a (fst aa) then Some aa else None)
        (it1 m2) =
       foldli l0
      " by auto
      from invar_l m1_v_eq have m2_OK: "(\<forall> s3 \<in> ran (m2.\<alpha> m2). s3.invar s3)"
        unfolding ltsbm_invar_def
        using m1.lookup_correct ranI by fastforce

      from invar_l t1 m1_v_eq 
      have qr: "\<And>a. a \<in> set l0 \<longrightarrow> s3.invar (snd a)"
        unfolding map_to_set_def
        apply simp
        apply (rule_tac impI)
      proof -
        fix aa
        assume pi1: "ltsbm_invar l" and
               pi2: "distinct l0 \<and>
          {y. \<exists>aa b.
                 m2.\<alpha> m2 aa = Some b \<and>
                 (if sat a aa then Some (aa, b) else None) = Some y} =
          set l0 \<and>
          set_iterator_image_filter (\<lambda>aa. if sat a (fst aa) then Some aa else None)
           (it1 m2) =
          foldli l0" and
          pi3: "m1.lookup v l = Some m2" and
          pi4: "aa \<in> set l0"
        from this map_to_set_def  
        have "m2.\<alpha> m2 (fst aa) = Some (snd aa)"
          apply auto
          by (smt Product_Type.Collect_case_prodD map_to_set_def mem_Collect_eq option.distinct(1) option.inject t1)
          
        from pi1 pi3 this show "s3.invar (snd aa)"
          unfolding ltsbm_invar_def
          by (meson m2_OK ranI)
      qed
      

      from t1  have "distinct l0 \<and> {y. \<exists>x. x \<in> map_to_set (m2.\<alpha> m2) \<and>
               (if sat a (fst x) then Some x else None) = Some y} = set l0"
        by simp

      from this invar_m2 m2_OK have tt2: "(\<forall> s3 \<in> ran (m2.\<alpha> m2). s3.invar s3) \<Longrightarrow>
            (s3.\<alpha> (foldli l0 (\<lambda>_ .True) 
            (\<lambda> e S. s3.union (snd e) S) (s3.empty ()))) = 
            {z | y z. \<exists>x. x \<in> map_to_set (m2.\<alpha> m2) \<and>
             (if sat a (fst x) then Some x else None) = Some y \<and> z \<in> s3.\<alpha> (snd y)}"
        apply simp
        apply (induction l0 arbitrary: m2)
        apply (simp add: s3.correct)
        unfolding map_to_set_def
         apply simp
         apply fastforce
      proof -
        fix aa l0 m2
        assume p1: "(\<And>m2. distinct l0 \<and>
              {y. \<exists>aa b.
                     (aa, b) \<in> {(k, v). m2.\<alpha> m2 k = Some v} \<and>
                     (if sat a aa then Some (aa, b) else None) = Some y} =
              set l0 \<Longrightarrow>
              m2.invar m2 \<Longrightarrow>
              Ball (ran (m2.\<alpha> m2)) s3.invar \<Longrightarrow>
              s3.\<alpha> (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.empty ())) =
              {uu.
               \<exists>aa. sat a aa \<and>
                    (\<exists>b. (aa, b) \<in> {(k, v). m2.\<alpha> m2 k = Some v} \<and> uu \<in> s3.\<alpha> b)})"
        and p2: "distinct (aa # l0) \<and> {y. \<exists>aa b.
              (aa, b) \<in> {(k, v). m2.\<alpha> m2 k = Some v} \<and>
              (if sat a aa then Some (aa, b) else None) = Some y} =
          set (aa # l0)"
        and p3: "m2.invar m2" and
            p4: "Ball (ran (m2.\<alpha> m2)) s3.invar"
        from p2 have prem0: "distinct l0"
          by simp
     from p3 m2.correct(11) have prem2: "m2.invar (m2.delete (fst aa) m2)"
       by simp
     thm this p2 m2.correct(10) 
      from p2 have prem1: "{y. \<exists>a' b.
              (a', b) \<in> {(k, v). m2.\<alpha> (m2.delete (fst aa) m2) k = Some v} \<and>
              (if sat a a' then Some (a', b) else None) = Some y} = set (l0)"
        apply simp
        apply (simp add: set_eq_iff)
        apply (rule allI)+
      proof 
        {
          fix ab b
          assume
              pp0: "aa \<notin> set l0 \<and>
       distinct l0 \<and>
       (\<forall>ab b.
           (\<exists>aa ba.
               m2.\<alpha> m2 aa = Some ba \<and>
               (if sat a aa then Some (aa, ba) else None) = Some (ab, b)) =
           ((ab, b) = aa \<or> (ab, b) \<in> set l0))" and
              pp1: "sat a ab \<and> m2.\<alpha> (m2.delete (fst aa) m2) ab = Some b"
          from p3 this  m2.correct(10)  
          have "ab \<noteq> (fst aa)"
            by auto
          from this pp0 pp1 p2 m2.correct show "(ab, b) \<in> set l0"
          proof -
            show ?thesis
              by (metis (no_types) \<open>\<And>ma k. m2.invar ma \<Longrightarrow> m2.\<alpha> (m2.delete k ma) = m2.\<alpha> ma |` (- {k})\<close> \<open>ab \<noteq> fst aa\<close> eq_fst_iff p3 pp0 pp1 restrict_map_eq(2))
          qed
        }
        {
          fix ab b
          assume pp1: "aa \<notin> set l0 \<and> distinct l0 \<and>
                 (\<forall>ab b. (\<exists>aa ba.
                  m2.\<alpha> m2 aa = Some ba \<and>
               (if sat a aa then Some (aa, ba) else None) = Some (ab, b)) =
           ((ab, b) = aa \<or> (ab, b) \<in> set l0))"
            and pp2: "(ab, b) \<in> set l0"
          from pp1 pp2 
          have cc1: "m2.\<alpha> m2 ab = Some b"
            apply auto
            by (metis Pair_inject option.distinct(1) option.inject)
          from this pp1 pp2 have cc2: "ab \<noteq> (fst aa)"
            by (metis fst_conv not_Some_eq2 old.prod.exhaust option.inject)
          from cc1 pp1 pp2 have "sat a ab"
            by (metis option.distinct(1) option.inject prod.inject)
          from this cc1 m2.correct cc2 pp1 pp2
          show "sat a ab \<and> m2.\<alpha> (m2.delete (fst aa) m2) ab = Some b"
            using p3 by auto       
        }
      qed
      from this prem0 have prem1: "distinct l0 \<and> {y. \<exists>a' b.
              (a', b) \<in> {(k, v). m2.\<alpha> (m2.delete (fst aa) m2) k = Some v} \<and>
              (if sat a a' then Some (a', b) else None) = Some y} =
       set l0 " by simp

      have aux0 : "\<And>S l. (\<forall> a \<in> set l. s3.invar (snd a)) 
           \<and> s3.invar S  \<longrightarrow>
           s3.invar (foldli l (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) S)"
        apply (rule impI)
      proof -
        fix S l
        show "(\<forall>a\<in>set l. s3.invar (snd a)) \<and> s3.invar S \<Longrightarrow>
           s3.invar (foldli l (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) S)"
          apply (induction l arbitrary: S)
          apply simp
          apply simp
          apply (insert s3.correct(19))
          by auto
      qed
        
      have aux: "\<And>S. s3.invar S \<and> (\<forall> a \<in> set (aa # l0). s3.invar (snd a)) \<longrightarrow>
           s3.\<alpha> (foldli (aa # l0) (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) S)
          = s3.\<alpha> (s3.union (snd aa) 
            (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) S))"
        apply simp
        apply (rule impI)+
      proof -
        fix S
        show p221: "s3.invar S \<and> s3.invar (snd aa) \<and> (\<forall>a\<in>set l0. s3.invar (snd a)) \<Longrightarrow>
         s3.\<alpha> (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.union (snd aa) S)) =
         s3.\<alpha> (s3.union (snd aa) (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) S))"    
          apply (induction l0 arbitrary: S aa)
          apply simp
          apply simp
          apply (rename_tac a1 l01 S1 aa1)
        proof -
        {
          fix a1::"'W \<times>'s3" 
          fix l01 :: "('W \<times>'s3) list"
          fix S1 :: "'s3"
          fix aa1 ::"'W \<times>'s3"
          assume p1: "(\<And>S (aa ::'W \<times>'s3) .
           s3.invar S \<and> s3.invar (snd aa) \<Longrightarrow>
           s3.\<alpha> (foldli l01 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.union (snd aa) S)) =
           s3.\<alpha>
            (s3.union (snd aa) (foldli l01 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) S)))"
          and p2: "s3.invar S1 \<and>
       s3.invar (snd aa1) \<and> s3.invar (snd a1) \<and> (\<forall>a\<in>set l01. s3.invar (snd a))"
          from s3.correct(18)
          have "\<And> a b c. s3.invar a \<and> s3.invar b \<and> s3.invar c \<longrightarrow>
                 s3.\<alpha> (s3.union a (s3.union b c)) = 
                 s3.\<alpha> (s3.union (s3.union a b) c)"
           using s3.union_correct(2) by auto
     from p2 s3.correct(19) 
     have k1: "s3.invar (s3.union (snd aa1) S1)" by auto

     from this p2 p1 aux0[of l01 S1]
     have "s3.invar (foldli l01 (\<lambda>_. True) 
            (\<lambda>e. s3.union (snd e)) (s3.union (snd aa1) S1))" 
       using aux0 by blast

     from p1 p2 s3.correct(18) this aux0
     have "s3.\<alpha>
     (s3.union (snd a1)
       (foldli l01 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.union (snd aa1) S1))) = 
      s3.\<alpha> (snd a1) \<union> s3.\<alpha> (foldli l01 (\<lambda>_. True) 
      (\<lambda>e. s3.union (snd e)) (s3.union (snd aa1) S1))"
       by simp

     have k3: "s3.invar S1 \<and> s3.invar (snd a1)"
       using p2 by blast
     have k4: "s3.invar S1 \<and> s3.invar (snd aa1)"
        using p2 by blast
     from k1 have k2: "s3.invar (s3.union (snd aa1) S1) \<and> s3.invar (snd a1)"
       using p2 by blast
     from aux0 p1[of "(s3.union (snd aa1) S1)" a1, OF k2] 
               p1[of S1 a1, OF k3]
               p1[of S1 aa1, OF k4]
     show "s3.\<alpha>
        (foldli l01 (\<lambda>_. True) (\<lambda>e. s3.union (snd e))
          (s3.union (snd a1) (s3.union (snd aa1) S1))) =
       s3.\<alpha>
        (s3.union (snd aa1)
          (foldli l01 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.union (snd a1) S1)))"
       apply simp
       using p1[of S1 a1, OF k3] p1[of S1 aa1, OF k4]
       apply simp
       by (simp add: Un_left_commute aux0 p2 s3.union_correct(1) s3.union_correct(2)) 
    }qed
qed 
  from p1 p2 p3 p4 invar_l 
  have aux1: "s3.invar (snd aa) \<and> (\<forall>a\<in>set l0. s3.invar (snd a))" 
    by (smt Product_Type.Collect_case_prodD list.set_intros(1) m2.delete_correct(1) mem_Collect_eq option.distinct(1) option.inject prem1 ranI restrict_map_eq(2))

  from p4 m2.correct
  have pk1: "Ball (ran (m2.\<alpha> (m2.delete (fst aa) m2))) s3.invar"
    by (metis (mono_tags, lifting) p3 ranI ran_restrictD)

  have aux2: "s3.invar (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.empty ()))"
    using aux0 aux1 s3.empty_correct(2) by blast
      note p1'=  p1[OF prem1 prem2]
      from p1' show 
      "s3.\<alpha> (foldli (aa # l0) (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.empty ())) =
       {uu.
        \<exists>aa. sat a aa \<and> (\<exists>b. (aa, b) \<in> {(k, v). m2.\<alpha> m2 k = Some v} \<and> uu \<in> s3.\<alpha> b)}"
        apply simp
        thm p2 s3.correct m2.correct
      proof -
        from p2 aux aux1
        have "s3.\<alpha> (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) 
                (s3.union (snd aa) (s3.empty ()))) = 
              s3.\<alpha> (s3.union (snd aa) (foldli l0 (\<lambda>_. True) 
               (\<lambda>e. s3.union (snd e)) (s3.empty ())))"
          by (simp add: s3.empty_correct(2))
    from this p1' show "s3.\<alpha>
     (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.union (snd aa) (s3.empty ()))) =
    {uu. \<exists>aa. sat a aa \<and> (\<exists>b. m2.\<alpha> m2 aa = Some b \<and> uu \<in> s3.\<alpha> b)}"
      apply simp  
    proof -
      assume pp1: "s3.\<alpha>
     (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.union (snd aa) (s3.empty ()))) =
    s3.\<alpha>
     (s3.union (snd aa) (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.empty ())))" 
        and
      pp2: "(Ball (ran (m2.\<alpha> (m2.delete (fst aa) m2))) s3.invar \<Longrightarrow>
     s3.\<alpha> (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.empty ())) =
     {uu.
      \<exists>aaa. sat a aaa \<and>
            (\<exists>b. m2.\<alpha> (m2.delete (fst aa) m2) aaa = Some b \<and> uu \<in> s3.\<alpha> b)})"

      from this s3.correct(18) aux1 aux2 pk1 have "s3.\<alpha>
     (s3.union (snd aa) (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.empty ()))) = 
     s3.\<alpha> (snd aa) \<union> {uu.
     \<exists>aaa. sat a aaa \<and> (\<exists>b. m2.\<alpha> (m2.delete (fst aa) m2) aaa = Some b \<and> uu \<in> s3.\<alpha> b)}"
        by simp
      from this show "s3.\<alpha>
     (s3.union (snd aa) (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.empty ()))) =
    {uu. \<exists>aa. sat a aa \<and> (\<exists>b. m2.\<alpha> m2 aa = Some b \<and> uu \<in> s3.\<alpha> b)}"
        apply simp
      proof -
        show
    "s3.\<alpha> (snd aa) \<union>
    {uu.
     \<exists>aaa. sat a aaa \<and> (\<exists>b. m2.\<alpha> (m2.delete (fst aa) m2) aaa = Some b \<and> uu \<in> s3.\<alpha> b)} =
    {uu. \<exists>aa. sat a aa \<and> (\<exists>b. m2.\<alpha> m2 aa = Some b \<and> uu \<in> s3.\<alpha> b)}"
          apply (simp add:set_eq_iff)
        proof
          fix x
          show "(x \<in> s3.\<alpha> (snd aa) \<or>
          (\<exists>aaa. sat a aaa \<and>
                 (\<exists>b. m2.\<alpha> (m2.delete (fst aa) m2) aaa = Some b \<and> x \<in> s3.\<alpha> b))) =
         (\<exists>aa. sat a aa \<and> (\<exists>b. m2.\<alpha> m2 aa = Some b \<and> x \<in> s3.\<alpha> b))"
   proof {
            assume pc1: "x \<in> s3.\<alpha> (snd aa) \<or>
    (\<exists>aaa. sat a aaa \<and>
           (\<exists>b. m2.\<alpha> (m2.delete (fst aa) m2) aaa = Some b \<and> x \<in> s3.\<alpha> b))"
            from p2 have "m2.\<alpha> m2 (fst aa) = Some (snd aa) \<and>
                          sat a (fst aa)"
           by (smt Product_Type.Collect_case_prodD fst_conv list.set_intros(1) mem_Collect_eq option.distinct(1) option.inject)
   from pc1 this m2.correct show "
    \<exists>aa. sat a aa \<and> (\<exists>b. m2.\<alpha> m2 aa = Some b \<and> x \<in> s3.\<alpha> b)"
   proof -
     have "\<forall>f W w s. ((f |` W) (w::'W) = Some (s::'s3)) = (f w = Some s \<and> w \<in> W)"
       using restrict_map_eq(2) by blast
     then show ?thesis
       using \<open>\<And>ma k. m2.invar ma \<Longrightarrow> m2.\<alpha> (m2.delete k ma) = m2.\<alpha> ma |` (- {k})\<close> \<open>m2.\<alpha> m2 (fst aa) = Some (snd aa) \<and> sat a (fst aa)\<close> p3 pc1 by auto
   qed
 } {
   assume pc2: "\<exists>aa. sat a aa \<and> (\<exists>b. m2.\<alpha> m2 aa = Some b \<and> x \<in> s3.\<alpha> b)"

  from p2 have "m2.\<alpha> m2 (fst aa) = Some (snd aa) \<and>
                          sat a (fst aa)"
           by (smt Product_Type.Collect_case_prodD fst_conv list.set_intros(1) mem_Collect_eq option.distinct(1) option.inject)
  from pc2 this m2.correct
   show "x \<in> s3.\<alpha> (snd aa) \<or>
    (\<exists>aaa. sat a aaa \<and> (\<exists>b. m2.\<alpha> (m2.delete (fst aa) m2) aaa = Some b \<and> x \<in> s3.\<alpha> b))"
   proof -
     show ?thesis
       by (metis (no_types) ComplI \<open>\<And>ma k. m2.invar ma \<Longrightarrow> m2.\<alpha> (m2.delete k ma) = m2.\<alpha> ma |` (- {k})\<close> \<open>m2.\<alpha> m2 (fst aa) = Some (snd aa) \<and> sat a (fst aa)\<close> option.inject p3 pc2 restrict_map_def singletonD)
   qed
 }
qed qed qed qed qed qed
  
  from t1 this m1_v_eq set_iterator_image_filter_correct[OF mi1 inj_g]
  show "set_iterator (ltsbm_succ_it_bex it1 it2 sat l v a)
           {uu. \<exists>v' e. uu = v' \<and> (v, e, v') \<in> ltsbm_\<alpha> l \<and> sat a e}"
        unfolding ltsbm_succ_it_bex_def
        apply simp
      proof -
    assume pa1: "Ball (ran (m2.\<alpha> m2)) s3.invar \<Longrightarrow>
        s3.\<alpha> (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.empty ())) =
    {uu.
     \<exists>aa b ab ba.
        (ab, ba) \<in> map_to_set (m2.\<alpha> m2) \<and>
        (if sat a ab then Some (ab, ba) else None) = Some (aa, b) \<and> uu \<in> s3.\<alpha> b}"

  have suc: "Ball (ran (m2.\<alpha> m2)) s3.invar"
    using m2_OK by blast

  have aux0 : "\<And>S l. (\<forall> a \<in> set l. s3.invar (snd a)) 
           \<and> s3.invar S  \<longrightarrow>
           s3.invar (foldli l (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) S)"
        apply (rule impI)
      proof -
        fix S l
        show "(\<forall>a\<in>set l. s3.invar (snd a)) \<and> s3.invar S \<Longrightarrow>
           s3.invar (foldli l (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) S)"
          apply (induction l arbitrary: S)
          apply simp
          apply simp
          apply (insert s3.correct(19))
          by auto
      qed

   

  from this qr s3.correct(2)
  have pre11: 
      "s3.invar ((foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.empty ())))"
    by blast
      
  note it2_OK' = it2_OK[unfolded set_iteratei_def set_iteratei_axioms_def ]
  from it2_OK' pre11 
  have "set_iterator (it2 (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.empty ()))) 
        (s3.\<alpha> (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.empty ())))"
    by simp
  from this tt2 suc
  have  cccf: "set_iterator (it2 (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.empty ())))
     {uu.
     \<exists>aa b ab ba.
        (ab, ba) \<in> map_to_set (m2.\<alpha> m2) \<and>
        (if sat a ab then Some (ab, ba) else None) = Some (aa, b) \<and> uu \<in> s3.\<alpha> b}"
    by simp
  have "{uu.
    \<exists>aa b ab ba.
       (ab, ba) \<in> map_to_set (m2.\<alpha> m2) \<and>
       (if sat a ab then Some (ab, ba) else None) = Some (aa, b) \<and> uu \<in> s3.\<alpha> b} = 
    {uu. \<exists>e. (v, e, uu) \<in> ltsbm_\<alpha> l \<and> sat a e}"
    unfolding map_to_set_def ltsbm_\<alpha>_def
    apply simp
    apply (subgoal_tac "m1.\<alpha> l v = Some m2")
    defer
    using m1_v_eq m1.correct(5)[of l v, OF invar_m1]
    apply simp
    apply simp
    by fastforce
  from this cccf
  show "set_iterator (it2 (foldli l0 (\<lambda>_. True) (\<lambda>e. s3.union (snd e)) (s3.empty ())))
     {uu. \<exists>e. (v, e, uu) \<in> ltsbm_\<alpha> l \<and> sat a e}"
    by simp
qed qed qed


definition ltsbm_succ_it where
    "ltsbm_succ_it it1 it2 m1 v e =
     (case m1.lookup v m1 of
         None \<Rightarrow> set_iterator_emp
       | Some m2 \<Rightarrow>map_iterator_product 
             (\<lambda> c f. it1 m2 c f) (\<lambda> s3 c f. it2 s3 c f))"

 lemma ltsbm_succ_it_alt_def :
    "ltsbm_succ_it = (\<lambda>it2 it3 m1 v e. 
      (case m1.lookup v m1 of
          None \<Rightarrow> \<lambda>c f \<sigma>0. \<sigma>0
        | Some m2 \<Rightarrow> \<lambda>c f. it2 m2 c (\<lambda>x y. it3 (snd x) c (\<lambda>b. f (fst x, b)) y)))"
    unfolding ltsbm_succ_it_def
              map_iterator_product_alt_def map_to_set_iterator_def curry_def
              fst_conv snd_conv set_iterator_emp_def
    by simp

  lemma ltsbm_succ_it_correct :
    assumes it1_OK: "map_iteratei m2.\<alpha> m2.invar it1"
    assumes it2_OK: "set_iteratei s3.\<alpha> s3.invar it2"
    shows "lts_succ_it ltsbm_\<alpha> ltsbm_invar (ltsbm_succ_it it1 it2)"
  unfolding lts_succ_it_def
  proof (intro allI impI)
    fix l v e
    assume invar_l: "ltsbm_invar l"
    from invar_l have invar_m1: "m1.invar l"
      unfolding ltsbm_invar_def by simp

    show "set_iterator (ltsbm_succ_it it1 it2 l v e) 
             {(e, v') |v' e. (v, e, v') \<in> ltsbm_\<alpha> l}"
    proof (cases "m1.lookup v l")
      case None note m1_v_eq = this
      with invar_m1 have "{(e, v') |e v'. (v, e, v') \<in> ltsbm_\<alpha> l} = {}"
        unfolding ltsbm_\<alpha>_def
         by (simp add: m1.correct)         
      thus ?thesis
        unfolding ltsbm_succ_it_def
        by (simp add: m1_v_eq set_iterator_emp_correct)
    next
      case (Some m2) note m1_v_eq = this
      with invar_l have invar_m2: "m2.invar m2" 
        unfolding ltsbm_invar_alt_def 
        by (simp add: m1.correct)

      from it1_OK invar_m2 
      have it1_OK': "set_iterator 
                      (\<lambda> c f. it1 m2 c f) 
                      (map_to_set (m2.\<alpha> m2))"
        unfolding map_iteratei_alt_def map_to_set_iterator_def 
                  set_iteratei_def set_iteratei_axioms_def
        apply simp
        done
        
      have it3_OK': "\<And>k s3. m2.\<alpha> m2 k = Some s3 \<Longrightarrow> 
           set_iterator (\<lambda>c f. it2 s3 c f) (s3.\<alpha> s3)"
      proof -
        fix k s3
        assume m2_k_eq: "m2.\<alpha> m2 k = Some s3"

        from invar_l invar_m1 invar_m2 m1_v_eq m2_k_eq 
        have invar_s3: "s3.invar s3"
          unfolding ltsbm_invar_alt_def
          by (simp add: m1.correct m2.correct)

        with it2_OK show "set_iterator (\<lambda>c f. it2 s3 c f) (s3.\<alpha> s3)"
          unfolding set_iteratei_alt_def by simp
      qed

      from map_iterator_product_correct [OF it1_OK', 
         of "\<lambda>s3 c f. it2 s3 c f" "s3.\<alpha>"] it3_OK' m1_v_eq invar_m1
        show ?thesis
          apply (simp add: ltsbm_succ_it_def ltsbm_\<alpha>_def)
      proof -
        have pre1: " set_iterator (map_iterator_product (it1 m2) it2)
     {(k, e). \<exists>v. m2.\<alpha> m2 k = Some v \<and> e \<in> s3.\<alpha> v} \<Longrightarrow>
    (\<And>k s3. m2.\<alpha> m2 k = Some s3 \<Longrightarrow> set_iterator (it2 s3) (s3.\<alpha> s3)) \<Longrightarrow>
    m1.lookup v l = Some m2 \<Longrightarrow>
    m1.invar l \<Longrightarrow>
    set_iterator (map_iterator_product (it1 m2) it2)
     {(e, v'). \<exists>m2. m1.\<alpha> l v = Some m2 \<and> (\<exists>s3. m2.\<alpha> m2 e = Some s3 \<and> v' \<in> s3.\<alpha> s3)}"
          by (simp add: m1.correct)

  from this have "{(e, v'). \<exists>m2. m1.\<alpha> l v = Some m2 \<and> (\<exists>s3. m2.\<alpha> m2 e = Some s3 \<and> v' \<in> s3.\<alpha> s3)} = {(e, v') |v' e.
      \<exists>m2. m1.\<alpha> l v = Some m2 \<and> (\<exists>s3. m2.\<alpha> m2 e = Some s3 \<and> v' \<in> s3.\<alpha> s3)}"
          by auto
        from pre1 this show "set_iterator (map_iterator_product (it1 m2) it2)
     {(k, e). \<exists>v. m2.\<alpha> m2 k = Some v \<and> e \<in> s3.\<alpha> v} \<Longrightarrow>
    (\<And>k s3. m2.\<alpha> m2 k = Some s3 \<Longrightarrow> set_iterator (it2 s3) (s3.\<alpha> s3)) \<Longrightarrow>
    m1.lookup v l = Some m2 \<Longrightarrow>
    m1.invar l \<Longrightarrow>
    set_iterator (map_iterator_product (it1 m2) it2)
     {(e, v') |v' e.
      \<exists>m2. m1.\<alpha> l v = Some m2 \<and> (\<exists>s3. m2.\<alpha> m2 e = Some s3 \<and> v' \<in> s3.\<alpha> s3)}"
          by auto
      qed
    qed qed 

    term  lts_connect_it

definition filter :: "'s3 \<Rightarrow> 'W \<times> 's3 \<Rightarrow> ('W \<times> 's3) option" where
  "filter c a = (if (\<not> s3.isEmpty (s3.inter (snd a) c)) then (Some a) else None)"

definition ltsbm_connect_it where
   "ltsbm_connect_it  =
     (\<lambda> it2 it3 m1 sa si v. 
      (case m1.lookup v m1 of
          None \<Rightarrow> \<lambda>c f \<sigma>0. \<sigma>0
        | Some m2 \<Rightarrow> 
             map_iterator_product
              (\<lambda> c f. (set_iterator_image_filter (filter sa) (it2 m2)) c f)
              (\<lambda> x c f. it3 si c f)))"


lemma ltsbm_connect_it_alt_def:
   "ltsbm_connect_it  =
     (\<lambda> it2 it3 m1 sa si v. 
      (case m1.lookup v m1 of
          None \<Rightarrow> \<lambda>c f \<sigma>0. \<sigma>0
        | Some m2 \<Rightarrow> 
             \<lambda>c f \<sigma>0. it2 m2 c 
              (\<lambda>x \<sigma>. (case (filter sa x) of Some x' \<Rightarrow> 
                 (\<lambda>x y. it3 si c (\<lambda>b. f (fst x, b)) y) x' \<sigma>  | None \<Rightarrow> \<sigma>)) 
              \<sigma>0))"
  unfolding ltsbm_connect_it_def
              map_iterator_product_alt_def set_iterator_image_filter_def curry_def
              fst_conv snd_conv set_iterator_emp_def
    by simp

lemma map_iterator_product_correct1 :
  assumes it_a: "map_iterator it_a m"
  assumes it_b: "set_iterator (it_b v) (S_b v)"
  shows "set_iterator (map_iterator_product it_a 
          (\<lambda> x c f. it_b v c f)) 
         {(k, e) . (\<exists> v'. m k = Some v' \<and> e \<in> S_b v)}" 
  
  using map_iterator_product_correct[OF it_a]
  apply (rule_tac map_iterator_product_correct[OF it_a])
  by (simp add: it_b)

 lemma ltsbm_connect_it_correct :
    assumes it2_OK: "map_iteratei m2.\<alpha> m2.invar it2"
    assumes it3_OK: "set_iteratei s3.\<alpha> s3.invar it3"
    shows "lts_connect_it ltsbm_\<alpha> ltsbm_invar s3_\<alpha> s3_invar 
            (ltsbm_connect_it it2 it3)"
  unfolding lts_connect_it_def s3_\<alpha>_def s3_invar_def
proof (intro allI impI)
  fix l1 B C v
  assume invar_l: "ltsbm_invar l1" and
         invar_C: "s3.invar C" and
         invar_B: "s3.invar B"
    from invar_l have invar_m1: "m1.invar l1"
      unfolding ltsbm_invar_def by simp
  let ?D = "{uu. \<exists>e v' v''.
         uu = (e, v') \<and> (v, e, v'') \<in> ltsbm_\<alpha> l1 \<and> v'' \<in> s3.\<alpha> B \<and> v' \<in> s3.\<alpha> C}" 
  show "set_iterator (ltsbm_connect_it it2 it3 l1 B C v) ?D"
    proof (cases "m1.lookup v l1")
      case None note m1_v_eq = this
      with invar_m1 have con1:  "?D = {}"
        unfolding ltsbm_\<alpha>_def
         by (simp add: m1.correct)         
      thus ?thesis
        unfolding ltsbm_connect_it_def
        apply (insert con1 set_iterator_emp_correct)
        unfolding set_iterator_emp_def
        apply simp
        apply (simp add: m1_v_eq set_iterator_emp_correct)
        apply (subgoal_tac "?D = 
                {(e, v'). \<exists>v''. (v, e, v'') \<in> ltsbm_\<alpha> l1 \<and> v'' \<in> s3.\<alpha> B \<and> v' \<in> s3.\<alpha> C}")
        apply auto
      proof -
        assume p1: "set_iterator (\<lambda>c f \<sigma>0. \<sigma>0) {}"
        from con1
        show " set_iterator (\<lambda>c f \<sigma>0. \<sigma>0)
         {(e, v'). \<exists>v''. (v, e, v'') \<in> ltsbm_\<alpha> l1 \<and> v'' \<in> s3.\<alpha> B \<and> v' \<in> s3.\<alpha> C}"
        proof -
          have "
            {(e, v'). \<exists>v''. (v, e, v'') \<in> ltsbm_\<alpha> l1 \<and> v'' \<in> s3.\<alpha> B \<and> v' \<in> s3.\<alpha> C} = ?D"
            by fastforce
          from this con1 have 
            con2: "{(e, v'). \<exists>v''. (v, e, v'') \<in> ltsbm_\<alpha> l1 \<and> v'' \<in> s3.\<alpha> B \<and> v' \<in> s3.\<alpha> C} = {}"
            by fastforce
          from p1 this
          show "set_iterator (\<lambda>c f \<sigma>0. \<sigma>0)
     {(e, v'). \<exists>v''. (v, e, v'') \<in> ltsbm_\<alpha> l1 \<and> v'' \<in> s3.\<alpha> B \<and> v' \<in> s3.\<alpha> C}"
            apply (simp only: con2)
            apply (simp add: set_iterator_emp_correct set_iterator_emp_def)
            by force
        qed qed       
    next
      case (Some m2) note m1_v_eq = this
      with invar_l have invar_m2: "m2.invar m2" 
        unfolding ltsbm_invar_alt_def 
        by (simp add: m1.correct)

      from it2_OK invar_m2 set_iterator_image_filter_correct
      have it2_OK': "set_iterator 
                      (\<lambda> c f. (set_iterator_image_filter (filter B) (it2 m2)) c f) 
                      {y . \<exists> x. x \<in> (map_to_set (m2.\<alpha> m2)) \<and> filter B x = Some y}"
      unfolding map_iteratei_alt_def 
                  set_iterator_image_filter_def
                  map_to_set_iterator_def unfolding filter_def
      apply simp
    proof -
      assume p1: "\<forall>m. m2.invar m \<longrightarrow> map_iterator (it2 m) (m2.\<alpha> m)"
      from this invar_m2 have con1: "set_iterator (it2 m2) (map_to_set (m2.\<alpha> m2))"
        by auto
      let ?g = "filter B"

      have inj_g: "inj_on ?g (map_to_set (m2.\<alpha> m2) \<inter> dom ?g)"
        unfolding filter_def
        apply (simp add: inj_on_def map_to_set_def)
        by fastforce
     
      have inter_eq: "{y. \<exists> x. x \<in> (map_to_set (m2.\<alpha> m2)) \<and> filter B x = Some y} = 
            map_to_set (\<lambda> k. if \<exists> v.  m2.\<alpha> m2 k = Some v 
                                      \<and> filter B (k,v) = Some (k, v)
                       then m2.\<alpha> m2 k else None)"
        unfolding map_to_set_def unfolding filter_def
        apply simp
        by fastforce
      from set_iterator_image_filter_correct[OF con1 inj_g]
      show it2_OK': "set_iterator
     (\<lambda>c f. it2 m2 c
             (\<lambda>x \<sigma>. case if s3.isEmpty (s3.inter (snd x) B) then None else Some x of
                    None \<Rightarrow> \<sigma> | Some x' \<Rightarrow> f x' \<sigma>))
     {y. \<exists>a b. \<not> s3.isEmpty (s3.inter b B) \<and>
               (a, b) \<in> map_to_set (m2.\<alpha> m2) \<and> (a, b) = y}"
        unfolding map_iteratei_alt_def 
                  set_iterator_image_filter_def
                  map_to_set_iterator_def
        unfolding filter_def
        apply (auto simp add: if_splits)
        apply (subgoal_tac 
              "{y. \<exists>a b. (a, b) \<in> map_to_set (m2.\<alpha> m2) \<and>
               (if s3.isEmpty (s3.inter b B) then None else Some (a, b)) = Some y}  =
              {y. \<exists>a b. \<not> s3.isEmpty (s3.inter b B) \<and>
               (a, b) \<in> map_to_set (m2.\<alpha> m2) \<and> (a, b) = y}")
         apply simp
        apply force  
        done
    qed
    have inter_eq: "{y. \<exists> x. x \<in> (map_to_set (m2.\<alpha> m2)) \<and> filter B x = Some y} = 
            map_to_set (\<lambda> k. if \<exists> v.  m2.\<alpha> m2 k = Some v 
                                      \<and> filter B (k,v) = Some (k, v)
                       then m2.\<alpha> m2 k else None)"
      unfolding map_to_set_def 
        unfolding filter_def
        apply simp
        by fastforce
      from it2_OK' inter_eq have it2_OK'': "
          set_iterator (\<lambda> c f. (set_iterator_image_filter (filter B) (it2 m2)) c f)
          (map_to_set (\<lambda> k. if \<exists> v.  m2.\<alpha> m2 k = Some v 
                                      \<and> filter B (k,v) = Some (k, v)
                       then m2.\<alpha> m2 k else None))
      " 
        by auto
      
      

      from invar_C it3_OK have con2: "
        set_iterator (it3 C) ((\<lambda>x. s3.\<alpha> x) C)"
        unfolding set_iteratei_alt_def
        by auto

      note result1 = map_iterator_product_correct1[OF it2_OK'', of it3 C "(\<lambda>x. s3.\<alpha> x)"]
      note result2 = result1[OF con2]
      from result2 m1_v_eq invar_m1
      show ?thesis
        unfolding ltsbm_connect_it_def ltsbm_\<alpha>_def
        apply simp
        unfolding filter_def
        apply (subgoal_tac "{k. \<exists>v'. (if \<exists>v. m2.\<alpha> m2 k = Some v \<and>
                       (if \<not> s3.isEmpty (s3.inter (snd (k, v)) B) then Some (k, v)
                        else None) =
                       Some (k, v)
                then m2.\<alpha> m2 k else None) =
               Some v'} \<times>
      s3.\<alpha> C = 
      {(e, v').
     \<exists>v''. (\<exists>m2. m1.\<alpha> l1 v = Some m2 \<and> (\<exists>s3. m2.\<alpha> m2 e = Some s3 \<and> v'' \<in> s3.\<alpha> s3)) \<and>
           v'' \<in> s3.\<alpha> B \<and> v' \<in> s3.\<alpha> C}")
       
         apply simp
        apply (subgoal_tac "m1.\<alpha> l1 v = m1.lookup v l1")
         defer
         apply (simp add: m1.lookup_correct s3.correct invar_C invar_B)
        apply simp 
        apply auto
      proof -
        {
          fix a b v'
          assume p1: "\<not> s3.isEmpty (s3.inter v' B)" and 
                 p2: "m1.lookup v l1 = Some m2" and
                 p3: "m2.\<alpha> m2 a = Some v'"
          from this invar_l  
          have con1: "s3.invar v'"
            unfolding ltsbm_invar_def Ball_def
            apply auto
            using invar_l ltsbm_invar_alt_def2 m2.lookup_correct by auto
          from p1 this invar_B s3.correct show " \<exists>v''. v'' \<in> s3.\<alpha> v' \<and> v'' \<in> s3.\<alpha> B"
            by auto
        }
        {
          fix a b v'' s3
           assume p1: "s3.isEmpty (s3.inter s3 B)" and 
                 p2: "m1.lookup v l1 = Some m2" and
                 p3: "m2.\<alpha> m2 a = Some s3" and
                 p4: "v'' \<in> s3.\<alpha> B" and
                 p5: "v'' \<in> s3.\<alpha> s3"
          from this invar_l  
          have con1: "s3.invar s3"
            unfolding ltsbm_invar_def Ball_def
            apply auto
            using invar_l ltsbm_invar_alt_def2 m2.lookup_correct by auto
          from p1 p4 p5 this invar_B s3.correct show "False"
            by auto         
        }
        
    qed
  qed
qed

definition ltsbm_succ_label_it where
   "ltsbm_succ_label_it it2 it3 m1 v =
     (case m1.lookup v m1 of
         None \<Rightarrow> set_iterator_emp
       | Some m2 \<Rightarrow> 
           map_iterator_product 
             (\<lambda> c f. it2 m2 c f) (\<lambda> s3 c f. it3 s3 c f))"



  lemma ltsbm_succ_label_it_alt_def :
    "ltsbm_succ_label_it = (\<lambda>it2 it3 m1 v. 
      (case m1.lookup v m1 of
          None \<Rightarrow> \<lambda>c f \<sigma>0. \<sigma>0
        | Some m2 \<Rightarrow> \<lambda>c f. it2 m2 c (\<lambda>x y. it3 (snd x) c (\<lambda>b. f (fst x, b)) y)))"
    unfolding ltsbm_succ_label_it_def
              map_iterator_product_alt_def map_to_set_iterator_def curry_def
              fst_conv snd_conv set_iterator_emp_def
    by simp

  lemma ltsbm_succ_label_it_correct :
    assumes it2_OK: "map_iteratei m2.\<alpha> m2.invar it2"
    assumes it3_OK: "set_iteratei s3.\<alpha> s3.invar it3"
    shows "lts_succ_label_it ltsbm_\<alpha> ltsbm_invar (ltsbm_succ_label_it it2 it3)"
  unfolding lts_succ_label_it_def
  proof (intro allI impI)
    fix l v
    assume invar_l: "ltsbm_invar l"
    from invar_l have invar_m1: "m1.invar l"
      unfolding ltsbm_invar_def by simp

    show "set_iterator (ltsbm_succ_label_it it2 it3 l v) 
             {(e, v') |e v'. (v, e, v') \<in> ltsbm_\<alpha> l}"
    proof (cases "m1.lookup v l")
      case None note m1_v_eq = this
      with invar_m1 have "{(e, v') |e v'. (v, e, v') \<in> ltsbm_\<alpha> l} = {}"
        unfolding ltsbm_\<alpha>_def
         by (simp add: m1.correct)         
      thus ?thesis
        unfolding ltsbm_succ_label_it_def
        by (simp add: m1_v_eq set_iterator_emp_correct)
    next
      case (Some m2) note m1_v_eq = this
      with invar_l have invar_m2: "m2.invar m2" 
        unfolding ltsbm_invar_alt_def 
        by (simp add: m1.correct)

      from it2_OK invar_m2 
      have it2_OK': "set_iterator 
                      (\<lambda> c f. it2 m2 c f) 
                      (map_to_set (m2.\<alpha> m2))"
        unfolding map_iteratei_alt_def map_to_set_iterator_def
        apply simp
        done
        
      have it3_OK': "\<And>k s3. m2.\<alpha> m2 k = Some s3 \<Longrightarrow> 
           set_iterator (\<lambda>c f. it3 s3 c f) (s3.\<alpha> s3)"
      proof -
        fix k s3
        assume m2_k_eq: "m2.\<alpha> m2 k = Some s3"

        from invar_l invar_m1 invar_m2 m1_v_eq m2_k_eq 
        have invar_s3: "s3.invar s3"
          unfolding ltsbm_invar_alt_def
          by (simp add: m1.correct m2.correct)

        with it3_OK show "set_iterator (\<lambda>c f. it3 s3 c f) (s3.\<alpha> s3)"
          unfolding set_iteratei_alt_def by simp
      qed

      from map_iterator_product_correct [OF it2_OK', 
         of "\<lambda>s3 c f. it3 s3 c f" "s3.\<alpha>"] it3_OK' m1_v_eq invar_m1
      show ?thesis
        apply (simp add: ltsbm_succ_label_it_def ltsbm_\<alpha>_def)
        by (simp add: m1.correct)
    qed
  qed

  
definition ltsbm_filter_it where
    "ltsbm_filter_it it1 it2 it3 P_v1 P_e P_v2 P m1 =
        set_iterator_filter (\<lambda>(v, e, v'). P_v2 v' \<and> P (v, e, v'))
        (map_iterator_product 
           (map_iterator_key_filter P_v1 (map_to_set_iterator m1 it1)) 
           (\<lambda>m2. map_iterator_product 
               (map_iterator_key_filter P_e (map_to_set_iterator m2 it2)) 
                  (\<lambda>s3 c f. it3 s3 c f)))"



lemma ltsbm_filter_it_alt_def :
     "ltsbm_filter_it = (\<lambda>it1 it2 it3 P_v1 P_e P_v2 P m1 c f.
        it1 m1 c (\<lambda> x1 \<sigma>. if P_v1 (fst x1) then it2 (snd x1) c 
          (\<lambda> x2 \<sigma>. if P_e (fst x2) then it3 (snd x2) c
            (\<lambda>v2 \<sigma>. if P_v2 v2 \<and> P ((fst x1), (fst x2), v2) then 
               f ((fst x1), (fst x2), v2) \<sigma> else \<sigma>) \<sigma> else \<sigma>) \<sigma>
             else \<sigma>))"
  unfolding ltsbm_filter_it_def map_iterator_product_alt_def
               fst_conv snd_conv set_iterator_filter_alt_def 
               map_iterator_key_filter_alt_def
               map_to_set_iterator_def
  by (auto)
  

  lemma ltsbm_filter_it_correct :
    assumes it1_OK: "map_iteratei m1.\<alpha> m1.invar it1"
    assumes it2_OK: "map_iteratei m2.\<alpha> m2.invar it2"
    assumes it3_OK: "set_iteratei s3.\<alpha> s3.invar it3"
    shows "lts_filter_it ltsbm_\<alpha> ltsbm_invar (ltsbm_filter_it it1 it2 it3)"
  unfolding lts_filter_it_def
  proof (intro allI impI)
    fix l P_v1 P_e P_v2 P
    assume invar_l: "ltsbm_invar l"
    from invar_l have invar_m1: "m1.invar l"
      unfolding ltsbm_invar_def by simp

    let ?it2'' = "\<lambda>m2. map_iterator_product 
      (map_iterator_key_filter P_e (map_to_set_iterator m2 it2)) (\<lambda>s3 c f. it3 s3 c f)"
    let ?S_2'' = "\<lambda>m2. {(e, v'). \<exists>s3. m2.\<alpha> m2 e = Some s3 \<and> P_e e \<and> v' \<in> s3.\<alpha> s3}"

    { fix v m2
      assume l_v_eq:"(m1.\<alpha> l |` {v. P_v1 v}) v = Some m2"

      from invar_l l_v_eq have invar_m2: "m2.invar m2"
        unfolding ltsbm_invar_alt_def 
        by (auto simp add: m1.correct restrict_map_eq)

      { fix e s3
        assume m2_e_eq: "(m2.\<alpha> m2 |` {e. P_e e}) e = Some s3"
        from invar_l l_v_eq invar_m2 m2_e_eq have invar_s3: "s3.invar s3"
          unfolding ltsbm_invar_alt_def restrict_map_def
          by (simp add: m1.correct m2.correct split: if_splits)

        note it3_OK' = set_iteratei_alt_D [OF it3_OK, OF invar_s3]
      } note it3_OK'' = this

      note it2_OK' = map_iteratei_alt_D [OF it2_OK, OF invar_m2]
      note it2_OK'' = map_iterator_key_filter_correct 
                      [OF it2_OK', of P_e]

      from map_iterator_product_correct 
              [OF it2_OK'', of "\<lambda>s3 c f. it3 s3 c f" s3.\<alpha>] it3_OK''
      have "set_iterator (?it2'' m2) (?S_2'' m2)" 
        by (simp add: restrict_map_eq)
    } note it2_OK'' = this

    have aux: "{(k, e). \<exists>v. m1.\<alpha> l k = Some v \<and> (case e of (k, e) \<Rightarrow>
              \<exists>va. m2.\<alpha> v k = Some va \<and> e \<in> s3.\<alpha> va)} = ltsbm_\<alpha> l"
      unfolding ltsbm_\<alpha>_def by auto

    note it1_OK' = map_iteratei_alt_D [OF it1_OK, OF invar_m1]
    note it1_OK'' = map_iterator_key_filter_correct [OF it1_OK' , of P_v1]

    let ?it1'' = "map_iterator_product 
      (map_iterator_key_filter P_v1 (map_to_set_iterator l it1)) ?it2''"
    let ?S_1'' = "{(k, e). \<exists>v. m1.\<alpha> l k = Some v \<and> P_v1 k \<and>
           (case e of (e, v') \<Rightarrow> \<exists>s3. m2.\<alpha> v e = Some s3 \<and> P_e e \<and> v' \<in> s3.\<alpha> s3)}"

    have S_1''_eq: "?S_1'' = {(v, e, v'). (v, e, v') \<in> ltsbm_\<alpha> l \<and> P_v1 v \<and> P_e e}"
      unfolding ltsbm_\<alpha>_def by auto

    from map_iterator_product_correct [OF it1_OK'', of ?it2'' ?S_2''] it2_OK''
    have it1_OK'': "set_iterator ?it1'' 
       {(v, e, v'). (v, e, v') \<in> ltsbm_\<alpha> l \<and> P_v1 v \<and> P_e e}"
      by (simp add: restrict_map_eq S_1''_eq)

    from set_iterator_filter_correct [OF it1_OK'', of 
            "(\<lambda>(v, e, v'). P_v2 v' \<and> P (v,e,v'))"]
    show "set_iterator (ltsbm_filter_it it1 it2 it3 P_v1 P_e P_v2 P l)
           {(v1, e, v2). (v1, e, v2) \<in> ltsbm_\<alpha> l \<and> P_v1 v1 \<and> P_e e \<and> P_v2 v2 \<and> P (v1, e, v2)}"
      unfolding ltsbm_filter_it_def[symmetric] 
      apply simp
      apply (rule subst [where P = "set_iterator 
              (ltsbm_filter_it it1 it2 it3 P_v1 P_e P_v2 P l)"])
       apply (auto simp add: ltsbm_filter_it_def prod_eq_iff)
    done
  qed

  definition ltsbm_it where
    "ltsbm_it it1 it2 it3 =
     ltsga_iterator (ltsbm_filter_it it1 it2 it3)"

definition ltsbm_it1 where
     "ltsbm_it1 = (\<lambda>it1 it2 it3 l c f. it1 l c 
            (\<lambda>v. it2 c (\<lambda>e. it3 c (\<lambda>v'. f (v, e, v')))))"


  lemma ltsbm_it_correct :
    assumes it1_OK: "map_iteratei m1.\<alpha> m1.invar it1"
    assumes it2_OK: "map_iteratei m2.\<alpha> m2.invar it2"
    assumes it3_OK: "set_iteratei s3.\<alpha> s3.invar it3"
    shows "lts_iterator ltsbm_\<alpha> ltsbm_invar (ltsbm_it it1 it2 it3)"
  unfolding ltsbm_it_def
  apply (rule ltsga_iterator_correct)
    apply (rule ltsbm_filter_it_correct)
    apply fact+
  done

end
end