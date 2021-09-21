(*  Title:       Implementing accessibility using the collection framework
    Authors:     Thomas Tuerk <tuerk@in.tum.de>
*)

section \<open> Accessibility computations using the collection framework \<close>  

theory Accessible_Impl
imports Main Accessible
        "Collections.Collections"
begin

definition (in StdSet) accessible_abort_impl where
  "accessible_abort_impl exit succ_list rs wl =
   WORKLISTT  
    (\<lambda>s. \<not> (fst s))
    (\<lambda>s e. 
       if (memb e (snd s)) then
         (RETURN (s, []))
       else                 
         RETURN ((exit e, ins e (snd s)), succ_list e)
     ) ((False, rs), wl)"



lemma (in StdSet) accessible_abort_impl_correct : 
assumes succ_list_OK: "\<And>q. set (succ_list q) = {q'. (q,q') \<in> R}"
    and invar_rs: "invar rs"
shows "accessible_abort_impl exit succ_list rs wl \<le> 
         \<Down>(WORKLISTIT_refine_rel (build_rel (\<lambda>s. (fst s, \<alpha> (snd s))) (\<lambda>s. invar (snd s))) Id)
       (accessible_worklist exit R (\<alpha> rs) wl)"
  unfolding accessible_abort_impl_def accessible_worklist_def WORKLISTT_def
  apply (rule WORKLISTIT_refine)
  apply (simp only: br_sv)
  apply (simp_all add: invar_rs list_all2_refl)
  apply (simp add: br_def)
  apply (simp add: invar_rs)
  apply (simp add: br_def)+
  apply (auto simp add: correct invar_rs succ_list_OK pw_le_iff 
                      list_all2_eq[symmetric]) 
  apply (auto simp add: inres_def nofail_def)
  
