(*  Title:       Isabelle Collections Library
    Author:      Peter Lammich <peter dot lammich at uni-muenster.de>
    Maintainer:  Peter Lammich <peter dot lammich at uni-muenster.de>
*)
(*
  Created 2009-12-10.
  Not part of submission on 2009-11-26.
  Changelist:

*)

section \<open> isaheader{Ordered Sets} \<close>

theory OrderedSet

imports SetSpec 
begin

  locale ordered_set = set \<alpha> invar 
    for \<alpha> :: "'s \<Rightarrow> ('u::linorder) set" and invar

  locale ordered_finite_set = finite_set \<alpha> invar + ordered_set \<alpha> invar
    for \<alpha> :: "'s \<Rightarrow> ('u::linorder) set" and invar

  locale set_iterateoi = ordered_finite_set \<alpha> invar
    for \<alpha> :: "'s \<Rightarrow> ('u::linorder) set" and invar
    +
    fixes iterateoi :: "('s,'u,'\<sigma>) iteratori"
    assumes iterateoi_rule: "\<lbrakk>
      invar m;
      I (\<alpha> m) \<sigma>0;
      !!k it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<forall>j\<in>it. k\<le>j; it \<subseteq> (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k \<sigma>)
      \<rbrakk> \<Longrightarrow> 
        I {} (iterateoi c f m \<sigma>0) \<or> 
        (\<exists>it. it \<subseteq> (\<alpha> m) \<and> it \<noteq> {} \<and> 
              \<not> (c (iterateoi c f m \<sigma>0)) \<and> 
              I it (iterateoi c f m \<sigma>0))"
  begin
  lemma iterateoi_rule_P':
    "\<lbrakk>
      invar m;
      I (\<alpha> m) \<sigma>0;
      !!k it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<forall>j\<in>it. k\<le>j; it \<subseteq> \<alpha> m; I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k \<sigma>);
      \<lbrakk> I {} (iterateoi c f m \<sigma>0)\<rbrakk>  \<Longrightarrow> P;
      !!it. \<lbrakk> it \<subseteq> \<alpha> m; it \<noteq> {}; 
              \<not> (c (iterateoi c f m \<sigma>0)); 
              I it (iterateoi c f m \<sigma>0) \<rbrakk> \<Longrightarrow> P
    \<rbrakk> \<Longrightarrow> P"
    using iterateoi_rule[of m I \<sigma>0 c f]
    by blast

  lemma iterateoi_rule_P_aux:
    "\<lbrakk>
      invar m;
      I (\<alpha> m) \<sigma>0;
      !!k it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<forall>j\<in>it. k\<le>j; it \<subseteq> \<alpha> m; I it \<sigma> \<rbrakk> 
                    \<Longrightarrow> I (it - {k}) (f k \<sigma>);
      !!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>;
      !!\<sigma> it. \<lbrakk> it \<subseteq> \<alpha> m; it \<noteq> {}; \<not> c \<sigma>; I it \<sigma> \<rbrakk> \<Longrightarrow> P \<sigma>
    \<rbrakk> \<Longrightarrow> P (iterateoi c f m \<sigma>0)"
    by (rule iterateoi_rule_P')

  lemma iterateoi_rule_P[case_names minv inv0 inv_pres i_complete i_inter]:
    assumes MINV: "invar m"
    assumes I0: "I (\<alpha> m) \<sigma>0"
    assumes IP: "!!k it \<sigma>. \<lbrakk> 
      c \<sigma>; 
      k \<in> it; 
      \<forall>j\<in>it. k\<le>j; 
      \<forall>j\<in>\<alpha> m - it. j\<le>k; 
      it \<subseteq> \<alpha> m; 
      I it \<sigma> 
    \<rbrakk> \<Longrightarrow> I (it - {k}) (f k \<sigma>)"
    assumes IF: "!!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>"
    assumes II: "!!\<sigma> it. \<lbrakk> 
      it \<subseteq> \<alpha> m; 
      it \<noteq> {}; 
      \<not> c \<sigma>; 
      I it \<sigma>; 
      \<forall>k\<in>it. \<forall>j\<in>\<alpha> m - it. j\<le>k 
    \<rbrakk> \<Longrightarrow> P \<sigma>"
    shows "P (iterateoi c f m \<sigma>0)"
  proof -
    from MINV I0 IP have
      "I {} (iterateoi c f m \<sigma>0) \<or> 
      (\<exists>it. it \<subseteq> \<alpha> m \<and> it \<noteq> {} \<and> 
            \<not> (c (iterateoi c f m \<sigma>0)) \<and> 
            I it (iterateoi c f m \<sigma>0) \<and> 
            (\<forall>k\<in>it. \<forall>j\<in>\<alpha> m - it. j\<le>k)
      )"
    proof (rule_tac 
        I="\<lambda>it \<sigma>. I it \<sigma> \<and> (\<forall>k\<in>it. \<forall>j\<in>\<alpha> m - it. j\<le>k)" 
        in iterateoi_rule_P_aux,goal_cases)
      case (3 k it \<sigma>)
      from 3 have 1: "\<forall>j\<in>\<alpha> m - it. j \<le> k" by auto
      with 3 have "I (it - {k}) (f k \<sigma>)" by (blast intro: 3(3))
      moreover 
      from 3 have "(\<forall>k'\<in>it - {k}. \<forall>j\<in>\<alpha> m - (it - {k}). j \<le> k')"
        by blast
      ultimately show ?case by blast
    qed (simp|blast)+
    with IF II show ?thesis by blast
  qed
  end

  locale set_iterateo = ordered_finite_set \<alpha> invar
    for \<alpha> :: "'s \<Rightarrow> ('u::linorder) set" and invar
    +
    fixes iterateo :: "('s,'u,'\<sigma>) iterator"
    assumes iterateo_rule: "\<lbrakk>
      invar m;
      I ((\<alpha> m)) \<sigma>0;
      !!k it \<sigma>. \<lbrakk> k \<in> it; \<forall>j\<in>it. k\<le>j; it \<subseteq> (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k \<sigma>)
      \<rbrakk> \<Longrightarrow> 
        I {} (iterateo f m \<sigma>0)"
  begin
  lemma iterateo_rule_P':
    "\<lbrakk>
      invar m;
      I ((\<alpha> m)) \<sigma>0;
      !!k it \<sigma>. \<lbrakk> k \<in> it; \<forall>j\<in>it. k\<le>j; it \<subseteq> (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k \<sigma>);
      \<lbrakk> I {} (iterateo f m \<sigma>0)\<rbrakk>  \<Longrightarrow> P
    \<rbrakk> \<Longrightarrow> P"
    using iterateo_rule[of m I \<sigma>0 f]
    by auto

  lemma iterateo_rule_P_aux:
    "\<lbrakk>
      invar m;
      I ((\<alpha> m)) \<sigma>0;
      !!k it \<sigma>. \<lbrakk> k \<in> it; \<forall>j\<in>it. k\<le>j; it \<subseteq> (\<alpha> m); I it \<sigma> \<rbrakk> 
                    \<Longrightarrow> I (it - {k}) (f k \<sigma>);
      !!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>
    \<rbrakk> \<Longrightarrow> P (iterateo f m \<sigma>0)"
    by (rule iterateo_rule_P')

    lemma iterateo_rule_P[case_names minv inv0 inv_pres i_complete]: 
      assumes MINV: "invar m"
      assumes I0: "I ((\<alpha> m)) \<sigma>0"
      assumes IP: "!!k it \<sigma>. \<lbrakk> k \<in> it; \<forall>j\<in>it. k\<le>j; \<forall>j\<in>(\<alpha> m) - it. j\<le>k; it \<subseteq> (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k \<sigma>)"
      assumes IF: "!!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>"
      shows "P (iterateo f m \<sigma>0)"
    proof -
      from MINV I0 IP have
        "I {} (iterateo f m \<sigma>0)"
      proof (rule_tac 
          I="\<lambda>it \<sigma>. I it \<sigma> \<and> (\<forall>k\<in>it. \<forall>j\<in>(\<alpha> m) - it. j\<le>k)" 
          in iterateo_rule_P_aux,goal_cases)
        case (3 k it \<sigma>)
        from 3 have 1: "\<forall>j\<in>(\<alpha> m) - it. j \<le> k" by auto
        with 3 have "I (it - {k}) (f k \<sigma>)" by (blast intro: 3(3))
        moreover 
        from 3 have "(\<forall>k'\<in>it - {k}. \<forall>j\<in>(\<alpha> m) - (it - {k}). j \<le> k')"
          by blast
        ultimately show ?case by blast
      qed (simp|blast)+
      with IF show ?thesis by blast
    qed
  end

  locale set_reverse_iterateoi = ordered_finite_set \<alpha> invar 
    for \<alpha> :: "'s \<Rightarrow> ('u::linorder) set" and invar
    +
    fixes reverse_iterateoi :: "('s,'u,'\<sigma>) iteratori"
    assumes reverse_iterateoi_rule: "\<lbrakk>
      invar m;
      I ((\<alpha> m)) \<sigma>0;
      !!k it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<forall>j\<in>it. k\<ge>j; it \<subseteq> (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k \<sigma>)
      \<rbrakk> \<Longrightarrow> 
        I {} (reverse_iterateoi c f m \<sigma>0) \<or> 
        (\<exists>it. it \<subseteq> (\<alpha> m) \<and> it \<noteq> {} \<and> 
              \<not> (c (reverse_iterateoi c f m \<sigma>0)) \<and> 
              I it (reverse_iterateoi c f m \<sigma>0))"
  begin
  lemma reverse_iterateoi_rule_P':
    "\<lbrakk>
      invar m;
      I ((\<alpha> m)) \<sigma>0;
      !!k it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<forall>j\<in>it. k\<ge>j; it \<subseteq> (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k \<sigma>);
      \<lbrakk> I {} (reverse_iterateoi c f m \<sigma>0)\<rbrakk>  \<Longrightarrow> P;
      !!it. \<lbrakk> it \<subseteq> (\<alpha> m); it \<noteq> {}; 
              \<not> (c (reverse_iterateoi c f m \<sigma>0)); 
              I it (reverse_iterateoi c f m \<sigma>0) \<rbrakk> \<Longrightarrow> P
    \<rbrakk> \<Longrightarrow> P"
    using reverse_iterateoi_rule[of m I \<sigma>0 c f]
    by blast

  lemma reverse_iterateoi_rule_P_aux:
    "\<lbrakk>
      invar m;
      I ((\<alpha> m)) \<sigma>0;
      !!k it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<forall>j\<in>it. k\<ge>j; it \<subseteq> (\<alpha> m); I it \<sigma> \<rbrakk> 
                    \<Longrightarrow> I (it - {k}) (f k \<sigma>);
      !!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>;
      !!\<sigma> it. \<lbrakk> it \<subseteq> (\<alpha> m); it \<noteq> {}; \<not> c \<sigma>; I it \<sigma> \<rbrakk> \<Longrightarrow> P \<sigma>
    \<rbrakk> \<Longrightarrow> P (reverse_iterateoi c f m \<sigma>0)"
    by (rule reverse_iterateoi_rule_P')


  lemma reverse_iterateoi_rule_P[case_names minv inv0 inv_pres i_complete i_inter]:
    assumes MINV: "invar m"
    assumes I0: "I ((\<alpha> m)) \<sigma>0"
    assumes IP: "!!k it \<sigma>. \<lbrakk> 
      c \<sigma>; 
      k \<in> it; 
      \<forall>j\<in>it. k\<ge>j; 
      \<forall>j\<in>(\<alpha> m) - it. j\<ge>k; 
      it \<subseteq> (\<alpha> m); 
      I it \<sigma> 
    \<rbrakk> \<Longrightarrow> I (it - {k}) (f k \<sigma>)"
    assumes IF: "!!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>"
    assumes II: "!!\<sigma> it. \<lbrakk> 
      it \<subseteq> (\<alpha> m); 
      it \<noteq> {}; 
      \<not> c \<sigma>; 
      I it \<sigma>; 
      \<forall>k\<in>it. \<forall>j\<in>(\<alpha> m) - it. j\<ge>k 
    \<rbrakk> \<Longrightarrow> P \<sigma>"
    shows "P (reverse_iterateoi c f m \<sigma>0)"
  proof -
    from MINV I0 IP have
      "I {} (reverse_iterateoi c f m \<sigma>0) \<or> 
      (\<exists>it. it \<subseteq> (\<alpha> m) \<and> it \<noteq> {} \<and> 
            \<not> (c (reverse_iterateoi c f m \<sigma>0)) \<and> 
            I it (reverse_iterateoi c f m \<sigma>0) \<and> 
            (\<forall>k\<in>it. \<forall>j\<in>(\<alpha> m) - it. j\<ge>k)
      )"
    proof (rule_tac 
        I="\<lambda>it \<sigma>. I it \<sigma> \<and> (\<forall>k\<in>it. \<forall>j\<in>(\<alpha> m) - it. j\<ge>k)" 
        in reverse_iterateoi_rule_P_aux,goal_cases)
      case (3 k it \<sigma>)
      from 3 have 1: "\<forall>j\<in>(\<alpha> m) - it. j \<ge> k" by auto
      with 3 have "I (it - {k}) (f k \<sigma>)" by (blast intro: 3(3))
      moreover 
      from 3 have "(\<forall>k'\<in>it - {k}. \<forall>j\<in>(\<alpha> m) - (it - {k}). j \<ge> k')"
        by blast
      ultimately show ?case by blast
    qed (simp|blast)+
    with IF II show ?thesis by blast
  qed
  end

  locale set_reverse_iterateo = ordered_finite_set \<alpha> invar 
    for \<alpha> :: "'s \<Rightarrow> ('u::linorder) set" and invar
    +
    fixes reverse_iterateo :: "('s,'u,'\<sigma>) iterator"
    assumes reverse_iterateo_rule: "\<lbrakk>
      invar m;
      I ((\<alpha> m)) \<sigma>0;
      !!k it \<sigma>. \<lbrakk> k \<in> it; \<forall>j\<in>it. k\<ge>j; it \<subseteq> (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k \<sigma>)
      \<rbrakk> \<Longrightarrow> 
        I {} (reverse_iterateo f m \<sigma>0)"
  begin
  lemma reverse_iterateo_rule_P':
    "\<lbrakk>
      invar m;
      I ((\<alpha> m)) \<sigma>0;
      !!k it \<sigma>. \<lbrakk> k \<in> it; \<forall>j\<in>it. k\<ge>j; it \<subseteq> (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k \<sigma>);
      \<lbrakk> I {} (reverse_iterateo f m \<sigma>0)\<rbrakk>  \<Longrightarrow> P
    \<rbrakk> \<Longrightarrow> P"
    using reverse_iterateo_rule[of m I \<sigma>0 f]
    by blast

  lemma reverse_iterateo_rule_P_aux:
    "\<lbrakk>
      invar m;
      I ((\<alpha> m)) \<sigma>0;
      !!k it \<sigma>. \<lbrakk> k \<in> it; \<forall>j\<in>it. k\<ge>j; it \<subseteq> (\<alpha> m); I it \<sigma> \<rbrakk> 
                    \<Longrightarrow> I (it - {k}) (f k \<sigma>);
      !!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>
    \<rbrakk> \<Longrightarrow> P (reverse_iterateo f m \<sigma>0)"
    by (rule reverse_iterateo_rule_P')
  
  lemma reverse_iterateo_rule_P[case_names minv inv0 inv_pres i_complete]:
    assumes MINV: "invar m"
    assumes I0: "I ((\<alpha> m)) \<sigma>0"
    assumes IP: "!!k it \<sigma>. \<lbrakk> 
      k \<in> it; 
      \<forall>j\<in>it. k\<ge>j; 
      \<forall>j\<in> (\<alpha> m) - it. j\<ge>k; 
      it \<subseteq> (\<alpha> m); 
      I it \<sigma> 
    \<rbrakk> \<Longrightarrow> I (it - {k}) (f k \<sigma>)"
    assumes IF: "!!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>"
    shows "P (reverse_iterateo f m \<sigma>0)"
  proof -
    from MINV I0 IP have
      "I {} (reverse_iterateo f m \<sigma>0)"
    proof (rule_tac 
        I="\<lambda>it \<sigma>. I it \<sigma> \<and> (\<forall>k\<in>it. \<forall>j\<in>(\<alpha> m) - it. j\<ge>k)" 
        in reverse_iterateo_rule_P_aux, goal_cases)
      case (3 k it \<sigma>)
      from 3 have 1: "\<forall>j\<in>(\<alpha> m) - it. j \<ge> k" by auto
      with 3 have "I (it - {k}) (f k \<sigma>)" by (blast intro: 3(3))
      moreover 
      from 3 have "(\<forall>k'\<in>it - {k}. \<forall>j\<in> (\<alpha> m) - (it - {k}). j \<ge> k')"
        by blast
      ultimately show ?case by blast
    qed (simp|blast)+
    with IF show ?thesis by blast
  qed

  end
  
  locale set_min = ordered_set +
    constrains \<alpha> :: "'s \<Rightarrow> 'u::linorder set"
    fixes min :: "'s \<Rightarrow> ('u \<Rightarrow> bool) \<Rightarrow> 'u option"
    assumes min_correct:
      "\<lbrakk> invar s; x\<in>\<alpha> s; P x \<rbrakk> \<Longrightarrow> min s P \<in> Some ` {x\<in>\<alpha> s. P x}"
      "\<lbrakk> invar s; x\<in>\<alpha> s; P x \<rbrakk> \<Longrightarrow> (the (min s P)) \<le> x"
      "\<lbrakk> invar s; {x\<in>\<alpha> s. P x} = {} \<rbrakk> \<Longrightarrow> min s P = None"
  begin
   lemma minE: 
     assumes A: "invar s" "x\<in>\<alpha> s" "P x"
     obtains x' where
     "min s P = Some x'" "x'\<in>\<alpha> s" "P x'" "\<forall>x\<in>\<alpha> s. P x \<longrightarrow> x' \<le> x"
   proof -
     from min_correct(1)[of s x P, OF A] have MIS: "min s P \<in> Some ` {x \<in> \<alpha> s. P x}" .
     then obtain x' where KV: "min s P = Some x'" "x'\<in>\<alpha> s" "P x'"
       by auto
     show thesis 
       apply (rule that[OF KV])
       apply (clarify)
       apply (drule (1) min_correct(2)[OF `invar s`])
       apply (simp add: KV(1))
       done
   qed

   lemmas minI = min_correct(3)

   lemma min_Some:
     "\<lbrakk> invar s; min s P = Some x \<rbrakk> \<Longrightarrow> x\<in>\<alpha> s"
     "\<lbrakk> invar s; min s P = Some x \<rbrakk> \<Longrightarrow> P x"
     "\<lbrakk> invar s; min s P = Some x; x'\<in>\<alpha> s; P x'\<rbrakk> \<Longrightarrow> x\<le>x'"
     apply -
     apply (cases "{x \<in> \<alpha> s. P x} = {}")
     apply (drule (1) min_correct(3))
     apply simp
     apply simp
     apply (erule exE)
     apply clarify
     apply (drule (2) min_correct(1)[of s _ P])
     apply auto [1]

     apply (cases "{x \<in> \<alpha> s. P x} = {}")
     apply (drule (1) min_correct(3))
     apply simp
     apply simp
     apply (erule exE)
     apply clarify
     apply (drule (2) min_correct(1)[of s _ P])
     apply auto [1]

     apply (drule (2) min_correct(2)[where P=P])
     apply auto
     done
     
   lemma min_None:
     "\<lbrakk> invar s; min s P = None \<rbrakk> \<Longrightarrow> {x\<in>\<alpha> s. P x} = {}"
     apply (cases "{x\<in>\<alpha> s. P x} = {}")
     apply simp
     apply simp
     apply (erule exE)
     apply clarify
     apply (drule (2) min_correct(1)[where P=P])
     apply auto
     done

  end

  locale set_max = ordered_set +
    constrains \<alpha> :: "'s \<Rightarrow> 'u::linorder set"
    fixes max :: "'s \<Rightarrow> ('u \<Rightarrow> bool) \<Rightarrow> 'u option"
    assumes max_correct:
      "\<lbrakk> invar s; x\<in>\<alpha> s; P x \<rbrakk> \<Longrightarrow> max s P \<in> Some ` {x\<in>\<alpha> s. P x}"
      "\<lbrakk> invar s; x\<in>\<alpha> s; P x \<rbrakk> \<Longrightarrow> the (max s P) \<ge> x"
      "\<lbrakk> invar s; {x\<in>\<alpha> s. P x} = {} \<rbrakk> \<Longrightarrow> max s P = None"
  begin
   lemma maxE: 
     assumes A: "invar s" "x\<in>\<alpha> s" "P x"
     obtains x' where
     "max s P = Some x'" "x'\<in>\<alpha> s" "P x'" "\<forall>x\<in>\<alpha> s. P x \<longrightarrow> x' \<ge> x"
   proof -
     from max_correct(1)[where P=P, OF A] have 
       MIS: "max s P \<in> Some ` {x\<in>\<alpha> s. P x}" .
     then obtain x' where KV: "max s P = Some x'" "x'\<in> \<alpha> s" "P x'"
       by auto
     show thesis 
       apply (rule that[OF KV])
       apply (clarify)
       apply (drule (1) max_correct(2)[OF `invar s`])
       apply (simp add: KV(1))
       done
   qed

   lemmas maxI = max_correct(3)

   lemma max_Some:
     "\<lbrakk> invar s; max s P = Some x \<rbrakk> \<Longrightarrow> x\<in>\<alpha> s"
     "\<lbrakk> invar s; max s P = Some x \<rbrakk> \<Longrightarrow> P x"
     "\<lbrakk> invar s; max s P = Some x; x'\<in>\<alpha> s; P x'\<rbrakk> \<Longrightarrow> x\<ge>x'"
     apply -
     apply (cases "{x\<in>\<alpha> s. P x} = {}")
     apply (drule (1) max_correct(3))
     apply simp
     apply simp
     apply (erule exE)
     apply clarify
     apply (drule (2) max_correct(1)[of s _ P])
     apply auto [1]

     apply (cases "{x\<in>\<alpha> s. P x} = {}")
     apply (drule (1) max_correct(3))
     apply simp
     apply simp
     apply (erule exE)
     apply clarify
     apply (drule (2) max_correct(1)[of s _ P])
     apply auto [1]

     apply (drule (1) max_correct(2)[where P=P])
     apply auto
     done
     
   lemma max_None:
     "\<lbrakk> invar s; max s P = None \<rbrakk> \<Longrightarrow> {x\<in>\<alpha> s. P x} = {}"
     apply (cases "{x\<in>\<alpha> s. P x} = {}")
     apply simp
     apply simp
     apply (erule exE)
     apply clarify
     apply (drule (1) max_correct(1)[where P=P])
     apply auto
     done

  end

subsection "Ordered Set to Sorted List Conversion"
  locale set_to_sorted_list = ordered_set \<alpha> invar + set_to_list \<alpha> invar to_list 
    for \<alpha> :: "'s \<Rightarrow> 'u::linorder set" and invar to_list +
    assumes to_list_sorted: "invar m \<Longrightarrow> sorted (to_list m)"

subsection "Record Based Interface"


  record ('x,'s) oset_ops = "('x::linorder,'s) set_ops" +
    set_op_min :: "'s \<Rightarrow> ('x \<Rightarrow> bool) \<Rightarrow> 'x option"
    set_op_max :: "'s \<Rightarrow> ('x \<Rightarrow> bool) \<Rightarrow> 'x option"
    

  locale StdOSetDefs = StdSetDefs ops
    for ops :: "('x::linorder,'s,'more) oset_ops_scheme"
  begin
    abbreviation min where "min == set_op_min ops"
    abbreviation max where "max == set_op_max ops"
  end


  locale StdOSet =
    StdOSetDefs ops +
    StdSet ops +
    set_min \<alpha> invar min +
    set_max \<alpha> invar max
    for ops
  begin
  end




end
