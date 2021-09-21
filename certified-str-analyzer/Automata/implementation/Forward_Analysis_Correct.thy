

(*  
    Authors:     Shuanglong Kan <shuanglong@uni-kl.de>           
*)

theory Forward_Analysis_Correct

imports "../Forward_Analysis" "Forward_Analysis_Impl" "HOL-Library.Tree"

begin

definition sat_pred_ass where
  "sat_pred_ass S rc rm ag = (
    (\<forall> v \<in> S. \<exists> w. w = ag v) \<and>
    (\<forall> v w. v \<in> S \<and>  w = ag v \<longrightarrow> w \<in> \<L> (the (rm v)))
     \<and> (\<forall> v1 v2 v. v \<in> dom rc \<and> v \<in> S \<and> (v1,v2) \<in> the (rc v) \<longrightarrow> 
        (\<exists> w w1 w2. w1 = ag v1 \<and> w2 = ag v2 \<and>
          w = w1 @ w2 \<and> 
          w1 \<in> \<L> (the (rm v1)) \<and>
          w2 \<in> \<L> (the (rm v2)))
        ) 
   )"

lemma sat_pred_ass_com: "
  S1 \<inter> S2 = {} \<and> 
  (\<forall> v v1 v2. v \<in> dom rc \<and> v \<in> S1 \<and> (v1,v2) \<in> (the (rc v)) \<longrightarrow> v1 \<in> S1 \<and> v2 \<in> S1) \<and>
  (\<forall> v v1 v2. v \<in> dom rc \<and> v \<in> S2 \<and> (v1,v2) \<in> (the (rc v)) \<longrightarrow> v1 \<in> S2 \<and> v2 \<in> S2) \<and> 
  sat_pred_ass S1 rc rm arg1 \<and> sat_pred_ass S2 rc rm arg2
  \<longrightarrow> sat_pred_ass (S1 \<union> S2) rc rm (override_on arg1 arg2 S2)"
  unfolding sat_pred_ass_def
  by (metis (mono_tags, lifting) Un_iff override_on_apply_in override_on_apply_notin)  




definition forward_spec where
  "forward_spec rm' S rc rm  = 
   (RETURN ({}, rm', S) \<le> SPEC (\<lambda> (S', rm1, R'). 
                      S' = {} \<and> 
                      S = S' \<union> R' \<and>
                      S' \<inter> R' = {} \<and>
                      dom rm1 = dom rm \<and> 
                      (\<forall> v \<in> S. \<forall> w. NFA (the (rm1 v)) \<and> 
                      ((NFA_accept (the (rm1 v)) w) \<longleftrightarrow>   
                       (NFA_accept (the (rm v)) w) \<and> (v \<in> dom rc \<longrightarrow>
                       (\<forall> (v1, v2) \<in> (the (rc v)). \<exists> w1 w2.
                       NFA_accept (the (rm1 v1)) w1 \<and> 
                       NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2))))))" 