proof -
  fix a b e'
  define mx where "mx = (succ_list e')"
  define mm where "mm = RETURN ((exit e', ins e' b), succ_list e') "
  define m\<psi> where "m\<psi> = (\<lambda>wl. set wl = {y. (e', y) \<in> R})"
  define mf' where "mf' = (\<lambda>N::'x list. RETURN ((exit e', insert e' (\<alpha> b)), N))"
  assume neg_a: "\<not> a" and
         invar_b: "invar b" and
         enotin: "e' \<notin> \<alpha> b" and 
         spec_p: "SPEC (\<lambda>wl. set wl = {y. (e', y) \<in> R}) \<bind> 
                  (\<lambda>N. RETURN ((exit e', insert e' (\<alpha> b)), N)) \<noteq> FAIL"
  from spec_p succ_list_OK have PRE1:
   "m\<psi> mx" unfolding m\<psi>_def mx_def by auto
  from this have PRE2:
   "mm \<le> \<Down>(WORKLISTIT_refine_rel {(c, a). a = (fst c, \<alpha> (snd c)) \<and> invar (snd c)} Id)
    (mf' mx)"
    unfolding mf'_def mx_def mm_def
    apply (auto)
    apply (simp add: ins_correct(1) invar_b)
    apply (simp add: ins_correct(1) invar_b)
    using ins_correct(1) invar_b apply blast
    apply (simp add: ins_correct(2) invar_b)
    by (simp add: list.rel_eq)
  from PRE1 PRE2 show "mm
       \<le> \<Down> (WORKLISTIT_refine_rel {(c, a). a = (fst c, \<alpha> (snd c)) \<and> invar (snd c)} Id)
           (SPEC m\<psi> \<bind> mf')"
    apply (auto simp add: PRE1 PRE2 rhs_step_bind_SPEC)
    using PRE1 PRE2 rhs_step_bind_SPEC by fastforce
qed



definition (in StdSet) accessible_abort_code where
  "accessible_abort_code exit succ_list rs wl = 
   worklist (\<lambda>s. \<not> fst s)
   (\<lambda>s e.
       if memb e (snd s) then (s, [])
       else ((exit e, ins e (snd s)), succ_list e))
   ((False, rs), wl)"

lemma (in StdSet) accessible_abort_code_aux: 
  "RETURN (accessible_abort_code exit succ_list rs wl) \<le> 
   accessible_abort_impl exit succ_list rs wl"
unfolding accessible_abort_impl_def accessible_abort_code_def
by (rule refine_transfer)+


lemma (in StdSet) accessible_abort_code_correct : 
fixes R :: "('x \<times> 'x) set"
assumes fin_res: "finite (accessible_restrict R (\<alpha> rs) (set wl))"
    and succ_list_OK: "\<And>q. set (succ_list q) = {q'. (q,q') \<in> R}"
    and invar_rs: "invar rs"
shows "let ((ex, rs'), wl') = accessible_abort_code exit succ_list rs wl in
    accessible_restrict R (\<alpha> rs') (set wl') =
    accessible_restrict R (\<alpha> rs) (set wl) \<and>
    ((\<forall>x. x \<in> \<alpha> rs' \<longrightarrow> x \<in> \<alpha> rs \<or> \<not> exit x) \<longrightarrow> wl' = []) \<and>
    (\<exists>x. x \<in> \<alpha> rs' \<and> x \<notin> \<alpha> rs \<and> exit x) = ex \<and> invar rs'"
proof -
  note accessible_abort_code_aux
  also note accessible_abort_impl_correct [OF succ_list_OK invar_rs]
  also note accessible_worklist_thm[OF fin_res, of "exit"]
  finally show ?thesis
    apply (erule_tac RETURN_ref_SPECD)
    apply (simp add: Image_iff Bex_def case_prod_beta list_all2_eq [symmetric])
    apply (rule conjI)
    apply (simp add: br_def)
    apply (simp add: br_def)
  done
qed


subsection \<open> Accessibility \<close>

definition (in StdSet) accessible_restrict_impl where
  "accessible_restrict_impl succ_list rs wl =
   do {
     (res, _) \<leftarrow> WORKLISTT  (\<lambda>_. True)
       (\<lambda>s e. 
         if (memb e s) then
           (RETURN (s, []))
         else                    
           RETURN (ins e s, succ_list e)
       ) (rs, wl);
       RETURN res
     }"

lemma (in StdSet) accessible_restrict_impl_correct : 
shows "accessible_restrict_impl succ_list rs wl \<le> \<Down>Id
       (do {((_, res), _) \<leftarrow> (accessible_abort_impl (\<lambda>_. False) succ_list rs wl); RETURN res})"
unfolding accessible_abort_impl_def accessible_restrict_impl_def WORKLISTT_def
apply (rule bind_refine 
   [where R' = "WORKLISTIT_refine_rel (build_rel (Pair False) (\<lambda>_. True)) Id"])
apply (rule WORKLISTIT_refine)
apply (simp only: br_sv)
      apply (auto simp add: list_all2_eq[symmetric] pw_le_iff refine_pw_simps)
     apply (simp add: br_def)
     apply (simp add: br_def)
     apply (simp add: br_def)
     apply (simp add: br_def)
     apply (simp add: br_def)
  apply (auto)
apply (simp add: br_def)
     
done

schematic_goal (in StdSet) accessible_restrict_code_aux2: 
  "RETURN ?code \<le> 
   accessible_restrict_impl succ_list rs wl"
unfolding accessible_restrict_impl_def 
apply (rule refine_transfer)+
done

definition (in StdSet) accessible_restrict_code where
  "accessible_restrict_code succ_list rs wl = 
   (let (res, _) = (worklist (\<lambda>s. True)
   (\<lambda>s e.
       if memb e s then (s, [])
       else (ins e s, succ_list e))
   (rs, wl)) in res)"

lemma (in StdSet) accessible_restrict_code_aux: 
  "RETURN (accessible_restrict_code succ_list rs wl) \<le> 
   accessible_restrict_impl succ_list rs wl"
using accessible_restrict_code_aux2 [of succ_list rs wl]
unfolding accessible_restrict_code_def by simp


lemma (in StdSet) accessible_restrict_code_correct : 
fixes R :: "('x \<times> 'x) set"
fixes succ_list rs wl
defines "rs' \<equiv> accessible_restrict_code succ_list rs wl"
assumes fin_res: "finite (accessible_restrict R (\<alpha> rs) (set wl))"
    and succ_list_OK: "\<And>q. set (succ_list q) = {q'. (q,q') \<in> R}"
    and invar_rs: "invar rs"
shows "invar rs' \<and>
       \<alpha> rs' = accessible_restrict R (\<alpha> rs) (set wl)"
proof -
  note step1 = order_trans [OF accessible_restrict_code_aux 
                   accessible_restrict_impl_correct [of succ_list rs wl, simplified]]

  note abort_impl_OK = accessible_abort_impl_correct [OF succ_list_OK invar_rs]
  note step2 = ref_two_step [OF abort_impl_OK accessible_worklist_thm, OF fin_res,
    of "\<lambda>_. False"]

  have step3: "do {((_, res), _) \<leftarrow> accessible_abort_impl (\<lambda>_. False) succ_list rs wl; RETURN res}
        \<le> \<Down> (build_rel \<alpha> invar) (do {((_, res), _) \<leftarrow> SPEC (\<lambda>((ex, rs'), wl').
           (accessible_restrict R rs' (set wl') =
            accessible_restrict R (\<alpha> rs) (set wl)) \<and>
           ex = (\<exists>e\<in>rs' - \<alpha> rs. False) \<and> (\<not> ex \<longrightarrow> wl' = [])); RETURN res})"
    apply (rule bind_refine [OF step2, where 
       f = "\<lambda>((_, res), _). RETURN res" and f' = "\<lambda>((_, res), _). RETURN res" and 
       R = "build_rel \<alpha> invar" ])
    apply (auto simp add: br_def)
  done

  have step4 : "(do {((_, res), _) \<leftarrow> SPEC (\<lambda>((ex, rs'), wl').
           (accessible_restrict R rs' (set wl') =
           accessible_restrict R (\<alpha> rs) (set wl)) \<and>
           (ex = (\<exists>e\<in>rs' - \<alpha> rs. False)) \<and> (\<not> ex \<longrightarrow> wl' = [])); RETURN res})
           \<le> SPEC (\<lambda>res. res = accessible_restrict R (\<alpha> rs) (set wl))" 
    apply (rule bind_rule)
    apply (simp add: subset_iff)
  done

  note step5 = ref_two_step [OF order_trans [OF step1 step3] step4]
  thus ?thesis 
     apply (erule_tac RETURN_ref_SPECD)
     apply (simp add: Image_iff Let_def rs'_def br_def)
  done
qed

lemma (in StdSet) accessible_restrict_code_correct2 : 
assumes fin_res: "finite (accessible R (set wl))"
    and succ_list_OK: "\<And>q. set (succ_list q) = {q'. (q,q') \<in> R}"
shows "let rs = accessible_restrict_code succ_list (empty ()) wl in
    invar rs \<and>
    \<alpha> rs = accessible R (set wl)"
proof -
  define uempty where "uempty = empty ()"
  note accessible_restrict_code_correctIns =  accessible_restrict_code_correct [of R uempty wl succ_list] assms
  have invar_uempty: "invar uempty" apply (auto simp add: uempty_def)
    by (simp add: local.empty_correct(2))
  have finite_access_restrict: "finite (accessible_restrict R (\<alpha> uempty) (set wl))"
    apply (auto simp add: uempty_def)
    apply (auto simp add: accessible_restrict_def)
    using invar_uempty uempty_def apply auto[1]
    by (simp add: fin_res local.empty_correct(1))
  from invar_uempty finite show ?thesis
  
    apply (auto simp add: invar_uempty finite_access_restrict
            accessible_restrict_code_correctIns uempty_def )
    using accessible_restrict_code_correctIns(1) 
          finite_access_restrict succ_list_OK uempty_def 
      apply blast
    using accessible_restrict_code_correctIns(1) 
          accessible_restrict_empty finite_access_restrict 
          local.empty_correct(1) succ_list_OK uempty_def apply fastforce
    using accessible_restrict_code_correctIns(1) 
          accessible_restrict_empty finite_access_restrict 
          local.empty_correct(1) succ_list_OK uempty_def 
    by fastforce
qed
    

subsection \<open> Check for reachability \<close>

definition (in StdSet) in_accessible_restrict_code where
"in_accessible_restrict_code P succ_list rs wl =
 fst (fst (accessible_abort_code P succ_list rs wl))"

lemma (in StdSet) in_accessible_restrict_code_correct : 
fixes R :: "('x \<times> 'x) set"
assumes fin_res: "finite (accessible_restrict R (\<alpha> rs) (set wl))"
    and succ_list_OK: "\<And>q. set (succ_list q) = {q'. (q,q') \<in> R}"
    and invar_rs: "invar rs"
shows "in_accessible_restrict_code P succ_list rs wl \<longleftrightarrow>
       (\<exists>e\<in>accessible_restrict R (\<alpha> rs) (set wl) - (\<alpha> rs). P e)"
proof -
  obtain ex rs' wl' where [simp]: "accessible_abort_code P succ_list rs wl = ((ex, rs'), wl')"
    by (metis prod.exhaust)

  have [simp]: "in_accessible_restrict_code P succ_list rs wl = ex"
    unfolding in_accessible_restrict_code_def by simp

  note abort_OK = accessible_abort_code_correct [OF fin_res succ_list_OK invar_rs, of P]

  show ?thesis 
  proof (cases ex)
    case True note [simp] = this
    
    from abort_OK obtain e where "P e" and "e \<in> \<alpha> rs'" "e \<notin> \<alpha> rs" by simp blast
    from `e \<in> \<alpha> rs'` have "e \<in> accessible_restrict R (\<alpha> rs') (set wl')" 
      unfolding accessible_restrict_def by simp
    with abort_OK have "e \<in> accessible_restrict R (\<alpha> rs) (set wl)" by simp
    with `P e` `e \<notin> \<alpha> rs` show ?thesis by simp blast
  next
    case False with abort_OK show ?thesis by auto
  qed
qed

lemma (in StdSet) in_accessible_restrict_code_correct2 : 
fixes R :: "('x \<times> 'x) set"
assumes fin_res: "finite (accessible R (set wl))"
    and succ_list_OK: "\<And>q. set (succ_list q) = {q'. (q,q') \<in> R}"
shows "in_accessible_restrict_code P succ_list (empty ()) wl \<longleftrightarrow>
       (\<exists>e\<in>accessible R (set wl). P e)"
proof -
  define uempty where "uempty = empty ()"
  note in_access_restrict_code_correct_ins = in_accessible_restrict_code_correct [of R uempty wl succ_list P] assms
  from uempty_def in_access_restrict_code_correct_ins show ?thesis
    apply (simp add: correct 
      in_accessible_restrict_code_def in_access_restrict_code_correct_ins)
    by (simp add: accessible_restrict_empty fin_res)
qed

subsection \<open> Code Generation \<close>

definition "accessible_abort_code = ls.accessible_abort_code"
declare accessible_abort_code_def [symmetric, code_unfold]
declare ls.accessible_abort_code_def [folded accessible_abort_code_def, code]

definition "accessible_restrict_code = ls.accessible_restrict_code"
declare accessible_restrict_code_def [symmetric, code_unfold]
declare ls.accessible_restrict_code_def [folded accessible_restrict_code_def, code]

definition "in_accessible_restrict_code = ls.in_accessible_restrict_code"
declare in_accessible_restrict_code_def [symmetric, code_unfold]
declare ls.in_accessible_restrict_code_def [folded in_accessible_restrict_code_def, code]


export_code accessible_abort_code accessible_restrict_code in_accessible_restrict_code in SML

end


