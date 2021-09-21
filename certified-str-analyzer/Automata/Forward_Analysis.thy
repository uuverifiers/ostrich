
(*  
    Authors:     Shuanglong Kan <shuanglong@uni-kl.de>           
*)

theory Forward_Analysis

imports NFA_set

begin 



datatype 'v CONCAT_constr = 
         Sing_V 'v |
       Concat_V 'v "'v CONCAT_constr"



definition str_constr_sat :: "'v set \<Rightarrow> ('v \<Rightarrow> 'a list option) \<Rightarrow> 
                              ('v \<Rightarrow> (('q::NFA_states), 'a) NFA_rec option) \<Rightarrow>
                              ('v \<Rightarrow> ('v \<times> 'v) set option) \<Rightarrow>  bool" 
  where
  "str_constr_sat S rs rm rc \<equiv> 
   (\<forall> v \<in> S. NFA_accept (the (rm v)) (the (rs v))) \<and>
   (\<forall> v CS. v \<in> S  \<and> (rc v = Some CS) \<longrightarrow> 
                      (\<forall> v1 v2. (v1, v2) \<in> CS \<longrightarrow> 
                        ((the \<circ> rs) v) = (the (rs v1)) @ ((the \<circ> rs) v2)))"


definition compute_dependent_abstract where
  "compute_dependent_abstract v rc =
   (if ((rc v) \<noteq> None) then 
   FOREACHi (\<lambda> s1 s2. s2 = {v0 | v0 v1 v2. 
                              (v1, v2) \<in> (the (rc v) - s1) 
                               \<and> (v0 = v1 \<or> v0 = v2)}) 
           {e. e \<in> the (rc v)} 
           (\<lambda> (v1, v2) S. RETURN (S \<union> {v1, v2})) {}
    else 
        RETURN {}
    )"

fun acyclic where
    "acyclic rc [] = True"
  | "acyclic rc (a # l) = ((a \<inter> (\<Union> (set l)) = {}) \<and> 
              (\<forall> v1 v2 v. v \<in> a \<and> v \<in> dom rc \<and> (v1,v2)\<in> (the (rc v)) 
                  \<longrightarrow> v1 \<in> (\<Union> (set l)) \<and> v2 \<in> (\<Union> (set l))) \<and> 
                      (acyclic (rc |` (\<Union> (set l))) l))"

fun acyclicc where
    "acyclicc rc [] = True"
  | "acyclicc rc (a # l) = ((a \<inter> (\<Union> (set l)) = {}) \<and> 
              (\<forall> v1 v2 v. v \<in> a \<and> v \<in> dom rc \<and> (v1,v2)\<in> (the (rc v)) 
                  \<longrightarrow> v1 \<in> (\<Union> (set l)) \<and> v2 \<in> (\<Union> (set l))) \<and> 
                      (acyclicc rc l))"
lemma acyclic_eq:
      "acyclicc rc l = acyclicc (rc |` \<Union> (set l)) l"
  apply (induction l arbitrary: rc rule: acyclicc.induct)
  apply simp
proof -
  fix a :: "'a set" 
  fix l :: "'a set list" 
  fix rca
  assume p1 : "(\<And>rc. acyclicc rc l = acyclicc (rc |` \<Union> (set l)) l)"
  from p1 have "acyclicc (rca |` \<Union> (set (a # l))) l = 
                (acyclicc (rca |` \<Union> (set (a # l)) |` \<Union> (set l)) l)"
    by fastforce
  have "set l \<subseteq> set (a # l)" by fastforce
  from this
  have "(rca |` \<Union> (set (a # l)) |` \<Union> (set l)) = (rca |` \<Union> (set l))"
    by (metis Union_mono restrict_map_subset_eq)
  from this have c1: "acyclicc (rca |` \<Union> (set (a # l))) l = 
                (acyclicc (rca |` \<Union> (set l)) l)"
    using \<open>acyclicc (rca |` \<Union> (set (a # l))) l = acyclicc (rca |` \<Union> (set (a # l)) |` \<Union> (set l)) l\<close> by auto
  from p1 have "acyclicc rca l = acyclicc (rca |` \<Union> (set l)) l"
    by auto
  from this c1 have c2: "acyclicc rca l = acyclicc (rca |` \<Union> (set (a # l))) l"
    by auto
  have cc1: "acyclicc rca (a # l) = ((a \<inter> (\<Union> (set l)) = {}) \<and> 
              (\<forall> v1 v2 v. v \<in> a \<and> v \<in> dom rca \<and> (v1,v2)\<in> (the (rca v)) 
                  \<longrightarrow> v1 \<in> (\<Union> (set l)) \<and> v2 \<in> (\<Union> (set l))) \<and> 
                      (acyclicc rca l))"
    by simp
  let ?rca = "(rca |` \<Union> (set (a # l)))"
  have cc2: "acyclicc ?rca (a # l) = 
  ((a \<inter> (\<Union> (set l)) = {}) \<and> 
              (\<forall> v1 v2 v. v \<in> a \<and> v \<in> dom ?rca \<and> (v1,v2)\<in> (the (?rca v)) 
                  \<longrightarrow> v1 \<in> (\<Union> (set l)) \<and> v2 \<in> (\<Union> (set l))) \<and> 
                      (acyclicc ?rca l))"
    by simp

  have "((a \<inter> (\<Union> (set l)) = {}) \<and> 
              (\<forall> v1 v2 v. v \<in> a \<and> v \<in> dom rca \<and> (v1,v2)\<in> (the (rca v)) 
                  \<longrightarrow> v1 \<in> (\<Union> (set l)) \<and> v2 \<in> (\<Union> (set l)))) = 
        ((a \<inter> (\<Union> (set l)) = {}) \<and> 
              (\<forall> v1 v2 v. v \<in> a \<and> v \<in> dom ?rca \<and> (v1,v2)\<in> (the (?rca v)) 
                  \<longrightarrow> v1 \<in> (\<Union> (set l)) \<and> v2 \<in> (\<Union> (set l))))" 
  proof
    {
      assume p1: "a \<inter> \<Union> (set l) = {} \<and>
    (\<forall>v1 v2 v.
        v \<in> a \<and> v \<in> dom rca \<and> (v1, v2) \<in> the (rca v) \<longrightarrow>
        v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))" 
      from this 
      show "a \<inter> \<Union> (set l) = {} \<and>
    (\<forall>v1 v2 v.
        v \<in> a \<and>
        v \<in> dom (rca |` \<Union> (set (a # l))) \<and>
        (v1, v2) \<in> the ((rca |` \<Union> (set (a # l))) v) \<longrightarrow>
        v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))"
        apply simp
        by fastforce
    }
    {
      assume p1: "a \<inter> \<Union> (set l) = {} \<and>
    (\<forall>v1 v2 v.
        v \<in> a \<and>
        v \<in> dom (rca |` \<Union> (set (a # l))) \<and>
        (v1, v2) \<in> the ((rca |` \<Union> (set (a # l))) v) \<longrightarrow>
        v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))"
      from this 
      show " a \<inter> \<Union> (set l) = {} \<and>
    (\<forall>v1 v2 v.
        v \<in> a \<and> v \<in> dom rca \<and> (v1, v2) \<in> the (rca v) \<longrightarrow>
        v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))"
        by (metis Int_iff Union_iff dom_restrict list.set_intros(1) restrict_in)
    } qed

  from this cc1 cc2 c2 acyclicc.simps
  show "acyclicc rca (a # l) = acyclicc (rca |` \<Union> (set (a # l))) (a # l)"
    apply simp
    by blast
qed

lemma acyclic_correct [simp]: 
  "acyclic rc (a # l) \<longrightarrow> acyclic (rc |` (\<Union> (set l))) l"
  by simp

lemma acyclicc_correct: 
  "acyclicc rc (a # l) \<longrightarrow> acyclicc rc l"
  by fastforce

lemma acyclicc_eq: 
  "acyclicc rc l = acyclic rc l"
  apply (induction l rule: acyclic.induct)
  apply simp
proof -
  fix rc a l
  assume p1: "acyclicc (rc |` \<Union> (set l)) l = Forward_Analysis.acyclic (rc |` \<Union> (set l)) l"
  from p1 acyclic_eq
  have "acyclicc rc l = Forward_Analysis.acyclic (rc |` \<Union> (set l)) l"
    by blast
  from this acyclicc.simps acyclic.simps
  show "acyclicc rc (a # l) = Forward_Analysis.acyclic rc (a # l)"
    by force
qed

lemma acyclic_tail [simp]: 
  "acyclic rc (a # l) \<longrightarrow> acyclic rc l"
proof 
  assume p1 : "acyclic rc (a # l)"
  from this acyclicc_eq acyclicc_correct 
  have "acyclicc rc (a # l)" 
    by blast
  from this acyclicc_correct acyclicc_eq
  show "acyclic rc l" 
    by blast
qed

lemma acyclic_dep1 [simp]: 
  "acyclic rc l \<longrightarrow> 
    (\<forall> v v1 v2. v \<in> \<Union> (set l) \<and> v \<in> dom rc \<and> (v1,v2) \<in> the (rc v) \<longrightarrow> 
          v1 \<in> \<Union> (set l) \<and>  v2 \<in> \<Union> (set l))"
  apply (induction l arbitrary: rc)
  apply simp
proof 
  fix a l rc
  assume p1: "\<And>rc. Forward_Analysis.acyclic rc l \<longrightarrow>
           (\<forall>v v1 v2.
               v \<in> \<Union> (set l) \<and> v \<in> dom rc \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
               v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))" and
         p2: "Forward_Analysis.acyclic rc (a # l)"
  from p2 have c1: "Forward_Analysis.acyclic (rc |` (\<Union> (set l))) l"
    using acyclic.simps(2) by blast
  show "\<forall>v v1 v2.
              v \<in> \<Union> (set (a # l)) \<and> v \<in> dom rc \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
              v1 \<in> \<Union> (set (a # l)) \<and> v2 \<in> \<Union> (set (a # l))"
    apply (rule_tac allI)+
  proof 
    fix v v1 v2
    assume p3: "v \<in> \<Union> (set (a # l)) \<and> v \<in> dom rc \<and> (v1, v2) \<in> the (rc v)"
    show "v1 \<in> \<Union> (set (a # l)) \<and> v2 \<in> \<Union> (set (a # l))"
    proof (cases "v \<in> a")
case True note in_ok = this
  from this p2 show ?thesis 
    by (meson Union_iff acyclic.simps(2) list.set_intros(2) p3)
next
  case False note notin = this
  from this p3 have c2: "v \<in> \<Union> (set l)" by auto
  thm p1 [of "(rc |` (\<Union> (set l)))"] c1
  have c3: "(\<forall>v v1 v2.
      v \<in> \<Union> (set l) \<and>
      v \<in> dom (rc |` \<Union> (set l)) \<and> (v1, v2) \<in> the ((rc |` \<Union> (set l)) v) \<longrightarrow>
      v1 \<in> \<Union> (set l) \<and> v2 \<in> \<Union> (set l))"
    using c1 p1 by blast
  from this notin c2 p3
  have "v \<in> \<Union> (set l) \<and>
        v \<in> dom (rc |` \<Union> (set l)) \<and> (v1, v2) \<in> the ((rc |` \<Union> (set l)) v)"
    by (metis Int_iff dom_restrict restrict_in)
  from this notin c2 p3 c3
  show ?thesis 
   by (meson Union_iff list.set_intros(2))
  qed
qed qed  

definition compute_ready_set_abstract where
  "compute_ready_set_abstract
   SI rc SR = 
   FOREACHi (\<lambda> s1 s2. s2 = {v . v \<in> (SI - s1) \<and> 
            (v \<in> dom rc \<longrightarrow> (\<forall> (v1, v2) \<in> (the (rc v)).v1 \<in> SR \<and> v2 \<in> SR))}) 
   {v. v \<in> SI} 
    (\<lambda> v S.  
     do {  
           c \<leftarrow> compute_dependent_abstract v rc;
           if c \<subseteq> SR then RETURN (S \<union> {v}) else RETURN S
    }) ({})"

fun l_S where
 "l_S [] S = []" |
 "l_S (a#l) S = (a - S) # (l_S l S)"

lemma l_S_correct: "\<Union> (set (l_S l S)) = \<Union> (set l) - S"
  apply (induction l arbitrary: S)
  apply simp
proof -
  fix a l S
  assume p1: "(\<And>S. \<Union> (set (l_S l S)) = \<Union> (set l) - S)"
  from p1 have p1': "\<Union> (set (l_S l S)) = \<Union> (set l) - S"
    by simp
  from  l_S.simps(2)[of a l S]
  have "\<Union> (set (l_S (a # l) S)) = ((a - S)) \<union> \<Union> (set (l_S l S))"
    by force
  from this p1'
  show "\<Union> (set (l_S (a # l) S)) = \<Union> (set (a # l)) - S "
    apply simp
    by blast
qed

lemma acyclic_last: "\<And> S Su l rc. Su \<subseteq> S \<and> S = \<Union> (set l) \<and> 
                                  Su \<noteq> {} \<and> acyclic rc l \<longrightarrow> 
                                  (\<exists> e. e \<in> Su \<and> 
                                  (e \<notin> dom rc \<or> (e \<in> dom rc \<and> 
                                  (\<forall> v1 v2. (v1, v2) \<in> (the (rc e)) \<longrightarrow> 
                                         v1 \<notin> Su \<and> v2 \<notin> Su))))"
proof 
  fix S Su l rc
  assume p1: "Su \<subseteq> S \<and> S = \<Union> (set l) \<and> Su \<noteq> {} \<and> Forward_Analysis.acyclic rc l"
  from p1 
  show "(\<exists> e. e \<in> Su \<and> (e \<notin> dom rc \<or> (e \<in> dom rc \<and> 
                        (\<forall> v1 v2. (v1, v2) \<in> (the (rc e)) \<longrightarrow> 
                          v1 \<notin> Su \<and> v2 \<notin> Su))))"
    apply (induction l arbitrary: S Su)
    apply auto[1]
  proof -
    fix a l S Su
    assume p1: "(\<And>S Su.
           Su \<subseteq> S \<and> S = \<Union> (set l) \<and> Su \<noteq> {} \<and> Forward_Analysis.acyclic rc l \<Longrightarrow>
           \<exists>e. e \<in> Su \<and>
               (e \<notin> dom rc \<or>
                e \<in> dom rc \<and>
                (\<forall>v1 v2. (v1, v2) \<in> the (rc e) \<longrightarrow> v1 \<notin> Su \<and> v2 \<notin> Su)))"
       and p2: "Su \<subseteq> S \<and> S = \<Union> (set (a # l)) \<and> 
                Su \<noteq> {} \<and> Forward_Analysis.acyclic rc (a # l)"

    show "\<exists>e. e \<in> Su \<and>
           (e \<notin> dom rc \<or>
            e \<in> dom rc \<and> (\<forall>v1 v2. (v1, v2) \<in> the (rc e) \<longrightarrow> v1 \<notin> Su \<and> v2 \<notin> Su))"

    proof (cases "\<Union> (set l) = {}")
      case True
      from p2 
      have empty: "a \<inter> (\<Union> (set l)) = {}"
        using True by blast
      from this p2 have "Su \<subseteq> a"
        by (simp add: \<open>Su \<subseteq> S \<and> S = \<Union> (set (a # l)) \<and> Su \<noteq> {} \<and> 
                      Forward_Analysis.acyclic rc (a # l)\<close> True)
      from this empty p2 acyclic.simps(2)[of rc a l]
      show ?thesis 
        by (metis True all_not_in_conv in_mono)
    next
      case False
      let ?l = "l_S (a # l) (S - Su)"
      from p2 have "Su \<subseteq> S \<and> S = \<Union> (set (a # l)) \<and> acyclic rc (a # l)"
        by blast
      from this
      have "Su = \<Union> (set ?l)"
        apply (induction l arbitrary: Su S a)
        using set_ConsD set_eq_subset apply auto[1]
      proof -
        fix a l Su S aa
        assume p1: "(\<And>Su S a.
           Su \<subseteq> S \<and> S = \<Union> (set (a # l)) \<and> Forward_Analysis.acyclic rc (a # l) \<Longrightarrow>
           Su = \<Union> (set (l_S (a # l) (S - Su))))"
           and p2: "Su \<subseteq> S \<and> S = \<Union> (set (aa # a # l)) \<and> 
                    Forward_Analysis.acyclic rc (aa # a # l)"
        let ?Su = "Su - aa"
        let ?S  = "S - aa"
        
        from p2
        have pre1: "?Su \<subseteq> ?S"
          by blast
        from p2 acyclic.simps
        have aa_al_empty: "aa \<inter> (\<Union> (set (a # l))) = {}"
          by metis
        from this p2
        have pre2: "?S = \<Union> (set (a # l))"
          by auto
        from p2
        have pre3: "acyclic rc (a # l)"
          using acyclic_tail by blast

        from p1 pre1 pre2 pre3
        have "?Su = \<Union> (set (l_S (a # l) (?S - ?Su)))"
          by blast

        from this aa_al_empty 
             l_S_correct[of "aa # a # l" "S - Su"]
             l_S_correct[of "a # l" "S - aa - (Su - aa)"]
        show "Su = \<Union> (set (l_S (aa # a # l) (S - Su)))"
          using p2 by blast
      qed
      from this p2
      show "\<exists>e. e \<in> Su \<and>
            (e \<notin> dom rc \<or>
             e \<in> dom rc \<and> (\<forall>v1 v2. (v1, v2) \<in> the (rc e) \<longrightarrow> v1 \<notin> Su \<and> v2 \<notin> Su))"
        apply (induction l arbitrary: S Su a)
      proof -
        {
          fix S Su a
          assume p1: "Su = \<Union> (set (l_S [a] (S - Su)))"
             and p2: "Su \<subseteq> S \<and> S = \<Union> (set [a]) \<and> Su \<noteq> {} \<and> 
                      Forward_Analysis.acyclic rc [a]"
          from p1 p2 have Sua: "Su \<subseteq> a \<and> Su \<noteq> {}"
            by auto
          from p2 acyclic.simps(2)[of rc a "[]"] 
          have "\<And> x. x \<in> a \<longrightarrow> 
                          (x \<notin> dom rc \<or> (x \<in> dom rc \<and> the (rc x) = {}))"
            by fastforce
          from this Sua
          show "\<exists>e. e \<in> Su \<and>
           (e \<notin> dom rc \<or>
            e \<in> dom rc \<and> (\<forall>v1 v2. (v1, v2) \<in> the (rc e) \<longrightarrow> v1 \<notin> Su \<and> v2 \<notin> Su))"
            by blast
        }
        {
          fix a l S Su aa
          assume p1: "\<And>S Su a.
           Su = \<Union> (set (l_S (a # l) (S - Su))) \<Longrightarrow>
           Su \<subseteq> S \<and>
           S = \<Union> (set (a # l)) \<and> Su \<noteq> {} \<and> Forward_Analysis.acyclic rc (a # l) \<Longrightarrow>
           \<exists>e. e \<in> Su \<and>
               (e \<notin> dom rc \<or>
                e \<in> dom rc \<and>
                (\<forall>v1 v2. (v1, v2) \<in> the (rc e) \<longrightarrow> v1 \<notin> Su \<and> v2 \<notin> Su))"
             and p2: "Su = \<Union> (set (l_S (aa # a # l) (S - Su)))"
             and p3: "Su \<subseteq> S \<and> S = \<Union> (set (aa # a # l)) \<and>
                      Su \<noteq> {} \<and> Forward_Analysis.acyclic rc (aa # a # l)"
          let ?S = "\<Union> (set (a # l))"
          let ?Su = "\<Union> (set (l_S (a # l) (S - Su)))"
          from p2
          have pt1: "\<Union> (set (l_S (a # l) (S - Su))) =
                \<Union> (set (l_S (a # l) (\<Union> (set (a # l)) - 
                                      \<Union> (set (l_S (a # l) (S - Su))))))"
            by (metis (no_types, lifting) Diff_subset double_diff l_S_correct order_mono_setup.refl)

          from acyclic.simps
          have pt2: "\<Union> (set (l_S (a # l) (S - Su))) \<subseteq> \<Union> (set (a # l)) \<and>
                \<Union> (set (a # l)) = \<Union> (set (a # l)) \<and>
                acyclic rc (a # l)"
            by (metis Diff_iff acyclic_tail l_S_correct p3 subsetI)

          thm pt2 p1[of ?Su a ?S, OF pt1]
          have cc1: "?Su \<noteq> {} \<longrightarrow> 
                (\<exists>e. e \<in> ?Su \<and>
                    (e \<notin> dom rc \<or>
                     e \<in> dom rc \<and>
                    (\<forall>v1 v2. (v1, v2) \<in> the (rc e) \<longrightarrow> v1 \<notin> ?Su \<and> v2 \<notin> ?Su)))"
            apply (rule_tac impI)
          proof -
            assume pc1: "\<Union> (set (l_S (a # l) (S - Su))) \<noteq> {}"
            from pc1 pt2 
            have "\<Union> (set (l_S (a # l) (S - Su))) \<subseteq> \<Union> (set (a # l)) \<and>
                  \<Union> (set (a # l)) = \<Union> (set (a # l)) \<and>
                  \<Union> (set (l_S (a # l) (S - Su))) \<noteq> {} \<and> 
                     Forward_Analysis.acyclic rc (a # l)"             
              by linarith
            from p1[OF pt1 this]
            show "\<exists>e. e \<in> ?Su \<and>
        (e \<notin> dom rc \<or>
         e \<in> dom rc \<and> (\<forall>v1 v2. (v1, v2) \<in> the (rc e) \<longrightarrow> v1 \<notin> ?Su \<and> v2 \<notin> ?Su))"
              by auto
          qed
          from p3 have
          "acyclic rc (aa # a # l)" by blast
          from this
          have "\<forall> e \<in> (\<Union> (set (a # l))). e \<in> dom rc \<longrightarrow>
                    (\<forall> v1 v2. (v1, v2) \<in> the (rc e) \<longrightarrow> v1 \<notin> aa \<and> v2 \<notin> aa)"
            by (metis acyclic.simps(2) acyclic_dep1 disjoint_iff_not_equal pt2)
          from this l_S_correct[of "a # l" Su]
          have "\<forall> e \<in> ?Su. e \<in> dom rc \<longrightarrow>
                    (\<forall> v1 v2. (v1, v2) \<in> the (rc e) \<longrightarrow> v1 \<notin> aa \<and> v2 \<notin> aa)"
            using pt2 by blast
          from this cc1
          have su1: "\<Union> (set (l_S (a # l) (S - Su))) \<noteq> {} \<longrightarrow>
                   (\<exists>e. e \<in> \<Union> (set (l_S (a # l) (S - Su))) \<and>
                    (e \<notin> dom rc \<or>
                     e \<in> dom rc \<and>
                    (\<forall>v1 v2.
                    (v1, v2) \<in> the (rc e) \<longrightarrow>
                     v1 \<notin> Su \<and>
                     v2 \<notin> Su)))"
            by (metis Diff_iff acyclic_dep1 l_S_correct pt2)

          from p2 l_S_correct[of "aa # a # l" "S - Su"]
               l_S_correct[of "a # l" "S - Su"]
          have "Su = ?Su \<union> (aa - (S - Su))"
            by fastforce

          show "\<exists> e. e \<in> Su \<and>
           (e \<notin> dom rc \<or>
            e \<in> dom rc \<and> (\<forall>v1 v2. (v1, v2) \<in> the (rc e) \<longrightarrow> v1 \<notin> Su \<and> v2 \<notin> Su))"
          proof (cases "?Su \<noteq> {}")
            case True
            from this su1
            have "(\<exists>e. e \<in> \<Union> (set (l_S (a # l) (S - Su))) \<and>
                  (e \<notin> dom rc \<or>
                   e \<in> dom rc \<and> (\<forall>v1 v2. (v1, v2) \<in> the (rc e) \<longrightarrow> 
                   v1 \<notin> Su \<and> v2 \<notin> Su)))"
              by auto
            then show ?thesis 
              by (metis UnCI \<open>Su = \<Union> (set (l_S (a # l) (S - Su))) \<union> (aa - (S - Su))\<close>)
          next
            case False
            from this
            have Suaa: "Su \<subseteq> aa"
              using \<open>Su = \<Union> (set (l_S (a # l) (S - Su))) \<union> (aa - (S - Su))\<close> by auto
            from p3 
            have Su_nempty: "Su \<noteq> {}" by simp
            from p3 acyclic.simps(2)[of rc aa "a # l"]
            have "aa \<inter> \<Union> (set (a # l)) = {} \<and>
                  (\<forall>v1 v2 v.
                   v \<in> aa \<and> v \<in> dom rc \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
                   v1 \<in> \<Union> (set (a # l)) \<and> v2 \<in> \<Union> (set (a # l)))"
              by blast
            from this
            have "\<forall> v1 v2 x. x \<in> aa \<and> x \<in> dom rc \<and> (v1,v2) \<in> the (rc x) 
                             \<longrightarrow> v1 \<notin> aa \<and> v2 \<notin> aa"
              by blast   
            from this Suaa Su_nempty
            show ?thesis 
              by blast
          qed 
        }
    qed qed qed qed

lemma compute_ready_set_abstract_alt: 
  assumes SI_finite: "finite SI" and
          dom_rc: "finite (dom rc)"  and
          ran_rc: "\<And>x . x \<in> dom rc \<longrightarrow> finite (the (rc x))" 
  shows "compute_ready_set_abstract SI rc SR \<le> 
   SPEC (\<lambda> S. S \<subseteq> SI \<and> (\<forall> v v1 v2. v \<in> S \<and> rc v \<noteq> None \<and> (v1, v2) \<in> the (rc v) \<longrightarrow> 
                               (v1 \<in> SR \<and> v2 \<in> SR)))"
  unfolding compute_ready_set_abstract_def
            compute_dependent_abstract_def
  apply (intro refine_vcg)
  apply (simp_all split: if_splits)
  apply (simp add: SI_finite)
  apply (insert  SI_finite)
  using ran_rc apply blast
  apply fastforce
  apply fastforce
  apply fastforce
  apply auto[1]
  by blast


lemma compute_ready_set_abstract_nempty: 
  assumes SI_finite: "finite SI \<and> SI \<noteq> {}" and
          acyclic: "SS = SI \<union> SR \<and> SI \<inter> SR = {} \<and> 
                    (\<exists> l. SS = \<Union> (set l) \<and> acyclic rc l)" 
                    and 
          dom_rc: "finite (dom rc)"  and
          ran_rc: "\<And>x . x \<in> dom rc \<longrightarrow> finite (the (rc x))" and
          ran_rc1: "\<forall> v1 v2 x . x \<in> dom rc \<and> (v1, v2) \<in> the (rc x) \<longrightarrow> 
                                 v1 \<in> SS \<and> v2 \<in> SS"
  
  shows "compute_ready_set_abstract SI rc SR \<le> 
   SPEC (\<lambda> S. S \<subseteq> SI \<and> S \<noteq> {} \<and> (\<forall> v v1 v2. v \<in> S \<and> rc v \<noteq> None \<and> (v1, v2) \<in> the (rc v) \<longrightarrow> 
                               (v1 \<in> SR \<and> v2 \<in> SR)))"
  unfolding compute_ready_set_abstract_def
            compute_dependent_abstract_def
  apply (intro refine_vcg)
  apply (simp_all split: if_splits)
  apply (simp add: SI_finite)
  apply (insert  SI_finite)
  using ran_rc apply blast
  defer
  apply fastforce
  apply fastforce
  apply fastforce
  defer 
  apply fastforce
  apply (rule conjI)
  defer
  apply blast
proof -
  fix \<sigma>
  assume p1: "finite SI \<and> SI \<noteq> {}"
  from acyclic obtain l where
  l_def: "SS = \<Union> (set l) \<and> Forward_Analysis.acyclic rc l"
    by blast
  

  
  from l_def acyclic_last[of SI SS l rc]
  have "(\<exists>e. e \<in> SI \<and>
         (e \<notin> dom rc \<or>
          e \<in> dom rc \<and> (\<forall>v1 v2. (v1, v2) \<in> the (rc e) \<longrightarrow> v1 \<notin> SI \<and> v2 \<notin> SI)))"
    using acyclic p1 by blast
  from this ran_rc1 acyclic
  show "\<exists>x. x \<in> SI \<and> (x \<in> dom rc \<longrightarrow> (\<forall>(v1, v2)\<in>the (rc x). v1 \<in> SR \<and> v2 \<in> SR))"
    by (metis (no_types, lifting) Un_iff case_prodI2)
qed




definition new_language_map  where
  "new_language_map rm rm' v a \<longleftrightarrow>
   (\<forall>v' a'. dom rm = dom rm' \<and> 
    (v' \<noteq> v \<longrightarrow> rm v' = Some a' \<longleftrightarrow> rm' v' = Some a') \<and> rm' v = Some a)"


definition lang_var  where "
  lang_var v RC rm a b = 
  FOREACHi (\<lambda> s A. 
            (\<forall> w. NFA A \<and> ((NFA_accept A w) \<longleftrightarrow> 
                                 (NFA_accept (the (rm v)) w) \<and>
                                  (\<forall> (v1, v2) \<in> RC - s. \<exists> w1 w2.
                                  NFA_accept (the (rm v1)) w1 \<and> 
                                  NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2))))
          {e. e \<in> RC} 
          (\<lambda> (v1, v2) L. 
           do {
                RETURN (NFA_product L 
                        (NFA_normalise_states
                                (efficient_NFA_concatenation 
                                     (NFA_rename_states 
                                          (the (rm v1)) (\<lambda> q. (a,q))) 
                                     (NFA_rename_states
                                          (the (rm v2)) (\<lambda> q. (b,q))))
                           )
                        )
           }) 
          (the (rm v))"



lemma lang_var_correct: 
  assumes rm_dom: "\<And> v1 v2. (v1,v2) \<in> RC \<longrightarrow> v1 \<in> dom rm \<and> v2 \<in> dom rm \<and>
                                             NFA (the (rm v1)) \<and> NFA (the (rm v2))"
      and rm_v_OK: "NFA (the (rm v))"
      and finite_RC: "finite RC" 
      and a_neq_b : "a \<noteq> b"
  shows "lang_var v RC rm a b \<le> 
         SPEC (\<lambda> \<A>. \<forall> w. NFA \<A> \<and> ((NFA_accept \<A> w) \<longleftrightarrow>   
                                (NFA_accept (the (rm v)) w) \<and>
                                (\<forall> (v1, v2) \<in> RC. \<exists> w1 w2.
                                  NFA_accept (the (rm v1)) w1 \<and> 
                                  NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2)))"
  unfolding lang_var_def
  apply (intro refine_vcg)
  apply (simp add: finite_RC)
  apply (simp add: rm_v_OK)
  apply (insert \<L>_NFA_product)
  apply (simp_all add: if_splits case_split)
proof -
  {
    fix x it \<sigma>
    show " x \<in> it \<Longrightarrow>
       it \<subseteq> RC \<Longrightarrow>
       NFA \<sigma> \<and>
       (\<forall>w. NFA_accept \<sigma> w =
            (NFA_accept (the (rm v)) w \<and>
             (\<forall>x\<in>RC - it.
                 case x of
                 (v1, v2) \<Rightarrow>
                   \<exists>w1. NFA_accept (the (rm v1)) w1 \<and>
                        (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2)))) \<Longrightarrow>
       (\<And>\<A>1 \<A>2. NFA \<A>1 \<Longrightarrow> NFA \<A>2 \<Longrightarrow> \<L> (NFA_product \<A>1 \<A>2) = \<L> \<A>1 \<inter> \<L> \<A>2) \<Longrightarrow>
       (case x of
        (v1, v2) \<Rightarrow>
          \<lambda>L. RETURN
               (NFA_product L
                 (NFA_normalise_states
                   (efficient_NFA_concatenation
                     (NFA_rename_states (the (rm v1)) (Pair a))
                     (NFA_rename_states (the (rm v2)) (Pair b))))))
        \<sigma>
       \<le> SPEC (\<lambda>A. NFA A \<and>
                    (\<forall>w. NFA_accept A w =
                         (NFA_accept (the (rm v)) w \<and>
                          (\<forall>x\<in>RC - (it - {x}).
                              case x of
                              (v1, v2) \<Rightarrow>
                                \<exists>w1. NFA_accept (the (rm v1)) w1 \<and>
                                     (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and>
                                           w = w1 @ w2)))))"
    proof -
      assume p1: "x \<in> it" and
             p2: "it \<subseteq> RC" and
             p3: "NFA \<sigma> \<and>
    (\<forall>w. NFA_accept \<sigma> w =
         (NFA_accept (the (rm v)) w \<and>
          (\<forall>x\<in>RC - it.
              case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the (rm v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2))))" and
          p4: "(\<And>\<A>1 \<A>2. NFA \<A>1 \<Longrightarrow> NFA \<A>2 \<Longrightarrow> \<L> (NFA_product \<A>1 \<A>2) = \<L> \<A>1 \<inter> \<L> \<A>2)"
    from this obtain v1 v2 where x_def: "x = (v1,v2)" by fastforce
    from this p3 show "(case x of
     (v1, v2) \<Rightarrow>
       \<lambda>L. RETURN
            (NFA_product L
              (NFA_normalise_states
                (efficient_NFA_concatenation (NFA_rename_states (the (rm v1)) (Pair a))
                  (NFA_rename_states (the (rm v2)) (Pair b))))))
     \<sigma>
    \<le> SPEC (\<lambda>A. NFA A \<and>
                 (\<forall>w. NFA_accept A w =
                      (NFA_accept (the (rm v)) w \<and>
                       (\<forall>x\<in>RC - (it - {x}).
                           case x of
                           (v1, v2) \<Rightarrow>
                             \<exists>w1. NFA_accept (the (rm v1)) w1 \<and>
                                  (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2)))))"
      apply simp
      apply (insert accept_NFA_product)
    proof 
      {
      fix w
      assume p11: "NFA \<sigma> \<and>
    (\<forall>w. NFA_accept \<sigma> w =
         (NFA_accept (the (rm v)) w \<and>
          (\<forall>x\<in>RC - it.
              case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the (rm v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2))))" and
             p12: " (\<And>\<A>1 \<A>2.
             NFA \<A>1 \<Longrightarrow>
             NFA \<A>2 \<Longrightarrow>
             \<forall>w. NFA_accept (NFA_product \<A>1 \<A>2) w =
                 (NFA_accept \<A>1 w \<and> NFA_accept \<A>2 w))"
       from p3 have c1: "NFA \<sigma>" by auto
        from p1 p2 x_def have c2: "(v1, v2) \<in> RC" by auto
        from this rm_dom have c3: "NFA (the (rm v1)) \<and> NFA (the (rm v2))"
          by auto
        from this have c4: "NFA (NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q)))"
          by (simp add: NFA_rename_states___is_well_formed)

        from c3 have c5: "NFA (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q)))"
          by (simp add: NFA_rename_states___is_well_formed)


        let ?Q1 = "\<Q> (NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q)))"
        let ?Q2 = "\<Q> (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q)))"
        from a_neq_b have c45: "?Q1 \<inter> ?Q2 = {}"
          unfolding NFA_rename_states_def
          by fastforce
        from c4 c5 c45 efficient_NFA_concatenation___is_well_formed
        have c6: "NFA (efficient_NFA_concatenation 
              (NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q)))
              (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q))))"
          by (simp add: efficient_NFA_concatenation___is_well_formed)

        from c6 NFA_isomorphic_wf_normalise_states 
        have c7: "NFA (NFA_normalise_states
            (efficient_NFA_concatenation 
                 (NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q)))
                  (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q)))))"
          by (metis NFA_isomorphic_wf_D(2))
      from p11 rm_dom 
      show "NFA (NFA_product \<sigma>
          (NFA_normalise_states
            (efficient_NFA_concatenation (NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q)))
              (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q))))))"
      proof -
        from c6 c7 p11 NFA_bool_comb___isomorphic_wf
             NFA_product___isomorphic_wf
        show "NFA (NFA_product \<sigma>
          (NFA_normalise_states
            (efficient_NFA_concatenation (NFA_rename_states (the (rm v1)) 
                (\<lambda>q. (a, q)))
              (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q))))))"
          unfolding NFA_product_def NFA_bool_comb_def
proof -
  have "NFA (efficient_bool_comb_NFA (\<and>) \<sigma> (NFA_normalise_states (efficient_NFA_concatenation (NFA_rename_states (the (rm v1)) 
    (\<lambda>b. (a, b))) (NFA_rename_states (the (rm v2)) (\<lambda>ba. (b, ba))))::('e, 'c) NFA_rec))"
by (simp add: c7 efficient_bool_comb_NFA___is_well_formed p3)
  then show "NFA (NFA_normalise_states (efficient_bool_comb_NFA (\<and>) \<sigma> 
    (NFA_normalise_states (efficient_NFA_concatenation (NFA_rename_states (the (rm v1)) 
      (\<lambda>b. (a, b))) 
    (NFA_rename_states (the (rm v2)) (\<lambda>ba. (b,ba))))::('e, 'c) NFA_rec))::('e, 'c) NFA_rec)"
by (meson NFA_isomorphic_wf_D(2) NFA_isomorphic_wf_normalise_states)
qed
qed
    from p11 p12 c7
    accept_NFA_product
    show " \<forall>w. NFA_accept
         (NFA_product \<sigma>
           (NFA_normalise_states
             (efficient_NFA_concatenation (NFA_rename_states (the (rm v1)) 
                    (\<lambda>q. (a, q)))
               (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q))))))
         w =
        (NFA_accept (the (rm v)) w \<and>
         (\<forall>x\<in>RC - (it - {(v1, v2)}).
             case x of
             (v1, v2) \<Rightarrow>
               \<exists>w1. NFA_accept (the (rm v1)) w1 \<and>
                    (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2)))"
      apply (simp add: c7 p11)
    proof 
      fix w
      from p1 p2 x_def show "NFA_accept
          (NFA_product \<sigma>
            (NFA_normalise_states
              (efficient_NFA_concatenation
                (NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q)))
                (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q))))))
          w =
         (NFA_accept (the (rm v)) w \<and>
          (\<forall>x\<in>RC - (it - {(v1, v2)}).
              case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the (rm v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2)))"
        apply (simp add: accept_NFA_product)
      proof -
        let ?A1 = "(NFA_normalise_states
         (efficient_NFA_concatenation (NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q)))
           (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q)))))
        "
        from accept_NFA_product[OF c1 c7] have c10: "NFA_accept
         (NFA_product \<sigma>
           (NFA_normalise_states
             (efficient_NFA_concatenation (NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q)))
               (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q))))))
         w =
        (NFA_accept \<sigma> w \<and>
         NFA_accept
          (NFA_normalise_states
            (efficient_NFA_concatenation (NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q)))
              (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q)))))
          w)
        " 
          apply simp
          by (simp add: c6)
        have c8: "RC - (it - {(v1, v2)}) = (RC - it) \<union> {(v1, v2)}"
          using p1 p2 x_def by fastforce
       have c9: "(\<forall>x\<in>RC - (it - {(v1, v2)}).
         case x of
         (v1, v2) \<Rightarrow>
           \<exists>w1. NFA_accept (the (rm v1)) w1 \<and>
                (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2)) = 
         ((\<forall>x\<in>RC - it.
         case x of
         (v1, v2) \<Rightarrow>
           \<exists>w1. NFA_accept (the (rm v1)) w1 \<and>
                (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2)) \<and> 
            (\<exists> w1. NFA_accept (the (rm v1)) w1 \<and>
                (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2)))"
         apply (simp add: c8)
         by (simp add: eq_iff)

       from NFA_is_equivalence_rename_funI___inj_used have 
       c21: "NFA_is_equivalence_rename_fun (the (rm v1)) (\<lambda>q. (a, q))"
         apply (rule_tac NFA_is_equivalence_rename_funI___inj_used)
         by simp

       from NFA_is_equivalence_rename_funI___inj_used have 
       c22: "NFA_is_equivalence_rename_fun (the (rm v2)) (\<lambda>q. (b, q))"
         apply (rule_tac NFA_is_equivalence_rename_funI___inj_used)
         by simp

       from NFA.NFA_rename_states___accept c21 have c23:
       "\<And> w1. NFA_accept (NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q))) w1 = 
        NFA_accept (the (rm v1)) w1" 
         using c3 by blast

       from NFA.NFA_rename_states___accept c22 have c24:
       "\<And> w2. NFA_accept (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q))) w2 = 
        NFA_accept (the (rm v2)) w2" 
        using c3 by blast

      from NFA_normalise_states_accept
      have c121: "NFA_accept
          (NFA_normalise_states
            (efficient_NFA_concatenation (NFA_rename_states (the (rm v1)) 
                (\<lambda>q. (a, q)))
              (NFA_rename_states (the (rm v2)) 
                (\<lambda>q. (b, q)))))
          w = NFA_accept
            (efficient_NFA_concatenation (NFA_rename_states 
              (the (rm v1)) (\<lambda>q. (a, q)))
              (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q))))
          w" 
        using c6 by blast
      note re1 = NFA_normalise_states_accept[of "(NFA_normalise_states
            (efficient_NFA_concatenation 
              (NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q)))
              (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q)))))", of w]
      from accept_efficient_NFA_concatenation
           [of "(NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q)))"
               "(NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q)))" w,
            OF c4 c5 c45] 
            c23 c24 
            NFA_normalise_states_accept[of "
            (efficient_NFA_concatenation (NFA_rename_states 
              (the (rm v1)) (\<lambda>q. (a, q)))
              (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q))))", of w]
            c121
       have c12: "NFA_accept
          (NFA_normalise_states
            (efficient_NFA_concatenation (NFA_rename_states (the (rm v1)) 
              (\<lambda>q. (a, q)))
              (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q)))))
          w = (\<exists> w1. NFA_accept (the (rm v1)) w1 \<and>
                (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2))"
         apply (simp only: re1)
         apply simp
       proof -
         assume z1: "NFA_accept
     (NFA_normalise_states
       (efficient_NFA_concatenation (NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q)))
         (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q)))))
     w =
    (\<exists>w1 w2.
        w = w1 @ w2 \<and> NFA_accept (the (rm v1)) w1 \<and> NFA_accept (the (rm v2)) w2)"
         from z1 show "NFA_accept
     (NFA_normalise_states
       (efficient_NFA_concatenation (NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q)))
         (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q)))))
     w =
    (\<exists>w1. NFA_accept (the (rm v1)) w1 \<and>
          (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2))"
     apply (subgoal_tac "(\<exists>w1 w2. w = w1 @ w2 \<and> NFA_accept (the (rm v1)) w1 \<and> NFA_accept (the (rm v2)) w2) =
             (\<exists>w1. NFA_accept (the (rm v1)) w1 \<and>
          (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2))")
            defer
            apply fast
           apply simp
           by (simp add: c121)
       qed
         
      
       from c9 c10 p11 c12  show "NFA_accept
     (NFA_product \<sigma>
       (NFA_normalise_states
         (efficient_NFA_concatenation (NFA_rename_states (the (rm v1)) (\<lambda>q. (a, q)))
           (NFA_rename_states (the (rm v2)) (\<lambda>q. (b, q))))))
     w =
    (NFA_accept (the (rm v)) w \<and>
     (\<forall>x\<in>RC - (it - {(v1, v2)}).
         case x of
         (v1, v2) \<Rightarrow>
           \<exists>w1. NFA_accept (the (rm v1)) w1 \<and>
                (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2)))"
         apply simp
         by (simp add: c12)
     qed
   qed
 }
