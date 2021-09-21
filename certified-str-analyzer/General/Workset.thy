(*  
    Authors:     Shuanglong Kan <shuanglong@uni-kl.de>
                 Thomas Tuerk <tuerk@in.tum.de>             
*)

section \<open> A nondeterministic while combinator \<close>

theory Workset 
  imports Main "HOL-Library.Multiset" "Refine_Monadic.Refine_Monadic" "CAVA_Base.CAVA_Base" 
  "../Automata/implementation/Rprod"
begin

subsection \<open> Worklist algorithm \<close>

text \<open>
Peter Lammich's refinement framework provides tools to reason about 
while loops. Let's use these tools to define worklist algorithms.

Despite the name, I'm not really interested in algorithms operating
on lists here. Often the order in which the elements of the worklist are
processed is unimportant. Therefore, multisets are useful. 

For many algorithm one could use sets instead of multisets, because elements that
have already been processed don't modify the state a second time. 
So, this theory introduces 3 closely related concepts: worklist, workbag and workset algorithms.
\<close>

subsection \<open>  Introducing some intermediate predicates for While Loops \<close>
(* r is well-founded *)
 (* each step does not fail, decreases according to r and preserves the invariant *)
definition WHILE_variant_OK where
  "WHILE_variant_OK cond step invar r \<equiv>
  (
    wf r \<and> 
   (\<forall>s. invar s \<and> cond s \<longrightarrow> step s \<le> SPEC (\<lambda>s'. invar s' \<and> (s', s) \<in> r)))"

lemma WHILE_variant_OK_I [intro!] :
  "\<lbrakk>wf r; \<And>s. \<lbrakk> cond s; invar s \<rbrakk> \<Longrightarrow> step s \<le> SPEC (\<lambda>s'. invar s' \<and> (s', s) \<in> r)\<rbrakk> \<Longrightarrow> 
    WHILE_variant_OK cond step invar r"
unfolding WHILE_variant_OK_def by blast 

definition WHILE_variant_exists where
  "WHILE_variant_exists cond step invar \<equiv>
   \<exists>r. WHILE_variant_OK cond step invar r"

lemma WHILE_variant_exists_I [intro!] :
  "WHILE_variant_OK cond step invar r \<Longrightarrow> WHILE_variant_exists cond step invar"
unfolding WHILE_variant_exists_def by blast 

definition "WHILE_invar_OK cond step invar \<equiv>
            (\<forall>s. (cond s \<and> invar s) \<longrightarrow> step s \<le> SPEC invar)"

lemma WHILE_invar_OK_I [intro!] :
  "\<lbrakk>\<And>s. \<lbrakk> cond s; invar s \<rbrakk> \<Longrightarrow> step s \<le> SPEC invar\<rbrakk> \<Longrightarrow> WHILE_invar_OK cond step invar"
unfolding WHILE_invar_OK_def by blast 

lemma WHILE_variant___invar_extract :
assumes invar_ex: "WHILE_variant_exists cond step invar"
shows "WHILE_invar_OK cond step invar"
proof 
  fix s
  assume "invar s" "cond s"
  with invar_ex obtain r where step1: "step s \<le> SPEC (\<lambda>s'. invar s' \<and> (s', s) \<in> r)"
    unfolding WHILE_variant_exists_def WHILE_variant_OK_def
    by blast

  have step2: "SPEC (\<lambda>s'. invar s' \<and> (s', s) \<in> r) \<le> SPEC invar"
    by (rule SPEC_rule) fast

  from step1 step2 show "step s \<le> SPEC invar"
    by (rule order_trans)
qed

text \<open> Invariants can be combined ... \<close>

lemma WHILE_invar_OK___combine :
  "\<lbrakk>WHILE_invar_OK cond step invar1;
    WHILE_invar_OK cond step invar2\<rbrakk> \<Longrightarrow>
   WHILE_invar_OK cond step (\<lambda>s. invar1 s \<and> invar2 s)"
  unfolding WHILE_invar_OK_def
  by (auto simp: pw_le_iff)

text \<open> ... and extended. \<close>

lemma WHILE_invar_OK___extend :
  "\<lbrakk>WHILE_invar_OK cond step invar1;
    \<And>s. \<lbrakk> cond s; invar1 s; invar2 s \<rbrakk> \<Longrightarrow> step s \<le> SPEC invar2\<rbrakk> \<Longrightarrow>
   WHILE_invar_OK cond step (\<lambda>s. invar1 s \<and> invar2 s)"
unfolding WHILE_invar_OK_def
  by (auto simp: pw_le_iff)

lemma WHILE_variant_OK___extend_invariant :
assumes invar_OK: "WHILE_invar_OK cond step invar"
    and wf_r: "wf r"
    and in_r: "\<And>s. \<lbrakk> cond s; invar s \<rbrakk> \<Longrightarrow> step s \<le> SPEC (\<lambda>s'. (s', s) \<in> r)" 
shows "WHILE_variant_OK cond step invar r"
proof 
  show "wf r" by fact
next
  fix s 
  assume cond_s: "cond s" and invar_s: "invar s"

  from in_r[OF cond_s invar_s] have step1: "step s \<le> SPEC (\<lambda>s'. (s', s) \<in> r)" .
  from invar_OK have step2: "step s \<le> SPEC (\<lambda>s'. invar s')"
    unfolding WHILE_invar_OK_def using cond_s invar_s by simp

  from step1 step2 
  show "step s \<le> SPEC (\<lambda>s'. invar s' \<and> (s', s) \<in> r)"
    apply (cases "step s")
    apply (auto)
  done
qed

text \<open> Interface to WHILE rules using these definitions \<close>

lemma WHILEI_rule_manual:
  assumes I0: "I x0"
  assumes IS: "WHILE_invar_OK b f I"
  assumes II: "\<And>x. \<lbrakk> I x; \<not>b x \<rbrakk> \<Longrightarrow> P x"
  shows "WHILEI I b f x0 \<le> SPEC P"
  using assms
  unfolding WHILE_invar_OK_def
  by (rule_tac WHILEI_rule, simp_all)

lemma WHILEIT_rule_manual:
  assumes I0: "I x0"
  assumes IS: "WHILE_variant_exists b f I"
  assumes II: "\<And>x. \<lbrakk> I x; \<not>b x \<rbrakk> \<Longrightarrow> P x"
  shows "WHILEIT I b f x0 \<le> SPEC P"
  proof -
    from IS [unfolded WHILE_variant_exists_def]
    obtain R where variant_OK: "WHILE_variant_OK b f I R" by blast

    with I0 II show ?thesis 
      unfolding WHILE_variant_OK_def
      apply (rule_tac WHILEIT_rule[of R])
      apply (simp_all)
    done
  qed

lemma WHILE_rule_manual:
  assumes I0: "I x0"
  assumes IS: "WHILE_invar_OK b f I"
  assumes II: "\<And>x. \<lbrakk> I x; \<not>b x \<rbrakk> \<Longrightarrow> P x"
  shows "WHILE b f x0 \<le> SPEC P"
  using assms
  unfolding WHILE_invar_OK_def
  by (rule_tac WHILE_rule[of I], simp_all)

lemma WHILET_rule_manual:
  assumes I0: "I x0"
  assumes IS: "WHILE_variant_exists b f I"
  assumes II: "\<And>x. \<lbrakk> I x; \<not>b x \<rbrakk> \<Longrightarrow> P x"
  shows "WHILET b f x0 \<le> SPEC P"
  proof -
    from IS [unfolded WHILE_variant_exists_def]
    obtain R where variant_OK: "WHILE_variant_OK b f I R" by blast

    with I0 II show ?thesis 
      unfolding WHILE_variant_OK_def 
      apply (rule_tac WHILET_rule[of R I])
      apply (simp_all)
    done
  qed

subsubsection \<open> Multisets / Bags \<close>

definition workbag_update where
  "workbag_update wb e N \<equiv> (wb - {#e#}) + N"

definition WORKBAG_b where
  "WORKBAG_b b = (\<lambda>swb. snd swb \<noteq> {#} \<and> b (fst swb))"

definition WORKBAG_f ::
 "('s \<Rightarrow> bool) \<Rightarrow> ('s \<Rightarrow> 'e \<Rightarrow> ('s \<times> 'e multiset) nres) \<Rightarrow> 
   's \<times> 'e multiset \<Rightarrow> ('s \<times> 'e multiset) nres" where
  "WORKBAG_f b f = (\<lambda>swb. do {
     ASSERT (WORKBAG_b b swb);
     e \<leftarrow> SPEC (\<lambda>e. e \<in># (snd swb)); 
     (s', N) \<leftarrow> f (fst swb) e;
     RETURN (s', workbag_update (snd swb) e N)})"

definition WORKBAGI ("WORKBAGI\<^bsup>_\<^esup>") where
  "WORKBAGI \<Phi> b f swb0 = 
   WHILEI \<Phi> (WORKBAG_b b) (WORKBAG_f b f) swb0"

definition WORKBAG where "WORKBAG \<equiv> WORKBAGI (\<lambda>_. True)"

definition WORKBAGIT ("WORKBAGI\<^isub>T\<^bsup>_\<^esup>") where 
  "WORKBAGIT \<Phi> b f swb0 \<equiv> WHILEIT \<Phi> (WORKBAG_b b) (WORKBAG_f b f) swb0"

definition WORKBAGT ("WORKBAG\<^isub>T") where "WORKBAG\<^isub>T \<equiv> WORKBAGIT (\<lambda>_. True)"

definition WORKBAG_invar_OK where
  "WORKBAG_invar_OK cond step invar =
   (\<forall>s wb e. invar (s, wb) \<and> e \<in># wb \<and> cond s \<longrightarrow>
             step s e \<le> SPEC (\<lambda>s'N. (invar (fst s'N, (workbag_update wb e (snd s'N))))))"

lemma WORKBAG_invar_OK___lift_to_while :
assumes invar_OK: "WORKBAG_invar_OK cond step invar"
shows "WHILE_invar_OK (WORKBAG_b cond) (WORKBAG_f cond step) invar"
proof
  fix swb
  assume cond: "WORKBAG_b cond swb"
     and invar: "invar swb"
  obtain s wb where swb_eq[simp]: "swb = (s, wb)" by (rule prod.exhaust)

  from cond have wb_neq: "wb \<noteq> {#}" unfolding WORKBAG_b_def by simp

  from cond invar invar_OK 
  have invar_OK': "\<And>e. e \<in># wb \<Longrightarrow> step s e \<le> SPEC (\<lambda>s'N. invar (fst s'N, workbag_update wb e (snd s'N)))" 
    unfolding WORKBAG_invar_OK_def WORKBAG_b_def by simp

  thus "WORKBAG_f cond step swb \<le> SPEC invar"
    unfolding WORKBAG_f_def
    apply (intro refine_vcg)
    apply (rule cond)
    apply (simp add: wb_neq)[]
    apply (metis (mono_tags, lifting) Collect_cong case_prod_unfold)
  done
qed

definition WORKBAG_variant_OK where
  "WORKBAG_variant_OK cond step invar r \<equiv>
   (wf r \<and>
   (\<forall>s wb e. (invar (s, wb) \<and> e \<in># wb \<and> cond s \<longrightarrow>
     step s e \<le> SPEC (\<lambda>s'N. (invar (fst s'N, (workbag_update wb e (snd s'N)))) \<and>
      ((fst s'N, s) \<in> r \<or> (s'N = (s, {#})))))))"

definition WORKBAG_variant_exists where
  "WORKBAG_variant_exists cond step invar \<equiv>
   \<exists>r. WORKBAG_variant_OK cond step invar r"

definition
  mset_less_rel :: "('a multiset * 'a multiset) set" where
  "mset_less_rel = {(A,B). A \<subset># B}"

lemma WORKBAG_variant_OK___lift_to_while :
fixes invar :: "'S \<times> 'e multiset \<Rightarrow> bool"
assumes var_OK: "WORKBAG_variant_OK cond step invar r"
shows "WHILE_variant_OK (WORKBAG_b cond) (WORKBAG_f cond step) 
  invar (r <*lex*> mset_less_rel)"
proof 
  { 
    from var_OK have "wf r" 
      unfolding WORKBAG_variant_OK_def
      by fast
    with wf_subset_mset_rel
    show "wf (r <*lex*> mset_less_rel)"
      by (simp add: \<open>wf {(M, N). M \<subset># N}\<close> mset_less_rel_def wf_lex_prod)
  }

  fix swb :: "'S \<times> 'e multiset"
  obtain s wb where swb_eq[simp]: "swb = (s, wb)" by (rule prod.exhaust)

  assume invar_swb: "invar swb"
     and cond_swb: "WORKBAG_b cond swb"

  from var_OK invar_swb cond_swb have var_OK': "\<And>e. e \<in># wb \<Longrightarrow> 
    step s e \<le> SPEC (\<lambda>s'N. invar (fst s'N, workbag_update wb e (snd s'N)) \<and>
             ((fst s'N, s) \<in> r \<or> s'N = (s, {#})))" 
    unfolding WORKBAG_b_def WORKBAG_variant_OK_def by simp

  have spec_step: "\<And>e. e \<in># wb \<Longrightarrow>
        SPEC (\<lambda>s'N. invar (fst s'N, workbag_update wb e (snd s'N)) \<and>
             ((fst s'N, s) \<in> r \<or> s'N = (s, {#}))) \<le> 
        SPEC
           (\<lambda>xa. invar (fst xa, workbag_update wb e (snd xa)) \<and>
                 ((fst xa, s) \<in> r \<or>
                  fst xa = s \<and>
                  (workbag_update wb e (snd xa), wb) \<in> mset_less_rel))"
   by (auto simp add: subset_iff workbag_update_def mset_less_rel_def mset_subset_diff_self)

  from cond_swb have "wb \<noteq> {#}" unfolding WORKBAG_b_def by simp
  with order_trans [OF var_OK' spec_step]
  show "WORKBAG_f cond step swb \<le> SPEC (\<lambda>s'. invar s' \<and> (s', swb) \<in> r <*lex*> mset_less_rel)" 
    unfolding WORKBAG_f_def
    apply (intro refine_vcg cond_swb)
    apply (simp_all add: split_beta)
  done
qed

lemma WORKBAG_variant_exists___lift_to_while :
"WORKBAG_variant_exists cond step invar \<Longrightarrow>
 WHILE_variant_exists (WORKBAG_b cond) (WORKBAG_f cond step) invar"
unfolding WORKBAG_variant_exists_def WHILE_variant_exists_def         
by (metis WORKBAG_variant_OK___lift_to_while)


lemma WORKBAGI_rule_manual:
  assumes I0: "I (s0, wb0)"
  assumes IS: "WORKBAG_invar_OK b f I"
  assumes II1: "\<And>s wb. \<lbrakk> I (s, wb); \<not>b s; wb \<noteq> {#} \<rbrakk> \<Longrightarrow> P (s, wb)"
  assumes II2: "\<And>s. I (s, {#}) \<Longrightarrow> P (s, {#})"
  shows "WORKBAGI I b f (s0, wb0) \<le> SPEC P"
  unfolding WORKBAGI_def
  proof (rule WHILEI_rule_manual)
    from I0 show "I (s0, wb0)" .
  next
    from WORKBAG_invar_OK___lift_to_while [OF IS]
    show "WHILE_invar_OK (WORKBAG_b b) (WORKBAG_f b f) I" .
  next
    fix x
    assume "I x" "\<not> WORKBAG_b b x"
    with II1[of "fst x" "snd x"] II2[of "fst x"] show "P x"
      unfolding WORKBAG_b_def 
      by (cases x, auto)
  qed

lemma WORKBAGIT_rule_manual:
  assumes I0: "I (s0, wb0)"
  assumes IS: "WORKBAG_variant_exists b f I"
  assumes II1: "\<And>s wb. \<lbrakk> I (s, wb); \<not>b s; wb \<noteq> {#} \<rbrakk> \<Longrightarrow> P (s, wb)"
  assumes II2: "\<And>s. I (s, {#}) \<Longrightarrow> P (s, {#})"
  shows "WORKBAGIT I b f (s0, wb0) \<le> SPEC P"
  unfolding WORKBAGIT_def
  proof (rule WHILEIT_rule_manual)
    from I0 show "I (s0, wb0)" .
  next
    from WORKBAG_variant_exists___lift_to_while [OF IS]
    show "WHILE_variant_exists (WORKBAG_b b) (WORKBAG_f b f) I" .
  next
    fix x
    assume "I x" "\<not> WORKBAG_b b x"
    with II1[of "fst x" "snd x"] II2[of "fst x"] show "P x"
      unfolding WORKBAG_b_def 
      by (cases x, auto)
  qed

lemma WORKBAGIT_rule:
  assumes "I (s0, wb0)"
  assumes "wf R"
  assumes "\<And>s wb e. \<lbrakk>I (s, wb); e \<in># wb; b s\<rbrakk> \<Longrightarrow>
    f s e \<le> SPEC (\<lambda>s'N.
           I (fst s'N, workbag_update wb e (snd s'N)) \<and>
           ((fst s'N, s) \<in> R \<or> s'N = (s, {#})))"
  assumes "\<And>s wb. \<lbrakk> I (s, wb); \<not>b s; wb \<noteq> {#} \<rbrakk> \<Longrightarrow> P (s, wb)"
  assumes "\<And>s. I (s, {#}) \<Longrightarrow> P (s, {#})"
  shows "WORKBAGIT I b f (s0, wb0) \<le> SPEC P"
  using assms 
  apply (rule_tac WORKBAGIT_rule_manual)
  apply (simp_all add: WORKBAG_variant_exists_def WORKBAG_variant_OK_def)
  apply blast
done

subsubsection \<open> Lists \<close>

text \<open> A simple possibility to implement multisets are lists. \<close>

text \<open> WORKLIST_b: swl is a pair and the second element is a list.
       it checks first list's satisfication of b
       and then second list not empty\<close>

definition WORKLIST_b where
  "WORKLIST_b b = (\<lambda>swl. snd swl \<noteq> [] \<and> b (fst swl))"

definition WORKLIST_f ::
 "('s \<Rightarrow> bool) \<Rightarrow>
  ('s \<Rightarrow> 'e \<Rightarrow> ('s \<times> 'e list) nres) \<Rightarrow> 
   's \<times> 'e list \<Rightarrow> ('s \<times> 'e list) nres" where
  (* get the first element from the list of the second element of swl
     and then compute f with the parameter e and fst swl
     finally return the result s' and new lists N (N can be empty list) *)
  "WORKLIST_f b f = (\<lambda>swl. do {
     ASSERT (WORKLIST_b b swl); 
     let e = hd (snd swl); 
     (s', N) \<leftarrow> f (fst swl) e;
     RETURN (s', N @ tl (snd swl))})"

definition WORKLISTI ("WORKLISTI\<^bsup>_\<^esup>") where
  "WORKLISTI \<Phi> b f swl0 = WHILEI \<Phi> (WORKLIST_b b) (WORKLIST_f b f) swl0"

definition WORKLIST where "WORKLIST \<equiv> WORKLISTI (\<lambda>_. True)"

definition WORKLISTIT ("WORKLISTI\<^isub>T\<^bsup>_\<^esup>") where 
  "WORKLISTIT \<Phi> b f swl0 \<equiv> WHILEIT \<Phi> (WORKLIST_b b) (WORKLIST_f b f) swl0"

definition WORKLISTT ("WORKLIST\<^isub>T") where "WORKLIST\<^isub>T \<equiv> WORKLISTIT (\<lambda>_. True)"

lemma WORKLISTT_alt_def :
  "WORKLISTT b f swl0 = WHILET (WORKLIST_b b) (WORKLIST_f b f) swl0"
unfolding WORKLISTT_def WORKLISTIT_def WHILET_def[symmetric] 
by simp

definition worklist_build_rel where
  "worklist_build_rel = build_rel (apsnd mset) (\<lambda>_. True)"

lemma worklist_build_rel_sv[simp, intro!]: "single_valued worklist_build_rel"
  unfolding worklist_build_rel_def by rule

lemma WORKBAGIT_LIST_refine:
  assumes R0: "s0' = (s0::'S) \<and> wb0 = mset (wl0 :: 'e list)"
  assumes RPHI: "\<And>s wl. \<Phi>' (s, mset wl) \<Longrightarrow> \<Phi> (s, wl)"
  assumes RB: "\<And>s wl. \<lbrakk>  \<Phi>(s, wl); \<Phi>' (s, mset wl) \<rbrakk> \<Longrightarrow> b s \<longleftrightarrow> b' s"
  assumes RS[refine]: 
    "\<And>s wl e. \<lbrakk> \<Phi>(s, wl); \<Phi>' (s, mset wl); b s; b' s; e \<in> set wl\<rbrakk> \<Longrightarrow> 
        f s e \<le> \<Down>worklist_build_rel (f' s e)"
  shows "WORKLISTIT \<Phi> b f (s0, wl0) \<le> 
         \<Down>worklist_build_rel (WORKBAGIT \<Phi>' b' f' (s0', wb0))"
  unfolding WORKLISTIT_def WORKBAGIT_def 
proof (rule WHILEIT_refine)
  from R0 show "((s0, wl0), s0', wb0) \<in> worklist_build_rel"
    unfolding worklist_build_rel_def build_rel_def
    by auto
next
  fix swl :: "('S \<times> 'e list)" and swb
  assume "(swl, swb) \<in> worklist_build_rel"
  then obtain s wl where swl_eq[simp] : "swl = (s, wl)"
                     and swb_eq[simp] : "swb = (s, mset wl)"
    unfolding worklist_build_rel_def build_rel_def
    by (cases swl, cases swb, auto)

  assume PHI': "\<Phi>' swb"
  with RPHI show PHI: "\<Phi> swl" by simp

  from RB PHI PHI' show "WORKLIST_b b swl = WORKBAG_b b' swb"
    by (simp add: WORKLIST_b_def WORKBAG_b_def)

  assume "WORKLIST_b b swl"
  with RB PHI PHI' have "b s" and "b' s"
    unfolding WORKLIST_b_def by auto

  from `WORKLIST_b b swl`
  obtain e wl' where wl_eq[simp]: "wl = e # wl'"
    unfolding WORKLIST_b_def by (cases wl, auto)

  from RS[of s wl] PHI PHI' `b s` `b' s`
  have f_ref: "f s e \<le> \<Down> worklist_build_rel (f' s e)" by simp

  show "WORKLIST_f b f swl \<le> \<Down> worklist_build_rel (WORKBAG_f b' f' swb)"
    unfolding WORKBAG_f_def WORKLIST_f_def WORKBAG_b_def WORKLIST_b_def
    apply (rule ASSERT_refine_right)
    apply (rule ASSERT_refine_left)
    apply (simp add: `b s` `b' s`)
    apply (rule bind2let_refine [where R' = "{(e, e)}"])
     apply (simp add: Image_iff pw_le_iff)
    apply (simp add: pw_conc_inres)
    apply (rule_tac bind_refine [where R' = "worklist_build_rel"])
    apply (simp add: f_ref)
    apply (auto simp add: 
     worklist_build_rel_def workbag_update_def pw_le_iff refine_pw_simps union_commute)
    by (simp add: in_br_conv)
qed

lemma WORKBAGIT_LIST_refine_simple:
  assumes RS: 
    "\<And>s wl e. \<lbrakk> \<Phi> (s, mset wl); b s; e \<in> set wl \<rbrakk> \<Longrightarrow> 
        f s e \<le> \<Down>worklist_build_rel (f' s e)"
  shows "WORKLISTIT (\<lambda>(s, wl). \<Phi> (s, mset wl)) b f (s0, wl0) \<le> 
         \<Down>worklist_build_rel (WORKBAGIT \<Phi> b f' (s0, mset wl0))"
apply (rule WORKBAGIT_LIST_refine)
apply (simp_all add: RS)
done


definition WORKLIST_invar_OK where
  "WORKLIST_invar_OK cond step invar =
   (\<forall>s wl e. invar (s, (e # wl)) \<and> cond s \<longrightarrow>
             step s e \<le> SPEC (\<lambda>s'N. (invar (fst s'N, (snd s'N) @ wl))))"

lemma WORKLIST_invar_OK___lift_to_while :
assumes invar_OK: "WORKLIST_invar_OK cond step invar"
shows "WHILE_invar_OK (WORKLIST_b cond) (WORKLIST_f cond step) invar"
proof
  fix swl
  assume cond: "WORKLIST_b cond swl"
     and invar: "invar swl"
  obtain s wl where swl_eq[simp]: "swl = (s, wl)" by (rule prod.exhaust)

  from cond obtain e wl' where wl_eq[simp]: "wl = e # wl'" 
    unfolding WORKLIST_b_def by (simp, cases wl, blast)

  from cond invar invar_OK 
  have invar_OK': "step s e \<le> SPEC (\<lambda>x. invar (fst x, snd x @ wl'))" 
    unfolding WORKLIST_invar_OK_def WORKLIST_b_def by simp

  thus "WORKLIST_f cond step swl \<le> SPEC invar"
    unfolding WORKLIST_f_def
    apply (intro refine_vcg)
    apply (rule cond)
    apply (simp add: split_beta)
  done
qed

definition WORKLIST_variant_OK where
  "WORKLIST_variant_OK cond step invar r \<equiv>
   (wf r \<and>
   (\<forall>s wl e. (invar (s, e # wl) \<and> cond s \<longrightarrow>
     step s e \<le> SPEC (\<lambda>s'N. (invar (fst s'N, (snd s'N) @ wl)) \<and>
      ((fst s'N, s) \<in> r \<or> (s'N = (s, [])))))))"

definition WORKLIST_variant_exists where
  "WORKLIST_variant_exists cond step invar \<equiv>
   \<exists>r. WORKLIST_variant_OK cond step invar r"

lemma WORKLIST_variant_OK___lift_to_while :
fixes invar :: "'S \<times> 'e list \<Rightarrow> bool"
assumes var_OK: "WORKLIST_variant_OK cond step invar r"
shows "WHILE_variant_OK (WORKLIST_b cond) (WORKLIST_f cond step) invar (r <*lex*> measure length)"
proof 
  { 
    from var_OK have "wf r" 
      unfolding WORKLIST_variant_OK_def
      by fast
    thus "wf (r <*lex*> measure length)" by auto
  }

  fix swl :: "'S \<times> 'e list"
  obtain s wl where swl_eq[simp]: "swl = (s, wl)" by (rule prod.exhaust)

  assume invar_swl: "invar swl"
     and cond_swl: "WORKLIST_b cond swl"

  from cond_swl obtain e wl' where wl_eq[simp]: "wl = e # wl'"
    unfolding WORKLIST_b_def by (simp, cases wl, blast)

  from var_OK invar_swl cond_swl have var_OK': " 
    step s e \<le> SPEC (\<lambda>s'N. invar (fst s'N, (snd s'N) @ wl') \<and>
             ((fst s'N, s) \<in> r \<or> s'N = (s, [])))" 
    unfolding WORKLIST_b_def WORKLIST_variant_OK_def by simp

  have spec_step: "
        SPEC (\<lambda>s'N. invar (fst s'N, (snd s'N) @ wl') \<and>
             ((fst s'N, s) \<in> r \<or> s'N = (s, []))) \<le> 
        SPEC
           (\<lambda>xa. invar (fst xa, (snd xa) @ wl') \<and>
                 ((fst xa, s) \<in> r \<or>
                  fst xa = s \<and>
                  ((snd xa) @ wl', wl) \<in> measure length))"
   by (auto simp add: subset_iff)

  from order_trans [OF var_OK' spec_step]
  show "WORKLIST_f cond step swl \<le> SPEC (\<lambda>s'. invar s' \<and> (s', swl) \<in> r <*lex*> measure length)" 
    unfolding WORKLIST_f_def
    apply (intro refine_vcg cond_swl)
    apply (simp_all add: split_beta)
  done
qed

lemma WORKLIST_variant_exists___lift_to_while :
"WORKLIST_variant_exists cond step invar \<Longrightarrow>
 WHILE_variant_exists (WORKLIST_b cond) (WORKLIST_f cond step) invar"
unfolding WORKLIST_variant_exists_def WHILE_variant_exists_def         
by (metis WORKLIST_variant_OK___lift_to_while)

lemma WORKLISTI_rule_manual:
  assumes I0: "I (s0, wl0)"
  assumes IS: "WORKLIST_invar_OK b f I"
  assumes II1: "\<And>s wl. \<lbrakk> I (s, wl); \<not>b s; wl \<noteq> []\<rbrakk> \<Longrightarrow> P (s, wl)"
  assumes II2: "\<And>s. I (s, []) \<Longrightarrow> P (s, [])"
  shows "WORKLISTI I b f (s0, wl0) \<le> SPEC P"
  unfolding WORKLISTI_def
  proof (rule WHILEI_rule_manual)
    from I0 show "I (s0, wl0)" .
  next
    from WORKLIST_invar_OK___lift_to_while [OF IS]
    show "WHILE_invar_OK (WORKLIST_b b) (WORKLIST_f b f) I" .
  next
    fix x
    assume "I x" "\<not> WORKLIST_b b x"
    with II1[of "fst x" "snd x"] II2[of "fst x"] show "P x"
      unfolding WORKLIST_b_def 
      by (cases x, auto)
  qed

lemma WORKLISTIT_rule_manual:
  assumes I0: "I (s0, wl0)"
  assumes IS: "WORKLIST_variant_exists b f I"
  assumes II1: "\<And>s wl. \<lbrakk> I (s, wl); \<not>b s; wl \<noteq> [] \<rbrakk> \<Longrightarrow> P (s, wl)"
  assumes II2: "\<And>s. I (s, []) \<Longrightarrow> P (s, [])"
  shows "WORKLISTIT I b f (s0, wl0) \<le> SPEC P"
  unfolding WORKLISTIT_def
  proof (rule WHILEIT_rule_manual)
    from I0 show "I (s0, wl0)" .
  next
    from WORKLIST_variant_exists___lift_to_while [OF IS]
    show "WHILE_variant_exists (WORKLIST_b b) (WORKLIST_f b f) I" .
  next
    fix x
    assume "I x" "\<not> WORKLIST_b b x"
    with II1[of "fst x" "snd x"] II2[of "fst x"] show "P x"
      unfolding WORKLIST_b_def 
      by (cases x, auto)
  qed

lemma WORKLISTIT_rule:
  assumes "I (s0, wl0)"
  assumes "wf R"
  assumes "\<And>s wl e. \<lbrakk>I (s, e # wl); b s\<rbrakk> \<Longrightarrow>
    f s e \<le> SPEC (\<lambda>s'N.
           I (fst s'N, (snd s'N) @ wl) \<and>
           ((fst s'N, s) \<in> R \<or> s'N = (s, [])))"
  assumes "\<And>s wl. \<lbrakk> I (s, wl); \<not>b s; wl \<noteq> [] \<rbrakk> \<Longrightarrow> P (s, wl)"
  assumes "\<And>s. I (s, []) \<Longrightarrow> P (s, [])"
  shows "WORKLISTIT I b f (s0, wl0) \<le> SPEC P"
  using assms 
  apply (rule_tac WORKLISTIT_rule_manual)
  apply (simp_all add: WORKLIST_variant_exists_def WORKLIST_variant_OK_def)
  apply blast
done



definition [simp]: "map_list_rel R \<equiv> {(l,l'). list_all2 (\<lambda>x x'. (x,x')\<in>R) l l'}"

lemma map_list_rel_RELATES[refine_dref_RELATES]:
  "RELATES R \<Longrightarrow> RELATES (map_list_rel R)" by (simp add: RELATES_def)


definition WORKLISTIT_refine_rel where
  "WORKLISTIT_refine_rel Rs Re = rprod Rs (map_list_rel Re)"



lemma WORKLISTIT_refine_rel_in [simp] :
  "x \<in> WORKLISTIT_refine_rel R_s R_e \<longleftrightarrow> 
   ((fst (fst x), fst (snd x)) \<in> R_s \<and>
    (snd (fst x), snd (snd x)) \<in> map_list_rel R_e)"
unfolding WORKLISTIT_refine_rel_def
by auto

lemma WORKLISTIT_refine[refine] :
assumes [refine]: "single_valued R_s" "single_valued R_e"
assumes I0: "(s0, s0') \<in> R_s" "(wl0, wl0') \<in> map_list_rel R_e"
assumes I_OK: "\<And>s wl s' wl'. \<lbrakk>(s, s') \<in> R_s; (wl, wl') \<in> map_list_rel R_e; I' (s', wl')\<rbrakk> \<Longrightarrow> I (s, wl)"
assumes b_OK: "\<And>s wl s' wl'. \<lbrakk>(s, s') \<in> R_s; (wl, wl') \<in> map_list_rel R_e; I' (s', wl'); I (s, wl)\<rbrakk> \<Longrightarrow> 
              b s = b' s'"
assumes f_OK: "\<And>s e s' e'. \<lbrakk>(s, s') \<in> R_s; (e, e') \<in> R_e; b s; b' s'\<rbrakk> \<Longrightarrow> 
   f s e \<le> \<Down>(WORKLISTIT_refine_rel R_s R_e) (f' s' e')"
shows "WORKLISTIT I b f (s0, wl0) \<le> \<Down>(WORKLISTIT_refine_rel R_s R_e) (WORKLISTIT I' b' f' (s0', wl0'))"
unfolding WORKLISTIT_def 
proof (rule WHILEIT_refine)
  show "((s0, wl0), s0', wl0') \<in> WORKLISTIT_refine_rel R_s R_e" 
    using I0 by simp
next
  fix swl swl'
  assume in_R: "(swl, swl') \<in> WORKLISTIT_refine_rel R_s R_e"
  obtain s wl where swl_eq[simp]: "swl = (s, wl)" by (rule prod.exhaust)
  obtain s' wl' where swl'_eq[simp]: "swl' = (s', wl')" by (rule prod.exhaust)

  from in_R have in_Rs[simp]: "(s, s') \<in> R_s" and 
                 in_Re[simp]: "(wl, wl') \<in> map_list_rel R_e" by simp_all

  assume I_swl': "I' swl'"
  thus I_swl: "I swl" using I_OK[OF in_Rs in_Re] by simp

  from in_Re have "wl = [] \<longleftrightarrow> wl' = []"
    by (rule_tac iffI, simp_all)
  thus "WORKLIST_b b swl = WORKLIST_b b' swl'"
    unfolding WORKLIST_b_def 
    using b_OK [OF in_Rs in_Re] I_swl I_swl' by simp

  assume b_swl: "WORKLIST_b b swl"
     and b_swl': "WORKLIST_b b' swl'"

  from b_swl obtain e wl_tl where wl_eq[simp]: "wl = e # wl_tl"
    unfolding WORKLIST_b_def by (simp, cases wl, blast)

  from b_swl' obtain e' wl_tl' where wl'_eq[simp]: "wl' = e' # wl_tl'"
    unfolding WORKLIST_b_def by (simp, cases wl', blast)

  from in_Re have in_Re': "(e, e') \<in> R_e" and in_Re'': "(wl_tl, wl_tl') \<in> map_list_rel R_e" by simp_all

  from b_swl b_swl'
  show "WORKLIST_f b f swl \<le> \<Down> (WORKLISTIT_refine_rel R_s R_e) (WORKLIST_f b' f' swl')"
    unfolding WORKLIST_f_def WORKLIST_b_def
    apply simp 
    apply (rule bind_refine [where ?R' = "(WORKLISTIT_refine_rel R_s R_e)"])
    apply (insert f_OK [OF in_Rs in_Re'], simp) []
    apply refine_rcg
    apply (insert in_Re'')
    apply (simp add: list_all2_appendI)
  done
qed 


subsection \<open> Code Generation for Worklists \<close>

definition worklist where
  "worklist b f \<equiv> while (WORKLIST_b b)
     (\<lambda>x. let xa = hd (snd x); (a, b) = f (fst x) xa in (a, b @ tl (snd x)))"

lemma worklist_alt_Nil_def :
   "worklist b f (s, []) = (s, [])"
unfolding worklist_def WORKLIST_b_def
by (subst while_unfold, simp)

lemma worklist_alt_Cons_def :
   "worklist b f (s, e # wl) = 
    (if (b s) then
       (let (s', N) = f s e in
       (worklist b f (s', N @ wl))) 
     else (s, e # wl))"
unfolding worklist_def WORKLIST_b_def
apply (subst while_unfold)
apply (cases "f s e")
apply simp
done

lemmas worklist_alt_def [simp, code] = worklist_alt_Nil_def worklist_alt_Cons_def

lemma WORKLISTIT_cgt [refine_transfer]:
  assumes F_OK[refine_transfer]: "\<And>s e. RETURN (f s e) \<le> F s e" 
  shows "RETURN (worklist b f (s, wl)) \<le> WORKLISTIT \<Phi> b F (s, wl)"
unfolding WORKLISTIT_def worklist_def WORKLIST_f_def
apply refine_transfer
done

lemma WORKLISTT_cgt [refine_transfer]:
  assumes F_OK: "\<And>s e. RETURN (f s e) \<le> F s e" 
  shows "RETURN (worklist b f (s, wl)) \<le> WORKLISTT b F (s, wl)"
unfolding WORKLISTT_def 
by (intro WORKLISTIT_cgt F_OK)

lemma WORKBAGIT_LIST_cgt :
  assumes RS: 
    "\<And>s wl e. \<lbrakk> \<Phi> (s, mset wl); b s; e \<in> set wl \<rbrakk> \<Longrightarrow> 
        RETURN (f s e) \<le> \<Down>worklist_build_rel (f' s e)"
  shows "RETURN (worklist b f (s0, wl0)) \<le> 
         \<Down>worklist_build_rel (WORKBAGIT \<Phi> b f' (s0, mset wl0))"
proof -
  note step1 = WORKLISTIT_cgt[where f = f and b = b and s = s0 and wl = wl0]
  note step2 = order_trans [OF step1 WORKBAGIT_LIST_refine_simple]

  note step3 = step2[where \<Phi>1 = \<Phi> and ?f1 = "\<lambda>s e. RETURN (f s e)"]
  from step3 RS show ?thesis
    by simp
qed

subsubsection {* Sets *}

text \<open> 
While worklist algorithm operate logically on multisets, 
using sets is often semantically equivalent. Essentially it means that
only the first operation on an element is important and all others are
ignored. Reasoning about sets is much easier. Therefore, a version
using sets is defined as well in the following. \<close>

definition workset_update where
  "workset_update wb e N \<equiv> (wb - {e}) \<union> N"

definition WORKSET_b where
  "WORKSET_b b = (\<lambda>sws. snd sws \<noteq> {} \<and> b (fst sws))"

definition WORKSET_f ::
 "('s \<Rightarrow> bool) \<Rightarrow> 
  ('s \<Rightarrow> 'e \<Rightarrow> ('s \<times> 'e set) nres) \<Rightarrow> 
   's \<times> 'e set \<Rightarrow> ('s \<times> 'e set) nres" where
  "WORKSET_f b f = (\<lambda>sws. do {
     ASSERT (WORKSET_b b sws);
     e \<leftarrow> SPEC (\<lambda>e. e \<in> (snd sws)); 
     (s', N) \<leftarrow> f (fst sws) e;
     ASSERT (finite N);
     RETURN (s', workset_update (snd sws) e N)})"

definition WORKSET_I where
  "WORKSET_I I = (\<lambda>sws. finite (snd sws) \<and> I sws)"

definition WORKSETI ("WORKSETI\<^bsup>_\<^esup>") where
  "WORKSETI \<Phi> b f sws0 = WHILEI (WORKSET_I \<Phi>) (WORKSET_b b) (WORKSET_f b f) sws0"

definition WORKSET where "WORKSET \<equiv> WORKSETI (\<lambda>_. True)"

definition WORKSETIT ("WORKSETI\<^isub>T\<^bsup>_\<^esup>") where 
  "WORKSETIT \<Phi> b f swb0 \<equiv> WHILEIT (WORKSET_I \<Phi>) (WORKSET_b b) (WORKSET_f b f) swb0"

definition WORKSETT ("WORKSET\<^isub>T") where "WORKSET\<^isub>T \<equiv> WORKSETIT (\<lambda>_. True)"

definition WORKSET_invar_OK where
  "WORKSET_invar_OK cond step invar =
   (\<forall>s ws e. invar (s, ws) \<and> e \<in> ws \<and> cond s \<longrightarrow>
             step s e \<le> SPEC (\<lambda>s'N. finite (snd s'N) \<and> 
                            invar (fst s'N, (workset_update ws e (snd s'N)))))"

lemma WORKSET_invar_OK___lift_to_while :
assumes invar_OK: "WORKSET_invar_OK cond step invar"
shows "WHILE_invar_OK (WORKSET_b cond) (WORKSET_f cond step) (WORKSET_I invar)"
proof
  fix sws
  assume cond: "WORKSET_b cond sws"
     and invar: "WORKSET_I invar sws"
  obtain s ws where sws_eq[simp]: "sws = (s, ws)" by (rule prod.exhaust)

  from cond invar invar_OK 
  have invar_OK': "\<And>e. e \<in> ws \<Longrightarrow> step s e \<le> SPEC (\<lambda>s'N. finite (snd s'N) \<and> 
         invar (fst s'N, workset_update ws e (snd s'N)))" 
    unfolding WORKSET_invar_OK_def WORKSET_b_def WORKSET_I_def by simp

  from invar have "finite ws" unfolding WORKSET_I_def by simp
  hence spec_step: "\<And>e. e \<in> ws \<Longrightarrow> SPEC (\<lambda>s'N. finite (snd s'N) \<and> 
         invar (fst s'N, workset_update ws e (snd s'N))) \<le> 
         SPEC (\<lambda>xa. ASSERT (finite (snd xa)) >>=
                 (\<lambda>_. RETURN (fst xa, workset_update ws e (snd xa)))
                 \<le> SPEC (\<lambda>sws. finite (snd sws) \<and> invar sws))" 
     by (simp add: subset_iff workset_update_def)

  from order_trans[OF invar_OK' spec_step]
  show "WORKSET_f cond step sws \<le> SPEC (WORKSET_I invar)"
    unfolding WORKSET_f_def WORKSET_I_def
    apply (intro refine_vcg cond)
    apply (simp add: split_beta)
  done
qed

definition WORKSET_variant_OK where
  "WORKSET_variant_OK cond step invar r \<equiv>
   (wf r \<and>
   (\<forall>s ws e. (invar (s, ws) \<and> e \<in> ws \<and> cond s \<longrightarrow>
     step s e \<le> SPEC (\<lambda>s'N. finite (snd s'N) \<and>
      (invar (fst s'N, (workset_update ws e (snd s'N)))) \<and>
      ((fst s'N, s) \<in> r \<or> ((s = fst s'N) \<and> snd s'N = {}))))))"

definition WORKSET_variant_exists where
  "WORKSET_variant_exists cond step invar \<equiv>
   \<exists>r. WORKSET_variant_OK cond step invar r"

lemma WORKSET_variant_OK___lift_to_while :
fixes invar :: "'S \<times> 'e set \<Rightarrow> bool"
assumes var_OK: "WORKSET_variant_OK cond step invar r"
shows "WHILE_variant_OK (WORKSET_b cond) (WORKSET_f cond step) 
                        (WORKSET_I invar) (r <*lex*> measure card)"
proof 
  { 
    from var_OK have "wf r" 
      unfolding WORKSET_variant_OK_def
      by fast
    with wf_subset_mset_rel
    show "wf (r <*lex*> measure card)" by auto
  }

  fix sws :: "'S \<times> 'e set"
  obtain s ws where sws_eq[simp]: "sws = (s, ws)" by (rule prod.exhaust)

  assume invar_sws: "WORKSET_I invar sws"
     and cond_sws: "WORKSET_b cond sws"

  from var_OK invar_sws cond_sws have var_OK': "\<And>e. e \<in> ws \<Longrightarrow> 
    step s e \<le> SPEC (\<lambda>s'N. finite (snd s'N) \<and> invar (fst s'N, workset_update ws e (snd s'N)) \<and>
             ((fst s'N, s) \<in> r \<or> s = fst s'N \<and> snd s'N = {}))" 
    unfolding WORKSET_b_def WORKSET_variant_OK_def WORKSET_I_def by simp

  from invar_sws
  have spec_step: "\<And>e. e \<in> ws \<Longrightarrow>
        (SPEC (\<lambda>s'N. finite (snd s'N) \<and> invar (fst s'N, workset_update ws e (snd s'N)) \<and>
             ((fst s'N, s) \<in> r \<or> s = fst s'N \<and> snd s'N = {})) \<le> 
         SPEC
               (\<lambda>xa. ASSERT (finite (snd xa)) >>=
                 (\<lambda>_. RETURN (fst xa, workset_update ws e (snd xa)))
                 \<le> SPEC
                    (\<lambda>s'. (WORKSET_I invar s') \<and>
                          (s', s, ws) \<in> r <*lex*> measure card)))"
    apply (auto simp add: subset_iff workset_update_def WORKSET_I_def)
    apply (metis card_gt_0_iff diff_Suc_less equals0D)
  done

  from order_trans [OF var_OK' spec_step]
  show "WORKSET_f cond step sws \<le> SPEC (\<lambda>s'. WORKSET_I invar s' \<and> (s', sws) \<in> r <*lex*> measure card)" 
    unfolding WORKSET_f_def
    apply (intro refine_vcg cond_sws)
    apply (simp add: split_beta)
  done
qed

lemma WORKSET_variant_exists___lift_to_while :
"WORKSET_variant_exists cond step invar \<Longrightarrow>
 WHILE_variant_exists (WORKSET_b cond) (WORKSET_f cond step) (WORKSET_I invar)"
proof -
  assume "WORKSET_variant_exists cond step invar"
  then obtain r where "WORKSET_variant_OK cond step invar r"
    unfolding WORKSET_variant_exists_def by blast
  from WORKSET_variant_OK___lift_to_while[OF this]
  show "WHILE_variant_exists (WORKSET_b cond) (WORKSET_f cond step) (WORKSET_I invar)"
    unfolding WHILE_variant_exists_def by blast
qed

lemma WORKSETI_rule_manual:
  assumes I0_fin: "finite ws0"
  assumes I0: "I (s0, ws0)"
  assumes IS: "WORKSET_invar_OK b f I"
  assumes II1: "\<And>s ws. \<lbrakk> I (s, ws); finite ws; \<not>b s \<rbrakk> \<Longrightarrow> P (s, ws)"
  assumes II2: "\<And>s. I (s, {}) \<Longrightarrow> P (s, {})"
  shows "WORKSETI I b f (s0, ws0) \<le> SPEC P"
  unfolding WORKSETI_def
  proof (rule WHILEI_rule_manual)
    from I0 I0_fin show "WORKSET_I I (s0, ws0)" unfolding WORKSET_I_def by simp
  next
    from WORKSET_invar_OK___lift_to_while [OF IS]
    show "WHILE_invar_OK (WORKSET_b b) (WORKSET_f b f) (WORKSET_I I)" .
  next
    fix x
    assume "WORKSET_I I x" "\<not> WORKSET_b b x"
    with II1[of "fst x" "snd x"] II2[of "fst x"] show "P x"
      unfolding WORKSET_b_def WORKSET_I_def 
      by (cases x, auto)
  qed

lemma WORKSETIT_rule_manual:
  assumes I0_fin: "finite ws0"
  assumes I0: "I (s0, ws0)"
  assumes IS: "WORKSET_variant_exists b f I"
  assumes II1: "\<And>s ws. \<lbrakk> I (s, ws); finite ws; \<not>b s \<rbrakk> \<Longrightarrow> P (s, ws)"
  assumes II2: "\<And>s. I (s, {}) \<Longrightarrow> P (s, {})"
  shows "WORKSETIT I b f (s0, ws0) \<le> SPEC P"
  unfolding WORKSETIT_def
  proof (rule WHILEIT_rule_manual)
    from I0 I0_fin show "WORKSET_I I (s0, ws0)" unfolding WORKSET_I_def by simp
  next
    from WORKSET_variant_exists___lift_to_while [OF IS]
    show "WHILE_variant_exists (WORKSET_b b) (WORKSET_f b f) (WORKSET_I I)" .
  next
    fix x
    assume "WORKSET_I I x" "\<not> WORKSET_b b x"
    with II1[of "fst x" "snd x"] II2[of "fst x"] show "P x"
      unfolding WORKSET_b_def WORKSET_I_def
      by (cases x, auto)
  qed

end 