(*  Title:       Isabelle Collections Library
    Author:      Peter Lammich <peter dot lammich at uni-muenster.de>
    Maintainer:  Peter Lammich <peter dot lammich at uni-muenster.de>
*)
(*
  Created 2009-12-08.
  Not part of submission on 2009-11-26.
  Changelist:

*)

section {* \isaheader{Ordered Maps} *}
theory OrderedMap
imports MapSpec 
begin

  locale ordered_map = map \<alpha> invar 
    for \<alpha> :: "'s \<Rightarrow> ('u::linorder) \<rightharpoonup> 'v" and invar

  locale ordered_finite_map = finite_map \<alpha> invar + ordered_map \<alpha> invar
    for \<alpha> :: "'s \<Rightarrow> ('u::linorder) \<rightharpoonup> 'v" and invar

  locale map_iterateoi = ordered_finite_map \<alpha> invar
    for \<alpha> :: "'s \<Rightarrow> ('u::linorder) \<rightharpoonup> 'v" and invar
    +
    fixes iterateoi :: "('s,'u,'v,'\<sigma>) map_iteratori"
    assumes iterateoi_rule: "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<forall>j\<in>it. k\<le>j; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k v \<sigma>)
      \<rbrakk> \<Longrightarrow> 
        I {} (iterateoi c f m \<sigma>0) \<or> 
        (\<exists>it. it \<subseteq> dom (\<alpha> m) \<and> it \<noteq> {} \<and> 
              \<not> (c (iterateoi c f m \<sigma>0)) \<and> 
              I it (iterateoi c f m \<sigma>0))"
  begin
  lemma iterateoi_rule_P':
    "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<forall>j\<in>it. k\<le>j; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k v \<sigma>);
      \<lbrakk> I {} (iterateoi c f m \<sigma>0)\<rbrakk>  \<Longrightarrow> P;
      !!it. \<lbrakk> it \<subseteq> dom (\<alpha> m); it \<noteq> {}; 
              \<not> (c (iterateoi c f m \<sigma>0)); 
              I it (iterateoi c f m \<sigma>0) \<rbrakk> \<Longrightarrow> P
    \<rbrakk> \<Longrightarrow> P"
    using iterateoi_rule[of m I \<sigma>0 c f]
    by blast

  lemma iterateoi_rule_P_aux:
    "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<forall>j\<in>it. k\<le>j; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                    \<Longrightarrow> I (it - {k}) (f k v \<sigma>);
      !!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>;
      !!\<sigma> it. \<lbrakk> it \<subseteq> dom (\<alpha> m); it \<noteq> {}; \<not> c \<sigma>; I it \<sigma> \<rbrakk> \<Longrightarrow> P \<sigma>
    \<rbrakk> \<Longrightarrow> P (iterateoi c f m \<sigma>0)"
    by (rule iterateoi_rule_P')

  lemma iterateoi_rule_P[case_names minv inv0 inv_pres i_complete i_inter]:
    assumes MINV: "invar m"
    assumes I0: "I (dom (\<alpha> m)) \<sigma>0"
    assumes IP: "!!k v it \<sigma>. \<lbrakk> 
      c \<sigma>; 
      k \<in> it; 
      \<forall>j\<in>it. k\<le>j; 
      \<forall>j\<in>dom (\<alpha> m) - it. j\<le>k; 
      \<alpha> m k = Some v; 
      it \<subseteq> dom (\<alpha> m); 
      I it \<sigma> 
    \<rbrakk> \<Longrightarrow> I (it - {k}) (f k v \<sigma>)"
    assumes IF: "!!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>"
    assumes II: "!!\<sigma> it. \<lbrakk> 
      it \<subseteq> dom (\<alpha> m); 
      it \<noteq> {}; 
      \<not> c \<sigma>; 
      I it \<sigma>; 
      \<forall>k\<in>it. \<forall>j\<in>dom (\<alpha> m) - it. j\<le>k 
    \<rbrakk> \<Longrightarrow> P \<sigma>"
    shows "P (iterateoi c f m \<sigma>0)"
  proof -
    from MINV I0 IP have
      "I {} (iterateoi c f m \<sigma>0) \<or> 
      (\<exists>it. it \<subseteq> dom (\<alpha> m) \<and> it \<noteq> {} \<and> 
            \<not> (c (iterateoi c f m \<sigma>0)) \<and> 
            I it (iterateoi c f m \<sigma>0) \<and> 
            (\<forall>k\<in>it. \<forall>j\<in>dom (\<alpha> m) - it. j\<le>k)
      )"
    proof (rule_tac 
        I="\<lambda>it \<sigma>. I it \<sigma> \<and> (\<forall>k\<in>it. \<forall>j\<in>dom (\<alpha> m) - it. j\<le>k)" 
        in iterateoi_rule_P_aux, goal_cases)
      case (3 k v it \<sigma>)
      from 3 have 1: "\<forall>j\<in>dom (\<alpha> m) - it. j \<le> k" by auto
      with 3 have "I (it - {k}) (f k v \<sigma>)" by (blast intro: 3(3))
      moreover 
      from 3 have "(\<forall>k'\<in>it - {k}. \<forall>j\<in>dom (\<alpha> m) - (it - {k}). j \<le> k')"
        by blast
      ultimately show ?case by blast
    qed (simp|blast)+
    with IF II show ?thesis by blast
  qed
  end

  locale map_iterateo = ordered_finite_map \<alpha> invar
    for \<alpha> :: "'s \<Rightarrow> ('u::linorder) \<rightharpoonup> 'v" and invar
    +
    fixes iterateo :: "('s,'u,'v,'\<sigma>) map_iterator"
    assumes iterateo_rule: "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> k \<in> it; \<forall>j\<in>it. k\<le>j; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k v \<sigma>)
      \<rbrakk> \<Longrightarrow> 
        I {} (iterateo f m \<sigma>0)"
  begin
  lemma iterateo_rule_P':
    "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> k \<in> it; \<forall>j\<in>it. k\<le>j; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k v \<sigma>);
      \<lbrakk> I {} (iterateo f m \<sigma>0)\<rbrakk>  \<Longrightarrow> P
    \<rbrakk> \<Longrightarrow> P"
    using iterateo_rule[of m I \<sigma>0 f]
    by blast

  lemma iterateo_rule_P_aux:
    "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> k \<in> it; \<forall>j\<in>it. k\<le>j; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                    \<Longrightarrow> I (it - {k}) (f k v \<sigma>);
      !!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>
    \<rbrakk> \<Longrightarrow> P (iterateo f m \<sigma>0)"
    by (rule iterateo_rule_P')

    lemma iterateo_rule_P[case_names minv inv0 inv_pres i_complete]: 
      assumes MINV: "invar m"
      assumes I0: "I (dom (\<alpha> m)) \<sigma>0"
      assumes IP: "!!k v it \<sigma>. \<lbrakk> k \<in> it; \<forall>j\<in>it. k\<le>j; \<forall>j\<in>dom (\<alpha> m) - it. j\<le>k; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k v \<sigma>)"
      assumes IF: "!!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>"
      shows "P (iterateo f m \<sigma>0)"
    proof -
      from MINV I0 IP have
        "I {} (iterateo f m \<sigma>0)"
      proof (rule_tac 
          I="\<lambda>it \<sigma>. I it \<sigma> \<and> (\<forall>k\<in>it. \<forall>j\<in>dom (\<alpha> m) - it. j\<le>k)" 
          in iterateo_rule_P_aux, goal_cases)
        case (3 k v it \<sigma>)
        from 3 have 1: "\<forall>j\<in>dom (\<alpha> m) - it. j \<le> k" by auto
        with 3 have "I (it - {k}) (f k v \<sigma>)" by (blast intro: 3(3))
        moreover 
        from 3 have "(\<forall>k'\<in>it - {k}. \<forall>j\<in>dom (\<alpha> m) - (it - {k}). j \<le> k')"
          by blast
        ultimately show ?case by blast
      qed (simp|blast)+
      with IF show ?thesis by blast
    qed
  end

  locale map_reverse_iterateoi = ordered_finite_map \<alpha> invar 
    for \<alpha> :: "'s \<Rightarrow> ('u::linorder) \<rightharpoonup> 'v" and invar
    +
    fixes reverse_iterateoi :: "('s,'u,'v,'\<sigma>) map_iteratori"
    assumes reverse_iterateoi_rule: "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<forall>j\<in>it. k\<ge>j; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k v \<sigma>)
      \<rbrakk> \<Longrightarrow> 
        I {} (reverse_iterateoi c f m \<sigma>0) \<or> 
        (\<exists>it. it \<subseteq> dom (\<alpha> m) \<and> it \<noteq> {} \<and> 
              \<not> (c (reverse_iterateoi c f m \<sigma>0)) \<and> 
              I it (reverse_iterateoi c f m \<sigma>0))"
  begin
  lemma reverse_iterateoi_rule_P':
    "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<forall>j\<in>it. k\<ge>j; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k v \<sigma>);
      \<lbrakk> I {} (reverse_iterateoi c f m \<sigma>0)\<rbrakk>  \<Longrightarrow> P;
      !!it. \<lbrakk> it \<subseteq> dom (\<alpha> m); it \<noteq> {}; 
              \<not> (c (reverse_iterateoi c f m \<sigma>0)); 
              I it (reverse_iterateoi c f m \<sigma>0) \<rbrakk> \<Longrightarrow> P
    \<rbrakk> \<Longrightarrow> P"
    using reverse_iterateoi_rule[of m I \<sigma>0 c f]
    by blast

  lemma reverse_iterateoi_rule_P_aux:
    "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<forall>j\<in>it. k\<ge>j; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                    \<Longrightarrow> I (it - {k}) (f k v \<sigma>);
      !!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>;
      !!\<sigma> it. \<lbrakk> it \<subseteq> dom (\<alpha> m); it \<noteq> {}; \<not> c \<sigma>; I it \<sigma> \<rbrakk> \<Longrightarrow> P \<sigma>
    \<rbrakk> \<Longrightarrow> P (reverse_iterateoi c f m \<sigma>0)"
    by (rule reverse_iterateoi_rule_P')


  lemma reverse_iterateoi_rule_P[case_names minv inv0 inv_pres i_complete i_inter]:
    assumes MINV: "invar m"
    assumes I0: "I (dom (\<alpha> m)) \<sigma>0"
    assumes IP: "!!k v it \<sigma>. \<lbrakk> 
      c \<sigma>; 
      k \<in> it; 
      \<forall>j\<in>it. k\<ge>j; 
      \<forall>j\<in>dom (\<alpha> m) - it. j\<ge>k; 
      \<alpha> m k = Some v; 
      it \<subseteq> dom (\<alpha> m); 
      I it \<sigma> 
    \<rbrakk> \<Longrightarrow> I (it - {k}) (f k v \<sigma>)"
    assumes IF: "!!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>"
    assumes II: "!!\<sigma> it. \<lbrakk> 
      it \<subseteq> dom (\<alpha> m); 
      it \<noteq> {}; 
      \<not> c \<sigma>; 
      I it \<sigma>; 
      \<forall>k\<in>it. \<forall>j\<in>dom (\<alpha> m) - it. j\<ge>k 
    \<rbrakk> \<Longrightarrow> P \<sigma>"
    shows "P (reverse_iterateoi c f m \<sigma>0)"
  proof -
    from MINV I0 IP have
      "I {} (reverse_iterateoi c f m \<sigma>0) \<or> 
      (\<exists>it. it \<subseteq> dom (\<alpha> m) \<and> it \<noteq> {} \<and> 
            \<not> (c (reverse_iterateoi c f m \<sigma>0)) \<and> 
            I it (reverse_iterateoi c f m \<sigma>0) \<and> 
            (\<forall>k\<in>it. \<forall>j\<in>dom (\<alpha> m) - it. j\<ge>k)
      )"
    proof (rule_tac 
        I="\<lambda>it \<sigma>. I it \<sigma> \<and> (\<forall>k\<in>it. \<forall>j\<in>dom (\<alpha> m) - it. j\<ge>k)" 
        in reverse_iterateoi_rule_P_aux, goal_cases)
      case (3 k v it \<sigma>)
      from 3 have 1: "\<forall>j\<in>dom (\<alpha> m) - it. j \<ge> k" by auto
      with 3 have "I (it - {k}) (f k v \<sigma>)" by (blast intro: 3(3))
      moreover 
      from 3 have "(\<forall>k'\<in>it - {k}. \<forall>j\<in>dom (\<alpha> m) - (it - {k}). j \<ge> k')"
        by blast
      ultimately show ?case by blast
    qed (simp|blast)+
    with IF II show ?thesis by blast
  qed
  end

  locale map_reverse_iterateo = ordered_finite_map \<alpha> invar 
    for \<alpha> :: "'s \<Rightarrow> ('u::linorder) \<rightharpoonup> 'v" and invar
    +
    fixes reverse_iterateo :: "('s,'u,'v,'\<sigma>) map_iterator"
    assumes reverse_iterateo_rule: "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> k \<in> it; \<forall>j\<in>it. k\<ge>j; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k v \<sigma>)
      \<rbrakk> \<Longrightarrow> 
        I {} (reverse_iterateo f m \<sigma>0)"
  begin
  lemma reverse_iterateo_rule_P':
    "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> k \<in> it; \<forall>j\<in>it. k\<ge>j; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k v \<sigma>);
      \<lbrakk> I {} (reverse_iterateo f m \<sigma>0)\<rbrakk>  \<Longrightarrow> P
    \<rbrakk> \<Longrightarrow> P"
    using reverse_iterateo_rule[of m I \<sigma>0 f]
    by blast

  lemma reverse_iterateo_rule_P_aux:
    "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> k \<in> it; \<forall>j\<in>it. k\<ge>j; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                    \<Longrightarrow> I (it - {k}) (f k v \<sigma>);
      !!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>
    \<rbrakk> \<Longrightarrow> P (reverse_iterateo f m \<sigma>0)"
    by (rule reverse_iterateo_rule_P')
  
  lemma reverse_iterateo_rule_P[case_names minv inv0 inv_pres i_complete]:
    assumes MINV: "invar m"
    assumes I0: "I (dom (\<alpha> m)) \<sigma>0"
    assumes IP: "!!k v it \<sigma>. \<lbrakk> 
      k \<in> it; 
      \<forall>j\<in>it. k\<ge>j; 
      \<forall>j\<in>dom (\<alpha> m) - it. j\<ge>k; 
      \<alpha> m k = Some v; 
      it \<subseteq> dom (\<alpha> m); 
      I it \<sigma> 
    \<rbrakk> \<Longrightarrow> I (it - {k}) (f k v \<sigma>)"
    assumes IF: "!!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>"
    shows "P (reverse_iterateo f m \<sigma>0)"
  proof -
    from MINV I0 IP have
      "I {} (reverse_iterateo f m \<sigma>0)"
    proof (rule_tac 
        I="\<lambda>it \<sigma>. I it \<sigma> \<and> (\<forall>k\<in>it. \<forall>j\<in>dom (\<alpha> m) - it. j\<ge>k)" 
        in reverse_iterateo_rule_P_aux, goal_cases)
      case (3 k v it \<sigma>)
      from 3 have 1: "\<forall>j\<in>dom (\<alpha> m) - it. j \<ge> k" by auto
      with 3 have "I (it - {k}) (f k v \<sigma>)" by (blast intro: 3(3))
      moreover 
      from 3 have "(\<forall>k'\<in>it - {k}. \<forall>j\<in>dom (\<alpha> m) - (it - {k}). j \<ge> k')"
        by blast
      ultimately show ?case by blast
    qed (simp|blast)+
    with IF show ?thesis by blast
  qed

  end
  

  definition "rel_of m P == {(k,v). m k = Some v \<and> P k v}"

  locale map_min = ordered_map +
    constrains \<alpha> :: "'s \<Rightarrow> 'u::linorder \<rightharpoonup> 'v"
    fixes min :: "'s \<Rightarrow> ('u \<Rightarrow> 'v \<Rightarrow> bool) \<Rightarrow> ('u \<times> 'v) option"
    assumes min_correct:
      "\<lbrakk> invar s; rel_of (\<alpha> s) P \<noteq> {} \<rbrakk> \<Longrightarrow> min s P \<in> Some ` rel_of (\<alpha> s) P"
      "\<lbrakk> invar s; (k,v) \<in> rel_of (\<alpha> s) P \<rbrakk> \<Longrightarrow> fst (the (min s P)) \<le> k"
      "\<lbrakk> invar s; rel_of (\<alpha> s) P = {} \<rbrakk> \<Longrightarrow> min s P = None"
  begin
   lemma minE: 
     assumes A: "invar s" "rel_of (\<alpha> s) P \<noteq> {}"
     obtains k v where
     "min s P = Some (k,v)" "(k,v)\<in>rel_of (\<alpha> s) P" "\<forall>(k',v')\<in>rel_of (\<alpha> s) P. k \<le> k'"
   proof -
     from min_correct(1)[OF A] have MIS: "min s P \<in> Some ` rel_of (\<alpha> s) P" .
     then obtain k v where KV: "min s P = Some (k,v)" "(k,v)\<in>rel_of (\<alpha> s) P"
       by auto
     show thesis 
       apply (rule that[OF KV])
       apply (clarify)
       apply (drule min_correct(2)[OF `invar s`])
       apply (simp add: KV(1))
       done
   qed

   lemmas minI = min_correct(3)

   lemma min_Some:
     "\<lbrakk> invar s; min s P = Some (k,v) \<rbrakk> \<Longrightarrow> (k,v)\<in>rel_of (\<alpha> s) P"
     "\<lbrakk> invar s; min s P = Some (k,v); (k',v')\<in>rel_of (\<alpha> s) P \<rbrakk> \<Longrightarrow> k\<le>k'"
     apply -
     apply (cases "rel_of (\<alpha> s) P = {}")
     apply (drule (1) min_correct(3))
     apply simp
     apply (erule (1) minE)
     apply auto [1]
     apply (drule (1) min_correct(2))
     apply auto
     done
     
   lemma min_None:
     "\<lbrakk> invar s; min s P = None \<rbrakk> \<Longrightarrow> rel_of (\<alpha> s) P = {}"
     apply (cases "rel_of (\<alpha> s) P = {}")
     apply simp
     apply (drule (1) min_correct(1))
     apply auto
     done

  end

  locale map_max = ordered_map +
    constrains \<alpha> :: "'s \<Rightarrow> 'u::linorder \<rightharpoonup> 'v"
    fixes max :: "'s \<Rightarrow> ('u \<Rightarrow> 'v \<Rightarrow> bool) \<Rightarrow> ('u \<times> 'v) option"
    assumes max_correct:
      "\<lbrakk> invar s; rel_of (\<alpha> s) P \<noteq> {} \<rbrakk> \<Longrightarrow> max s P \<in> Some ` rel_of (\<alpha> s) P"
      "\<lbrakk> invar s; (k,v) \<in> rel_of (\<alpha> s) P \<rbrakk> \<Longrightarrow> fst (the (max s P)) \<ge> k"
      "\<lbrakk> invar s; rel_of (\<alpha> s) P = {} \<rbrakk> \<Longrightarrow> max s P = None"
  begin
   lemma maxE: 
     assumes A: "invar s" "rel_of (\<alpha> s) P \<noteq> {}"
     obtains k v where
     "max s P = Some (k,v)" "(k,v)\<in>rel_of (\<alpha> s) P" "\<forall>(k',v')\<in>rel_of (\<alpha> s) P. k \<ge> k'"
   proof -
     from max_correct(1)[OF A] have MIS: "max s P \<in> Some ` rel_of (\<alpha> s) P" .
     then obtain k v where KV: "max s P = Some (k,v)" "(k,v)\<in>rel_of (\<alpha> s) P"
       by auto
     show thesis 
       apply (rule that[OF KV])
       apply (clarify)
       apply (drule max_correct(2)[OF `invar s`])
       apply (simp add: KV(1))
       done
   qed

   lemmas maxI = max_correct(3)

   lemma max_Some:
     "\<lbrakk> invar s; max s P = Some (k,v) \<rbrakk> \<Longrightarrow> (k,v)\<in>rel_of (\<alpha> s) P"
     "\<lbrakk> invar s; max s P = Some (k,v); (k',v')\<in>rel_of (\<alpha> s) P \<rbrakk> \<Longrightarrow> k\<ge>k'"
     apply -
     apply (cases "rel_of (\<alpha> s) P = {}")
     apply (drule (1) max_correct(3))
     apply simp
     apply (erule (1) maxE)
     apply auto [1]
     apply (drule (1) max_correct(2))
     apply auto
     done
     
   lemma max_None:
     "\<lbrakk> invar s; max s P = None \<rbrakk> \<Longrightarrow> rel_of (\<alpha> s) P = {}"
     apply (cases "rel_of (\<alpha> s) P = {}")
     apply simp
     apply (drule (1) max_correct(1))
     apply auto
     done

  end

subsection "Ordered Map to Sorted List Conversion"
  locale map_to_sorted_list = ordered_map \<alpha> invar + map_to_list \<alpha> invar to_list 
    for \<alpha> :: "'s \<Rightarrow> 'u::linorder \<rightharpoonup> 'v" and invar to_list +
    assumes to_list_sorted:
    "invar m \<Longrightarrow> sorted (map fst (to_list m))"


subsection "Record Based Interface"
  record ('k,'v,'s) omap_ops = "('k,'v,'s) map_ops" +
    map_op_min :: "'s \<Rightarrow> ('k \<Rightarrow> 'v \<Rightarrow> bool) \<Rightarrow> ('k \<times> 'v) option"
    map_op_max :: "'s \<Rightarrow> ('k \<Rightarrow> 'v \<Rightarrow> bool) \<Rightarrow> ('k \<times> 'v) option"



  locale StdOMapDefs = StdMapDefs ops 
    for ops :: "('k::linorder,'v,'s,'more) omap_ops_scheme"
  begin
    abbreviation min where "min == map_op_min ops"
    abbreviation max where "max == map_op_max ops"
  end


  locale StdOMap = 
    StdOMapDefs ops +
    StdMap ops +
    map_min \<alpha> invar min +
    map_max \<alpha> invar max
    for ops
  begin
  end





end