qed
qed 
}
qed


definition language_vars where "
  language_vars S rc rm da db = 
  FOREACHi
       (\<lambda> Si rmi. S \<subseteq> dom rmi \<and> dom rmi = dom rm \<and>
                  (\<forall> v. v \<in> dom(rmi) \<longrightarrow> NFA (the (rmi v))) \<and>
                  (\<forall> v \<in> Si. (the (rmi v)) = (the (rm v))) \<and> 
                  (\<forall> v. v \<notin> S  \<longrightarrow> (the (rmi v)) = (the (rm v))) \<and> 
                  (\<forall> x \<in> S - Si. NFA (the (rmi x)) \<and> (\<forall> w.
                  (NFA_accept (the (rmi x)) w \<longleftrightarrow>
                   NFA_accept (the (rm x)) w \<and> 
        (x \<in> dom rc \<longrightarrow> (\<forall> (v1,v2) \<in> (the (rc x)).\<exists> w1 w2. NFA_accept (the (rmi v1)) w1 \<and>
                  NFA_accept (the (rmi v2)) w2 \<and> w = w1 @ w2)))))
        )
       {v. v \<in> S} (\<lambda> v rm. do {
       if (v \<in> dom rc) then do {
       a   \<leftarrow> (lang_var v (the (rc v)) rm da db);
       rm' \<leftarrow> SPEC (\<lambda> rm'. new_language_map rm rm' v a);
       RETURN rm'}
       else RETURN rm
  }) rm"

lemma language_vars_correct: 
  assumes   acyc: "\<And> v v1 v2. v \<in> S \<and> v \<in> dom rc \<and> (v1,v2) \<in> (the (rc v)) 
                    \<longrightarrow> v1 \<notin> S \<and> v2 \<notin> S"
      and rm_dom: "\<And> v v1 v2. v \<in> S \<and> v \<in> dom rc \<and> (v1,v2) \<in> (the (rc v)) \<longrightarrow>
                          v1 \<in> dom rm \<and> v2 \<in> dom rm \<and>
                          NFA (the (rm v1)) \<and> NFA (the (rm v2))"
      and rm_v_OK: "\<And> v. v \<in> dom rm \<longrightarrow> NFA (the (rm v))"
      and finite_rc: "finite (dom rc) \<and> (\<forall> v \<in> S. v \<in> dom (rc) \<longrightarrow> finite (the (rc v)))" 
      and finite_rm: "S \<subseteq> dom rm" 
      and finite_S: "finite S"
      and a_neq_b : "a \<noteq> b"
  shows "language_vars S rc rm a b \<le> 
         SPEC (\<lambda> rm1. dom rm1 = dom rm \<and> 
                      (\<forall> v. v \<notin> S  \<longrightarrow> the (rm1 v) = the (rm v)) \<and>
                      (\<forall> v \<in> S. \<forall> w. NFA (the (rm1 v)) \<and> 
                      ((NFA_accept (the (rm1 v)) w) \<longleftrightarrow>   
                      (NFA_accept (the (rm v)) w) \<and> (v \<in> dom rc \<longrightarrow>
                      (\<forall> (v1, v2) \<in> (the (rc v)). \<exists> w1 w2.
                      NFA_accept (the (rm v1)) w1 \<and> 
                      NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2)))))"
  unfolding language_vars_def
  thm lang_var_correct
  apply (intro refine_vcg)
  apply (simp add: finite_S)
  apply simp
   apply (simp add: finite_rm rm_v_OK)
  using lang_var_correct a_neq_b
  apply simp
    defer
proof -
  {
    fix x it \<sigma>
    assume p1: "x \<in> it" and 
           p2: "it \<subseteq> {v. v \<in> S}" and 
           p3: "S \<subseteq> dom \<sigma> \<and>
       dom \<sigma> = dom rm \<and>
       (\<forall>v. v \<in> dom \<sigma> \<longrightarrow> NFA (the (\<sigma> v))) \<and>
       (\<forall>v\<in>it. the (\<sigma> v) = the (rm v)) \<and>
       (\<forall>v. v \<notin> S \<longrightarrow> the (\<sigma> v) = the (rm v)) \<and>
       (\<forall>x\<in>S - it.
           NFA (the (\<sigma> x)) \<and>
           (\<forall>w. NFA_accept (the (\<sigma> x)) w =
                (NFA_accept (the (rm x)) w \<and>
                 (x \<in> dom rc \<longrightarrow>
                  (\<forall>(v1, v2)\<in>the (rc x).
                      \<exists>w1 w2.
                         NFA_accept (the (\<sigma> v1)) w1 \<and>
                         NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2)))))" and
          p4: "x \<notin> dom rc"
    from this 
    show "S \<subseteq> dom \<sigma> \<and>
       dom \<sigma> = dom rm \<and>
       (\<forall>v. v \<in> dom \<sigma> \<longrightarrow> NFA (the (\<sigma> v))) \<and>
       (\<forall>v\<in>it - {x}. the (\<sigma> v) = the (rm v)) \<and>
       (\<forall>v. v \<notin> S \<longrightarrow> the (\<sigma> v) = the (rm v)) \<and>
       (\<forall>x\<in>S - (it - {x}).
           NFA (the (\<sigma> x)) \<and>
           (\<forall>w. NFA_accept (the (\<sigma> x)) w =
                (NFA_accept (the (rm x)) w \<and>
                 (x \<in> dom rc \<longrightarrow>
                  (\<forall>(v1, v2)\<in>the (rc x).
                      \<exists>w1 w2.
                         NFA_accept (the (\<sigma> v1)) w1 \<and>
                         NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2)))))"
      apply simp
    proof 
      from p3
      show "S \<subseteq> dom rm"
        by auto
      show "\<forall>x\<in>S - (it - {x}).
       NFA (the (\<sigma> x)) \<and>
       (\<forall>w. NFA_accept (the (\<sigma> x)) w =
            (NFA_accept (the (rm x)) w \<and>
             (x \<in> dom rc \<longrightarrow>
              (\<forall>(v1, v2)\<in>the (rc x).
                  \<exists>w1. NFA_accept (the (\<sigma> v1)) w1 \<and>
                       (\<exists>w2. NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2)))))"
      proof 
        fix xa
        assume p5: "xa \<in> S - (it - {x})"
        from this have pc3: "xa \<in> S - it \<or> xa = x"
          by fastforce
        from p3
        have pc2: "xa \<in> S - it \<longrightarrow>  NFA (the (\<sigma> xa)) \<and>
          (\<forall>w. NFA_accept (the (\<sigma> xa)) w =
               (NFA_accept (the (rm xa)) w \<and>
                (xa \<in> dom rc \<longrightarrow>
                 (\<forall>(v1, v2)\<in>the (rc xa).
                     \<exists>w1. NFA_accept (the (\<sigma> v1)) w1 \<and>
                          (\<exists>w2. NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2)))))"
          by simp
        from p1 p2 p3 p4
        have pc1: "xa = x \<longrightarrow> NFA (the (\<sigma> xa)) \<and> 
               (\<forall>w. NFA_accept (the (\<sigma> xa)) w =
               (NFA_accept (the (rm xa)) w \<and>
                (xa \<in> dom rc \<longrightarrow>
                 (\<forall>(v1, v2)\<in>the (rc xa).
                     \<exists>w1. NFA_accept (the (\<sigma> v1)) w1 \<and>
                          (\<exists>w2. NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2)))))"
          by (metis DiffD1 DiffI Diff_eq_empty_iff empty_iff p5)
        from pc1 pc2 pc3
     show "NFA (the (\<sigma> xa)) \<and>
          (\<forall>w. NFA_accept (the (\<sigma> xa)) w =
               (NFA_accept (the (rm xa)) w \<and>
                (xa \<in> dom rc \<longrightarrow>
                 (\<forall>(v1, v2)\<in>the (rc xa).
                     \<exists>w1. NFA_accept (the (\<sigma> v1)) w1 \<and>
                          (\<exists>w2. NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2)))))"
       by auto
     qed qed
  }
  {
    fix \<sigma>
    assume p1: "S \<subseteq> dom \<sigma> \<and>
         dom \<sigma> = dom rm \<and>
         (\<forall>v. v \<in> dom \<sigma> \<longrightarrow> NFA (the (\<sigma> v))) \<and>
         (\<forall>v\<in>{}. the (\<sigma> v) = the (rm v)) \<and>
         (\<forall>v. v \<notin> S \<longrightarrow> the (\<sigma> v) = the (rm v)) \<and>
         (\<forall>x\<in>S - {}.
             NFA (the (\<sigma> x)) \<and>
             (\<forall>w. NFA_accept (the (\<sigma> x)) w =
                  (NFA_accept (the (rm x)) w \<and>
                   (x \<in> dom rc \<longrightarrow>
                    (\<forall>(v1, v2)\<in>the (rc x).
                        \<exists>w1 w2.
                           NFA_accept (the (\<sigma> v1)) w1 \<and>
                           NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2)))))"
    from this show "dom \<sigma> = dom rm \<and>
         (\<forall>v. v \<notin> S \<longrightarrow> the (\<sigma> v) = the (rm v)) \<and>
         (\<forall>v\<in>S. \<forall>w. NFA (the (\<sigma> v)) \<and>
                     NFA_accept (the (\<sigma> v)) w =
                     (NFA_accept (the (rm v)) w \<and>
                      (v \<in> dom rc \<longrightarrow>
                       (\<forall>(v1, v2)\<in>the (rc v).
                           \<exists>w1 w2.
                              NFA_accept (the (rm v1)) w1 \<and>
                              NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2))))"
      apply (rule_tac conjI)+
       apply simp
      apply (rule_tac conjI)+
       apply simp
    proof 
      fix v
      assume p11: "S \<subseteq> dom \<sigma> \<and>
         dom \<sigma> = dom rm \<and>
         (\<forall>v. v \<in> dom \<sigma> \<longrightarrow> NFA (the (\<sigma> v))) \<and>
         (\<forall>v\<in>{}. the (\<sigma> v) = the (rm v)) \<and>
         (\<forall>v. v \<notin> S \<longrightarrow> the (\<sigma> v) = the (rm v)) \<and>
         (\<forall>x\<in>S - {}.
             NFA (the (\<sigma> x)) \<and>
             (\<forall>w. NFA_accept (the (\<sigma> x)) w =
                  (NFA_accept (the (rm x)) w \<and>
                   (x \<in> dom rc \<longrightarrow>
                    (\<forall>(v1, v2)\<in>the (rc x).
                        \<exists>w1 w2.
                           NFA_accept (the (\<sigma> v1)) w1 \<and>
                           NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2)))))"
       and p12: "v \<in> S"
      from this have conn1: "\<forall> v \<in> S.
             NFA (the (\<sigma> v)) \<and>
             (\<forall>w. NFA_accept (the (\<sigma> v)) w =
                  (NFA_accept (the (rm v)) w \<and> (v \<in> dom rc \<longrightarrow>
                   (\<forall>(v1, v2)\<in>the (rc v).
                       \<exists>w1 w2.
                          NFA_accept (the (\<sigma> v1)) w1 \<and>
                          NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2))))"
        by simp
      from this p12 have conn2: "
        NFA (the (\<sigma> v)) \<and>
             (\<forall>w. NFA_accept (the (\<sigma> v)) w =
                  (NFA_accept (the (rm v)) w \<and> (v \<in> dom rc \<longrightarrow>
                   (\<forall>(v1, v2)\<in>the (rc v).
                       \<exists>w1 w2.
                          NFA_accept (the (\<sigma> v1)) w1 \<and>
                          NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2))))"
        by auto

      from p11 have "\<forall> v. v \<notin> S \<longrightarrow> the (\<sigma> v) = the (rm v)" by auto
      from this have "\<forall> v. v \<notin> S \<longrightarrow> 
              (\<forall> w. NFA_accept (the (\<sigma> v)) w = NFA_accept (the (rm v)) w)"
        by simp
      from this acyc[of v] have "v \<in> dom rc \<longrightarrow> (\<forall> (v1, v2) \<in> (the (rc v)). 
              (\<forall> w. NFA_accept (the (\<sigma> v1)) w = NFA_accept (the (rm v1)) w \<and>
                    NFA_accept (the (\<sigma> v2)) w = NFA_accept (the (rm v2)) w))"
        using p12 by blast
      
      from this conn2  show "\<forall>w. NFA (the (\<sigma> v)) \<and>
             NFA_accept (the (\<sigma> v)) w =
             (NFA_accept (the (rm v)) w \<and> (v \<in> dom rc \<longrightarrow>
              (\<forall>(v1, v2)\<in>the (rc v).
                  \<exists>w1 w2.
                     NFA_accept (the (rm v1)) w1 \<and>
                     NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2)))"
        by fastforce
    qed 
  }
  {
  fix x it \<sigma>
  show "x \<in> it \<Longrightarrow>
       it \<subseteq> S \<Longrightarrow>
       S \<subseteq> dom \<sigma> \<and>
       dom \<sigma> = dom rm \<and>
       (\<forall>v. v \<in> dom \<sigma> \<longrightarrow> NFA (the (\<sigma> v))) \<and>
       (\<forall>v\<in>it. the (\<sigma> v) = the (rm v)) \<and>
       (\<forall>v. v \<notin> S \<longrightarrow> the (\<sigma> v) = the (rm v)) \<and>
       (\<forall>x\<in>S - it.
           NFA (the (\<sigma> x)) \<and>
           (\<forall>w. NFA_accept (the (\<sigma> x)) w =
                (NFA_accept (the (rm x)) w \<and>
                 (x \<in> dom rc \<longrightarrow>
                  (\<forall>x\<in>the (rc x).
                      case x of
                      (v1, v2) \<Rightarrow>
                        \<exists>w1. NFA_accept (the (\<sigma> v1)) w1 \<and>
                             (\<exists>w2. NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2)))))) \<Longrightarrow>
       x \<in> dom rc \<Longrightarrow>
       (\<And>RC rm v a b.
           (\<And>v1 v2.
               (v1, v2) \<in> RC \<longrightarrow>
               v1 \<in> dom rm \<and> v2 \<in> dom rm \<and> NFA (the (rm v1)) \<and> NFA (the (rm v2))) \<Longrightarrow>
           NFA (the (rm v)) \<Longrightarrow>
           finite RC \<Longrightarrow>
           a \<noteq> b \<Longrightarrow>
           lang_var v RC rm a b
           \<le> SPEC (\<lambda>\<A>. NFA \<A> \<and>
                        (\<forall>w. NFA_accept \<A> w =
                             (NFA_accept (the (rm v)) w \<and>
                              (\<forall>x\<in>RC.
                                  case x of
                                  (v1, v2) \<Rightarrow>
                                    \<exists>w1. NFA_accept (the (rm v1)) w1 \<and>
                                         (\<exists>w2.
 NFA_accept (the (rm v2)) w2 \<and> w = w1 @ w2)))))) \<Longrightarrow>
       a \<noteq> b \<Longrightarrow>
       lang_var x (the (rc x)) \<sigma> a b
       \<le> SPEC (\<lambda>a. {rm'. new_language_map \<sigma> rm' x a}
                    \<subseteq> {rmi.
                        S \<subseteq> dom rmi \<and>
                        dom rmi = dom rm \<and>
                        (\<forall>v. v \<in> dom rmi \<longrightarrow> NFA (the (rmi v))) \<and>
                        (\<forall>v\<in>it - {x}. the (rmi v) = the (rm v)) \<and>
                        (\<forall>v. v \<notin> S \<longrightarrow> the (rmi v) = the (rm v)) \<and>
                        (\<forall>x\<in>S - (it - {x}).
                            NFA (the (rmi x)) \<and>
                            (\<forall>w. NFA_accept (the (rmi x)) w =
                                 (NFA_accept (the (rm x)) w \<and>
                                  (x \<in> dom rc \<longrightarrow>
                                   (\<forall>(v1, v2)\<in>the (rc x).
                                       \<exists>w1. NFA_accept (the (rmi v1)) w1 \<and>
(\<exists>w2. NFA_accept (the (rmi v2)) w2 \<and> w = w1 @ w2))))))})"
  proof -
  assume p1 : "x \<in> it" and
         p2 : "it \<subseteq> S" and
         p3 : "S \<subseteq> dom \<sigma> \<and>
    dom \<sigma> = dom rm \<and>
    (\<forall>v. v \<in> dom \<sigma> \<longrightarrow> NFA (the (\<sigma> v))) \<and>
    (\<forall>v\<in>it. the (\<sigma> v) = the (rm v)) \<and>
    (\<forall>v. v \<notin> S \<longrightarrow> the (\<sigma> v) = the (rm v)) \<and>
    (\<forall>x\<in>S - it.
        NFA (the (\<sigma> x)) \<and>
        (\<forall>w. NFA_accept (the (\<sigma> x)) w =
             (NFA_accept (the (rm x)) w \<and>
              (x \<in> dom rc \<longrightarrow>
               (\<forall>x\<in>the (rc x).
                   case x of
                   (v1, v2) \<Rightarrow>
                     \<exists>w1. NFA_accept (the (\<sigma> v1)) w1 \<and>
                          (\<exists>w2. NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2)))))) " and
       p31': "x \<in> dom rc" and
         p4: "(\<And>RC rm v a b.
        (\<And>v1 v2.
            (v1, v2) \<in> RC \<longrightarrow>
            v1 \<in> dom rm \<and> v2 \<in> dom rm \<and> NFA (the (rm v1)) \<and> NFA (the (rm v2))) \<Longrightarrow>
        NFA (the (rm v)) \<Longrightarrow>
        finite RC \<Longrightarrow>
        a \<noteq> b \<Longrightarrow>
        lang_var v RC rm a b
        \<le> SPEC (\<lambda>\<A>. NFA \<A> \<and>
                     (\<forall>w. NFA_accept \<A> w =
                          (NFA_accept (the (rm v)) w \<and>
                           (\<forall>x\<in>RC.
                               case x of
                               (v1, v2) \<Rightarrow>
                                 \<exists>w1. NFA_accept (the (rm v1)) w1 \<and>
                                      (\<exists>w2. NFA_accept (the (rm v2)) w2 \<and>
w = w1 @ w2))))))"
  from this have x_in_S: "x \<in> S" by auto
  from this finite_rc p31' have finite_RC: "finite (the (rc x))"
    by auto
  from p3 finite_rc finite_rm rm_dom have con1:
  "\<And>v1 v2.
      (v1, v2) \<in> the (rc x) \<longrightarrow>
      v1 \<in> dom \<sigma> \<and> v2 \<in> dom \<sigma> \<and> NFA (the (\<sigma> v1)) \<and> NFA (the (\<sigma> v2))"
    using x_in_S 
    using p31' by auto
  have con2: "NFA (the (\<sigma> x))"
    by (meson p3 subsetD x_in_S)
  note lang_var_correct' = lang_var_correct[OF con1 con2 finite_RC a_neq_b]
  from lang_var_correct' 
  have lang_var': "lang_var x (the (rc x)) \<sigma> a b
  \<le> SPEC (\<lambda>\<A>. \<forall>w. NFA \<A> \<and>
                   NFA_accept \<A> w =
                   (NFA_accept (the (\<sigma> x)) w \<and>
                    (\<forall>(v1, v2)\<in>the (rc x).
                        \<exists>w1 w2.
                           NFA_accept (the (\<sigma> v1)) w1 \<and>
                           NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2)))"
    by auto
  from p3 have "\<forall> v. v \<notin> S \<longrightarrow> the (\<sigma> v) = the (rm v)" by auto
      from this have "\<forall> v. v \<notin> S \<longrightarrow> 
              (\<forall> w. NFA_accept (the (\<sigma> v)) w = NFA_accept (the (rm v)) w)"
        by simp
      from this acyc[of x] have "x \<in> dom rc \<longrightarrow> (\<forall> (v1, v2) \<in> (the (rc x)). 
              (\<forall> w1. NFA_accept (the (\<sigma> v1)) w1 = NFA_accept (the (rm v1)) w1) \<and>
              (\<forall> w2. NFA_accept (the (\<sigma> v2)) w2 = NFA_accept (the (rm v2)) w2))"
        using x_in_S by blast
  have "SPEC (\<lambda>\<A>. \<forall>w. NFA \<A> \<and>
                   NFA_accept \<A> w =
                   (NFA_accept (the (\<sigma> x)) w \<and>
                    (\<forall>(v1, v2)\<in>the (rc x).
                        \<exists>w1 w2.
                           NFA_accept (the (\<sigma> v1)) w1 \<and>
                           NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2))) \<le>
        SPEC (\<lambda>a. {rm'. new_language_map \<sigma> rm' x a}
                 \<subseteq> {rmi.
                     S \<subseteq> dom rmi \<and>
                     dom rmi = dom rm \<and>
                     (\<forall>v. v \<in> dom rmi \<longrightarrow> NFA (the (rmi v))) \<and>
                     (\<forall>v\<in>it - {x}. the (rmi v) = the (rm v)) \<and>
                     (\<forall>v. v \<notin> S \<longrightarrow> the (rmi v) = the (rm v)) \<and>
                     (\<forall>x\<in>S - (it - {x}).
                         NFA (the (rmi x)) \<and>
                         (\<forall>w. NFA_accept (the (rmi x)) w =
                              (NFA_accept (the (rm x)) w \<and>
                               (x \<in> dom rc \<longrightarrow>
                               (\<forall>(v1, v2)\<in>the (rc x).
                                   \<exists>w1. NFA_accept (the (rmi v1)) w1 \<and>
                                        (\<exists>w2.
NFA_accept (the (rmi v2)) w2 \<and> w = w1 @ w2))))))})"
   apply simp
   apply (rule_tac subsetI)
  proof -
    fix xa
    show "xa \<in> {\<A>. NFA \<A> \<and>
                    (\<forall>w. NFA_accept \<A> w =
                         (NFA_accept (the (\<sigma> x)) w \<and>
                          (\<forall>(v1, v2)\<in>the (rc x).
                              \<exists>w1. NFA_accept (the (\<sigma> v1)) w1 \<and>
                                   (\<exists>w2. NFA_accept (the (\<sigma> v2)) w2 \<and>
                                         w = w1 @ w2))))} \<Longrightarrow>
          xa \<in> {a. {rm'. new_language_map \<sigma> rm' x a}
                    \<subseteq> {rmi.
                        S \<subseteq> dom rmi \<and>
                        dom rmi = dom rm \<and>
                        (\<forall>v. v \<in> dom rmi \<longrightarrow> NFA (the (rmi v))) \<and>
                        (\<forall>v\<in>it - {x}. the (rmi v) = the (rm v)) \<and>
                        (\<forall>v. v \<notin> S \<longrightarrow> the (rmi v) = the (rm v)) \<and>
                        (\<forall>x\<in>S - (it - {x}).
                            NFA (the (rmi x)) \<and>
                            (\<forall>w. NFA_accept (the (rmi x)) w =
                                 (NFA_accept (the (rm x)) w \<and> (x \<in> dom rc \<longrightarrow>
                                  (\<forall>(v1, v2)\<in>the (rc x).
                                      \<exists>w1. NFA_accept (the (rmi v1)) w1 \<and>
                                           (\<exists>w2.
   NFA_accept (the (rmi v2)) w2 \<and> w = w1 @ w2))))))}}"
    proof 
    assume p11: "xa \<in> {\<A>. NFA \<A> \<and>
                    (\<forall>w. NFA_accept \<A> w =
                         (NFA_accept (the (\<sigma> x)) w \<and>
                          (\<forall>(v1, v2)\<in>the (rc x).
                              \<exists>w1. NFA_accept (the (\<sigma> v1)) w1 \<and>
                                   (\<exists>w2. NFA_accept (the (\<sigma> v2)) w2 \<and>
                                         w = w1 @ w2))))}"
    show "{rm'. new_language_map \<sigma> rm' x xa}
    \<subseteq> {rmi.
        S \<subseteq> dom rmi \<and>
        dom rmi = dom rm \<and>
        (\<forall>v. v \<in> dom rmi \<longrightarrow> NFA (the (rmi v))) \<and>
        (\<forall>v\<in>it - {x}. the (rmi v) = the (rm v)) \<and>
        (\<forall>v. v \<notin> S \<longrightarrow> the (rmi v) = the (rm v)) \<and>
        (\<forall>x\<in>S - (it - {x}).
            NFA (the (rmi x)) \<and>
            (\<forall>w. NFA_accept (the (rmi x)) w =
                 (NFA_accept (the (rm x)) w \<and> (x \<in> dom rc \<longrightarrow>
                  (\<forall>(v1, v2)\<in>the (rc x).
                      \<exists>w1. NFA_accept (the (rmi v1)) w1 \<and>
                           (\<exists>w2. NFA_accept (the (rmi v2)) w2 \<and> w = w1 @ w2))))))}"
      apply (simp add: new_language_map_def)
      apply (rule subsetI)
    proof
      fix xb
      assume p21: "xb \<in> {rm'.
                dom \<sigma> = dom rm' \<and>
                (\<forall>v'. v' \<noteq> x \<longrightarrow> (\<forall>a'. (\<sigma> v' = Some a') = (rm' v' = Some a'))) \<and>
                rm' x = Some xa}"
      from this have 
          "(\<forall>v'. v' \<noteq> x \<longrightarrow> (\<forall>a'. (\<sigma> v' = Some a') = (xb v' = Some a'))) \<and>
                xb x = Some xa"
        by auto
      from p21 have "dom \<sigma> = dom xb" 
          by auto
      have z5: "(\<forall> xc\<in> S - (it - {x}).
              NFA (the (xb xc)) \<and>
              (\<forall>w. NFA_accept (the (xb xc)) w =
                   (NFA_accept (the (rm xc)) w \<and> (xc \<in> dom rc \<longrightarrow>
                    (\<forall>xa\<in>the (rc xc).
                        case xa of
                        (v1, v2) \<Rightarrow>
                          \<exists>w1. NFA_accept (the (xb v1)) w1 \<and>
                               (\<exists>w2. NFA_accept (the (xb v2)) w2 \<and> w = w1 @ w2))))))"
      proof 
        fix xc
        assume p31: "xc \<in> S - (it - {x})"
        from p3 this have cc1: "xc \<in> S - (it - {x})"
          by auto
        have cc2: "x \<in> S"
          using \<open>x \<in> S\<close> by blast
        from cc1 cc2 have cc3: "(xc \<in> S - it \<and> xc \<noteq> x) \<or> xc = x"
          by fastforce
        from p3  have cc4: "(xc \<in> S - it \<and> xc \<noteq> x) \<longrightarrow> NFA (the (xb xc)) \<and>
          (\<forall>w. NFA_accept (the (xb xc)) w =
               (NFA_accept (the (rm xc)) w \<and> (xc \<in> dom rc \<longrightarrow>
                (\<forall>x\<in>the (rc xc).
                    case x of
                    (v1, v2) \<Rightarrow>
                      \<exists>w1. NFA_accept (the (xb v1)) w1 \<and>
                           (\<exists>w2. NFA_accept (the (xb v2)) w2 \<and> w = w1 @ w2)))))"
   proof 
    show "xc \<in> S - it \<and> xc \<noteq> x \<longrightarrow>
    NFA (the (xb xc)) \<and>
    (\<forall>w. NFA_accept (the (xb xc)) w =
         (NFA_accept (the (rm xc)) w \<and> (xc \<in> dom rc \<longrightarrow>
          (\<forall>x\<in>the (rc xc).
              case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the (xb v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the (xb v2)) w2 \<and> w = w1 @ w2)))))"
      apply (rule impI)
    proof 
      assume p41: "xc \<in> S - it \<and> xc \<noteq> x"
      from this p3 
      have "NFA (the (\<sigma> xc))" by auto
      from this p41 p21 p31
      show "NFA (the (xb xc))"
        by (metis (mono_tags, lifting) \<open>(\<forall>v'. v' \<noteq> x \<longrightarrow> (\<forall>a'. (\<sigma> v' = Some a') = (xb v' = Some a'))) \<and> xb x = Some xa\<close> option.collapse) 
      from p41 p3
      have cp1: "
         \<forall>w. NFA_accept (the (\<sigma> xc)) w =
        (NFA_accept (the (rm xc)) w \<and>  (xc \<in> dom rc \<longrightarrow>
         (\<forall>x\<in>the (rc xc).
             case x of
             (v1, v2) \<Rightarrow>
               \<exists>w1. NFA_accept (the (\<sigma> v1)) w1 \<and>
                    (\<exists>w2. NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2))))
      "
        by auto
      from p21 p41
      have rc_xc_OK: "\<And> w. NFA_accept (the (\<sigma> xc)) w = NFA_accept (the (xb xc)) w"
        by (metis (no_types, lifting) \<open>(\<forall>v'. v' \<noteq> x \<longrightarrow> (\<forall>a'. (\<sigma> v' = Some a') = (xb v' = Some a'))) \<and> xb x = Some xa\<close> option.collapse)
      have rc_xc_OK1: "xc \<in> dom rc \<longrightarrow> (\<forall> (v1, v2) \<in> (the (rc xc)). v1 \<noteq> x \<and> v2 \<noteq> x)"
        by (metis (full_types, lifting) Diff_iff 
            acyc case_prod_conv p41 surj_pair x_in_S)
      have rc_xc_OK2: "xc \<in> dom rc  \<longrightarrow> (\<forall> (v1, v2) \<in> (the (rc xc)). 
              (\<forall> w1. NFA_accept (the (\<sigma> v1)) w1 = NFA_accept (the (xb v1)) w1) \<and>
              (\<forall> w2. NFA_accept (the (\<sigma> v2)) w2 = NFA_accept (the (xb v2)) w2))"
      proof
        
        assume p111: "xc \<in> dom rc"
        show "\<forall>(v1, v2)\<in>the (rc xc).
       (\<forall>w1. NFA_accept (the (\<sigma> v1)) w1 = NFA_accept (the (xb v1)) w1) \<and>
       (\<forall>w2. NFA_accept (the (\<sigma> v2)) w2 = NFA_accept (the (xb v2)) w2)"
        proof 
          fix x
          assume p112: "x \<in> the (rc xc)"
        obtain v1 v2 where "x = (v1,v2)" 
          by fastforce
        from this show  "case x of
         (v1, v2) \<Rightarrow>
           (\<forall>w1. NFA_accept (the (\<sigma> v1)) w1 = NFA_accept (the (xb v1)) w1) \<and>
           (\<forall>w2. NFA_accept (the (\<sigma> v2)) w2 = NFA_accept (the (xb v2)) w2)"
          apply simp
          using rc_xc_OK1 p21
          apply simp
          by (metis (no_types, lifting) DiffD1 acyc domD p111 p112 p3 p41 rm_dom x_in_S)
       qed qed
       
      from rc_xc_OK2 rc_xc_OK cp1 p31
      show "\<forall>w. NFA_accept (the (xb xc)) w =
        (NFA_accept (the (rm xc)) w \<and> (xc \<in> dom rc \<longrightarrow>
         (\<forall>x\<in>the (rc xc).
             case x of
             (v1, v2) \<Rightarrow>
               \<exists>w1. NFA_accept (the (xb v1)) w1 \<and>
                    (\<exists>w2. NFA_accept (the (xb v2)) w2 \<and> w = w1 @ w2))))"
        apply (rule_tac allI)
      proof -
        fix w
        from cp1 p31'
        have t1: "NFA_accept (the (\<sigma> xc)) w =
            (NFA_accept (the (rm xc)) w \<and> (xc \<in> dom rc \<longrightarrow>
         (\<forall>x\<in>the (rc xc). 
             case x of
             (v1, v2) \<Rightarrow>
               \<exists>w1. NFA_accept (the (\<sigma> v1)) w1 \<and>
                    (\<exists>w2. NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2))))"
          by simp
        have t4: "NFA_accept (the (\<sigma> xc)) w = NFA_accept (the (xb xc)) w"
          by (simp add: rc_xc_OK)
        from rc_xc_OK2 have t3: "(xc \<in> dom rc \<longrightarrow> (\<forall>x\<in>the (rc xc).
         case x of
         (v1, v2) \<Rightarrow>
           \<exists>w1. NFA_accept (the (\<sigma> v1)) w1 \<and>
                (\<exists>w2. NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2))) = 
          (xc \<in> dom rc \<longrightarrow> (\<forall>x\<in>the (rc xc).
              case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the (xb v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the (xb v2)) w2 \<and> w = w1 @ w2)))"
          by fastforce
        from  t3 t4 cp1
        show "NFA_accept (the (xb xc)) w =
         (NFA_accept (the (rm xc)) w \<and> (xc \<in> dom rc \<longrightarrow>
          (\<forall>x\<in>the (rc xc).
              case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the (xb v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the (xb v2)) w2 \<and> w = w1 @ w2))))"
          by simp       
    qed
  qed qed
  
  have cc5: "(xc = x) \<longrightarrow> NFA (the (xb xc)) \<and>
          (\<forall>w. NFA_accept (the (xb xc)) w =
               (NFA_accept (the (rm xc)) w \<and> (xc \<in> dom rc \<longrightarrow>
                (\<forall>x\<in>the (rc xc).
                    case x of
                    (v1, v2) \<Rightarrow>
                      \<exists>w1. NFA_accept (the (xb v1)) w1 \<and>
                           (\<exists>w2. NFA_accept (the (xb v2)) w2 \<and> w = w1 @ w2)))))"
  proof
    assume p51: "xc = x"
    from this p21 have ccc2: "the (xb xc) = xa" by auto
    from this p11 p31' have ccc1: "
      NFA xa \<and> (\<forall>w. NFA_accept xa w =
                         (NFA_accept (the (\<sigma> x)) w \<and> (x \<in> dom rc \<longrightarrow>
                          (\<forall>(v1, v2)\<in>the (rc x).
                              \<exists>w1. NFA_accept (the (\<sigma> v1)) w1 \<and>
                                   (\<exists>w2. NFA_accept (the (\<sigma> v2)) w2 \<and>
                                         w = w1 @ w2)))))" by auto
    from p1 p3 ccc1
    have cccc1: "\<forall> w. (NFA_accept (the (\<sigma> x)) w) = (NFA_accept (the (rm x)) w)"
      by simp

    have cccc2: "\<forall> w. (NFA_accept (the (xb x)) w) \<longrightarrow> (NFA_accept (the (\<sigma> x)) w)"
      using ccc1 ccc2 p51 by blast
    have rc_xc_OK1: "xc \<in> dom rc \<longrightarrow> (\<forall> (v1, v2) \<in> (the (rc xc)). v1 \<noteq> x \<and> v2 \<noteq> x)"
      using acyc p51 x_in_S by blast
    have rc_xc_OK2: "xc \<in> dom rc \<longrightarrow> (\<forall> (v1, v2) \<in> (the (rc xc)). 
              (\<forall> w1. NFA_accept (the (\<sigma> v1)) w1 = NFA_accept (the (xb v1)) w1) \<and>
              (\<forall> w2. NFA_accept (the (\<sigma> v2)) w2 = NFA_accept (the (xb v2)) w2))"
    proof
      assume p110: "xc \<in> dom rc"
      show "\<forall>(v1, v2)\<in>the (rc xc).
       (\<forall>w1. NFA_accept (the (\<sigma> v1)) w1 = NFA_accept (the (xb v1)) w1) \<and>
       (\<forall>w2. NFA_accept (the (\<sigma> v2)) w2 = NFA_accept (the (xb v2)) w2)"
      proof
        fix x
        assume p111: "x \<in> the (rc xc)"
        obtain v1 v2 where "x = (v1,v2)" 
          by fastforce
        from this show  "case x of
         (v1, v2) \<Rightarrow>
           (\<forall>w1. NFA_accept (the (\<sigma> v1)) w1 = NFA_accept (the (xb v1)) w1) \<and>
           (\<forall>w2. NFA_accept (the (\<sigma> v2)) w2 = NFA_accept (the (xb v2)) w2)"
          apply simp
          using rc_xc_OK1 p21
          apply simp
          by (metis (no_types, lifting) acyc con1 domD p110 p111 p51 x_in_S)
       qed qed
       (*from rc_xc_OK2 ccc1 ccc2 cccc1*) 
       show "NFA (the (xb xc)) \<and>
    (\<forall>w. NFA_accept (the (xb xc)) w =
         (NFA_accept (the (rm xc)) w \<and> (xc \<in> dom rc \<longrightarrow>
          (\<forall>x\<in>the (rc xc).
              case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the (xb v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the (xb v2)) w2 \<and> w = w1 @ w2)))))"
      apply (rule_tac conjI)
      apply (simp add: ccc1 ccc2)
       proof
         thm rc_xc_OK2 ccc1 ccc2 cccc1
         fix w
         show "NFA_accept (the (xb xc)) w =
         (NFA_accept (the (rm xc)) w \<and> (xc \<in> dom rc \<longrightarrow>
          (\<forall>x\<in>the (rc xc).
              case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the (xb v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the (xb v2)) w2 \<and> w = w1 @ w2))))"          
         proof -
           from ccc1 have "NFA_accept xa w =
       (NFA_accept (the (\<sigma> x)) w \<and> (x \<in> dom rc \<longrightarrow>
        (\<forall>(v1, v2)\<in>the (rc x).
            \<exists>w1. NFA_accept (the (\<sigma> v1)) w1 \<and>
                 (\<exists>w2. NFA_accept (the (\<sigma> v2)) w2 \<and> w = w1 @ w2))))"
             by auto
           from this cccc1 ccc2 rc_xc_OK2 p51 show ?thesis
             apply simp
             by fastforce
  qed qed qed

  from this cc4 show   " xc \<in> S - (it - {x}) \<Longrightarrow>
          NFA (the (xb xc)) \<and>
          (\<forall>w. NFA_accept (the (xb xc)) w =
               (NFA_accept (the (rm xc)) w \<and> (xc \<in> dom rc \<longrightarrow>
                (\<forall>xa\<in>the (rc xc).
                    case xa of
                    (v1, v2) \<Rightarrow>
                      \<exists>w1. NFA_accept (the (xb v1)) w1 \<and>
                           (\<exists>w2. NFA_accept (the (xb v2)) w2 \<and> w = w1 @ w2)))))"
    by fastforce