lemma Forward_analysis_sat_gen:
  fixes rc :: "'a \<Rightarrow> ('a \<times> 'a) set option" and
        S  :: "'a set" and
        rm :: "'a \<Rightarrow> ('g :: NFA_states, 'h) NFA_rec option" and
        rm' :: "'a \<Rightarrow> ('g, 'h) NFA_rec option" and
        ag :: "'a \<Rightarrow> 'h list"
  assumes rm_v_OK: "\<And> v. v \<in> dom rm \<longrightarrow> NFA (the (rm v))"
      and rc_OK: "dom rc \<subseteq> S \<and> (\<forall> v \<in> S. v \<in> dom rc \<longrightarrow> finite (the (rc v)))" 
      and rm_OK: "S = dom rm" 
      and finite_S: "finite S"
      and S_ok: "S = \<Union> (set l) \<and> acyclic rc l"
      and result_Ok: "forward_spec rm' S rc rm"
    shows "sat_pred_as S rc rm ag \<longrightarrow> 
           (\<forall> v. v \<in> dom rm' \<longrightarrow> ag v \<in> \<L> (the (rm' v)))"
  apply (insert S_ok rc_OK result_Ok rm_OK finite_S rm_v_OK)
  apply (induction rc l arbitrary: S rm rm' rule: acyclic.induct )
  unfolding sat_pred_as_def
  apply simp
proof -
  {
    fix rc :: "'a \<Rightarrow> ('a \<times> 'a) set option"  
    fix S :: "'a set"
    fix rm :: "'a \<Rightarrow> ('g :: NFA_states, 'h) NFA_rec option"
    fix rm' :: "'a \<Rightarrow> ('g, 'h) NFA_rec option"
    assume p1: "rc = Map.empty" and
           p3: "forward_spec rm' {} Map.empty Map.empty" and
           p4: "S = {}" 
    from p3[unfolded forward_spec_def]
    have "dom rm' = dom Map.empty" 
      by auto
    from this show "\<forall>v. v \<in> dom rm' \<longrightarrow> ag v \<in> \<L> (the (rm' v))"
      by simp
  }{
    fix rc :: "'a \<Rightarrow> ('a \<times> 'a) set option"  
    fix a :: "'a set"
    fix l :: "'a set list"
    fix S :: "'a set"
    fix rm :: "'a \<Rightarrow> ('g :: NFA_states, 'h) NFA_rec option"
    fix rm' :: "'a \<Rightarrow> ('g, 'h) NFA_rec option"
    assume p1: "\<And>(S :: 'a set) (rm :: 'a \<Rightarrow> ('g, 'h) NFA_rec option)  
            (rm' :: 'a \<Rightarrow> ('g, 'h) NFA_rec option).
           S = \<Union> (set l) \<and> Forward_Analysis.acyclic (rc |` \<Union> (set l)) l \<Longrightarrow>
           dom (rc |` \<Union> (set l)) \<subseteq> S \<and> (\<forall>v\<in>S. v \<in> dom (rc |` \<Union> (set l)) \<longrightarrow> finite (the ((rc |` \<Union> (set l)) v))) \<Longrightarrow>
           forward_spec rm' S (rc |` \<Union> (set l)) rm \<Longrightarrow>
           S = dom rm \<Longrightarrow>
           finite S \<Longrightarrow>
           (\<And>v. v \<in> dom rm \<longrightarrow> NFA (the (rm v))) \<Longrightarrow>
           (\<forall>v\<in>S. ag v \<in> \<L> (the (rm v))) \<and>
           (\<forall>v1 v2 v.
               v \<in> dom (rc |` \<Union> (set l)) \<and> (v1, v2) \<in> the ((rc |` \<Union> (set l)) v) \<longrightarrow>
               ag v = ag v1 @ ag v2 \<and>
               ag v1 \<in> \<L> (the (rm v1)) \<and> ag v2 \<in> \<L> (the (rm v2))) \<longrightarrow>
           (\<forall>v. v \<in> dom rm' \<longrightarrow> ag v \<in> \<L> (the (rm' v)))" and
        p2: "S = \<Union> (set (a # l)) \<and> Forward_Analysis.acyclic rc (a # l)" and
        p3: "dom rc \<subseteq> S \<and> (\<forall>v\<in>S. v \<in> dom rc \<longrightarrow> finite (the (rc v)))" and
        p4: "forward_spec rm' S rc rm" and
        p5: "S = dom rm" and
        p6: "finite S" and
        p7: "(\<And>v. v \<in> dom rm \<longrightarrow> NFA (the (rm v)))" 
    show  " (\<forall>v\<in>S. ag v \<in> \<L> (the (rm v))) \<and>
       (\<forall>v1 v2 v.
           v \<in> dom rc \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
           ag v = ag v1 @ ag v2 \<and>
           ag v1 \<in> \<L> (the (rm v1)) \<and> ag v2 \<in> \<L> (the (rm v2))) \<longrightarrow>
       (\<forall>v. v \<in> dom rm' \<longrightarrow> ag v \<in> \<L> (the (rm' v)))"
      apply (rule impI)+
    proof 
      fix v
      assume p8: "(\<forall>v\<in>S. ag v \<in> \<L> (the (rm v))) \<and>
         (\<forall>v1 v2 v.
             v \<in> dom rc \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
             ag v = ag v1 @ ag v2 \<and>
             ag v1 \<in> \<L> (the (rm v1)) \<and> ag v2 \<in> \<L> (the (rm v2)))"
      show "v \<in> dom rm' \<longrightarrow> ag v \<in> \<L> (the (rm' v))"
        apply (rule impI)
      proof -
        assume p9: "v \<in> dom rm'"

        from p4[unfolded forward_spec_def]
        have "dom rm' = dom rm \<and>
              (\<forall>v\<in>S. \<forall>w. NFA (the (rm' v)) \<and>
                          NFA_accept (the (rm' v)) w =
                          (NFA_accept (the (rm v)) w \<and> (v \<in> dom rc \<longrightarrow>
                           (\<forall>(v1, v2)\<in>the (rc v).
                               \<exists>w1 w2.
                                  NFA_accept (the (rm' v1)) w1 \<and>
                                  NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2))))"
          by simp
        from this p3 p9 
        have "dom rm' = S \<and> dom rm = dom rm' \<and> v \<in> S" 
          using p5 by auto

    from p2 have p22': "S = \<Union> (set (a # l))" 
          by blast
    let ?S = "S - a"
     let ?rc = "rc |` ?S"
     let ?rm = "rm |` ?S"
     let ?rm' = "rm' |` ?S"
     from p2 acyclic_correct 
     have "a \<inter> (\<Union> (set l)) = {}"
       by (metis acyclic.simps(2))
    from this p22' have cce1: "(\<Union> (set l)) = (S - a)" 
      by auto
    have c3: "dom (rc |` \<Union> (set l)) \<subseteq> S - a \<and> 
      (\<forall>v\<in>S - a. v \<in> dom (rc |` \<Union> (set l)) \<longrightarrow> finite (the ((rc |` \<Union> (set l)) v)))"
    using cce1 p3 by auto

    have imp: "\<And> v. v \<in> S - a \<and> v \<in> dom ?rm' \<Longrightarrow>  ag v \<in> \<L> (the (?rm' v))" 
    proof -
      fix v
     assume notvaa: "v \<in> S - a \<and> v \<in> dom ?rm'"
     from p7 notvaa
     have c11: "(\<And>v. v \<in> dom ?rm \<longrightarrow> NFA (the (?rm v)))"
       by auto
    from p4[unfolded forward_spec_def]
    have pe1: "RETURN ({}, rm', S) \<le> SPEC (\<lambda>(S', rm1, R').
              S' = {} \<and>
              S = S' \<union> R' \<and>
              S' \<inter> R' = {} \<and>
              dom rm1 = dom rm \<and>
              (\<forall>v\<in>S. \<forall>w. NFA (the (rm1 v)) \<and>
                          NFA_accept (the (rm1 v)) w =
                          (NFA_accept (the (rm v)) w \<and>  (v \<in> dom rc \<longrightarrow>
                           (\<forall>(v1, v2)\<in>the (rc v).
                               \<exists>w1 w2.
                                  NFA_accept (the (rm1 v1)) w1 \<and>
                                  NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2)))))"
      by simp
      
     from p3
     have c12: "dom ?rc \<subseteq> ?S \<and> (\<forall>v\<in>?S. v \<in> dom ?rc \<longrightarrow> finite (the (?rc v))) "
       apply auto
       done
     from p5
     have c13: "S - a = dom (rm |` (S - a))" by auto
     from p6 have c14: "finite (S - a)" by auto

    from pe1 have "(dom rm) = (dom rm')"
      apply auto
      done


    from p2 have "a \<inter> \<Union> (set l) = {}"
      by (metis acyclic.simps(2))
    from this p22'
    have S_a_correct: "S - a = \<Union> (set l)"
      by auto
    from p2 this
    have b1: "Forward_Analysis.acyclic ?rc l" 
      by (metis acyclic_correct cce1)
    from notvaa acyclic_dep1[of "(rc |` (S - a))" l] b1 this have b2:
    "(\<forall>v v1 v2.
        v \<in> \<Union> (set l) \<and> v \<in> dom ?rc \<and> (v1, v2) \<in> the (?rc v) \<longrightarrow>
        v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))" 
      by blast
   
     from notvaa p8 have c1: "(\<forall>v\<in>?S. ag v \<in> \<L> (the (?rm v))) \<and>
       (\<forall>v1 v2 v.
           v \<in> dom (rc |` \<Union> (set l)) \<and> (v1, v2) \<in> the ((rc |` \<Union> (set l)) v) \<longrightarrow>
           ag v = ag v1 @ ag v2 \<and>
           ag v1 \<in> \<L> (the (?rm v1)) \<and> ag v2 \<in> \<L> (the (?rm v2)))"
     proof -
       assume p1: "v \<in> S - a \<and> v \<in> dom (rm' |` (S - a))" and 
              p2: "(\<forall>v\<in>S. ag v \<in> \<L> (the (rm v))) \<and>
    (\<forall>v1 v2 v.
        v \<in> dom rc \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
        ag v = ag v1 @ ag v2 \<and> ag v1 \<in> \<L> (the (rm v1)) \<and> ag v2 \<in> \<L> (the (rm v2)))"
       from this b2 S_a_correct
        have "(\<forall>v\<in>S - a. ag v \<in> \<L> (the ((rm |` (S - a)) v))) \<and>
         (\<forall>v1 v2 v.
             v \<in> dom (rc |` \<Union> (set l)) \<and> (v1, v2) \<in> the ((rc |` \<Union> (set l)) v) \<longrightarrow>
             ag v = ag v1 @ ag v2 \<and>
             ag v1 \<in> \<L> (the ((rm |` (S - a)) v1)) \<and>
             ag v2 \<in> \<L> (the ((rm |` (S - a)) v2)))"
          by (metis Diff_iff Int_iff cce1 dom_restrict restrict_in)
        from this show "?thesis" by blast
      qed
      
      from c1 cce1 p2 have ccc1: "(\<forall>v\<in>?S. ag v \<in> \<L> (the (?rm v))) \<and>
     (\<forall>v1 v2 v.
         v \<in> dom (rc |` \<Union> (set l)) \<and> (v1, v2) \<in> the ((rc |` \<Union> (set l)) v) \<longrightarrow>
         ag v = ag v1 @ ag v2 \<and>
             ag v1 \<in> \<L> (the ((rm |` (S - a)) v1)) \<and>
             ag v2 \<in> \<L> (the ((rm |` (S - a)) v2)))"
        by (simp only: cce1)
              
     from p2
     have c2: "?S = \<Union> (set l) \<and> Forward_Analysis.acyclic ?rc l"
       apply (rule_tac conjI)
     proof -
       {
       assume p1: "S = \<Union> (set (a # l)) \<and> Forward_Analysis.acyclic rc (a # l)"

       from p1 have "a \<inter> (\<Union> (set l)) = {}" by (metis acyclic.simps(2))
       from this p22'
       show "S - a = \<Union> (set l)"
         by auto
     }{
       assume p1: " S = \<Union> (set (a # l)) \<and> Forward_Analysis.acyclic rc (a # l)"
       from p1 p22' have a: "a \<inter> (\<Union> (set l)) = {}" by (metis acyclic.simps(2))
       from p1 this p3
       have  cc1: "Forward_Analysis.acyclic (rc |` (S - a)) l" 
         by (metis \<open>S = \<Union> (set (a # l)) \<and> Forward_Analysis.acyclic rc (a # l) \<Longrightarrow> S - a = \<Union> (set l)\<close> acyclic_correct)
       from a p3 have "\<And>aa.  aa \<in> (\<Union> (set l)) \<longrightarrow> (rc aa) = ((rc |` (S - a)) aa)"
         unfolding restrict_map_def
         apply simp
         by auto
          
       from p3 this a cc1 acyclic_correct
       show "Forward_Analysis.acyclic (rc |` (S - a)) l"
         by blast      
     }
   qed
   from p2 acyclic_correct
   have ccc2: "S - a = \<Union> (set l) \<and> Forward_Analysis.acyclic (rc |` \<Union> (set l)) l"
     using c2 by blast
     from p3
     have c3: "dom (rc |` \<Union> (set l)) \<subseteq> (S - a) \<and> 
    (\<forall>v\<in>S - a. v \<in> dom (rc |` \<Union> (set l)) \<longrightarrow> finite (the ((rc |` \<Union> (set l)) v)))"
       using cce1 by auto
     from p4
     have ccc4: "dom rm' = dom rm \<and>
              (\<forall>v\<in>S. \<forall>w. NFA (the (rm' v)) \<and>
                          NFA_accept (the (rm' v)) w =
                          (NFA_accept (the (rm v)) w \<and>  (v \<in> dom rc \<longrightarrow>
                           (\<forall>(v1, v2)\<in>the (rc v).
                               \<exists>w1 w2.
                                  NFA_accept (the (rm' v1)) w1 \<and>
                                  NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2))))"
       unfolding forward_spec_def by auto
     from this
     have cccc4: "forward_spec (rm' |` (S - a)) (S - a) (rc |` \<Union> (set l)) (rm |` (S - a))"
       unfolding forward_spec_def
       apply simp
     proof 
       fix v
       assume pt1: "dom rm' = dom rm \<and>
         (\<forall>v\<in>S. NFA (the (rm' v)) \<and>
                 (\<forall>w. NFA_accept (the (rm' v)) w =
                      (NFA_accept (the (rm v)) w \<and> (v \<in> dom rc \<longrightarrow>
                       (\<forall>x\<in>the (rc v).
                           case x of
                           (v1, v2) \<Rightarrow>
                             \<exists>w1. NFA_accept (the (rm' v1)) w1 \<and>
                                  (\<exists>w2. NFA_accept (the (rm' v2)) w2 \<and>
                                        w = w1 @ w2))))))" and
     pt2: "v \<in> S - a"
       show " \<forall>w. (NFA_accept (the (rm v)) w \<and>
              (v \<in> dom rc \<longrightarrow>
               (\<forall>(v1, v2)\<in>the (rc v).
                   \<exists>w1. NFA_accept (the (rm' v1)) w1 \<and>
                        (\<exists>w2. NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2)))) =
             (NFA_accept (the (rm v)) w \<and>
              (v \<in> dom rc \<and> Bex (set l) ((\<in>) v) \<longrightarrow>
               (\<forall>(v1, v2)\<in>the (rc v).
                   \<exists>w1. NFA_accept (the ((rm' |` (S - a)) v1)) w1 \<and>
                        (\<exists>w2. NFA_accept (the ((rm' |` (S - a)) v2)) w2 \<and>
                              w = w1 @ w2))))"
         apply auto
           defer
         using cce1 pt2 apply auto[1]
     proof -
     {fix w aa b x y
       assume pb1: "NFA_accept (the (rm v)) w" and
              pb2: "\<forall>x\<in>y. case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the (rm' v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2) " and
              pb3: "(aa, b) \<in> y" and
              pb4: "x \<in> set l" and 
              pb5: "v \<in> x" and
              pb6: "rc v = Some y"
       from this have aa_b: "(aa, b) \<in> the (rc v)" 
         using cce1 pt2 by auto
       from this pb2 pb3 have cy1: "\<exists>w1. NFA_accept (the (rm' aa)) w1 \<and>
                 (\<exists>w2. NFA_accept (the (rm' b)) w2 \<and> w = w1 @ w2)"
         by auto
       from c2 have c3: "Forward_Analysis.acyclic (rc |` (S - a)) l" 
         by blast
       from pt2 have pt2': "v \<in> \<Union> (set l)"
         using cce1 by blast
       from pb6 have "v \<in> dom rc" by auto
       from acyclic_dep1[of "rc |` \<Union> (set l)" l] c3 S_a_correct have
       "(\<forall>v v1 v2.
        v \<in> \<Union> (set l) \<and>
        v \<in> dom (rc |` \<Union> (set l)) \<and> (v1, v2) \<in> the ((rc |` \<Union> (set l)) v) \<longrightarrow>
        v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))"
         by (metis b2 cce1) 
       from this pt2 pt2' cce1 pb3 pb6
       have "aa \<in> \<Union> (set l) \<and> b \<in> \<Union> (set l)"
         by (metis (no_types, lifting) aa_b restrict_map_eq(2) restrict_map_self)

       from this S_a_correct cy1
       show "\<exists>w1. NFA_accept (the ((rm' |` (S - a)) aa)) w1 \<and>
            (\<exists>w2. NFA_accept (the ((rm' |` (S - a)) b)) w2 \<and> w = w1 @ w2)"
         by auto
     }
     {
       fix w aa b y
       assume p1: "NFA_accept (the (rm v)) w"
          and p2: "\<forall>x\<in>y. case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the ((rm' |` (S - a)) v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the ((rm' |` (S - a)) v2)) w2 \<and> w = w1 @ w2)"
          and p3: "(aa, b) \<in> y" and
          p4: "rc v = Some y" 
       from this have aa_b: "(aa, b) \<in> the ((rc |` \<Union> (set l)) v)" 
         using cce1 pt2 by auto
       from this p2 p3 p4 have cy1: "\<exists>w1. NFA_accept (the ((rm' |` (S - a)) aa)) w1 \<and>
                 (\<exists>w2. NFA_accept (the ((rm' |` (S - a)) b)) w2 \<and> w = w1 @ w2)"
         by auto
       from c2 have c3: "Forward_Analysis.acyclic (rc |` (S - a)) l" 
         by blast
       from acyclic_dep1[of "rc |` \<Union> (set l)" l] c3 S_a_correct have
       "(\<forall>v v1 v2.
        v \<in> \<Union> (set l) \<and>
        v \<in> dom (rc |` \<Union> (set l)) \<and> (v1, v2) \<in> the ((rc |` \<Union> (set l)) v) \<longrightarrow>
        v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))"
         by (metis b2 cce1)
       from this aa_b have "aa \<in> \<Union> (set l) \<and> b \<in> \<Union> (set l)"
         by (metis cce1 domI p4 pt2 restrict_map_eq(2))
       from this S_a_correct cy1
       show " \<exists>w1. NFA_accept (the (rm' aa)) w1 \<and>
            (\<exists>w2. NFA_accept (the (rm' b)) w2 \<and> w = w1 @ w2)"
         by simp
     }
   
   qed qed
     
     have ccc5: "S - a = dom (rm |` (S - a))"
       using c13 by blast
     have ccc6: "finite (S - a)"
       using c14 by blast

     have ccc7: "(\<And>v. v \<in> dom (rm |` (S - a)) \<longrightarrow> NFA (the ((rm |` (S - a)) v)))"
       using c11 by auto

     thm  ccc1 ccc2 c3 cccc4 ccc5 ccc6 ccc7
     note p1' =  p1 [OF ccc2 c3 cccc4 ccc5 ccc6 ccc7]
   
     from p1' ccc1 
     show "ag v \<in> \<L> (the ((rm' |` (S - a)) v))" 
       using notvaa by blast
   qed
   show "v \<in> dom rm' \<Longrightarrow> ag v \<in> \<L> (the (rm' v))"
   proof (cases "v \<notin> a")
case True
  from this imp show ?thesis 
    by (simp add: \<open>dom rm' = S \<and> dom rm = dom rm' \<and> v \<in> S\<close>) 
next
  case False note v_in_a = this
  thm imp
  from p2 have "a \<inter> \<Union> (set l) = {}"
    using \<open>a \<inter> \<Union> (set l) = {}\<close> by blast
    from p2 this
  have S_a_correct: "S - a = \<Union> (set l)"
    using cce1 by blast
  from p4[unfolded forward_spec_def]
  have cc1: "dom rm' = dom rm \<and>
              (\<forall>v\<in>S. \<forall>w. NFA (the (rm' v)) \<and>
                          NFA_accept (the (rm' v)) w =
                          (NFA_accept (the (rm v)) w \<and> (v \<in> dom rc \<longrightarrow>
                           (\<forall>(v1, v2)\<in>the (rc v).
                               \<exists>w1 w2.
                                  NFA_accept (the (rm' v1)) w1 \<and>
                                  NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2))))"
    by auto

  from this have imp1: "\<forall>w. NFA_accept (the (rm' v)) w =
                          (NFA_accept (the (rm v)) w \<and> (v \<in> dom rc \<longrightarrow>
                           (\<forall>(v1, v2)\<in>the (rc v).
                               \<exists>w1 w2.
                                  NFA_accept (the (rm' v1)) w1 \<and>
                                  NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2)))"
    by (simp add: \<open>dom rm' = S \<and> dom rm = dom rm' \<and> v \<in> S\<close>)

    from acyclic_dep2[of rc a l] p2 have b2:
    "(\<forall>v1 v2. v \<in> dom rc \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
        v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))" 
      using \<open>dom rm' = S \<and> dom rm = dom rm' \<and> v \<in> S\<close> p3 v_in_a by blast

    from p8
    have imp2 : "NFA_accept (the (rm v)) (ag v)"
      using NFA_accept_alt_def \<open>dom rm' = S \<and> dom rm = dom rm' \<and> v \<in> S\<close> by blast

    from imp 
    have cc3: "\<forall> v1. v1 \<in> S - a \<and> v1 \<in> dom (rm' |` (S - a)) \<longrightarrow> 
               NFA_accept (the (rm' v1)) (ag v1)"
      by (simp add: NFA_accept_alt_def)
   
    have cc4: "S - a =  \<Union> (set l)" 
      by (simp add: cce1)
    (* from p8 cc3 b2 this*)
    have "\<And> v1 v2. v \<in> dom rc \<and> (v1, v2)\<in>the (rc v) \<Longrightarrow> NFA_accept (the (rm' v1)) (ag v1) \<and>
                                NFA_accept (the (rm' v2)) (ag v2) \<and> 
                                (ag v) = (ag v1) @ (ag v2)"
    proof -
      fix v1 v2
      assume pc1: "v \<in> dom rc \<and> (v1, v2) \<in> the (rc v)"
      from p8 have ci1: "ag v = ag v1 @ ag v2"
        using \<open>dom rm' = S \<and> dom rm = dom rm' \<and> v \<in> S\<close> p3 pc1  by blast
      from cc3 have ci2: "NFA_accept (the (rm' v1)) (ag v1)"
        using \<open>dom rm' = S \<and> dom rm = dom rm' \<and> v \<in> S\<close> b2 cce1 pc1 by auto
       from cc3 have ci3: "NFA_accept (the (rm' v2)) (ag v2)"
        using \<open>dom rm' = S \<and> dom rm = dom rm' \<and> v \<in> S\<close> b2 cce1 pc1 by auto
      from ci1 ci2 ci3 show "NFA_accept (the (rm' v1)) (ag v1) \<and>
       NFA_accept (the (rm' v2)) (ag v2) \<and> ag v = ag v1 @ ag v2"
        by simp
    qed
    from imp1 imp2 this have "NFA_accept (the (rm' v)) (ag v)"
      by fastforce
    from this show ?thesis 
    using \<L>_def by blast
qed qed qed 
} qed


lemma Forward_analysis_unsat_gen:
  fixes rc :: "'a \<Rightarrow> ('a \<times> 'a) set option" and
        S  :: "'a set" and
        rm :: "'a \<Rightarrow> ('g :: NFA_states, 'h) NFA_rec option" and
        rm' :: "'a \<Rightarrow> ('g, 'h) NFA_rec option" 
  assumes rm_v_OK: "\<And> v. v \<in> dom rm \<longrightarrow> NFA (the (rm v))"
      and rc_OK: "dom rc \<subseteq> S \<and> (\<forall> v \<in> S. v \<in> dom rc \<longrightarrow> finite (the (rc v)))" 
      and rm_OK: "S = dom rm" 
      and finite_S: "finite S"
      and S_ok: "S = \<Union> (set l) \<and> acyclic rc l"
      and result_Ok: "forward_spec rm' S rc rm"
    shows "(\<exists> v. v \<in> dom rm' \<and> \<L> (the (rm' v)) = {}) \<longrightarrow>
            (\<forall> ag. \<not> (sat_pred_as S rc rm ag))"
  apply (rule impI)
proof -
  assume p0: "\<exists>v. v \<in> dom rm' \<and> \<L> (the (rm' v)) = {}"
  show "\<forall>ag. \<not> sat_pred_as S rc rm ag"
    apply (rule allI)
  proof 
    fix ag
    assume p1: "sat_pred_as S rc rm ag"
    note imp1 = 
      Forward_analysis_sat_gen[OF rm_v_OK rc_OK rm_OK finite_S S_ok result_Ok, of ag]
    from p1 imp1 have "(\<forall>v. v \<in> dom rm' \<longrightarrow> ag v \<in> \<L> (the (rm' v)))"
      by auto
    from this p0 show False
      by blast
  qed
qed

lemma Forward_analysis_unsat:
  fixes rc :: "'a \<Rightarrow> ('a \<times> 'a) set option" and
        S  :: "'a set" and
        rm :: "'a \<Rightarrow> ('g :: NFA_states, 'h) NFA_rec option" and
        rm' :: "'a \<Rightarrow> ('g, 'h) NFA_rec option" 
  assumes rm_v_OK: "\<And> v. v \<in> dom rm \<longrightarrow> NFA (the (rm v))"
      and rc_OK: "dom rc \<subseteq> S \<and> (\<forall> v \<in> S. v \<in> dom rc \<longrightarrow> finite (the (rc v)))" 
      and rc_wf: "\<forall>v1 v2 x. x \<in> dom rc \<and> (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<in> S \<and> v2 \<in> S"
      and rm_OK: "S = dom rm" 
      and finite_S: "finite S"
      and S_ok: "S = \<Union> (set l) \<and> acyclic rc l"
      and a_neq_b: "a \<noteq> b"
      and result_Ok: "RETURN ({},rm',S) = Forward_Analysis S rc rm a b"
    shows "(\<exists> v. v \<in> dom rm' \<and> \<L> (the (rm' v)) = {}) \<longrightarrow>
            (\<forall> ag. \<not> (sat_pred_as S rc rm ag))"
proof -
  from S_ok 
  have S_ok': "\<exists>l. S = \<Union> (set l) \<and> Forward_Analysis.acyclic rc l"
    by blast
  note fac =  Forward_analysis_correct[OF rm_v_OK rc_OK rc_wf rm_OK S_ok' finite_S a_neq_b]
  from result_Ok have impf: "forward_spec rm' S rc rm"
    unfolding forward_spec_def
    using fac
    by auto

  note imp1 =  Forward_analysis_unsat_gen[OF rm_v_OK rc_OK rm_OK finite_S S_ok impf]
  from imp1
  show "(\<exists> v. v \<in> dom rm' \<and> \<L> (the (rm' v)) = {}) \<longrightarrow>
            (\<forall> ag. \<not> (sat_pred_as S rc rm ag))"
    by simp
qed



definition uniq_indegree' where
   "uniq_indegree' rc = 
        (\<not>(\<exists> v v' v1 v2 v3 v4. v \<in> dom rc \<and> v' \<in> dom rc \<and> v \<noteq> v' \<and> 
          (v1, v2) \<in> (the (rc v)) \<and>
          (v3, v4) \<in> (the (rc v')) \<and> 
          (v1 = v2 \<or> v3 = v4 \<or> {v1, v2} \<inter> {v3, v4} \<noteq> {})))"

lemma uniq_eq: "uniq_indegree rc \<longrightarrow> uniq_indegree' rc"
  unfolding uniq_indegree_def uniq_indegree'_def
  by blast

fun reachable where
   "reachable rc [] = True"
 | "reachable rc [q] = True"
 | "reachable rc (q # q' # l) = 
              ((reachable rc (q' # l)) \<and> q \<in> dom rc \<and> 
               (\<exists> q1 q2. (q1, q2) \<in> (the (rc q)) \<and> (q' \<in> {q1,q2})))"

definition reachable_set where
   "reachable_set rc v = {v' . \<exists> l. reachable rc (v # l) \<and> last (v#l) = v'}"

fun reachable_set_l where
   "reachable_set_l rc [] = {}"
 | "reachable_set_l rc ((v1,v2) # l) = 
      (reachable_set rc v1 \<union> reachable_set rc v2 \<union> reachable_set_l rc l)"




definition child_set where
   "child_set rc v = 
        {v'. v \<in> dom rc \<and> (\<exists> v1 v2. (v1,v2) \<in> (the (rc v)) \<and> v' \<in> {v1,v2})}"



lemma reachable_in_l:
   "v \<in> a \<and> acyclic rc (a # l) \<and>
    reachable rc (v # m) \<Longrightarrow> 
    (\<forall> v'\<in> set m. v' \<in> \<Union> (set l))"
  apply (induction rc m arbitrary: v a l rule: reachable.induct)
  apply (metis all_not_in_conv empty_set)
proof -
  {
    fix rc q v a l
    assume p1: "v \<in> a \<and> Forward_Analysis.acyclic rc (a # l) \<and> reachable rc [v, q]"
    from this reachable.simps
    have "\<exists> v1 v2. (v1,v2) \<in> the (rc v) \<and> (v1 = q \<or> v2 = q)"
      by (metis insert_iff memb_imp_not_empty)
    from this acyclic_dep2
    have "q \<in> \<Union> (set l)"     
      by (metis p1 reachable.simps(3))
    from this show "\<forall>v'\<in>set [q]. v' \<in> \<Union> (set l)"
      by auto
  }{
    
    fix rc q q' l v a la
    
    assume p1: "\<And>v a la.
             v \<in> a \<and> Forward_Analysis.acyclic rc (a # la) \<and> 
             reachable rc (v # q' # l) \<Longrightarrow>
             \<forall>v'\<in>set (q' # l). v' \<in> \<Union> (set la)" 
  
and
           p2: "v \<in> a \<and> Forward_Analysis.acyclic rc (a # la) \<and> 
                reachable rc (v # q # q' # l)"

    from this have "\<exists> v1 v2. (v1,v2) \<in> the (rc v) \<and> (q = v1 \<or> q = v2)"
      by (meson empty_iff insertE reachable.simps(3))
    from this p1 p2 
    have "q \<in> \<Union> (set la)"
      by (meson acyclic_dep2 reachable.simps(3))
    from this p1 p2 
    have "\<exists> l1 aa l2. a # la = l1 @ (aa # l2) \<and> q \<in> aa"
      by (meson UnionE in_set_conv_decomp_last list.set_intros(2))
    from this obtain l1 aa l2 where
    c2: "a # la = l1 @ (aa # l2) \<and> q \<in> aa" by auto
    from p2 c2 reachable.simps 
    have "reachable rc (q # q' # l)"
      by fastforce  
    
    from p2 have "Forward_Analysis.acyclic rc (a # la)" by fastforce

    have c3: "\<And> l' l1' l2'. Forward_Analysis.acyclic rc l' \<and> l' = l1' @ l2' \<longrightarrow> 
           Forward_Analysis.acyclic rc l2'"
    proof -
      fix l' l1' l2'
      show "Forward_Analysis.acyclic rc l' \<and> l' = l1' @ l2' \<longrightarrow>
       Forward_Analysis.acyclic rc l2'"
      apply (induction l1' arbitrary: l' l2')
      apply (metis empty_append_eq_id)
    proof 
      {
        fix a l1' l' l2'
        assume p1: "(\<And>l' l2'.
           Forward_Analysis.acyclic rc l' \<and> l' = l1' @ l2' \<longrightarrow>
           Forward_Analysis.acyclic rc l2')" and 
         p2: "Forward_Analysis.acyclic rc l' \<and> l' = (a # l1') @ l2'"
        from this acyclic_tail 
        have "Forward_Analysis.acyclic rc (l1' @ l2')"
          by (metis append_Cons)
        from this p1
        show "Forward_Analysis.acyclic rc l2'"
          by blast
      } qed qed
  from p2 have c6: "q \<in> \<Union> (set la)"
    using \<open>q \<in> \<Union> (set la)\<close> by blast
  from c2 
  have c7: "Forward_Analysis.acyclic rc la"
    using \<open>Forward_Analysis.acyclic rc (a # la)\<close> acyclic_tail by blast
  have c71: "reachable rc (q # q' # l)"
    using \<open>reachable rc (q # q' # l)\<close> by blast
  from p2 c3 c6 obtain l1' b l2' where
   c4: "la = l1' @ (b # l2')
    \<and> q \<in> b"
    by (meson Union_iff in_set_conv_decomp_first)
  from this c7 c71
  have c8: "q \<in> b \<and> Forward_Analysis.acyclic rc (b # l2') \<and> reachable rc (q # q' # l)" 
    using c3 by blast
  from p1[of q b l2', OF c8] c4
  have "\<forall>v'\<in>set (q' # l). v' \<in> \<Union> (set la)"
    by fastforce
 from this
  show "\<forall>v'\<in>set (q # q' # l). v' \<in> \<Union> (set la)"
    using c6 by auto   
}qed



lemma acyclic_divide: 
   "\<And> l' l1' l2'. Forward_Analysis.acyclic rc l' \<and> l' = l1' @ l2' \<longrightarrow> 
           Forward_Analysis.acyclic rc l2'"
    proof -
      fix l' l1' l2'
      show "Forward_Analysis.acyclic rc l' \<and> l' = l1' @ l2' \<longrightarrow>
       Forward_Analysis.acyclic rc l2'"
      apply (induction l1' arbitrary: l' l2')
      apply (metis empty_append_eq_id)
    proof 
      {
        fix a l1' l' l2'
        assume p1: "(\<And>l' l2'.
           Forward_Analysis.acyclic rc l' \<and> l' = l1' @ l2' \<longrightarrow>
           Forward_Analysis.acyclic rc l2')" and 
         p2: "Forward_Analysis.acyclic rc l' \<and> l' = (a # l1') @ l2'"
        from this acyclic_tail 
        have "Forward_Analysis.acyclic rc (l1' @ l2')"
          by (metis append_Cons)
        from this p1
        show "Forward_Analysis.acyclic rc l2'"
          by blast
      } qed qed

lemma nocycle:
   "(v \<in> \<Union> (set l) \<and> acyclic rc l \<Longrightarrow> 
     (\<forall> m. \<not> reachable rc (v # m @ [v])))"
  apply (rule allI)
proof
  fix m 
  assume p2: "v \<in> \<Union> (set l) \<and> Forward_Analysis.acyclic rc l"  and
         p3: "reachable rc (v # m @ [v])"
  from p2 obtain l1 l2 a where
  c1: "l = l1 @ (a # l2) \<and> v \<in> a"
    by (meson Union_iff split_list_last)
  from this p2 acyclic_divide 
  have c2: "v \<in> a \<and> Forward_Analysis.acyclic rc (a # l2)"
    by blast
  from this p3 have c1: "v \<in> a \<and> Forward_Analysis.acyclic rc (a # l2)
                  \<and> reachable rc (v # m @ [v])"
    by fastforce
  from reachable_in_l[OF c1]
  have "v \<in> \<Union> (set l2)" by auto
  from c1 acyclic.simps
  have "v \<notin> \<Union> (set l2)"
    by (metis IntI memb_imp_not_empty)
  from this
  show "False"
    using \<open>v \<in> \<Union> (set l2)\<close> by blast
qed


lemma l1l2: "\<And> l1 l2. ((l1 = l2) \<or> (\<exists> l. l1 = l @ l2) \<or> (\<exists> l. l2 = l @ l1) \<or> 
                  (\<exists> l l1' l2'. l1 = l1' @ l \<and> l2 = l2' @ l \<and> l1' \<noteq> [] \<and> l2' \<noteq> [] 
                    \<and> last l1' \<noteq> last l2'))"
proof -
  fix l1 l2
  show "l1 = l2 \<or>
       (\<exists>l. l1 = l @ l2) \<or>
       (\<exists>l. l2 = l @ l1) \<or>
       (\<exists>l l1' l2'.
           l1 = l1' @ l \<and> l2 = l2' @ l \<and> l1' \<noteq> [] \<and> l2' \<noteq> [] \<and> last l1' \<noteq> last l2')"
    apply (induction l1)
    apply simp
  proof -
    fix a l1
    assume p0: "l1 = l2 \<or>
       (\<exists>l. l1 = l @ l2) \<or>
       (\<exists>l. l2 = l @ l1) \<or>
       (\<exists>l l1' l2'.
           l1 = l1' @ l \<and>
           l2 = l2' @ l \<and> l1' \<noteq> [] \<and> l2' \<noteq> [] \<and> last l1' \<noteq> last l2')"
    have c1: "l1 = l2 \<Longrightarrow> (\<exists>l. a # l1 = l @ l2)"
      by fastforce
    have c2: "(\<exists>l. l1 = l @ l2) \<Longrightarrow> (\<exists>l. a # l1 = l @ l2)"
      by fastforce
    have c3: "(\<exists>l. l2 = l @ l1) \<Longrightarrow> (\<exists>l. l2 = l @ a # l1) \<or> l1 = l2 \<or> (\<exists>l l1' l2'.
           a # l1 = l1' @ l \<and>
           l2 = l2' @ l \<and> l1' \<noteq> [] \<and> l2' \<noteq> [] \<and> last l1' \<noteq> last l2')"
    proof -
      assume p1 : "\<exists>l. l2 = l @ l1"
      from this obtain l where p1': "l2 = l @ l1" by auto
      show "(\<exists>l. l2 = l @ a # l1) \<or> l1 = l2 \<or> (\<exists>l l1' l2'.
           a # l1 = l1' @ l \<and>
           l2 = l2' @ l \<and> l1' \<noteq> [] \<and> l2' \<noteq> [] \<and> last l1' \<noteq> last l2')"
      proof (cases "l = []")
case True
  from this p1' show ?thesis by auto 
next
  case False
  note l_neq = this
  from p0 this p1' show ?thesis 
  proof (cases "last l = a")
case True
  from this p1' 
  show ?thesis 
    by (metis append.assoc append_Cons append_butlast_last_id empty_append_eq_id)
next
  case False
  note last_l_neq_a = this
  from this p1' l_neq
  have "a # l1 = [a] @ l1 \<and> l2 = l @ l1 \<and> [a] \<noteq> [] \<and> l \<noteq> []\<and> 
        last [a] \<noteq> last l" by auto
  from this
  show ?thesis
    by blast
qed
  
qed qed
  have c4: "(\<exists>l l1' l2'.
           l1 = l1' @ l \<and> l2 = l2' @ l \<and> l1' \<noteq> [] \<and> l2' \<noteq> [] \<and> last l1' \<noteq> last l2') \<Longrightarrow> 
        (\<exists>l l1' l2'.
           a # l1 = l1' @ l \<and>
           l2 = l2' @ l \<and> l1' \<noteq> [] \<and> l2' \<noteq> [] \<and> last l1' \<noteq> last l2')"
    by (metis append_Cons last_ConsR list.distinct(1))
  from c1 c2 c3 c4 p0
  show "a # l1 = l2 \<or>
       (\<exists>l. a # l1 = l @ l2) \<or>
       (\<exists>l. l2 = l @ a # l1) \<or>
       (\<exists>l l1' l2'.
           a # l1 = l1' @ l \<and>
           l2 = l2' @ l \<and> l1' \<noteq> [] \<and> l2' \<noteq> [] \<and> last l1' \<noteq> last l2')"
    by fastforce
qed qed
  
lemma reachable_div:  "l = l1 @ l2 \<and> reachable rc l \<longrightarrow> 
                       reachable rc l1 \<and> reachable rc l2"
  apply (induction l1 arbitrary: l)
  apply auto[1]
proof 
  fix a l1 l
  assume p1: "(\<And>l. l = l1 @ l2 \<and> reachable rc l \<longrightarrow> reachable rc l1 \<and> reachable rc l2)"
     and p2: "l = (a # l1) @ l2 \<and> reachable rc l"
  from p2 reachable.simps
  have reach_l1_l2: "reachable rc (l1 @ l2)"
    by (metis append_Cons reachable.elims(3))
  from p1[of "l1 @ l2"] this 
  have imp1: "reachable rc l1 \<and> reachable rc l2" 
    by auto
  from this have reachable_rc_l1: "reachable rc l1" by simp
  from p2 this
  have reachable_rc_al1: "reachable rc (a # l1)"
  proof (cases "l1 = []")
    case True
    then show ?thesis by auto
  next
    case False
    from this obtain b l1' 
    where b_l1': "l1 = b # l1'" 
      using neq_NilE by blast
    from this p2
    have c1: "l = a # b # l1' @ l2 \<and> reachable rc l"
      by auto
    from this reachable.simps
    have "\<exists> v1 v2. (v1,v2) \<in> the (rc a) \<and> (b = v1 \<or> b = v2)"
      by fastforce
    from this c1 b_l1' reachable_rc_l1 reachable.simps
    show ?thesis 
      by fastforce
  qed
  from this imp1
  show "reachable rc (a # l1) \<and> reachable rc l2"
    by simp
qed
    
lemma reachable_set_closure: "\<And> v v1 v2.
         v \<in> dom rc \<and> v \<in> reachable_set rc x1 \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
         v1 \<in> reachable_set rc x1 \<and> v2 \<in> reachable_set rc x1"
proof fix v v1 v2
  assume p1: "v \<in> dom rc \<and> v \<in> reachable_set rc x1 \<and> (v1, v2) \<in> the (rc v)"
  from p1 reachable_set_def
  obtain l where c1: "reachable rc (x1 # l) \<and> last (x1 # l) = v"
proof -
assume a1: "\<And>l. reachable rc (x1 # l) \<and> last (x1 # l) = v \<Longrightarrow> thesis"
  have c1: "v \<in> {a. \<exists>as. reachable rc (x1 # as) \<and> last (x1 # as) = a}"
    by (metis p1 reachable_set_def)
  then show ?thesis
using a1 by blast
qed
  from this p1 
  have c2: "reachable rc (x1 # l @ [v1])"
    apply (induction l arbitrary: x1)
    apply fastforce
  proof -
    fix a l x1
    assume p2: "(\<And>x1. reachable rc (x1 # l) \<and> last (x1 # l) = v \<Longrightarrow>
              v \<in> dom rc \<and> v \<in> reachable_set rc x1 \<and> (v1, v2) \<in> the (rc v) \<Longrightarrow>
              reachable rc (x1 # l @ [v1]))"
       and p3: "reachable rc (x1 # a # l) \<and> last (x1 # a # l) = v"
       and p4: "v \<in> dom rc \<and> v \<in> reachable_set rc x1 \<and> (v1, v2) \<in> the (rc v)"
    from p3 reachable.simps have c1: "reachable rc (a # l) \<and> last (a # l) = v"
      by fastforce
    from this p4 reachable_set_def
    have c2: "v \<in> dom rc \<and> v \<in> reachable_set rc a \<and> (v1, v2) \<in> the (rc v)"
      by fastforce
    from p3 have "\<exists> v1 v2. (v1,v2) \<in> the (rc x1) \<and> (a = v1 \<or> a = v2)" 
      by fastforce
    from p2[OF c1 c2] this reachable.simps
    show "reachable rc (x1 # (a # l) @ [v1])"
      using p3 by auto
  qed 
  from c1 p1
  have "reachable rc (x1 # l @ [v2])"
    apply (induction l arbitrary: x1)
    apply fastforce
  proof -
    fix a l x1
    assume p2: "(\<And>x1. reachable rc (x1 # l) \<and> last (x1 # l) = v \<Longrightarrow>
              v \<in> dom rc \<and> v \<in> reachable_set rc x1 \<and> (v1, v2) \<in> the (rc v) \<Longrightarrow>
              reachable rc (x1 # l @ [v2]))"
       and p3: "reachable rc (x1 # a # l) \<and> last (x1 # a # l) = v"
       and p4: "v \<in> dom rc \<and> v \<in> reachable_set rc x1 \<and> (v1, v2) \<in> the (rc v)"
    from p3 reachable.simps have c1: "reachable rc (a # l) \<and> last (a # l) = v"
      by fastforce
    from this p4 reachable_set_def
    have c2: "v \<in> dom rc \<and> v \<in> reachable_set rc a \<and> (v1, v2) \<in> the (rc v)"
      by fastforce
    from p3 have "\<exists> v1 v2. (v1,v2) \<in> the (rc x1) \<and> (a = v1 \<or> a = v2)" 
      by fastforce
    from p2[OF c1 c2] this reachable.simps
    show "reachable rc (x1 # (a # l) @ [v2])"
      using p3 by auto
  qed
  from this c2 reachable_set_def[of rc x1]
  show "v1 \<in> reachable_set rc x1 \<and> v2 \<in> reachable_set rc x1"
    using not_Cons_self2 by auto
qed

lemma reachable_set_l_closure:
       "\<And> v v1 v2.
        v \<in> dom rc \<and> v \<in> reachable_set_l rc l \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
        v1 \<in> reachable_set_l rc l \<and> v2 \<in> reachable_set_l rc l" 
  apply (rule impI)
proof - 
  fix v v1 v2
  assume p1: "v \<in> dom rc \<and> v \<in> reachable_set_l rc l \<and> (v1, v2) \<in> the (rc v)"
  from p1 have "v1 \<in> reachable_set_l rc l"
    apply (induction l)
    apply fastforce
  proof- 
    fix a l
    assume p2: "(v \<in> dom rc \<and> v \<in> reachable_set_l rc l \<and> (v1, v2) \<in> the (rc v) \<Longrightarrow>
            v1 \<in> reachable_set_l rc l)"
       and p3: "v \<in> dom rc \<and> v \<in> reachable_set_l rc (a # l) \<and> (v1, v2) \<in> the (rc v)"
    show "v1 \<in> reachable_set_l rc (a # l)"
    proof (cases "v1 \<in> reachable_set_l rc [a]")
      case True
      from this reachable_set_l.simps 
          reachable_set_def[of rc "fst a"] reachable_set_def[of rc "snd a"]
      have "v1 \<in> reachable_set rc (fst a) \<or> v1 \<in> reachable_set rc (snd a)"
        by (metis (mono_tags, lifting) UnE prod.exhaust_sel sup_bot_right)
      from this reachable_set_l.simps 
      show ?thesis 
        by (metis True UnI1 Un_empty_right surjective_pairing)
    next
      case False
      have "reachable_set_l rc [] = {}" by fastforce
      from this False p3 reachable_set_l.simps(2)[of rc "fst a" "snd a" l]
           reachable_set_l.simps(2)[of rc "fst a" "snd a" "[]"]
      have "v1 \<in> reachable_set_l rc l"
        by (metis UnE UnI2 Un_commute p2 prod.collapse reachable_set_closure)
      then show ?thesis 
        by (metis Un_iff list.discI list_tail_coinc reachable_set_l.elims)
    qed qed
    from p1 have "v2 \<in> reachable_set_l rc l"
    apply (induction l)
    apply fastforce
  proof- 
    fix a l
    assume p2: "(v \<in> dom rc \<and> v \<in> reachable_set_l rc l \<and> (v1, v2) \<in> the (rc v) \<Longrightarrow>
            v2 \<in> reachable_set_l rc l)"
       and p3: "v \<in> dom rc \<and> v \<in> reachable_set_l rc (a # l) \<and> (v1, v2) \<in> the (rc v)"
    show "v2 \<in> reachable_set_l rc (a # l)"
    proof (cases "v2 \<in> reachable_set_l rc [a]")
      case True
      from this reachable_set_l.simps 
          reachable_set_def[of rc "fst a"] reachable_set_def[of rc "snd a"]
      have "v2 \<in> reachable_set rc (fst a) \<or> v2 \<in> reachable_set rc (snd a)"
        by (metis (mono_tags, lifting) UnE prod.exhaust_sel sup_bot_right)
      from this reachable_set_l.simps 
      show ?thesis 
        by (metis True UnI1 Un_empty_right surjective_pairing)
    next
      case False
      have "reachable_set_l rc [] = {}" by fastforce
      from this False p3 reachable_set_l.simps(2)[of rc "fst a" "snd a" l]
           reachable_set_l.simps(2)[of rc "fst a" "snd a" "[]"]
      have "v2 \<in> reachable_set_l rc l"
        by (metis UnE UnI2 Un_commute p2 prod.collapse reachable_set_closure)
      then show ?thesis 
        by (metis Un_iff list.discI list_tail_coinc reachable_set_l.elims)
    qed qed
    from this
    show "v1 \<in> reachable_set_l rc l \<and> v2 \<in> reachable_set_l rc l"
      using \<open>v1 \<in> reachable_set_l rc l\<close> by blast
  qed



lemma distjoint_subtree_reachable:
   "uniq_indegree rc \<Longrightarrow> 
    (\<forall> x v v' l. v \<noteq> v' \<and> {v,v'} \<subseteq> child_set rc x 
     \<and> x \<in> \<Union> (set l) \<and> acyclic rc l \<longrightarrow> 
     (reachable_set rc v) \<inter> (reachable_set rc v') = {})"
  apply (rule_tac allI)+
proof 
  fix x v v' l
  assume p1: "uniq_indegree rc"
     and p2: "v \<noteq> v' \<and> {v, v'} \<subseteq> child_set rc x \<and>
       x \<in> \<Union> (set l) \<and> Forward_Analysis.acyclic rc l"
  from this
  show "reachable_set rc v \<inter> reachable_set rc v' = {}"
  apply (induction l)
  unfolding reachable_set_def 
  apply simp
proof -
  fix a l
  assume pp1: "(uniq_indegree rc \<Longrightarrow>
            v \<noteq> v' \<and>
            {v, v'} \<subseteq> child_set rc x \<and>
            x \<in> \<Union> (set l) \<and> Forward_Analysis.acyclic rc l \<Longrightarrow>
            {v'. \<exists>l. reachable rc (v # l) \<and> last (v # l) = v'} \<inter>
            {v'a. \<exists>l. reachable rc (v' # l) \<and> last (v' # l) = v'a} = {})" and
         pp2: "uniq_indegree rc" and
         pp3: " v \<noteq> v' \<and>
           {v, v'} \<subseteq> child_set rc x \<and>
           x \<in> \<Union> (set (a # l)) \<and>
           Forward_Analysis.acyclic rc (a # l)"
    
  show "{v'. \<exists>l. reachable rc (v # l) \<and> last (v # l) = v'} \<inter>
        {v'a. \<exists>l. reachable rc (v' # l) \<and> last (v' # l) = v'a} = {}"
  proof (rule ccontr)
    assume pp4: "{v'. \<exists>l. reachable rc (v # l) \<and> last (v # l) = v'} \<inter>
    {v'a. \<exists>l. reachable rc (v' # l) \<and> last (v' # l) = v'a} \<noteq>
    {}" 
    from this obtain l1 l2 vi where
     l1l2vi: "reachable rc (v # l1) \<and> last (v # l1) = vi \<and>
      reachable rc (v' # l2) \<and> last (v' # l2) = vi"
      by blast
    thm l1l2[of "v # l1" "v' # l2"]

   have not2: "\<not> (\<exists>l. v' # l2 = l @ v # l1)"
    proof 
      assume pl1: "(\<exists>l. v' # l2 = l @ v # l1)"
      from this obtain l2' where
       l1'_def: "v' # l2 = l2' @ (v # l1)" by auto
      from this pp3 l1l2vi have l1_nempty: "l2' \<noteq> []"
        by (metis append.left_neutral list_tail_coinc)
      from this obtain le where lelastl1': "le = last l2'"
        by auto
      from this obtain l1f where "l2' = l1f @ [le]" 
        by (metis append_butlast_last_id l1_nempty)
      from this have ct1: "v' # l2 = l1f @ [le] @ (v # l1)"
        by (simp add: l1'_def)
      from this reachable_div
      have reachable_rc_le_v': "reachable rc (le # v # l1)"
        by (metis append_eq_Cons_conv l1l2vi)
      show "False"
      proof (cases "le \<noteq> x")
        case True note lenx = this
        from reachable_rc_le_v' reachable.simps
        have reachable_le_v': "reachable rc [le, v]"
          by fastforce
        from this reachable.simps
        have ce1: "\<exists> v1 v2. (v1,v2) \<in> the (rc le) \<and> (v = v1 \<or> v = v2)"
          by fastforce
        from ce1 reachable_le_v' obtain v1 v2 where
        ce1': "le \<in> dom rc \<and> (v1,v2) \<in> the (rc le) \<and> (v = v1 \<or> v = v2)" by auto
        from pp3 have ce2: "\<exists> v1 v2. (v1,v2) \<in> the (rc x) \<and> (v = v1 \<or> v= v2)"
          unfolding child_set_def
          by blast
        from ce2 pp1 obtain v1' v2' where 
        ce2': "x \<in> dom rc \<and> (v1',v2') \<in> the (rc x) \<and> (v = v1' \<or> v= v2')"
          by (metis (no_types, lifting) child_set_def insert_subset mem_Collect_eq p2)
        from p1 have p1_aux: "\<And> v v' v1 v2 v3 v4.
       v \<in> dom rc \<and>
       v' \<in> dom rc \<and>
       v \<noteq> v' \<and>
       (v1, v2) \<in> the (rc v) \<and>
       (v3, v4) \<in> the (rc v') \<longrightarrow> (v1 \<noteq> v2 \<and> v3 \<noteq> v4 \<and> {v1, v2} \<inter> {v3, v4} = {})"
      unfolding uniq_indegree_def
      by blast
    from ce2' ce1' p1_aux[of x le v1' v2' v1 v2] lenx  
    show ?thesis
      by fastforce
      next
        case False
        note le_eq_x = this
        from ct1 pp3 l1'_def l1l2vi reachable_div
        have "reachable rc l2'"
          by metis
        from pp3 have "\<exists> v1 v2. (v1,v2) \<in> the (rc x) \<and> (v' = v1 \<or> v' = v2)" 
          unfolding child_set_def 
          by blast

        from  this l1l2vi reachable.simps
        have "reachable rc (x # v' # l2)"
          using le_eq_x reachable_rc_le_v' by auto

        from l1'_def
        have "x # v' # l2 = x # l2' @ (v # l1)"
          by auto
        from this reachable_div
        have "reachable rc (x # l2')"
          by (metis Cons_eq_appendI \<open>reachable rc (x # v' # l2)\<close>)
        
       from this lelastl1' nocycle[of x "a # l" rc] pp3
       show ?thesis 
         by (metis \<open>l2' = l1f @ [le]\<close> le_eq_x)
      qed qed

    have not1: "\<not> (\<exists>l. v # l1 = l @ v' # l2)"
    proof 
      assume pl1: "\<exists>l. v # l1 = l @ v' # l2"
      from this obtain l1' where
       l1'_def: "v # l1 = l1' @ (v' # l2)" by auto
      from this pp3 l1l2vi have l1_nempty: "l1' \<noteq> []"
        by (metis append.left_neutral list_tail_coinc)
      from this obtain le where lelastl1': "le = last l1'"
        by auto
      from this obtain l1f where "l1' = l1f @ [le]" 
        by (metis append_butlast_last_id l1_nempty)
      from this have ct1: "v # l1 = l1f @ [le] @ (v' # l2)"
        by (simp add: l1'_def)
      from this reachable_div
      have reachable_rc_le_v': "reachable rc (le # v' # l2)"
        by (metis append_eq_Cons_conv l1l2vi)
      show "False"
      proof (cases "le \<noteq> x")
        case True note lenx = this
        from reachable_rc_le_v' reachable.simps
        have reachable_le_v': "reachable rc [le, v']"
          by fastforce
        from this reachable.simps
        have ce1: "\<exists> v1 v2. (v1,v2) \<in> the (rc le) \<and> (v' = v1 \<or> v' = v2)"
          by fastforce
        from ce1 reachable_le_v' obtain v1 v2 where
        ce1': "le \<in> dom rc \<and> (v1,v2) \<in> the (rc le) \<and> (v' = v1 \<or> v' = v2)" by auto
        from pp3 have ce2: "\<exists> v1 v2. (v1,v2) \<in> the (rc x) \<and> (v' = v1 \<or> v'= v2)"
          unfolding child_set_def
          by blast
        from ce2 pp1 obtain v1' v2' where 
        ce2': "x \<in> dom rc \<and> (v1',v2') \<in> the (rc x) \<and> (v' = v1' \<or> v'= v2')"
          by (metis (no_types, lifting) child_set_def insert_subset mem_Collect_eq p2)
        from p1 have p1_aux: "\<And> v v' v1 v2 v3 v4.
       v \<in> dom rc \<and>
       v' \<in> dom rc \<and>
       v \<noteq> v' \<and>
       (v1, v2) \<in> the (rc v) \<and>
       (v3, v4) \<in> the (rc v') \<longrightarrow> (v1 \<noteq> v2 \<and> v3 \<noteq> v4 \<and> {v1, v2} \<inter> {v3, v4} = {})"
      unfolding uniq_indegree_def
      by blast
    from ce2' ce1' p1_aux[of x le v1' v2' v1 v2] lenx  
    show ?thesis
      by fastforce
      next
        case False
        note le_eq_x = this
        from ct1 pp3 l1'_def l1l2vi reachable_div
        have "reachable rc l1'"
          by metis
        from pp3 have "\<exists> v1 v2. (v1,v2) \<in> the (rc x) \<and> (v = v1 \<or> v = v2)" 
          unfolding child_set_def 
          by blast

        from  this l1l2vi reachable.simps
        have "reachable rc (x # v # l1)"
          using le_eq_x reachable_rc_le_v' by auto

        from l1'_def
        have "x # v # l1 = x # l1' @ (v' # l2)"
          by auto
        from this reachable_div
        have "reachable rc (x # l1')"
          by (metis Cons_eq_appendI \<open>reachable rc (x # v # l1)\<close>)
        
       from this lelastl1' nocycle[of x "a # l" rc] pp3
       show ?thesis 
         by (metis \<open>l1' = l1f @ [le]\<close> le_eq_x)
      qed qed 

      from pp3
      have not3: "v # l1 \<noteq> v' # l2"
        by blast

from not1 not2 not3 l1l2[of "v # l1" "v' # l2"]
  have "(\<exists>l l1' l2'.
        v # l1 = l1' @ l \<and>
        v' # l2 = l2' @ l \<and> l1' \<noteq> [] \<and> l2' \<noteq> [] \<and> last l1' \<noteq> last l2')"
    by blast
  from this obtain l l1' l2'
    where pivot: "v # l1 = l1' @ l \<and>
        v' # l2 = l2' @ l \<and> l1' \<noteq> [] \<and> l2' \<noteq> [] \<and> last l1' \<noteq> last l2'"
    by auto
  from this have "l \<noteq> []"
    using l1l2vi by auto
  from this obtain fa l' where
   "l = fa # l'" 
    using neq_NilE by blast
  from pivot obtain ll1' ll2' where
   ll12: "last l1' = ll1' \<and> last l2' = ll2' \<and> ll1'\<noteq> ll2'"
    by auto
  from pivot this obtain l1'' l2''
    where "l1' = l1'' @ [ll1'] \<and> l2' = l2'' @ [ll2']"
    by (metis append_butlast_last_id)
  from this have cd1: "v # l1 = l1'' @ [ll1'] @ (fa # l')"
    by (simp add: \<open>l = fa # l'\<close> pivot)

  from this have cd2: "v' # l2 = l2'' @ [ll2'] @ (fa # l')"
    by (simp add: \<open>l = fa # l'\<close> \<open>l1' = l1'' @ [ll1'] \<and> l2' = l2'' @ [ll2']\<close> pivot)

  from cd1 reachable_div[of "v # l1" l1'' "[ll1'] @ fa # l'" rc]
  have "reachable rc (ll1' # fa # l')"
    using append_Cons l1l2vi by auto
  from this reachable.simps
  have suc1: "reachable rc [ll1', fa]" 
    by simp

  from cd2 reachable_div[of "v' # l2" l2'' "[ll2'] @ fa # l'" rc]
  have "reachable rc (ll2' # fa # l')"
    using append_Cons l1l2vi by auto
  from this reachable.simps
  have  suc2: "reachable rc [ll2', fa]" 
    by simp

  from suc1 reachable.simps(3)
  have "\<exists> v1 v2. (v1,v2) \<in> the (rc ll1') \<and> (fa = v1 \<or> fa = v2)"
    by simp
  from this suc1 obtain n1 n2 where
  fn1: "ll1' \<in> dom rc \<and> (n1,n2) \<in> the (rc ll1') \<and> (fa = n1 \<or> fa = n2)"
    by fastforce

  from suc2 reachable.simps(3)
  have "\<exists> v1 v2. (v1,v2) \<in> the (rc ll2') \<and> (fa = v1 \<or> fa = v2)"
    by simp

  from this suc2 obtain n1' n2' where
  fn2: "ll2' \<in> dom rc \<and> (n1',n2') \<in> the (rc ll2') \<and> (fa = n1' \<or> fa = n2')"
    by fastforce

  from ll12
  have fn3: "ll1'\<noteq> ll2'" by auto
  
 from p1 have p1_aux: "\<And> v v' v1 v2 v3 v4.
       v \<in> dom rc \<and>
       v' \<in> dom rc \<and>
       v \<noteq> v' \<and>
       (v1, v2) \<in> the (rc v) \<and>
       (v3, v4) \<in> the (rc v') \<longrightarrow> (v1 \<noteq> v2 \<and> v3 \<noteq> v4 \<and> {v1, v2} \<inter> {v3, v4} = {})"
      unfolding uniq_indegree_def
      by blast

    from fn1 fn2 fn3 p1_aux[of ll1' ll2' n1 n2 n1' n2']
    show False
      by fastforce
  qed qed qed
 

lemma reachable_set_l_correct: 
   "v \<in> dom rc \<and> set l =  the (rc v) \<longrightarrow> reachable_set rc v 
     = {v} \<union> (reachable_set_l rc l)"
proof 
  assume p1: "v \<in> dom rc \<and> set l = the (rc v)"
  from this 
  show "reachable_set rc v = {v} \<union> reachable_set_l rc l"
  proof -
  have "\<And> l. reachable rc (v # l) \<longrightarrow> 
          l = [] \<or> ( v \<in> dom rc \<and> 
          (\<exists> l' v1 v2. (v1, v2) \<in> (the (rc v)) \<and> l = v1 # l'\<or> l = v2 # l'))"
    by (meson neq_NilE p1)
  from this show "reachable_set rc v = {v} \<union> reachable_set_l rc l"
    apply (simp add: set_eq_iff)
    apply (rule allI)
  proof 
    {
      fix x
      assume p11: "\<And>l. reachable rc (v # l) \<longrightarrow>
              l = [] \<or>
              v \<in> dom rc \<and>
              (\<exists>l' v1 v2. (v1, v2) \<in> the (rc v) \<and> l = v1 # l' \<or> l = v2 # l')" and
             p2: "x = v \<or> x \<in> reachable_set_l rc l"
      have "x = v \<longrightarrow> x \<in> reachable_set rc v"
        unfolding reachable_set_def
        by fastforce
      have "x \<in> reachable_set_l rc l \<longrightarrow> x \<in> reachable_set rc v"
      proof
        assume pp1: "x \<in> reachable_set_l rc l"
        from pp1
        have "\<exists> v1 v2. (v1,v2) \<in> set l \<and> 
                (x \<in> reachable_set rc v1 \<or> x \<in> reachable_set rc v2)"
          apply (induction l)
          apply simp
          by fastforce

        from this obtain v1 v2 where
          t1: "(v1, v2) \<in> set l \<and> (x \<in> reachable_set rc v1 \<or> x \<in> reachable_set rc v2)"
          by auto

        from this have tt1: "x \<in> reachable_set rc v1 \<longrightarrow>
          (\<exists> l. ((reachable rc (v1 # l) \<and> last (v1 # l) = x)))
         "
          unfolding reachable_set_def
          by blast

        from this have tt2: "x \<in> reachable_set rc v2 \<longrightarrow>
          (\<exists> l. ((reachable rc (v2 # l) \<and> last (v2 # l) = x)))
         "
          unfolding reachable_set_def
          by blast
        from t1 p1 tt1 tt2
        have "(v1,v2) \<in> the (rc v)"
          by simp
        from this tt1
        have suc2: "x \<in> reachable_set rc v1 \<longrightarrow> 
              (\<exists> l. reachable rc (v # l) \<and> last (v # l) = x)"
          apply (rule_tac impI)
        proof - 
          assume pc1: " x \<in> reachable_set rc v1"
          from this tt1 have "(\<exists>l. reachable rc (v1 # l) \<and> last (v1 # l) = x)"
            by simp
          from this obtain lx1 where
           "reachable rc (v1 # lx1) \<and> last (v1 # lx1) = x" by auto
          from this have "reachable rc (v # (v1 # lx1)) \<and> last (v # v1 # lx1) = x"
            using \<open>(v1, v2) \<in> the (rc v)\<close> p1 by auto
          from this show "\<exists>l. reachable rc (v # l) \<and> last (v # l) = x"
            by blast
        qed

        have suc1: "x \<in> reachable_set rc v2 \<longrightarrow> 
              (\<exists> l. reachable rc (v # l) \<and> last (v # l) = x)"
          apply (rule_tac impI)
        proof - 
          assume pc1: " x \<in> reachable_set rc v2"
          from this tt2 have "(\<exists>l. reachable rc (v2 # l) \<and> last (v2 # l) = x)"
            by simp
          from this obtain lx2 where
           "reachable rc (v2 # lx2) \<and> last (v2 # lx2) = x" by auto
          from this have "reachable rc (v # (v2 # lx2)) \<and> last (v # v2 # lx2) = x"
            using \<open>(v1, v2) \<in> the (rc v)\<close> p1 by auto
          from this show "\<exists>l. reachable rc (v # l) \<and> last (v # l) = x"
            by blast
        qed

        from suc1 suc2 show 
         "x \<in> reachable_set_l rc l \<Longrightarrow> x \<in> reachable_set rc v"
          unfolding reachable_set_def
          using suc1 suc2 t1 by blast
      qed
       from this show "x \<in> reachable_set rc v" 
         unfolding reachable_set_def
         using p2 reachable_set_def by auto
     }
     {
       fix x
       assume pp1: "\<And>l. reachable rc (v # l) \<longrightarrow>
              l = [] \<or>
              v \<in> dom rc \<and>
              (\<exists>l' v1 v2. (v1, v2) \<in> the (rc v) \<and> l = v1 # l' \<or> l = v2 # l')" and
              pp2: "x \<in> reachable_set rc v"
       from this have "\<exists> l. reachable rc (v#l) \<and> (last (v#l) = x)"
         unfolding reachable_set_def
         by blast
       from this obtain l1 where
        re1: "reachable rc (v#l1) \<and> (last (v#l1) = x)"
         by auto
       from this have "l1 = [] \<longrightarrow> x = v" 
         by auto

       from re1
       have "l1 \<noteq> [] \<longrightarrow> (\<exists> v1 v2 l'. 
            (v1,v2) \<in> the (rc v) \<and> ((l1 = v1 # l') \<or> (l1 = v2 # l')))"
         apply (induction l1)
          apply simp
         by auto
         

       from this obtain v1 v2 l' where
       aa: "l1 \<noteq> [] \<longrightarrow> (v1,v2) \<in> the (rc v) \<and> ((l1 = v1 # l') \<or> (l1 = v2 # l'))"
         by auto

       from this have aa1: "l1 \<noteq> [] \<longrightarrow> (v1,v2) \<in> set l"
         by (simp add: p1)

       from aa have "l1 \<noteq> [] \<longrightarrow> (reachable rc (v1#l') \<and> (last (v1#l') = x)) \<or>   
                                    (reachable rc (v2#l') \<and> (last (v2#l') = x))"
         using re1 by auto
       from this p1 aa1
       have "l1 \<noteq> [] \<longrightarrow> x \<in> reachable_set rc v1 \<or> x \<in> reachable_set rc v2"
         unfolding reachable_set_def
         by blast
       from this aa1 have "l1 \<noteq> [] \<longrightarrow> x \<in> reachable_set_l rc l"
         apply (rule_tac impI)
       proof -
         assume pz1: "l1 \<noteq> [] \<longrightarrow> x \<in> reachable_set rc v1 \<or> x \<in> reachable_set rc v2"
         and pz2: "l1 \<noteq> [] \<longrightarrow> (v1, v2) \<in> set l" and
         pz3 : "l1 \<noteq> []"
         from pz1 pz3 have po1: "x \<in> reachable_set rc v1 \<or> x \<in> reachable_set rc v2"
           by simp
         from pz2 pz3 have po2: "(v1, v2) \<in> set l"
           by simp
         from po1 po2 show "x \<in> reachable_set_l rc l"
           apply (induction l)
           apply simp
           by auto
       qed
       show "x = v \<or> x \<in> reachable_set_l rc l"
         using \<open>l1 = [] \<longrightarrow> x = v\<close> \<open>l1 \<noteq> [] \<longrightarrow> x \<in> reachable_set_l rc l\<close> by blast
     }qed qed qed
    
 
lemma reachable_set_single: "v \<notin> dom rc \<Longrightarrow>reachable_set rc v = {v}"
  unfolding reachable_set_def
proof 
  show "v \<notin> dom rc \<Longrightarrow> {v} \<subseteq> {v'. \<exists>l. reachable rc (v # l) \<and> last (v # l) = v'}"
    by auto
  show "v \<notin> dom rc \<Longrightarrow> {v'. \<exists>l. reachable rc (v # l) \<and> last (v # l) = v'} \<subseteq> {v}"
  proof 
    fix x
    assume p1: "v \<notin> dom rc"
       and p2: "x \<in> {v'. \<exists>l. reachable rc (v # l) \<and> last (v # l) = v'}"
    from p2 obtain l where 
     c1: "reachable rc (v # l) \<and> last (v # l) = x"
      by fastforce
    from this
    show "x \<in> {v}"
    proof (cases "l = []")
      case True
      from this c1 show ?thesis apply fastforce done
    next
      case False
      from this obtain a l' where c2: "l = a # l'"
        using neq_NilE by blast
      from c1 c2 reachable.simps(3)[of rc v a l']
      have "v \<in> dom rc \<and> (\<exists>q1 q2. (q1, q2) \<in> the (rc v) \<and> a \<in> {q1, q2})"
        apply fastforce done
      from this p1 have False by auto
      then show ?thesis by auto
    qed
  qed qed

lemma reachable_sub:
  assumes acyc_uniq: "Forward_Analysis.acyclic rc (a # l) \<and> uniq_indegree rc" and
          v_notin_a: "v \<notin> a" and
             v_in_S: "v \<in> \<Union> (set (a # l))" and
          finite_rc: "\<forall> v \<in> \<Union> (set (a # l)). v \<in> dom rc \<longrightarrow> finite (the (rc v))"
        shows "reachable_set rc v = reachable_set (rc |` \<Union> (set l)) v"
    apply (insert acyc_uniq v_notin_a v_in_S finite_rc) 
    apply (induction l arbitrary: a rc v)
    apply simp 
    proof - {
        fix a l aa rc v
        assume li1: "(\<And>a rc v.
           Forward_Analysis.acyclic rc (a # l) \<and> uniq_indegree rc \<Longrightarrow>
           v \<notin> a \<Longrightarrow>
           v \<in> \<Union> (set (a # l)) \<Longrightarrow>
           \<forall>v\<in>\<Union> (set (a # l)). v \<in> dom rc \<longrightarrow> finite (the (rc v)) \<Longrightarrow>
           reachable_set rc v = reachable_set (rc |` \<Union> (set l)) v)"
        and li2: "Forward_Analysis.acyclic rc (aa # a # l) \<and> uniq_indegree rc" and
            li3: "v \<in> \<Union> (set (aa # a # l))" and
            li4: "v \<notin> aa" and
           li5: "\<forall>v\<in>\<Union> (set (aa # a # l)). v \<in> dom rc \<longrightarrow> finite (the (rc v))"
        from li2 li4 
        have "v \<in> \<Union> (set (a # l))"
          by (metis Union_iff li3 set_ConsD)
        from li2 have acyclic_rc_al: "acyclic rc (a # l)"
          using acyclic_tail by blast
        let ?S = "\<Union> (set (a # l))"
        have reachable_v: "\<And> v. v \<in> \<Union> (set l) \<Longrightarrow> 
                reachable_set rc v = reachable_set (rc |` \<Union> (set l)) v"
        proof -
          fix v
          assume p1: "v \<in> \<Union> (set l)"
          have tmp1: "?S = \<Union> (set (a # l))" by auto
          from p1
          have tmp2: "v \<in> \<Union> (set (a # l))" 
            by simp
          from acyclic_rc_al acyclic.simps
          have "a \<inter> \<Union> (set l) = {}"
            by metis
          from tmp2 this p1
          have tmp3: "v \<notin> a" 
            by blast
          from li1[of rc a v] tmp1 acyclic_rc_al tmp2 tmp3 li2 
          show "reachable_set rc v = reachable_set (rc |` \<Union> (set l)) v"
            by (metis Set.set_insert Union_mono insert_subset li1 li5 set_subset_Cons)
        qed

        from li2 acyclic_correct
        have acyclic_rc_al': "acyclic (rc |` \<Union> (set (a # l))) (a # l)"
          using acyclic_tail by blast

        have reachable_v': "\<And> v. v \<in> \<Union> (set l) \<Longrightarrow> 
                reachable_set (rc |` \<Union> (set (a # l))) v = 
                reachable_set (rc |` \<Union> (set l)) v"
        proof -
          fix v
          assume p1: "v \<in> \<Union> (set l)"
          have tmp1: "?S = \<Union> (set (a # l))" by auto
          from p1
          have tmp2: "v \<in> \<Union> (set (a # l))" 
            by simp
          from acyclic_rc_al acyclic.simps
          have "a \<inter> \<Union> (set l) = {}"
            by metis
          from tmp2 this p1
          have tmp3: "v \<notin> a" 
            by blast
          from li2
          have tmp4: "uniq_indegree (rc |` \<Union> (set (a # l)))"
            unfolding uniq_indegree_def     
            apply (rule_tac conjI)
            apply (metis Int_iff dom_restrict restrict_in)
            apply (rule_tac conjI)
            defer
            apply (metis Int_iff dom_restrict restrict_in)
            by (metis Int_iff dom_restrict restrict_in)


          from li1[of   "(rc |` \<Union> (set (a # l)))" a v] 
                tmp1 acyclic_rc_al' tmp2 tmp3 tmp4
          show "reachable_set (rc |` \<Union> (set (a # l))) v = 
                reachable_set (rc |` \<Union> (set l)) v"
            by (metis (no_types, lifting) IntD1 Union_mono dom_restrict li1 li2 li5 restrict_in restrict_map_subset_eq set_subset_Cons subset_eq)
        qed

        from reachable_v reachable_v'
        have reachable_vv': "\<And> v. v \<in> \<Union> (set l) \<Longrightarrow> 
          reachable_set rc v = reachable_set (rc |` \<Union> (set (a # l))) v"
          by auto
        from this
        show "reachable_set rc v = 
              reachable_set (rc |` \<Union> (set (a # l))) v"
        proof (cases "v \<notin> a")
case True
  from this reachable_vv'[of v]
  show ?thesis 
    using \<open>v \<in> \<Union> (set (a # l))\<close> by auto
next
  case False
  note v_eq_a = this
  thm reachable_set_l_correct[of v rc ]
  have "v \<in> reachable_set (rc |` \<Union> (set (a # l))) v"
    unfolding reachable_set_def
    by auto
  then show ?thesis 
  proof (cases "v \<notin> dom rc")
    case True
    from this reachable_set_single [of v rc]
    have "reachable_set rc v = {v}" 
      by auto
    from reachable_set_single
    have "reachable_set (rc |` \<Union> (set (a # l))) v = {v}"
      by (simp add: reachable_set_single True)
    then show ?thesis 
      by (simp add: \<open>reachable_set rc v = {v}\<close>)
  next
    case False
    from this obtain ll where ll_def: "the (rc v) = ll"
      by fastforce
    from this li5
    obtain sll where
    sll_def: "distinct sll \<and> set sll = ll" 
      by (meson False finite_distinct_list li3)

    from v_eq_a acyclic_rc_al ll_def acyclic.simps
    have ll_l: "\<And> v1 v2. (v1,v2) \<in> ll \<longrightarrow> v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l)"
      by (metis False)

    from reachable_set_l_correct[of v rc sll]
    have "reachable_set rc v = {v} \<union> reachable_set_l rc sll"
      using False \<open>the (rc v) = ll\<close> sll_def by blast

    from False v_eq_a 
    have "the ((rc |` \<Union> (set (a # l))) v) = ll"
      using \<open>the (rc v) = ll\<close> by auto

    from this reachable_set_l_correct[of v "(rc |` \<Union> (set (a # l)))" sll]
    have "reachable_set (rc |` \<Union> (set (a # l))) v = 
          {v} \<union> reachable_set_l (rc |` \<Union> (set (a # l))) sll"
      using False \<open>v \<in> \<Union> (set (a # l))\<close> sll_def by auto

    from ll_l sll_def reachable_vv'
    have "reachable_set_l rc sll = reachable_set_l (rc |` \<Union> (set (a # l))) sll"
      apply (induction sll arbitrary: ll)
      apply simp
      apply (rename_tac b sll ll)
    proof -
      fix b sll ll
      assume pr1: "(\<And>ll. (\<And>v1 v2. (v1, v2) \<in> ll \<longrightarrow> v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l)) \<Longrightarrow>
              distinct sll \<and> set sll = ll \<Longrightarrow>
              (\<And>v. v \<in> \<Union> (set l) \<Longrightarrow>
                    reachable_set rc v = reachable_set (rc |` \<Union> (set (a # l))) v) \<Longrightarrow>
              reachable_set_l rc sll = reachable_set_l (rc |` \<Union> (set (a # l))) sll)" and
      pr2: "(\<And>v1 v2. (v1, v2) \<in> ll \<longrightarrow> v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))" and
      pr3: "distinct (b # sll) \<and> set (b # sll) = ll" and
      pr4: "(\<And>v. v \<in> \<Union> (set l) \<Longrightarrow>
             reachable_set rc v = reachable_set (rc |` \<Union> (set (a # l))) v)"

      let ?ll = "ll - {b}"
      from pr3 have pr3': "distinct sll \<and> set sll = ?ll"
        by auto
      from this pr2 
      have pr2': "(\<And>v1 v2. (v1, v2) \<in> ?ll \<longrightarrow> v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))"
        by auto

      from  pr1[OF pr2' pr3' pr4]
      have cy3: "reachable_set_l rc sll = reachable_set_l (rc |` \<Union> (set (a # l))) sll"
        by fastforce

      from pr2 pr3 reachable_vv'
      have cy1: "reachable_set rc (fst b) = 
            reachable_set (rc |` \<Union> (set (a # l))) (fst b)"
        by (metis fst_conv list.set_intros(1) old.prod.exhaust)

      from pr2 pr3 reachable_vv'
      have cy2: "reachable_set rc (snd b) = 
            reachable_set (rc |` \<Union> (set (a # l))) (snd b)"
        by (metis snd_conv list.set_intros(1) old.prod.exhaust)
      from cy1 cy2 cy3 reachable_set_l.simps
      show "reachable_set_l rc (b # sll) = 
            reachable_set_l (rc |` \<Union> (set (a # l))) (b # sll)"
        by (metis prod.collapse)
    qed
    then show ?thesis 
      using \<open>reachable_set (rc |` \<Union> (set (a # l))) 
            v = {v} \<union> reachable_set_l (rc |` \<Union> (set (a # l))) sll\<close> 
            \<open>reachable_set rc v = {v} \<union> reachable_set_l rc sll\<close> by blast
  qed
qed}qed



lemma reachable_subl:
  assumes p1: "v \<in> \<Union> (set l) \<and> 
               Forward_Analysis.acyclic (rc |` \<Union> (set l)) l \<and> uniq_indegree rc"
      and p2: "\<forall> v \<in> \<Union> (set l). v \<in> dom rc \<longrightarrow> finite (the (rc v))"
  shows "reachable_set (rc |` \<Union> (set l)) v \<subseteq> (\<Union> (set l))"
    apply (insert p1 p2)    
    apply (induction l arbitrary: v)
   apply simp
  apply (rename_tac aa l v)
  proof -
    fix aa l v
    assume po1: "\<And>v. v \<in> \<Union> (set l) \<and>
             Forward_Analysis.acyclic (rc |` \<Union> (set l)) l \<and> uniq_indegree rc \<Longrightarrow>
             \<forall>v\<in>\<Union> (set l). v \<in> dom rc \<longrightarrow> finite (the (rc v)) \<Longrightarrow>
             reachable_set (rc |` \<Union> (set l)) v \<subseteq> \<Union> (set l)"
       and po2: "v \<in> \<Union> (set (aa # l)) \<and>
       Forward_Analysis.acyclic (rc |` \<Union> (set (aa # l))) (aa # l) \<and>
       uniq_indegree rc"
       and po3: "\<forall>v\<in>\<Union> (set (aa # l)). v \<in> dom rc \<longrightarrow> finite (the (rc v))"

    show "reachable_set (rc |` \<Union> (set (aa # l))) v \<subseteq> \<Union> (set (aa # l))"
    proof (cases "v \<notin> dom rc")
case True
  from this
  have "v \<notin> dom (rc |` \<Union> (set (aa # l)))"
    by auto
 from this reachable_set_single[of v "rc |` \<Union> (set (aa # l))"] po2
  show ?thesis 
    by (metis empty_subsetI insert_subset)
next
  case False
  note v_in_rc = this
  then show ?thesis 
  proof (cases "v \<notin> aa")
    case True    

    from po2 acyclic_correct
    have tmp1: "v \<in> \<Union> (set l) \<and> Forward_Analysis.acyclic (rc |` \<Union> (set l)) l \<and> uniq_indegree rc"
      by (metis True Union_iff Union_mono restrict_map_subset_eq set_ConsD set_subset_Cons)

    from po3 have tmp2: "\<forall>v\<in>\<Union> (set l). v \<in> dom rc \<longrightarrow> finite (the (rc v)) "
      by fastforce
    
    from po2 have po2': "uniq_indegree (rc |` \<Union> (set (aa # l)))"
      unfolding uniq_indegree_def
      apply (rule_tac conjI)
      apply (metis Int_iff dom_restrict restrict_in)
      apply (rule_tac conjI)
      apply (metis Int_iff dom_restrict restrict_in)
      by (metis Int_iff dom_restrict restrict_in)

    from reachable_sub[of "(rc |` \<Union> (set (aa # l)))" aa l v] po2' po2 po3 True
    have "reachable_set (rc |` \<Union> (set (aa # l))) v =
          reachable_set (rc |` \<Union> (set (aa # l)) |` \<Union> (set l)) v"
      by (metis IntE dom_restrict reachable_sub restrict_in subset_eq)
  
    from po1[OF tmp1 tmp2] this
    have "reachable_set (rc |` \<Union> (set (aa # l))) v \<subseteq> \<Union> (set l)"
      by (metis Union_mono restrict_map_subset_eq set_subset_Cons)
    from this
    show ?thesis by fastforce
  next
    case False
    from v_in_rc obtain ll where ll_def: "the (rc v) = ll"
      by fastforce
    from False this po3 obtain lla where lla_def: "distinct lla \<and> set lla = ll"
      by (meson finite_distinct_list po2 v_in_rc)

    from False ll_def 
    have v_in_aal: "v \<in> dom (rc |` \<Union> (set (aa # l)))"
      by (metis Int_iff dom_restrict po2 v_in_rc)

    from lla_def ll_def 
    have "set lla = the ((rc |` \<Union> (set (aa # l))) v)"
      by (metis po2 restrict_in)

    from v_in_aal reachable_set_l_correct[of v "rc |` \<Union> (set (aa # l))" lla] this
    have "reachable_set (rc |` \<Union> (set (aa # l))) v  = 
          {v} \<union> reachable_set_l (rc |` \<Union> (set (aa # l))) lla"
      by auto
    from po2 False lla_def ll_def
    have fstsnd: "\<And> a. a \<in> set lla \<longrightarrow> fst a \<in> \<Union> (set l) \<and> snd a \<in> \<Union> (set l)"
      by (metis \<open>set lla = the ((rc |` \<Union> (set (aa # l))) v)\<close> acyclic_dep2 prod.collapse v_in_aal)

    thm reachable_sub[of "(rc |` \<Union> (set (aa # l)))" aa l v]

    from po2 acyclic.simps 
    have aa_l_empty: "aa \<inter> \<Union> (set l) = {}"
      by metis
   
    from fstsnd
    have reachable_lla: "reachable_set_l (rc |` \<Union> (set (aa # l))) lla \<subseteq> \<Union> (set l)"
      apply (induction lla)
      apply simp
      apply (rename_tac b lla)
    proof -
      fix b lla
      assume pj1: "((\<And>a. a \<in> set lla \<longrightarrow> fst a \<in> \<Union> (set l) \<and> snd a \<in> \<Union> (set l)) 
          \<Longrightarrow>
        reachable_set_l (rc |` \<Union> (set (aa # l))) lla \<subseteq> \<Union> (set l))" and
             pj2: "(\<And>a. a \<in> set (b # lla) \<longrightarrow> fst a \<in> \<Union> (set l) \<and> snd a \<in> \<Union> (set l))"

      from pj2 have "(\<And>a. a \<in> set lla \<longrightarrow> fst a \<in> \<Union> (set l) \<and> snd a \<in> \<Union> (set l))"
        by fastforce
      from this pj1 have ci2: "reachable_set_l (rc |` \<Union> (set (aa # l))) lla \<subseteq> \<Union> (set l)"
        by auto

      from reachable_set_l.simps(2)[of "rc |` \<Union> (set (aa # l))" "fst b" "snd b" lla]
      have ci1: "reachable_set_l (rc |` \<Union> (set (aa # l))) (b # lla) = 
            reachable_set (rc |` \<Union> (set (aa # l))) (fst b) \<union>
            reachable_set (rc |` \<Union> (set (aa # l))) (snd b) \<union>
            reachable_set_l (rc |` \<Union> (set (aa # l))) lla"
        by auto
      from pj2
      have tmp1: "fst b \<in> \<Union> (set l)" by auto

      have tmp2: "Forward_Analysis.acyclic (rc |` \<Union> (set l)) l \<and> uniq_indegree rc"
        by (metis Union_mono acyclic_correct po2 restrict_map_subset_eq set_subset_Cons)

      have tmp3: "\<forall>v\<in>\<Union> (set l). v \<in> dom rc \<longrightarrow> finite (the (rc v))"
        by (simp add: po3)

      from po1[of "fst b"] tmp1 tmp2 tmp3
      have tu1: "reachable_set (rc |` \<Union> (set l)) (fst b) \<subseteq> \<Union> (set l)"
        by blast


    from pj2
      have tmp1: "snd b \<in> \<Union> (set l)" by auto

      have tmp2: "Forward_Analysis.acyclic (rc |` \<Union> (set l)) l \<and> uniq_indegree rc"
        by (metis Union_mono acyclic_correct po2 restrict_map_subset_eq set_subset_Cons)

      have tmp3: "\<forall>v\<in>\<Union> (set l). v \<in> dom rc \<longrightarrow> finite (the (rc v))"
        by (simp add: po3)

      from po1[of "snd b"] tmp1 tmp2 tmp3
      have tu2: "reachable_set (rc |` \<Union> (set l)) (snd b) \<subseteq> \<Union> (set l)"
        by blast

      from po2 have tmpp1: "Forward_Analysis.acyclic (rc |` \<Union> (set (aa # l))) (aa # l) \<and>
                    uniq_indegree (rc |` \<Union> (set (aa # l)))"
        apply (rule_tac conjI)
        apply blast
        unfolding uniq_indegree_def
        apply (rule_tac conjI)
        apply (metis Int_iff dom_restrict restrict_in)
        apply (rule_tac conjI)
        apply (metis Int_iff dom_restrict restrict_in)
        by (metis Int_iff dom_restrict restrict_in)

      from po3 have tmpp2: 
      "\<forall>v\<in>\<Union> (set (aa # l)).
               v \<in> dom (rc |` \<Union> (set (aa # l))) \<longrightarrow> 
                finite (the ((rc |` \<Union> (set (aa # l))) v))"
        by simp
      from tmp1 aa_l_empty
      have tmpp3: "fst b \<notin> aa \<and> fst b \<in> \<Union> (set (aa # l))"
        by (meson Union_iff disjoint_iff_not_equal list.set_intros(1) list.set_intros(2) pj2)
        

     from tmp1 aa_l_empty
      have tmpp4: "snd b \<notin> aa \<and> snd b \<in> \<Union> (set (aa # l))"
        by (meson Union_iff disjoint_iff_not_equal list.set_intros(1) list.set_intros(2) pj2)

     from tmpp1 tmpp2 tmpp3 reachable_sub[of "rc |` \<Union> (set (aa # l))" aa l "fst b"]
     have ci3: "reachable_set (rc |` \<Union> (set (aa # l))) (fst b) =
      reachable_set (rc |` \<Union> (set (aa # l)) |` \<Union> (set l)) (fst b)"
       by fastforce

    from tmpp1 tmpp2 tmpp4 reachable_sub[of "rc |` \<Union> (set (aa # l))" aa l "snd b"]
     have ci4: "reachable_set (rc |` \<Union> (set (aa # l))) (snd b) =
      reachable_set (rc |` \<Union> (set (aa # l)) |` \<Union> (set l)) (snd b)"
       by fastforce

     from ci3 ci4 tu1 tu2
     have tu1': "reachable_set (rc |` \<Union> (set (aa # l)) |` \<Union> (set l)) (fst b) \<subseteq> \<Union> (set l)"
       by (metis Sup_subset_mono restrict_map_subset_eq set_subset_Cons)
from ci3 ci4 tu1 tu2
     have tu2': "reachable_set (rc |` \<Union> (set (aa # l)) |` \<Union> (set l)) (snd b) \<subseteq> \<Union> (set l)"
       by (metis Sup_subset_mono restrict_map_subset_eq set_subset_Cons)

    from ci1 ci2 tu1' tu2'
    show "reachable_set_l (rc |` \<Union> (set (aa # l))) (b # lla) \<subseteq> \<Union> (set l)"
      using ci3 ci4 by blast
  qed
  from reachable_set_l_correct[of v "rc |` \<Union> (set (aa # l))" lla]
  have "reachable_set (rc |` \<Union> (set (aa # l))) v =
  {v} \<union> reachable_set_l (rc |` \<Union> (set (aa # l))) lla"
    using \<open>reachable_set (rc |` \<Union> (set (aa # l))) v = {v} \<union> reachable_set_l (rc |` \<Union> (set (aa # l))) lla\<close> by blast
  from this reachable_lla False
  show ?thesis 
    by auto
  qed
qed
qed

lemma sat_pred_ass_sub:
      "sat_pred_ass S (rc |` S') (rm |` S') ag \<Longrightarrow> S \<subseteq> S' \<Longrightarrow>
       (\<forall> v1 v2 v. v \<in> S' \<and> v \<in> dom rc \<and> (v1,v2) \<in> the (rc v) \<longrightarrow> v1 \<in> S' \<and> v2 \<in> S')
       \<Longrightarrow> 
       sat_pred_ass S rc rm ag"
  unfolding sat_pred_ass_def
proof -
  assume p1: "(\<forall>v\<in>S. \<exists>w. w = ag v) \<and>
    (\<forall>v w. v \<in> S \<and> w = ag v \<longrightarrow> w \<in> \<L> (the ((rm |` S') v))) \<and>
    (\<forall>v1 v2 v.
        v \<in> dom (rc |` S') \<and> v \<in> S \<and> (v1, v2) \<in> the ((rc |` S') v) \<longrightarrow>
        (\<exists>w w1 w2.
            w1 = ag v1 \<and>
            w2 = ag v2 \<and>
            w = w1 @ w2 \<and>
            w1 \<in> \<L> (the ((rm |` S') v1)) \<and> w2 \<in> \<L> (the ((rm |` S') v2))))"
    and p12: "\<forall>v1 v2 v. v \<in> S' \<and> v \<in> dom rc \<and> 
              (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<in> S' \<and> v2 \<in> S'"
    and p13: "S \<subseteq> S'"
  show "(\<forall>v\<in>S. \<exists>w. w = ag v) \<and>
    (\<forall>v w. v \<in> S \<and> w = ag v \<longrightarrow> w \<in> \<L> (the (rm v))) \<and>
    (\<forall>v1 v2 v.
        v \<in> dom rc \<and> v \<in> S \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
        (\<exists>w w1 w2.
            w1 = ag v1 \<and>
            w2 = ag v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2))))"
    apply (rule conjI)
    using p1 apply simp
    apply (rule conjI)
    using p1 p13 apply fastforce
  proof -
    from p1 have c1: "(\<forall>v1 v2 v.
       v \<in> dom (rc |` S') \<and> v \<in> S \<and> (v1, v2) \<in> the ((rc |` S') v) \<longrightarrow>
      (\<exists>w w1 w2.
          w1 = ag v1 \<and>
          w2 = ag v2 \<and>
          w = w1 @ w2 \<and> w1 \<in> \<L> (the ((rm |` S') v1)) \<and> w2 \<in> \<L> (the ((rm |` S') v2))))"
      by auto
    from c1
    show "\<forall>v1 v2 v.
       v \<in> dom rc \<and> v \<in> S \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
       (\<exists>w w1 w2.
           w1 = ag v1 \<and>
           w2 = ag v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2)))"
      apply (rule_tac allI)+
    proof fix v1 v2 v
      assume p2: "\<forall>v1 v2 v.
          v \<in> dom (rc |` S') \<and> v \<in> S \<and> (v1, v2) \<in> the ((rc |` S') v) \<longrightarrow>
          (\<exists>w w1 w2.
              w1 = ag v1 \<and>
              w2 = ag v2 \<and>
              w = w1 @ w2 \<and>
              w1 \<in> \<L> (the ((rm |` S') v1)) \<and> w2 \<in> \<L> (the ((rm |` S') v2)))"
      and p3: "v \<in> dom rc \<and> v \<in> S \<and> (v1, v2) \<in> the (rc v)"
      from p3 p13 
      have "v \<in> dom (rc |` S') \<and> v \<in> S \<and> (v1, v2) \<in> the ((rc |` S') v)"
        by fastforce        
      from this p2 have "
          (\<exists>w w1 w2.
              w1 = ag v1 \<and>
              w2 = ag v2 \<and>
              w = w1 @ w2 \<and>
              w1 \<in> \<L> (the ((rm |` S') v1)) \<and> w2 \<in> \<L> (the ((rm |` S') v2)))
      "
        by auto
      from this obtain w w1 w2 where
      "w1 = ag v1 \<and>
       w2 = ag v2 \<and>
       w = w1 @ w2 \<and>
       w1 \<in> \<L> (the ((rm |` S') v1)) \<and> w2 \<in> \<L> (the ((rm |` S') v2))"
        by fastforce
      from this p12 p3 p13
      have 
       "w1 = ag v1 \<and>
        w2 = ag v2 \<and>
        w = w1 @ w2 \<and>
        w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2))"
        by (metis in_mono restrict_in)
      from this
      show "\<exists>w w1 w2.
          w1 = ag v1 \<and>
          w2 = ag v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2))"
        by blast
    qed qed qed
      


lemma Forward_analysis_complete_gen:
  fixes rc :: "'a \<Rightarrow> ('a \<times> 'a) set option" and
        S  :: "'a set" and
        rm :: "'a \<Rightarrow> ('g :: NFA_states, 'h) NFA_rec option" and
        rm' :: "'a \<Rightarrow> ('g, 'h) NFA_rec option" and
        l :: "'a set list"
  assumes rm_v_OK: "\<And> v. v \<in> dom rm \<longrightarrow> NFA (the (rm v))"
      and rc_OK: "dom rc \<subseteq> S \<and> (\<forall> v \<in> S. v \<in> dom rc \<longrightarrow> finite (the (rc v)))" 
      and rm_OK: "S = dom rm" 
      and finite_S: "finite S"
      and S_ok: "S = \<Union> (set l) \<and> acyclic rc l \<and> uniq_indegree rc"
      and result_Ok: "forward_spec rm' S rc rm" 
    shows "(\<forall> v. v \<in> dom rm' \<longrightarrow> \<L> (the (rm' v)) \<noteq> {}) \<longrightarrow> 
           (\<forall> v w. v \<in> S \<and> w \<in> \<L> (the (rm' v)) \<longrightarrow> 
                 (\<exists> ag. w = ag v \<and> 
                  sat_pred_ass (reachable_set rc v) rc rm ag))"
  apply (insert S_ok rc_OK result_Ok rm_OK finite_S rm_v_OK)
  apply (induction rc l arbitrary: S rm rm' rule: acyclic.induct )
  apply simp
proof -
  { fix rc :: "'a \<Rightarrow> ('a \<times> 'a) set option"
    fix a :: "'a set"
    fix l :: "'a set list"
    fix S :: "'a set"
    fix rm  :: "'a \<Rightarrow> ('g :: NFA_states, 'h) NFA_rec option"
    fix rm' :: "'a \<Rightarrow> ('g, 'h) NFA_rec option"
    assume p1 : "(\<And> (S :: 'a set) 
            (rm :: 'a \<Rightarrow> ('g, 'h) NFA_rec option) 
             (rm' :: 'a \<Rightarrow> ('g , 'h) NFA_rec option).
           S = \<Union> (set l) \<and>
           Forward_Analysis.acyclic (rc |` \<Union> (set l)) l \<and>
           uniq_indegree (rc |` \<Union> (set l)) \<Longrightarrow>
           dom (rc |` \<Union> (set l)) \<subseteq> S \<and>
           (\<forall>v\<in>S. v \<in> dom (rc |` \<Union> (set l)) \<longrightarrow> finite (the ((rc |` \<Union> (set l)) v))) \<Longrightarrow>
           forward_spec rm' S (rc |` \<Union> (set l)) rm \<Longrightarrow>
           S = dom rm \<Longrightarrow>
           finite S \<Longrightarrow>
           (\<And>v. v \<in> dom rm \<longrightarrow> NFA (the (rm v))) \<Longrightarrow>
           (\<forall>v. v \<in> dom rm' \<longrightarrow> \<L> (the (rm' v)) \<noteq> {}) \<longrightarrow>
            (\<forall>v w. v \<in> S \<and> w \<in> \<L> (the (rm' v)) \<longrightarrow>
                  (\<exists>ag. w = ag v \<and>
                        sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v)
                         (rc |` \<Union> (set l)) rm ag)))" and
           p2 : "S = \<Union> (set (a # l)) \<and> Forward_Analysis.acyclic rc (a # l) \<and> uniq_indegree rc" and
           p3 : "dom rc \<subseteq> S \<and> (\<forall>v\<in>S. v \<in> dom rc \<longrightarrow> finite (the (rc v)))" and
           p4 : "forward_spec rm' S rc rm"  and
           p5 : "S = dom rm" and
           p6 : "finite S" and
           p7 : "(\<And>v. v \<in> dom rm \<longrightarrow> NFA (the (rm v)))"
    show "(\<And>v. v \<in> dom rm \<longrightarrow> NFA (the (rm v))) \<Longrightarrow>
       (\<forall>v. v \<in> dom rm' \<longrightarrow> \<L> (the (rm' v)) \<noteq> {}) \<longrightarrow>
       (\<forall>v w. v \<in> S \<and> w \<in> \<L> (the (rm' v)) \<longrightarrow>
              (\<exists>ag. w = ag v \<and> sat_pred_ass (reachable_set rc v) rc rm ag))"
      apply (rule impI allI) +
    proof -
      fix v w
      assume p8: "\<forall>v. v \<in> dom rm' \<longrightarrow> \<L> (the (rm' v)) \<noteq> {}" and
             p9: "v \<in> S \<and> w \<in> \<L> (the (rm' v))"
      show "\<exists>ag.  w = ag v \<and> sat_pred_ass (reachable_set rc v) rc rm ag"
      proof -
        let ?S = "\<Union> (set l)"
        let ?rc = "rc |` ?S"
        let ?rm = "rm |` ?S"
        have set_a_l: " \<Union> (set (a # l)) = a \<union> \<Union> (set l)"
          by fastforce
        from p2 acyclic.simps
        have cce2: "a \<inter> \<Union> (set l) = {}"
          by metis
        from p2 this set_a_l
        have S_a_correct: "S - a = \<Union> (set l)"
          by blast
        from p2 this acyclic_correct acyclic.simps
        have b1: "Forward_Analysis.acyclic ?rc l" 
          by blast
        from p2 have "uniq_indegree ?rc"
          unfolding uniq_indegree_def
          apply (rule_tac conjI) 
           apply (metis Int_iff dom_restrict restrict_in)
           apply (rule_tac conjI) 
           apply (metis Int_iff dom_restrict restrict_in) 
          by (metis Int_iff dom_restrict restrict_in)
        from this b1 have p1p1: "?S = \<Union> (set l) \<and> 
                    Forward_Analysis.acyclic ?rc l \<and> uniq_indegree ?rc"
          by blast
      from p2 acyclic.simps
        have "a \<inter> (\<Union> (set l)) = {}"  by metis
        from this p2 set_a_l
        have cce1: "(\<Union> (set l)) = (S - a)" 
        by blast
    have c3: "dom (rc |` \<Union> (set l)) \<subseteq>  \<Union> (set l)  \<and> 
      (\<forall>v \<in> \<Union> (set l) . v \<in> dom (rc |` \<Union> (set l)) \<longrightarrow> finite (the ((rc |` \<Union> (set l)) v)))"
      using cce1 p3 by auto


    from p4
     have ccc4: "dom rm' = dom rm \<and>
              (\<forall>v\<in>S. \<forall>w. NFA (the (rm' v)) \<and>
                          NFA_accept (the (rm' v)) w =
                          (NFA_accept (the (rm v)) w \<and>  (v \<in> dom rc \<longrightarrow>
                           (\<forall>(v1, v2)\<in>the (rc v).
                               \<exists>w1 w2.
                                  NFA_accept (the (rm' v1)) w1 \<and>
                                  NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2))))"
       unfolding forward_spec_def by auto
     from this
     have cccc4: "forward_spec (rm' |` (S - a)) (S - a) (rc |` \<Union> (set l)) (rm |` (S - a))"
       unfolding forward_spec_def
       apply simp
     proof 
       fix v
       assume pt1: "dom rm' = dom rm \<and>
         (\<forall>v\<in>S. NFA (the (rm' v)) \<and>
                 (\<forall>w. NFA_accept (the (rm' v)) w =
                      (NFA_accept (the (rm v)) w \<and> (v \<in> dom rc \<longrightarrow>
                       (\<forall>x\<in>the (rc v).
                           case x of
                           (v1, v2) \<Rightarrow>
                             \<exists>w1. NFA_accept (the (rm' v1)) w1 \<and>
                                  (\<exists>w2. NFA_accept (the (rm' v2)) w2 \<and>
                                        w = w1 @ w2))))))" and
     pt2: "v \<in> S - a"
       show " \<forall>w. (NFA_accept (the (rm v)) w \<and>
              (v \<in> dom rc \<longrightarrow>
               (\<forall>(v1, v2)\<in>the (rc v).
                   \<exists>w1. NFA_accept (the (rm' v1)) w1 \<and>
                        (\<exists>w2. NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2)))) =
             (NFA_accept (the (rm v)) w \<and>
              (v \<in> dom rc \<and> Bex (set l) ((\<in>) v) \<longrightarrow>
               (\<forall>(v1, v2)\<in>the (rc v).
                   \<exists>w1. NFA_accept (the ((rm' |` (S - a)) v1)) w1 \<and>
                        (\<exists>w2. NFA_accept (the ((rm' |` (S - a)) v2)) w2 \<and>
                              w = w1 @ w2))))"
         apply auto
           defer
         using cce1 pt2 apply auto[1]
     proof -
     {fix w aa b x y
       assume pb1: "NFA_accept (the (rm v)) w" and
              pb2: "\<forall>x\<in>y. case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the (rm' v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2) " and
              pb3: "(aa, b) \<in> y" and
              pb4: "x \<in> set l" and 
              pb5: "v \<in> x" and
              pb6: "rc v = Some y"
       from this have aa_b: "(aa, b) \<in> the (rc v)" 
         using cce1 pt2 by auto
       from this pb2 pb3 have cy1: "\<exists>w1. NFA_accept (the (rm' aa)) w1 \<and>
                 (\<exists>w2. NFA_accept (the (rm' b)) w2 \<and> w = w1 @ w2)"
         by auto
       from p1p1 S_a_correct
       have c3: "Forward_Analysis.acyclic (rc |` (S - a)) l" 
         by presburger
       from pt2 have pt2': "v \<in> \<Union> (set l)"
         using cce1 by blast
       from pb6 have "v \<in> dom rc" by auto
       from acyclic_dep1[of "rc |` \<Union> (set l)" l] c3 S_a_correct have
       "(\<forall>v v1 v2.
        v \<in> \<Union> (set l) \<and>
        v \<in> dom (rc |` \<Union> (set l)) \<and> (v1, v2) \<in> the ((rc |` \<Union> (set l)) v) \<longrightarrow>
        v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))"
         by (metis cce1) 
       from this pt2 pt2' cce1 pb3 pb6
       have "aa \<in> \<Union> (set l) \<and> b \<in> \<Union> (set l)"
         by (metis (no_types, lifting) aa_b restrict_map_eq(2) restrict_map_self)

       from this S_a_correct cy1
       show "\<exists>w1. NFA_accept (the ((rm' |` (S - a)) aa)) w1 \<and>
            (\<exists>w2. NFA_accept (the ((rm' |` (S - a)) b)) w2 \<and> w = w1 @ w2)"
         by auto
     }
     {
       fix w aa b y
       assume p1: "NFA_accept (the (rm v)) w"
          and p2: "\<forall>x\<in>y. case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the ((rm' |` (S - a)) v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the ((rm' |` (S - a)) v2)) w2 \<and> w = w1 @ w2)"
          and p3: "(aa, b) \<in> y" and
          p4: "rc v = Some y" 
       from this have aa_b: "(aa, b) \<in> the ((rc |` \<Union> (set l)) v)" 
         using cce1 pt2 by auto
       from this p2 p3 p4 have cy1: "\<exists>w1. NFA_accept (the ((rm' |` (S - a)) aa)) w1 \<and>
                 (\<exists>w2. NFA_accept (the ((rm' |` (S - a)) b)) w2 \<and> w = w1 @ w2)"
         by auto
       from p1p1 S_a_correct 
       have c3: "Forward_Analysis.acyclic (rc |` (S - a)) l" 
         by presburger
       from acyclic_dep1[of "rc |` \<Union> (set l)" l] c3 S_a_correct have
       "(\<forall>v v1 v2.
        v \<in> \<Union> (set l) \<and>
        v \<in> dom (rc |` \<Union> (set l)) \<and> (v1, v2) \<in> the ((rc |` \<Union> (set l)) v) \<longrightarrow>
        v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))"
         by (metis  cce1)
       from this aa_b have "aa \<in> \<Union> (set l) \<and> b \<in> \<Union> (set l)"
         by (metis cce1 domI p4 pt2 restrict_map_eq(2))
       from this S_a_correct cy1
       show " \<exists>w1. NFA_accept (the (rm' aa)) w1 \<and>
            (\<exists>w2. NFA_accept (the (rm' b)) w2 \<and> w = w1 @ w2)"
         by simp
     }
   qed qed
   from this S_a_correct
   have cccc4' : "forward_spec (rm' |` (S - a)) (\<Union> (set l)) (rc |` \<Union> (set l)) (rm |` (S - a)) "
     by simp

  from p5
     have c13: "S - a = dom (rm |` (S - a))" by auto
     from p6 have c14: "finite (S - a)" by auto

  have ccc5: "S - a = dom (rm |` (S - a))"
    using c13 by blast
  from ccc5 S_a_correct have ccc5': "\<Union> (set l) = dom (rm |` (S - a))" by auto

   have ccc6: "finite (S - a)"
     using c14 by blast
   from ccc6 S_a_correct 
   have ccc6': "finite (\<Union> (set l))" by simp

  from p7 
     have c11: "(\<And>v. v \<in> dom ?rm \<longrightarrow> NFA (the (?rm v)))"
       by auto

  have ccc7: "(\<And>v. v \<in> dom (rm |` (S - a)) \<longrightarrow> NFA (the ((rm |` (S - a)) v)))"
       using c11 S_a_correct by auto

   from p8
   have ccc8: "(\<forall>v. v \<in> dom (rm' |` (S - a)) \<longrightarrow> \<L> (the ((rm' |` (S - a)) v)) \<noteq> {})"
     by simp
   from ccc8 p1[OF p1p1 c3 cccc4' ccc5' ccc6' ccc7 ]
   have imp: "(\<forall>v w. v \<in> \<Union> (set l) \<and> w \<in> \<L> (the ((rm' |` (S - a)) v)) \<longrightarrow>
           (\<exists>ag. w = ag v \<and>
                 sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v) (rc |` \<Union> (set l))
                  (rm |` (S - a)) ag))"
     by simp


   from p3 have "v \<in> dom rc \<longrightarrow> finite (the (rc v))"
     by blast
   from this obtain lrc where
   lrc_OK1: "distinct lrc" and
   lrc_OK2: "v \<in> dom rc \<longrightarrow> set lrc = (the (rc v))" and
   lrc_OK3: "v \<notin> dom rc \<longrightarrow> lrc = []"
     by (metis distinct.simps(1) finite_distinct_list)

   from p4[unfolded forward_spec_def]
   have imp1: "dom rm' = dom rm \<and>
              (\<forall>v\<in>S. \<forall>w. NFA (the (rm' v)) \<and>
                          NFA_accept (the (rm' v)) w =
                          (NFA_accept (the (rm v)) w \<and>
                           (v \<in> dom rc \<longrightarrow>
                            (\<forall>(v1, v2)\<in>the (rc v).
                                \<exists>w1 w2.
                                   NFA_accept (the (rm' v1)) w1 \<and>
                                   NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2))))"
     by simp
   from imp1 p5 p9 have v_in_rm': "v \<in> dom rm'" 
     by auto
   from p9 imp1 have imp2: "NFA_accept (the (rm' v)) w"
     by (simp add: \<L>_def)
   from this  p9 imp1 have imp2': "NFA_accept (the (rm v)) w"
     by blast

  show "\<exists>ag. w = ag v \<and> sat_pred_ass (reachable_set rc v) rc rm ag"
  proof (cases "v \<notin> a")
    case True note v_notin_a = this
    from this 
    have v_in_Sa: "v \<in> S - a" 
      using p9 by auto
    from this imp
    have iimp: "(\<exists>ag. w = ag v \<and>
                sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v) (rc |` \<Union> (set l))
                 (rm |` (S - a)) ag)"
      by (simp add: cce1 p9)
    from rc_OK  have finite_rc': "\<forall>v\<in>S. v \<in> dom rc \<longrightarrow> finite (the (rc v))"
      using p3 by linarith
    from p9 have p9': "v \<in> S" by auto

    from p2 p9' v_notin_a finite_rc' reachable_sub[of rc a l v]
    have reachable_eq: "reachable_set rc v = reachable_set (rc |` \<Union> (set l)) v"
      by blast


  from this v_notin_a p2 p9 acyclic.simps
  have "v \<in> \<Union> (set l) \<and> acyclic rc l \<and> uniq_indegree rc"
    by (metis acyclic_tail cce1 v_in_Sa)
  from this acyclic_correct
  have co2: "v \<in> \<Union> (set l) \<and> acyclic (rc |` \<Union> (set l)) l \<and> uniq_indegree rc"
    using b1 by blast
  from finite_rc' p2
  have finite_rc'': "\<forall> v \<in> \<Union> (set (a # l)). v \<in> dom rc \<longrightarrow> finite (the (rc v))"
    by blast
  from reachable_subl[of v l rc] co2 finite_rc''
  have reachable_subset:"reachable_set (rc |` \<Union> (set l)) v \<subseteq> (\<Union> (set l))"
    using p3 by blast

  have tp1:  "Forward_Analysis.acyclic rc (a # l) \<and> uniq_indegree rc"
    using p2 by blast
  have tp2: "v \<in> \<Union> (set (a # l)) "
    using p2 p9' by blast
  from p3 have tp3: "\<forall>v\<in>\<Union> (set (a # l)). v \<in> dom rc \<longrightarrow> finite (the (rc v))"
    by blast
  from tp1 tp2 tp3 reachable_sub[of rc a l v]
  have rb': "reachable_set rc v = reachable_set (rc |` \<Union> (set l)) v"
    using reachable_eq by blast
  from iimp obtain ag where
  iimp': "w = ag v \<and>
       sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v) (rc |` \<Union> (set l))
        (rm |` (S - a)) ag" by auto
  from this 
  have "w = ag v \<and> sat_pred_ass (reachable_set rc v) rc rm ag"
    apply (rule_tac conjI)
    apply simp
    unfolding sat_pred_ass_def
  proof -
    assume ph1: "w = ag v \<and>
    (\<forall>v\<in>reachable_set (rc |` \<Union> (set l)) v. \<exists>w. w = ag v) \<and>
    (\<forall>va w.
        va \<in> reachable_set (rc |` \<Union> (set l)) v \<and> w = ag va \<longrightarrow>
        w \<in> \<L> (the ((rm |` (S - a)) va))) \<and>
    (\<forall>v1 v2 va.
        va \<in> dom (rc |` \<Union> (set l)) \<and>
        va \<in> reachable_set (rc |` \<Union> (set l)) v \<and>
        (v1, v2) \<in> the ((rc |` \<Union> (set l)) va) \<longrightarrow>
        (\<exists>w w1 w2.
            w1 = ag v1 \<and>
            w2 = ag v2 \<and>
            w = w1 @ w2 \<and>
            w1 \<in> \<L> (the ((rm |` (S - a)) v1)) \<and> w2 \<in> \<L> (the ((rm |` (S - a)) v2))))"

    show "(\<forall>v\<in>reachable_set rc v. \<exists>w. w = ag v) \<and>
    (\<forall>va w. va \<in> reachable_set rc v \<and> w = ag va \<longrightarrow> w \<in> \<L> (the (rm va))) \<and>
    (\<forall>v1 v2 va.
        va \<in> dom rc \<and> va \<in> reachable_set rc v \<and> (v1, v2) \<in> the (rc va) \<longrightarrow>
        (\<exists>w w1 w2.
            w1 = ag v1 \<and>
            w2 = ag v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2))))"
      apply (rule conjI)
      using ph1 rb' apply simp
      apply (rule conjI)
      apply (subgoal_tac "(\<forall>va w.
        va \<in> reachable_set (rc |` \<Union> (set l)) v \<and> w = ag va \<longrightarrow>
        w \<in> \<L> (the ((rm |` (S - a)) va)))")
      using ph1 rb' reachable_subset cce1
      apply fastforce
      using ph1 apply simp
      apply (rule allI)+
    proof 
      fix v1 v2 va
      assume ph2: "va \<in> dom rc \<and> va \<in> reachable_set rc v \<and> (v1, v2) \<in> the (rc va)"
      from ph1 have ph1': "(\<forall>v1 v2 va.
      va \<in> dom (rc |` \<Union> (set l)) \<and>
      va \<in> reachable_set (rc |` \<Union> (set l)) v \<and>
      (v1, v2) \<in> the ((rc |` \<Union> (set l)) va) \<longrightarrow>
      (\<exists>w w1 w2.
          w1 = ag v1 \<and>
          w2 = ag v2 \<and>
          w = w1 @ w2 \<and>
          w1 \<in> \<L> (the ((rm |` (S - a)) v1)) \<and> w2 \<in> \<L> (the ((rm |` (S - a)) v2))))"
        by simp
      
      from ph2 reachable_subset cce1 rb'
      have "va \<in> dom (rc |` \<Union> (set l)) \<and>
       va \<in> reachable_set (rc |` \<Union> (set l)) v \<and>
       (v1, v2) \<in> the ((rc |` \<Union> (set l)) va)"
        by auto
      from this ph1'
      have "(\<exists>w w1 w2.
            w1 = ag v1 \<and>
            w2 = ag v2 \<and>
            w = w1 @ w2 \<and>
            w1 \<in> \<L> (the ((rm |` (S - a)) v1)) \<and> w2 \<in> \<L> (the ((rm |` (S - a)) v2)))"
        by fastforce
      from this show "\<exists>w w1 w2.
          w1 = ag v1 \<and>
          w2 = ag v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2))"
        by (metis \<open>v \<in> \<Union> (set l) \<and> Forward_Analysis.acyclic rc l \<and> uniq_indegree rc\<close> \<open>va \<in> dom (rc |` \<Union> (set l)) \<and> va \<in> reachable_set (rc |` \<Union> (set l)) v \<and> (v1, v2) \<in> the ((rc |` \<Union> (set l)) va)\<close> acyclic_dep1 c3 cce1 ph2 restrict_in subset_eq)
    qed qed
  from this 
    show ?thesis 
      by fastforce
  next
   case False note v_in_a = this
   from p2 acyclic.simps(2)[of rc a l] cce1
   have suc1: "v \<in> dom rc \<longrightarrow>  (\<forall> (v1, v2) \<in> the (rc v). v1 \<in> S - a \<and> v2 \<in> S - a)"
     using acyclic_dep2 case_prodI2 cce1 v_in_a
     by (metis (no_types, lifting))
   from p5
   have suc2: "\<forall> v2 w . v2 \<in> S - a  \<longrightarrow> NFA_accept (the (rm' v2)) w = 
          NFA_accept (the ((rm' |` (S - a)) v2)) w"
     by auto

   from imp1 p9
   have "(v \<in> dom rc \<longrightarrow>
      (\<forall>(v1, v2)\<in>the (rc v).
          \<exists>w1 w2.
             NFA_accept (the (rm' v1)) w1 \<and>
             NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2))"
     using imp2 by auto
  
   from suc1 p9 this suc2
   have "v \<in> dom rc \<longrightarrow>
    (\<forall>(v1, v2)\<in>the (rc v).
        \<exists>w1 w2.
           NFA_accept (the ((rm' |` (S - a)) v1)) w1 \<and> 
           NFA_accept (the ((rm' |` (S - a)) v2)) w2 \<and> w = w1 @ w2)"
     by blast
   from this \<L>_def
   have "v \<in> dom rc \<longrightarrow>  (\<forall> (v1, v2) \<in> the (rc v).
        \<exists> w1 w2. w = w1 @ w2 \<and> w1 \<in> \<L> (the ((rm' |` (S - a)) v1)) \<and>
        w2 \<in> \<L> (the ((rm' |` (S - a)) v2)))"
     by blast

   from suc1 cce1
   have "v \<in> dom rc \<longrightarrow> (\<forall>(v1, v2)\<in>the (rc v). v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))" 
     by simp
    
   from p2 have acyclic_l: "acyclic rc l"
         by (metis acyclic_tail)
   have "v \<in> dom rc \<longrightarrow> (\<forall> (v1,v2) \<in> (the (rc v)).
          (\<exists> w1 w2 ag1 ag2. w = w1 @ w2 \<and> 
             w1 = ag1 v1 \<and> sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v1) rc rm ag1 \<and>
             w2 = ag2 v2 \<and> sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v2) rc rm ag2
           ))"
   proof 
     assume ps1: "v \<in> dom rc"
     show "\<forall>(v1, v2)\<in>the (rc v).
       \<exists>w1 w2 ag1 ag2.
          w = w1 @ w2 \<and>
          w1 = ag1 v1 \<and>
          sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v1) rc rm ag1 \<and>
          w2 = ag2 v2 \<and> sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v2) rc rm ag2"
     proof
       fix x
       assume px1: "x \<in> the (rc v)"
       from this obtain v1 v2 where
       x_v1_v2: "x = (v1,v2)" by fastforce
       from this show "case x of
         (v1, v2) \<Rightarrow>
           \<exists>w1 w2 ag1 ag2.
              w = w1 @ w2 \<and>
              w1 = ag1 v1 \<and>
              sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v1) rc rm ag1 \<and>
              w2 = ag2 v2 \<and>
              sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v2) rc rm ag2"
         apply simp
       proof -
         from imp1 imp2 ps1
         have "\<exists>w1 w2. NFA_accept (the (rm' v1)) w1 \<and>
                       NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2"
           using \<open>v \<in> dom rc \<longrightarrow> (\<forall>(v1, v2)\<in>the (rc v). \<exists>w1 w2. NFA_accept (the (rm' v1)) w1 \<and> NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2)\<close> \<open>x = (v1, v2)\<close> \<open>x \<in> the (rc v)\<close> by auto
         from this obtain w1 w2 where
         w1w2: "NFA_accept (the (rm' v1)) w1 \<and>
                       NFA_accept (the (rm' v2)) w2 \<and> w = w1 @ w2"
           by auto
         from w1w2 have 
         pc1 : "w1 \<in> \<L> (the ((rm' |` (S - a)) v1))" and 
         pc2 : "w2 \<in> \<L> (the ((rm' |` (S - a)) v2))"
         apply (metis NFA_accept_alt_def \<open>x = (v1, v2)\<close> \<open>x \<in> the (rc v)\<close> acyclic_dep2 cce1 p2 ps1 restrict_in v_in_a)
         by (metis NFA_accept_alt_def \<open>x = (v1, v2)\<close> \<open>x \<in> the (rc v)\<close> acyclic_dep2 cce1 p2 ps1 restrict_in v_in_a w1w2)
       from px1 suc1 cce1 x_v1_v2
       have v1v2_dom: "v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l)"
         using ps1 by blast
       from v1v2_dom imp pc1 pc2 w1w2 
       have "v1 \<in> \<Union> (set l) \<and> w1 \<in> \<L> (the ((rm' |` (S - a)) v1))"
         by blast
      from this v1v2_dom imp
       have cp2: "\<exists>ag. w1 = ag v1 \<and>
                sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v1) (rc |` \<Union> (set l))
                 (rm |` (S - a)) ag"
         by fastforce
       from v1v2_dom imp pc1 pc2 w1w2 
       have "v2 \<in> \<Union> (set l) \<and> w2 \<in> \<L> (the ((rm' |` (S - a)) v2))"
         by blast
       from this v1v2_dom imp
       have cp1: "\<exists>ag. w2 = ag v2 \<and>
                sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v2) (rc |` \<Union> (set l))
                 (rm |` (S - a)) ag"
         by fastforce

       have "Forward_Analysis.acyclic rc (a # l) \<and> uniq_indegree rc"
         using p2 by blast

       from reachable_subl[of v1 l rc]
       have sub1: "reachable_set (rc |` \<Union> (set l)) v1 \<subseteq> \<Union> (set l)"
         using b1 p2 p3 v1v2_dom by blast

       from reachable_subl[of v2 l rc]
       have sub2: "reachable_set (rc |` \<Union> (set l)) v2 \<subseteq> \<Union> (set l)"
         using b1 p2 p3 v1v2_dom by blast

       from cp2 obtain ag1 where ag1_def:"w1 = ag1 v1 \<and>
       sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v1) (rc |` \<Union> (set l))
        (rm |` (S - a)) ag1" by auto
         
       from acyclic_l this acyclic.simps
       have v12_in_setl: "\<forall>v1 v2 v.
       v \<in> \<Union> (set l) \<and> v \<in> dom rc \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
       v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l)" 
         by (metis acyclic_dep1)

       from this sub1 cce1 ag1_def 
            sat_pred_ass_sub[of "reachable_set (rc |` \<Union> (set l)) v1"
                      rc "\<Union> (set l)" rm ag1]
       have ag1_get: "(w1 = ag1 v1 \<and>
          sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v1) rc rm ag1)"
       by fastforce

      from cp1 obtain ag2 where ag2_def:"w2 = ag2 v2 \<and>
       sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v2) (rc |` \<Union> (set l))
        (rm |` (S - a)) ag2" by auto

      from v12_in_setl sub2 cce1 ag2_def 
            sat_pred_ass_sub[of "reachable_set (rc |` \<Union> (set l)) v2"
                      rc "\<Union> (set l)" rm ag2]
       have ag2_get: "(w2 = ag2 v2 \<and>
          sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v2) rc rm ag2)"
         by fastforce
       from ag1_get ag2_get
       have "
       w = w1 @ w2 \<and>
       (\<exists>ag1. w1 = ag1 v1 \<and>
          sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v1) rc rm ag1) \<and>
              (\<exists>ag2. w2 = ag2 v2 \<and>
                    sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v2) rc rm ag2)"
         using w1w2 by blast
        from this
      show "\<exists>w1 w2.
       w = w1 @ w2 \<and>
       (\<exists>ag1.  w1 = ag1 v1 \<and>
              sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v1) rc rm ag1 \<and>
              (\<exists>ag2. w2 = ag2 v2 \<and>
                     sat_pred_ass (reachable_set (rc |` \<Union> (set l)) v2) rc rm ag2))"
          by auto
      qed qed qed

      from p2 acyclic_correct have acycl: "acyclic rc (a # l)"
        using acyclic_l by blast

      have "\<And> v1 v2. lrc \<noteq> [] \<and> (v1, v2) \<in> set lrc \<longrightarrow> (v1, v2) \<in> the (rc v)"
        apply (insert lrc_OK2)
      proof
        fix v1 v2
        assume vlrc: "v \<in> dom rc \<longrightarrow> set lrc = the (rc v)" and
            v1v2lrc: "lrc \<noteq> [] \<and> (v1, v2) \<in> set lrc"
        from this lrc_OK3 
        have v_rc: "v \<in> dom rc" 
          by fastforce
        from this vlrc have "set lrc = the (rc v)" by simp
        from this show "(v1, v2) \<in> the (rc v)"
          using v1v2lrc by blast
      qed
      
      from this lrc_OK3 lrc_OK1 acycl
      have fsuc1: 
       "(\<exists>ag. sat_pred_ass (reachable_set_l rc lrc) rc rm ag 
             \<and> ((\<forall> (v1,v2) \<in> set lrc. w = ag v1 @ ag v2
                  \<and> ag v1 \<in> \<L> (the (rm v1)) \<and> ag v2 \<in> \<L> (the (rm v2)))))"
        apply (induction lrc)
        
        defer
        apply (rename_tac x lrc)
      proof -
      {
        show "(\<And>v1 v2. [] \<noteq> [] \<and> (v1, v2) \<in> set [] \<longrightarrow> (v1, v2) \<in> the (rc v)) \<Longrightarrow>
    v \<notin> dom rc \<longrightarrow> [] = [] \<Longrightarrow>
    distinct [] \<Longrightarrow>
    \<exists>ag. sat_pred_ass (reachable_set_l rc []) rc rm ag \<and>
         (\<forall>(v1, v2)\<in>set [].
             w = ag v1 @ ag v2 \<and> ag v1 \<in> \<L> (the (rm v1)) \<and> ag v2 \<in> \<L> (the (rm v2)))"
          apply simp
          unfolding sat_pred_ass_def
          by simp
      }
      {
        fix x :: "'a \<times> 'a"
        fix lrc :: "('a \<times> 'a) list"
        assume pt1: "((\<And>v1 v2. lrc \<noteq> [] \<and> (v1, v2) \<in> set lrc \<longrightarrow> (v1, v2) \<in> the (rc v)) \<Longrightarrow>
        v \<notin> dom rc \<longrightarrow> lrc = [] \<Longrightarrow>
        distinct lrc \<Longrightarrow> acyclic rc (a#l) \<Longrightarrow>
        \<exists>ag. sat_pred_ass (reachable_set_l rc lrc) rc rm ag \<and>
             (\<forall>(v1, v2)\<in>set lrc.
                 w = ag v1 @ ag v2 \<and>
                 ag v1 \<in> \<L> (the (rm v1)) \<and> ag v2 \<in> \<L> (the (rm v2))))"
           and pt2: "(\<And>v1 v2. x # lrc \<noteq> [] \<and> (v1, v2) \<in> set (x # lrc) \<longrightarrow> 
                      (v1, v2) \<in> the (rc v))" 
           and pt3: "v \<notin> dom rc \<longrightarrow> x # lrc = []" 
           and pt4: "distinct (x # lrc)" and
               pt5: "acyclic rc (a # l)"
      from pt2 
      have pt2': "\<And>v1 v2. lrc \<noteq> [] \<and> (v1, v2) \<in> set lrc \<longrightarrow> (v1, v2) \<in> the (rc v)"
          by simp
      from pt3 have pt3': "v \<notin> dom rc \<longrightarrow> lrc = []"
        by blast 
      from pt4 have pt4': "distinct lrc" by fastforce
      from pt1 this pt3' pt5  pt2' obtain ag1 where
      ho1: "sat_pred_ass (reachable_set_l rc lrc) rc rm ag1 \<and>
            (\<forall>a\<in>set lrc.
                case a of
                (v1, v2) \<Rightarrow>
                  w = ag1 v1 @ ag1 v2 \<and>
                  ag1 v1 \<in> \<L> (the (rm v1)) \<and> ag1 v2 \<in> \<L> (the (rm v2)))" by blast 
      obtain x1 x2 where
      "x = (x1,x2)" 
        by force
      from this pt2
      have x1x2v: "(x1,x2) \<in> the (rc v)" by fastforce
      from this have "\<exists> x1 x2. (x1,x2) \<in> the (rc v)" by fastforce
      have "x # lrc \<noteq> []" by fastforce
      from this pt3
      have v_in_rc: "v \<in> dom rc"
        by auto
      from p2 this 
      have x1_neq_x2: "x1 \<noteq> x2"
        unfolding uniq_indegree_def
        using x1x2v by blast
      from x1x2v 
      have x1x2inv: "{x1,x2} \<subseteq> child_set rc v"
        unfolding child_set_def
        using \<open>v \<in> dom rc\<close> by blast
      from x1x2v x1_neq_x2 distjoint_subtree_reachable[of rc] p2 this acyclic_l this 
      have hop4: "reachable_set rc x1 \<inter> reachable_set rc x2 = {}"
        by (metis Int_iff inf_sup_absorb set_a_l v_in_a)
      from pt2' pt4
      have hop5: "reachable_set rc x1 \<inter> (reachable_set_l rc lrc) = {}"
        apply (induction lrc)
         apply simp
        apply (rename_tac b lrc)
      proof - 
        fix b lrc
        assume pl1: "((\<And>v1 v2. lrc \<noteq> [] \<and> 
                      (v1, v2) \<in> set lrc \<longrightarrow> (v1, v2) \<in> the (rc v)) \<Longrightarrow>
                      distinct (x # lrc) \<Longrightarrow>
                      reachable_set rc x1 \<inter> reachable_set_l rc lrc = {})"
           and pl2: "(\<And>v1 v2. b # lrc \<noteq> [] \<and> (v1, v2) \<in> set (b # lrc) \<longrightarrow> 
                     (v1, v2) \<in> the (rc v))" and
               pl3: "distinct (x # b # lrc)"
        show "reachable_set rc x1 \<inter> reachable_set_l rc (b # lrc) = {}"
        proof (cases "lrc = []")
        case True
        from this reachable_set_l.simps(2)[of rc]
        have cr1: "reachable_set_l rc (b # lrc) = 
                        reachable_set rc (fst b) \<union> reachable_set rc (snd b)"
          by (metis Un_empty_right reachable_set_l.simps(1) reachable_set_l.simps(2) surjective_pairing)
        from pl2
        have a_in_v: "(fst b, snd b) \<in> the (rc v)"
          by (metis list.discI list.set_intros(1) pl2 prod.collapse)
        from pl3 have x1x2neqa: "(x1, x2) \<noteq> (fst b, snd b)"
          by (simp add: \<open>x = (x1, x2)\<close>)
        from p2 have urc: "uniq_indegree rc " unfolding uniq_indegree_def
          by blast
        from this have "(\<And> v1 v2 v3 v4 v.
      v \<in> dom rc \<and>
      (v1, v2) \<in> the (rc v) \<and> (v3, v4) \<in> the (rc v) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
      {v1, v2} \<inter> {v3, v4} = {})"
          unfolding uniq_indegree_def
          by blast
        from this[of v x1 x2 "fst b" "snd b"] v_in_rc x1x2v x1x2neqa a_in_v
        have "{x1,x2} \<inter> {fst b, snd b} = {}"
          by blast
        from this have x1fsb: "x1 \<noteq> fst b \<and> x1 \<noteq> snd b" by auto
        from x1x2v a_in_v
        have "{x1, fst b, snd b} \<subseteq> child_set rc v"
          unfolding child_set_def
          using v_in_rc by blast
        have "{x1, fst b} \<subseteq> (child_set rc v) \<and> v \<in> \<Union> (set (a # l))"
          using \<open>{x1, fst b, snd b} \<subseteq> child_set rc v\<close> v_in_a by auto
        from this distjoint_subtree_reachable[OF urc] pt5 x1fsb
        have c1: "reachable_set rc x1 \<inter> reachable_set rc (fst b) = {}"
          by blast

        have  "{x1, snd b} \<subseteq> (child_set rc v) \<and> v \<in> \<Union> (set (a # l))"
          using \<open>{x1, fst b, snd b} \<subseteq> child_set rc v\<close> v_in_a by auto
        from this distjoint_subtree_reachable[OF urc] pt5 x1fsb
        have c2: "reachable_set rc x1 \<inter> reachable_set rc (snd b) = {}"
          by blast
        from c1 c2 cr1
        show ?thesis
          by fastforce
        next
          case False
          from this pl2
          have pc1: "(\<And>v1 v2. lrc \<noteq> [] \<and> (v1, v2) \<in> set lrc \<longrightarrow> (v1, v2) \<in> the (rc v))"
            by fastforce
          from pl3 have pl3': "distinct (x#lrc)" by auto
          from pl1 this pc1 False 
          have cr: "reachable_set rc x1 \<inter> reachable_set_l rc lrc = {}"
            by fastforce
          from pl3 have "x \<noteq> b" by auto

        from pl2
        have a_in_v: "(fst b, snd b) \<in> the (rc v)"
          by (metis list.discI list.set_intros(1) pl2 prod.collapse)
        from pl3 have x1x2neqa: "(x1, x2) \<noteq> (fst b, snd b)"
          by (simp add: \<open>x = (x1, x2)\<close>)
        from p2 have urc: "uniq_indegree rc " unfolding uniq_indegree_def
          by blast
        from this have "(\<And> v1 v2 v3 v4 v.
      v \<in> dom rc \<and>
      (v1, v2) \<in> the (rc v) \<and> (v3, v4) \<in> the (rc v) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
      {v1, v2} \<inter> {v3, v4} = {})"
          unfolding uniq_indegree_def
          by blast
        from this[of v x1 x2 "fst b" "snd b"] v_in_rc x1x2v x1x2neqa a_in_v
        have "{x1,x2} \<inter> {fst b, snd b} = {}"
          by blast
        from this have x1fsb: "x1 \<noteq> fst b \<and> x1 \<noteq> snd b" by auto
        from x1x2v a_in_v
        have "{x1, fst b, snd b} \<subseteq> child_set rc v"
          unfolding child_set_def
          using v_in_rc by blast
        have "{x1, fst b} \<subseteq> (child_set rc v) \<and> v \<in> \<Union> (set (a # l))"
          using \<open>{x1, fst b, snd b} \<subseteq> child_set rc v\<close> v_in_a by auto
        from this distjoint_subtree_reachable[OF urc] pt5 x1fsb
        have c1: "reachable_set rc x1 \<inter> reachable_set rc (fst b) = {}"
          by blast

        have  "{x1, snd b} \<subseteq> (child_set rc v) \<and> v \<in> \<Union> (set (a # l))"
          using \<open>{x1, fst b, snd b} \<subseteq> child_set rc v\<close> v_in_a by auto
        from this distjoint_subtree_reachable[OF urc] pt5 x1fsb
        have c2: "reachable_set rc x1 \<inter> reachable_set rc (snd b) = {}"
          by blast

        from c1 c2 cr reachable_set_l.simps(2)[of rc "fst b" "snd b" lrc]
        show ?thesis 
          by auto 
qed qed
  from pt2' pt4
  have hop6: "reachable_set rc x2 \<inter> (reachable_set_l rc lrc) = {}"
      apply (induction lrc)
      apply simp
      apply (rename_tac b lrc)
      proof - 
        fix b lrc
        assume pl1: "((\<And>v1 v2. lrc \<noteq> [] \<and> 
                      (v1, v2) \<in> set lrc \<longrightarrow> (v1, v2) \<in> the (rc v)) \<Longrightarrow>
                      distinct (x # lrc) \<Longrightarrow>
                      reachable_set rc x2 \<inter> reachable_set_l rc lrc = {})"
           and pl2: "(\<And>v1 v2. b # lrc \<noteq> [] \<and> (v1, v2) \<in> set (b # lrc) \<longrightarrow> 
                     (v1, v2) \<in> the (rc v))" and
               pl3: "distinct (x # b # lrc)"
        show "reachable_set rc x2 \<inter> reachable_set_l rc (b # lrc) = {}"
        proof (cases "lrc = []")
        case True
        from this reachable_set_l.simps(2)[of rc]
        have cr1: "reachable_set_l rc (b # lrc) = 
                        reachable_set rc (fst b) \<union> reachable_set rc (snd b)"
          by (metis Un_empty_right reachable_set_l.simps(1) reachable_set_l.simps(2) surjective_pairing)
        from pl2
        have a_in_v: "(fst b, snd b) \<in> the (rc v)"
          by (metis list.discI list.set_intros(1) pl2 prod.collapse)
        from pl3 have x1x2neqa: "(x1, x2) \<noteq> (fst b, snd b)"
          by (simp add: \<open>x = (x1, x2)\<close>)
        from p2 have urc: "uniq_indegree rc " unfolding uniq_indegree_def
          by blast
        from this have "(\<And> v1 v2 v3 v4 v.
      v \<in> dom rc \<and>
      (v1, v2) \<in> the (rc v) \<and> (v3, v4) \<in> the (rc v) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
      {v1, v2} \<inter> {v3, v4} = {})"
          unfolding uniq_indegree_def
          by blast
        from this[of v x1 x2 "fst b" "snd b"] v_in_rc x1x2v x1x2neqa a_in_v
        have "{x1,x2} \<inter> {fst b, snd b} = {}"
          by blast
        from this have x1fsb: "x2 \<noteq> fst b \<and> x2 \<noteq> snd b" by auto
        from x1x2v a_in_v
        have "{x2, fst b, snd b} \<subseteq> child_set rc v"
          unfolding child_set_def
          using v_in_rc by blast
        have "{x2, fst b} \<subseteq> (child_set rc v) \<and> v \<in> \<Union> (set (a # l))"
          using \<open>{x2, fst b, snd b} \<subseteq> child_set rc v\<close> v_in_a by auto
        from this distjoint_subtree_reachable[OF urc] pt5 x1fsb
        have c1: "reachable_set rc x2 \<inter> reachable_set rc (fst b) = {}"
          by blast

        have  "{x2, snd b} \<subseteq> (child_set rc v) \<and> v \<in> \<Union> (set (a # l))"
          using \<open>{x2, fst b, snd b} \<subseteq> child_set rc v\<close> v_in_a by auto
        from this distjoint_subtree_reachable[OF urc] pt5 x1fsb
        have c2: "reachable_set rc x2 \<inter> reachable_set rc (snd b) = {}"
          by blast
        from c1 c2 cr1
        show ?thesis
          by fastforce
        next
          case False
          from this pl2
          have pc1: "(\<And>v1 v2. lrc \<noteq> [] \<and> (v1, v2) \<in> set lrc \<longrightarrow> (v1, v2) \<in> the (rc v))"
            by fastforce
          from pl3 have pl3': "distinct (x#lrc)" by auto
          from pl1 this pc1 False 
          have cr: "reachable_set rc x2 \<inter> reachable_set_l rc lrc = {}"
            by fastforce
          from pl3 have "x \<noteq> b" by auto

        from pl2
        have a_in_v: "(fst b, snd b) \<in> the (rc v)"
          by (metis list.discI list.set_intros(1) pl2 prod.collapse)
        from pl3 have x1x2neqa: "(x1, x2) \<noteq> (fst b, snd b)"
          by (simp add: \<open>x = (x1, x2)\<close>)
        from p2 have urc: "uniq_indegree rc " unfolding uniq_indegree_def
          by blast
        from this have "(\<And> v1 v2 v3 v4 v.
      v \<in> dom rc \<and>
      (v1, v2) \<in> the (rc v) \<and> (v3, v4) \<in> the (rc v) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
      {v1, v2} \<inter> {v3, v4} = {})"
          unfolding uniq_indegree_def
          by blast
        from this[of v x1 x2 "fst b" "snd b"] v_in_rc x1x2v x1x2neqa a_in_v
        have "{x1,x2} \<inter> {fst b, snd b} = {}"
          by blast
        from this have x1fsb: "x2 \<noteq> fst b \<and> x2 \<noteq> snd b" by auto
        from x1x2v a_in_v
        have "{x2, fst b, snd b} \<subseteq> child_set rc v"
          unfolding child_set_def
          using v_in_rc by blast
        have "{x2, fst b} \<subseteq> (child_set rc v) \<and> v \<in> \<Union> (set (a # l))"
          using \<open>{x2, fst b, snd b} \<subseteq> child_set rc v\<close> v_in_a by auto
        from this distjoint_subtree_reachable[OF urc] pt5 x1fsb
        have c1: "reachable_set rc x2 \<inter> reachable_set rc (fst b) = {}"
          by blast

        have  "{x2, snd b} \<subseteq> (child_set rc v) \<and> v \<in> \<Union> (set (a # l))"
          using \<open>{x2, fst b, snd b} \<subseteq> child_set rc v\<close> v_in_a by auto
        from this distjoint_subtree_reachable[OF urc] pt5 x1fsb
        have c2: "reachable_set rc x2 \<inter> reachable_set rc (snd b) = {}"
          by blast

        from c1 c2 cr reachable_set_l.simps(2)[of rc "fst b" "snd b" lrc]
        show ?thesis 
          by auto 
qed qed
  from hop5 hop6 x1_neq_x2
  have hop7: "x1 \<noteq> x2 \<and> x1 \<notin> (reachable_set_l rc lrc) \<and> x2 \<notin> (reachable_set_l rc lrc)"
     apply (rule_tac conjI)
     apply simp
     apply (subgoal_tac "x1 \<in> reachable_set rc x1 \<and> x2 \<in> reachable_set rc x2")
     apply blast
    using reachable_set_def[of rc x1] reachable_set_def[of rc x2] reachable.simps
    by force

  have ppr1: "v \<in> dom rc \<and> (x1,x2) \<in> the (rc v) \<and> x1 \<in> \<Union> (set l) \<and> x2 \<in> \<Union> (set l)"
    using acyclic_dep2 pt5 v_in_a v_in_rc x1x2v by blast
  have "NFA_accept (the (rm' v)) w"
    by (simp add: imp2)
    from imp1 this p9 ppr1 cce1
      obtain w1' w2' where
       w1w2': "w1' \<in>  \<L> (the ((rm' |` (S - a)) x1))" and
       w2x2: "w2' \<in>  \<L> (the ((rm' |` (S - a)) x2))" and
       ww1w2: "w = w1' @ w2'"
        using \<open>v \<in> dom rc \<longrightarrow> (\<forall>(v1, v2)\<in>the (rc v). \<exists>w1 w2. w = w1 @ w2 \<and> w1 \<in> \<L> (the ((rm' |` (S - a)) v1)) \<and> w2 \<in> \<L> (the ((rm' |` (S - a)) v2)))\<close> by blast
      from reachable_sub[of rc a l x1]
      have rx1: "reachable_set rc x1 = 
            reachable_set (rc |` \<Union> (set l)) x1"
        using cce1 p2 p3 ppr1 by blast

      from reachable_sub[of rc a l x2]
      have rx2: "reachable_set rc x2 = 
            reachable_set (rc |` \<Union> (set l)) x2"
        using cce1 p2 p3 ppr1 by blast
      from w1w2' w2x2 ww1w2 imp rx1 rx2 ppr1
      have "x1 \<in> \<Union> (set l) \<and> w1' \<in> \<L> (the ((rm' |` (S - a)) x1)) \<longrightarrow>
          (\<exists>ag. w1' = ag x1 \<and>
                sat_pred_ass (reachable_set (rc |` \<Union> (set l)) x1) (rc |` \<Union> (set l))
                 (rm |` (S - a)) ag)"
        by blast
      from this w1w2' ppr1
      have exisag1: "(\<exists>ag. w1' = ag x1 \<and>
                sat_pred_ass (reachable_set (rc |` \<Union> (set l)) x1) (rc |` \<Union> (set l))
                 (rm |` (S - a)) ag)"
        by blast

      from reachable_subl[of x1 l rc]
      have rx1sub: "reachable_set (rc |` \<Union> (set l)) x1 \<subseteq> \<Union> (set l)"
        using b1 p2 p3 ppr1 by blast

      from exisag1 rx1 this cce1
      obtain ag2 where "w1' = ag2 x1 \<and>
         sat_pred_ass (reachable_set (rc |` \<Union> (set l)) x1) (rc |` \<Union> (set l))
          (rm |` (S - a)) ag2"
        by auto

      thm rx1 rx1sub cce1

      from this 
      have
      hop1: "w1' = ag2 x1 \<and>
                sat_pred_ass (reachable_set (rc) x1) (rc)
                 (rm) ag2" 
        unfolding sat_pred_ass_def
        apply (rule_tac conjI)
        apply simp[1]
        apply (rule_tac conjI)
        using rx1 rx1sub cce1
        apply fastforce
        apply (rule_tac conjI)
        using rx1 rx1sub cce1
        apply fastforce
        using rx1 rx1sub cce1
      proof -
        assume ppr2: "w1' = ag2 x1 \<and>
    (\<forall>v\<in>reachable_set (rc |` \<Union> (set l)) x1. \<exists>w. w = ag2 v) \<and>
    (\<forall>v w. v \<in> reachable_set (rc |` \<Union> (set l)) x1 \<and> w = ag2 v \<longrightarrow>
           w \<in> \<L> (the ((rm |` (S - a)) v))) \<and>
    (\<forall>v1 v2 v.
        v \<in> dom (rc |` \<Union> (set l)) \<and>
        v \<in> reachable_set (rc |` \<Union> (set l)) x1 \<and>
        (v1, v2) \<in> the ((rc |` \<Union> (set l)) v) \<longrightarrow>
        (\<exists>w w1 w2.
            w1 = ag2 v1 \<and>
            w2 = ag2 v2 \<and>
            w = w1 @ w2 \<and>
            w1 \<in> \<L> (the ((rm |` (S - a)) v1)) \<and> w2 \<in> \<L> (the ((rm |` (S - a)) v2))))"
        from this 
        have su1: "(\<forall>v1 v2 v.
        v \<in> dom (rc |` \<Union> (set l)) \<and>
        v \<in> reachable_set (rc |` \<Union> (set l)) x1 \<and>
        (v1, v2) \<in> the ((rc |` \<Union> (set l)) v) \<longrightarrow>
        (\<exists>w w1 w2.
            w1 = ag2 v1 \<and>
            w2 = ag2 v2 \<and>
            w = w1 @ w2 \<and>
            w1 \<in> \<L> (the ((rm |` (S - a)) v1)) \<and> w2 \<in> \<L> (the ((rm |` (S - a)) v2))))"
          by blast


        show " \<forall>v1 v2 v.
       v \<in> dom rc \<and> v \<in> reachable_set rc x1 \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
       (\<exists>w w1 w2.
           w1 = ag2 v1 \<and>
           w2 = ag2 v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2)))"
          apply (rule allI)+
        proof fix v1 v2 v
          assume ppr3: "v \<in> dom rc \<and> v \<in> reachable_set rc x1 \<and> 
                       (v1, v2) \<in> the (rc v)"
          from this 
          have v_in_l: "v \<in> \<Union> (set l)"
            using rx1 rx1sub by blast
          from ppr3 have ppr3': "(v1,v2) \<in> the (rc v)" by auto

          from p2 have "acyclic rc l"
            using acyclic_l by blast
          from this v_in_l ppr3'
          have "{v1,v2} \<subseteq> \<Union> (set l)"
            apply (induction l)
             apply simp
          proof -
            fix a l
            assume pre1: "(Forward_Analysis.acyclic rc l \<Longrightarrow>
            v \<in> \<Union> (set l) \<Longrightarrow> (v1, v2) \<in> the (rc v) \<Longrightarrow> {v1, v2} \<subseteq> \<Union> (set l))"
               and pre2: "Forward_Analysis.acyclic rc (a # l)"
               and pre3: "v \<in> \<Union> (set (a # l))" and
                   pre4: "(v1, v2) \<in> the (rc v)"
            show "{v1, v2} \<subseteq> \<Union> (set (a # l))"
            proof (cases "v \<notin> a")
              case True
              from pre2 have pre2': "acyclic rc l" 
                using acyclic_tail by blast
              from True pre3 have "v \<in> \<Union> (set l)" by fastforce
              from pre1 show ?thesis
                by (meson Union_mono \<open>v \<in> \<Union> (set l)\<close> pre2' pre4 set_subset_Cons subset_iff)
            next  
              case False
              from this pre2 acyclic.simps
              show ?thesis 
                by (metis Int_empty_right acyclic_dep1 inf.absorb_iff2 insert_subset ppr3 pre3)
            qed qed
            from this su1  rx1 rx1sub cce1
  show "\<exists>w w1 w2.
          w1 = ag2 v1 \<and>
          w2 = ag2 v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2))"
    by (metis (full_types) \<open>w1' = ag2 x1 \<and> sat_pred_ass (reachable_set (rc |` \<Union> (set l)) x1) (rc |` \<Union> (set l)) (rm |` (S - a)) ag2\<close> acyclic_dep1 acyclic_l ppr3 sat_pred_ass_def sat_pred_ass_sub)
qed qed


      from w1w2' w2x2 ww1w2 imp rx1 rx2 ppr1
      have "x2 \<in> \<Union> (set l) \<and> w2' \<in> \<L> (the ((rm' |` (S - a)) x2)) \<longrightarrow>
          (\<exists>ag. w2' = ag x2 \<and>
                sat_pred_ass (reachable_set (rc |` \<Union> (set l)) x2) (rc |` \<Union> (set l))
                 (rm |` (S - a)) ag)"
        by blast
      from this w2x2 ppr1
      have exisag1: "(\<exists>ag. w2' = ag x2 \<and>
                sat_pred_ass (reachable_set (rc |` \<Union> (set l)) x2) (rc |` \<Union> (set l))
                 (rm |` (S - a)) ag)"
        by blast

      from reachable_subl[of x2 l rc]
      have rx1sub: "reachable_set (rc |` \<Union> (set l)) x2 \<subseteq> \<Union> (set l)"
        using b1 p2 p3 ppr1 by blast

      from exisag1 rx2 this cce1
      obtain ag3 where "w2' = ag3 x2 \<and>
         sat_pred_ass (reachable_set (rc |` \<Union> (set l)) x2) (rc |` \<Union> (set l))
          (rm |` (S - a)) ag3"
        by auto

     from this 
      have
      hop2: "w2' = ag3 x2 \<and>
                sat_pred_ass (reachable_set (rc) x2) (rc)
                 (rm) ag3" 
        unfolding sat_pred_ass_def
        apply (rule_tac conjI)
        apply simp[1]
        apply (rule_tac conjI)
        using rx1 rx1sub cce1
        apply fastforce
        apply (rule_tac conjI)
        using rx2 rx1sub cce1
        apply fastforce
        using rx1 rx1sub cce1
      proof -
        assume ppr2: "w2' = ag3 x2 \<and>
    (\<forall>v\<in>reachable_set (rc |` \<Union> (set l)) x2. \<exists>w. w = ag3 v) \<and>
    (\<forall>v w. v \<in> reachable_set (rc |` \<Union> (set l)) x2 \<and> w = ag3 v \<longrightarrow>
           w \<in> \<L> (the ((rm |` (S - a)) v))) \<and>
    (\<forall>v1 v2 v.
        v \<in> dom (rc |` \<Union> (set l)) \<and>
        v \<in> reachable_set (rc |` \<Union> (set l)) x2 \<and>
        (v1, v2) \<in> the ((rc |` \<Union> (set l)) v) \<longrightarrow>
        (\<exists>w w1 w2.
            w1 = ag3 v1 \<and>
            w2 = ag3 v2 \<and>
            w = w1 @ w2 \<and>
            w1 \<in> \<L> (the ((rm |` (S - a)) v1)) \<and> w2 \<in> \<L> (the ((rm |` (S - a)) v2))))"
        from this 
        have su1: "(\<forall>v1 v2 v.
        v \<in> dom (rc |` \<Union> (set l)) \<and>
        v \<in> reachable_set (rc |` \<Union> (set l)) x2 \<and>
        (v1, v2) \<in> the ((rc |` \<Union> (set l)) v) \<longrightarrow>
        (\<exists>w w1 w2.
            w1 = ag3 v1 \<and>
            w2 = ag3 v2 \<and>
            w = w1 @ w2 \<and>
            w1 \<in> \<L> (the ((rm |` (S - a)) v1)) \<and> w2 \<in> \<L> (the ((rm |` (S - a)) v2))))"
          by blast
        show "\<forall>v1 v2 v.
       v \<in> dom rc \<and> v \<in> reachable_set rc x2 \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
       (\<exists>w w1 w2.
           w1 = ag3 v1 \<and>
           w2 = ag3 v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2)))"
          apply (rule allI)+
        proof fix v1 v2 v
          assume ppr3: "v \<in> dom rc \<and> v \<in> reachable_set rc x2 \<and> 
                       (v1, v2) \<in> the (rc v)"
          from this 
          have v_in_l: "v \<in> \<Union> (set l)"
            using rx2 rx1sub by blast
          from ppr3 have ppr3': "(v1,v2) \<in> the (rc v)" by auto

          from p2 have "acyclic rc l"
            using acyclic_l by blast
          from this v_in_l ppr3'
          have "{v1,v2} \<subseteq> \<Union> (set l)"
            apply (induction l)
             apply simp
          proof -
            fix a l
            assume pre1: "(Forward_Analysis.acyclic rc l \<Longrightarrow>
            v \<in> \<Union> (set l) \<Longrightarrow> (v1, v2) \<in> the (rc v) \<Longrightarrow> {v1, v2} \<subseteq> \<Union> (set l))"
               and pre2: "Forward_Analysis.acyclic rc (a # l)"
               and pre3: "v \<in> \<Union> (set (a # l))" and
                   pre4: "(v1, v2) \<in> the (rc v)"
            show "{v1, v2} \<subseteq> \<Union> (set (a # l))"
            proof (cases "v \<notin> a")
              case True
              from pre2 have pre2': "acyclic rc l" 
                using acyclic_tail by blast
              from True pre3 have "v \<in> \<Union> (set l)" by fastforce
              from pre1 show ?thesis
                by (meson Union_mono \<open>v \<in> \<Union> (set l)\<close> pre2' pre4 set_subset_Cons subset_iff)
            next  
              case False
              from this pre2 acyclic.simps
              show ?thesis 
                by (metis Int_empty_right acyclic_dep1 inf.absorb_iff2 insert_subset ppr3 pre3)
            qed qed
            from this su1  rx2 rx1sub cce1 ppr3
  show "\<exists>w w1 w2.
          w1 = ag3 v1 \<and>
          w2 = ag3 v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2))"
    by fastforce
  qed qed

      from reachable_set_l.simps(2)
      have hop3: "reachable_set_l rc ((x1,x2) # lrc) = 
                    reachable_set rc x1 \<union> reachable_set rc x2 \<union>
                    reachable_set_l rc lrc"
        by simp

 let ?ag = "override_on (override_on ag1 ag2 (reachable_set rc x1)) ag3 
               (reachable_set rc x2)"

  from reachable_set_closure[of _ rc x1] have
       reachable_set_closure': "(\<forall>v v1 v2.
        v \<in> dom rc \<and> v \<in> reachable_set rc x1 \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
        v1 \<in> reachable_set rc x1 \<and> v2 \<in> reachable_set rc x1)" by fastforce
  from reachable_set_l_closure[of _ rc lrc] have 
      reachable_set_l_closure': "(\<forall>v v1 v2.
        v \<in> dom rc \<and> v \<in> reachable_set_l rc lrc \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
        v1 \<in> reachable_set_l rc lrc \<and> v2 \<in> reachable_set_l rc lrc)" by fastforce

  from ho1 hop1 hop2 hop3 hop4 hop5 hop6 hop7 
       sat_pred_ass_com[of "reachable_set_l rc lrc" "reachable_set rc x1"  rc rm 
       ag1 ag2] reachable_set_closure'
       reachable_set_l_closure'
  have sat_pred_ass1: "sat_pred_ass (reachable_set rc x1 \<union> reachable_set_l rc lrc) rc rm 
        ((override_on ag1 ag2 (reachable_set rc x1)))" 
    using Un_commute inf_commute 
    by (metis (no_types, lifting) sat_pred_ass_com)

  from reachable_set_closure[of _ rc x2]
  have reachable_set_closure_x2: "(\<forall>v v1 v2.
        v \<in> dom rc \<and> v \<in> reachable_set rc x2 \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
        v1 \<in> reachable_set rc x2 \<and> v2 \<in> reachable_set rc x2)"
    by fastforce

  from reachable_set_closure[of _ rc x1] reachable_set_l_closure[of _ rc lrc]
  have reachable_setl_closure: "(\<forall>v v1 v2.
        v \<in> dom rc \<and>
        v \<in> reachable_set rc x1 \<union> reachable_set_l rc lrc \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
        v1 \<in> reachable_set rc x1 \<union> reachable_set_l rc lrc \<and>
        v2 \<in> reachable_set rc x1 \<union> reachable_set_l rc lrc)"
    by blast

  have empty: "(reachable_set rc x1 \<union> reachable_set_l rc lrc) \<inter> reachable_set rc x2 = {}"
    using hop4 hop6 by auto

  have "(reachable_set rc x1 \<union> reachable_set_l rc lrc \<union> reachable_set rc x2) =
        (reachable_set rc x2 \<union> (reachable_set rc x1 \<union> reachable_set_l rc lrc))"
    by blast

  from empty sat_pred_ass1 ho1 hop1 hop2 hop3 hop4 hop5 hop6 hop7 this 
       sat_pred_ass_com[of  
          "(reachable_set rc x1 \<union> reachable_set_l rc lrc)" 
          "reachable_set rc x2"
          rc rm "override_on ag1 ag2 (reachable_set rc x1)"
          ag3
          ] reachable_set_closure_x2 reachable_setl_closure
  have "sat_pred_ass (reachable_set rc x2 \<union> 
     (reachable_set rc x1 \<union> reachable_set_l rc lrc))
     rc rm 
     (override_on(override_on ag1 ag2 (reachable_set rc x1)) ag3 (reachable_set rc x2))"
    by fastforce
  from this hop3 hop4 hop5 hop6 hop7
  have re1: "sat_pred_ass (reachable_set_l rc ((x1,x2) # lrc)) rc rm ?ag"
    by (simp add: inf_sup_aci(7) sup.commute)

  from hop2 hop3 hop4 hop5
  have sss0: "\<forall> v \<in> (reachable_set rc x1). ?ag v = ag2 v"
    by fastforce

   from hop2 hop3 hop4 hop5
  have ss1: "\<forall> v \<in> (reachable_set rc x2). ?ag v = ag3 v"
    by fastforce

 from hop2 hop3 hop4 hop5
  have ss2: "\<forall> v \<in> (reachable_set_l rc lrc). ?ag v = ag1 v"
    by (metis Int_iff empty_iff hop6 override_on_apply_notin)

  from reachable_set_def reachable_set_l.simps
  have sss4: "x1 \<in> (reachable_set rc x1) \<and>
              x2 \<in> (reachable_set rc x2) \<and>
              (\<forall> (v1,v2) \<in> set lrc. v1 \<in> (reachable_set_l rc lrc)
                                  \<and> v2 \<in> (reachable_set_l rc lrc))" 
    apply (rule_tac conjI)
    apply fastforce
    apply (rule_tac conjI)
    apply fastforce
  proof -
    assume pq1: "(\<And>rc v.
        reachable_set rc v = {v'. \<exists>l. reachable rc (v # l) \<and> last (v # l) = v'})" 
    have "\<And> v1 v2. (v1, v2)\<in>set lrc \<longrightarrow> 
            v1 \<in> reachable_set_l rc lrc \<and> v2 \<in> reachable_set_l rc lrc"
    proof 
      fix v1 v2
      assume pq2: "(v1, v2) \<in> set lrc"
      from pq2
      show "v1 \<in> reachable_set_l rc lrc \<and> v2 \<in> reachable_set_l rc lrc"
        apply (induction lrc)
        apply fastforce
      proof -
        fix a lrc 
        assume pq3: " ((v1, v2) \<in> set lrc \<Longrightarrow>
        v1 \<in> reachable_set_l rc lrc \<and> v2 \<in> reachable_set_l rc lrc)" and
          pq4: "(v1, v2) \<in> set (a # lrc)"
        show  "v1 \<in> reachable_set_l rc (a # lrc) \<and> 
               v2 \<in> reachable_set_l rc (a # lrc)"
        proof (cases "(v1,v2) = a")
          case True
          from this reachable_set_l.simps(2)[of rc "fst a" "snd a" lrc] 
               reachable_set_def[of rc v1] reachable_set_def[of rc v2]
          show ?thesis by force
        next
          case False
          from this 
          have v1v2lrc: "(v1, v2) \<in> set lrc"
            using pq4 by auto
          from pq3[OF v1v2lrc] reachable_set_l.simps(2)
          show ?thesis 
            by (metis (full_types) UnCI old.prod.exhaust)
        qed qed qed
        from this 
        show "\<forall>(v1, v2)\<in>set lrc. v1 \<in> reachable_set_l rc lrc \<and> 
                                 v2 \<in> reachable_set_l rc lrc"
          by fastforce qed

  from ho1 hop1 hop2 hop3 hop4 hop5 hop6 hop7 sss0 ss1 ss2 sss4 imp1
  have sss3: "(\<forall>a\<in>set (lrc).
                case a of
                (v1, v2) \<Rightarrow>
                  w = ?ag v1 @ ?ag v2 \<and>
                  ?ag v1 \<in> \<L> (the (rm v1)) \<and> ?ag v2 \<in> \<L> (the (rm v2)))"
    using case_prodD case_prodI2
    by force

  from imp1 w1w2' hop1 hop2 have sss4: "
    ((case x of (v1, v2) \<Rightarrow>
                  w = ?ag v1 @ ?ag v2 \<and>
                  ?ag v1 \<in> \<L> (the (rm v1)) \<and> ?ag v2 \<in> \<L> (the (rm v2))))"
    by (simp add: \<open>w = w1' @ w2'\<close> \<open>x = (x1, x2)\<close> sat_pred_ass_def sss0 sss4)   
  from sss3 sss4 re1 hop3
  have "sat_pred_ass (reachable_set_l rc (x # lrc)) rc rm ?ag \<and>(\<forall>a\<in>set (x # lrc).
                case a of
                (v1, v2) \<Rightarrow>
                  w = ?ag v1 @ ?ag v2 \<and>
                  ?ag v1 \<in> \<L> (the (rm v1)) \<and> ?ag v2 \<in> \<L> (the (rm v2)))"
    using \<open>x = (x1, x2)\<close> by auto
  from this
  show " \<exists>ag. sat_pred_ass (reachable_set_l rc (x # lrc)) rc rm ag \<and>
            (\<forall>a\<in>set (x # lrc).
                case a of
                (v1, v2) \<Rightarrow>
                  w = ag v1 @ ag v2 \<and>
                  ag v1 \<in> \<L> (the (rm v1)) \<and> ag v2 \<in> \<L> (the (rm v2)))"
    by blast
} qed


  from reachable_set_l_correct lrc_OK2 lrc_OK3
  have tz1: "(reachable_set rc v) = (reachable_set_l rc lrc) \<union> {v} \<and>
        (v \<notin> reachable_set_l rc lrc)"
  proof (cases "v \<notin> dom rc")
    case True
    from this reachable_set_def 
    have "reachable_set rc v = {v}" 
      by (simp add: reachable_set_single)
    from lrc_OK3 True have "(reachable_set_l rc lrc) = {}"
      by simp
    then show ?thesis 
      using \<open>reachable_set rc v = {v}\<close> by blast
  next
    case False
    from this lrc_OK2 
    have lrcv: "set lrc = the (rc v)" by simp
    from lrcv show ?thesis 
    apply (rule_tac conjI)
    using reachable_set_l_correct[of v rc lrc] False lrcv
    apply fastforce
  proof -
    assume pv1: "set lrc = the (rc v)"
    from pv1
    have "set lrc \<subseteq>  the (rc v)" by auto
    from this
    show "v \<notin> reachable_set_l rc lrc"
      apply (induction lrc)
      apply simp
      apply (rename_tac aa lrc)
    proof -
      fix aa lrc
      assume pv2: "(set lrc \<subseteq> the (rc v) \<Longrightarrow> v \<notin> reachable_set_l rc lrc)"
         and pv3: "set (aa # lrc) \<subseteq> the (rc v)"
      show "v \<notin> reachable_set_l rc (aa # lrc)"
  proof (cases "v \<in> reachable_set_l rc [aa]")
    case True
    from this reachable_set_l.simps(2)[of rc "fst aa" "snd aa" "[]"] 
          reachable_set_l.simps(1)[of rc]
    have c1: "v \<in> reachable_set rc (fst aa) \<or> v \<in> reachable_set rc (snd aa)"
      by fastforce
    from pv3 have c2: "(fst aa, snd aa) \<in> the (rc v)"
      by simp
    from c1 c2 obtain a' where
    a'_def: "v \<in> reachable_set rc a' \<and> (\<exists> v1 v2. (v1,v2) \<in> the (rc v) \<and> 
                                          (a' = v1 \<or> a' = v2))"
      by fastforce
    from this reachable_set_def
    have "\<exists> ll. reachable rc (a'# ll) \<and> last (a' # ll) = v"
      by (simp add: reachable_set_def)
    from this obtain ll
      where "reachable rc (a'# ll) \<and> last (a' # ll) = v" by auto
    from this a'_def reachable.simps(3)[of rc]
    have c4: "reachable rc (v#a'#ll) \<and> last ((v#a'#ll)) = v"
      using False by auto
    from p2 nocycle[of v "a#l" rc]
    have "\<forall>m. \<not> reachable rc (v # m @ [v])"
      using p9 by blast
    from this c4 
    show ?thesis 
      by (metis \<open>reachable rc (a' # ll) \<and> last (a' # ll) = v\<close> append_butlast_last_id list.discI)
    
next
  case False
  from False reachable_set_l.simps(2)[of rc "fst aa" "snd aa" "[]"] 
        reachable_set_l.simps(1)[of rc]
  have c1: "v \<notin> reachable_set rc (fst aa) \<and> v \<notin> reachable_set rc (snd aa)"
    by fastforce
  from pv3 have "set (lrc) \<subseteq> the (rc v)"
    by simp
  from this pv2 have "v \<notin> reachable_set_l rc lrc" by simp
  from this False reachable_set_l.simps(2)[of rc "fst aa" "snd aa" lrc] c1
  show ?thesis by fastforce
qed qed qed qed

  from fsuc1 obtain ag
    where 
    fusc1: "sat_pred_ass (reachable_set_l rc lrc) rc rm ag \<and>
       (\<forall>(v1, v2)\<in>set lrc.
           w = ag v1 @ ag v2 \<and> ag v1 \<in> \<L> (the (rm v1)) \<and> ag v2 \<in> \<L> (the (rm v2)))"
    by auto

  from this p9 obtain ag'
    where "ag' = fun_upd ag v w" by auto

  from this fusc1 lrc_OK1 lrc_OK2
  have "w = ag' v \<and> sat_pred_ass (reachable_set rc v) rc rm ag'"
    apply (rule_tac conjI)
    apply simp
    unfolding sat_pred_ass_def
  proof -
    assume oi: "((\<forall>v\<in>reachable_set_l rc lrc. \<exists>w. w = ag v) \<and>
     (\<forall>v w. v \<in> reachable_set_l rc lrc \<and> w = ag v \<longrightarrow> w \<in> \<L> (the (rm v))) \<and>
     (\<forall>v1 v2 v.
         v \<in> dom rc \<and> v \<in> reachable_set_l rc lrc \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
         (\<exists>w w1 w2.
             w1 = ag v1 \<and>
             w2 = ag v2 \<and>
             w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2))))) \<and>
    (\<forall>(v1, v2)\<in>set lrc.
        w = ag v1 @ ag v2 \<and> ag v1 \<in> \<L> (the (rm v1)) \<and> ag v2 \<in> \<L> (the (rm v2)))"
    show "(\<forall>v\<in>reachable_set rc v. \<exists>w. w = ag' v) \<and>
    (\<forall>va w. va \<in> reachable_set rc v \<and> w = ag' va \<longrightarrow> w \<in> \<L> (the (rm va))) \<and>
    (\<forall>v1 v2 va.
        va \<in> dom rc \<and> va \<in> reachable_set rc v \<and> (v1, v2) \<in> the (rc va) \<longrightarrow>
        (\<exists>w w1 w2.
            w1 = ag' v1 \<and>
            w2 = ag' v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2))))"
      apply (rule conjI) +
      apply blast
      apply (rule conjI)
      apply (rule allI)+
      apply (rename_tac va w')
    proof 
      { fix va w'
        assume pp1: "va \<in> reachable_set rc v \<and> w' = ag' va"
        from pp1 tz1
        have "va = v \<or> va \<in> reachable_set_l rc lrc"
          by auto
        from p9
        have zz1: "va = v \<longrightarrow> w' \<in> \<L> (the (rm va))"
          using NFA_accept_alt_def \<open>ag' = ag(v := w)\<close> imp2' pp1 by auto
        from oi pp1
        have zz2: "va \<in> reachable_set_l rc lrc \<longrightarrow> w' \<in> \<L> (the (rm va))"
          using \<open>ag' = ag(v := w)\<close> zz1 by auto
        from zz1 zz2 pp1 show "w' \<in> \<L> (the (rm va))"
          using \<open>va = v \<or> va \<in> reachable_set_l rc lrc\<close> by blast
      }
      {
        show "\<forall>v1 v2 va.
       va \<in> dom rc \<and> va \<in> reachable_set rc v \<and> (v1, v2) \<in> the (rc va) \<longrightarrow>
       (\<exists>w w1 w2.
           w1 = ag' v1 \<and>
           w2 = ag' v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2)))"
          apply (rule allI)+
        proof 
          fix v1 v2 va
          assume pp1: "va \<in> dom rc \<and> va \<in> reachable_set rc v \<and> (v1, v2) \<in> the (rc va)"
          from this tz1 
          have "va = v \<or> va \<in> reachable_set_l rc lrc" 
            by auto
          from oi have
          "(\<forall>(v1, v2)\<in>set lrc. \<exists>w1 w2. w1 = ag v1 \<and> w2 = ag v2 \<and> w = w1 @ w2)"
            by auto
          from this oi lrc_OK1 lrc_OK2 pp1
          have "va \<in> reachable_set_l rc lrc \<longrightarrow> (\<exists>w w1 w2.
          w1 = ag' v1 \<and>
          w2 = ag' v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2)))"
            apply simp
            by (metis (full_types, hide_lams) \<L>_def \<open>ag' = ag(v := w)\<close> fun_upd_apply imp2' mem_Collect_eq)


     from oi lrc_OK1 lrc_OK2 pp1 imp1
         have "va = v \<longrightarrow> (\<exists>w w1 w2.
          w1 = ag' v1 \<and>
          w2 = ag' v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2)))"
           using \<open>\<And>w' va. va \<in> reachable_set rc v \<and> w' = ag' va \<Longrightarrow> w' \<in> \<L> (the (rm va))\<close> \<open>ag' = ag(v := w)\<close> case_prodD fun_upd_other
           by fastforce
         show "\<exists>w w1 w2.
          w1 = ag' v1 \<and>
          w2 = ag' v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2))" 
           using \<open>va = v \<longrightarrow> (\<exists>w w1 w2. w1 = ag' v1 \<and> w2 = ag' v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2)))\<close> \<open>va = v \<or> va \<in> reachable_set_l rc lrc\<close> \<open>va \<in> reachable_set_l rc lrc \<longrightarrow> (\<exists>w w1 w2. w1 = ag' v1 \<and> w2 = ag' v2 \<and> w = w1 @ w2 \<and> w1 \<in> \<L> (the (rm v1)) \<and> w2 \<in> \<L> (the (rm v2)))\<close> by blast
       qed 
    }qed qed
      
  from this
  show "\<exists>ag. w = ag v \<and> sat_pred_ass (reachable_set rc v) rc rm ag"
    by auto
qed qed qed }
qed


lemma Forward_analysis_complete:
  fixes rc :: "'a \<Rightarrow> ('a \<times> 'a) set option" and
        S  :: "'a set" and
        rm :: "'a \<Rightarrow> ('g :: NFA_states, 'h) NFA_rec option" and
        rm' :: "'a \<Rightarrow> ('g, 'h) NFA_rec option" and
        l :: "'a set list"
  assumes rm_v_OK: "\<And> v. v \<in> dom rm \<longrightarrow> NFA (the (rm v))"
      and rc_OK: "dom rc \<subseteq> S \<and> (\<forall> v \<in> S. v \<in> dom rc \<longrightarrow> finite (the (rc v)))" 
      and rm_OK: "S = dom rm" 
      and finite_S: "finite S"
      and S_not_all: "\<exists> v. v \<notin> S"
      and S_ok: "S \<noteq> {} \<and> S = \<Union> (set l) \<and> acyclic rc l \<and> uniq_indegree rc"
      and result_Ok: "forward_spec rm' S rc rm" 
    shows "(\<forall> v. v \<in> dom rm' \<longrightarrow> \<L> (the (rm' v)) \<noteq> {}) \<longrightarrow> 
           (\<exists> ag. sat_pred_ass S rc rm ag)"
proof -

  have S'_gen: "\<And> S l rc. finite S \<and>  S \<noteq> {} \<and> 
        S = \<Union> (set l) \<and> acyclic  rc l \<Longrightarrow> 
        (\<exists> S'. S' = {v. (v \<in> S) \<and> (\<nexists> v1 v2 v'. v' \<in> dom rc \<and> v' \<in> S \<and> 
                          (v1,v2) \<in> the (rc v') \<and>
                          (v = v1 \<or> v = v2))} \<and> S' \<noteq> {})"
  proof -
    fix S l rc
    assume S_ok': "finite S \<and> S \<noteq> {} \<and> S = \<Union> (set l) \<and> acyclic  rc l"
  from S_ok obtain S' where
  S'_def: "S' = {v. (v \<in> S) \<and> (\<nexists> v1 v2 v'. v' \<in> dom rc \<and> v' \<in> S \<and> (v1,v2) \<in> the (rc v') \<and>
                          (v = v1 \<or> v = v2))}"
    by blast
  from S_ok' 
  have "l \<noteq> [] \<and> (\<forall> s \<in> set l. finite s) \<and> (\<exists> s. s \<in> set l \<and> s \<noteq> {})"
    by (metis Sup_bot_conv(1) Sup_empty Sup_upper empty_set finite_subset)
  from this 
  have "\<exists>l1 a l2. l = l1 @ [a] @ l2 \<and> \<Union> (set l1) = {} \<and> a \<noteq> {}"
  proof - 
    assume p1: "l \<noteq> [] \<and> (\<forall>s\<in>set l. finite s) \<and> (\<exists>s. s \<in> set l \<and> s \<noteq> {})"
    from p1
    show "\<exists>l1 a l2. l = l1 @ [a] @ l2 \<and> \<Union> (set l1) = {} \<and> a \<noteq> {}" 
      apply (induction l)
      apply simp
    proof- 
      fix a l
      assume p2: "(l \<noteq> [] \<and> Ball (set l) finite \<and> (\<exists>s. s \<in> set l \<and> s \<noteq> {}) \<Longrightarrow>
            \<exists>l1 a l2. l = l1 @ [a] @ l2 \<and> \<Union> (set l1) = {} \<and> a \<noteq> {})"
         and p3: "a # l \<noteq> [] \<and> Ball (set (a # l)) finite \<and> 
                  (\<exists>s. s \<in> set (a # l) \<and> s \<noteq> {})"
      show " \<exists>l1 aa l2. a # l = l1 @ [aa] @ l2 \<and> \<Union> (set l1) = {} \<and> aa \<noteq> {}"
      proof (cases "a = {}")
        case True
        from this p3 have c1: "l \<noteq> []" by fastforce
        from p3 have c2: "Ball (set l) finite" by fastforce
        from p3 have c3: "(\<exists>s. s \<in> set l \<and> s \<noteq> {})"
          using True by auto
        from c1 c2 c3 p2 
        obtain l1 aa l2 where
        "l = l1 @ [aa] @ l2 \<and> \<Union> (set l1) = {} \<and> aa \<noteq> {}" 
          by blast
        from this True
        have "a # l = (a # l1) @ [aa] @ l2 \<and> \<Union> (set (a # l1)) = {} \<and> aa \<noteq> {}"
          by fastforce
then show ?thesis by blast
next
  case False
  from this p3 
  have "a # l = [] @ [a] @ l\<and> \<Union> (set []) = {} \<and> a \<noteq> {}"
    by fastforce
then show ?thesis by fastforce
qed qed qed
  from this obtain l1 a l2 where
  l1al2: "l = l1 @ [a] @ l2 \<and> \<Union> (set l1) = {} \<and> a \<noteq> {}" by auto
  have "a \<subseteq> S'"
  proof (rule ccontr)
    assume pp1: "\<not> a \<subseteq> S'"
    from S_ok'  l1al2
    have "a \<subseteq> S" 
      by (metis Sup_upper append_Cons in_set_conv_decomp)
    from this pp1 S'_def
    have dis: "\<exists> v. v \<in> a \<longrightarrow> 
          (\<exists> v1 v2 v'. v' \<in> dom rc \<and> v' \<in> S \<and> 
              (v1, v2) \<in> the (rc v') \<and> (v = v1 \<or> v = v2))"
      by blast
    from this obtain v where v_def: "v \<in> a \<and> 
    (\<exists> v1 v2 v'. v' \<in> dom rc \<and> v' \<in> S \<and> (v1, v2) \<in> the (rc v') \<and> (v = v1 \<or> v = v2))" 
      using S'_def \<open>a \<subseteq> S\<close> pp1 by blast
    from this dis obtain v1 v2 v' where
    c1: "v' \<in> dom rc \<and> v' \<in> S \<and> (v1, v2) \<in> the (rc v') \<and> (v = v1 \<or> v = v2)"
      by auto
    from this S_ok' l1al2
    have "v' \<in> \<Union> (set l)"
      by blast
    from l1al2 this have v'_a_l2: "v' \<in> \<Union> (set (a # l2))"
      by auto
    from l1al2 S_ok'
    have acyclic_a_l2: "acyclic rc (a # l2)"
      by (metis acyclic_divide append_Cons append_self_conv2)
    show "False"
    proof (cases "v' \<in> a")
    case True
    from this c1 v_def acyclic_a_l2 acyclic.simps 
    show ?thesis 
      by (metis Int_iff empty_iff)
    next
     case False
     from this v'_a_l2 
     have "v' \<in> \<Union> (set l2)"
       by fastforce
  from this c1 v_def acyclic_a_l2 acyclic.simps
  show ?thesis 
    by (metis acyclic_dep1 acyclic_tail disjoint_iff_not_equal)
qed qed

from this l1al2
  have S'_nempty: "S' \<noteq> {}"
    by auto
  from this S'_def show
  "\<exists>S'. S' =
            {v \<in> S.
             \<nexists>v1 v2 v'.
                v' \<in> dom rc \<and> v' \<in> S \<and> (v1, v2) \<in> the (rc v') \<and> (v = v1 \<or> v = v2)} \<and>
            S' \<noteq> {}"
    by auto
qed

  from rc_OK have dom_rc_S: "dom rc \<subseteq> S" by auto

  from  S_ok finite_S 
  have c1: "finite S \<and> S \<noteq> {} \<and> S = \<Union> (set l) \<and> acyclic rc l"
    by force
  from this S'_gen[of S l rc]
  have "\<exists>S'. S' =
         {v \<in> S.
          \<nexists>v1 v2 v'.
             v' \<in> dom rc \<and> v' \<in> S \<and> (v1, v2) \<in> the (rc v') \<and> (v = v1 \<or> v = v2)} \<and>
         S' \<noteq> {}"
    by blast
  from this obtain S' where
  S'_def: "S' =
         {v \<in> S.
          \<nexists>v1 v2 v'.
             v' \<in> dom rc \<and> v' \<in> S \<and> (v1, v2) \<in> the (rc v') \<and> (v = v1 \<or> v = v2)} \<and>
         S' \<noteq> {}"
    by blast

  from this c1 dom_rc_S
  have c1: "\<And> x. x \<in> S \<Longrightarrow> 
          (\<exists> x' l. reachable rc (x'# l) \<and> last (x' # l) = x \<and> x' \<in> S')"
    apply (induction l arbitrary: S S' rc)
    apply fastforce
  proof -
    fix a :: "'v set" 
    fix l :: "'v set list"
    fix x :: "'v"
    fix S :: "'v set" 
    fix S':: "'v set"
    fix rc:: "'v \<Rightarrow> ('v \<times> 'v) set option"
  assume
      pre1: "(\<And>x S S' rc.
           x \<in> S \<Longrightarrow>
           S' =
           {v \<in> S.
            \<nexists>v1 v2 v'.
               v' \<in> dom rc \<and> v' \<in> S \<and> (v1, v2) \<in> the (rc v') \<and> (v = v1 \<or> v = v2)} \<and>
           S' \<noteq> {} \<Longrightarrow>
           finite S \<and> S \<noteq> {} \<and> S = \<Union> (set l) \<and> Forward_Analysis.acyclic rc l \<Longrightarrow>
           dom rc \<subseteq> S \<Longrightarrow>
           \<exists>x' l. reachable rc (x' # l) \<and> last (x' # l) = x \<and> x' \<in> S')" and
      pre2: "S' =
       {v \<in> S.
        \<nexists>v1 v2 v'.
           v' \<in> dom rc \<and> v' \<in> S \<and> (v1, v2) \<in> the (rc v') \<and> (v = v1 \<or> v = v2)} 
          \<and> S' \<noteq> {}"
    and pre3: "finite S \<and>
       S \<noteq> {} \<and> S = \<Union> (set (a # l)) \<and> Forward_Analysis.acyclic rc (a # l)"
    and pre4: "x \<in> S" 
    and pre5: "dom rc \<subseteq> S"
  let ?S = "S - a"
      let ?rc = "rc |` (S - a)"
      from pre3 have Sal: "S = \<Union> (set (a # l))"
        by blast
      from pre3 acyclic.simps(2)[of rc a l]
      have aln: "(a \<inter> \<Union> (set l) = {})" by blast
      from this Sal
      have Su_def: "?S = \<Union> (set l)" by force
      from pre3
  have acyclic_l: "acyclic rc l"
    using acyclic_tail by blast
  have asubsetS': "a \<subseteq> S'"
    apply auto
    apply (rename_tac x1)
  proof -
      fix x1
      assume xa: "x1 \<in> a"
      from this Sal
      have x1S: "x1 \<in> S"  by force
      show "x1 \<in> S'"
      proof (rule ccontr)
        assume nxS': "x1 \<notin> S'"
        from this pre2 x1S
        have "\<exists> v1 v2 v'.
           v' \<in> dom rc \<and> v' \<in> S \<and> (v1, v2) \<in> the (rc v') \<and> (x1 = v1 \<or> x1 = v2)"
          by blast
        from this obtain v1 v2 v' where
        v1v2v': "v' \<in> dom rc \<and> v' \<in> S \<and> (v1, v2) \<in> the (rc v') \<and> (x1 = v1 \<or> x1 = v2)"
          by blast
        show "False"
        proof (cases "v' \<in> a")
          case True
          from this pre3 v1v2v'
          have "x1 \<in> \<Union> (set l)"
            by (meson acyclic.simps(2))
          from this xa aln 
          show ?thesis 
            by blast
next
  case False
  from pre3
  have "acyclic rc l"
    using acyclic_tail by blast
  from False
  have "v' \<in> \<Union> (set l)"
    using Su_def v1v2v' by auto
  from this acyclic_l v1v2v'
  have "x1 \<in> \<Union> (set l)"
    using acyclic_dep1 by blast
    from this show ?thesis 
      using Su_def xa by auto
qed qed qed

  show  "\<exists>x' l. reachable rc (x' # l) \<and> last (x' # l) = x \<and> x' \<in> S'"
    proof (cases "x \<in> a")
    case True
    from this asubsetS' pre2
    show ?thesis
      by (metis Collect_mem_eq last.simps reachable.simps(2) subset_Collect_conv)
    next
      case False
      from Su_def False have xsetl: "x \<in> \<Union> (set l)" 
        using pre4 by blast
      from pre3 this
      have c2: "finite (S - a) \<and> S - a \<noteq> {} \<and> 
            S - a = \<Union> (set l) \<and> Forward_Analysis.acyclic (rc |` \<Union> (set l)) l"
        by (metis Su_def acyclic_correct empty_iff finite_Diff)
      from this S'_gen[of ?S l "rc |` (\<Union> (set l))"]
      obtain S'' where
      S''_def: "S'' =
         {v \<in> S - a.
          \<nexists>v1 v2 v'.
             v' \<in> dom (rc |` \<Union> (set l)) \<and>
             v' \<in> S - a \<and> (v1, v2) \<in> the ((rc |` \<Union> (set l)) v') \<and> (v = v1 \<or> v = v2)} \<and>
         S'' \<noteq> {}"
        by blast
     have pre11: "x \<in> S - a"
       using Su_def xsetl by blast 
     have pre22: "dom (rc |` \<Union> (set l)) \<subseteq> S - a"
       by (simp add: Su_def)
     from 
     pre1[of x ?S S'' "rc |` (\<Union> (set l))", OF pre11 S''_def c2 pre22] 
     have 
     "\<exists>x' l'. reachable (rc |` \<Union> (set l)) (x' # l') \<and> last (x' # l') = x \<and> x' \<in> S''"
       by auto
     from this obtain x' l' 
     where 
     x'l'_def: 
     "reachable (rc |` \<Union> (set l)) (x' # l') \<and> last (x' # l') = x \<and> x' \<in> S''"
       by auto

     from x'l'_def 
       have "reachable (rc |` \<Union> (set l)) (x' # l') \<and> last (x' # l') = x"
         by auto
     from this
     have c5: "reachable rc (x' # l') \<and> last (x' # l') = x"
       apply (induction l' arbitrary: x')
       apply simp
     proof - 
       fix a l' x'
       assume pp1: "(\<And>x'. reachable (rc |` \<Union> (set l)) (x' # l') \<and> last (x' # l') = x \<Longrightarrow>
              reachable rc (x' # l') \<and> last (x' # l') = x)"
          and pp2: "reachable (rc |` \<Union> (set l)) (x' # a # l') \<and> last (x' # a # l') = x"

       from pp2 reachable.simps(3)[of "(rc |` \<Union> (set l))" x' a l']
       have 
       c4: "reachable (rc |` \<Union> (set l)) (a # l') \<and> last (a # l') = x"
         by force
       from pp1[OF c4]
       have "reachable rc (a # l') \<and> last (a # l') = x" by auto
       from this pp2 reachable.simps(3)[of rc x' a l'] 
            reachable.simps(3)[of "(rc |` \<Union> (set l))" x' a l']
       show "reachable rc (x' # a # l') \<and> last (x' # a # l') = x"
         by fastforce
     qed

     from c5 
     show ?thesis 
     proof (cases "x' \<in> S'")
       case True
       from this c5
       show ?thesis by blast
     next
       case False
       from x'l'_def
       have c6: "x' \<in> S''" by auto
       have "x' \<in> S - a"
         using S''_def x'l'_def by blast
       from this pre2 False 
       have "\<exists> v1 v2 v'.
        v' \<in> dom rc \<and>
        v' \<in> S \<and> (v1, v2) \<in> the (rc v') \<and> 
       (x' = v1 \<or> x' = v2)"
         by blast
       from this obtain v1 v2 v' where
       v1v2v':"v' \<in> dom rc \<and>
        v' \<in> S \<and> (v1, v2) \<in> the (rc v') \<and> 
       (x' = v1 \<or> x' = v2)"
         by auto
       have "v' \<in> a"
       proof (rule ccontr)
         assume ppp1: "v' \<notin> a"
         from this have c7: "v' \<in> \<Union> (set l)"
           using Su_def v1v2v' by auto
         have "x' \<in> \<Union> (set l)"
           using Su_def \<open>x' \<in> S - a\<close> by blast
         from v1v2v' c7 ppp1
         have c8: "v' \<in> dom (rc |` \<Union> (set l)) \<and> 
               v' \<in> S - a \<and> (v1, v2) \<in> the ((rc |` \<Union> (set l)) v') \<and> (x' = v1 \<or> x' = v2)"
           by auto
         from this c6 c7 S''_def Su_def
         have c9:
         "\<nexists>v1 v2 v'.
          v' \<in> dom (rc |` \<Union> (set l)) \<and>
          v' \<in> S - a \<and> (v1, v2) \<in> the ((rc |` \<Union> (set l)) v') \<and> (x' = v1 \<or> x' = v2)"
           by auto
         from c8 c9
         show False
           by fastforce
       qed
       from this c5 v1v2v' reachable.simps
       show ?thesis
         by (metis Diff_cancel Diff_eq_empty_iff asubsetS' insert_subset last_ConsR list.discI subset_antisym)
     qed
    qed
  qed

  have "S \<subseteq> \<Union> {s. \<exists>v \<in> S'. s = reachable_set rc v}"
    unfolding reachable_set_def
  proof 
    fix x
    assume "x \<in> S"
    from c1[of x] this
    have "\<exists>x' l. reachable rc (x' # l) \<and> last (x' # l) = x \<and> x' \<in> S'"
      by auto
    from this
    show "x \<in> \<Union> {s. \<exists>v\<in>S'. s = {v'. \<exists>l. reachable rc (v # l) \<and> last (v # l) = v'}}"
      by blast
  qed

  have lastS: "\<And> v1 l1. v1 \<in> S' \<and> reachable rc (v1 # l1) \<longrightarrow> last (v1 # l1) \<in> S"
    apply (rule_tac impI)
  proof -
    fix v1 l1
    assume pp1: "v1 \<in> S' \<and> reachable rc (v1 # l1)"

    from S'_def pp1
    have v1S: "v1 \<in> S \<and> reachable rc (v1 # l1)" by auto
    

    from S_ok
    have "S = \<Union> (set l) \<and> Forward_Analysis.acyclic rc l" by blast
    
    from this v1S
    show "last (v1 # l1) \<in> S"
      apply (induction l1 arbitrary: v1)
      apply (metis last.simps)
    proof -
      fix a l1 v1
      assume ppr1: "(\<And>v1. S = \<Union> (set l) \<and> Forward_Analysis.acyclic rc l \<Longrightarrow>
              v1 \<in> S \<and> reachable rc (v1 # l1) \<Longrightarrow> last (v1 # l1) \<in> S)"
      and ppr2: "S = \<Union> (set l) \<and> Forward_Analysis.acyclic rc l"
      and ppr3: "v1 \<in> S \<and> reachable rc (v1 # a # l1)"
      from ppr3 ppr2
      have "a \<in> S"
        by (metis acyclic_dep1 empty_iff insert_iff reachable.simps(3))
      from this ppr3 have
      "a \<in> S \<and> reachable rc (a # l1)"
        by auto
      from ppr1[OF ppr2, of a, OF this]
      show "last (v1 # a # l1) \<in> S"
        by auto
    qed qed
    have "\<Union> {s. \<exists>v \<in> S'. s = reachable_set rc v} \<subseteq> S"
    proof
      fix x
      assume ppp1: "x \<in> \<Union> {s. \<exists>v\<in>S'. s = reachable_set rc v}"
      from this 
      obtain v2 s where "s = (reachable_set rc v2) \<and> v2 \<in> S' \<and> x \<in> s"
        by blast
      from this reachable_set_def[of rc v2]
      obtain l2 
        where "reachable rc (v2 # l2) \<and> last (v2 # l2) = x"
        by blast
      from this lastS[of v2 l2]
      show "x \<in> S"
        using \<open>s = reachable_set rc v2 \<and> v2 \<in> S' \<and> x \<in> s\<close> by blast
    qed
    from this
    have key1: "S = \<Union> {s. \<exists>v\<in>S'. s = reachable_set rc v}"
      using \<open>S \<subseteq> \<Union> {s. \<exists>v\<in>S'. s = reachable_set rc v}\<close> by blast

    have key2: "\<And> v1 v2. v1 \<in> S' \<and> v2 \<in> S' \<and> v1 \<noteq> v2 \<longrightarrow> 
                   reachable_set rc v1 \<inter> reachable_set rc v2 = {}"
    proof 
      fix v1 v2
      assume pp1: "v1 \<in> S' \<and> v2 \<in> S' \<and> v1 \<noteq> v2"
      from S_not_all
      obtain v where v_def: "v \<notin> S" by auto
      let ?S = "{v} \<union> S"
      let ?l = "{v} # l"
      let ?rc = "fun_upd rc v (Some {(v1,v2)})"

      from v_def
      have rc_def: "(v \<in> dom ?rc \<and> the (?rc v) = {(v1,v2)}) \<and> 
               (\<forall> v \<in> S. v \<in> dom rc \<longrightarrow> 
                  (v \<in> dom ?rc \<and> the (?rc v) = the (rc v)))"
        apply (rule_tac conjI)
        apply simp
        by simp

      from pp1 S'_def
      have uniq_1: "\<nexists>v1' v2' v'. v' \<in> dom rc \<and> v' \<in> S \<and> 
            (v1', v2') \<in> the (rc v') \<and> (v1 = v1' \<or> v1 = v2')"
        by blast

      from pp1 S'_def
      have uniq_2: "\<nexists>v1' v2' v'. v' \<in> dom rc \<and> v' \<in> S \<and> 
            (v1', v2') \<in> the (rc v') \<and> (v2 = v1' \<or> v2 = v2')"
        by blast

      from S_ok
      have uniq_rc: "uniq_indegree rc" by blast
      from this uniq_1 uniq_2 rc_def pp1
      have uniq_indegree_rc_p: "uniq_indegree ?rc"
        unfolding uniq_indegree_def
        apply (rule_tac conjI)
        apply (metis domD domI fun_upd_apply mk_disjoint_insert prod.inject singleton_insert_inj_eq')
        apply (rule_tac conjI)
        apply (rule_tac allI)+
      proof -
        {fix v1a v2a v3 v4 va
         show "va \<in> dom (rc(v \<mapsto> {(v1, v2)})) \<and>
               (v1a, v2a) \<in> the ((rc(v \<mapsto> {(v1, v2)})) va) \<and>
               (v3, v4) \<in> the ((rc(v \<mapsto> {(v1, v2)})) va) \<and> (v1a, v2a) \<noteq> (v3, v4) \<longrightarrow>
               {v1a, v2a} \<inter> {v3, v4} = {}"
         proof (cases "va = v")
          case True
          then show ?thesis 
            by auto
          next
          case False
          from this v_def rc_OK uniq_rc rc_def
          show ?thesis 
            unfolding uniq_indegree_def
            by (metis (mono_tags, lifting) domD domI fun_upd_apply)
        qed      
      }
      {
       show "\<nexists>va v' v1a v2a v3 v4.
        va \<in> dom (rc(v \<mapsto> {(v1, v2)})) \<and>
        v' \<in> dom (rc(v \<mapsto> {(v1, v2)})) \<and>
        va \<noteq> v' \<and>
        (v1a, v2a) \<in> the ((rc(v \<mapsto> {(v1, v2)})) va) \<and>
        (v3, v4) \<in> the ((rc(v \<mapsto> {(v1, v2)})) v') \<and> {v1a, v2a} \<inter> {v3, v4} \<noteq> {}"
       proof (rule ccontr, simp)
         assume p1: "\<exists>va. (va = v \<or> va \<in> dom rc) \<and>
         (\<exists>v'. (v' = v \<or> v' \<in> dom rc) \<and>
               va \<noteq> v' \<and>
               (\<exists>v1a v2a.
                   (v1a, v2a) \<in> the (if va = v then Some {(v1, v2)} else rc va) \<and>
                   (\<exists>v3 v4.
                       (v3, v4) \<in> the (if v' = v then Some {(v1, v2)} else rc v') \<and>
                       (v3 = v1a \<or> v3 = v2a \<or> v4 = v1a \<or> v4 = v2a))))"
         from this
         obtain va v' v1a v2a v3 v4
         where c1: "(va = v \<or> va \<in> dom rc) \<and>
         (v' = v \<or> v' \<in> dom rc) \<and>
               va \<noteq> v' \<and>
               (v1a, v2a) \<in> the (if va = v then Some {(v1, v2)} else rc va) \<and>
               (v3, v4) \<in> the (if v' = v then Some {(v1, v2)} else rc v') \<and>
               (v3 = v1a \<or> v3 = v2a \<or> v4 = v1a \<or> v4 = v2a)"
           by blast
         from this have c2: "(va = v \<or> va \<in> dom rc) \<and>
         (v' = v \<or> v' \<in> dom rc)"
           by auto
         show False
         proof (cases "va \<noteq> v \<and> v' \<noteq> v")
           case True
           from this c2 
           have c3: "va \<in> dom rc \<and> v' \<in> dom rc"
             by auto
           from this True have 
           "(va \<in> dom rc) \<and>
            (v' \<in> dom rc) \<and>
               va \<noteq> v' \<and>
               (v1a, v2a) \<in> the (rc va) \<and>
               (v3, v4) \<in> the (rc v') \<and>
               (v3 = v1a \<or> v3 = v2a \<or> v4 = v1a \<or> v4 = v2a)"
             using c1 by auto
           from this c3 True uniq_rc
           show ?thesis 
             unfolding uniq_indegree_def
             by blast
         next
           case False note case0 = this
           from this have vav': 
           "va = v \<or> v' = v" by auto
           from this uniq_1 uniq_2 rc_def c1
           show ?thesis 
           proof (cases "va = v \<and> v' \<in> dom rc")
             case True
             from this uniq_1 uniq_2 rc_def c1
             have cc1: "\<nexists>v1' v2'.
                   v' \<in> dom rc \<and> v' \<in> S \<and> (v1', v2') \<in> the (rc v') \<and> 
                  (v1 = v1' \<or> v1 = v2')" by auto
            from this uniq_1 uniq_2 rc_def c1
             have cc2: "\<nexists>v1' v2'.
                   va \<in> dom rc \<and> va \<in> S \<and> (v1', v2') \<in> the (rc va) \<and> 
                  (v1 = v1' \<or> v1 = v2')" by auto
            from cc1 cc2 True rc_def c1
            show ?thesis 
            proof -
              have f1: "(v3, v4) \<in> the (rc v')"
                using True c1 by presburger
              have "(v1a, v2a) = (v1, v2)"
                using True c1 by auto
              then show ?thesis
                using f1 by (metis (no_types) Pair_inject True c1 cc1 dom_rc_S subsetD uniq_2)
            qed
            next
              case False note case1 = this
              then show ?thesis 
              proof (cases "va = v \<and> v' = v")
                case True
                from this c1 
                show ?thesis 
                  by simp
              next
                case False 
                from this case1 case0
                have vav': "va \<in> dom rc \<and> v' = v"
                  using c2 by blast
                from this uniq_1 uniq_2 rc_def c1
                have cc1: "\<nexists>v1' v2'.
                   va \<in> dom rc \<and> va \<in> S \<and> (v1', v2') \<in> the (rc va) \<and> 
                  (v1 = v1' \<or> v1 = v2')" by auto
                from this uniq_1 uniq_2 rc_def c1
                have cc2: "\<nexists>v1' v2'.
                   va \<in> dom rc \<and> va \<in> S \<and> (v1', v2') \<in> the (rc va) \<and> 
                  (v2 = v1' \<or> v2 = v2')" by auto
            from cc1 cc2 vav' rc_def c1
            show ?thesis 
              using dom_rc_S by fastforce
              qed
          qed
         qed
       qed 
     }qed



    from S_ok
    have  "S = \<Union> (set l) \<and> acyclic rc l"
      by blast
    from this rc_def v_def
    have "Forward_Analysis.acyclic ?rc l"
      apply (induction l arbitrary: S)
      using acyclic.simps(1) apply blast
    proof -
      fix a l S
      assume pp1: "(\<And>S. S = \<Union> (set l) \<and> Forward_Analysis.acyclic rc l \<Longrightarrow>
             (v \<in> dom (rc(v \<mapsto> {(v1, v2)})) \<and>
              the ((rc(v \<mapsto> {(v1, v2)})) v) = {(v1, v2)}) \<and>
             (\<forall>va\<in>S.
                 va \<in> dom rc \<longrightarrow>
                 va \<in> dom (rc(v \<mapsto> {(v1, v2)})) \<and>
                 the ((rc(v \<mapsto> {(v1, v2)})) va) = the (rc va)) \<Longrightarrow>
             v \<notin> S \<Longrightarrow> Forward_Analysis.acyclic (rc(v \<mapsto> {(v1, v2)})) l)"
        and pp2: "S = \<Union> (set (a # l)) \<and> Forward_Analysis.acyclic rc (a # l)" 
        and pp3: "(v \<in> dom (rc(v \<mapsto> {(v1, v2)})) \<and> the ((rc(v \<mapsto> {(v1, v2)})) v) = {(v1, v2)}) \<and>
       (\<forall>va\<in>S.
           va \<in> dom rc \<longrightarrow>
           va \<in> dom (rc(v \<mapsto> {(v1, v2)})) \<and>
           the ((rc(v \<mapsto> {(v1, v2)})) va) = the (rc va))"
        and pp4: "v \<notin> S"
      from pp2
      have cs1: "a \<inter> \<Union> (set l) = {}"
        by (meson acyclic.simps(2))

      from pp2 pp3 pp4
      have "v \<notin> a"
        by (meson Union_iff list.set_intros(1))

      from this pp2 pp3 pp4 acyclic.simps(2)[of rc a l]
      have cs2: "(\<forall>v1 v2 v.
       v \<in> a \<and> v \<in> dom ?rc \<and> (v1, v2) \<in> the (?rc v) \<longrightarrow>
       v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))"
        by (metis (mono_tags, lifting) domD domI fun_upd_apply)

      let ?S' = "S - a"
      

      from pp2 pp3 acyclic.simps(2)[of rc a l] 
      have "S = \<Union> (set (a # l)) \<and> a \<inter> \<Union> (set l) = {}" by blast
      from this 
      have "S - a = \<Union> (set l)" by force
      from this pp2 pp3 acyclic.simps(2)[of rc a l] acyclic_tail[of rc a l]
      have cc1: "S - a = \<Union> (set l) \<and> Forward_Analysis.acyclic rc l"
        by blast
   from pp3
   have cc2: "(v \<in> dom (rc(v \<mapsto> {(v1, v2)})) \<and> the ((rc(v \<mapsto> {(v1, v2)})) v) = {(v1, v2)}) \<and>
(\<forall>va\<in>S - a.
    va \<in> dom rc \<longrightarrow>
    va \<in> dom (rc(v \<mapsto> {(v1, v2)})) \<and> the ((rc(v \<mapsto> {(v1, v2)})) va) = the (rc va))"
     by blast

   from pp4 have cc3: "v \<notin> S - a" by auto

   from cc1 cc2 cc3 pp1[of ?S']
   have "acyclic (rc(v \<mapsto> {(v1, v2)})) l" by blast
   from this have "acyclic (rc(v \<mapsto> {(v1, v2)}) |` \<Union> (set l)) l"
     by (metis acyclic_correct cc1 cc3 pp2 restrict_fun_upd)
   from this acyclic.simps(2)[of "rc(v \<mapsto> {(v1, v2)})" a l] cs1 cs2
      show "acyclic (rc(v \<mapsto> {(v1, v2)})) (a # l)"
        by blast
    qed 

    from this acyclic_eq acyclicc_eq
    have forwardanaly: "Forward_Analysis.acyclic (rc(v \<mapsto> {(v1, v2)}) |` (\<Union> (set l))) l"
      by blast
    have vl: "{v} \<inter> \<Union> (set l) = {}"
      using S_ok v_def by blast
    from pp1 S'_def
    have "v1 \<in> S \<and> v2 \<in> S"
      by fastforce
    from S_ok this
    have "(\<forall>v1a v2a va.
         va \<in> {v} \<and>
         va \<in> dom (rc(v \<mapsto> {(v1, v2)})) \<and>
         (v1a, v2a) \<in> the ((rc(v \<mapsto> {(v1, v2)})) va) \<longrightarrow>
         v1a \<in> \<Union> (set l) \<and> v2a \<in> \<Union> (set l))"
      by (simp add: \<open>S \<noteq> {} \<and> S = \<Union> (set l) \<and> Forward_Analysis.acyclic rc l \<and> uniq_indegree rc\<close>)
   from this vl forwardanaly acyclic.simps(2)[of "rc(v \<mapsto> {(v1, v2)})" "{v}" l] 
    have acyclic_v_l: "acyclic (rc(v \<mapsto> {(v1, v2)})) ({v} # l)"
      by blast

    from this 
         distjoint_subtree_reachable[of "rc(v \<mapsto> {(v1, v2)})", 
         OF uniq_indegree_rc_p] acyclic_v_l 
            child_set_def[of "rc(v \<mapsto> {(v1, v2)})" v]

    have tmp1: "
       v1 \<noteq> v2 \<and>
       {v1, v2} \<subseteq> child_set (rc(v \<mapsto> {(v1, v2)})) v \<and>
       v \<in> \<Union> (set ({v} # l)) \<and> Forward_Analysis.acyclic (rc(v \<mapsto> {(v1, v2)})) ({v} # l) 
         \<longrightarrow>
       reachable_set (rc(v \<mapsto> {(v1, v2)})) v1 \<inter> reachable_set (rc(v \<mapsto> {(v1, v2)})) v2 =
       {}"
      by blast
    from child_set_def[of "(rc(v \<mapsto> {(v1, v2)}))" v] pp1
    have "{v1, v2} \<subseteq> child_set (rc(v \<mapsto> {(v1, v2)})) v \<and> v1 \<noteq> v2"
      by force

    from this tmp1 acyclic_v_l
    have reachable_disjoint: "reachable_set (rc(v \<mapsto> {(v1, v2)})) v1 \<inter> 
          reachable_set (rc(v \<mapsto> {(v1, v2)})) v2 = {}"
      by (meson UnionI list.set_intros(1) singletonI)

    let ?rc = "(rc(v \<mapsto> {(v1, v2)}))"


    have reachv1v2: "\<And> m v'. v' \<in> S \<Longrightarrow>
                 reachable rc (v' # m) = reachable (rc(v \<mapsto> {(v1, v2)})) (v' # m)"
    proof -
      fix m v'
      assume pt1: "v' \<in> S"
      from this
      show "reachable rc (v' # m) = reachable (rc(v \<mapsto> {(v1, v2)})) (v' # m)"
        apply (induction m arbitrary: v')
        apply simp
      proof -
        fix a m v'
        assume pt2: "(\<And>v'. v' \<in> S \<Longrightarrow>
                   reachable rc (v' # m) = reachable (rc(v \<mapsto> {(v1, v2)})) (v' # m))"
           and pt3: "v' \<in> S"
        from this 
        have "reachable rc (v' # a # m) \<Longrightarrow> 
                    reachable (rc(v \<mapsto> {(v1, v2)})) (v' # a # m)"
        proof -
          assume pt4: "reachable rc (v' # a # m)"
          from this reachable.simps S_ok 
          have "a \<in> S"
            by (metis acyclic_dep1 empty_iff insert_iff pt3)
          from this pt2 
          have "reachable rc (a # m) = reachable (rc(v \<mapsto> {(v1, v2)})) (a # m)"
            by auto
          from pt4  reachable.simps
          have "\<exists> v1 v2. (v1,v2) \<in> the (rc v') \<and> (a = v1 \<or> a = v2)"
            by simp
          from this rc_def pt3
          have "\<exists> v1 v2. (v1,v2) \<in> the (?rc v') \<and> (a = v1 \<or> a = v2)"
            using v_def by auto
          from this show "reachable (rc(v \<mapsto> {(v1, v2)})) (v' # a # m)"
            using \<open>reachable rc (a # m) = reachable (rc(v \<mapsto> {(v1, v2)})) (a # m)\<close> pt4 by auto
        qed

        have "reachable (rc(v \<mapsto> {(v1, v2)})) (v' # a # m) \<Longrightarrow>
              reachable rc (v' # a # m)"
        proof -
          assume pt4: "reachable ?rc (v' # a # m)"
          from this reachable.simps S_ok rc_def 
          have "a \<in> S"
            by (metis \<open>Forward_Analysis.acyclic (rc(v \<mapsto> {(v1, v2)})) l\<close> acyclic_dep1 empty_iff insert_iff pt3)
          from this pt2 
          have "reachable rc (a # m) = reachable (rc(v \<mapsto> {(v1, v2)})) (a # m)"
            by auto
          from pt4  reachable.simps
          have "\<exists> v1 v2. (v1,v2) \<in> the (?rc v') \<and> (a = v1 \<or> a = v2)"
            by simp
          from this rc_def pt3
          have "\<exists> v1 v2. (v1,v2) \<in> the (rc v') \<and> (a = v1 \<or> a = v2)"
            by (metis fun_upd_apply v_def)
          from this show "reachable rc (v' # a # m)"
            using \<open>reachable rc (a # m) = reachable (rc(v \<mapsto> {(v1, v2)})) (a # m)\<close> pt3 pt4 v_def by auto
        qed
        from this 
        show "reachable rc (v' # a # m) = reachable (rc(v \<mapsto> {(v1, v2)})) (v' # a # m)"
          using \<open>reachable rc (v' # a # m) \<Longrightarrow> reachable (rc(v \<mapsto> {(v1, v2)})) (v' # a # m)\<close> by linarith          
      qed qed
    from reachv1v2 
    have "\<And> m. reachable rc (v1 # m) \<longleftrightarrow> reachable (rc(v \<mapsto> {(v1, v2)})) (v1 # m)"
      using \<open>v1 \<in> S \<and> v2 \<in> S\<close> by blast
    from this 
    have reach_eq: "reachable_set (rc(v \<mapsto> {(v1, v2)})) v1 = reachable_set rc v1"
      unfolding reachable_set_def
      by blast


    from reachv1v2 
    have "\<And> m. reachable rc (v2 # m) \<longleftrightarrow> reachable (rc(v \<mapsto> {(v1, v2)})) (v2 # m)"
      using \<open>v1 \<in> S \<and> v2 \<in> S\<close> by blast

     from this 
    have "reachable_set (rc(v \<mapsto> {(v1, v2)})) v2 = reachable_set rc v2"
      unfolding reachable_set_def
      by blast

    from this reach_eq reachable_disjoint
    show "reachable_set rc v1 \<inter> reachable_set rc v2 = {}"
      by auto
  qed

  show "(\<forall>v. v \<in> dom rm' \<longrightarrow> \<L> (the (rm' v)) \<noteq> {}) \<longrightarrow> (\<exists>ag. sat_pred_ass S rc rm ag)"
    apply (rule impI)
  proof -
    assume p1: "\<forall>v. v \<in> dom rm' \<longrightarrow> \<L> (the (rm' v)) \<noteq> {}"
    from S'_def finite_S
    have "finite S'" by fastforce
    from this
    obtain ls where
    ls_def: "set ls = S' \<and> distinct ls"
      using finite_distinct_list by blast

    from S_ok
    have S_ok' : "S = \<Union> (set l) \<and> Forward_Analysis.acyclic rc l \<and> uniq_indegree rc"
      by blast
    from p1 Forward_analysis_complete_gen
        [OF rm_v_OK rc_OK rm_OK finite_S S_ok' result_Ok]
    have Srcrm: "(\<forall>v w. v \<in> S \<and> w \<in> \<L> (the (rm' v)) \<longrightarrow>
           (\<exists>ag. w = ag v \<and> sat_pred_ass (reachable_set rc v) rc rm ag))"
      by auto

    from S'_def result_Ok rm_OK
    have S'rm: "S' \<subseteq> dom rm'"
      unfolding forward_spec_def
      by auto
    from S_ok result_Ok
    have "uniq_indegree rc"
      by fastforce
    from this key1 key2 ls_def finite_S Srcrm S'rm
    show "\<exists>ag. sat_pred_ass S rc rm ag"
      apply (induction ls arbitrary: S S')
    proof -
    {
      fix Sa :: "'a set" and S'a :: "'a set"
      assume a1: "set [] = S'a \<and> distinct ([]::'a list)"
      assume a2: "Sa = \<Union> {s. \<exists>v\<in>S'a. s = reachable_set rc v}"
      have "\<exists>f. sat_pred_ass {} rc rm f"
        by (simp add: sat_pred_ass_def)
        then show "Ex (sat_pred_ass Sa rc rm)"
      using a2 a1 by simp
    }{
      fix a ls S S'
      assume ps1: "(\<And>S S'.
           uniq_indegree rc \<Longrightarrow>
           S = \<Union> {s. \<exists>v\<in>S'. s = reachable_set rc v} \<Longrightarrow>
           (\<And>v1 v2.
               v1 \<in> S' \<and> v2 \<in> S' \<and> v1 \<noteq> v2 \<longrightarrow>
               reachable_set rc v1 \<inter> reachable_set rc v2 = {}) \<Longrightarrow>
           set ls = S' \<and> distinct ls \<Longrightarrow>
           finite S \<Longrightarrow>
           \<forall>v w. v \<in> S \<and> w \<in> \<L> (the (rm' v)) \<longrightarrow>
                 (\<exists>ag. w = ag v \<and> sat_pred_ass (reachable_set rc v) rc rm ag) \<Longrightarrow>
           S' \<subseteq> dom rm' \<Longrightarrow> Ex (sat_pred_ass S rc rm))"
         and ps2: "uniq_indegree rc"
         and ps3: "S = \<Union> {s. \<exists>v\<in>S'. s = reachable_set rc v}"
         and ps4: "(\<And>v1 v2.
           v1 \<in> S' \<and> v2 \<in> S' \<and> v1 \<noteq> v2 \<longrightarrow>
           reachable_set rc v1 \<inter> reachable_set rc v2 = {})"
         and ps5: "set (a # ls) = S' \<and> distinct (a # ls)"
         and ps6: "finite S" 
         and ps7: " \<forall>v w. v \<in> S \<and> w \<in> \<L> (the (rm' v)) \<longrightarrow>
             (\<exists>ag. w = ag v \<and> sat_pred_ass (reachable_set rc v) rc rm ag)"
         and ps8: "S' \<subseteq> dom rm'"

      let ?S = "S - reachable_set rc a"
      let ?S' = "S' - {a}"

      from ps5 ps4
      have union: "reachable_set rc a \<inter> \<Union> {s. \<exists>v \<in> set ls. s = reachable_set rc v} = {}"
        apply (induction ls arbitrary: S')
        apply simp
      proof -
        fix aa ls S'
        assume pt1: "(\<And>S'. set (a # ls) = S' \<and> distinct (a # ls) \<Longrightarrow>
              (\<And>v1 v2.
                  v1 \<in> S' \<and> v2 \<in> S' \<and> v1 \<noteq> v2 \<longrightarrow>
                  reachable_set rc v1 \<inter> reachable_set rc v2 = {}) \<Longrightarrow>
              reachable_set rc a \<inter> \<Union> {s. \<exists>v\<in>set ls. s = reachable_set rc v} = {})"
           and pt2: "set (a # aa # ls) = S' \<and> distinct (a # aa # ls)"
           and pt3: "(\<And>v1 v2.
           v1 \<in> S' \<and> v2 \<in> S' \<and> v1 \<noteq> v2 \<longrightarrow>
           reachable_set rc v1 \<inter> reachable_set rc v2 = {})"

        have  "\<Union> {s. \<exists>v\<in>set (aa # ls). s = reachable_set rc v} = 
              \<Union> {s. \<exists>v\<in>set ls. s = reachable_set rc v} \<union> (reachable_set rc aa)"
          by auto

        let ?S'' = "S' - {aa}"
        from pt2
        have c1: "set (a # ls) = S' - {aa} \<and> distinct (a # ls)"
          by fastforce
      
        from pt1[of ?S'', OF c1] pt3
        have c2: "reachable_set rc a \<inter> \<Union> {s. \<exists>v\<in>set ls. s = reachable_set rc v} = {}"
          by simp
        from pt3 pt2
        have "reachable_set rc a \<inter> reachable_set rc aa = {}"
          by force
        from this c2
        show "reachable_set rc a \<inter> \<Union> {s. \<exists>v\<in>set (aa # ls). s = 
              reachable_set rc v} = {}"
          by auto
      qed
      from ps5
      have c3: "?S' = set ls \<and> S' = {a} \<union> set ls "
        by force
        

      from ps3 this
      have "\<Union> {s. \<exists>v\<in> set (a # ls). s = reachable_set rc v} = 
            \<Union> {s. \<exists>v\<in> set ls. s = reachable_set rc v} \<union> reachable_set rc a"
        by auto
      from this c3
      have "\<Union> {s. \<exists>v\<in> S'. s = reachable_set rc v} = 
            \<Union> {s. \<exists>v\<in> S' - {a}. s = reachable_set rc v} \<union> reachable_set rc a"
        by blast
      from ps3 ps4 union this c3
      have c4: "S - reachable_set rc a = \<Union> {s. \<exists>v\<in>S' - {a}. s = reachable_set rc v}"
        by blast

      from ps4 have c5: "(\<And>v1 v2.
      v1 \<in> S' - {a} \<and> v2 \<in> S' - {a} \<and> v1 \<noteq> v2 \<longrightarrow>
      reachable_set rc v1 \<inter> reachable_set rc v2 = {})"
        by fastforce

      from ps5 have c6: "set ls = S' - {a} \<and> distinct ls"
        by fastforce

      from ps6 have c7: "finite (S - reachable_set rc a)"
        by auto

      from ps7
      have c8: "\<forall>v w. v \<in> S - reachable_set rc a \<and> w \<in> \<L> (the (rm' v)) \<longrightarrow>
        (\<exists>ag. w = ag v \<and> sat_pred_ass (reachable_set rc v) rc rm ag)"
        by fastforce

      from ps8 have c9: "S' - {a} \<subseteq> dom rm'" 
        by auto
      from ps1[of ?S ?S', OF ps2 c4 c5 c6 c7 c8 c9]
      obtain ag where
      ag_def: "sat_pred_ass (S - reachable_set rc a) rc rm ag" by auto



      from p1 ps8 ps5 
      obtain wa where "wa \<in> \<L> (the (rm' a))"
        by fastforce
      from this ps7 ps5 
      obtain ag2 where
      ag2_def: "sat_pred_ass (reachable_set rc a) rc rm ag2"
        by (metis (no_types, lifting) DiffI Diff_eq_empty_iff Srcrm Un_iff \<open>\<Union> {s. \<exists>v\<in>S'. s = reachable_set rc v} = \<Union> {s. \<exists>v\<in>S' - {a}. s = reachable_set rc v} \<union> reachable_set rc a\<close> dom_rc_S insert_absorb insert_not_empty ps3 reachable_set_single singletonI)
      

      let ?S1 = "reachable_set rc a"
      let ?S2 = "S - reachable_set rc a"

      have cc1: "reachable_set rc a \<inter> (S - reachable_set rc a) = {}"
        by blast

      from reachable.simps
      have cc2: 
      "(\<forall>v v1 v2.
       v \<in> dom rc \<and> v \<in> reachable_set rc a \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
       v1 \<in> reachable_set rc a \<and> v2 \<in> reachable_set rc a)"
        unfolding reachable_set_def 
        by (metis reachable_set_closure reachable_set_def)

      thm ps3
      have cc3: 
      "(\<forall>v v1 v2.
        v \<in> dom rc \<and> v \<in> S - reachable_set rc a \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
        v1 \<in> S - reachable_set rc a \<and> v2 \<in> S - reachable_set rc a)"
        apply (rule allI impI)+
      proof -
        fix v v1 v2
        assume pr1: "v \<in> dom rc \<and> v \<in> S - reachable_set rc a \<and> (v1, v2) \<in> the (rc v)"

        from ps3 pr1 
        obtain b
          where b_def: "b \<in> S' \<and> v \<in> reachable_set rc b \<and> reachable_set rc b \<subseteq> S"
          by fastforce
        from this pr1 
        have "a \<noteq> b"
          by blast
        from this ps4 ps5 b_def
        have a_b_empty: "reachable_set rc a \<inter> reachable_set rc b = {}"
          by auto

        from reachable.simps
        have "(\<forall>v v1 v2.
       v \<in> dom rc \<and> v \<in> reachable_set rc b \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
       v1 \<in> reachable_set rc b \<and> v2 \<in> reachable_set rc b)"
          unfolding reachable_set_def
          by (metis reachable_set_closure reachable_set_def)
        from this a_b_empty b_def pr1
       show "v1 \<in> S - reachable_set rc a \<and> v2 \<in> S - reachable_set rc a"
         by blast
     qed


      from cc1 cc2 cc3 sat_pred_ass_com[of ?S1 ?S2 rc rm ag2 ag] ag_def ag2_def
      have 
      "sat_pred_ass (reachable_set rc a \<union> (S - reachable_set rc a)) rc rm
      (override_on ag2 ag (S - reachable_set rc a))"
        by blast
      from this
      show "Ex (sat_pred_ass S rc rm)"
        by (metis Un_commute \<open>\<Union> {s. \<exists>v\<in>S'. s = reachable_set rc v} = \<Union> {s. \<exists>v\<in>S' - {a}. s = reachable_set rc v} \<union> reachable_set rc a\<close> c4 ps3)
    }    
  qed qed qed


end