qed
  from this have z2: "NFA (the (xb x))"
    by (simp add: x_in_S)
  from this p21 p3 have z3: "\<forall>v. v \<in> dom xb \<longrightarrow> NFA (the (xb v))"
    apply (rule_tac allI)
  proof -
    fix v
    show "v \<in> dom xb \<longrightarrow> NFA (the (xb v))"
    proof (cases "v = x")
      case True
      assume "v = x"
      then show ?thesis 
        using \<open>NFA (the (xb x))\<close> by auto
    next
      case False
      assume "v \<noteq> x"
      from this p21 p3 z2
      have k1: "the (xb v) = the (\<sigma> v)"
        by (metis (no_types, hide_lams) \<open>(\<forall>v'. v' \<noteq> x \<longrightarrow> (\<forall>a'. (\<sigma> v' = Some a') = (xb v' = Some a'))) \<and> xb x = Some xa\<close> option.exhaust)
      have "x \<in> S" 
      using x_in_S by blast
      from this k1 p3 show ?thesis
        by (simp add: \<open>dom \<sigma> = dom xb\<close>)
    qed qed
    have "x \<in> S" 
      using x_in_S by blast
    from this p21 p3
    have "\<forall>v. v \<notin> S \<longrightarrow> the (xb v) = the (rm v)"
      by (metis (full_types, hide_lams) 
                 \<open>(\<forall>v'. v' \<noteq> x \<longrightarrow> (\<forall>a'. (\<sigma> v' = Some a') = (xb v' = Some a'))) \<and> 
                 xb x = Some xa\<close> option.exhaust)        
    from this z3 z5 show "S \<subseteq> dom xb \<and>
          dom xb = dom rm \<and>
          (\<forall>v. v \<in> dom xb \<longrightarrow> NFA (the (xb v))) \<and>
          (\<forall>v\<in>it - {x}. the (xb v) = the (rm v)) \<and>
          (\<forall>v. v \<notin> S \<longrightarrow> the (xb v) = the (rm v)) \<and>
          (\<forall>xa\<in>S - (it - {x}).
           NFA (the (xb xa)) \<and>
           (\<forall>w. NFA_accept (the (xb xa)) w =
           (NFA_accept (the (rm xa)) w \<and> (xa \<in> dom rc \<longrightarrow>
           (\<forall>xa\<in>the (rc xa).
            case xa of (v1, v2) \<Rightarrow>
            \<exists>w1. NFA_accept (the (xb v1)) w1 \<and>
           (\<exists>w2. NFA_accept (the (xb v2)) w2 \<and> w = w1 @ w2))))))"
    apply (rule_tac conjI)
    using \<open>dom \<sigma> = dom xb\<close> p3 apply auto[1]
    apply (rule_tac conjI)
    using \<open>dom \<sigma> = dom xb\<close> p3 apply auto[1]
    apply (rule_tac conjI)
    apply simp
    apply (rule_tac conjI)
    apply (metis (no_types, lifting) DiffD1 Diff_insert_absorb \<open>(\<forall>v'. v' \<noteq> x \<longrightarrow> (\<forall>a'. (\<sigma> v' = Some a') = (xb v' = Some a'))) \<and> xb x = Some xa\<close> domD mk_disjoint_insert p3 subset_eq)
    apply (rule_tac conjI)
    apply simp
    by simp
qed qed qed
    
  from this lang_var'
  show "lang_var x (the (rc x)) \<sigma> a b
    \<le> SPEC (\<lambda>a. {rm'. new_language_map \<sigma> rm' x a}
                 \<subseteq> {rmi.
                     S \<subseteq> dom rmi \<and>
                     dom rmi = dom rm \<and>
                     (\<forall>v. v \<in> dom rmi \<longrightarrow> NFA (the (rmi v))) \<and>
                     (\<forall>v\<in>it - {x}. the (rmi v) = the (rm v)) \<and>
                     (\<forall>v. v \<notin> S \<longrightarrow> the (rmi v) = the (rm v)) \<and>
                     (\<forall>x\<in>S - (it - {x}).
                         NFA (the (rmi x)) \<and>
                         (\<forall>w. NFA_accept (the (rmi x)) w =
                              (NFA_accept (the (rm x)) w \<and> (x \<in> dom rc \<longrightarrow>
                               (\<forall>(v1, v2)\<in>the (rc x).
                                   \<exists>w1. NFA_accept (the (rmi v1)) w1 \<and>
                                        (\<exists>w2.
NFA_accept (the (rmi v2)) w2 \<and> w = w1 @ w2))))))})"
    using order_trans by blast
qed}qed

definition closureR where
  "closureR R rc = (\<forall> v v1 v2. v \<in> R \<and> v \<in> dom rc \<and> (v1,v2) \<in> (the (rc v)) \<longrightarrow> v1 \<in> R \<and> v2 \<in> R)"
  
definition Forward_Analysis where
  "Forward_Analysis S rc rm a b = 
   WHILEIT 
      (\<lambda> (S1, rm1, R). S = S1 \<union> R \<and> S1 \<inter> R = {} \<and>
                  dom rc \<subseteq> S \<and>
                  dom rm = S \<and>
                  dom rm1 = S \<and> 
                  closureR R rc \<and>
                  (\<forall> v. v \<in> dom rm1 \<longrightarrow> NFA (the (rm1 v))) \<and>
                  (\<forall> v \<in> S1. (the (rm1 v)) = (the (rm v))) \<and>  
                  (\<forall> x \<in> S - S1. NFA (the (rm1 x)) \<and> (\<forall> w.
                  (NFA_accept (the (rm1 x)) w \<longleftrightarrow>
                   NFA_accept (the (rm x)) w \<and> (x \<in> dom rc \<longrightarrow>
                  (\<forall> (v1,v2) \<in> (the (rc x)).\<exists> w1 w2. 
                      NFA_accept (the (rm1 v1)) w1 \<and>
                      NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2))))))
      (\<lambda> (S1, rm1, R). S1 \<noteq> {}) (\<lambda> (S1, rm1, R). do {
       S' \<leftarrow> compute_ready_set_abstract S1 rc R; 
      rm' \<leftarrow> language_vars S' rc rm1 a b;
   RETURN (S1 - S', rm', R \<union> S')}) (S, rm, {})"


lemma wf_finite_psubset[simp]: "wf finite_psubset"
  apply (unfold finite_psubset_def)
  apply (rule wf_measure [THEN wf_subset])
  apply (simp add: measure_def inv_image_def less_than_def less_eq)
  apply (fast elim!: psubset_card_mono)
  done


definition finite_fwr where
   "finite_fwr = {((a, b, c), (d, e, f)). (a, d) \<in> finite_psubset}"


lemma wf_finite_fwr: "wf finite_fwr"
  unfolding finite_fwr_def
  using wf_finite_psubset
  apply simp
  apply (rule wf_measure [THEN wf_subset])
  apply (simp add: measure_def inv_image_def less_than_def less_eq)
  apply (subgoal_tac "{((a, b, c), (d, ab)). a \<subset> d \<and> finite d} \<subseteq> {(x, y). 
             (\<lambda> (a, b, c). card a) x < (\<lambda> (a, b, c). card a) y}")
  apply assumption
proof 
  fix x 
  show "x \<in> {((a, b, c), d, ab). a \<subset> d \<and> finite d} \<Longrightarrow>
         x \<in> {(x, y). (case x of (a, b, c) \<Rightarrow> card a) < 
  (case y of (a, b, c) \<Rightarrow> card a)}"
  proof -
  assume p1: "x \<in> {((a, b, c), d, ab). a \<subset> d \<and> finite d}"
  from p1 obtain a b c d ab where
  "x = ((a, b, c), d, ab) \<and> a \<subset> d \<and> finite d"
    by blast
  from this
  show "x \<in> {(x, y). (case x of (a, b, c) \<Rightarrow> card a) < 
                     (case y of (a, b, c) \<Rightarrow> card a)}"
    apply simp
    by (simp add: psubset_card_mono)
qed qed
  

lemma Forward_analysis_correct:
  assumes rm_v_OK: "\<And> v. v \<in> dom rm \<longrightarrow> NFA (the (rm v))"
      and rc_OK: "dom rc \<subseteq> S \<and> (\<forall> v \<in> S. v \<in> dom rc \<longrightarrow> finite (the (rc v)))"
      and ran_rc1: "\<forall> v1 v2 x . x \<in> dom rc \<and> (v1, v2) \<in> the (rc x) \<longrightarrow> 
                                 v1 \<in> S \<and> v2 \<in> S"
      and rm_OK: "S = dom rm"
      and S_ok: "\<exists> l. S = \<Union> (set l) \<and> acyclic rc l"
      and finite_S: "finite S"
      and a_neq_b : "a \<noteq> b"
  shows "Forward_Analysis S rc rm a b \<le> 
         SPEC (\<lambda> (S', rm1, R'). 
                      S' = {} \<and> 
                      S = S' \<union> R' \<and>
                      S' \<inter> R' = {} \<and>
                      dom rm1 = dom rm \<and> 
                      (\<forall> v \<in> S. \<forall> w. NFA (the (rm1 v)) \<and> 
                      ((NFA_accept (the (rm1 v)) w) \<longleftrightarrow>   
                       (NFA_accept (the (rm v)) w) \<and> (v \<in> dom rc \<longrightarrow>
                       (\<forall> (v1, v2) \<in> (the (rc v)). \<exists> w1 w2.
                       NFA_accept (the (rm1 v1)) w1 \<and> 
                       NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2)))))"
  
  unfolding Forward_Analysis_def
  apply (refine_vcg)
  defer
  apply simp
  apply simp  
  using rc_OK 
  apply (simp add: rc_OK)
  apply (simp add: rm_OK)
  apply (simp add: rm_OK)
  apply (insert rm_v_OK)[1]
  apply (simp add: closureR_def)
  apply (insert rm_v_OK)[1]
  apply simp
  apply (insert rm_v_OK)[1]
  apply simp
  apply (insert closureR_def)[1]
  apply fastforce
  defer
  apply fastforce
  apply fastforce
  apply fastforce
  apply auto[1]
  defer
  apply (subgoal_tac "wf finite_fwr")
  apply assumption
  using wf_finite_fwr
  apply simp
   defer
  apply auto[1]
  apply simp
  apply (rename_tac S' ba rm1 R)
  defer
  
proof -
  fix s S' ba rm1 R
  assume p0: "
       S = S' \<union> R \<and>
       S' \<inter> R = {} \<and>
       dom rc \<subseteq> S \<and>
       dom rm = S \<and>
       dom rm1 = S \<and>
       closureR R rc \<and>
       (\<forall>v. v \<in> dom rm1 \<longrightarrow> NFA (the (rm1 v))) \<and>
       (\<forall>v\<in>S'. the (rm1 v) = the (rm v)) \<and>
       (\<forall>x\<in>S - S'.
           NFA (the (rm1 x)) \<and>
           (\<forall>w. NFA_accept (the (rm1 x)) w =
                (NFA_accept (the (rm x)) w \<and>
                 (x \<in> dom rc \<longrightarrow>
                  (\<forall>x\<in>the (rc x).
                      case x of
                      (v1, v2) \<Rightarrow>
                        \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
                             (\<exists>w2. NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2))))))"  
        and
        p12: "S' \<noteq> {}" and
        p02: "s = (S', rm1, R)" and
        p03: "ba = (rm1, R)"

  from this have p04: "s = (S', rm1, R)" by simp
  
  from p0  have p1:  
      "S = S' \<union> R \<and>
       S' \<inter> R = {} \<and>
       dom rc \<subseteq> S \<and>
       dom rm = S \<and>
       dom rm1 = S \<and>
       (\<forall>v v1 v2. v \<in> R \<longrightarrow> v \<in> dom rc \<longrightarrow> (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<in> R \<and> v2 \<in> R) \<and>
       (\<forall>v. v \<in> dom rm1 \<longrightarrow> NFA (the (rm1 v))) \<and>
       (\<forall>v\<in>S'. the (rm1 v) = the (rm v)) \<and>
       (\<forall>x\<in>S - S'.
           NFA (the (rm1 x)) \<and>
           (\<forall>w. NFA_accept (the (rm1 x)) w =
                (NFA_accept (the (rm x)) w \<and> (x \<in> dom rc \<longrightarrow>
                 (\<forall>x\<in>the (rc x).
                     case x of
                     (v1, v2) \<Rightarrow>
                       \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
                            (\<exists>w2. NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2))))))" 
    apply (insert p0[unfolded closureR_def])
    by meson
  from this finite_S have finite_S': "finite S'"
    by simp
  from p1 have domrc: "dom rc \<subseteq> S' \<union> R"
     by auto
  from p1 finite_S have S_sub_rc: "finite (dom rc)" 
    by (meson finite_subset)
  from rc_OK have finite_rc_x: "(\<And>x.  x \<in> dom rc \<longrightarrow>finite (the (rc x)))"
    by fastforce
  have ppre1: "finite S' \<and> S' \<noteq> {}"
    using finite_S' p12 by blast
   from p0 S_ok
   have ppre2: "S = S' \<union> R \<and> S' \<inter> R = {} \<and> (\<exists>l. S = \<Union> (set l) \<and> 
                 Forward_Analysis.acyclic rc l)"
     by blast
   from compute_ready_set_abstract_nempty[of S' S R rc, OF ppre1 ppre2]
       ran_rc1 rc_OK
   have compute_ready_set_correct: 
        "compute_ready_set_abstract S' rc R
            \<le> SPEC (\<lambda>S. S \<subseteq> S' \<and>
               S \<noteq> {} \<and>
               (\<forall>v v1 v2.
                   v \<in> S \<and> rc v \<noteq> None \<and>  
                  (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<in> R \<and> v2 \<in> R))"
     using S_sub_rc by blast
  from this  have 
    "SPEC (\<lambda>S. S \<subseteq> S' \<and>
               S \<noteq> {} \<and>
               (\<forall>v v1 v2.
                   v \<in> S \<and> rc v \<noteq> None \<and>  
                  (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<in> R \<and> v2 \<in> R))
      \<le> SPEC (\<lambda>S'a. language_vars S'a rc rm1 a b \<bind>
                      (\<lambda>rm'. RETURN (S' - S'a, rm', R \<union> S'a))
                      \<le> SPEC (\<lambda>s'. (case s' of
                                     (S1, rm1, Ra) \<Rightarrow>
                                       S' \<union> R = S1 \<union> Ra \<and>
                                       S1 \<inter> Ra = {} \<and>
                                       dom rc \<subseteq> S' \<union> R \<and>
                                       dom rm1 = S' \<union> R \<and>
                                       closureR Ra rc \<and>
                                       (\<forall>v. v \<in> dom rm1 \<longrightarrow> NFA (the (rm1 v))) \<and>
                                       (\<forall>v\<in>S1. the (rm1 v) = the (rm v)) \<and>
                                       (\<forall>x\<in>S' \<union> R - S1.
                                           NFA (the (rm1 x)) \<and>
                                           (\<forall>w.
   NFA_accept (the (rm1 x)) w =
   (NFA_accept (the (rm x)) w \<and>
    (x \<in> dom rc \<longrightarrow>
     (\<forall>(v1, v2)\<in>the (rc x).
         \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
              (\<exists>w2. NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2))))))) \<and>
                                    (s', S', rm1, R) \<in> finite_fwr))"
    apply simp
    apply (simp add: subset_iff)
  proof 
    fix t
    show "(\<forall>ta. ta \<in> t \<longrightarrow> ta \<in> S') \<and>
         t \<noteq> {} \<and>
         (\<forall>v v1 v2.
             v \<in> t \<and> (\<exists>y. rc v = Some y) \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
             v1 \<in> R \<and> v2 \<in> R) \<longrightarrow>
         language_vars t rc rm1 a b \<bind> (\<lambda>rm'. RETURN (S' - t, rm', R \<union> t))
         \<le> SPEC (\<lambda>s'. (case s' of
                        (S1, rm1, Ra) \<Rightarrow>
                          S' \<union> R = S1 \<union> Ra \<and>
                          S1 \<inter> Ra = {} \<and>
                          (\<forall>t. t \<in> dom rc \<longrightarrow> t \<in> S' \<or> t \<in> R) \<and>
                          dom rm1 = S' \<union> R \<and>
                          closureR Ra rc \<and>
                          (\<forall>v. v \<in> dom rm1 \<longrightarrow> NFA (the (rm1 v))) \<and>
                          (\<forall>v\<in>S1. the (rm1 v) = the (rm v)) \<and>
                          (\<forall>x\<in>S' \<union> R - S1.
                              NFA (the (rm1 x)) \<and>
                              (\<forall>w. NFA_accept (the (rm1 x)) w =
                                   (NFA_accept (the (rm x)) w \<and>
                                    (x \<in> dom rc \<longrightarrow>
                                     (\<forall>x\<in>the (rc x).
                                         case x of
                                         (v1, v2) \<Rightarrow>
                                           \<exists>w1.
  NFA_accept (the (rm1 v1)) w1 \<and>
  (\<exists>w2. NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2))))))) \<and>
                       (s', S', rm1, R) \<in> finite_fwr)"
      apply (rule impI)+
  proof -
    assume p31: "(\<forall>ta. ta \<in> t \<longrightarrow> ta \<in> S') \<and>
    t \<noteq> {} \<and>
    (\<forall>v v1 v2.
        v \<in> t \<and> (\<exists>y. rc v = Some y) \<and> 
        (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<in> R \<and> v2 \<in> R)"
    show "language_vars t rc rm1 a b \<bind> (\<lambda>rm'. RETURN (S' - t, rm', R \<union> t))
    \<le> SPEC (\<lambda>s'. (case s' of
                   (S1, rm1, Ra) \<Rightarrow>
                     S' \<union> R = S1 \<union> Ra \<and>
                     S1 \<inter> Ra = {} \<and>
                     (\<forall>t. t \<in> dom rc \<longrightarrow> t \<in> S' \<or> t \<in> R) \<and>
                     dom rm1 = S' \<union> R \<and>
                     closureR Ra rc \<and>
                     (\<forall>v. v \<in> dom rm1 \<longrightarrow> NFA (the (rm1 v))) \<and>
                     (\<forall>v\<in>S1. the (rm1 v) = the (rm v)) \<and>
                     (\<forall>x\<in>S' \<union> R - S1.
                         NFA (the (rm1 x)) \<and>
                         (\<forall>w. NFA_accept (the (rm1 x)) w =
                              (NFA_accept (the (rm x)) w \<and>
                               (x \<in> dom rc \<longrightarrow>
                                (\<forall>x\<in>the (rc x).
                                    case x of
                                    (v1, v2) \<Rightarrow>
                                      \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
                                           (\<exists>w2.
   NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2))))))) \<and>
                  (s', S', rm1, R) \<in> finite_fwr)"
    proof -
      from p31 have tmp1: "t \<subseteq> S'" by fastforce
      from p31 p1 this
      have t1: "(\<And>v v1 v2. v \<in> t \<and> (\<exists>y. rc v = Some y) \<and> (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<notin> t \<and> v2 \<notin> t)"
        by (meson disjoint_iff_not_equal)
      have t2: "(\<And>v v1 v2.
          v \<in> t \<and> (\<exists>y. rc v = Some y) \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
          v1 \<in> dom rm1 \<and> v2 \<in> dom rm1 \<and> NFA (the (rm1 v1)) \<and> NFA (the (rm1 v2)))"
      proof 
        fix v v1 v2       
        assume pt1: "v \<in> t \<and> (\<exists>y. rc v = Some y) \<and> (v1, v2) \<in> the (rc v)"
        from p1 have "R \<subseteq> S"
          by blast
        from this pt1 p31 
        have "v1 \<in> S \<and> v2 \<in> S"
          by blast
        from this p1 
        show "v1 \<in> dom rm1 \<and> v2 \<in> dom rm1 \<and> NFA (the (rm1 v1)) \<and> NFA (the (rm1 v2))"
          by metis
      qed
      from p1 have t3: "(\<And>v. v \<in> dom rm1 \<longrightarrow> NFA (the (rm1 v)))"
        by metis
      thm language_vars_correct
      from p1 tmp1 finite_S rc_OK 
      have t4: "finite (dom rc) \<and> (\<forall>v\<in>t.  v \<in> dom rc \<longrightarrow> finite (the (rc v)))"
        using S_sub_rc by blast
      from p1 tmp1  have t5: "t \<subseteq> dom rm1"
        using t4 by auto
      from p1 this have t6: "finite t"
        by (meson \<open>t \<subseteq> S'\<close> finite_S' infinite_super)
      from t1
      have t1' : "\<And> v v1 v2. v \<in> t \<and>  v \<in> dom rc \<and> 
                  (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<notin> t \<and> v2 \<notin> t" 
        using t4 by blast

      

      from  t2
      have t2': 
        "\<And> v v1 v2. v \<in> t  \<and> v \<in> dom rc \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
         v1 \<in> dom rm1 \<and> v2 \<in> dom rm1 \<and> NFA (the (rm1 v1)) \<and> NFA (the (rm1 v2))" 
        by (meson domD subset_iff t4)
      note language_vars_correct' = 
           language_vars_correct[of t rc rm1 a b, OF t1' t2' t3 t4 t5 t6 a_neq_b]
      from this 
      show "language_vars t rc rm1 a b \<bind> (\<lambda>rm'. RETURN (S' - t, rm', R \<union> t))
    \<le> SPEC (\<lambda>s'. (case s' of
                   (S1, rm1, Ra) \<Rightarrow>
                     S' \<union> R = S1 \<union> Ra \<and>
                     S1 \<inter> Ra = {} \<and>
                     (\<forall>t. t \<in> dom rc \<longrightarrow> t \<in> S' \<or> t \<in> R) \<and>
                     dom rm1 = S' \<union> R \<and>
                     closureR Ra rc \<and>
                     (\<forall>v. v \<in> dom rm1 \<longrightarrow> NFA (the (rm1 v))) \<and>
                     (\<forall>v\<in>S1. the (rm1 v) = the (rm v)) \<and>
                     (\<forall>x\<in>S' \<union> R - S1.
                         NFA (the (rm1 x)) \<and>
                         (\<forall>w. NFA_accept (the (rm1 x)) w =
                              (NFA_accept (the (rm x)) w \<and>
                               (x \<in> dom rc \<longrightarrow>
                                (\<forall>x\<in>the (rc x).
                                    case x of
                                    (v1, v2) \<Rightarrow>
                                      \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
                                           (\<exists>w2.
   NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2))))))) \<and>
                  (s', S', rm1, R) \<in> finite_fwr)"
        apply (intro refine_vcg)
      proof -
        have "SPEC (\<lambda>rm1a. dom rm1a = dom rm1 \<and>
                    (\<forall>v. v \<notin> t \<longrightarrow> the (rm1a v) = the (rm1 v)) \<and>
                    (\<forall>v\<in>t. \<forall>w. NFA (the (rm1a v)) \<and>
                                NFA_accept (the (rm1a v)) w =
                                (NFA_accept (the (rm1 v)) w \<and>
                                 (v \<in> dom rc \<longrightarrow>
                                 (\<forall>(v1, v2)\<in>the (rc v).
                                     \<exists>w1 w2.
                                        NFA_accept (the (rm1 v1)) w1 \<and>
                                        NFA_accept (the (rm1 v2)) w2 \<and>
                                        w = w1 @ w2))))) \<le>
              SPEC (\<lambda>rm'. RETURN (S' - t, rm', R \<union> t)
                   \<le> SPEC (\<lambda>s'. (case s' of
                                  (S1, rm1, Ra) \<Rightarrow>
                                    S' \<union> R = S1 \<union> Ra \<and>
                                    S1 \<inter> Ra = {} \<and>
                                    (\<forall>t. t \<in> dom rc \<longrightarrow> t \<in> S' \<or> t \<in> R) \<and>
                                    dom rm1 = S' \<union> R \<and>
                                    closureR Ra rc \<and>
                                    (\<forall>v. v \<in> dom rm1 \<longrightarrow> NFA (the (rm1 v))) \<and>
                                    (\<forall>v\<in>S1. the (rm1 v) = the (rm v)) \<and>
                                    (\<forall>x\<in>S' \<union> R - S1.
                                        NFA (the (rm1 x)) \<and>
                                        (\<forall>w.
NFA_accept (the (rm1 x)) w =
(NFA_accept (the (rm x)) w \<and>
 (x \<in> dom rc \<longrightarrow>
  (\<forall>x\<in>the (rc x).
      case x of
      (v1, v2) \<Rightarrow>
        \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
             (\<exists>w2. NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2))))))) \<and>
                                 (s', S', rm1, R) \<in> finite_fwr))"
          apply simp
          apply (simp add: subset_iff)
          apply (rule allI impI) +
          apply (rule conjI)
          using Un_assoc \<open>t \<subseteq> S'\<close> apply auto[1]
          apply (rule conjI)
          using p1 apply blast
          apply (rule conjI)
          using p1 apply blast
          apply (rule conjI)
          unfolding closureR_def
          using p1 p31 
          apply (metis Un_iff domD)
          apply (rule conjI)
          using p1 
          apply (metis Un_iff domD p31)
          defer
          apply (rule conjI)
          apply (metis t3)
          apply (rule conjI)  
          using p0 apply blast
          apply (rule conjI)
        proof 
          { 
          fix ta x
          assume pu1: "dom ta = dom rm1 \<and>
                       (\<forall>v. v \<notin> t \<longrightarrow> the (ta v) = the (rm1 v)) \<and>
                       (\<forall>v \<in> t. NFA (the (ta v)) \<and>
               (\<forall>w. NFA_accept (the (ta v)) w =
                    (NFA_accept (the (rm1 v)) w \<and> (v \<in> dom rc \<longrightarrow>
                     (\<forall>x\<in>the (rc v).
                         case x of
                         (v1, v2) \<Rightarrow>
                           \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
                                (\<exists>w2. NFA_accept (the (rm1 v2)) w2 \<and>
                                      w = w1 @ w2))))))" and
                 pu2: "x \<in> S' \<union> R - (S' - t)"
          from pu2 have "x \<in> R \<union> t"
            by blast
          from p1 have "R \<inter> t = {}" 
            by (metis Int_empty_right inf.absorb_iff1 inf_sup_aci(1) inf_sup_aci(3) tmp1)
          from this have "R - t = R" by auto
          from p1 pu1 this have c0: "x \<in> R  \<longrightarrow> the (ta x) = the (rm1 x)"
            by (metis DiffD2)
          from pu1 have cco1: "(\<forall>v. v \<in> R \<longrightarrow> the (ta v) = the (rm1 v))"
            using \<open>R - t = R\<close> by auto
          from p1 have c1: 
          "(\<forall> x \<in> R. NFA (the (rm1 x)) \<and>
           (\<forall>w. NFA_accept (the (rm1 x)) w =
           (NFA_accept (the (rm x)) w \<and>  (x \<in> dom rc \<longrightarrow>
            (\<forall>x\<in>the (rc x).
                case x of
                (v1, v2) \<Rightarrow>
                  \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
                       (\<exists>w2. NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2))))))"
            by (metis (no_types, lifting) Diff_iff Un_Diff_Int Un_iff sup_bot.right_neutral)
          from this have c2: "(x \<in> R \<longrightarrow> NFA (the (rm1 x)) \<and>
           (\<forall>w. NFA_accept (the (rm1 x)) w =
           (NFA_accept (the (rm x)) w \<and>  (x \<in> dom rc \<longrightarrow>
            (\<forall>x\<in>the (rc x).
                case x of
                (v1, v2) \<Rightarrow>
                  \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
                       (\<exists>w2. NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2))))))"
            by force
          from p1 c0 have c3: "x \<in> R \<longrightarrow> NFA (the (ta x))"
            by (metis c2)
          from p1 have "S' \<inter> R = {}" by simp
          from p1 this have c31: "t \<inter> R = {}" 
            using tmp1 by auto
          have c4:
             "x \<in> R \<longrightarrow> NFA (the (ta x)) \<and>
                (\<forall>w. NFA_accept (the (ta x)) w =
                 (NFA_accept (the (rm x)) w \<and>  (x \<in> dom rc \<longrightarrow>
                  (\<forall>x\<in>the (rc x).
                   case x of
                    (v1, v2) \<Rightarrow>
                      \<exists>w1. NFA_accept (the (ta v1)) w1 \<and>
                        (\<exists>w2. NFA_accept (the (ta v2)) w2 \<and> w = w1 @ w2)))))"
          proof 
            assume pi1: "x \<in> R"
            from this c2 have "
                NFA (the (rm1 x)) \<and>
           (\<forall>w. NFA_accept (the (rm1 x)) w =
           (NFA_accept (the (rm x)) w \<and>  (x \<in> dom rc \<longrightarrow>
            (\<forall>x\<in>the (rc x).
                case x of
                (v1, v2) \<Rightarrow>
                  \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
                       (\<exists>w2. NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2)))))"
              by simp
            have cc1: "the (ta x) = the (rm1 x)"
              using c0 pi1 by linarith

            from c2 have cc2: " NFA (the (rm1 x)) \<and>
    (\<forall>w. NFA_accept (the (rm1 x)) w =
         (NFA_accept (the (rm x)) w \<and>  (x \<in> dom rc \<longrightarrow>
          (\<forall>x\<in>the (rc x).
              case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2)))))"
              using pi1 by auto
            from pi1 p1 have x1: 
             "\<forall>v1 v2. x \<in> dom rc \<and> (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<in> R \<and> v2 \<in> R"
              by blast
          show "
          NFA (the (ta x)) \<and>
              (\<forall>w. NFA_accept (the (ta x)) w =
         (NFA_accept (the (rm x)) w \<and>  (x \<in> dom rc \<longrightarrow>
          (\<forall>x\<in>the (rc x).
              case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the (ta v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the (ta v2)) w2 \<and> w = w1 @ w2)))))"
           apply (rule_tac conjI)
           using x1 pi1 cc1 cc2 cco1 
            apply simp
         proof 
           fix w
           from x1 pi1 cc1 cc2 cco1
           have "(x \<in> dom rc \<longrightarrow>
           (\<forall>x\<in>the (rc x).
               case x of
               (v1, v2) \<Rightarrow>
                 \<exists>w1. NFA_accept (the (ta v1)) w1 \<and>
                      (\<exists>w2. NFA_accept (the (ta v2)) w2 \<and> w = w1 @ w2))) = 
             (x \<in> dom rc \<longrightarrow>
           (\<forall>x\<in>the (rc x).
               case x of
               (v1, v2) \<Rightarrow>
                 \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
                      (\<exists>w2. NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2)))"
             using case_prodD case_prodI2
             by (smt case_prodD case_prodI2)
           from this x1 pi1 cc1 cc2 cco1
          show "NFA_accept (the (ta x)) w =
         (NFA_accept (the (rm x)) w \<and>
          (x \<in> dom rc \<longrightarrow>
           (\<forall>x\<in>the (rc x).
               case x of
               (v1, v2) \<Rightarrow>
                 \<exists>w1. NFA_accept (the (ta v1)) w1 \<and>
                      (\<exists>w2. NFA_accept (the (ta v2)) w2 \<and> w = w1 @ w2))))"
            by simp 
       qed qed

       from tmp1 have "x \<in> t \<longrightarrow> x \<in> S'" by fastforce 
       from this p0 have cco3: "x \<in> t \<longrightarrow> the (rm1 x) = the (rm x)"
         by blast

       

       from p31 
       have p31': "(\<forall>ta. ta \<in> t \<longrightarrow> ta \<in> S') \<and>
             (\<forall>v v1 v2. v \<in> t  \<and> v \<in> dom rc \<and>
             (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<in> R \<and> v2 \<in> R)"
         using t4 by blast

       from p1 have cco4: "x \<in> t \<and> x \<in> dom rc \<longrightarrow> (\<forall> v1 v2. (v1, v2) \<in> (the (rc x)) 
              \<longrightarrow> v1 \<in> R \<and> v2 \<in> R)"
         using p31' by blast 

       have c5:
             "x \<in> t \<longrightarrow> NFA (the (ta x)) \<and>
                (\<forall>w. NFA_accept (the (ta x)) w =
                 (NFA_accept (the (rm x)) w \<and> (x \<in> dom rc \<longrightarrow>
                  (\<forall>x\<in>the (rc x).
                   case x of
                    (v1, v2) \<Rightarrow>
                      \<exists>w1. NFA_accept (the (ta v1)) w1 \<and>
                        (\<exists>w2. NFA_accept (the (ta v2)) w2 \<and> w = w1 @ w2)))))"
       proof 
         assume prem1: "x \<in> t"
         from this pu1 
         have "NFA (the (ta x))" by simp
         from pu1 have cco2: "NFA (the (ta x)) \<and>
          (\<forall>w. NFA_accept (the (ta x)) w =
               (NFA_accept (the (rm1 x)) w \<and> (x \<in> dom rc \<longrightarrow>
                (\<forall>x\<in>the (rc x).
                    case x of
                    (v1, v2) \<Rightarrow>
                      \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
                           (\<exists>w2. NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2)))))"
           using \<open>x \<in> t\<close> by auto
        from pu1 have cco1: "(\<forall>v. v \<in> R \<longrightarrow> the (ta v) = the (rm1 v))"
            using \<open>R - t = R\<close> by auto
         from this prem1 cco2 cco3 cco4 have "(\<forall>w. NFA_accept (the (ta x)) w =
         (NFA_accept (the (rm x)) w \<and> (x \<in> dom rc \<longrightarrow>
          (\<forall>x\<in>the (rc x).
              case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the (ta v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the (ta v2)) w2 \<and> w = w1 @ w2)))))"
           by fastforce
         from this show "NFA (the (ta x)) \<and>
    (\<forall>w. NFA_accept (the (ta x)) w =
         (NFA_accept (the (rm x)) w \<and> (x \<in> dom rc \<longrightarrow>
          (\<forall>x\<in>the (rc x).
              case x of
              (v1, v2) \<Rightarrow>
                \<exists>w1. NFA_accept (the (ta v1)) w1 \<and>
                     (\<exists>w2. NFA_accept (the (ta v2)) w2 \<and> w = w1 @ w2)))))"
           using \<open>NFA (the (ta x))\<close> by blast
       qed
    
       from c4 c5 show "NFA (the (ta x)) \<and>
       (\<forall>w. NFA_accept (the (ta x)) w =
            (NFA_accept (the (rm x)) w \<and> (x \<in> dom rc \<longrightarrow>
             (\<forall>x\<in>the (rc x).
                 case x of
                 (v1, v2) \<Rightarrow>
                   \<exists>w1. NFA_accept (the (ta v1)) w1 \<and>
                        (\<exists>w2. NFA_accept (the (ta v2)) w2 \<and> w = w1 @ w2)))))"
         using \<open>x \<in> R \<union> t\<close> by auto
     } 
     {
       fix ta
       from p31
       have "t \<noteq> {} \<and> t \<subseteq> S'"
         by blast
       from this have "S' - t \<subset> S'"
         by blast
       from this finite_S'
       show "((S' - t, ta, R \<union> t), S', rm1, R) \<in> finite_fwr"
         unfolding finite_fwr_def finite_psubset_def
         by blast 
     }
     qed 
     from this show "language_vars t rc rm1 a b
    \<le> SPEC (\<lambda>rm'. RETURN (S' - t, rm', R \<union> t)
                   \<le> SPEC (\<lambda>s'. (case s' of
                                  (S1, rm1, Ra) \<Rightarrow>
                                    S' \<union> R = S1 \<union> Ra \<and>
                                    S1 \<inter> Ra = {} \<and>
                                    (\<forall>t. t \<in> dom rc \<longrightarrow> t \<in> S' \<or> t \<in> R) \<and>
                                    dom rm1 = S' \<union> R \<and>
                                    closureR Ra rc \<and>
                                    (\<forall>v. v \<in> dom rm1 \<longrightarrow> NFA (the (rm1 v))) \<and>
                                    (\<forall>v\<in>S1. the (rm1 v) = the (rm v)) \<and>
                                    (\<forall>x\<in>S' \<union> R - S1.
                                        NFA (the (rm1 x)) \<and>
                                        (\<forall>w.
NFA_accept (the (rm1 x)) w =
(NFA_accept (the (rm x)) w \<and>
 (x \<in> dom rc \<longrightarrow>
  (\<forall>x\<in>the (rc x).
      case x of
      (v1, v2) \<Rightarrow>
        \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
             (\<exists>w2. NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2))))))) \<and>
                                 (s', S', rm1, R) \<in> finite_fwr))"
       using SPEC_trans language_vars_correct' by blast
   qed qed qed qed
  
   from this compute_ready_set_correct  domrc
   show "compute_ready_set_abstract S' rc R
       \<le> SPEC (\<lambda>S'a. language_vars S'a rc rm1 a b \<bind>
                      (\<lambda>rm'. RETURN (S' - S'a, rm', R \<union> S'a))
                      \<le> SPEC (\<lambda>s'. (case s' of
                                     (S1, rm1, Ra) \<Rightarrow>
                                       S' \<union> R = S1 \<union> Ra \<and>
                                       S1 \<inter> Ra = {} \<and>
                                       dom rc \<subseteq> S' \<union> R \<and>
                                       dom rm1 = S' \<union> R \<and>
                                       closureR Ra rc \<and>
                                       (\<forall>v. v \<in> dom rm1 \<longrightarrow> NFA (the (rm1 v))) \<and>
                                       (\<forall>v\<in>S1. the (rm1 v) = the (rm v)) \<and>
                                       (\<forall>x\<in>S' \<union> R - S1.
                                           NFA (the (rm1 x)) \<and>
                                           (\<forall>w.
   NFA_accept (the (rm1 x)) w =
   (NFA_accept (the (rm x)) w \<and>
    (x \<in> dom rc \<longrightarrow>
     (\<forall>(v1, v2)\<in>the (rc x).
         \<exists>w1. NFA_accept (the (rm1 v1)) w1 \<and>
              (\<exists>w2. NFA_accept (the (rm1 v2)) w2 \<and> w = w1 @ w2))))))) \<and>
                                    (s', S', rm1, R) \<in> finite_fwr))"
     using SPEC_trans 
     by fastforce
 qed
  



definition sat_pred where
  "sat_pred S rc rm = (
    \<exists> ag. (\<forall> v \<in> S. (ag v \<in> \<L> (the (rm v)))) \<and> (\<forall> v1 v2 v. v \<in> dom rc \<and> (v1,v2) \<in> the (rc v) \<longrightarrow> 
          (ag v) = (ag v1) @ (ag v2) \<and> (ag v1) \<in> \<L> (the (rm v1)) \<and>(ag v2) \<in> \<L> (the (rm v2))) 
   )"

definition sat_pred_as where
  "sat_pred_as S rc rm ag = (
    (\<forall> v \<in> S. (ag v \<in> \<L> (the (rm v)))) \<and> (\<forall> v1 v2 v. v \<in> dom rc \<and> (v1,v2) \<in> the (rc v) \<longrightarrow> 
          (ag v) = (ag v1) @ (ag v2) \<and> (ag v1) \<in> \<L> (the (rm v1)) \<and>(ag v2) \<in> \<L> (the (rm v2))) 
   )"

lemma acyclic_dep2 [simp]: 
  "acyclic rc (a # l) \<longrightarrow> 
    (\<forall> v v1 v2. v \<in> a \<and> v \<in> dom rc \<and> (v1,v2) \<in> the (rc v) \<longrightarrow> 
          v1 \<in> \<Union> (set l) \<and>  v2 \<in> \<Union> (set l))"
  using Forward_Analysis.acyclic.simps
  by metis


definition comp_indegree_v  where
  "comp_indegree_v v rc =
   (if ((rc v) \<noteq> None) then 
   FOREACHi (\<lambda> s1 l.  (\<forall> v1 v2. 
                       (v1,v2) \<in> the (rc v) - s1 \<longrightarrow> v1 \<in> set l \<and> v2 \<in> set l) \<and>
                      (distinct l \<longrightarrow> 
                      (\<forall> v1 v2. (v1, v2) \<in> the (rc v) - s1 \<longrightarrow> v1 \<noteq> v2) \<and>
                      (\<forall> v1 v2 v3 v4. (v1, v2) \<in> the (rc v) - s1 \<and>
                                      (v3, v4) \<in> the (rc v) - s1 \<and> 
                         (v1,v2) \<noteq> (v3,v4) \<longrightarrow> {v1,v2} \<inter> {v3,v4} = {})))
           {e. e \<in> the (rc v)} 
           (\<lambda> (v1, v2) L. RETURN (v1 # v2 # L)) []
    else 
        RETURN []
    )"

lemma comp_indegree_v_correct:
  assumes rc_OK : "v \<in> dom rc \<and> finite (the (rc v))"
  shows "comp_indegree_v v rc \<le> 
   SPEC (\<lambda> l. (\<forall> v1 v2. 
                       (v1,v2) \<in> the (rc v) \<longrightarrow> v1 \<in> set l \<and> v2 \<in> set l) \<and>
              (distinct l \<longrightarrow> 
              (\<forall> v1 v2. (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<in> set l \<and> v2 \<in> set l) \<and>
              (\<forall> v1 v2. (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<noteq> v2) \<and>
              (\<forall> v1 v2 v3 v4. (v1, v2) \<in> the (rc v) \<and>
                              (v3, v4) \<in> the (rc v) \<and> 
               (v1,v2) \<noteq> (v3,v4) \<longrightarrow> {v1,v2} \<inter> {v3,v4} = {})))"
  unfolding comp_indegree_v_def
  apply (intro refine_vcg)
  using rc_OK apply simp
  using rc_OK apply simp
  defer
  apply blast
  using rc_OK apply blast
proof -
  fix x it \<sigma>
  assume p1: "rc v \<noteq> None"
     and p2: "x \<in> it"
     and p3: "it \<subseteq> {e. e \<in> the (rc v)}"
     and p4: "(\<forall>v1 v2. (v1, v2) \<in> the (rc v) - it \<longrightarrow> v1 \<in> set \<sigma> \<and> v2 \<in> set \<sigma>) \<and>
       (distinct \<sigma> \<longrightarrow>
        (\<forall>v1 v2. (v1, v2) \<in> the (rc v) - it \<longrightarrow> v1 \<noteq> v2) \<and>
        (\<forall>v1 v2 v3 v4.
            (v1, v2) \<in> the (rc v) - it \<and>
            (v3, v4) \<in> the (rc v) - it \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
            {v1, v2} \<inter> {v3, v4} = {}))"
  from this obtain v1 v2 where v1v2_def: "x = (v1,v2)" 
    by (meson surj_pair)
  from v1v2_def p1 p2 p3 p4
  have "(case x of (v1, v2) \<Rightarrow> \<lambda>L. RETURN (v1 # v2 # L)) \<sigma> = 
         (\<lambda>L. RETURN (v1 # v2 # L)) \<sigma>"
    by auto
  from this
  show "(case x of (v1, v2) \<Rightarrow> \<lambda>L. RETURN (v1 # v2 # L)) \<sigma>
       \<le> SPEC (\<lambda>l. (\<forall>v1 v2.
                        (v1, v2) \<in> the (rc v) - (it - {x}) \<longrightarrow>
                        v1 \<in> set l \<and> v2 \<in> set l) \<and>
                    (distinct l \<longrightarrow>
                     (\<forall>v1 v2. (v1, v2) \<in> the (rc v) - (it - {x}) \<longrightarrow> v1 \<noteq> v2) \<and>
                     (\<forall>v1 v2 v3 v4.
                         (v1, v2) \<in> the (rc v) - (it - {x}) \<and>
                         (v3, v4) \<in> the (rc v) - (it - {x}) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
                         {v1, v2} \<inter> {v3, v4} = {})))"
    using v1v2_def apply simp
  proof -
    show "(\<forall>v1a v2a.
        (v1a, v2a) \<in> the (rc v) \<and> ((v1a, v2a) \<in> it \<longrightarrow> v1a = v1 \<and> v2a = v2) \<longrightarrow>
        (v1a = v1 \<or> v1a = v2 \<or> v1a \<in> set \<sigma>) \<and> (v2a = v1 \<or> v2a = v2 \<or> v2a \<in> set \<sigma>)) \<and>
    (v1 \<noteq> v2 \<and> v1 \<notin> set \<sigma> \<and> v2 \<notin> set \<sigma> \<and> distinct \<sigma> \<longrightarrow>
     (\<forall>v1a v2a.
         (v1a, v2a) \<in> the (rc v) \<and> ((v1a, v2a) \<in> it \<longrightarrow> v1a = v1 \<and> v2a = v2) \<longrightarrow>
         v1a \<noteq> v2a) \<and>
     (\<forall>v1a v2a v3 v4.
         (v1a, v2a) \<in> the (rc v) \<and>
         ((v1a, v2a) \<in> it \<longrightarrow> v1a = v1 \<and> v2a = v2) \<and>
         (v3, v4) \<in> the (rc v) \<and>
         ((v3, v4) \<in> it \<longrightarrow> v3 = v1 \<and> v4 = v2) \<and> (v1a = v3 \<longrightarrow> v2a \<noteq> v4) \<longrightarrow>
         v3 \<noteq> v1a \<and> v3 \<noteq> v2a \<and> v4 \<noteq> v1a \<and> v4 \<noteq> v2a))"
      apply (rule conjI)
      using p4 apply blast
      apply (rule_tac impI)
    proof -
      assume p5: "v1 \<noteq> v2 \<and> v1 \<notin> set \<sigma> \<and> v2 \<notin> set \<sigma> \<and> distinct \<sigma>"
      show "(\<forall>v1a v2a.
        (v1a, v2a) \<in> the (rc v) \<and> ((v1a, v2a) \<in> it \<longrightarrow> v1a = v1 \<and> v2a = v2) \<longrightarrow>
        v1a \<noteq> v2a) \<and>
    (\<forall>v1a v2a v3 v4.
        (v1a, v2a) \<in> the (rc v) \<and>
        ((v1a, v2a) \<in> it \<longrightarrow> v1a = v1 \<and> v2a = v2) \<and>
        (v3, v4) \<in> the (rc v) \<and>
        ((v3, v4) \<in> it \<longrightarrow> v3 = v1 \<and> v4 = v2) \<and> (v1a = v3 \<longrightarrow> v2a \<noteq> v4) \<longrightarrow>
        v3 \<noteq> v1a \<and> v3 \<noteq> v2a \<and> v4 \<noteq> v1a \<and> v4 \<noteq> v2a)"
        apply (rule conjI)
        using p4 p5 apply blast
        apply (rule allI)+
      proof 
        fix v1a v2a v3 v4
        assume p6: "(v1a, v2a) \<in> the (rc v) \<and>
       ((v1a, v2a) \<in> it \<longrightarrow> v1a = v1 \<and> v2a = v2) \<and>
       (v3, v4) \<in> the (rc v) \<and>
       ((v3, v4) \<in> it \<longrightarrow> v3 = v1 \<and> v4 = v2) \<and> (v1a = v3 \<longrightarrow> v2a \<noteq> v4)"
        from p5 p6 p1 p2 p3 p4
        show "v3 \<noteq> v1a \<and> v3 \<noteq> v2a \<and> v4 \<noteq> v1a \<and> v4 \<noteq> v2a"
          by blast
      qed qed qed qed

definition comp_indegree where
  "comp_indegree S rc = 
    FOREACHi
    (\<lambda> s1 l.  (\<forall> v1 v2 v. v \<in> dom rc \<and> v \<in> S - s1 \<and> 
                      (v1,v2) \<in> the (rc v) \<longrightarrow> v1 \<in> set l \<and> v2 \<in> set l) \<and>
                      (distinct l \<longrightarrow> 
                      (\<forall> v1 v2 v. v \<in> dom rc \<and> v \<in> S - s1 \<and>  
                                  (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<noteq> v2) \<and>
                      (\<forall> v1 v2 v3 v4 v.  v \<in>  dom rc \<and> v \<in> S - s1 \<and> 
                                            (v1, v2) \<in> the (rc v) \<and>
                                            (v3, v4) \<in> the (rc v) \<and> 
                         (v1,v2) \<noteq> (v3,v4) \<longrightarrow> {v1,v2} \<inter> {v3,v4} = {}) \<and> 
                      (\<forall> v1 v2 v3 v4 v v'.  v \<in> dom rc \<and> v \<in> S - s1 \<and>
                                            v' \<in> dom rc \<and> v' \<in> S - s1 \<and> v \<noteq> v' \<and>
                                            (v1, v2) \<in> the (rc v) \<and>
                                            (v3, v4) \<in> the (rc v')
                        \<longrightarrow> {v1,v2} \<inter> {v3,v4} = {})
                     )) 
    S
    (\<lambda> v l. do {
        l' \<leftarrow> comp_indegree_v v rc;
        RETURN (l' @ l)
    }) []
  "

lemma comp_indegree_correct:
  assumes rc_OK : "\<And> v. v \<in> dom rc  \<longrightarrow> finite (the (rc v))" and
          finite_S : "finite S"
  shows "comp_indegree S rc \<le> 
   SPEC (\<lambda> l. (distinct l \<longrightarrow> 
                      (\<forall> v1 v2 v. v \<in> dom rc \<and> v \<in> S \<and>  
                                  (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<noteq> v2) \<and>
                      (\<forall> v1 v2 v3 v4 v.  v \<in>  dom rc \<and> v \<in> S \<and> 
                                            (v1, v2) \<in> the (rc v) \<and>
                                            (v3, v4) \<in> the (rc v) \<and> 
                         (v1,v2) \<noteq> (v3,v4) \<longrightarrow> {v1,v2} \<inter> {v3,v4} = {}) \<and> 
                      (\<forall> v1 v2 v3 v4 v v'.  v \<in> dom rc \<and> v \<in> S \<and>
                                            v' \<in> dom rc \<and> v' \<in> S \<and> v \<noteq> v' \<and>
                                            (v1, v2) \<in> the (rc v) \<and>
                                            (v3, v4) \<in> the (rc v') \<longrightarrow> {v1,v2} \<inter> {v3,v4} = {})
                     ))"
  unfolding comp_indegree_def
  apply (intro refine_vcg)
  using finite_S apply simp
  apply blast
  defer
  apply blast
proof -
  fix x it \<sigma>
  assume p1: "x \<in> it"
     and p2: "it \<subseteq> S"
     and p3: "(\<forall>v1 v2 v.
           v \<in> dom rc \<and> v \<in> S - it \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
           v1 \<in> set \<sigma> \<and> v2 \<in> set \<sigma>) \<and>
       (distinct \<sigma> \<longrightarrow>
        (\<forall>v1 v2 v. v \<in> dom rc \<and> v \<in> S - it \<and> (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<noteq> v2) \<and>
        (\<forall>v1 v2 v3 v4 v.
            v \<in> dom rc \<and>
            v \<in> S - it \<and>
            (v1, v2) \<in> the (rc v) \<and> (v3, v4) \<in> the (rc v) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
            {v1, v2} \<inter> {v3, v4} = {}) \<and>
        (\<forall>v1 v2 v3 v4 v v'.
            v \<in> dom rc \<and>
            v \<in> S - it \<and>
            v' \<in> dom rc \<and>
            v' \<in> S - it \<and>
            v \<noteq> v' \<and>
            (v1, v2) \<in> the (rc v) \<and> (v3, v4) \<in> the (rc v')  \<longrightarrow>
            {v1, v2} \<inter> {v3, v4} = {}))"
  
  
  show "comp_indegree_v x rc
       \<le> SPEC (\<lambda>l'. RETURN (l' @ \<sigma>)
                     \<le> SPEC (\<lambda>l. (\<forall>v1 v2 v.
                                      v \<in> dom rc \<and>
                                      v \<in> S - (it - {x}) \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
                                      v1 \<in> set l \<and> v2 \<in> set l) \<and>
                                  (distinct l \<longrightarrow>
                                   (\<forall>v1 v2 v.
                                       v \<in> dom rc \<and>
                                       v \<in> S - (it - {x}) \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
                                       v1 \<noteq> v2) \<and>
                                   (\<forall>v1 v2 v3 v4 v.
                                       v \<in> dom rc \<and>
                                       v \<in> S - (it - {x}) \<and>
                                       (v1, v2) \<in> the (rc v) \<and>
                                       (v3, v4) \<in> the (rc v) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
                                       {v1, v2} \<inter> {v3, v4} = {}) \<and>
                                   (\<forall>v1 v2 v3 v4 v v'.
                                       v \<in> dom rc \<and>
                                       v \<in> S - (it - {x}) \<and>
                                       v' \<in> dom rc \<and>
                                       v' \<in> S - (it - {x}) \<and>
                                       v \<noteq> v' \<and>
                                       (v1, v2) \<in> the (rc v) \<and>
                                       (v3, v4) \<in> the (rc v') \<longrightarrow>
                                       {v1, v2} \<inter> {v3, v4} = {}))))"
  proof (cases "x \<notin> dom rc")
    case True
    from True have comp_indegree_v_emp: "comp_indegree_v x rc = RETURN []"
      unfolding comp_indegree_v_def
      by auto
    show ?thesis
      using comp_indegree_v_emp 
      apply simp
      apply (rule conjI)
      using p3 True apply blast
      apply (rule impI)
      apply (rule conjI)
      using p3 True apply blast
      apply (rule conjI)
      using p3 True apply blast
      using p3 True by blast
  next
    case False
    from this comp_indegree_v_correct[of x rc] finite_S rc_OK
    have c0: "comp_indegree_v x rc
    \<le> SPEC (\<lambda>l. (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<in> set l \<and> v2 \<in> set l) \<and>
                 (distinct l \<longrightarrow>
                  (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<in> set l \<and> v2 \<in> set l) \<and>
                  (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<noteq> v2) \<and>
                  (\<forall>v1 v2 v3 v4.
                      (v1, v2) \<in> the (rc x) \<and>
                      (v3, v4) \<in> the (rc x) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
                      {v1, v2} \<inter> {v3, v4} = {})))"
      by blast
    have "SPEC (\<lambda>l. (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<in> set l \<and> v2 \<in> set l) \<and>
               (distinct l \<longrightarrow>
                (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<in> set l \<and> v2 \<in> set l) \<and>
                (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<noteq> v2) \<and>
                (\<forall>v1 v2 v3 v4.
                    (v1, v2) \<in> the (rc x) \<and>
                    (v3, v4) \<in> the (rc x) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
                    {v1, v2} \<inter> {v3, v4} = {})))
    \<le> SPEC (\<lambda>l'. RETURN (l' @ \<sigma>)
                  \<le> SPEC (\<lambda>l. (\<forall>v1 v2 v.
                                   v \<in> dom rc \<and>
                                   v \<in> S - (it - {x}) \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
                                   v1 \<in> set l \<and> v2 \<in> set l) \<and>
                               (distinct l \<longrightarrow>
                                (\<forall>v1 v2 v.
                                    v \<in> dom rc \<and>
                                    v \<in> S - (it - {x}) \<and> (v1, v2) \<in> the (rc v) \<longrightarrow>
                                    v1 \<noteq> v2) \<and>
                                (\<forall>v1 v2 v3 v4 v.
                                    v \<in> dom rc \<and>
                                    v \<in> S - (it - {x}) \<and>
                                    (v1, v2) \<in> the (rc v) \<and>
                                    (v3, v4) \<in> the (rc v) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
                                    {v1, v2} \<inter> {v3, v4} = {}) \<and>
                                (\<forall>v1 v2 v3 v4 v v'.
                                    v \<in> dom rc \<and>
                                    v \<in> S - (it - {x}) \<and>
                                    v' \<in> dom rc \<and>
                                    v' \<in> S - (it - {x}) \<and>
                                    v \<noteq> v' \<and>
                                    (v1, v2) \<in> the (rc v) \<and>
                                    (v3, v4) \<in> the (rc v')  \<longrightarrow>
                                    {v1, v2} \<inter> {v3, v4} = {}))))"
      apply simp
    proof
      fix xa
      assume pp1: "xa \<in> {l. (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<in> set l \<and> v2 \<in> set l) \<and>
                   (distinct l \<longrightarrow>
                    (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<in> set l \<and> v2 \<in> set l) \<and>
                    (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<noteq> v2) \<and>
                    (\<forall>v1 v2 v3 v4.
                        (v1, v2) \<in> the (rc x) \<and>
                        (v3, v4) \<in> the (rc x) \<and> (v1 = v3 \<longrightarrow> v2 \<noteq> v4) \<longrightarrow>
                        v3 \<noteq> v1 \<and> v3 \<noteq> v2 \<and> v4 \<noteq> v1 \<and> v4 \<noteq> v2))}"
      from this have
      "(\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<in> set xa \<and> v2 \<in> set xa) \<and>
                   (distinct xa \<longrightarrow>
                    (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<in> set xa \<and> v2 \<in> set xa) \<and>
                    (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<noteq> v2) \<and>
                    (\<forall>v1 v2 v3 v4.
                        (v1, v2) \<in> the (rc x) \<and>
                        (v3, v4) \<in> the (rc x) \<and> (v1 = v3 \<longrightarrow> v2 \<noteq> v4) \<longrightarrow>
                        v3 \<noteq> v1 \<and> v3 \<noteq> v2 \<and> v4 \<noteq> v1 \<and> v4 \<noteq> v2))"
        by blast
      from this have
      "(\<forall>v1 v2. (\<exists>v. v \<in> dom rc \<and>
                 v \<in> S \<and> (v \<in> it \<longrightarrow> v = x) \<and> (v1, v2) \<in> the (rc v)) \<longrightarrow>
                         (v1 \<in> set xa \<or> v1 \<in> set \<sigma>) \<and> (v2 \<in> set xa \<or> v2 \<in> set \<sigma>)) \<and>
                     (distinct xa \<and> distinct \<sigma> \<and> set xa \<inter> set \<sigma> = {} \<longrightarrow>
                      (\<forall>v1 v2.
                          (\<exists>v. v \<in> dom rc \<and>
                               v \<in> S \<and> (v \<in> it \<longrightarrow> v = x) \<and> (v1, v2) \<in> the (rc v)) \<longrightarrow>
                          v1 \<noteq> v2) \<and>
                      (\<forall>v1 v2 v3 v4.
                          (\<exists>v. v \<in> dom rc \<and>
                               v \<in> S \<and>
                               (v \<in> it \<longrightarrow> v = x) \<and>
                               (v1, v2) \<in> the (rc v) \<and>
                               (v3, v4) \<in> the (rc v) \<and> (v1 = v3 \<longrightarrow> v2 \<noteq> v4)) \<longrightarrow>
                          v3 \<noteq> v1 \<and> v3 \<noteq> v2 \<and> v4 \<noteq> v1 \<and> v4 \<noteq> v2) \<and>
                      (\<forall>v1 v2 v3 v4.
                          (\<exists>v. v \<in> dom rc \<and>
                               v \<in> S \<and>
                               (v \<in> it \<longrightarrow> v = x) \<and>
                               (\<exists>v'. v' \<in> dom rc \<and>
                                     v' \<in> S \<and>
                                     (v' \<in> it \<longrightarrow> v' = x) \<and>
                                     v \<noteq> v' \<and>
                                     (v1, v2) \<in> the (rc v) \<and>
                                     (v3, v4) \<in> the (rc v'))) \<longrightarrow>
                          v3 \<noteq> v1 \<and> v3 \<noteq> v2 \<and> v4 \<noteq> v1 \<and> v4 \<noteq> v2))"
        apply (rule_tac conjI)
        apply (meson Diff_iff p3)
        apply (rule impI)
        apply (rule conjI)
        using p3
        apply (metis DiffI) 
        apply (rule conjI)
        apply (rule allI)+
        defer 
        apply (rule allI)+
        defer
      proof -
        {
          fix v1 v2 v3 v4
          assume pr1: " (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<in> set xa \<and> v2 \<in> set xa) \<and>
       (distinct xa \<longrightarrow>
        (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<in> set xa \<and> v2 \<in> set xa) \<and>
        (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<noteq> v2) \<and>
        (\<forall>v1 v2 v3 v4.
            (v1, v2) \<in> the (rc x) \<and> (v3, v4) \<in> the (rc x) \<and> (v1 = v3 \<longrightarrow> v2 \<noteq> v4) \<longrightarrow>
            v3 \<noteq> v1 \<and> v3 \<noteq> v2 \<and> v4 \<noteq> v1 \<and> v4 \<noteq> v2))"
             and pr2: "distinct xa \<and> distinct \<sigma> \<and> set xa \<inter> set \<sigma> = {}"
          from this 
          have c1: "(\<forall>v1 v2 v3 v4.
         (v1, v2) \<in> the (rc x) \<and> (v3, v4) \<in> the (rc x) \<and> (v1 = v3 \<longrightarrow> v2 \<noteq> v4) \<longrightarrow>
         v3 \<noteq> v1 \<and> v3 \<noteq> v2 \<and> v4 \<noteq> v1 \<and> v4 \<noteq> v2)"
            by blast
          from p3 pr2
          have c2: "(\<forall>v1 v2 v3 v4 v.
       v \<in> dom rc \<and>
       v \<in> S - it \<and>
       (v1, v2) \<in> the (rc v) \<and> (v3, v4) \<in> the (rc v) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
       {v1, v2} \<inter> {v3, v4} = {})"
            by blast
          from c1 c2
          show
          "(\<exists>v. v \<in> dom rc \<and>
            v \<in> S \<and>
            (v \<in> it \<longrightarrow> v = x) \<and>
            (v1, v2) \<in> the (rc v) \<and> (v3, v4) \<in> the (rc v) \<and> (v1 = v3 \<longrightarrow> v2 \<noteq> v4)) \<longrightarrow>
       v3 \<noteq> v1 \<and> v3 \<noteq> v2 \<and> v4 \<noteq> v1 \<and> v4 \<noteq> v2"
            by blast
        }

        {
          fix v1 v2 v3 v4
          assume pr1: "(\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<in> set xa \<and> v2 \<in> set xa) \<and>
       (distinct xa \<longrightarrow>
        (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<in> set xa \<and> v2 \<in> set xa) \<and>
        (\<forall>v1 v2. (v1, v2) \<in> the (rc x) \<longrightarrow> v1 \<noteq> v2) \<and>
        (\<forall>v1 v2 v3 v4.
            (v1, v2) \<in> the (rc x) \<and> (v3, v4) \<in> the (rc x) \<and> (v1 = v3 \<longrightarrow> v2 \<noteq> v4) \<longrightarrow>
            v3 \<noteq> v1 \<and> v3 \<noteq> v2 \<and> v4 \<noteq> v1 \<and> v4 \<noteq> v2))" and
          pr2: "distinct xa \<and> distinct \<sigma> \<and> set xa \<inter> set \<sigma> = {}"

          from pr2 p3
          have c1: "(\<forall>v1 v2 v3 v4 v v'.
         v \<in> dom rc \<and>
         v \<in> S - it \<and>
         v' \<in> dom rc \<and>
         v' \<in> S - it \<and>
         v \<noteq> v' \<and>
         (v1, v2) \<in> the (rc v) \<and> (v3, v4) \<in> the (rc v')  \<longrightarrow>
         {v1, v2} \<inter> {v3, v4} = {})"
            by blast
        
          show "(\<exists>v. v \<in> dom rc \<and>
            v \<in> S \<and>
            (v \<in> it \<longrightarrow> v = x) \<and>
            (\<exists>v'. v' \<in> dom rc \<and>
                  v' \<in> S \<and>
                  (v' \<in> it \<longrightarrow> v' = x) \<and>
                  v \<noteq> v' \<and>
                  (v1, v2) \<in> the (rc v) \<and>
                  (v3, v4) \<in> the (rc v') )) \<longrightarrow>
       v3 \<noteq> v1 \<and> v3 \<noteq> v2 \<and> v4 \<noteq> v1 \<and> v4 \<noteq> v2"
            apply (rule_tac impI)
          proof -
            assume pc2: "\<exists>v. v \<in> dom rc \<and>
        v \<in> S \<and>
        (v \<in> it \<longrightarrow> v = x) \<and>
        (\<exists>v'. v' \<in> dom rc \<and>
              v' \<in> S \<and>
              (v' \<in> it \<longrightarrow> v' = x) \<and>
              v \<noteq> v' \<and>
              (v1, v2) \<in> the (rc v) \<and>
              (v3, v4) \<in> the (rc v'))"
            from this obtain v v'
              where vv'_def: "v \<in> dom rc \<and>
              v \<in> S \<and>
             (v \<in> it \<longrightarrow> v = x) \<and>
             (v' \<in> dom rc \<and>
              v' \<in> S \<and>
              (v' \<in> it \<longrightarrow> v' = x) \<and>
              v \<noteq> v' \<and>
              (v1, v2) \<in> the (rc v) \<and>
              (v3, v4) \<in> the (rc v'))"
              by auto
            show "v3 \<noteq> v1 \<and> v3 \<noteq> v2 \<and> v4 \<noteq> v1 \<and> v4 \<noteq> v2"
            proof (cases "x \<noteq> v \<and> x \<noteq> v'")
              case True
              from this vv'_def c1
              show ?thesis 
                by blast
            next
              case False note xvv' = this
              then show ?thesis
              proof (cases "v = x")
                case True note vx = this
                show ?thesis 
                proof (cases "v' = x")
                  case True
                  from this vx xvv' have "v = x \<and> v' = x" by simp
                  from this pr1 vv'_def 
                  show ?thesis  by blast
                next
                  case False
                  from this vx xvv' have "v = x \<and> v' \<noteq> x" by simp
                  from this pr1 vv'_def pr1
                  show ?thesis 
                    by (metis DiffI disjoint_iff_not_equal p3 pr2)
                qed
next
  case False 
  from this xvv' have "v' = x \<and> v \<noteq> x" by auto
  from this pr1 vv'_def pr1
  show ?thesis by (metis DiffI disjoint_iff_not_equal p3 pr2)
qed qed qed 
} qed

  from this show "xa \<in> {l'. (\<forall>v1 v2.
                         (\<exists>v. v \<in> dom rc \<and>
                              v \<in> S \<and> (v \<in> it \<longrightarrow> v = x) \<and> (v1, v2) \<in> the (rc v)) \<longrightarrow>
                         (v1 \<in> set l' \<or> v1 \<in> set \<sigma>) \<and> (v2 \<in> set l' \<or> v2 \<in> set \<sigma>)) \<and>
                     (distinct l' \<and> distinct \<sigma> \<and> set l' \<inter> set \<sigma> = {} \<longrightarrow>
                      (\<forall>v1 v2.
                          (\<exists>v. v \<in> dom rc \<and>
                               v \<in> S \<and> (v \<in> it \<longrightarrow> v = x) \<and> (v1, v2) \<in> the (rc v)) \<longrightarrow>
                          v1 \<noteq> v2) \<and>
                      (\<forall>v1 v2 v3 v4.
                          (\<exists>v. v \<in> dom rc \<and>
                               v \<in> S \<and>
                               (v \<in> it \<longrightarrow> v = x) \<and>
                               (v1, v2) \<in> the (rc v) \<and>
                               (v3, v4) \<in> the (rc v) \<and> (v1 = v3 \<longrightarrow> v2 \<noteq> v4)) \<longrightarrow>
                          v3 \<noteq> v1 \<and> v3 \<noteq> v2 \<and> v4 \<noteq> v1 \<and> v4 \<noteq> v2) \<and>
                      (\<forall>v1 v2 v3 v4.
                          (\<exists>v. v \<in> dom rc \<and>
                               v \<in> S \<and>
                               (v \<in> it \<longrightarrow> v = x) \<and>
                               (\<exists>v'. v' \<in> dom rc \<and>
                                     v' \<in> S \<and>
                                     (v' \<in> it \<longrightarrow> v' = x) \<and>
                                     v \<noteq> v' \<and>
                                     (v1, v2) \<in> the (rc v) \<and>
                                     (v3, v4) \<in> the (rc v'))) \<longrightarrow>
                          v3 \<noteq> v1 \<and> v3 \<noteq> v2 \<and> v4 \<noteq> v1 \<and> v4 \<noteq> v2))}"
    by blast
qed
  from this c0
  show ?thesis
    using SPEC_trans by blast
qed qed

definition indegree where
"indegree S rc = do {
  res \<leftarrow> comp_indegree S rc;
  if distinct res then RETURN True else RETURN False
}"

definition uniq_indegree where
   "uniq_indegree rc = 
        ((\<forall> v1 v2 v. v \<in> dom rc \<and> (v1,v2) \<in> the (rc v) \<longrightarrow> v1 \<noteq> v2) \<and> 
         (\<forall> v1 v2 v3 v4 v. 
                 v \<in> dom rc \<and> (v1, v2) \<in> (the (rc v)) \<and> 
                (v3, v4) \<in> (the (rc v)) \<and> 
                (v1,v2) \<noteq> (v3,v4) \<longrightarrow> {v1,v2} \<inter> {v3,v4} = {}) \<and> 
        \<not>(\<exists> v v' v1 v2 v3 v4. v \<in> dom rc \<and> v' \<in> dom rc \<and> v \<noteq> v' \<and> 
          (v1, v2) \<in> (the (rc v)) \<and>
          (v3, v4) \<in> (the (rc v')) \<and> 
          ({v1, v2} \<inter> {v3, v4} \<noteq> {})))"

lemma comp_indegree_uniq:
  assumes rc_OK : "\<And> v. v \<in> dom rc  \<longrightarrow> finite (the (rc v))" and
          finite_S : "finite S \<and> dom rc \<subseteq> S" and
          indegree_T: "indegree S rc = RETURN True" and
          comp_ind: "RETURN l = comp_indegree S rc"
    shows "uniq_indegree rc"
proof -
  from indegree_T 
  have c0: "comp_indegree S rc \<le> SPEC (\<lambda> l. distinct l)"
    unfolding indegree_def
  proof -
    assume p1: "comp_indegree S rc \<bind> 
                (\<lambda>res. if distinct res then RETURN True else RETURN False) =
                RETURN True"
    from this bind_rule_complete[of "comp_indegree S rc" 
                              "(\<lambda>res. if distinct res then RETURN True else RETURN False)"
                              "\<lambda> t. t = True"]
    have c1:"(comp_indegree S rc
     \<le> SPEC (\<lambda>x. (if distinct x then RETURN True else RETURN False)
                  \<le> SPEC (\<lambda>t. t = True)))"
      by auto

    have "SPEC (\<lambda>x. (if distinct x then RETURN True else RETURN False)
                  \<le> SPEC (\<lambda>t. t = True)) \<le> SPEC (\<lambda> l. distinct l)"
      by simp
    from this c1
    show "comp_indegree S rc \<le> SPEC distinct"
      using SPEC_trans by blast qed

  from comp_indegree_correct[of rc S] finite_S rc_OK
  have c1: "comp_indegree S rc
    \<le> SPEC (\<lambda>l. distinct l \<longrightarrow>
                 (\<forall>v1 v2 v. v \<in> dom rc \<and> v \<in> S \<and> (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<noteq> v2) \<and>
                 (\<forall>v1 v2 v3 v4 v.
                     v \<in> dom rc \<and>
                     v \<in> S \<and>
                     (v1, v2) \<in> the (rc v) \<and>
                     (v3, v4) \<in> the (rc v) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
                     {v1, v2} \<inter> {v3, v4} = {}) \<and>
                 (\<forall>v1 v2 v3 v4 v v'.
                     v \<in> dom rc \<and>
                     v \<in> S \<and>
                     v' \<in> dom rc \<and>
                     v' \<in> S \<and>
                     v \<noteq> v' \<and>
                     (v1, v2) \<in> the (rc v) \<and>
                     (v3, v4) \<in> the (rc v')  \<longrightarrow>
                     {v1, v2} \<inter> {v3, v4} = {}))"
    by auto

  have ires: "inres (RES {l}) l" by auto

  from c0 comp_ind have c2: "distinct l" 
    by (metis mem_Collect_eq nres_order_simps(21))
  from c1 comp_ind RETURN_def[of l]
  have "RES {l} \<le> SPEC (\<lambda>l. distinct l \<longrightarrow>
                 (\<forall>v1 v2 v. v \<in> dom rc \<and> v \<in> S \<and> (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<noteq> v2) \<and>
                 (\<forall>v1 v2 v3 v4 v.
                     v \<in> dom rc \<and>
                     v \<in> S \<and>
                     (v1, v2) \<in> the (rc v) \<and>
                     (v3, v4) \<in> the (rc v) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
                     {v1, v2} \<inter> {v3, v4} = {}) \<and>
                 (\<forall>v1 v2 v3 v4 v v'.
                     v \<in> dom rc \<and>
                     v \<in> S \<and>
                     v' \<in> dom rc \<and>
                     v' \<in> S \<and>
                     v \<noteq> v' \<and>
                     (v1, v2) \<in> the (rc v) \<and>
                     (v3, v4) \<in> the (rc v') \<longrightarrow>
                     {v1, v2} \<inter> {v3, v4} = {}))"
    by simp
  from this inres_SPEC[of "RES {l}" l] ires
  have "(\<lambda>l. distinct l \<longrightarrow>
                 (\<forall>v1 v2 v. v \<in> dom rc \<and> v \<in> S \<and> (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<noteq> v2) \<and>
                 (\<forall>v1 v2 v3 v4 v.
                     v \<in> dom rc \<and>
                     v \<in> S \<and>
                     (v1, v2) \<in> the (rc v) \<and>
                     (v3, v4) \<in> the (rc v) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
                     {v1, v2} \<inter> {v3, v4} = {}) \<and>
                 (\<forall>v1 v2 v3 v4 v v'.
                     v \<in> dom rc \<and>
                     v \<in> S \<and>
                     v' \<in> dom rc \<and>
                     v' \<in> S \<and>
                     v \<noteq> v' \<and>
                     (v1, v2) \<in> the (rc v) \<and>
                     (v3, v4) \<in> the (rc v')  \<longrightarrow>
                     {v1, v2} \<inter> {v3, v4} = {})) l"
    by blast
  from this have
  "distinct l \<longrightarrow>
               (\<forall>v1 v2 v. v \<in> dom rc \<and> v \<in> S \<and> (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<noteq> v2) \<and>
               (\<forall>v1 v2 v3 v4 v.
                   v \<in> dom rc \<and>
                   v \<in> S \<and>
                   (v1, v2) \<in> the (rc v) \<and>
                   (v3, v4) \<in> the (rc v) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
                   {v1, v2} \<inter> {v3, v4} = {}) \<and>
               (\<forall>v1 v2 v3 v4 v v'.
                   v \<in> dom rc \<and>
                   v \<in> S \<and>
                   v' \<in> dom rc \<and>
                   v' \<in> S \<and>
                   v \<noteq> v' \<and>
                   (v1, v2) \<in> the (rc v) \<and>
                   (v3, v4) \<in> the (rc v')  \<longrightarrow>
                   {v1, v2} \<inter> {v3, v4} = {})"
    by blast
  from this c2
  have "(\<forall>v1 v2 v. v \<in> dom rc \<and> v \<in> S \<and> (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<noteq> v2) \<and>
                 (\<forall>v1 v2 v3 v4 v.
                     v \<in> dom rc \<and>
                     v \<in> S \<and>
                     (v1, v2) \<in> the (rc v) \<and>
                     (v3, v4) \<in> the (rc v) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
                     {v1, v2} \<inter> {v3, v4} = {}) \<and>
                 (\<forall>v1 v2 v3 v4 v v'.
                     v \<in> dom rc \<and>
                     v \<in> S \<and>
                     v' \<in> dom rc \<and>
                     v' \<in> S \<and>
                     v \<noteq> v' \<and>
                     (v1, v2) \<in> the (rc v) \<and>
                     (v3, v4) \<in> the (rc v') \<longrightarrow>
                     {v1, v2} \<inter> {v3, v4} = {})"
    by blast
  from this comp_ind
  show "uniq_indegree rc"
    unfolding uniq_indegree_def
    apply (rule_tac conjI)
    using finite_S apply blast
    apply (rule_tac conjI)
    using finite_S apply blast
  proof- 
    assume pb1: "(\<forall>v1 v2 v. v \<in> dom rc \<and> v \<in> S \<and> (v1, v2) \<in> the (rc v) \<longrightarrow> v1 \<noteq> v2) \<and>
    (\<forall>v1 v2 v3 v4 v.
        v \<in> dom rc \<and>
        v \<in> S \<and>
        (v1, v2) \<in> the (rc v) \<and> (v3, v4) \<in> the (rc v) \<and> (v1, v2) \<noteq> (v3, v4) \<longrightarrow>
        {v1, v2} \<inter> {v3, v4} = {}) \<and>
    (\<forall>v1 v2 v3 v4 v v'.
        v \<in> dom rc \<and>
        v \<in> S \<and>
        v' \<in> dom rc \<and>
        v' \<in> S \<and>
        v \<noteq> v' \<and>
        (v1, v2) \<in> the (rc v) \<and> (v3, v4) \<in> the (rc v') \<longrightarrow>
        {v1, v2} \<inter> {v3, v4} = {})"
    from this have key1: "
    (\<forall>v1 v2 v3 v4 v v'.
        v \<in> dom rc \<and>
        v \<in> S \<and>
        v' \<in> dom rc \<and>
        v' \<in> S \<and>
        v \<noteq> v' \<and>
        (v1, v2) \<in> the (rc v) \<and> (v3, v4) \<in> the (rc v')  \<longrightarrow>
        {v1, v2} \<inter> {v3, v4} = {})"
      by blast
    from this  
      show "\<nexists>v v' v1 v2 v3 v4.
       v \<in> dom rc \<and>
       v' \<in> dom rc \<and>
       v \<noteq> v' \<and>
       (v1, v2) \<in> the (rc v) \<and> (v3, v4) \<in> the (rc v') \<and> {v1, v2} \<inter> {v3, v4} \<noteq> {}"
        by (meson finite_S subsetD)
    qed qed
    


end
