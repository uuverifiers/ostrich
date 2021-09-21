(*  Title:       Nondeterministic Finite Automata 
    Authors:     Shuanglong Kan <shuanglong@uni-kl.de>
                 Thomas Tuerk <tuerk@in.tum.de>             
                 Petra Dietrich <petra@ecs.vuw.ac.nz>
*)

(* Nondeterministic Finite Automata *)

theory NFA_set
imports Main LTS_set "../General/Accessible"
        "HOL-Library.Nat_Bijection" 
        "implementation/Interval"
begin


subsection \<open> Basic Definitions \<close>

class NFA_states =
  fixes states_enumerate :: "nat \<Rightarrow> 'a"
  assumes states_enumerate_inj: "inj states_enumerate"
begin
  lemma states_enumerate_eq: "states_enumerate n = states_enumerate m \<longleftrightarrow> n = m"
    using states_enumerate_inj
    unfolding inj_on_def by auto

  lemma not_finite_NFA_states_UNIV : "~ (finite (UNIV ::'a set))"
  proof 
    assume fin_UNIV: "finite (UNIV::'a set)"
    hence "finite (states_enumerate ` UNIV)"
      by (rule_tac finite_subset[of _ UNIV], simp_all)
    hence "finite (UNIV::nat set)"
      using states_enumerate_inj
      by (rule finite_imageD)
    thus "False" using infinite_UNIV_nat by simp
  qed
end


instantiation nat :: NFA_states
begin
  definition "states_enumerate q = q"

  instance proof  
    show "inj (states_enumerate::nat \<Rightarrow> nat)"
      unfolding states_enumerate_nat_def
      by (simp add: inj_on_def)
  qed
end

text \<open> This theory defines nondetermistic finite automata.
  These automata are represented as records containing a transtion relation, 
  a set of initial states and a set of final states. \<close>

record ('q,'a) NFA_rec =
  \<Q> :: "'q set"           (* "The set of states" *)
  \<Delta> :: "('q,'a) LTS"      (* "The transition relation" *)
  \<I> :: "'q set"            (* "The set of initial states *)
  \<F> :: "'q set"           (* "The set of final states *)

text \<open> Using notions for labelled transition systems, it is easy to
  define the languages accepted by automata. \<close>

definition NFA_accept :: "('a, 'b) NFA_rec \<Rightarrow> 'b list \<Rightarrow> bool" where
  "NFA_accept \<A> w = (\<exists> q \<in> (\<I> \<A>). \<exists> q' \<in> (\<F> \<A>). 
                 LTS_is_reachable (\<Delta> \<A>) q w q')"

definition \<L> where "\<L> \<A> = {w. NFA_accept \<A> w}"

text \<open> It is also useful to define the language accepted in a state. \<close>

definition \<L>_in_state where
  "\<L>_in_state \<A> q = {w.  (\<exists>q'\<in> (\<F> \<A>). 
                     LTS_is_reachable (\<Delta> \<A>) q w q')}"

abbreviation "\<L>_right == \<L>_in_state"

lemma \<L>_in_state_alt_def :
  "\<L>_in_state \<A> q = \<L> \<lparr> \<Q> = \<Q> \<A>, \<Delta> = \<Delta> \<A>, \<I> = {q}, \<F> = \<F> \<A> \<rparr>"
unfolding \<L>_def \<L>_in_state_def 
by (auto simp add: NFA_accept_def)

definition \<L>_left where
  "\<L>_left \<A> q = {w.  (\<exists> i \<in> (\<I> \<A>). LTS_is_reachable (\<Delta> \<A>) i w q)}"

lemma \<L>_left_alt_def :
  "\<L>_left \<A> q = \<L> \<lparr> \<Q> = \<Q> \<A>, \<Delta> = \<Delta> \<A>, \<I> = \<I> \<A>, \<F> = {q} \<rparr>"
unfolding \<L>_def \<L>_left_def by (auto simp add: NFA_accept_def)

lemma NFA_accept_alt_def : "NFA_accept \<A> w \<longleftrightarrow> 
                                w \<in> \<L> \<A>" by (simp add: \<L>_def)

lemma \<L>_alt_def :
  "\<L> \<A> = \<Union> ((\<L>_in_state \<A>) ` (\<I> \<A>))"
by (auto simp add: \<L>_def \<L>_in_state_def NFA_accept_def)

lemma in_\<L>_in_state_Nil [simp] : "[] \<in> \<L>_in_state \<A> q \<longleftrightarrow> (q \<in> \<F> \<A>)" 
   by (simp add: \<L>_in_state_def)


lemma in_\<L>_in_state_Cons [simp] :
    "(a # w) \<in> \<L>_in_state \<A> q \<longleftrightarrow> 
  (\<exists> q' \<sigma>. a \<in> \<sigma> \<and> (q, \<sigma>, q') \<in> \<Delta> \<A> \<and> w \<in> \<L>_in_state \<A> q')" 
  by (auto simp add: \<L>_in_state_def)
  

definition remove_prefix :: "'a list \<Rightarrow> ('a list) set \<Rightarrow> ('a list) set" where
  "remove_prefix pre L \<equiv> drop (length pre) ` (L \<inter> {pre @ w |w. True})"  

lemma remove_prefix_alt_def [simp] :
  "w \<in> remove_prefix pre L \<longleftrightarrow> (pre @ w \<in> L)"
by (auto simp add: remove_prefix_def image_iff Bex_def)

lemma remove_prefix_Nil [simp] :
   "remove_prefix [] L = L" by (simp add: set_eq_iff)

lemma remove_prefix_Combine [simp] :
   "remove_prefix p2 (remove_prefix p1 L) = 
    remove_prefix (p1 @ p2) L" 
by (rule set_eqI, simp)

lemma \<L>_in_state_remove_prefix : 
  "pre \<in> lists (\<Sigma> \<A>) \<Longrightarrow>
    (remove_prefix pre (\<L>_in_state \<A> q) = 
    \<Union> {\<L>_in_state \<A> q' | q'. LTS_is_reachable (\<Delta> \<A>) q pre q'})"
by (rule set_eqI, auto simp add: \<L>_in_state_def LTS_is_reachable_concat)

lemma \<L>_in_state___in_\<F> : 
assumes L_eq: "\<L>_in_state \<A> q = \<L>_in_state \<A> q'"
shows "(q \<in> \<F> \<A> \<longleftrightarrow> q' \<in> \<F> \<A>)"
proof -
  from L_eq have "([] \<in> \<L>_in_state \<A> q) = ([] \<in> \<L>_in_state \<A> q')" by simp
  thus ?thesis by simp
qed


text \<open>  The following locale captures, whether a NFA  is well-formed. \<close>

locale NFA =  
  fixes \<A> :: "('q, 'a) NFA_rec" 
  assumes \<Delta>_consistent: "\<And>q \<sigma> q'. (q,\<sigma>,q') \<in> \<Delta> \<A> 
                \<Longrightarrow> (q \<in> \<Q> \<A>) \<and> (q' \<in> \<Q> \<A>)"
      and \<I>_consistent: "\<I> \<A> \<subseteq> \<Q> \<A>"
      and \<F>_consistent: "\<F> \<A> \<subseteq> \<Q> \<A>"
      and finite_\<Q>: "finite (\<Q> \<A>)"

lemma NFA_intro [intro!] :
  " \<lbrakk>\<And>q \<sigma> q'. (q,\<sigma>,q') \<in> \<Delta> \<A> \<Longrightarrow> (q \<in> \<Q> \<A>) \<and> (q' \<in> \<Q> \<A>);
     \<I> \<A> \<subseteq> \<Q> \<A>; \<F> \<A> \<subseteq> \<Q> \<A>; finite (\<Q> \<A>)\<rbrakk> \<Longrightarrow> NFA \<A>"
by (simp add: NFA_def)

definition dummy_NFA where
"dummy_NFA q a =
 \<lparr>\<Q> = {q}, \<Delta> = {(q, {a}, q)},
  \<I> = {q}, \<F> = {q} \<rparr>"

lemma dummy_NFA___is_NFA :
  "NFA (dummy_NFA q a)"
by (simp add: NFA_def dummy_NFA_def)

lemma (in NFA) wf_NFA : "NFA \<A>" 
unfolding NFA_def
using \<Delta>_consistent finite_\<Q> \<I>_consistent \<F>_consistent
by simp

lemma (in NFA) finite_\<I> :
  "finite (\<I> \<A>)"
using \<I>_consistent finite_\<Q>
by (metis finite_subset)

lemma (in NFA) finite_\<F> :
  "finite (\<F> \<A>)"
using \<F>_consistent finite_\<Q>
by (metis finite_subset)

(*
lemma (in NFA) \<Delta>_subset :
"\<Delta> \<A> \<subseteq> \<Q> \<A> \<times> Pow (\<Sigma> \<A>) \<times> \<Q> \<A>" 
using \<Delta>_consistent
by (simp add: subset_iff)

lemma (in NFA) finite_\<Delta> :
  "finite (\<Delta> \<A>)"
proof -
  from finite_\<Q> finite_\<Sigma> have "finite (\<Q> \<A> \<times> Pow (\<Sigma> \<A>) \<times> \<Q> \<A>)" by simp
  with \<Delta>_subset show "finite (\<Delta> \<A>)" by (metis finite_subset)
qed

lemma (in NFA) NFA_\<Delta>_cons___is_path :
shows "\<lbrakk>q \<in> \<Q> \<A>; LTS_is_path (\<Delta> \<A>) q \<pi>\<rbrakk> \<Longrightarrow>
   \<pi> \<in> lists (Pow (\<Sigma> \<A>) \<times> \<Q> \<A>)"
proof (induct \<pi> arbitrary: q)
  case Nil thus ?case by simp
next
  case (Cons \<sigma>q \<pi>) 
  note ind_hyp = Cons(1)
  note q_in_Q = Cons(2)
  note path_\<sigma>q_\<pi> = Cons(3)

  obtain \<sigma> q'' where \<sigma>q_eq : "\<sigma>q = (\<sigma>, q'')" by (cases \<sigma>q, auto)
  
  from path_\<sigma>q_\<pi> \<sigma>q_eq have "(q, \<sigma>, q'') \<in> (\<Delta> \<A>)" by simp
  hence q''_in_Q: "q'' \<in> \<Q> \<A>" and \<sigma>_in_\<Sigma>: "\<sigma> \<subseteq> \<Sigma> \<A>" 
    using \<Delta>_consistent by blast+
  from path_\<sigma>q_\<pi> \<sigma>q_eq have path_\<pi>: "LTS_is_path (\<Delta> \<A>) q'' \<pi>" by simp
  note \<pi>_in = ind_hyp [OF q''_in_Q path_\<pi>]
  
  from \<pi>_in \<sigma>q_eq \<sigma>_in_\<Sigma> q''_in_Q show ?case by simp
qed
*)

lemma (in NFA) NFA_\<Delta>_cons___LTS_is_reachable :
  "\<lbrakk>LTS_is_reachable (\<Delta> \<A>) q w q'\<rbrakk> \<Longrightarrow> (q \<in> \<Q> \<A> \<longrightarrow> q' \<in> \<Q> \<A>)"
using \<Delta>_consistent
  apply (induct w arbitrary: q)
  by auto

(*
lemma (in NFA) LTS_is_reachable___labels :
  "LTS_is_reachable (\<Delta> \<A>) q w q' \<Longrightarrow> w \<in> lists (\<Sigma> \<A>)"
by (simp add: NFA_\<Delta>_cons___LTS_is_reachable)
*)
lemma (in NFA) NFA_accept_wf_def :
"NFA_accept \<A> w = (\<exists> q\<in>(\<I> \<A>). \<exists> q'\<in>(\<F> \<A>). LTS_is_reachable (\<Delta> \<A>) q w q')"
by (metis NFA_accept_def)

lemma (in NFA) LTS_is_reachable_from_initial_alt_def :
  "accessible (LTS_forget_labels (\<Delta> \<A>)) (\<I> \<A>) =
   {q'. (\<exists> q\<in> (\<I> \<A>). \<exists>w. LTS_is_reachable (\<Delta> \<A>) q w q')}"
  by (simp add: accessible_def rtrancl_LTS_forget_labels)

lemma (in NFA) LTS_is_reachable_from_initial_subset :
  "accessible (LTS_forget_labels (\<Delta> \<A>)) (\<I> \<A>) \<subseteq> \<Q> \<A>"
using NFA_\<Delta>_cons___LTS_is_reachable \<I>_consistent
unfolding LTS_is_reachable_from_initial_alt_def
by auto

lemma (in NFA) LTS_is_reachable_from_initial_finite :
  "finite (accessible (LTS_forget_labels (\<Delta> \<A>)) (\<I> \<A>))"
using LTS_is_reachable_from_initial_subset finite_\<Q>
by (rule finite_subset)


subsection \<open> Constructing from a list representation \<close>

fun construct_NFA_aux where 
   "construct_NFA_aux \<A> (q1, l, q2) =
    \<lparr> \<Q>=insert q1 (insert q2 (\<Q> \<A>)),
      \<Delta>=\<Delta> \<A> \<union> {(q1,set l,q2)}, 
      \<I> = \<I> \<A>, \<F> = \<F> \<A>\<rparr>"


fun NFA_construct where
   "NFA_construct (Q, D, I, F) =
    foldl construct_NFA_aux 
    \<lparr> \<Q>=set (Q @ I @ F), \<Delta>={}, \<I> =set I, \<F> = set F\<rparr> D"
declare NFA_construct.simps [simp del]

lemma foldl_fun_comm:
  assumes "\<And> x y s. f (f s x) y = f (f s y) x"
  shows "f (foldl f s xs) x = foldl f (f s x) xs"
  by (induct xs arbitrary: s)
    (simp_all add: assms)

(* NFA_construct for interval *)

fun construct_NFA_interval_aux where 
   "construct_NFA_interval_aux \<A> (q1, l, q2) =
    \<lparr> \<Q>=insert q1 (insert q2 (\<Q> \<A>)),
      \<Delta>=\<Delta> \<A> \<union> {(q1,semI l,q2)}, 
      \<I> = \<I> \<A>, \<F> = \<F> \<A>\<rparr>"

fun NFA_construct_interval   where
   "NFA_construct_interval (Q, D, I, F) =
    foldl construct_NFA_interval_aux 
    \<lparr> \<Q>=set (Q @ I @ F), \<Delta>={}, \<I> =set I, \<F> = set F\<rparr> D"
declare NFA_construct_interval.simps [simp del]

lemma NFA_construct_interval_alt_def :
  "NFA_construct_interval (Q, D, I, F) =
   \<lparr> \<Q>=set Q \<union> set I \<union> set F \<union>
       set (map fst D) \<union>
       set (map (snd \<circ> snd) D),
       \<Delta> = {(q1,l,q2). \<exists> l1. (q1,l1,q2) \<in> set D \<and> l = semI l1}, 
       \<I> = set I, \<F> = set F\<rparr>"
proof (induct D)
  case Nil thus ?case by (auto simp add: NFA_construct_interval.simps)
next
  case (Cons qlq D)
  have fold_lemma: "\<And>\<A>. foldl construct_NFA_interval_aux 
                (construct_NFA_interval_aux \<A> qlq) D =
            construct_NFA_interval_aux (foldl construct_NFA_interval_aux \<A> D) qlq"
    by (rule_tac foldl_fun_comm [symmetric], auto)
  have fold_lemma1: "NFA_construct_interval (Q, (qlq # D), I, F)= 
         construct_NFA_interval_aux (NFA_construct_interval (Q, D, I, F)) qlq"
    by (simp add: NFA_construct_interval.simps fold_lemma)
  obtain q1 l q2 where qlq_eq : "qlq = (q1, l, q2)" by (cases qlq, auto)
  
  from Cons fold_lemma1 show ?case
    apply (auto simp add: qlq_eq semI_def)
    using prod.collapse by blast
qed

lemma NFA_construct_interval___is_well_formed :
  shows "NFA (NFA_construct_interval l)"
proof -
  obtain Q D I F where l_eq[simp]: "l = (Q, D, I, F)" by (metis prod.exhaust)
  have l_D: "fst (snd l) = D" by auto
  { fix q \<sigma> q'
    assume "(q, \<sigma>, q') \<in> \<Delta> (NFA_construct_interval (Q, D, I, F))"
    then obtain l where in_D: "(q, l, q') \<in> set D" 
       by (auto simp add: NFA_construct_interval_alt_def)

    from in_D have p1: "q \<in> fst ` set D" by (metis fst_conv imageI) 
    from in_D have p3: "q' \<in> (snd \<circ> snd) ` set D"
      by (metis imageI image_comp [symmetric] snd_conv)

    note p1 p3
  } 
  
  thus ?thesis
    by (auto simp add: NFA_construct_interval_alt_def NFA_def 
           Ball_def)
qed 

(* end *)




lemma NFA_construct_alt_def :
  "NFA_construct (Q, D, I, F) =
   \<lparr> \<Q>=set Q \<union> set I \<union> set F \<union>
       set (map fst D) \<union>
       set (map (snd \<circ> snd) D),
       \<Delta> = {(q1,l,q2).(\<exists>l1. (q1,l1,q2) \<in> set D \<and> l = set l1)}, \<I> = set I, \<F> = set F\<rparr>"
proof (induct D)
  case Nil thus ?case by (auto simp add: NFA_construct.simps)
next
  case (Cons qlq D)
  have fold_lemma: "\<And>\<A>. foldl construct_NFA_aux (construct_NFA_aux \<A> qlq) D =
            construct_NFA_aux (foldl construct_NFA_aux \<A> D) qlq"
    by (rule_tac foldl_fun_comm [symmetric], auto)
  have fold_lemma1: "NFA_construct (Q, (qlq # D), I, F)= 
         construct_NFA_aux (NFA_construct (Q, D, I, F)) qlq"
    by (simp add: NFA_construct.simps fold_lemma)
  obtain q1 l q2 where qlq_eq : "qlq = (q1, l, q2)" by (cases qlq, auto)
  
  from Cons fold_lemma1 show ?case
    apply (auto simp add: qlq_eq)
    done
qed

fun NFA_construct_simple where
  "NFA_construct_simple (Q, D, I, F) =
   NFA_construct (Q, map (\<lambda>(q1, a, q2). (q1, [a], q2)) D, I, F)" 

lemma NFA_construct___is_well_formed :
  "NFA (NFA_construct l)"
proof -
  obtain Q D I F where l_eq[simp]: "l = (Q, D, I, F)" by (metis prod.exhaust)
  
  { fix q \<sigma> q'
    assume "(q, \<sigma>, q') \<in> \<Delta> (NFA_construct (Q, D, I, F))"
    then obtain l where in_D: "(q, l, q') \<in> set D" 
       by (auto simp add: NFA_construct_alt_def)

    from in_D have p1: "q \<in> fst ` set D" by (metis fst_conv imageI) 
    from in_D have p3: "q' \<in> (snd \<circ> snd) ` set D"
      by (metis imageI image_comp [symmetric] snd_conv)

    note p1 p3
  } 
  thus ?thesis
    by (auto simp add: NFA_construct_alt_def NFA_def Ball_def) 
qed 

definition set_to_list :: "'a set \<Rightarrow> 'a list" where
  "set_to_list s = (SOME l. set l = s)"

lemma set_set_to_list [simp]: "finite s \<Longrightarrow> set (set_to_list s) = s"
  unfolding set_to_list_def
  by (metis (mono_tags) finite_list some_eq_ex)

lemma list_set_eq : "\<And> l a. finite a \<longrightarrow> (l = set (SOME l. set l = a)) \<longrightarrow> l = a"
  by (metis (full_types) set_set_to_list set_to_list_def)

lemma S_S: "S = {q. q \<in>S}"
  by auto

(*
lemma NFA_construct_exists :
fixes \<A> :: "('q, 'a::linorder) NFA_rec"
assumes wf_A: "NFA \<A>" and
    finite_\<Delta>: "finite (\<Delta> \<A>)"
  shows "\<exists> Q D I F. 
   NFA_construct_interval (Q, D, I, F) = \<A> "
proof -
  interpret NFA_A: NFA \<A> by (fact wf_A)

  from finite_list[OF NFA_A.finite_\<Q>] guess Q .. note set_Q = this 
  from finite_list[OF NFA_A.finite_\<I>] guess I .. note set_I = this 
  from finite_list[OF NFA_A.finite_\<F>] guess F .. note set_F = this 
  from finite_list[OF finite_\<Delta>] guess DD .. note set_DD = this

  
  let ?D = "map (\<lambda>qaq. (fst qaq, set_to_list (fst (snd qaq)), snd (snd qaq))) DD"

  have "\<A> = NFA_construct (Q, ?D, I, F)"
    apply (rule NFA_rec.equality)
    apply (simp_all add: NFA_construct_alt_def set_Q set_I set_F set_DD o_def)
        apply (insert NFA_A.\<Delta>_consistent NFA_A.\<I>_consistent NFA_A.\<F>_consistent) []
        apply auto[]
      apply (insert NFA_A.\<Delta>_consistent) []
     apply auto []
    apply (metis finite_\<Delta> infinite_super set_set_to_list subset_eq set_to_list_def)
    apply (auto simp add: 
         image_iff Bex_def ex_simps[symmetric] set_to_list_def some_eq_ex  S_S)
     apply (metis NFA_A.\<Delta>_consistent NFA_A.finite_\<Sigma> 
          infinite_super set_set_to_list set_to_list_def)
    by (metis NFA_A.\<Delta>_consistent NFA_A.finite_\<Sigma> infinite_super set_set_to_list set_to_list_def)
  thus ?thesis by blast
qed

*)


subsection \<open> Removing states \<close>
  
definition NFA_remove_states :: 
       "('q, 'a) NFA_rec \<Rightarrow> 'q set \<Rightarrow> ('q, 'a) NFA_rec" where
       "NFA_remove_states \<A> S == \<lparr> \<Q>=\<Q> \<A> - S, 
       \<Delta> = {(s1,\<alpha>,s2) . 
            (s1,\<alpha>,s2) \<in> \<Delta> \<A> \<and> s1 \<notin> S \<and> s2 \<notin> S \<and> \<alpha> \<noteq> {}}, 
       \<I> = \<I> \<A> - S, 
       \<F> = \<F> \<A> - S\<rparr>"

lemma [simp] : "\<I> (NFA_remove_states \<A> S) = \<I> \<A> - S" by (simp add: NFA_remove_states_def)
lemma [simp] : "\<Q> (NFA_remove_states \<A> S) = \<Q> \<A> - S" by (simp add: NFA_remove_states_def)
lemma [simp] : "\<F> (NFA_remove_states \<A> S) = \<F> \<A> - S" by (simp add: NFA_remove_states_def)
lemma [simp] : "x \<in> \<Delta> (NFA_remove_states \<A> S) \<longleftrightarrow> 
                x \<in> \<Delta> \<A> \<and> fst x \<notin> S \<and> snd (snd x) \<notin> S \<and> (fst (snd x) \<noteq> {})" 
                  by (cases x, simp add: NFA_remove_states_def)

lemma NFA_remove_states_\<Delta>_subset : "\<Delta> (NFA_remove_states \<A> S) \<subseteq> \<Delta> \<A>" by (simp add: subset_iff)
lemma NFA_remove_states___is_well_formed : "NFA \<A> \<Longrightarrow> NFA (NFA_remove_states \<A> S)" by (auto simp add: NFA_def)


lemma NFA_remove_states_NFA_remove_states [simp] : "NFA_remove_states (NFA_remove_states \<A> S1) S2 = 
  NFA_remove_states \<A> (S1 \<union> S2)"
  by (rule NFA_rec.equality, auto simp add: NFA_remove_states_def)

lemma NFA_remove_states_\<L>_subset : "\<L> (NFA_remove_states \<A> S) \<subseteq> \<L> \<A>"
  by (simp add: \<L>_def NFA_accept_def subset_iff Bex_def,
      metis LTS_is_reachable_mono NFA_remove_states_\<Delta>_subset)



lemma LTS_is_reachable_NFA_remove_states :
assumes Q_unrech: "\<And>q'. q'\<in> Q \<Longrightarrow> LTS_is_unreachable (\<Delta> \<A>)  q q'"
  shows "LTS_is_reachable (\<Delta> \<A>) q w q' \<longleftrightarrow> 
         LTS_is_reachable (\<Delta> (NFA_remove_states \<A> Q)) q w q'"
using  Q_unrech
proof (induct w arbitrary: q)
  case Nil thus ?case by simp
next
  case (Cons a w)
  note a_in_\<Sigma> = Cons(1)
  note w_in_\<Sigma> = Cons(2)
  

  have "LTS_is_reachable (\<Delta> \<A>) q [] q" by simp
  with  w_in_\<Sigma> have q_nin_Q: "q \<notin> Q" by (metis LTS_is_unreachable_def)

  have Qq_cond': "\<And>q' \<sigma>. (q, \<sigma>, q') \<in> \<Delta> \<A> \<and> a \<in> \<sigma> \<Longrightarrow> q' \<notin> Q \<and> 
          (\<forall>q''\<in>Q. LTS_is_unreachable (\<Delta> \<A>)  q' q'')"
  proof -
    fix q' \<sigma>
    assume "(q, \<sigma>, q') \<in> \<Delta> \<A> \<and> a \<in> \<sigma>"
    with a_in_\<Sigma> have "LTS_is_reachable (\<Delta> \<A>) q [a] q' " by auto
    with  w_in_\<Sigma> show "q' \<notin> Q \<and> (\<forall>q''\<in>Q. LTS_is_unreachable (\<Delta> \<A>) q' q'')" 
      by (metis LTS_is_unreachable_def LTS_is_unreachable_reachable_start)
  qed
  
  from  a_in_\<Sigma> w_in_\<Sigma> q_nin_Q w_in_\<Sigma> Qq_cond'
  show ?case  
    apply (simp)
    by blast
qed

lemma NFA_remove_states_\<L>_in_state_iff :
assumes Q_unrech: "\<And>q'. q'\<in> Q \<Longrightarrow> LTS_is_unreachable (\<Delta> \<A>) q q'"
shows "\<L>_in_state (NFA_remove_states \<A> Q) q = \<L>_in_state \<A> q"
      (is "?L1 = ?L2")
proof (rule set_eqI)
  fix w
  show "w \<in> ?L1 \<longleftrightarrow> w \<in> ?L2"
    thm LTS_is_reachable_NFA_remove_states
  proof -
    from Q_unrech have q'_nin_Q: "\<And>q'. LTS_is_reachable (\<Delta> \<A>) q w q' \<Longrightarrow> q' \<notin> Q"
      by (metis LTS_is_unreachable_def)
    note reachable_remove_simp = LTS_is_reachable_NFA_remove_states 
            [OF Q_unrech, symmetric]

    with  q'_nin_Q show ?thesis 
      by (auto simp add: \<L>_in_state_def)
  qed
qed

lemma NFA_remove_states_\<L>_iff : 
  assumes unreach_asm: "\<And>q q'. \<lbrakk>q \<in> \<I> \<A>; q' \<in> Q\<rbrakk> \<Longrightarrow> 
      LTS_is_unreachable (\<Delta> \<A>) q q'"
shows "\<L> (NFA_remove_states \<A> Q) = \<L> \<A>"
proof -
  have initial_not_Q: "\<forall>q \<in> \<I> \<A>. q \<notin> Q" by (metis unreach_asm LTS_is_unreachable_not_refl)
  have in_state_iff: "\<forall>q \<in> \<I> \<A>. \<L>_in_state (NFA_remove_states \<A> Q) q = \<L>_in_state \<A> q" 
    by (metis unreach_asm NFA_remove_states_\<L>_in_state_iff)

  from initial_not_Q in_state_iff 
  show ?thesis by (simp add: \<L>_alt_def set_eq_iff Bex_def, metis)
qed

lemma NFA_remove_states_accept_iff : 
assumes unreach_asm: "\<And>q q'. \<lbrakk>q \<in> \<I> \<A>; q'\<in> Q\<rbrakk> \<Longrightarrow> LTS_is_unreachable (\<Delta> \<A>) q q'"
shows "NFA_accept (NFA_remove_states \<A> Q) w = NFA_accept \<A> w"
using assms
by (simp add: NFA_accept_alt_def NFA_remove_states_\<L>_iff)

definition NFA_unreachable_states where
  "NFA_unreachable_states \<A> = {q'. \<forall> q \<in> \<I> \<A>. LTS_is_unreachable (\<Delta> \<A>) q q'}"

lemma NFA_unreachable_states_alt_def :
"NFA_unreachable_states \<A> = {q. \<L>_left \<A> q = {}}"
by (simp add: NFA_unreachable_states_def \<L>_left_def LTS_is_unreachable_def, auto)

lemma [simp]: "q \<notin> NFA_unreachable_states \<A> \<and> (q,\<alpha>,q') \<in> \<Delta> \<A> \<and> \<alpha> \<noteq> {}  \<longrightarrow>
              q' \<notin> NFA_unreachable_states \<A>"
proof 
  assume  "q \<notin> NFA_unreachable_states \<A> \<and> (q,\<alpha>,q') \<in> \<Delta> \<A> \<and> \<alpha> \<noteq> {} " 
  thus "q' \<notin> NFA_unreachable_states \<A>"
    apply (simp add: NFA_unreachable_states_def LTS_is_unreachable_def)
  proof -
    assume q_reachable: "(\<exists>qa\<in>\<I> \<A>. \<exists> w. LTS_is_reachable (\<Delta> \<A>) qa w q) 
            \<and> (q, \<alpha>, q') \<in> \<Delta> \<A> \<and> \<alpha> \<noteq> {}"
    then obtain qa w a \<alpha> where 
      pre1: "LTS_is_reachable (\<Delta> \<A>) qa w q  \<and>
             (q, \<alpha>, q') \<in> \<Delta> \<A> \<and> \<alpha> \<noteq> {} \<and>(qa \<in> \<I> \<A>) \<and> a \<in> \<alpha> " by auto
    from this have 
          pre2: "LTS_is_reachable  (\<Delta> \<A>) qa (w @ [a]) q'" 
      by auto

    from pre1 pre2 show "\<exists>q\<in>\<I> \<A>. \<exists>w. LTS_is_reachable (\<Delta> \<A>) q w q'"
      by blast
  qed
qed
    
      

lemma NFA_unreachable_states_extend :
  "\<lbrakk>x \<notin> NFA_unreachable_states \<A>; (x, \<sigma>, q') \<in> \<Delta> \<A>; \<sigma> \<noteq> {}\<rbrakk> \<Longrightarrow> q' 
      \<notin> NFA_unreachable_states \<A>"
proof
  assume "x \<notin> NFA_unreachable_states \<A>"
  then obtain w q where 
     reach_x: "LTS_is_reachable (\<Delta> \<A>) q w x" and
     q_in_I: "q \<in> \<I> \<A>" 
  by (auto simp add: NFA_unreachable_states_def LTS_is_unreachable_def)
   
  assume "(x, \<sigma>, q') \<in> \<Delta> \<A>" 
  with reach_x have reach_q' : "\<And> a. a \<in> \<sigma> \<longrightarrow> 
             LTS_is_reachable (\<Delta> \<A>) q (w @ [a]) q'" by auto
   
  
  assume "q' \<in> NFA_unreachable_states \<A>" and
          "x \<notin> NFA_unreachable_states \<A>" and
          "(x, \<sigma>, q') \<in> \<Delta> \<A>" and 
          "\<sigma> \<noteq> {}"
  thus "False"
    apply auto
    done
qed

definition NFA_is_initially_connected where
  "NFA_is_initially_connected \<A> \<longleftrightarrow> \<Q> \<A> \<inter> NFA_unreachable_states \<A> = {}"

lemma NFA_is_initially_connected_alt_def :
  "NFA_is_initially_connected \<A> \<longleftrightarrow> (\<forall>q \<in> \<Q> \<A>. 
   \<exists>i\<in>\<I> \<A>. \<exists> w . LTS_is_reachable (\<Delta> \<A>) i w q)"
unfolding NFA_is_initially_connected_def
by (auto simp add: set_eq_iff NFA_unreachable_states_def LTS_is_unreachable_def)

lemma dummy_NFA___NFA_is_initially_connected :
  "NFA_is_initially_connected (dummy_NFA q a)"
apply (simp add: NFA_is_initially_connected_alt_def dummy_NFA_def Bex_def)
apply (rule exI [where x = "[]"])
apply simp
  done


definition NFA_remove_unreachable_states where
  "NFA_remove_unreachable_states \<A> = NFA_remove_states \<A> (NFA_unreachable_states \<A>)"

lemma NFA_remove_unreachable_states_\<L> [simp] :
  "\<L> (NFA_remove_unreachable_states \<A>) = \<L> \<A>"
apply (simp add: NFA_remove_unreachable_states_def)
apply (rule NFA_remove_states_\<L>_iff)
apply (simp add: NFA_unreachable_states_def)
done

lemma NFA_remove_unreachable_states_\<L>_in_state [simp] :
assumes q_in_Q: "q \<in> \<Q> (NFA_remove_unreachable_states \<A>)"
shows "\<L>_in_state (NFA_remove_unreachable_states \<A>) q = \<L>_in_state \<A> q"
proof -
  from q_in_Q have "q \<notin> NFA_unreachable_states \<A>"
    by (simp add: NFA_remove_unreachable_states_def)
  then obtain q0 w where 
    "q0 \<in> \<I> \<A> \<and> LTS_is_reachable (\<Delta> \<A>) q0 w q "
    by (auto simp add: NFA_unreachable_states_def LTS_is_unreachable_def)
  then have Q_OK: "\<And>q'. q' \<in> NFA_unreachable_states \<A> \<Longrightarrow> 
        LTS_is_unreachable (\<Delta> \<A>) q q'"
    by (simp add: NFA_unreachable_states_def,
        metis LTS_is_unreachable_reachable_start)

  note NFA_remove_states_\<L>_in_state_iff [where q = q and \<A> = \<A> and
     Q = "NFA_unreachable_states \<A>", OF Q_OK]
  thus ?thesis by (simp add: NFA_remove_unreachable_states_def)
qed

lemma NFA_remove_unreachable_states_accept_iff [simp] : 
"NFA_accept (NFA_remove_unreachable_states \<A>) w = NFA_accept \<A> w"
by (simp add: NFA_accept_alt_def)

lemma NFA_remove_unreachable_states___is_well_formed [simp] : 
"NFA \<A> \<Longrightarrow> NFA (NFA_remove_unreachable_states \<A>)"
by (simp add: NFA_remove_unreachable_states_def NFA_remove_states___is_well_formed)

lemma NFA_unreachable_states_\<I> :
  "q \<in> \<I> \<A> \<Longrightarrow> q \<notin> NFA_unreachable_states \<A>"
proof -
   have f1: "LTS_is_reachable (\<Delta> \<A>) q [] q \<and> [] \<in> lists (\<Sigma> \<A>)" by simp
   show "q \<in> \<I> \<A> \<Longrightarrow> q \<notin> NFA_unreachable_states \<A>"  
     by (simp add: NFA_unreachable_states_def LTS_is_unreachable_def, metis f1)
qed

lemma NFA_remove_unreachable_states_\<I> [simp] :
  "\<I> (NFA_remove_unreachable_states \<A>) = \<I> \<A>"
by (auto simp add: NFA_remove_unreachable_states_def NFA_unreachable_states_\<I>)


lemma NFA_unreachable_states_NFA_remove_unreachable_states :
  "NFA_unreachable_states (NFA_remove_unreachable_states \<A>) =
   NFA_unreachable_states \<A>"
proof -
  have "\<And>q q' w. \<lbrakk>q \<in> \<I> \<A>\<rbrakk> \<Longrightarrow> 
        LTS_is_reachable (\<Delta> (NFA_remove_unreachable_states \<A>)) q w q' \<longleftrightarrow>
        LTS_is_reachable (\<Delta> \<A>) q w q'"
  proof -
    fix q q' w
    assume q_in_I: "q \<in> \<I> \<A>"
   
    with q_in_I have 
      Q_OK: "\<And>q'. q' \<in> NFA_unreachable_states \<A> \<Longrightarrow> 
            LTS_is_unreachable (\<Delta> \<A>) q q'"
      by (simp add: NFA_unreachable_states_def)

    note LTS_is_reachable_NFA_remove_states 
            [where \<A> = \<A> and q = q and q'=q' and w = w
       and Q = "NFA_unreachable_states \<A>"]
    with Q_OK show "LTS_is_reachable (\<Delta> (NFA_remove_unreachable_states \<A>)) q w q' \<longleftrightarrow>
          LTS_is_reachable (\<Delta> \<A>) q w q'"
      by (simp add: NFA_remove_unreachable_states_def)
  qed
  thus ?thesis by (simp add: NFA_unreachable_states_def LTS_is_unreachable_def)
qed


lemma NFA_remove_unreachable_states_NFA_remove_unreachable_states [simp] :
  "NFA_remove_unreachable_states (NFA_remove_unreachable_states \<A>) = NFA_remove_unreachable_states \<A>"
apply (simp add: NFA_remove_unreachable_states_def)
apply (simp add: NFA_remove_unreachable_states_def [symmetric]
                 NFA_unreachable_states_NFA_remove_unreachable_states)
done

lemma NFA_remove_unreachable_states___NFA_is_initially_connected :
  "NFA_is_initially_connected (NFA_remove_unreachable_states \<A>)"
apply (simp add: NFA_is_initially_connected_def NFA_unreachable_states_NFA_remove_unreachable_states)
apply (simp add: NFA_remove_unreachable_states_def)
apply fastforce
done


subsection \<open> Rename States / Combining \<close>

definition NFA_rename_states :: 
"('q1, 'a) NFA_rec \<Rightarrow> ('q1 \<Rightarrow> 'q2) \<Rightarrow> ('q2, 'a) NFA_rec" where
"NFA_rename_states \<A> f \<equiv> 
\<lparr> \<Q>=f ` (\<Q> \<A>),  \<Delta> = { (f s1, a, f s2) | s1 a s2. (s1,a,s2) \<in> \<Delta> \<A>}, 
  \<I>=f ` (\<I> \<A>), \<F> = f ` (\<F> \<A>) \<rparr>"

lemma [simp] : "\<I> (NFA_rename_states \<A> f) = f ` \<I> \<A>" by (simp add: NFA_rename_states_def)
lemma [simp] : "\<Q> (NFA_rename_states \<A> f) = f ` \<Q> \<A>" by (simp add: NFA_rename_states_def)
lemma [simp] : "\<F> (NFA_rename_states \<A> f) = f ` \<F> \<A>" by (simp add: NFA_rename_states_def)
lemma [simp] : "(fq, \<sigma>, fq') \<in> \<Delta> (NFA_rename_states \<A> f) \<longleftrightarrow> 
                (\<exists>q q'. (q, \<sigma>, q') \<in> \<Delta> \<A> \<and> (fq = f q) \<and> (fq' = f q'))" 
  by (auto simp add: NFA_rename_states_def)

lemma NFA_rename_states___is_well_formed :
 "NFA \<A> \<Longrightarrow> NFA (NFA_rename_states \<A> f)"
by (auto simp add: NFA_def image_iff Bex_def)

lemma NFA_rename_states_id [simp] : "NFA_rename_states \<A> id = \<A>" 
  by (rule NFA_rec.equality, auto simp add: NFA_rename_states_def)

lemma NFA_rename_states_NFA_rename_states [simp] : 
   "NFA_rename_states (NFA_rename_states \<A> f1) f2 = 
    NFA_rename_states \<A> (f2 \<circ> f1)" 
by (auto simp add: NFA_rename_states_def, metis)

lemma (in NFA) NFA_rename_states_agree_on_Q :
assumes f12_agree: "\<And>q. q \<in> \<Q> \<A> \<Longrightarrow> f1 q = f2 q"
shows "NFA_rename_states \<A> f1 = NFA_rename_states \<A> f2"
unfolding NFA_rename_states_def
proof (rule NFA_rec.equality, simp_all)
  have image_Q: "\<And>Q. Q \<subseteq> \<Q> \<A> \<Longrightarrow> f1 ` Q = f2 ` Q"
    using f12_agree 
    by (simp add: subset_iff set_eq_iff image_iff)

  from image_Q show "f1 ` (\<Q> \<A>) = f2 ` (\<Q> \<A>)" by simp
  from \<I>_consistent image_Q show "f1 ` (\<I> \<A>) = f2 ` (\<I> \<A>)" by simp
  from \<F>_consistent image_Q show "f1 ` (\<F> \<A>) = f2 ` (\<F> \<A>)" by simp
next
  from \<Delta>_consistent f12_agree
  show "{(f1 s1, a, f1 s2) |s1 a s2. (s1, a, s2) \<in> \<Delta> \<A>} =
        {(f2 s1, a, f2 s2) |s1 a s2. (s1, a, s2) \<in> \<Delta> \<A>}" 
    by (simp add: set_eq_iff) metis
qed

lemma LTS_is_reachable___NFA_rename_statesE :
 "LTS_is_reachable (\<Delta> \<A>) q w q' \<Longrightarrow>
  LTS_is_reachable (\<Delta> (NFA_rename_states \<A> f)) (f q) w (f q')"
proof (induct w arbitrary: q)
  case Nil thus ?case by simp
next
  case (Cons a w) 
  note ind_hyp = Cons(1)
  note reach_\<sigma>w = Cons(2)

  from reach_\<sigma>w obtain q'' \<sigma> where 
     q''_\<Delta>: "a \<in> \<sigma> \<and>(q, \<sigma>, q'') \<in> \<Delta> \<A>" and
     reach_w: "LTS_is_reachable (\<Delta> \<A>) q'' w q'" by auto

  from ind_hyp reach_w 
    have reach_w': "LTS_is_reachable (\<Delta> (NFA_rename_states \<A> f)) (f q'') w (f q')" 
    by blast

  from q''_\<Delta> have q''_\<Delta>' : "(f q, \<sigma>, f q'') \<in> (\<Delta> (NFA_rename_states \<A> f))" by auto

  from q''_\<Delta>' reach_w' show ?case 
    using q''_\<Delta> by auto
qed

lemma \<L>_in_state_rename_subset1 :
   "\<L>_in_state \<A> q \<subseteq> \<L>_in_state (NFA_rename_states \<A> f) (f q)"
by (simp add: \<L>_in_state_def subset_iff, metis LTS_is_reachable___NFA_rename_statesE)

definition NFA_is_equivalence_rename_fun where
"NFA_is_equivalence_rename_fun \<A> f = 
 (\<forall>q\<in>\<Q> \<A>. \<forall>q'\<in>\<Q> \<A>. (f q = f q') \<longrightarrow> (\<L>_in_state \<A> q = \<L>_in_state \<A> q'))"

definition NFA_is_strong_equivalence_rename_fun where
"NFA_is_strong_equivalence_rename_fun \<A> f = 
 (\<forall>q\<in>\<Q> \<A>. \<forall>q'\<in>\<Q> \<A>. ((f q = f q') \<longleftrightarrow> (\<L>_in_state \<A> q = \<L>_in_state \<A> q')))"

lemma NFA_is_strong_equivalence_rename_funE :
"\<lbrakk>NFA_is_strong_equivalence_rename_fun \<A> f;
  q \<in> \<Q> \<A>; q'\<in> \<Q> \<A>\<rbrakk> \<Longrightarrow> 
  f q = f q' \<longleftrightarrow> (\<L>_in_state \<A> q = \<L>_in_state \<A> q')"
unfolding NFA_is_strong_equivalence_rename_fun_def by metis

lemma NFA_is_strong_equivalence_rename_fun___weaken :
  "NFA_is_strong_equivalence_rename_fun \<A> f \<Longrightarrow>
   NFA_is_equivalence_rename_fun \<A> f"
by (simp add: NFA_is_equivalence_rename_fun_def NFA_is_strong_equivalence_rename_fun_def)



lemma NFA_is_strong_equivalence_rename_fun_exists :
  "\<exists>f::('a \<Rightarrow> 'a). (NFA_is_strong_equivalence_rename_fun \<A> f \<and> (\<forall>q \<in> \<Q> \<A>. f q \<in> \<Q> \<A>))"
proof -
  define fe where "fe = (\<lambda>l. SOME q. q \<in> \<Q> \<A> \<and> \<L>_in_state \<A> q = l)"
  define f where "f = (\<lambda>q. fe (\<L>_in_state \<A> q))"

  have f_lang : "\<And>q. q \<in> \<Q> \<A> \<Longrightarrow>
      f q \<in> \<Q> \<A> \<and> 
      \<L>_in_state \<A> (f q) = \<L>_in_state \<A> q"
    by (simp add: fe_def f_def, rule_tac someI_ex, auto)
    
  have "NFA_is_strong_equivalence_rename_fun \<A> f"
    by (simp add: NFA_is_strong_equivalence_rename_fun_def,
           metis f_def f_lang)
  with f_lang show ?thesis by metis
qed

lemma NFA_is_strong_equivalence_rename_fun___isomorph :
fixes f1 :: "'a \<Rightarrow> 'b"
  and f2 :: "'a => 'c"
  and \<A> :: "('a, 'l) NFA_rec"
assumes f1_OK: "NFA_is_strong_equivalence_rename_fun \<A> f1"
    and f2_OK: "NFA_is_strong_equivalence_rename_fun \<A> f2"
shows "\<exists>f12. (\<forall>q\<in>\<Q> \<A>. f2 q = (f12 (f1 q))) \<and> inj_on f12 (f1 ` (\<Q> \<A>))"
proof -
  define f12 where "f12 = (\<lambda>q. f2 ((inv_into (\<Q> \<A>) f1) q))"

  have inj_f12: "inj_on f12 (f1 ` (\<Q> \<A>))"
  unfolding inj_on_def f12_def
  proof (intro ballI impI) 
    fix q1 q2 :: 'b
    assume q1_in_f1_Q: "q1 \<in> f1 ` \<Q> \<A>"
    assume q2_in_f1_Q: "q2 \<in> f1 ` \<Q> \<A>"
    assume f2_eq: "f2 (inv_into (\<Q> \<A>) f1 q1) = f2 (inv_into (\<Q> \<A>) f1 q2)"

    let ?q1' = "inv_into (\<Q> \<A>) f1 q1"
    let ?q2' = "inv_into (\<Q> \<A>) f1 q2"

    from inv_into_into[OF q1_in_f1_Q] have q1'_in_Q: "?q1' \<in> \<Q> \<A>" .
    from inv_into_into[OF q2_in_f1_Q] have q2'_in_Q: "?q2' \<in> \<Q> \<A>" .

    from f_inv_into_f[OF q1_in_f1_Q] have q1_eq: "f1 ?q1' = q1" by simp
    from f_inv_into_f[OF q2_in_f1_Q] have q2_eq: "f1 ?q2' = q2" by simp


    from NFA_is_strong_equivalence_rename_funE [OF f2_OK q1'_in_Q q2'_in_Q] f2_eq
    have q12'_equiv: "\<L>_in_state \<A> ?q1' = \<L>_in_state \<A> ?q2'"
      unfolding NFA_is_strong_equivalence_rename_fun_def
      by simp

    with NFA_is_strong_equivalence_rename_funE [OF f1_OK q1'_in_Q q2'_in_Q]
    show "q1 = q2"
      by (simp add: q1_eq q2_eq)
  qed

  have f2_eq: "(\<forall>q\<in>\<Q> \<A>. f2 q = f12 (f1 q))"
  proof (intro ballI)
    fix q
    assume q_in_Q: "q\<in>\<Q> \<A>"

    let ?q' = "inv_into (\<Q> \<A>) f1 (f1 q)"

    from q_in_Q have f1_q_in_f1_Q: "f1 q \<in> f1 ` (\<Q> \<A>)" by simp


    from inv_into_into [OF f1_q_in_f1_Q] 
    have q'_in_Q: "?q' \<in> \<Q> \<A>" by simp

    from f_inv_into_f[OF f1_q_in_f1_Q] have "f1 ?q' = f1 q" by simp
    with NFA_is_strong_equivalence_rename_funE [OF f1_OK q'_in_Q q_in_Q] 
    have q_q'_equiv: "\<L>_in_state \<A> ?q' = \<L>_in_state \<A> q"
      by simp

    from NFA_is_strong_equivalence_rename_funE [OF f2_OK q'_in_Q q_in_Q] q_q'_equiv
    have "f2 q = f2 ?q'" by simp

    thus "f2 q = f12 (f1 q)"
      unfolding f12_def
      by simp
  qed
    
  from f2_eq inj_f12 show ?thesis by blast
qed

lemma (in NFA) \<L>_in_state_rename_subset2 :
assumes equiv_f : "NFA_is_equivalence_rename_fun \<A> f" 
assumes q_in_Q  : "q \<in> \<Q> \<A>"
shows "\<L>_in_state (NFA_rename_states \<A> f) (f q) \<subseteq> \<L>_in_state \<A> q"
proof -
have "\<And>w q'. \<lbrakk>q \<in> \<Q> \<A>;  q' \<in> \<F> \<A>; LTS_is_reachable (\<Delta> (NFA_rename_states \<A> f)) (f q) w (f q')\<rbrakk> \<Longrightarrow>
              w \<in> \<L>_in_state \<A> q"
proof -
  fix w q'
  assume q'_in_F: "q' \<in> \<F> \<A>"
  from q'_in_F have q'_in_Q: "q' \<in> \<Q> \<A>" using \<F>_consistent 
      by (auto simp add: NFA_def)
   show "\<lbrakk>q \<in> \<Q> \<A>;  
      LTS_is_reachable (\<Delta> (NFA_rename_states \<A> f)) (f q) w (f q')\<rbrakk> \<Longrightarrow>
         w \<in> \<L>_in_state \<A> q"
  proof (induct w arbitrary: q)
    case Nil
    note q_in_Q = Nil(1)
    from Nil(2) have "f q = f q'" by simp
    with equiv_f q_in_Q q'_in_Q have "\<L>_in_state \<A> q = \<L>_in_state \<A> q'" 
      by (metis NFA_is_equivalence_rename_fun_def) 
    with q'_in_F have "q \<in> \<F> \<A>" by (metis \<L>_in_state___in_\<F>)
    thus "[] \<in> \<L>_in_state \<A> q" by simp
  next
    case (Cons a w)
    note ind_hyp = Cons(1) 
    note q_in_Q = Cons(2) 
    note \<sigma>w_lists = Cons(3)
   

    from \<sigma>w_lists obtain q'' q''' \<sigma> where
       f_q'''_eq: "f q''' = f q" and
       in_\<Delta>: "(q''', \<sigma>, q'') \<in> \<Delta> \<A> \<and> a \<in> \<sigma>" and
       in_r\<Delta>: "(f q, \<sigma>, f q'') \<in>  (\<Delta> (NFA_rename_states \<A> f))" and
       is_reach_w': "LTS_is_reachable (\<Delta> (NFA_rename_states \<A> f)) (f q'') w (f q')"
    by (auto, metis) 

    from in_\<Delta> have q'''_in_Q : "q''' \<in> \<Q> \<A>" and
                   q''_in_Q: "q'' \<in> \<Q> \<A>"
      using \<Delta>_consistent 
      apply blast
      using \<Delta>_consistent in_\<Delta> by blast
   

    from q''_in_Q ind_hyp is_reach_w' \<sigma>w_lists have
       "w \<in> \<L>_in_state \<A> q''" by simp
    with in_\<Delta> \<sigma>w_lists have "(a # w) \<in> \<L>_in_state \<A> q'''" by auto 
    with q_in_Q q'''_in_Q f_q'''_eq equiv_f show ?case
      by (metis NFA_is_equivalence_rename_fun_def)
  qed
qed
thus ?thesis
  by (auto simp add: \<L>_in_state_def subset_iff q_in_Q)
qed

lemma (in NFA) \<L>_in_state_rename_iff :
assumes equiv_f : "NFA_is_equivalence_rename_fun \<A> f" 
assumes q_in_Q  : "q \<in> \<Q> \<A>"
shows "\<L>_in_state (NFA_rename_states \<A> f) (f q) = \<L>_in_state \<A> q"
using assms
by (metis \<L>_in_state_rename_subset1 \<L>_in_state_rename_subset2 set_eq_subset)

lemma (in NFA) \<L>_rename_iff :
assumes equiv_f : "NFA_is_equivalence_rename_fun \<A> f" 
shows "\<L> (NFA_rename_states \<A> f) = \<L> \<A>"
proof -
  have "\<And>q. q \<in> \<I> \<A> \<Longrightarrow> q \<in> \<Q> \<A>" using \<I>_consistent by auto
  thus ?thesis
    by (simp add: \<L>_alt_def set_eq_iff Bex_def,
        metis \<L>_in_state_rename_iff equiv_f)
qed

lemma (in NFA) \<L>_left_rename_iff :
  assumes equiv_f : "NFA_is_equivalence_rename_fun 
        \<lparr>\<Q> = \<Q> \<A>, \<Delta> = \<Delta> \<A>, \<I> = \<I> \<A>, \<F> = {q}\<rparr> f" 
    and q_in: "q \<in> \<Q> \<A>"
shows "\<L>_left (NFA_rename_states \<A> f) (f q) = \<L>_left \<A> q"
proof -
  obtain \<A>' where \<A>'_def: "\<A>' = \<lparr>\<Q> = \<Q> \<A>, \<Delta> = \<Delta> \<A>, \<I> = \<I> \<A>, \<F> = {q}\<rparr>"
    by blast

  from wf_NFA \<A>'_def q_in have wf_\<A>': "NFA \<A>'"
    unfolding NFA_def by simp

  have left_A: "\<L>_left \<A> q = \<L> \<A>'" 
    unfolding \<L>_left_alt_def \<A>'_def ..

  have left_reA: "\<L>_left (NFA_rename_states \<A> f) (f q) = \<L>  (NFA_rename_states \<A>' f)"
    unfolding \<L>_left_alt_def \<A>'_def 
    by (simp add: NFA_rename_states_def)

  from equiv_f have equiv_f' : "NFA_is_equivalence_rename_fun \<A>' f"
     unfolding \<A>'_def
     by simp

  from NFA.\<L>_rename_iff [OF wf_\<A>' equiv_f']
       left_A left_reA
  show ?thesis by simp
qed

lemma (in NFA) \<L>_left_rename_iff_inj :
assumes inj_f : "inj_on f (\<Q> \<A>)" 
    and q_in: "q \<in> \<Q> \<A>"
shows "\<L>_left (NFA_rename_states \<A> f) (f q) = \<L>_left \<A> q"
proof -
  from inj_f have equiv_f : "NFA_is_equivalence_rename_fun 
        \<lparr>\<Q> = \<Q> \<A>,  \<Delta> = \<Delta> \<A>, \<I> = \<I> \<A>, \<F> = {q}\<rparr> f" 
    unfolding NFA_is_equivalence_rename_fun_def inj_on_def
    by auto

  from \<L>_left_rename_iff [OF equiv_f q_in] 
  show ?thesis .
qed

lemma (in NFA) NFA_rename_states___accept :
assumes equiv_f : "NFA_is_equivalence_rename_fun \<A> f" 
shows "NFA_accept (NFA_rename_states \<A> f) w = NFA_accept \<A> w"
using assms
by (simp add: NFA_accept_alt_def \<L>_rename_iff)


text \<open>  Renaming without combining states is fine. \<close>
lemma NFA_is_equivalence_rename_funI___inj_used : 
  "inj_on f (\<Q> \<A>) \<Longrightarrow> NFA_is_equivalence_rename_fun \<A> f"
by (auto simp add: inj_on_def NFA_is_equivalence_rename_fun_def)

text \<open> Combining without renaming is fine as well. \<close>  
lemma NFA_is_equivalence_rename_funI___intro2 :
"(\<forall>q \<in> \<Q> \<A>. ((f q \<in> \<Q> \<A>) \<and> (\<L>_in_state \<A> (f q) = \<L>_in_state \<A> q))) \<Longrightarrow> NFA_is_equivalence_rename_fun \<A> f"
by (simp add: inj_on_def NFA_is_equivalence_rename_fun_def, metis)


subsection \<open> Isomorphy \<close>

definition NFA_isomorphic where
  "NFA_isomorphic \<A>1 \<A>2 \<equiv>
   (\<exists>f. inj_on f (\<Q> \<A>1) \<and> \<A>2 = NFA_rename_states \<A>1 f)"

lemma NFA_isomorphic_refl :
  "NFA_isomorphic \<A> \<A>"
proof -
  have "inj_on id (\<Q> \<A>)" by simp
  moreover
  have "NFA_rename_states \<A> id = \<A>" by simp
  ultimately
  show ?thesis unfolding NFA_isomorphic_def by metis
qed

lemma NFA_isomorphic_sym_impl :
assumes wf_NFA1 : "NFA \<A>1"
    and equiv_\<A>1_\<A>2: "NFA_isomorphic \<A>1 \<A>2"
shows "NFA_isomorphic \<A>2 \<A>1"
proof -
  from equiv_\<A>1_\<A>2 
  obtain f where inj_f : "inj_on f (\<Q> \<A>1)" and
                 \<A>2_eq: "\<A>2 = NFA_rename_states \<A>1 f" 
    unfolding NFA_isomorphic_def by auto

  obtain f' where f'_def : "f' = inv_into (\<Q> \<A>1) f" by auto
  with inj_f have f'_f: "\<And>q. q \<in> (\<Q> \<A>1) \<Longrightarrow> f' (f q) = q" by simp

  from \<A>2_eq have Q_A2_eq: "\<Q> \<A>2 = f ` (\<Q> \<A>1)"
    by (simp add: NFA_rename_states_def) 
  with f'_f have inj_f' : "inj_on f' (\<Q> \<A>2)"
    by (simp add: inj_on_def)

  have \<A>1_eq : "\<A>1 = NFA_rename_states \<A>2 f'"
  proof (rule NFA_rec.equality)
    
    from f'_f 
    show "\<Q> \<A>1 = \<Q> (NFA_rename_states \<A>2 f')"
      by (auto simp add: \<A>2_eq NFA_remove_states_def image_iff)
  next
    from wf_NFA1 have "\<I> \<A>1 \<subseteq> \<Q> \<A>1" by (simp add: NFA_def)
    with f'_f have "\<And>q. q \<in> (\<I> \<A>1) \<Longrightarrow> f' (f q) = q" by auto
    thus "\<I> \<A>1 = \<I> (NFA_rename_states \<A>2 f')"
      by (auto simp add: \<A>2_eq NFA_remove_states_def image_iff)
  next
    from wf_NFA1 have "\<F> \<A>1 \<subseteq> \<Q> \<A>1" by (simp add: NFA_def)
    with f'_f have "\<And>q. q \<in> (\<F> \<A>1) \<Longrightarrow> f' (f q) = q" by auto
    thus "\<F> \<A>1 = \<F> (NFA_rename_states \<A>2 f')"
      by (auto simp add: \<A>2_eq NFA_remove_states_def image_iff)
  next
    from wf_NFA1 f'_f 
    have "\<And>q1 a q2. (q1, a, q2) \<in> (\<Delta> \<A>1) \<Longrightarrow> f' (f q1) = q1 \<and>  f' (f q2) = q2" 
       unfolding NFA_def by auto
    thus "\<Delta> \<A>1 = \<Delta> (NFA_rename_states \<A>2 f')"
      by (auto simp add: \<A>2_eq NFA_remove_states_def, metis)
  next        
    show "more \<A>1 = more (NFA_rename_states \<A>2 f')"
      by (simp add: NFA_remove_states_def)
  qed

  from \<A>1_eq inj_f' show "NFA_isomorphic \<A>2 \<A>1" unfolding NFA_isomorphic_def by auto
qed

lemma NFA_isomorphic_sym :
assumes wf_NFA1: "NFA \<A>1"
    and wf_NFA2: "NFA \<A>2"
shows "NFA_isomorphic \<A>1 \<A>2 \<longleftrightarrow> NFA_isomorphic \<A>2 \<A>1"
using assms
by (metis NFA_isomorphic_sym_impl)

lemma NFA_isomorphic___implies_well_formed :
assumes wf_NFA1: "NFA \<A>1"
    and equiv_\<A>1_\<A>2: "NFA_isomorphic \<A>1 \<A>2"
shows "NFA \<A>2"
using assms 
by (metis NFA_rename_states___is_well_formed NFA_isomorphic_def)

lemma NFA_isomorphic_trans :
assumes equiv_\<A>1_\<A>2: "NFA_isomorphic \<A>1 \<A>2"
    and equiv_\<A>2_\<A>3: "NFA_isomorphic \<A>2 \<A>3"
shows "NFA_isomorphic \<A>1 \<A>3"
proof -
  from equiv_\<A>1_\<A>2 
  obtain f1 where inj_f1 : "inj_on f1 (\<Q> \<A>1)" and
                  \<A>2_eq: "\<A>2 = NFA_rename_states \<A>1 f1" 
    unfolding NFA_isomorphic_def by auto

  from equiv_\<A>2_\<A>3 
  obtain f2 where inj_f2 : "inj_on f2 (\<Q> \<A>2)" and
                  \<A>3_eq: "\<A>3 = NFA_rename_states \<A>2 f2" 
    unfolding NFA_isomorphic_def by auto

  from \<A>2_eq \<A>3_eq have \<A>3_eq' : "\<A>3 = NFA_rename_states \<A>1 (f2 \<circ> f1)" by simp

  from \<A>2_eq have "\<Q> \<A>2 = f1 ` (\<Q> \<A>1)" by (simp add: NFA_remove_states_def)
  with inj_f1 inj_f2 have f2_f1_inj: "inj_on (f2 \<circ> f1) (\<Q> \<A>1)"
    by (simp add: inj_on_def)

  from \<A>3_eq' f2_f1_inj show "NFA_isomorphic \<A>1 \<A>3" unfolding NFA_isomorphic_def by auto
qed

text \<open>   Normaly, one is interested in only well-formed automata. This simplifies
        reasoning about isomorphy. \<close>
definition NFA_isomorphic_wf where
  "NFA_isomorphic_wf \<A>1 \<A>2 \<equiv> NFA_isomorphic \<A>1 \<A>2 \<and> NFA \<A>1"

lemma NFA_isomorphic_wf_\<L> :
assumes equiv: "NFA_isomorphic_wf \<A>1 \<A>2"
shows "\<L> \<A>1 = \<L> \<A>2"
proof -
  from equiv
  obtain f where inj_f : "inj_on f (\<Q> \<A>1)" and
                 \<A>2_eq: "\<A>2 = NFA_rename_states \<A>1 f" and
                 wf_\<A>1: "NFA \<A>1" 
    unfolding NFA_isomorphic_wf_def NFA_isomorphic_def by auto

  from inj_f have "NFA_is_equivalence_rename_fun \<A>1 f" by
    (simp add: NFA_is_equivalence_rename_funI___inj_used)

  note NFA.\<L>_rename_iff [OF wf_\<A>1 this]
  with \<A>2_eq show ?thesis by simp
qed

(*
lemma NFA_isomorphic_wf_\<Sigma> :
assumes equiv: "NFA_isomorphic_wf \<A>1 \<A>2"
shows "\<Sigma> \<A>1 = \<Sigma> \<A>2"
proof -
  from equiv
  obtain f where \<A>2_eq: "\<A>2 = NFA_rename_states \<A>1 f" 
    unfolding NFA_isomorphic_wf_def NFA_isomorphic_def by auto

  with \<A>2_eq show ?thesis by simp
qed
*)

lemma NFA_isomorphic_wf_accept :
assumes equiv: "NFA_isomorphic_wf \<A>1 \<A>2"
shows "NFA_accept \<A>1 w = NFA_accept \<A>2 w"
using NFA_isomorphic_wf_\<L> [OF equiv]
by (simp add: set_eq_iff \<L>_def)

lemma NFA_isomorphic_wf_alt_def :
  "NFA_isomorphic_wf \<A>1 \<A>2 \<longleftrightarrow>
   NFA_isomorphic \<A>1 \<A>2 \<and> NFA \<A>1 \<and> NFA \<A>2"
unfolding NFA_isomorphic_wf_def
by (metis NFA_isomorphic___implies_well_formed)

lemma NFA_isomorphic_wf_sym :
  "NFA_isomorphic_wf \<A>1 \<A>2 = NFA_isomorphic_wf \<A>2 \<A>1"
unfolding NFA_isomorphic_wf_alt_def
by (metis NFA_isomorphic_sym)

lemma NFA_isomorphic_wf_trans :
  "\<lbrakk>NFA_isomorphic_wf \<A>1 \<A>2; NFA_isomorphic_wf \<A>2 \<A>3\<rbrakk> \<Longrightarrow>
   NFA_isomorphic_wf \<A>1 \<A>3"
unfolding NFA_isomorphic_wf_alt_def
by (metis NFA_isomorphic_trans)

lemma NFA_isomorphic_wf_refl :
  "NFA \<A>1 \<Longrightarrow> NFA_isomorphic_wf \<A>1 \<A>1"
unfolding NFA_isomorphic_wf_def
by (simp add: NFA_isomorphic_refl)

lemma NFA_isomorphic_wf_intro :
  "\<lbrakk>NFA \<A>1; NFA_isomorphic \<A>1 \<A>2\<rbrakk> \<Longrightarrow> NFA_isomorphic_wf \<A>1 \<A>2"
unfolding NFA_isomorphic_wf_def by simp

lemma NFA_isomorphic_wf_D :
  "NFA_isomorphic_wf \<A>1 \<A>2 \<Longrightarrow> NFA \<A>1"
  "NFA_isomorphic_wf \<A>1 \<A>2 \<Longrightarrow> NFA \<A>2"
  "NFA_isomorphic_wf \<A>1 \<A>2 \<Longrightarrow> NFA_isomorphic \<A>1 \<A>2"
  "NFA_isomorphic_wf \<A>1 \<A>2 \<Longrightarrow> NFA_isomorphic \<A>2 \<A>1"
unfolding NFA_isomorphic_wf_alt_def
by (simp_all, metis NFA_isomorphic_sym)
  
lemma NFA_isomorphic___NFA_rename_states :
"inj_on f (\<Q> \<A>) \<Longrightarrow> NFA_isomorphic \<A> (NFA_rename_states \<A> f)"
unfolding NFA_isomorphic_def
by blast

lemma NFA_isomorphic_wf___NFA_rename_states :
"\<lbrakk>inj_on f (\<Q> \<A>); NFA \<A>\<rbrakk> \<Longrightarrow> NFA_isomorphic_wf \<A> (NFA_rename_states \<A> f)"
unfolding NFA_isomorphic_def NFA_isomorphic_wf_def
by blast

lemma NFA_isomorphic_wf___rename_states_cong :
fixes \<A>1 :: "('q1, 'a) NFA_rec"
fixes \<A>2 :: "('q2, 'a) NFA_rec"
assumes inj_f1 : "inj_on f1 (\<Q> \<A>1)" and
        inj_f2 : "inj_on f2 (\<Q> \<A>2)" and
        equiv: "NFA_isomorphic_wf \<A>1 \<A>2"
shows "NFA_isomorphic_wf (NFA_rename_states \<A>1 f1) (NFA_rename_states \<A>2 f2)"
proof -
  note wf_\<A>1 = NFA_isomorphic_wf_D(1)[OF equiv]
  note wf_\<A>2 = NFA_isomorphic_wf_D(2)[OF equiv]

  note eq_1 = NFA_isomorphic_wf___NFA_rename_states [OF inj_f1 wf_\<A>1]
  note eq_2 = NFA_isomorphic_wf___NFA_rename_states [OF inj_f2 wf_\<A>2]
  from eq_1 eq_2 equiv show ?thesis
    by (metis NFA_isomorphic_wf_trans NFA_isomorphic_wf_sym)
qed

lemma NFA_isomorphic_wf___NFA_remove_unreachable_states :
assumes equiv: "NFA_isomorphic_wf \<A>1 \<A>2"
shows "NFA_isomorphic_wf (NFA_remove_unreachable_states \<A>1) (NFA_remove_unreachable_states \<A>2)"
proof -
  from equiv
  obtain f where inj_f : "inj_on f (\<Q> \<A>1)" and
                 \<A>2_eq: "\<A>2 = NFA_rename_states \<A>1 f" and
                 wf_\<A>1: "NFA \<A>1" and
                 wf_\<A>2: "NFA \<A>2" 
    unfolding NFA_isomorphic_wf_alt_def NFA_isomorphic_def by auto

  have "\<Q> (NFA_remove_unreachable_states \<A>1) \<subseteq> \<Q> \<A>1"
    unfolding NFA_remove_unreachable_states_def by auto
  with inj_f have inj_f' : "inj_on f (\<Q> (NFA_remove_unreachable_states \<A>1))"
    by (rule subset_inj_on)

  from NFA.\<L>_left_rename_iff_inj [OF wf_\<A>1 inj_f]
  have unreach_lem: 
    "\<And>q. q \<in> \<Q> \<A>1 \<Longrightarrow>
     f q \<in> NFA_unreachable_states (NFA_rename_states \<A>1 f) \<longleftrightarrow>
     q \<in> (NFA_unreachable_states \<A>1 \<inter> \<Q> \<A>1)"
    by (simp add: NFA_unreachable_states_alt_def)

  have diff_lem : 
   "\<And>Q. Q \<subseteq> \<Q> \<A>1 \<Longrightarrow>
    f ` Q - NFA_unreachable_states (NFA_rename_states \<A>1 f) =
    f ` (Q - NFA_unreachable_states \<A>1)"
  apply (rule set_eqI)
  apply (insert unreach_lem)
  apply (auto)
  done

  have \<A>2_eq' :
    "NFA_remove_unreachable_states \<A>2 = NFA_rename_states (NFA_remove_unreachable_states \<A>1) f"
    proof (rule  NFA_rec.equality)
      show 
           "more (NFA_remove_unreachable_states \<A>2) =
            more (NFA_rename_states (NFA_remove_unreachable_states \<A>1) f)"

        unfolding NFA_remove_unreachable_states_def \<A>2_eq
        by simp_all
    next
      from diff_lem [of "\<Q> \<A>1"]
      show "\<Q> (NFA_remove_unreachable_states \<A>2) =
            \<Q> (NFA_rename_states (NFA_remove_unreachable_states \<A>1) f)"
        unfolding NFA_remove_unreachable_states_def \<A>2_eq
        by simp
    next
      from diff_lem [OF NFA.\<I>_consistent [OF wf_\<A>1]]
      show "\<I> (NFA_remove_unreachable_states \<A>2) =
            \<I> (NFA_rename_states (NFA_remove_unreachable_states \<A>1) f)"
        unfolding NFA_remove_unreachable_states_def \<A>2_eq
        by simp
    next
      from diff_lem [OF NFA.\<F>_consistent [OF wf_\<A>1]]
      show "\<F> (NFA_remove_unreachable_states \<A>2) =
            \<F> (NFA_rename_states (NFA_remove_unreachable_states \<A>1) f)"
        unfolding NFA_remove_unreachable_states_def \<A>2_eq
        by simp
    next
      from unreach_lem NFA.\<Delta>_consistent [OF wf_\<A>1]
      have "\<And>q a q'. (q, a, q') \<in> \<Delta> \<A>1 \<and>
                     f q \<notin> NFA_unreachable_states (NFA_rename_states \<A>1 f) \<and>
                     f q' \<notin> NFA_unreachable_states (NFA_rename_states \<A>1 f) \<longleftrightarrow>
                     (q, a, q') \<in> \<Delta> \<A>1 \<and>
                     q \<notin> NFA_unreachable_states \<A>1 \<and>
                     q' \<notin> NFA_unreachable_states \<A>1"
        by auto
      hence "\<And>q a q'. (q, a, q') \<in> \<Delta> (NFA_remove_unreachable_states \<A>2) \<longleftrightarrow>
                     (q, a, q') \<in> \<Delta> (NFA_rename_states (NFA_remove_unreachable_states \<A>1) f)"
        unfolding NFA_remove_unreachable_states_def \<A>2_eq
        by (simp, blast)
      thus "\<Delta> (NFA_remove_unreachable_states \<A>2) =
            \<Delta> (NFA_rename_states (NFA_remove_unreachable_states \<A>1) f)"
        by auto
    qed

  from inj_f' \<A>2_eq' NFA_remove_unreachable_states___is_well_formed[OF wf_\<A>1]
  show ?thesis
    unfolding NFA_isomorphic_wf_def NFA_isomorphic_def
    by blast
qed
  
lemma NFA_is_initially_connected___NFA_rename_states :
assumes connected: "NFA_is_initially_connected \<A>"
shows "NFA_is_initially_connected (NFA_rename_states \<A> f)"
unfolding NFA_is_initially_connected_alt_def
proof (intro ballI)
  fix q2
  let ?A2 = "NFA_rename_states \<A> f"
  assume q2_in: "q2 \<in> \<Q> ?A2"
  from q2_in obtain q1 where q1_in: "q1 \<in> \<Q> \<A>" and q2_eq: "q2 = f q1" by auto

  from connected q1_in obtain i1 w where
     i1_in: "i1 \<in> \<I> \<A>" and 
     reach1: "LTS_is_reachable (\<Delta> \<A>) i1 w q1"
    unfolding NFA_is_initially_connected_alt_def
    by blast

  have i2_in: "f i1 \<in> \<I> ?A2"
    using i1_in by auto

  have reach2 : "LTS_is_reachable (\<Delta> ?A2) (f i1) w (f q1)"
    using LTS_is_reachable___NFA_rename_statesE [OF reach1, of f]  .

  from i2_in reach2
  show "\<exists>i\<in>\<I> ?A2. \<exists>w. LTS_is_reachable (\<Delta> ?A2) i w q2"
    using q2_eq by blast
qed

lemma NFA_is_initially_connected___NFA_isomorphic :
assumes equiv: "NFA_isomorphic \<A>1 \<A>2"
    and connected_A1: "NFA_is_initially_connected \<A>1"
shows "NFA_is_initially_connected \<A>2"
proof -
  from equiv obtain f where \<A>2_eq: "\<A>2 = NFA_rename_states \<A>1 f"
    unfolding NFA_isomorphic_def by auto

  from NFA_is_initially_connected___NFA_rename_states [OF connected_A1, of f, folded \<A>2_eq]
  show ?thesis .
qed

lemma NFA_is_initially_connected___NFA_isomorphic_wf :
fixes \<A>1 :: "('q1, 'a) NFA_rec"
fixes \<A>2 :: "('q2, 'a) NFA_rec"
assumes iso: "NFA_isomorphic_wf \<A>1 \<A>2"
shows "NFA_is_initially_connected \<A>1 = NFA_is_initially_connected \<A>2"
using assms
by (metis NFA_is_initially_connected___NFA_isomorphic
          NFA_isomorphic_wf_sym NFA_isomorphic_wf_def)


subsection \<open> Efficient Construction of NFAs \<close>

text  \<open> In the following automata are constructed by 
sequentially adding states together to an initially empty automaton.
An \emph{empty} automaton contains an alphabet of labels and a set of initial states.
Adding states updates the set of states, the transition relation and the set of
accepting states.

This construction is used to add only the reachable states to an automaton.
\<close>

definition NFA_initial_automaton :: "'q set \<Rightarrow> ('q, 'a) NFA_rec" where
  "NFA_initial_automaton I \<equiv> \<lparr> \<Q> = {},  \<Delta> = {}, \<I>=I, \<F> = {} \<rparr>"

definition NFA_insert_state :: "('q \<Rightarrow> bool) \<Rightarrow> ('q, 'a) LTS \<Rightarrow> 'q 
                                 \<Rightarrow> ('q, 'a) NFA_rec \<Rightarrow> ('q, 'a) NFA_rec" 
where
"NFA_insert_state FP D q \<A> \<equiv>
\<lparr> \<Q>=insert q (\<Q> \<A>),  \<Delta> = \<Delta> \<A> \<union> {qsq . qsq \<in> D \<and> fst qsq = q 
          \<and> (fst (snd qsq) \<noteq> {})}, 
  \<I>=\<I> \<A>, \<F> = if (FP q) then insert q (\<F> \<A>) else (\<F> \<A>)\<rparr>"

definition NFA_construct_reachable where
"NFA_construct_reachable I FP D =
 Finite_Set.fold (NFA_insert_state FP D) 
     (NFA_initial_automaton I) 
     (accessible (LTS_forget_labels D) I)"

lemma NFA_insert_state___comp_fun_commute :
  "comp_fun_commute (NFA_insert_state FP D)"
apply (simp add: NFA_insert_state_def comp_fun_commute_def o_def)
apply (subst fun_eq_iff)
apply simp
apply (metis Un_commute Un_left_commute insert_commute)
done

lemma fold_NFA_insert_state : 
"finite Q \<Longrightarrow> Finite_Set.fold (NFA_insert_state FP D) \<A> Q =
\<lparr> \<Q>=Q \<union> (\<Q> \<A>), \<Delta> = \<Delta> \<A> \<union> {qsq. qsq \<in> D \<and> fst qsq \<in> Q \<and> (fst (snd qsq) \<noteq> {}) }, 
  \<I>=\<I> \<A>, \<F> = (\<F> \<A>) \<union> {q. q \<in> Q \<and> FP q} \<rparr>"
apply (induct rule: finite_induct)
  apply (simp) 
apply (simp add: comp_fun_commute.fold_insert [OF NFA_insert_state___comp_fun_commute])
apply (auto simp add: NFA_insert_state_def)
done

lemma NFA_construct_reachable_simp :
 "finite (accessible (LTS_forget_labels D) I) \<Longrightarrow>
  NFA_construct_reachable I  FP D = 
  \<lparr>\<Q> = accessible (LTS_forget_labels D) I, \<Delta> = {qsq. qsq \<in> D \<and> 
      fst qsq \<in> accessible (LTS_forget_labels D) I \<and> (fst (snd qsq) \<noteq> {})}, \<I> = I,
   \<F> = {q \<in> accessible (LTS_forget_labels D) I. FP q}\<rparr>"
by (simp add: NFA_construct_reachable_def
              fold_NFA_insert_state NFA_initial_automaton_def)

text \<open> Now show that this can be used to remove unreachable states \<close>


lemma (in NFA) NFA_remove_unreachable_states_implementation :
assumes I_OK: "I = \<I> \<A>"
    and FP_OK: "\<And>q. q \<in> \<Q> \<A> \<Longrightarrow> FP q \<longleftrightarrow> q \<in> \<F> \<A>"
    and D_OK: "D = \<Delta> \<A>"
shows
  "(NFA_remove_unreachable_states \<A>) = (NFA_construct_reachable I FP D)"
  (is "?ls = ?rs")
proof -
  let ?D = "LTS_forget_labels (\<Delta> \<A>)"
  note access_eq = LTS_is_reachable_from_initial_alt_def
  have access_eq' : "accessible ?D (\<I> \<A>) = \<Q> \<A> - NFA_unreachable_states \<A>"
                    (is "?ls' = ?rs'")
  proof (intro set_eqI iffI)
    fix q
    assume "q \<in> ?rs'" 
    thus "q \<in> ?ls'"
      by (auto simp add: NFA_unreachable_states_def access_eq LTS_is_unreachable_def)
  next
    fix q
    assume ls: "q \<in> ?ls'" 
    with LTS_is_reachable_from_initial_subset have q_in_Q: "q \<in> \<Q> \<A>" by auto
    from \<I>_consistent have I_subset_Q: "\<And>q. q \<in> \<I> \<A> \<Longrightarrow> q \<in> \<Q> \<A>" by auto

    from ls q_in_Q I_subset_Q show "q \<in> ?rs'"
      by (auto simp add: NFA_unreachable_states_def access_eq LTS_is_unreachable_def Bex_def)
  qed

  have \<I>_diff_eq: "\<I> \<A> - NFA_unreachable_states \<A> = \<I> \<A>"
    by (auto simp add: NFA_unreachable_states_\<I>)

  from \<F>_consistent FP_OK have \<F>_eq: 
    "{q \<in> \<Q> \<A>. q \<notin> NFA_unreachable_states \<A> \<and> FP q} =
     \<F> \<A> - NFA_unreachable_states \<A>" by auto

  from LTS_is_reachable_from_initial_finite
  show "?ls = ?rs"
    apply (simp add: NFA_construct_reachable_simp I_OK D_OK)
    apply (simp add: NFA_remove_unreachable_states_def)
    apply (simp add: NFA_remove_states_def access_eq')
    apply (auto simp add: \<I>_diff_eq \<F>_eq \<Delta>_consistent)
    by (metis NFA.\<Delta>_consistent NFA_unreachable_states_extend equals0D wf_NFA)
qed


text \<open> Now let's implement efficiently constructing NFAs. During implementation, 
        the states are renamend as well. \<close>

definition NFA_construct_reachable_map_OK where
  "NFA_construct_reachable_map_OK S rm DD rm' \<longleftrightarrow>
   DD \<subseteq> dom rm' \<and>
   (\<forall>q r'. rm q = Some r' \<longrightarrow> rm' q = Some r') \<and>
   inj_on rm' (S \<inter> dom rm')"

lemma NFA_construct_reachable_map_OK_I [intro!] :
"\<lbrakk>DD \<subseteq> dom rm'; \<And>q r'. rm q = Some r' \<Longrightarrow> rm' q = Some r'; 
  inj_on rm' (S \<inter> dom rm')\<rbrakk> \<Longrightarrow>
 NFA_construct_reachable_map_OK S rm DD rm'"
unfolding NFA_construct_reachable_map_OK_def by simp

lemma NFA_construct_reachable_map_OK_insert_DD :
  "NFA_construct_reachable_map_OK S rm (insert q DD) rm' \<longleftrightarrow>
   q \<in> dom rm' \<and> NFA_construct_reachable_map_OK S rm DD rm'"
unfolding NFA_construct_reachable_map_OK_def by simp

lemma NFA_construct_reachable_map_OK_trans :
  "\<lbrakk>NFA_construct_reachable_map_OK S rm DD rm'; 
    NFA_construct_reachable_map_OK S rm' DD' rm''; 
    DD'' \<subseteq> DD \<union> DD'\<rbrakk> \<Longrightarrow>
   NFA_construct_reachable_map_OK S rm DD'' rm''"
unfolding NFA_construct_reachable_map_OK_def 
  by (simp add: subset_iff dom_def) metis


definition NFA_construct_reachable_abstract_impl_invar where
"NFA_construct_reachable_abstract_impl_invar I FP D \<equiv> (\<lambda>((rm, \<A>), wl).
(\<exists>s. NFA_construct_reachable_map_OK (accessible (LTS_forget_labels D) 
       (set I)) Map.empty 
       (s \<union> set I \<union> set wl \<union> {q'. \<exists>a q. q \<in> s \<and> a \<noteq> {} \<and> (q,a,q')\<in> D}) rm \<and>
     (accessible (LTS_forget_labels D) (set I)  = 
      accessible_restrict (LTS_forget_labels D) s (set wl)) \<and>
     (\<A> = NFA_rename_states 
        \<lparr>\<Q> = s, \<Delta> = {qsq. qsq \<in> D \<and> 
         fst qsq \<in> s \<and> (fst (snd qsq) \<noteq> {})}, \<I> = set I,
         \<F> = {q \<in> s. FP q}\<rparr> (the \<circ> rm))))"

definition NFA_construct_reachable_abstract_impl_weak_invar where
"NFA_construct_reachable_abstract_impl_weak_invar I FP D \<equiv> (\<lambda>(rm, \<A>).
(\<exists>s. NFA_construct_reachable_map_OK (accessible (LTS_forget_labels D) (set I)) Map.empty 
       (s \<union> set I \<union> {q'. \<exists>a q. q\<in>s \<and> (q,a,q')\<in> D  \<and> a \<noteq> {}}) rm \<and>
     s \<subseteq> accessible (LTS_forget_labels D) (set I) \<and> 
     (\<A> = NFA_rename_states 
        \<lparr>\<Q> = s, 
         \<Delta> = {qsq. qsq \<in> D \<and> fst qsq \<in> s \<and> (fst (snd qsq) \<noteq> {})}, \<I> = set I,
         \<F> = {q \<in> s. FP q}\<rparr> (the \<circ> rm))))"

lemma NFA_construct_reachable_abstract_impl_invar_weaken :
assumes invar: "NFA_construct_reachable_abstract_impl_invar I FP D ((rm, \<A>), wl)"
shows "NFA_construct_reachable_abstract_impl_weak_invar I FP D (rm, \<A>)"
using assms
unfolding NFA_construct_reachable_abstract_impl_weak_invar_def
          NFA_construct_reachable_abstract_impl_invar_def
          accessible_restrict_def NFA_construct_reachable_map_OK_def
apply clarify
apply (rule_tac x=s in exI)
  apply auto
  by blast



fun NFA_construct_reachable_abstract_impl_foreach_invar where
  "NFA_construct_reachable_abstract_impl_foreach_invar
    S D rm D0 q it (rm', D', N) =
    (let D'' = {(a, q') . (q, a, q') \<in> D \<and> a \<noteq> {}} - it; qS = snd ` D'' in
    (NFA_construct_reachable_map_OK S rm qS rm' \<and>
     set N = qS \<and>
     D' = D0 \<union> {(the (rm' q), a, the (rm' q')) | a q'. (a, q') \<in> D''}))"

declare NFA_construct_reachable_abstract_impl_foreach_invar.simps [simp del]

definition NFA_construct_reachable_abstract_impl_step where
"NFA_construct_reachable_abstract_impl_step S D rm D0 q =
  FOREACHi 
    (NFA_construct_reachable_abstract_impl_foreach_invar S D rm D0 q)
    {(a, q') . (q, a, q') \<in> D} 
    (\<lambda>(a, q') (rm, D', N). if (a \<noteq> {}) then do {
       (rm', r') \<leftarrow> SPEC (\<lambda>(rm', r'). 
           NFA_construct_reachable_map_OK S rm {q'} rm' \<and> rm' q' = Some r');
           RETURN (rm', insert (the (rm q), a, r') D', q' # N)
     } else RETURN (rm, D', N)) (rm, D0, [])"

lemma NFA_construct_reachable_abstract_impl_step_correct :
assumes fin: "finite {(a, q'). (q, a, q') \<in> D}"
    and inj_rm: "inj_on rm (S \<inter> dom rm)"
    and q_in_dom: "q \<in> dom rm"
shows "NFA_construct_reachable_abstract_impl_step S D rm D0 q \<le>
      SPEC (NFA_construct_reachable_abstract_impl_foreach_invar S D rm D0 q {})"
unfolding NFA_construct_reachable_abstract_impl_step_def
apply (intro refine_vcg)
apply (fact fin)
apply (simp add: NFA_construct_reachable_abstract_impl_foreach_invar.simps
                 NFA_construct_reachable_map_OK_def inj_rm)
apply fastforce
apply (clarify, simp)
apply (rename_tac it a q' rm' D' N rm'' r)
defer
apply (clarify, simp)+
apply (rename_tac it q' rm' D' N)
defer
apply simp
proof -
  {
  fix it a q' rm' D' N rm'' r'
  assume in_it: "(a, q') \<in> it"
     and it_subset: "it \<subseteq> {(a, q'). (q, a, q') \<in> D}"
     and invar: "NFA_construct_reachable_abstract_impl_foreach_invar S D rm D0 q it (rm', D', N)"
     and map_OK: "NFA_construct_reachable_map_OK S rm' {q'} rm''"
     and rm''_q': "rm'' q' = Some r'"
    assume a_nempty: "a \<noteq> {}"
  from q_in_dom obtain r where rm_q: "rm q = Some r" by auto

  define D'' where " D'' = {(a, q'). (q, a, q') \<in> D \<and> a \<noteq> {}} - it"
  have D''_intro : "({(a, q'). (q, a, q') \<in> D  \<and> a \<noteq> {}} - (it - {(a, q')})) = insert (a, q') D''"
    using in_it it_subset D''_def a_nempty
    by auto
    

  from invar have
    rm'_OK: "NFA_construct_reachable_map_OK S rm (snd ` D'') rm'" and 
    set_N_eq: "set N = snd ` D''"  and 
    D'_eq: "D' = D0 \<union> {(the (rm' q), a, the (rm' q')) |a q'. (a, q') \<in> D'' }"
    unfolding NFA_construct_reachable_abstract_impl_foreach_invar.simps
    by (simp_all add: Let_def D''_def)

  have prop1: "NFA_construct_reachable_map_OK S rm (insert q' (snd ` D'')) rm''" 
    using map_OK rm'_OK
    unfolding NFA_construct_reachable_map_OK_def
    by auto

  have prop2: "insert (the (rm' q), a, r') D' =
    D0 \<union> {(the (rm'' q), aa, the (rm'' q'a)) |aa q'a. aa = a \<and> q'a = q' \<or> (aa, q'a) \<in> D''}"
    (is "?ls = D0 \<union> ?rs") 
  proof -
    from rm'_OK rm_q have rm'_q: "rm' q = Some r"
      unfolding NFA_construct_reachable_map_OK_def by simp
    with map_OK have rm''_q: "rm'' q = Some r"
      unfolding NFA_construct_reachable_map_OK_def by simp

    have step1: "?rs = insert (the (rm'' q), a, the (rm'' q')) {(the (rm'' q), a, the (rm'' q')) |a q'. (a, q') \<in> D''}"
      (is "_ = (insert _ ?rs')")
      by auto

    from rm'_OK map_OK have rm''_eq: "\<And>a q'. (a, q') \<in> D'' \<Longrightarrow> rm'' q' = rm' q'"
      unfolding NFA_construct_reachable_map_OK_def dom_def subset_iff
      by auto 

    from rm''_eq have D'_eq': "D' = D0 \<union> ?rs'" unfolding D'_eq rm'_q rm''_q by auto metis
    
    show ?thesis unfolding D'_eq' step1 by (simp add: rm'_q rm''_q rm''_q')
  qed

  show "NFA_construct_reachable_abstract_impl_foreach_invar S D rm D0 q (it - {(a, q')})
        (rm'', insert (the (rm' q), a, r') D', q' # N)" 
    unfolding NFA_construct_reachable_abstract_impl_foreach_invar.simps D''_intro
    by (simp add: Let_def set_N_eq prop1 prop2)
} 
  {
    fix it q' rm' D' N
  assume in_it: "({}, q') \<in> it"
     and it_subset: "it \<subseteq> {(a, q'). (q, a, q') \<in> D}"
     and invar: "NFA_construct_reachable_abstract_impl_foreach_invar S D rm D0 q it
        (rm', D', N)"
  from this have "NFA_construct_reachable_abstract_impl_foreach_invar S D rm D0 q
           (it - {({}, q')}) (rm', D', N)"    
    unfolding NFA_construct_reachable_abstract_impl_foreach_invar.simps
    apply (subgoal_tac "{(a, q'). (q, a, q') \<in> D \<and> a \<noteq> {}} - (it - {({}, q')}) = 
          {(a, q'). (q, a, q') \<in> D \<and> a \<noteq> {}} - it")
     apply simp
     by fastforce
   from this show "\<not> NFA_construct_reachable_abstract_impl_foreach_invar S D rm D0 q
           (it - {({}, q')}) (rm', D', N) \<Longrightarrow>
       False" by auto
 }
qed

definition NFA_construct_reachable_abstract_impl where
  "NFA_construct_reachable_abstract_impl I FP D  =
   do {
     (rm, I') \<leftarrow> SPEC (\<lambda>(rm, I'). 
        NFA_construct_reachable_map_OK (accessible (LTS_forget_labels D) (set I)) 
            Map.empty (set I) rm \<and>
        I' = (the \<circ> rm) ` (set I));
     ((rm, \<A>), _) \<leftarrow> WORKLISTIT (NFA_construct_reachable_abstract_impl_invar I FP D) 
      (\<lambda>_. True)
      (\<lambda>(rm, \<A>) q. do {
         ASSERT (q \<in> dom rm \<and> q \<in> accessible (LTS_forget_labels D) (set I) \<and>
                 NFA_construct_reachable_abstract_impl_weak_invar I FP D (rm, \<A>));
         if (the (rm q) \<in> \<Q> \<A>) then
           (RETURN ((rm, \<A>), []))
         else                    
           do {
             (rm', D', N) \<leftarrow> SPEC 
                 (NFA_construct_reachable_abstract_impl_foreach_invar 
                 (accessible (LTS_forget_labels D) (set I)) D rm (\<Delta> \<A>) q {});
             RETURN ((rm', \<lparr> \<Q>=insert (the (rm q)) (\<Q> \<A>), \<Delta> = D', 
                           \<I>=\<I> \<A>, \<F> = if (FP q) then (insert (the (rm q)) (\<F> \<A>)) else (\<F> \<A>)\<rparr>), N)
           }
        }) ((rm, \<lparr> \<Q>={}, \<Delta> = {}, \<I>=I', \<F>={} \<rparr>), I);
     RETURN \<A>
   }"

lemma NFA_construct_reachable_abstract_impl_correct :
fixes D :: "('q \<times> 'a set \<times> 'q) set" and I
defines "S \<equiv> (accessible (LTS_forget_labels D) (set I))"
assumes fin_S: "finite S"
shows "NFA_construct_reachable_abstract_impl I FP D \<le>
       SPEC (\<lambda>\<A>. NFA_isomorphic (NFA_construct_reachable (set I) FP D) 
                                (\<A>::('q2, 'a) NFA_rec))"
unfolding NFA_construct_reachable_abstract_impl_def S_def[symmetric]
apply (intro refine_vcg WORKLISTIT_rule)
apply (simp_all split: if_splits)

  apply (clarify, simp)
  apply (rename_tac rm)
  defer
  apply (clarify, simp)
  apply (rename_tac rm)
  apply (subgoal_tac "wf (inv_image (measure (\<lambda>\<A>. card S - card (\<Q> \<A>))) snd)")
  apply assumption
  defer
  apply (clarify) 
  apply (intro refine_vcg)
  apply simp
  apply (rename_tac rm' rm \<A> wl q)
  apply (intro conjI)
  defer
  defer
  defer
  apply (clarify, simp) 
  apply (rename_tac rm' rm \<A>  wl q  r)
  defer
   apply clarify 
   apply (simp split: if_splits)
   apply (rename_tac rm'' rm \<A> wl q rm' D' N r)
   apply (intro conjI)
   defer
   defer
   apply (clarify, simp)
   apply (rename_tac rm' rm \<A>)
defer
proof -
  fix rm :: "'q \<Rightarrow> 'q2 option"
  assume rm_OK: "NFA_construct_reachable_map_OK S Map.empty (set I) rm"

  thus "NFA_construct_reachable_abstract_impl_invar I FP D
           ((rm, \<lparr>\<Q> = {}, \<Delta> = {}, \<I> = (\<lambda>x. the (rm x)) ` set I, \<F> = {}\<rparr>), I)"
    unfolding NFA_construct_reachable_abstract_impl_invar_def
    apply (simp)
    apply (rule exI [where x = "{}"])
    apply (simp add: accessible_restrict_def NFA_rename_states_def S_def)
    done
next
  show "wf (inv_image (measure (\<lambda>\<A>. card S - card (\<Q> \<A>))) snd)"
    by (intro wf_inv_image wf_measure)
next 
  fix rm :: "'q \<Rightarrow> 'q2 option" and \<A>

  note reach_simp = NFA_construct_reachable_simp [OF fin_S[unfolded S_def]]
  assume "NFA_construct_reachable_abstract_impl_invar I FP D ((rm, \<A>), [])"
  thus "NFA_isomorphic (NFA_construct_reachable (set I) FP D) \<A>"
    unfolding NFA_construct_reachable_abstract_impl_invar_def
    apply (simp add: reach_simp S_def[symmetric])
    apply (rule NFA_isomorphic___NFA_rename_states)
    apply (simp add: inj_on_def NFA_construct_reachable_map_OK_def dom_def subset_iff Ball_def)
    apply (metis option.sel)
    done

next
  fix rm :: "'q \<Rightarrow> 'q2 option"
  fix \<A> q wl 
  assume invar: "NFA_construct_reachable_abstract_impl_invar I FP D ((rm, \<A>), q # wl)"

  from invar obtain s where 
    S_eq: "S = accessible_restrict (LTS_forget_labels D) s (insert q (set wl))" and
    rm_OK: "NFA_construct_reachable_map_OK S Map.empty (insert q (s \<union> set I \<union> 
            set wl \<union> {q'. \<exists>a q. q \<in> s \<and> (q, a, q') \<in> D \<and> a \<noteq> {}})) rm" and
    \<A>_eq: "\<A> = NFA_rename_states
           \<lparr>\<Q> = s, \<Delta> = {qsq \<in> D. fst qsq \<in> s \<and> (fst (snd qsq) \<noteq> {})}, 
             \<I> = set I, \<F> = {q \<in> s. FP q}\<rparr>
           (the \<circ> rm)"
    unfolding NFA_construct_reachable_abstract_impl_invar_def S_def[symmetric] 
    using Collect_cong Un_insert_left Un_insert_right case_prodD case_prodD' 
          list.simps(15)
    by smt
 
  from rm_OK show "q \<in> dom rm"
    unfolding NFA_construct_reachable_map_OK_def by simp 

  from S_eq show "q \<in> S"
    using accessible_restrict_subset_ws[of "insert q (set wl)" "LTS_forget_labels D" s]
    by simp

  from NFA_construct_reachable_abstract_impl_invar_weaken[OF invar]
  show "NFA_construct_reachable_abstract_impl_weak_invar I  FP D (rm, \<A>)" by simp


next
  fix rm :: "'q \<Rightarrow> 'q2 option" and \<A> q wl r

  assume invar: "NFA_construct_reachable_abstract_impl_invar I FP D ((rm, \<A>), q # wl)" and
         rm_q_eq: "rm q = Some r" and
         rm_q: "r \<in> \<Q> \<A>" and
         q_in_S: "q \<in> S"

  show "NFA_construct_reachable_abstract_impl_invar I FP D ((rm, \<A>), wl)"
  proof -
    from invar obtain s where 
      rm_OK: "NFA_construct_reachable_map_OK S Map.empty (insert q (s \<union> set I \<union> 
              set wl \<union> {q'. \<exists>a q. q \<in> s \<and> (q, a, q') \<in> D \<and> a \<noteq> {}})) rm" and
      S_eq: "S = accessible_restrict (LTS_forget_labels D) s (insert q (set wl))" and
      \<A>_eq: "\<A> = NFA_rename_states 
        \<lparr>\<Q> = s, \<Delta> = {qsq. qsq \<in> D \<and> fst qsq \<in> s \<and> (fst (snd qsq) \<noteq> {})}, 
         \<I> = set I,
         \<F> = {q \<in> s. FP q}\<rparr> (the \<circ> rm)" 
      unfolding NFA_construct_reachable_abstract_impl_invar_def S_def[symmetric] 
      by (smt Collect_cong Un_insert_left Un_insert_right case_prodD case_prodD' list.simps(15))
    from S_eq have s_subset: "s \<subseteq> S" unfolding accessible_restrict_def by simp

    from rm_q \<A>_eq have "r \<in> (the \<circ> rm) ` s" by simp
    with rm_OK rm_q_eq q_in_S s_subset have "q \<in> s"
      unfolding NFA_construct_reachable_map_OK_def
      apply (simp add: image_iff Bex_def dom_def subset_iff inj_on_def Ball_def)
      apply (metis option.sel)
    done

  from `q \<in> s` have "insert q (s \<union> set I \<union> set wl \<union> 
              {q'. \<exists>a q. q \<in> s \<and> (q, a, q') \<in> D \<and> a \<noteq> {}}) = 
                       s \<union>  set I \<union> set wl \<union> {q'. \<exists>a q. q \<in> s \<and> (q, a, q') \<in> D \<and> a \<noteq> {}}" 
                by auto
    with `q \<in> s` rm_OK s_subset show ?thesis
      unfolding NFA_construct_reachable_abstract_impl_invar_def S_def[symmetric]
      apply simp
      apply (rule exI[where x = s])
      apply (simp add: \<A>_eq S_eq accessible_restrict_insert_in)
      by (smt Collect_cong)
  qed

next


  fix rm :: "'q \<Rightarrow> 'q2 option"
  fix rm'' :: "'q \<Rightarrow> 'q2 option"
  fix \<A> q wl rm' D' N r
  assume invar: "NFA_construct_reachable_abstract_impl_invar I FP D ((rm, \<A>), q # wl)"
     and rm_q_eq: "rm q = Some r" 
     and nin_Q: "r \<notin> \<Q> \<A>"
     and q_in_S: "q \<in> S"
  assume foreach_invar: 
      "NFA_construct_reachable_abstract_impl_foreach_invar 
        S D rm (\<Delta> \<A>) q {} (rm', D', N)"

  from rm_q_eq have r_eq: "r = the (rm q)" by simp

  from invar obtain s where 
     S_eq: "S = accessible_restrict (LTS_forget_labels D) s (insert q (set wl))" and
     rm_OK: "NFA_construct_reachable_map_OK S Map.empty 
          (insert q (s \<union> set I \<union> set wl \<union> {q'. \<exists>a q. q \<in> s \<and>a \<noteq> {} \<and> (q, a, q') \<in> D})) rm" 
            and
     \<A>_eq: "\<A> = NFA_rename_states 
        \<lparr>\<Q> = s, \<Delta> = {qsq. qsq \<in> D \<and> fst qsq \<in> s \<and> (fst (snd qsq) \<noteq> {})}, \<I> = set I,
         \<F> = {q \<in> s. FP q}\<rparr> (the \<circ> rm)" 
    unfolding NFA_construct_reachable_abstract_impl_invar_def S_def[symmetric] 
      by auto

   define D''  where "D'' = {(a, q'). (q, a, q') \<in> D \<and> a \<noteq> {}}" 
  from foreach_invar have 
    rm'_OK: "NFA_construct_reachable_map_OK S rm (snd ` D'') rm'" and 
    set_N_eq: "set N = snd ` D''"  and 
    D'_eq: "D' = \<Delta> \<A> \<union> {(the (rm' q), a, the (rm' q')) |a q'. (a, q') \<in> D'' \<and> a \<noteq> {}}"
    unfolding NFA_construct_reachable_abstract_impl_foreach_invar.simps
    apply (simp_all add: Let_def D''_def)
    done
  define DD where " DD = 
    insert q (s \<union> set I \<union> set wl \<union> {q'. \<exists>a q. q \<in> s \<and> a \<noteq> {} \<and> (q, a, q') \<in> D})"
  have DD_intro: "(insert q
       (s \<union> set I \<union> (set N \<union> set wl) \<union> 
       {q'. \<exists>a qa. (qa = q \<or> qa \<in> s) \<and> (qa, a, q') \<in> D \<and> a \<noteq> {}})) = DD \<union> snd ` D''"  
    unfolding DD_def by (auto simp add: image_iff set_N_eq D''_def)

  from nin_Q \<A>_eq have q_nin_s: "q \<notin> s" by (auto simp add: image_iff r_eq)

  have "(set wl \<union> {y. (q, y) \<in> LTS_forget_labels D}) = set N \<union> set wl"
    unfolding set_N_eq D''_def LTS_forget_labels_def 
    apply (auto simp add: image_iff)
    done
  hence prop1: "S = accessible_restrict (LTS_forget_labels D) (insert q s) (set N \<union> set wl)"
     by (simp add: S_eq accessible_restrict_insert_nin q_nin_s)

  have prop2: "NFA_construct_reachable_map_OK S Map.empty
     (insert q  (s \<union> set I \<union> (set N \<union> set wl) \<union> 
   {q'. \<exists>a qa. (qa = q \<or> qa \<in> s) \<and> (qa, a, q') \<in> D \<and> a \<noteq> {}} )) rm'" 
    unfolding DD_intro NFA_construct_reachable_map_OK_def
  proof (intro conjI allI impI Un_least)
    from rm'_OK show "snd ` D'' \<subseteq> dom rm'" "inj_on rm' (S \<inter> dom rm')"
      unfolding NFA_construct_reachable_map_OK_def by simp_all
  next
    from rm_OK have "DD \<subseteq> dom rm"
      unfolding NFA_construct_reachable_map_OK_def DD_def[symmetric] by simp
    moreover from rm'_OK have "dom rm \<subseteq> dom rm'"
      unfolding NFA_construct_reachable_map_OK_def dom_def by auto
    finally show "DD \<subseteq> dom rm'" .
  qed simp

  from rm'_OK have "\<And>q. q \<in> dom rm \<Longrightarrow> rm' q = rm q" 
    unfolding NFA_construct_reachable_map_OK_def
    by (simp add: dom_def) metis
  with rm_OK have rm'_eq: "\<And>q'. q' \<in> DD \<Longrightarrow> rm' q' = rm q'" 
    unfolding NFA_construct_reachable_map_OK_def DD_def[symmetric]
    by (simp add: subset_iff)

  have prop3: " 
    \<lparr>\<Q> = insert r (\<Q> \<A>),  \<Delta> = D', \<I> = \<I> \<A>,
       \<F> = if FP q then insert (the (rm q)) (\<F> \<A>) else \<F> \<A>\<rparr> =
    NFA_rename_states
     \<lparr>\<Q> = insert q s,  \<Delta> = {qsq \<in> D. (fst qsq = q \<or> fst qsq \<in> s) 
        \<and> (fst (snd qsq) \<noteq> {})}, \<I> = set I,
        \<F> = {qa. (qa = q \<or> qa \<in> s) \<and> FP qa}\<rparr>
     (the \<circ> rm')" 
  proof -
    from DD_def have "set I \<subseteq> DD" unfolding DD_def by auto
    with rm'_eq have rm'_eq_I: "(the \<circ> rm) ` set I = (the \<circ> rm') ` set I" 
      apply (rule_tac set_eqI)
      apply (auto simp add: image_iff Bex_def subset_iff)
    done

    from DD_def have "insert q s \<subseteq> DD" unfolding DD_def by auto
    with rm'_eq have rm'_eq_Q: 
      "insert r ((the \<circ> rm) ` s) = insert (the (rm' q)) ((the \<circ> rm') ` s)"
      apply (rule_tac set_eqI)
      apply (auto simp add: image_iff Bex_def subset_iff r_eq)
      done


  have D'_eq' : "D' = {(the (rm' s1), a, the (rm' s2)) 
        |s1 a s2. (s1, a, s2) \<in> D \<and> a \<noteq> {} \<and> (s1 = q \<or> s1 \<in> s)}"    
       (is "_ = ?ls")
    proof -
      have "?ls = {(the (rm' s1), a, the (rm' s2)) |s1 a s2. (s1, a, s2) \<in> D \<and> 
                    a \<noteq> {} \<and> s1 \<in> s} \<union>
                  {(the (rm' q), a, the (rm' q')) |a q'. (a, q') \<in> D'' \<and> a \<noteq> {}}"
           (is "_ = ?ls' \<union> _")
        unfolding D''_def 
        apply auto
         apply blast
        apply blast
        done
      moreover
        from rm'_eq have "?ls' = \<Delta> \<A>" unfolding \<A>_eq DD_def
          apply (auto simp add: NFA_rename_states_def) 
           apply (metis empty_iff)
            by (metis empty_iff)
          finally show ?thesis 
            apply (simp add: D'_eq)
            done
        qed


    from rm'_eq have rm'_eq_F: 
      "(if FP q then insert (the (rm q)) (\<F> \<A>) else \<F> \<A>) =
        (the \<circ> rm') ` {qa. (qa = q \<or> qa \<in> s) \<and> FP qa}" 
      apply (rule_tac set_eqI)
      apply (simp add: image_iff \<A>_eq DD_def)
      apply (metis) 
    done

  show ?thesis 
    apply (simp add: NFA_rename_states_def \<A>_eq rm'_eq_F rm'_eq_I rm'_eq_Q D'_eq')
    apply auto
    using \<open>insert q s \<subseteq> DD\<close> r_eq rm'_eq apply auto[1]
    using \<open>insert q s \<subseteq> DD\<close> rm'_eq apply force
    using \<open>insert q s \<subseteq> DD\<close> r_eq rm'_eq apply auto[1]
    using \<open>insert q s \<subseteq> DD\<close> rm'_eq apply auto[1]
    using rm'_eq_I apply auto[1]
    using \<open>set I \<subseteq> DD\<close> rm'_eq by auto
qed 
  

  from S_eq have s_subset: "s \<subseteq> S" unfolding accessible_restrict_def by simp

  
  have conclude1: "NFA_construct_reachable_abstract_impl_invar I FP D
        ((rm',\<lparr>\<Q> = insert r (\<Q> \<A>),  \<Delta> = D', \<I> = \<I> \<A>,
             \<F> = if FP q then insert (the (rm q)) (\<F> \<A>) else \<F> \<A>\<rparr>), N @ wl)"
    unfolding NFA_construct_reachable_abstract_impl_invar_def S_def[symmetric]
    apply (simp split del: if_splits)
    apply (rule exI [where x = "insert q s"])
    apply (simp split del: if_splits add: q_in_S)
    apply (simp add: prop3 prop2)
    apply (simp add: prop1)
    using Collect_cong prop1 prop2
    by smt


  from S_eq have s_subset: "s \<subseteq> S" unfolding accessible_restrict_def by simp
  with fin_S have fin_s: "finite s" by (metis finite_subset)

  from \<A>_eq fin_s nin_Q have fin_Q: "finite (\<Q> \<A>)" and card_Q_le': "card (\<Q> \<A>) \<le> card s"
    unfolding NFA_rename_states_def by (simp_all add: card_image_le image_iff r_eq) 

  
  from S_eq s_subset accessible_restrict_subset_ws[of "(insert q (set wl))" "LTS_forget_labels D" s] 
  have "insert q s \<subseteq> S" unfolding accessible_restrict_def by simp 
  hence "card (insert q s) \<le> card S" by (rule card_mono[OF fin_S])
  hence "card s < card S" by (simp add: q_nin_s fin_s)
  with card_Q_le' have card_Q_le: "card (\<Q> \<A>) < card S" by simp

  hence "card S - card (insert r (\<Q> \<A>)) < card S - card (\<Q> \<A>)" 
    by (simp add: nin_Q fin_Q)
  
  have "card S - card (insert r (\<Q> \<A>)) < card S - card (\<Q> \<A>) \<or>
       rm' = rm \<and> \<lparr>\<Q> = insert r (\<Q> \<A>),  \<Delta> = D', \<I> = \<I> \<A>,
          \<F> = if FP q then insert (the (rm q)) (\<F> \<A>) else \<F> \<A>\<rparr> = \<A> \<and> N = []" 
    using \<open>card S - card (insert r (\<Q> \<A>)) < card S - card (\<Q> \<A>)\<close> apply blast
    done

  show "FP q \<longrightarrow> NFA_construct_reachable_abstract_impl_invar I FP D
        ((rm', \<lparr>\<Q> = insert r (\<Q> \<A>),  \<Delta> = D', \<I> = \<I> \<A>, \<F> = insert r (\<F> \<A>)\<rparr>),
         N @ wl) \<and>
       (card S - card (insert r (\<Q> \<A>)) < card S - card (\<Q> \<A>) \<or>
        rm' = rm \<and>
        \<lparr>\<Q> = insert r (\<Q> \<A>),  \<Delta> = D', \<I> = \<I> \<A>, \<F> = insert r (\<F> \<A>)\<rparr> = \<A> \<and> N = [])"
 using \<open>card S - card (insert r (\<Q> \<A>)) < card S - card (\<Q> \<A>)\<close> conclude1 r_eq by auto

  show "\<not> FP q \<longrightarrow>
       NFA_construct_reachable_abstract_impl_invar I FP D
        ((rm', \<lparr>\<Q> = insert r (\<Q> \<A>), \<Delta> = D', \<I> = \<I> \<A>, \<F> = \<F> \<A>\<rparr>), N @ wl) \<and>
       (card S - card (insert r (\<Q> \<A>)) < card S - card (\<Q> \<A>) \<or>
        rm' = rm \<and> \<lparr>\<Q> = insert r (\<Q> \<A>), \<Delta> = D', \<I> = \<I> \<A>, \<F> = \<F> \<A>\<rparr> = \<A> \<and> N = [])"
    using \<open>card S - card (insert r (\<Q> \<A>)) < card S - card (\<Q> \<A>)\<close> conclude1 by auto
  
qed


definition NFA_construct_reachable_abstract2_impl where
  "NFA_construct_reachable_abstract2_impl I FP D  =
   do {
     (rm, I') \<leftarrow> SPEC (\<lambda>(rm, I'). 
        NFA_construct_reachable_map_OK 
          (accessible (LTS_forget_labels D) (set I)) Map.empty (set I) rm \<and>
        I' = (the \<circ> rm) ` (set I));
     ((rm, \<A>), _) \<leftarrow> WORKLISTIT 
        (NFA_construct_reachable_abstract_impl_invar I  FP D) 
      (\<lambda>_. True)
      (\<lambda>(rm, \<A>) q. do {
         ASSERT (q \<in> dom rm \<and> q \<in> accessible (LTS_forget_labels D) (set I) \<and>
                 NFA_construct_reachable_abstract_impl_weak_invar I FP D (rm, \<A>));
         if (the (rm q) \<in> \<Q> \<A>) then
           (RETURN ((rm, \<A>), []))
         else                    
           do {
             (rm', D', N) \<leftarrow> NFA_construct_reachable_abstract_impl_step 
                 (accessible (LTS_forget_labels D) (set I)) D rm (\<Delta> \<A>) q;
             RETURN ((rm', \<lparr> \<Q>=insert (the (rm q)) (\<Q> \<A>), \<Delta> = D', 
                           \<I>=\<I> \<A>, \<F> = if (FP q) 
               then (insert (the (rm q)) (\<F> \<A>)) else (\<F> \<A>)\<rparr>), N)
           }
        }) ((rm, \<lparr> \<Q>={},  \<Delta> = {}, \<I>=I', \<F>={} \<rparr>), I);
     RETURN \<A>
   }"

lemma NFA_construct_reachable_abstract2_impl_correct :
fixes D :: "('q \<times> 'a set \<times> 'q) set" and I
defines "S \<equiv> accessible (LTS_forget_labels D) (set I)"
assumes fin_S: "finite S"
    and fin_D: "\<And>q. finite {(a, q'). (q, a, q') \<in> D}"
  shows "NFA_construct_reachable_abstract2_impl I FP D  
           \<le> \<Down>Id ((NFA_construct_reachable_abstract_impl I FP D)::('q2, 'a) NFA_rec nres)"
unfolding NFA_construct_reachable_abstract2_impl_def NFA_construct_reachable_abstract_impl_def S_def[symmetric]
apply refine_rcg
apply (simp)
apply (rule single_valued_Id)
apply (rule single_valued_Id)
apply (simp)
apply (simp_all add: list_all2_eq[symmetric])
apply blast
apply (clarify, simp)+
apply (rename_tac q rm \<A> r)
apply (rule NFA_construct_reachable_abstract_impl_step_correct)
proof -
  fix rm :: "'q \<Rightarrow> 'q2 option" and q r
  assume "rm q = Some r" thus "q \<in> dom rm" by blast
next
  fix rm :: "'q \<Rightarrow> 'q2 option" and
      \<A> :: "('q2, 'a) NFA_rec" 

  assume "NFA_construct_reachable_abstract_impl_weak_invar I FP D (rm, \<A>)"
  thus "inj_on rm (S \<inter> dom rm)" 
     unfolding NFA_construct_reachable_abstract_impl_weak_invar_def 
               NFA_construct_reachable_map_OK_def S_def[symmetric] by auto
next
  fix q
  have rewr: "{(a, q'). (q, a, q') \<in> D}  = 
        (\<lambda>(q, a, q'). (a, q')) ` {qsq. qsq \<in> D \<and> fst qsq = q}" 
    apply (simp add: image_iff)
    apply auto
    by (simp add: image_iff)
  show "finite {(a, q'). (q, a, q') \<in> D }" 
    by (rule fin_D)
qed

subsection \<open> Constructing reachable automata with products \<close>


fun NFA_construct_reachable_abstract_impl_foreach_invar_prod where
  "NFA_construct_reachable_abstract_impl_foreach_invar_prod 
    S D rm D0 q it (rm', D', N) =
    (let D'' = {((a1, a2), q') . (q, (a1, a2), q') \<in> D \<and> a1 \<inter> a2 \<noteq> {}} - it; 
     qS = snd ` D'' in
    (NFA_construct_reachable_map_OK S rm qS rm' \<and>
     set N = qS \<and>
     D' = D0 \<union> {(the (rm' q), (a1 \<inter> a2), the (rm' q')) | 
                 a1 a2 q'. ((a1,a2), q') \<in> D''}))"

declare NFA_construct_reachable_abstract_impl_foreach_invar_prod.simps [simp del]

definition NFA_construct_reachable_abstract_impl_step_prod where
 "NFA_construct_reachable_abstract_impl_step_prod S D rm D0 q =
  FOREACHi 
    (NFA_construct_reachable_abstract_impl_foreach_invar_prod S D rm D0 q)
    {(a , q') . (q, a, q') \<in> D} 
    (\<lambda>(a, q') (rm, D', N). if (fst a \<inter> snd a \<noteq> {}) then do {
       (rm', r') \<leftarrow> SPEC (\<lambda>(rm', r'). 
           NFA_construct_reachable_map_OK S rm {q'} rm' \<and> rm' q' = Some r');
           RETURN (rm', insert (the (rm q), fst a \<inter> snd a, r') D', q' # N)
     } else RETURN (rm, D',N)) (rm, D0, [])"

lemma NFA_construct_reachable_abstract_impl_step_prod_correct :
assumes fin: "finite {(a, q').(q, a, q') \<in> D }"
    and inj_rm: "inj_on rm (S \<inter> dom rm)"
    and q_in_dom: "q \<in> dom rm"
shows "NFA_construct_reachable_abstract_impl_step_prod S D rm D0 q \<le>
      SPEC (NFA_construct_reachable_abstract_impl_foreach_invar_prod S D rm D0 q {})"
unfolding NFA_construct_reachable_abstract_impl_step_prod_def
apply (intro refine_vcg)
apply (fact fin)
apply (simp add: NFA_construct_reachable_abstract_impl_foreach_invar_prod.simps
                 NFA_construct_reachable_map_OK_def inj_rm)
apply (fastforce)
defer defer
apply simp
apply (clarify, simp)
apply (rename_tac it a1 a2 q' rm' D' N rm'' r')
defer
  apply (simp)+
  apply (clarify)
  apply simp
  apply (rename_tac it a1 a2 q' rm' D' N)
  defer
proof -
  {
  fix it a1 a2 q' rm' D' N rm'' r'
  assume in_it: "((a1,a2), q') \<in> it"
     and it_subset: "it \<subseteq> {(a, q'). (q, a, q') \<in> D}"
     and invar: "NFA_construct_reachable_abstract_impl_foreach_invar_prod 
                  S D rm D0 q it (rm', D', N)"
     and map_OK: "NFA_construct_reachable_map_OK S rm' {q'} rm''"
     and rm''_q': "rm'' q' = Some r'"
  from q_in_dom obtain r where rm_q: "rm q = Some r" by auto

  define D'' where " D'' = {(a, q'). (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}} - it"

  have D''_intro : "a1 \<inter> a2 \<noteq> {} \<Longrightarrow> ({(a, q'). (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}} 
                     - (it - {((a1,a2), q')})) = insert ((a1,a2), q') D''"
    using in_it it_subset D''_def 
    apply simp
    by auto
   
  from invar have
    rm'_OK: "NFA_construct_reachable_map_OK S rm (snd ` D'') rm'" and 
    set_N_eq: "set N = snd ` D''"  and 
    D'_eq: "D' = D0 \<union> {(the (rm' q), 
                 fst a \<inter> snd a, 
                the (rm' q')) |a q'. (a, q') \<in> D'' }"
    unfolding NFA_construct_reachable_abstract_impl_foreach_invar_prod.simps
    defer
    apply (simp_all add: Let_def D''_def)
    apply (subgoal_tac "{((a1, a2), q'). (q, (a1, a2), q') \<in> D } = 
                        {(a, q'). (q, a, q') \<in> D}")
      apply (fastforce)
    apply blast
    apply (subgoal_tac "{((a1, a2), q'). (q, (a1, a2), q') \<in> D \<and> a1 \<inter> a2 \<noteq> {}} = 
                        {(a, q'). (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}}")
    apply simp
    by (fastforce)

  have prop1: "NFA_construct_reachable_map_OK S rm (insert q' (snd ` D'')) rm''" 
    using map_OK rm'_OK
    unfolding NFA_construct_reachable_map_OK_def
    by auto

   from rm'_OK map_OK have rm''_eq: "\<And>a q'. (a, q') \<in> D'' \<Longrightarrow> rm'' q' = rm' q'"
      unfolding NFA_construct_reachable_map_OK_def dom_def subset_iff
      by auto 

   from rm'_OK rm_q have rm'_q: "rm' q = Some r"
      unfolding NFA_construct_reachable_map_OK_def by simp
    with map_OK have rm''_q: "rm'' q = Some r"
      unfolding NFA_construct_reachable_map_OK_def by simp
    from this have dom_q: "q \<in> dom(rm'')" by blast

    from rm'_q rm''_q have rm'_eq_rm''_q : "rm' q = rm'' q" 
        by fastforce

  have prop2: "insert (the (rm' q), (a1 \<inter> a2), r') D' =
    D0 \<union> {(the (rm'' q), fst aa \<inter> snd aa, the (rm'' q'a)) |
         aa q'a.  aa = (a1, a2) \<and> q'a = q' \<or> ((aa, q'a) \<in> D'')}"
    (is "?ls = D0 \<union> ?rs") 
  proof -
    have step1: "?rs = insert (the (rm'' q), (a1 \<inter> a2), 
    the (rm'' q')) {(the (rm'' q), a1 \<inter> a2, the (rm'' q')) 
          |a1 a2 q'. ((a1,a2), q') \<in> D''}"
      (is "_ = (insert _ ?rs')")
      apply (simp)
      apply (simp only: insert_compr)
      by blast
    from rm''_eq D'_eq have D'_eq': "D' = D0 \<union> ?rs'" unfolding D'_eq rm'_q rm''_q 
      apply simp
      by (metis (mono_tags, hide_lams))
    
    show ?thesis unfolding D'_eq' step1 by (simp add: rm'_q rm''_q rm''_q')
  qed
  assume "a1 \<inter> a2 \<noteq> {}"
  from this D''_intro 
  show con1: " 
        NFA_construct_reachable_abstract_impl_foreach_invar_prod S D rm D0 q 
        (it - {((a1, a2), q')})
        (rm'', insert (the (rm' q), a1 \<inter> a2, r') D', q' # N)" 
    unfolding NFA_construct_reachable_abstract_impl_foreach_invar_prod.simps 
    apply (simp add: set_N_eq prop1 prop2)
    apply (insert prop1)
    apply (simp add: D''_def)
    apply (rule conjI)
    apply (smt Collect_cong D''_intro image_insert prod.case_eq_if prod.collapse snd_conv)
    apply (subgoal_tac "\<And> a b q1. a = a1 \<and> b = a2 \<and> q1 = q' \<or>
     (q, (a, b), q1) \<in> D \<and> a \<inter> b \<noteq> {} \<and> ((a, b), q1) \<notin> it \<longleftrightarrow>
       (q, (a, b), q1) \<in> D \<and> a \<inter> b \<noteq> {} \<and> (((a, b), q1) \<in> it \<longrightarrow> b = a2 \<and> a = a1 \<and> q1 = q') 
       ")
    apply simp
    apply (simp only: insert_def)
    apply (subgoal_tac "{((a1, a2), q'). (q, (a1, a2), q') \<in> D \<and> a1 \<inter> a2 \<noteq> {}} -
     (it - ({x. x = ((a1, a2), q')} \<union> {})) = 
     ({((a1, a2), q'). (q, (a1, a2), q') \<in> D \<and> a1 \<inter> a2 \<noteq> {}} - it)
     \<union> {x. x = ((a1, a2), q')} \<union> {}")
    apply simp_all
    apply (subgoal_tac "{((a1, a2), q'). (q, (a1, a2), q') \<in> D \<and> a1 \<inter> a2 \<noteq> {}} = 
                        {(a, q'). (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}}")
       apply simp
    by auto
}
  {
    fix it a1 a2 q' rm' D' N
     assume in_it: "((a1, a2), q') \<in> it"
     and it_subset: "it \<subseteq> {(a, q'). (q, a, q') \<in> D}"
     and invar: "NFA_construct_reachable_abstract_impl_foreach_invar_prod 
                  S D rm D0 q it (rm', D', N)"
     and a1_a2_empty: "a1 \<inter> a2 = {}"
     show "NFA_construct_reachable_abstract_impl_foreach_invar_prod S D rm D0 q
        (it - {((a1, a2), q')}) (rm', D', N)"
     apply (insert invar in_it it_subset a1_a2_empty)
     unfolding NFA_construct_reachable_abstract_impl_foreach_invar_prod.simps
     apply (simp)
     apply (rule conjI)+
     apply (subgoal_tac 
       "{((a1, a2), q'). (q, (a1, a2), q') \<in> D \<and> a1 \<inter> a2 \<noteq> {}} - it = 
        {((a1, a2), q'). (q, (a1, a2), q') \<in> D \<and> a1 \<inter> a2 \<noteq> {}} -
         (it - {((a1, a2), q')})")
     apply simp
     apply fastforce
     apply (rule conjI)
     apply fastforce
     by blast
}

qed

definition NFA_construct_reachable_abstract_impl_prod where
  "NFA_construct_reachable_abstract_impl_prod I FP D  =
   do {
     (rm, I') \<leftarrow> SPEC (\<lambda>(rm, I'). 
        NFA_construct_reachable_map_OK (accessible (LTS_forget_labels 
          {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) (set I)) 
            Map.empty (set I) rm \<and>
        I' = (the \<circ> rm) ` (set I));
     ((rm, \<A>), _) \<leftarrow> 
        WORKLISTIT (NFA_construct_reachable_abstract_impl_invar I FP 
         {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) 
      (\<lambda>_. True)
      (\<lambda>(rm, \<A>) q. do {
         ASSERT (q \<in> dom rm \<and> q \<in> accessible (LTS_forget_labels 
          {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) (set I) \<and>
                 NFA_construct_reachable_abstract_impl_weak_invar I FP  
                  {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D} (rm, \<A>));
         if (the (rm q) \<in> \<Q> \<A>) then
           (RETURN ((rm, \<A>), []))
         else                    
           do {
             (rm', D', N) \<leftarrow> SPEC 
                 (NFA_construct_reachable_abstract_impl_foreach_invar_prod 
                 (accessible (LTS_forget_labels 
                   {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) (set I)) D rm (\<Delta> \<A>) q {});
             RETURN ((rm', \<lparr> \<Q>=insert (the (rm q)) (\<Q> \<A>), \<Delta> = D', 
                           \<I>=\<I> \<A>, \<F> = if (FP q) then (insert (the (rm q)) (\<F> \<A>)) else (\<F> \<A>)\<rparr>), N)
           }
        }) ((rm, \<lparr> \<Q>={},  \<Delta> = {}, \<I>=I', \<F>={} \<rparr>), I);
     RETURN \<A>
   }"

lemma NFA_construct_reachable_abstract_impl_prod_correct :
fixes D :: "('q \<times> ('a set \<times> 'a set) \<times> 'q) set" and I
defines "S \<equiv> (accessible (LTS_forget_labels 
        {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) (set I))"
assumes fin_S: "finite S"
shows "NFA_construct_reachable_abstract_impl_prod I FP D \<le>
       SPEC (\<lambda>\<A>. NFA_isomorphic (NFA_construct_reachable (set I) FP 
          {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) 
                                (\<A>::('q2, 'a) NFA_rec))"
unfolding NFA_construct_reachable_abstract_impl_prod_def S_def[symmetric]
apply (intro refine_vcg WORKLISTIT_rule)
apply (simp_all split: if_splits)

  apply (clarify, simp)
  apply (rename_tac rm)
  defer
  apply (clarify, simp)
  apply (rename_tac rm)
  apply (subgoal_tac "wf (inv_image (measure (\<lambda>\<A>. card S - card (\<Q> \<A>))) snd)")
  apply assumption
  defer
  apply (clarify) 
  apply (intro refine_vcg)
  apply simp
  apply (rename_tac rm' rm \<A> wl q)
  apply (intro conjI)
  defer
  defer
  defer
  apply (clarify, simp) 
  apply (rename_tac rm' rm \<A>  wl q  r)
  defer
   apply clarify 
   apply (simp split: if_splits)
   apply (rename_tac rm'' rm \<A> wl q rm' D' N r)
   apply (intro conjI)
   defer
   defer
   apply (clarify, simp)
   apply (rename_tac rm' rm \<A>)
defer
proof -
  fix rm :: "'q \<Rightarrow> 'q2 option"
  assume rm_OK: "NFA_construct_reachable_map_OK S Map.empty (set I) rm"

  thus "NFA_construct_reachable_abstract_impl_invar I FP  
        {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}
           ((rm, \<lparr>\<Q> = {}, \<Delta> = {}, \<I> = (\<lambda>x. the (rm x)) ` set I, \<F> = {}\<rparr>), I)"
    unfolding NFA_construct_reachable_abstract_impl_invar_def
    apply (simp)
    apply (rule exI [where x = "{}"])
    apply (simp add: accessible_restrict_def NFA_rename_states_def S_def)
    done
next
  show "wf (inv_image (measure (\<lambda>\<A>. card S - card (\<Q> \<A>))) snd)"
    by (intro wf_inv_image wf_measure)
next 
  fix rm :: "'q \<Rightarrow> 'q2 option" and \<A>

  note reach_simp = NFA_construct_reachable_simp [OF fin_S[unfolded S_def]]
  assume "NFA_construct_reachable_abstract_impl_invar I FP 
           {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D} ((rm, \<A>), [])"
  thus "NFA_isomorphic (NFA_construct_reachable (set I) FP 
         {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) \<A>"
    unfolding NFA_construct_reachable_abstract_impl_invar_def
    apply (simp add: reach_simp S_def[symmetric])
    apply (rule NFA_isomorphic___NFA_rename_states)
    apply (simp add: inj_on_def NFA_construct_reachable_map_OK_def dom_def subset_iff Ball_def)
    apply (metis option.sel)
    done

next
  fix rm :: "'q \<Rightarrow> 'q2 option"
  fix \<A> q wl 
  assume invar: "NFA_construct_reachable_abstract_impl_invar I FP
        {(q, a1 \<inter> a2, q') |q a1 a2 q'. (q, (a1, a2), q') \<in> D} ((rm, \<A>), q # wl)"
  from invar have invar1: 
     "NFA_construct_reachable_abstract_impl_invar 
                 I FP  {(q,fst a \<inter> snd a, q')|q a q'. (q, a, q') \<in> D}
                 ((rm, \<A>), q # wl)"
    by auto
  from invar1 obtain s where 
    S_eq: "S = accessible_restrict (LTS_forget_labels  
              {(q, a \<inter> b, q') |q a b q'. (q, (a, b), q') \<in> D})
                s (insert q (set wl))" and
    rm_OK: "NFA_construct_reachable_map_OK S Map.empty (insert q (s \<union> set I \<union> 
            set wl \<union> {q'. \<exists> a q. q \<in> s \<and> (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}})) rm" 
            and
    \<A>_eq: "\<A> = NFA_rename_states
           \<lparr>\<Q> = s, \<Delta> = {qsq.
                   (\<exists>q a b q'. qsq = (q, a \<inter> b, q') \<and> (q, (a, b), q') \<in> D) \<and>
                   fst qsq \<in> s \<and> fst (snd qsq) \<noteq> {}}, 
             \<I> = set I, \<F> = {q \<in> s. FP q}\<rparr>
           (the \<circ> rm)"
    unfolding NFA_construct_reachable_abstract_impl_invar_def S_def[symmetric]           
    apply (simp add: if_split accessible_restrict_def)
    apply (subgoal_tac "\<And>s.{q'. \<exists>a b q. q \<in> s \<and> (q, (a, b), q') \<in> D \<and> a \<inter> b \<noteq> {}} = 
                {q'. \<exists>a q. q \<in> s \<and> a \<noteq> {} \<and> (\<exists>aa b. a = aa \<inter> b \<and> (q, (aa, b), q') \<in> D)}")
     apply simp
    using S_def apply fastforce
    by (metis (no_types, lifting) Collect_cong)
   
    
  from rm_OK show "q \<in> dom rm"
    unfolding NFA_construct_reachable_map_OK_def by simp 

  from S_eq show "q \<in> S"
    using accessible_restrict_subset_ws[of "insert q (set wl)" 
          "LTS_forget_labels {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}" s]
    by simp

  from NFA_construct_reachable_abstract_impl_invar_weaken[OF invar]
  show "NFA_construct_reachable_abstract_impl_weak_invar 
        I FP  {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D} (rm, \<A>)" by simp

next
  fix rm :: "'q \<Rightarrow> 'q2 option" and \<A> q wl r

  assume invar: "NFA_construct_reachable_abstract_impl_invar 
                 I FP  {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D} 
                 ((rm, \<A>), q # wl)" and
         rm_q_eq: "rm q = Some r" and
         rm_q: "r \<in> \<Q> \<A>" and
         q_in_S: "q \<in> S"

  from invar have invar1: 
     "NFA_construct_reachable_abstract_impl_invar 
                 I FP  {(q,fst a \<inter> snd a, q')|q a q'. (q, a, q') \<in> D}
                 ((rm, \<A>), q # wl)" by auto

  show "NFA_construct_reachable_abstract_impl_invar I FP  
        {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}
       ((rm, \<A>), wl)"
  proof -
    from invar1 obtain s where 
      rm_OK: "NFA_construct_reachable_map_OK S Map.empty (insert q (s \<union> set I \<union> 
              set wl \<union> {q'. \<exists>a q. q \<in> s \<and> (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}})) rm" 
              and
      S_eq: "S = accessible_restrict (LTS_forget_labels 
             {(q, fst a \<inter> snd a, q')|q a q'. (q, a, q') \<in> D}) 
             s (insert q (set wl))" and
      \<A>_eq: "\<A> = NFA_rename_states 
        \<lparr>\<Q> = s, \<Delta> = {qsq.
                   (\<exists>q a b q'. qsq = (q, a \<inter> b, q') \<and> (q, (a, b), q') \<in> D) \<and>
                   fst qsq \<in> s \<and> fst (snd qsq) \<noteq> {}}, 
         \<I> = set I,
         \<F> = {q \<in> s. FP q}\<rparr> (the \<circ> rm)" 
      unfolding NFA_construct_reachable_abstract_impl_invar_def S_def[symmetric] 
      apply (simp add: if_split)
      by (smt Collect_cong S_def)
      
      
      from S_eq have s_subset: "s \<subseteq> S" unfolding accessible_restrict_def by simp
      
    from rm_q \<A>_eq have "r \<in> (the \<circ> rm) ` s" by simp
    with rm_OK rm_q_eq q_in_S s_subset have "q \<in> s"
      unfolding NFA_construct_reachable_map_OK_def
      apply (simp add: image_iff Bex_def dom_def subset_iff inj_on_def Ball_def)
      apply (metis option.sel)
    done

  from `q \<in> s` have "insert q (s \<union> set I \<union> set wl \<union> 
              {q'. \<exists>a q. q \<in> s \<and> (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}}) = 
                       s \<union>  set I \<union> set wl \<union> {q'. \<exists>a q. q \<in> s \<and> (q, a, q') \<in> D 
               \<and> fst a \<inter> snd a \<noteq> {}}" 
                by auto
    with `q \<in> s` rm_OK s_subset show ?thesis
      unfolding NFA_construct_reachable_abstract_impl_invar_def S_def[symmetric]
      apply simp
      apply (rule exI[where x = s])
      apply (simp add: \<A>_eq S_eq accessible_restrict_insert_in)
      by (smt Collect_cong)
  qed

next


  fix rm :: "'q \<Rightarrow> 'q2 option"
  fix rm'' :: "'q \<Rightarrow> 'q2 option"
  fix \<A> q wl rm' D' N r
  assume invar: "NFA_construct_reachable_abstract_impl_invar 
      I  FP {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D} ((rm, \<A>), q # wl)"
     and rm_q_eq: "rm q = Some r" 
     and nin_Q: "r \<notin> \<Q> \<A>"
     and q_in_S: "q \<in> S"
  assume foreach_invar: 
      "NFA_construct_reachable_abstract_impl_foreach_invar_prod 
        S D
        rm (\<Delta> \<A>) q {} (rm', D', N)"

  from invar have invar1: 
     "NFA_construct_reachable_abstract_impl_invar 
                 I  FP  {(q,fst a \<inter> snd a, q')|q a q'. (q, a, q') \<in> D}
                 ((rm, \<A>), q # wl)" by auto

  from rm_q_eq have r_eq: "r = the (rm q)" by simp

  from invar1 obtain s where 
     S_eq: "S = accessible_restrict (LTS_forget_labels 
            {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) 
            s (insert q (set wl))" and
     rm_OK: "NFA_construct_reachable_map_OK S Map.empty 
          (insert q (s \<union> set I \<union> set wl \<union> {q'. \<exists>a q. q \<in> s \<and>
              fst a \<inter> snd a \<noteq> {} \<and> (q, a, q') \<in> D})) rm" 
            and
     \<A>_eq: "\<A> = NFA_rename_states 
        \<lparr>\<Q> = s, \<Delta> = {qsq.
                         (\<exists>q a b q'. qsq = (q, a \<inter> b, q') \<and> (q, (a, b), q') \<in> D) \<and>
                         fst qsq \<in> s \<and> fst (snd qsq) \<noteq> {}}, 
         \<I> = set I,
         \<F> = {q \<in> s. FP q}\<rparr> (the \<circ> rm)" 
    unfolding NFA_construct_reachable_abstract_impl_invar_def S_def[symmetric] 
    apply (simp add: if_split accessible_restrict_def)
    apply (subgoal_tac "\<And>s.{q'. \<exists>a b q. q \<in> s \<and> (q, (a, b), q') \<in> D \<and> a \<inter> b \<noteq> {}} = 
                {q'. \<exists>a q. q \<in> s \<and> a \<noteq> {} \<and> (\<exists>aa b. a = aa \<inter> b \<and> (q, (aa, b), q') \<in> D)}")
    apply (smt Collect_cong S_def)
    by (metis (no_types, lifting) Collect_cong)

  define D'' where "D'' = {(a, q'). (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}}" 

  from foreach_invar have 
    rm'_OK: "NFA_construct_reachable_map_OK S rm (snd ` D'') rm'" and 
    set_N_eq: "set N = snd ` D''"  and 
    D'_eq: "D' = \<Delta> \<A> \<union> {(the (rm' q), fst a \<inter> snd a, 
                          the (rm' q')) |a q'. (a, q') \<in> D'' 
                          \<and> fst a \<inter> snd a \<noteq> {}}"
  unfolding NFA_construct_reachable_abstract_impl_foreach_invar_prod.simps S_def
  apply (simp_all add: Let_def D''_def)
  proof -
    assume NFA_reachable_ok: "NFA_construct_reachable_map_OK
     (accessible
       (LTS_forget_labels {(q, a1 \<inter> a2, q') |q a1 a2 q'. (q, (a1, a2), q') \<in> D})
       (set I))
     rm (snd ` {((a1, a2), q'). (q, (a1, a2), q') \<in> D \<and> a1 \<inter> a2 \<noteq> {} }) rm' \<and>
    set N = snd ` {((a1, a2), q'). (q, (a1, a2), q') \<in> D \<and> a1 \<inter> a2 \<noteq> {} } \<and>
    D' =
    \<Delta> \<A> \<union>
    {(the (rm' q), a1 \<inter> a2, the (rm' q')) |a1 a2 q'.
     (q, (a1, a2), q') \<in> D \<and> a1 \<inter> a2 \<noteq> {}}"
   have pre1: "snd ` {(a, q'). (\<exists>a1 a2. a = a1 \<inter> a2 \<and> (q, (a1, a2), q') \<in> D) \<and> a \<noteq> {}} = 
           snd ` {(fst a \<inter> snd a, q')| a q'. (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}}"
     by (smt Collect_cong fst_conv prod.case_eq_if prod.collapse snd_conv)
   from this have pre2: "
     snd ` {(fst a \<inter> snd a, q')| a q'. (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}} = 
           {q'| a q'. (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}}" 
     apply (auto simp add: setcompr_eq_image Setcompr_eq_image)
     by blast
     
   from pre1 pre2 have pre3: 
      "snd ` {(a, q'). (\<exists>a1 a2. a = a1 \<inter> a2 \<and> (q, (a1, a2), q') \<in> D) \<and> a \<noteq> {}} = 
       {q'| a q'. (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}}" by auto

  from pre1 pre2 pre3 have pre4: 
      "snd ` {(a, q'). (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}} = 
       {q'| a q'. (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}}"  
     apply (auto simp add: setcompr_eq_image Setcompr_eq_image)    
     apply blast
     by fastforce

  from pre2 pre3 pre4 pre1 NFA_reachable_ok show "NFA_construct_reachable_map_OK
     (accessible
       (LTS_forget_labels {(q, a1 \<inter> a2, q') |q a1 a2 q'. (q, (a1, a2), q') \<in> D})
       (set I))
     rm (snd ` {(a, q'). (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {} }) rm'"
    by (smt Collect_cong prod.case_eq_if prod.collapse)
  from pre1 pre2 pre3 pre4 show "snd ` {((a1, a2), q'). (q, (a1, a2), q') \<in> D \<and> a1 \<inter> a2 \<noteq> {}} =
    snd ` {(a, q'). (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}}" 
    by (smt Collect_cong prod.case_eq_if prod.collapse)
  qed
    
  define DD where " DD = 
    insert q (s \<union> set I \<union> set wl \<union> {q'. \<exists>a q. q \<in> s \<and> fst a \<inter> snd a \<noteq> {} \<and> (q, a, q') \<in> D})"
  have DD_intro: "(insert q
       (s \<union> set I \<union> (set N \<union> set wl) \<union> 
       {q'. \<exists>a qa. (qa = q \<or> qa \<in> s) \<and> (qa, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}})) 
       = DD \<union> snd ` D''"  
    unfolding DD_def 
    apply (simp add: image_iff set_N_eq D''_def)
  proof -
    have pre1: "snd ` {(a, q'). (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}} = 
                {q'| a q'. (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}}" by fastforce
    have pre2: "
    {q'. \<exists>a b qa. (qa = q \<or> qa \<in> s) \<and> (qa, (a, b), q') \<in> D \<and> a \<inter> b \<noteq> {}}
    = {q'. \<exists>a b q. q \<in> s \<and> a \<inter> b \<noteq> {} \<and> (q, (a, b), q') \<in> D} \<union> 
      { q'| a q'. (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}}" by fastforce
    from pre1 pre2 show "insert q
     (s \<union> set I \<union> (snd ` {(a, q'). (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}} \<union> set wl) \<union>
      {q'. \<exists>a b qa. (qa = q \<or> qa \<in> s) \<and> (qa, (a, b), q') \<in> D \<and> a \<inter> b \<noteq> {}}) =
    insert q
     (s \<union> set I \<union> set wl \<union> {q'. \<exists>a b q. q \<in> s \<and> a \<inter> b \<noteq> {} \<and> (q, (a, b), q') \<in> D} \<union>
      snd ` {(a, q'). (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}})"
      apply simp
      by fastforce
  qed

  from nin_Q \<A>_eq have q_nin_s: "q \<notin> s" by (auto simp add: image_iff r_eq)

  have pre1: "snd ` {(a, q'). (\<exists>a1 a2. a = a1 \<inter> a2 \<and> (q, (a1, a2), q') \<in> D) \<and> a \<noteq> {}} = 
           snd ` {(fst a \<inter> snd a, q')| a q'. (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}}"
     by (smt Collect_cong fst_conv prod.case_eq_if prod.collapse snd_conv)

  have "(set wl \<union> {y. (q, y) \<in> 
          LTS_forget_labels {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}})
           = set N \<union> set wl"
    unfolding set_N_eq D''_def LTS_forget_labels_def 
    apply ( simp add: image_iff) 
    apply auto
    using pre1 apply auto[1]
    apply (simp_all add: disjoint_iff_not_equal image_iff)
    by (metis disjoint_iff_not_equal)
  from this have prop1: "S = accessible_restrict 
        (LTS_forget_labels {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) 
                (insert q s) (set N \<union> set wl)"
    by (simp add: S_eq accessible_restrict_insert_nin q_nin_s)
  
  have prop2: "NFA_construct_reachable_map_OK S Map.empty
     (insert q  (s \<union> set I \<union> (set N \<union> set wl) \<union> 
   {q'. \<exists>a qa. (qa = q \<or> qa \<in> s) \<and> (qa, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}} )) rm'" 
    unfolding  DD_intro NFA_construct_reachable_map_OK_def
  proof (intro conjI allI impI Un_least )
    from rm'_OK show "snd ` D'' \<subseteq> dom rm'" "inj_on rm' (S \<inter> dom rm')"
      unfolding NFA_construct_reachable_map_OK_def by simp_all
  next
    from rm_OK have "DD \<subseteq> dom rm"
      unfolding NFA_construct_reachable_map_OK_def DD_def[symmetric] by simp
    moreover from rm'_OK have "dom rm \<subseteq> dom rm'"
      unfolding NFA_construct_reachable_map_OK_def dom_def by auto
    finally show "DD \<subseteq> dom rm'" .
  qed simp

  from rm'_OK have "\<And>q. q \<in> dom rm \<Longrightarrow> rm' q = rm q" 
    unfolding NFA_construct_reachable_map_OK_def
    by (simp add: dom_def) metis
  with rm_OK have rm'_eq: "\<And>q'. q' \<in> DD \<Longrightarrow> rm' q' = rm q'" 
    unfolding NFA_construct_reachable_map_OK_def DD_def[symmetric]
    by (simp add: subset_iff)

  have prop3: " 
    \<lparr>\<Q> = insert r (\<Q> \<A>),  \<Delta> = D', \<I> = \<I> \<A>,
       \<F> = if FP q then insert (the (rm q)) (\<F> \<A>) else \<F> \<A>\<rparr> =
    NFA_rename_states
     \<lparr>\<Q> = insert q s, \<Delta> = {qsq.
                   (\<exists>q a b q'. qsq = (q, a \<inter> b, q') \<and> (q, (a, b), q') \<in> D) \<and>
                   (fst qsq = q \<or> fst qsq \<in> s) \<and> fst (snd qsq) \<noteq> {}}, \<I> = set I,
        \<F> = {qa. (qa = q \<or> qa \<in> s) \<and> FP qa}\<rparr>
     (the \<circ> rm')" 
  proof -
    from DD_def have "set I \<subseteq> DD" unfolding DD_def by auto
    with rm'_eq have rm'_eq_I: "(the \<circ> rm) ` set I = (the \<circ> rm') ` set I" 
      apply (rule_tac set_eqI)
      apply (auto simp add: image_iff Bex_def subset_iff)
    done

    from DD_def have "insert q s \<subseteq> DD" unfolding DD_def by auto
    with rm'_eq have rm'_eq_Q: 
      "insert r ((the \<circ> rm) ` s) = insert (the (rm' q)) ((the \<circ> rm') ` s)"
      apply (rule_tac set_eqI)
      apply (auto simp add: image_iff Bex_def subset_iff r_eq)
      done


  have D'_eq' : "D' = {(the (rm' s1), fst a \<inter> snd a, the (rm' s2)) 
        |s1 a s2. (s1, a, s2) \<in> D \<and> fst a \<inter> snd a \<noteq> {} \<and> (s1 = q \<or> s1 \<in> s)}"    
       (is "_ = ?ls")
    proof -
      have "?ls = {(the (rm' s1), fst a \<inter> snd a, the (rm' s2)) |s1 a s2. (s1, a, s2) \<in> D \<and> 
                    fst a \<inter> snd a \<noteq> {} \<and> s1 \<in> s} \<union>
                  {(the (rm' q), fst a \<inter> snd a, the (rm' q')) |a q'. (a, q') \<in> D'' \<and> fst a \<inter> snd a \<noteq> {}}"
           (is "_ = ?ls' \<union> _")
        unfolding D''_def 
        apply auto
         apply blast
          apply blast
         apply blast
        by blast
      moreover
        from rm'_eq have "?ls' = \<Delta> \<A>" unfolding \<A>_eq DD_def
          apply (auto simp add: NFA_rename_states_def) 
           apply (metis IntI empty_iff)
          by (metis IntI empty_iff)
          finally show ?thesis 
            apply (simp add: D'_eq)
            done
        qed


    from rm'_eq have rm'_eq_F: 
      "(if FP q then insert (the (rm q)) (\<F> \<A>) else \<F> \<A>) =
        (the \<circ> rm') ` {qa. (qa = q \<or> qa \<in> s) \<and> FP qa}" 
      apply (rule_tac set_eqI)
      apply (simp add: image_iff \<A>_eq DD_def)
      apply (metis) 
    done

  from this show ?thesis 
    apply (simp add: NFA_rename_states_def \<A>_eq rm'_eq_F rm'_eq_I rm'_eq_Q D'_eq'
                     if_split)
    apply (rule conjI)
    using rm'_eq_Q apply auto[1]
    apply (rule conjI)
    defer
    using \<open>set I \<subseteq> DD\<close> rm'_eq apply force
    by blast
qed 
  from S_eq have s_subset: "s \<subseteq> S" unfolding accessible_restrict_def by simp
  have conclude1: "NFA_construct_reachable_abstract_impl_invar I FP 
                  {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}
        ((rm',\<lparr>\<Q> = insert r (\<Q> \<A>),  \<Delta> = D', \<I> = \<I> \<A>,
             \<F> = if FP q then insert (the (rm q)) (\<F> \<A>) else \<F> \<A>\<rparr>), N @ wl)"
    unfolding NFA_construct_reachable_abstract_impl_invar_def S_def[symmetric]
    apply (simp split del: if_splits)
    apply (rule exI [where x = "insert q s"])
    apply (simp split del: if_splits add: q_in_S)
    apply (simp add: prop3 prop2 prop1)
    apply (insert prop2 prop1)
    apply (subgoal_tac "
          {q'. \<exists>a qa. (qa = q \<or> qa \<in> s) \<and> (qa, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}} = 
          {q'.
         \<exists>a qa.
            (qa = q \<or> qa \<in> s) \<and>
            a \<noteq> {} \<and> (\<exists>a1 a2. a = a1 \<inter> a2 \<and> (qa, (a1, a2), q') \<in> D)}")
    apply auto[1]
    by (smt Collect_cong Pair_inject prod.collapse)
  from S_eq have s_subset: "s \<subseteq> S" unfolding accessible_restrict_def by simp
  with fin_S have fin_s: "finite s" by (metis finite_subset)

  from \<A>_eq fin_s nin_Q have fin_Q: "finite (\<Q> \<A>)" and card_Q_le': "card (\<Q> \<A>) \<le> card s"
    unfolding NFA_rename_states_def by (simp_all add: card_image_le image_iff r_eq) 

  
  from S_eq s_subset accessible_restrict_subset_ws[of 
          "(insert q (set wl))" "LTS_forget_labels 
            {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}" s] 
  have "insert q s \<subseteq> S" unfolding accessible_restrict_def by simp 
  hence "card (insert q s) \<le> card S" by (rule card_mono[OF fin_S])
  hence "card s < card S" by (simp add: q_nin_s fin_s)
  with card_Q_le' have card_Q_le: "card (\<Q> \<A>) < card S" by simp

  hence "card S - card (insert r (\<Q> \<A>)) < card S - card (\<Q> \<A>)" 
    by (simp add: nin_Q fin_Q)
  
  have "card S - card (insert r (\<Q> \<A>)) < card S - card (\<Q> \<A>) \<or>
       rm' = rm \<and> \<lparr>\<Q> = insert r (\<Q> \<A>),  \<Delta> = D', \<I> = \<I> \<A>,
          \<F> = if FP q then insert (the (rm q)) (\<F> \<A>) else \<F> \<A>\<rparr> = \<A> \<and> N = []" 
    using \<open>card S - card (insert r (\<Q> \<A>)) < card S - card (\<Q> \<A>)\<close> apply blast
    done

  show "FP q \<longrightarrow> NFA_construct_reachable_abstract_impl_invar I FP 
        {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}
        ((rm', \<lparr>\<Q> = insert r (\<Q> \<A>),  \<Delta> = D', \<I> = \<I> \<A>, \<F> = insert r (\<F> \<A>)\<rparr>),
         N @ wl) \<and>
       (card S - card (insert r (\<Q> \<A>)) < card S - card (\<Q> \<A>) \<or>
        rm' = rm \<and>
        \<lparr>\<Q> = insert r (\<Q> \<A>), \<Delta> = D', \<I> = \<I> \<A>, \<F> = insert r (\<F> \<A>)\<rparr> = \<A> \<and> N = [])"
 using \<open>card S - card (insert r (\<Q> \<A>)) < card S - card (\<Q> \<A>)\<close> conclude1 r_eq by auto

  show "\<not> FP q \<longrightarrow>
       NFA_construct_reachable_abstract_impl_invar I  FP  {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}
        ((rm', \<lparr>\<Q> = insert r (\<Q> \<A>),  \<Delta> = D', \<I> = \<I> \<A>, \<F> = \<F> \<A>\<rparr>), N @ wl) \<and>
       (card S - card (insert r (\<Q> \<A>)) < card S - card (\<Q> \<A>) \<or>
        rm' = rm \<and> \<lparr>\<Q> = insert r (\<Q> \<A>),  \<Delta> = D', \<I> = \<I> \<A>, \<F> = \<F> \<A>\<rparr> = \<A> \<and> N = [])"
    using \<open>card S - card (insert r (\<Q> \<A>)) < card S - card (\<Q> \<A>)\<close> conclude1 by auto
qed


definition NFA_construct_reachable_abstract2_prod_impl where
  "NFA_construct_reachable_abstract2_prod_impl I FP D  =
   do {
     (rm, I') \<leftarrow> SPEC (\<lambda>(rm, I'). 
        NFA_construct_reachable_map_OK 
          (accessible (LTS_forget_labels 
            {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) 
            (set I)) Map.empty (set I) rm \<and>
        I' = (the \<circ> rm) ` (set I));
     ((rm, \<A>), _) \<leftarrow> WORKLISTIT 
        (NFA_construct_reachable_abstract_impl_invar I FP
          {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) 
      (\<lambda>_. True)
      (\<lambda>(rm, \<A>) q. do {
         ASSERT (q \<in> dom rm \<and> q \<in> accessible (LTS_forget_labels 
          {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) (set I) \<and>
            NFA_construct_reachable_abstract_impl_weak_invar I FP 
            {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D} (rm, \<A>));
         if (the (rm q) \<in> \<Q> \<A>) then
           (RETURN ((rm, \<A>), []))
         else                    
           do {
             (rm', D', N) \<leftarrow> NFA_construct_reachable_abstract_impl_step_prod
                 (accessible (LTS_forget_labels 
                 {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) 
                  (set I)) D rm (\<Delta> \<A>) q;
             RETURN ((rm', \<lparr> \<Q>=insert (the (rm q)) (\<Q> \<A>), \<Delta> = D', 
                           \<I>=\<I> \<A>, \<F> = if (FP q) 
               then (insert (the (rm q)) (\<F> \<A>)) else (\<F> \<A>)\<rparr>), N)
           }
        }) ((rm, \<lparr> \<Q>={}, \<Delta> = {}, \<I>=I', \<F>={} \<rparr>), I);
     RETURN \<A>
   }"

lemma NFA_construct_reachable_abstract2_impl_prod_correct :
fixes D :: "('q \<times> ('a set \<times> 'a set) \<times> 'q) set" and I
defines "S \<equiv> accessible (LTS_forget_labels 
          {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) (set I)"
assumes fin_S: "finite S"
    and fin_D: "\<And>q. finite {(a, q'). (q, a, q') \<in> D}"
  shows "NFA_construct_reachable_abstract2_prod_impl I FP D  
           \<le> \<Down>Id ((NFA_construct_reachable_abstract_impl_prod I FP D)
              ::('q2, 'a) NFA_rec nres)"
  unfolding NFA_construct_reachable_abstract2_prod_impl_def 
            NFA_construct_reachable_abstract_impl_prod_def S_def[symmetric]
apply refine_rcg
apply (simp)
apply (rule single_valued_Id)
apply (rule single_valued_Id)
apply (simp)
apply (simp_all add: list_all2_eq[symmetric])
apply blast
apply (clarify, simp)+
apply (rename_tac q rm \<A> r)
apply (rule NFA_construct_reachable_abstract_impl_step_prod_correct)
proof -
  fix rm :: "'q \<Rightarrow> 'q2 option" and q r
  assume "rm q = Some r" thus "q \<in> dom rm" by blast
next
  fix rm :: "'q \<Rightarrow> 'q2 option" and
      \<A> :: "('q2, 'a) NFA_rec" 

  assume "NFA_construct_reachable_abstract_impl_weak_invar I FP 
          {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D} (rm, \<A>)"
  thus "inj_on rm (S \<inter> dom rm)" 
     unfolding NFA_construct_reachable_abstract_impl_weak_invar_def 
               NFA_construct_reachable_map_OK_def S_def[symmetric] by auto
next
  fix q
  have rewr: "{(a, q'). (q, a, q') \<in> D}  = 
        (\<lambda>(q, a, q'). (a, q')) ` {qsq. qsq \<in> D \<and> fst qsq = q}" 
    apply (simp add: image_iff)
    apply auto
    by (simp add: image_iff)
  show "finite {(a, q'). (q, a, q') \<in> D}" 
    by (rule fin_D)
qed

subsection \<open> Renaming letters (i.e. elements of the alphabet) \<close>



definition NFA_rename_labels :: "('q, 'a) NFA_rec \<Rightarrow> ('a \<Rightarrow> 'b) \<Rightarrow>
                              ('q, 'b) NFA_rec" where
"NFA_rename_labels \<A> f \<equiv> \<lparr> \<Q> = \<Q> \<A>,
                        \<Delta> = { (p, f ` \<sigma>, q) | p \<sigma> q. (p,\<sigma>,q) \<in> \<Delta> \<A>}, 
                        \<I> = \<I> \<A>,
                        \<F> = \<F> \<A> \<rparr>"

lemma [simp] : "\<Q> (NFA_rename_labels \<A> f) = \<Q> \<A>" by (simp add: NFA_rename_labels_def)
lemma [simp] : "(p, f\<sigma>, q) \<in> \<Delta> (NFA_rename_labels \<A> f) \<longleftrightarrow> 
                (\<exists> \<sigma>. (p, \<sigma>, q) \<in> \<Delta> \<A> \<and> (f\<sigma> = f ` \<sigma>))" 
  by (auto simp add: NFA_rename_labels_def)
lemma [simp] : "\<I> (NFA_rename_labels \<A> f) = \<I> \<A>" by (simp add: NFA_rename_labels_def)
lemma [simp] : "\<F> (NFA_rename_labels \<A> f) = \<F> \<A>" by (simp add: NFA_rename_labels_def)

lemma (in NFA) NFA_rename_labels___is_well_formed :
"NFA (NFA_rename_labels \<A> f)"
using wf_NFA
  by (auto simp add: NFA_def image_iff Bex_def)
 
  
(*
lemma lists___NFA_rename_labels :
  "(map f w) \<in> lists (\<Sigma> (NFA_rename_labels \<A> f))"
by (auto simp add: lists_def)
*)

lemma NFA_rename_labels_id [simp] : "NFA_rename_labels \<A> id = \<A>" 
  by (rule NFA_rec.equality, auto simp add: NFA_rename_labels_def)

lemma LTS_is_reachable___NFA_rename_labels :
 "LTS_is_reachable (\<Delta> \<A>) q w q' \<Longrightarrow>
  LTS_is_reachable (\<Delta> (NFA_rename_labels \<A> f)) q (map f w) q'"
proof (induct w arbitrary: q)
  case Nil thus ?case by simp
next
  case (Cons a w) note ind_hyp = Cons(1) note reach_\<sigma>w = Cons(2)
  from reach_\<sigma>w obtain q'' \<sigma> where 
     q''_\<Delta>: "(q, \<sigma>, q'') \<in> \<Delta> \<A>" and
     reach_w: "LTS_is_reachable (\<Delta> \<A>) q'' w q'" by auto
  from ind_hyp reach_w 
    have reach_w': "LTS_is_reachable (\<Delta> (NFA_rename_labels \<A> f)) q'' (map f w) q'" by blast
  from q''_\<Delta> have q''_\<Delta>' : "(q, f ` \<sigma>, q'') \<in> (\<Delta> (NFA_rename_labels \<A> f))" by auto
  from q''_\<Delta>' reach_w' show ?case 
    apply auto
    by (metis LTS_is_reachable.simps(2) image_eqI ind_hyp reach_\<sigma>w)
qed

lemma LTS_is_reachable___NFA_rename_labelsE :
  "LTS_is_reachable (\<Delta> (NFA_rename_labels \<A> f)) q w q' \<Longrightarrow>
   \<exists> w'. w = (map f w') \<and> LTS_is_reachable (\<Delta> \<A>) q w' q'"
proof (induct w arbitrary: q)
  case Nil thus ?case by simp
next
  let ?\<A>' = "NFA_rename_labels \<A> f"
  case (Cons a w) note ind_hyp = Cons(1)
  from Cons(2) obtain q'' \<sigma> where 
     q''_\<Delta>: "(q, \<sigma>, q'') \<in> \<Delta> ?\<A>' \<and> a \<in> \<sigma>" and
     reach_w: "LTS_is_reachable (\<Delta> ?\<A>') q'' w q'" by auto
  from ind_hyp reach_w obtain w' where 
    reach_w': "w = map f w' \<and> LTS_is_reachable (\<Delta> \<A>) q'' w' q'" by blast
  from q''_\<Delta> obtain a' \<sigma>' where "f a' = a" and "a' \<in> \<sigma>' \<and> (q, \<sigma>', q'') \<in> \<Delta> \<A>" by auto
  with reach_w' have "(a # w) = map f (a' # w') 
          \<and> LTS_is_reachable (\<Delta> \<A>) q (a' # w') q'" by auto
  then show "\<exists>w'. a # w = map f w' \<and> LTS_is_reachable (\<Delta> \<A>) q w' q'" by metis
qed

lemma NFA_accept___NFA_rename_labels :
  assumes "NFA_accept \<A> w"
  shows "NFA_accept (NFA_rename_labels \<A> f) (map f w)"
using assms  LTS_is_reachable___NFA_rename_labels unfolding NFA_accept_def
by (auto, fast)

lemma (in NFA) NFA_accept___NFA_rename_labelsE :
  "NFA_accept (NFA_rename_labels \<A> f) w \<Longrightarrow> \<exists> w'. w = (map f w') \<and> NFA_accept \<A> w'"
proof -
  let ?\<A> = "NFA_rename_labels \<A> f"
  assume "NFA_accept ?\<A> w"
  then obtain q and q' where
    a: "q \<in> \<I> ?\<A> \<and> q' \<in> \<F> ?\<A>" and b: "LTS_is_reachable (\<Delta> ?\<A>) q w q'"
    unfolding NFA_accept_def by auto
  from a have "q \<in> \<I> \<A> \<and> q' \<in> \<F> \<A>" by simp
  moreover
  from b obtain w' where c: "w = map f w'" and d: "LTS_is_reachable (\<Delta> \<A>) q w' q'"
    using LTS_is_reachable___NFA_rename_labelsE by metis
  moreover
  ultimately show ?thesis unfolding NFA_accept_def by metis
qed

lemma (in NFA) NFA_accept___NFA_rename_labels_iff :
  "NFA_accept (NFA_rename_labels \<A> f) w \<longleftrightarrow> (\<exists> w'. w = (map f w') \<and> NFA_accept \<A> w')"
by (metis NFA_accept___NFA_rename_labels NFA_accept___NFA_rename_labelsE)

lemma (in NFA) \<L>_NFA_rename_labels [simp] :
  "\<L> (NFA_rename_labels \<A> f) = (map f) ` \<L> \<A>"
by (simp add: set_eq_iff \<L>_def NFA_accept___NFA_rename_labels_iff image_iff, blast)

lemma NFA_isomorphic_wf___NFA_rename_labels_cong :
assumes equiv: "NFA_isomorphic_wf \<A>1 \<A>2"
shows "NFA_isomorphic_wf (NFA_rename_labels \<A>1 fl) (NFA_rename_labels \<A>2 fl)"
proof -
  from equiv
  obtain f where inj_f : "inj_on f (\<Q> \<A>1)" and
                 \<A>2_eq: "\<A>2 = NFA_rename_states \<A>1 f" and
                 wf_\<A>1: "NFA \<A>1" 
    unfolding NFA_isomorphic_wf_def NFA_isomorphic_def by auto

  note wf_rename = NFA.NFA_rename_labels___is_well_formed [OF wf_\<A>1, of fl]

  have "NFA_rename_labels \<A>2 fl = NFA_rename_states (NFA_rename_labels \<A>1 fl) f"
    unfolding \<A>2_eq NFA_rename_labels_def NFA_rename_states_def
    by auto metis
  with wf_rename inj_f show ?thesis
    unfolding NFA_isomorphic_wf_def NFA_isomorphic_def 
    by auto
qed

subsection \<open> Normalise states \<close>

text\<open> Operations like building the product of two automata, naturally lead to a different type
of automaton states. When combining several operations, one often needs to stay in the same
type, however. The following definitions allows to transfer an automaton to an isomorphic
one with a different type of states. \<close>

definition NFA_normalise_states :: "('q, 'a) NFA_rec \<Rightarrow> 
          ('q2::{NFA_states}, 'a) NFA_rec" where
  "NFA_normalise_states \<A> = (NFA_rename_states \<A> (SOME (f::'q \<Rightarrow> 'q2). inj_on f (\<Q> \<A>)))"

lemma ex_inj_on_finite :
assumes inf_univ: "~(finite (UNIV::'b set))"
    and fin_A: "finite (A::'a set)"
shows "\<exists>f::('a \<Rightarrow> 'b). inj_on f A"
using fin_A
proof (induct rule: finite_induct)
  case empty show ?case by simp
next
  case (insert a A)
  note fin_A = insert(1)
  note a_nin = insert(2)
  from insert(3) obtain f where inj_f: "inj_on (f::'a\<Rightarrow>'b) A" by blast

  from fin_A have "finite (f ` A)" by (rule finite_imageI)
  then obtain b where b_nin: "b \<notin> (f ` A)" by (metis ex_new_if_finite inf_univ)

  let ?f' = "\<lambda>x. if (x = a) then b else f x"
  from inj_f a_nin b_nin have "inj_on ?f' (insert a A)"
    unfolding inj_on_def by auto
  thus ?case by blast
qed

lemma NFA_isomorphic_wf_normalise_states :
fixes \<A>:: "('q, 'a) NFA_rec"
assumes wf_A: "NFA \<A>"
shows "NFA_isomorphic_wf \<A> ((NFA_normalise_states \<A>)::('q2::{NFA_states},'a) NFA_rec)"
unfolding NFA_normalise_states_def
  apply (rule NFA_isomorphic_wf___NFA_rename_states [OF _ wf_A])
  apply (rule someI_ex [where P = "\<lambda>f. inj_on f (\<Q> \<A>)"])
  apply (rule ex_inj_on_finite)
  apply (simp_all add: NFA.finite_\<Q>[OF wf_A] not_finite_NFA_states_UNIV)
done

lemma NFA_isomorphic_wf___NFA_normalise_states :
"NFA_isomorphic_wf \<A>1 \<A>2 \<Longrightarrow> NFA_isomorphic_wf \<A>1 (NFA_normalise_states \<A>2)"
by (metis NFA_isomorphic_wf_alt_def NFA_isomorphic_wf_normalise_states NFA_isomorphic_wf_trans)

lemma NFA_isomorphic_wf___NFA_normalise_states_cong :
fixes \<A>1::"('q1, 'a) NFA_rec"
  and \<A>2::"('q2, 'a) NFA_rec"
shows "NFA_isomorphic_wf \<A>1 \<A>2 \<Longrightarrow> 
 NFA_isomorphic_wf (NFA_normalise_states \<A>1) (NFA_normalise_states \<A>2)"
unfolding NFA_normalise_states_def
  apply (rule NFA_isomorphic_wf___rename_states_cong [of _ \<A>1])
  apply (rule someI_ex [where P = "\<lambda>f. inj_on f (\<Q> \<A>1)"])
  apply (rule ex_inj_on_finite)
  defer defer
  apply (rule someI_ex [where P = "\<lambda>f. inj_on f (\<Q> \<A>2)"])
  apply (rule ex_inj_on_finite)
  apply (simp_all add: NFA.finite_\<Q> not_finite_NFA_states_UNIV NFA_isomorphic_wf_alt_def)
done

(*
lemma NFA_normalise_states_\<Sigma> [simp] :
"\<Sigma> (NFA_normalise_states \<A>) = \<Sigma> \<A>"
unfolding NFA_normalise_states_def by simp
*)

lemma NFA_normalise_states_\<L> [simp] :
"NFA \<A> \<Longrightarrow> \<L> (NFA_normalise_states \<A>) = \<L> \<A>"
using NFA_isomorphic_wf_normalise_states[of \<A>]
by (metis NFA_isomorphic_wf_\<L>)

lemma NFA_normalise_states_accept [simp] :
"NFA \<A> \<Longrightarrow> NFA_accept (NFA_normalise_states \<A>) w = NFA_accept \<A> w"
using NFA_normalise_states_\<L> [of \<A>]
by (auto simp add: \<L>_def)

lemma NFA_is_initially_connected___normalise_states :
assumes connected: "NFA_is_initially_connected \<A>"
shows "NFA_is_initially_connected (NFA_normalise_states \<A>)"
unfolding NFA_normalise_states_def
by (intro connected NFA_is_initially_connected___NFA_rename_states)


subsection \<open> Product automata \<close>

text \<open> The following definition is an abstraction of
  product automata. It only becomes interesting for deterministic automata.
  For nondeterministic ones, only product automata are used. \<close>

definition bool_comb_NFA :: 
  "(bool \<Rightarrow> bool \<Rightarrow> bool) \<Rightarrow> ('q1, 'a) NFA_rec \<Rightarrow> 
   ('q2, 'a) NFA_rec \<Rightarrow> ('q1 \<times> 'q2, 'a) NFA_rec" where
"bool_comb_NFA bc \<A>1 \<A>2 == \<lparr>
   \<Q>=\<Q> \<A>1 \<times> \<Q> \<A>2,
   \<Delta> = LTS_product (\<Delta> \<A>1) (\<Delta> \<A>2),
   \<I> = \<I> \<A>1 \<times> \<I> \<A>2,
   \<F> = {q. q \<in> \<Q> \<A>1 \<times> \<Q> \<A>2 \<and> bc (fst q \<in> \<F> \<A>1) (snd q \<in> \<F> \<A>2)}\<rparr>"

lemma [simp] : "\<I> (bool_comb_NFA bc \<A>1 \<A>2) = \<I> \<A>1 \<times> \<I> \<A>2" by (simp add: bool_comb_NFA_def)
lemma [simp] : "\<Q> (bool_comb_NFA bc \<A>1 \<A>2) = \<Q> \<A>1 \<times> \<Q> \<A>2" by (simp add: bool_comb_NFA_def)
lemma [simp] : "\<F> (bool_comb_NFA bc \<A>1 \<A>2) = {q. q \<in> \<Q> \<A>1 \<times> \<Q> \<A>2 \<and> bc (fst q \<in> \<F> \<A>1) (snd q \<in> \<F> \<A>2)}" by (simp add: bool_comb_NFA_def)
lemma [simp] : "\<Delta> (bool_comb_NFA bc \<A>1 \<A>2) = LTS_product (\<Delta> \<A>1) (\<Delta> \<A>2)" by (simp add: bool_comb_NFA_def)

definition product_NFA where 
"product_NFA \<A>1 \<A>2 = bool_comb_NFA (\<and>) \<A>1 \<A>2"


lemma accept_product_NFA :
assumes wf1: "NFA \<A>1" and wf2: "NFA \<A>2" 
shows "NFA_accept (product_NFA \<A>1 \<A>2) w = ((NFA_accept \<A>1 w) \<and> (NFA_accept \<A>2 w))"
using NFA.\<F>_consistent [OF wf1] NFA.\<F>_consistent [OF wf2]
apply (auto simp add: NFA_accept_def LTS_is_reachable_product product_NFA_def subset_iff Bex_def)
apply blast
done

lemma \<L>_product_NFA :
  "\<lbrakk>NFA \<A>1; NFA \<A>2\<rbrakk>  \<Longrightarrow> \<L> (product_NFA \<A>1 \<A>2) = \<L> \<A>1 \<inter> \<L> \<A>2"
unfolding \<L>_def using accept_product_NFA by auto

lemma bool_comb_NFA___is_well_formed :
  "\<lbrakk> NFA \<A>1;  NFA \<A>2\<rbrakk> \<Longrightarrow> NFA (bool_comb_NFA bc \<A>1 \<A>2)"
  unfolding NFA_def 
  by (auto simp add: bool_comb_NFA_def)


lemma product_NFA___is_well_formed :
  "\<lbrakk> NFA \<A>1;  NFA \<A>2 \<rbrakk> \<Longrightarrow> NFA (product_NFA \<A>1 \<A>2)"
  unfolding NFA_def 
  by (auto simp add: product_NFA_def)

definition efficient_bool_comb_NFA where
  "efficient_bool_comb_NFA bc \<A>1 \<A>2 = 
   NFA_remove_unreachable_states (bool_comb_NFA bc \<A>1 \<A>2)"

definition efficient_product_NFA where
  "efficient_product_NFA \<A>1 \<A>2 = NFA_remove_unreachable_states (product_NFA \<A>1 \<A>2)"

lemma efficient_product_NFA_alt_def :
  "efficient_product_NFA \<A>1 \<A>2 = efficient_bool_comb_NFA (\<and>) \<A>1 \<A>2"
unfolding efficient_product_NFA_def efficient_bool_comb_NFA_def product_NFA_def
..



lemma accept_efficient_product_NFA :
  "\<lbrakk>NFA \<A>1;  NFA \<A>2\<rbrakk> \<Longrightarrow> NFA_accept (efficient_product_NFA \<A>1 \<A>2) w = 
   (NFA_accept \<A>1 w \<and> NFA_accept \<A>2 w)" 
by (simp add: efficient_product_NFA_def accept_product_NFA)

lemma \<L>_efficient_product_NFA :
  "\<lbrakk> NFA \<A>1;  NFA \<A>2\<rbrakk> \<Longrightarrow> \<L> (efficient_product_NFA \<A>1 \<A>2) = \<L> \<A>1 \<inter> \<L> \<A>2"
unfolding \<L>_def
by (auto simp add: accept_efficient_product_NFA)

lemma efficient_bool_comb_NFA___is_well_formed :
  "\<lbrakk> NFA \<A>1;  NFA \<A>2 \<rbrakk> \<Longrightarrow> NFA (efficient_bool_comb_NFA bc \<A>1 \<A>2)"
unfolding efficient_bool_comb_NFA_def
by (simp add: bool_comb_NFA___is_well_formed)

lemma efficient_product_NFA___is_well_formed :
  "\<lbrakk> NFA \<A>1;  NFA \<A>2 \<rbrakk> \<Longrightarrow> NFA (efficient_product_NFA \<A>1 \<A>2)"
unfolding efficient_product_NFA_alt_def
by (rule efficient_bool_comb_NFA___is_well_formed)

lemma efficient_bool_comb_NFA_compute :
assumes wf1: "NFA \<A>1" and wf2: "NFA \<A>2"
shows "efficient_bool_comb_NFA bc \<A>1 \<A>2 = 
   (NFA_construct_reachable (\<I> \<A>1 \<times> \<I> \<A>2) 
     (\<lambda>q. q \<in> \<Q> \<A>1 \<times> \<Q> \<A>2 \<and> bc ((fst q) \<in> \<F> \<A>1) ((snd q) \<in> \<F> \<A>2)) 
   (LTS_product (\<Delta> \<A>1) (\<Delta> \<A>2)))"
proof -
   note bool_comb_NFA___is_well_formed [OF wf1 wf2]
   hence wf_bc: "NFA (bool_comb_NFA bc \<A>1 \<A>2)" .

   show ?thesis
     unfolding efficient_bool_comb_NFA_def
     apply (rule NFA.NFA_remove_unreachable_states_implementation)
     apply (simp_all add: wf_bc)
   done
qed

lemma efficient_product_NFA_compute :
  "\<lbrakk>NFA \<A>1;  NFA \<A>2\<rbrakk> \<Longrightarrow>
   efficient_product_NFA \<A>1 \<A>2 = 
   (NFA_construct_reachable (\<I> \<A>1 \<times> \<I> \<A>2)
     (\<lambda>q. q \<in> \<Q> \<A>1 \<times> \<Q> \<A>2 \<and> q \<in> (\<F> \<A>1 \<times> \<F> \<A>2))
     (LTS_product (\<Delta> \<A>1) (\<Delta> \<A>2)))"
apply (simp add: efficient_product_NFA_alt_def 
                 efficient_bool_comb_NFA_compute)
apply (subgoal_tac "(\<lambda>q. q \<in> \<Q> \<A>1 \<times> \<Q> \<A>2 \<and> q \<in> \<F> \<A>1 \<times> \<F> \<A>2) = 
                    (\<lambda>q. q \<in> \<Q> \<A>1 \<times> \<Q> \<A>2 \<and> ((fst q) \<in> \<F> \<A>1) \<and> ((snd q) \<in> \<F> \<A>2))")
apply simp
apply (simp add: fun_eq_iff)
done

lemma NFA_isomorphic_bool_comb_NFA :
assumes equiv_1: "NFA_isomorphic_wf \<A>1 \<A>1'"
    and equiv_2: "NFA_isomorphic_wf \<A>2 \<A>2'"
shows "NFA_isomorphic_wf (bool_comb_NFA bc \<A>1 \<A>2) (bool_comb_NFA bc \<A>1' \<A>2')"
proof -
  from equiv_1 obtain f1 where inj_f1 : "inj_on f1 (\<Q> \<A>1)" and
                 \<A>1'_eq: "\<A>1' = NFA_rename_states \<A>1 f1" and
                 wf_\<A>1 : "NFA \<A>1" 
    unfolding NFA_isomorphic_wf_def NFA_isomorphic_def by auto

  from equiv_2 obtain f2 where inj_f2 : "inj_on f2 (\<Q> \<A>2)" and
                 \<A>2'_eq: "\<A>2' = NFA_rename_states \<A>2 f2" and
                 wf_\<A>2: "NFA \<A>2" 
    unfolding NFA_isomorphic_wf_def NFA_isomorphic_def by auto

  define f where "f = (\<lambda> (q1, q2). (f1 q1, f2 q2))"
  with inj_f1 inj_f2 have inj_f : "inj_on f (\<Q> (bool_comb_NFA bc \<A>1 \<A>2))"
    by (simp add: inj_on_def)

  have f_image: "\<And>S1 S2. f ` (S1 \<times> S2) = (f1 ` S1) \<times> (f2 ` S2)"
    unfolding f_def by auto

  have f_image1: "\<And>q1 q2. f (q1, q2) = ((f1 q1), (f2 q2))"
    unfolding f_def by auto

  have "\<F> (bool_comb_NFA bc \<A>1' \<A>2') = f ` (\<F> (bool_comb_NFA bc \<A>1 \<A>2))"
  proof -
    { fix q
      have "q \<in> {q \<in> f1 ` \<Q> \<A>1 \<times> f2 ` \<Q> \<A>2. bc (fst q \<in> f1 ` \<F> \<A>1) (snd q \<in> f2 ` \<F> \<A>2)} \<longleftrightarrow>
            q \<in> f ` {q \<in> \<Q> \<A>1 \<times> \<Q> \<A>2. bc (fst q \<in> \<F> \<A>1) (snd q \<in> \<F> \<A>2)}"
      proof -
        obtain q1 q2 where q_eq: "q = (q1, q2)" by (cases q, blast)

        have fact1 : "\<And>y. y \<in> \<Q> \<A>1 \<Longrightarrow> (\<exists>x. x \<in> \<F> \<A>1 \<and> f1 y = f1 x) \<longleftrightarrow> (y \<in> \<F> \<A>1)"
          by (metis inj_f1 [unfolded inj_on_def] 
                    NFA.\<F>_consistent [OF wf_\<A>1, unfolded subset_iff])

        have fact2 : "\<And>y. y \<in> \<Q> \<A>2 \<Longrightarrow> (\<exists>x. x \<in> \<F> \<A>2 \<and> f2 y = f2 x) \<longleftrightarrow> (y \<in> \<F> \<A>2)"
          by (metis inj_f2 [unfolded inj_on_def] 
                    NFA.\<F>_consistent [OF wf_\<A>2, unfolded subset_iff])

        show ?thesis 
          apply (simp del: ex_simps add: image_iff Bex_def ex_simps[symmetric] q_eq f_def)
          apply (insert fact1 fact2)
          apply (auto, metis+)
        done
      qed
    } 
    thus ?thesis
      unfolding \<A>1'_eq \<A>2'_eq bool_comb_NFA_def 
      by simp
  qed

  hence prod_eq': "bool_comb_NFA bc \<A>1' \<A>2' = NFA_rename_states (bool_comb_NFA bc \<A>1 \<A>2) f"
    unfolding \<A>1'_eq \<A>2'_eq bool_comb_NFA_def 
    apply (rule_tac NFA_rec.equality)
    apply (simp_all add: f_image)
    apply (simp add: NFA_rename_states_def LTS_product_def f_image1)
    apply fastforce
  done

  from inj_f prod_eq' 
       bool_comb_NFA___is_well_formed [OF wf_\<A>1 wf_\<A>2, of bc]
  show ?thesis
    unfolding NFA_isomorphic_wf_def NFA_isomorphic_def by blast
qed

lemma NFA_isomorphic_efficient_bool_comb_NFA :
assumes equiv_1: "NFA_isomorphic_wf \<A>1 \<A>1'"
    and equiv_2: "NFA_isomorphic_wf \<A>2 \<A>2'"
shows "NFA_isomorphic_wf (efficient_bool_comb_NFA bc \<A>1 \<A>2) (efficient_bool_comb_NFA bc \<A>1' \<A>2')"
unfolding efficient_bool_comb_NFA_def
apply (rule NFA_isomorphic_wf___NFA_remove_unreachable_states)
apply (rule_tac NFA_isomorphic_bool_comb_NFA)
  apply (simp_all add: equiv_1 equiv_2)
  done



definition NFA_bool_comb :: "(bool \<Rightarrow> bool \<Rightarrow> bool) \<Rightarrow> 
  ('q::{NFA_states}, 'a) NFA_rec \<Rightarrow> ('q, 'a) NFA_rec \<Rightarrow> ('q, 'a) NFA_rec" where
  "NFA_bool_comb bc \<A>1 \<A>2 = NFA_normalise_states (efficient_bool_comb_NFA bc \<A>1 \<A>2)"

definition NFA_product :: "('q::{NFA_states}, 'a) NFA_rec 
                        \<Rightarrow> ('q, 'a) NFA_rec 
                        \<Rightarrow> ('q, 'a) NFA_rec" where
  "NFA_product \<A>1 \<A>2 = NFA_bool_comb (\<and>) \<A>1 \<A>2"



lemma NFA_bool_comb___isomorphic_wf :
"NFA \<A>1 \<Longrightarrow> NFA \<A>2 \<Longrightarrow>
 NFA_isomorphic_wf (efficient_bool_comb_NFA bc \<A>1 \<A>2) 
                   (NFA_bool_comb bc \<A>1 \<A>2)"
unfolding NFA_isomorphic_def NFA_bool_comb_def
apply (rule NFA_isomorphic_wf_normalise_states)
  apply (simp add: efficient_bool_comb_NFA___is_well_formed)
  done

lemma NFA_product___isomorphic_wf :
"NFA \<A>1 \<Longrightarrow> NFA \<A>2 \<Longrightarrow>
 NFA_isomorphic_wf (efficient_bool_comb_NFA (\<and>) \<A>1 \<A>2) 
                   (NFA_product  \<A>1 \<A>2)"
unfolding NFA_isomorphic_def NFA_bool_comb_def NFA_product_def
apply (rule NFA_isomorphic_wf_normalise_states)
apply (simp add: efficient_bool_comb_NFA___is_well_formed)
done

lemma NFA_product_NFA :
"NFA \<A>1 \<Longrightarrow> NFA \<A>2 \<Longrightarrow>
 NFA (NFA_product  \<A>1 \<A>2)"
  by (meson NFA_isomorphic_wf_D(2) NFA_product___isomorphic_wf)

lemma NFA_isomorphic_efficient_NFA_bool_comb :
assumes equiv_1: "NFA_isomorphic_wf \<A>1 \<A>1'"
    and equiv_2: "NFA_isomorphic_wf \<A>2 \<A>2'"
shows "NFA_isomorphic_wf (NFA_bool_comb bc \<A>1 \<A>2) (NFA_bool_comb bc \<A>1' \<A>2')"
unfolding NFA_bool_comb_def efficient_bool_comb_NFA_def
apply (rule NFA_isomorphic_wf___NFA_normalise_states_cong)
apply (rule NFA_isomorphic_wf___NFA_remove_unreachable_states)
apply (rule_tac NFA_isomorphic_bool_comb_NFA)
apply (simp_all add: equiv_1 equiv_2)
  done




lemma \<L>_NFA_product :
  "\<lbrakk>NFA \<A>1; NFA \<A>2\<rbrakk>  \<Longrightarrow> \<L> (NFA_product \<A>1 \<A>2) = \<L> \<A>1 \<inter> \<L> \<A>2"
  unfolding \<L>_def NFA_product_def NFA_bool_comb_def
  using accept_product_NFA 
  apply (insert NFA_normalise_states_\<L> 
                NFA_normalise_states_accept NFA_accept_alt_def
                \<L>_efficient_product_NFA
                efficient_product_NFA_alt_def)
  apply (subgoal_tac "NFA (efficient_bool_comb_NFA (\<and>) \<A>1 \<A>2)")
  defer 
  apply (simp add: efficient_bool_comb_NFA___is_well_formed)
  apply (insert accept_efficient_product_NFA)
  apply auto
proof -
  fix x
  assume p1: "(\<And>\<A>1 \<A>2.
        NFA \<A>1 \<Longrightarrow> NFA \<A>2 \<Longrightarrow> \<L> (efficient_product_NFA \<A>1 \<A>2) = \<L> \<A>1 \<inter> \<L> \<A>2)" and
         p2: "NFA \<A>1" and
         p3: "NFA \<A>2" and
         p4: "(\<And>\<A>1 \<A>2. efficient_product_NFA \<A>1 \<A>2 = efficient_bool_comb_NFA (\<and>) \<A>1 \<A>2)" and
         p5: "NFA (efficient_bool_comb_NFA (\<and>) \<A>1 \<A>2)"
  show "NFA_accept (efficient_bool_comb_NFA (\<and>) \<A>1 \<A>2) x \<Longrightarrow> NFA_accept \<A>1 x"
    by (metis accept_efficient_product_NFA efficient_product_NFA_alt_def p2 p3)
  {
    assume p6: "NFA_accept (efficient_bool_comb_NFA (\<and>) \<A>1 \<A>2) x"
    show "NFA_accept \<A>2 x"
      by (metis accept_efficient_product_NFA efficient_product_NFA_alt_def p2 p3 p6)
  }
  {
    assume p7: "NFA_accept \<A>1 x" and
           p8: "NFA_accept \<A>2 x"
    show "NFA_accept (efficient_bool_comb_NFA (\<and>) \<A>1 \<A>2) x"
      by (metis accept_efficient_product_NFA efficient_product_NFA_alt_def p2 p3 p7 p8)
  }
qed

lemma accept_NFA_product :
  "\<lbrakk>NFA \<A>1; NFA \<A>2\<rbrakk>  \<Longrightarrow> \<forall> w. NFA_accept (NFA_product \<A>1 \<A>2) w = 
                              (NFA_accept \<A>1 w  \<and> NFA_accept \<A>2 w)"
  apply (insert \<L>_NFA_product)
  by (simp add: NFA_accept_alt_def \<L>_NFA_product)
  
  
subsection \<open> Reversal \<close>
definition NFA_reverse :: "('q, 'a) NFA_rec \<Rightarrow> ('q, 'a) NFA_rec" where
  "NFA_reverse \<A> = \<lparr> \<Q> = \<Q> \<A>, \<Delta> = { (q,\<sigma>,p). (p,\<sigma>,q) \<in> \<Delta> \<A> }, \<I> = \<F> \<A>, \<F> = \<I> \<A> \<rparr>"

lemma [simp] : "\<Q> (NFA_reverse \<A>) = \<Q> \<A>" by (simp add: NFA_reverse_def)
lemma [simp] : "\<I> (NFA_reverse \<A>) = \<F> \<A>" by (simp add: NFA_reverse_def)
lemma [simp] : "\<F> (NFA_reverse \<A>) = \<I> \<A>" by (simp add: NFA_reverse_def)

lemma [simp] : "p\<sigma>q \<in> \<Delta> (NFA_reverse \<A>) \<longleftrightarrow> ((snd (snd p\<sigma>q)), (fst (snd p\<sigma>q)), (fst p\<sigma>q)) \<in> \<Delta> \<A>"
by (cases p\<sigma>q, simp add: NFA_reverse_def)

lemma NFA_reverse___is_well_formed :
  "NFA \<A> \<Longrightarrow> NFA (NFA_reverse \<A>)"
by (simp add: NFA_def NFA_reverse_def)

lemma NFA_reverse_NFA_reverse :
  "NFA_reverse (NFA_reverse \<A>) = \<A>"
proof -
  have "\<Delta> \<A> = {(q, \<sigma>, p) |q \<sigma> p. (q, \<sigma>, p) \<in> \<Delta> \<A>}" by auto
  thus ?thesis by (simp add: NFA_reverse_def)
qed

lemma NFA_reverse___LTS_is_reachable :
  "LTS_is_reachable (\<Delta> (NFA_reverse \<A>)) p w q \<longleftrightarrow> LTS_is_reachable (\<Delta> \<A>) q (rev w) p"
by (induct w arbitrary: p q, auto)

lemma NFA_reverse___accept :
  "NFA_accept (NFA_reverse \<A>) w \<longleftrightarrow> NFA_accept \<A> (rev w)"
by (simp add: NFA_accept_def NFA_reverse___LTS_is_reachable, auto) 

lemma NFA_reverse___\<L> :
  "\<L> (NFA_reverse \<A>) = {rev w | w. w \<in> \<L> \<A>}"
unfolding \<L>_def using NFA_reverse___accept by force

lemma NFA_reverse___\<L>_in_state :
  "\<L>_in_state (NFA_reverse \<A>) q = {rev w | w. w \<in> \<L>_left \<A> q}"
by (auto simp add: \<L>_in_state_def \<L>_left_def NFA_reverse___LTS_is_reachable lists_eq_set,
    metis rev_rev_ident set_rev)

lemma NFA_reverse___\<L>_left :
  "\<L>_left (NFA_reverse \<A>) q = {rev w | w. w \<in> \<L>_in_state \<A> q}"
by (auto simp add: \<L>_in_state_def \<L>_left_def NFA_reverse___LTS_is_reachable lists_eq_set,
    metis rev_rev_ident set_rev)

lemma unreachable_states_NFA_reverse_def :
  "NFA_unreachable_states \<A> = {q. \<L>_in_state (NFA_reverse \<A>) q = {}}"
by (simp add: NFA_reverse___\<L>_in_state NFA_unreachable_states_alt_def)

lemma NFA_isomorphic_wf___NFA_reverse_cong :
assumes equiv: "NFA_isomorphic_wf \<A>1 \<A>2"
shows "NFA_isomorphic_wf (NFA_reverse \<A>1) (NFA_reverse \<A>2)"
proof -
  from equiv obtain f where inj_f : "inj_on f (\<Q> \<A>1)" and
                 \<A>2_eq: "\<A>2 = NFA_rename_states \<A>1 f" and
                 wf_\<A>1: "NFA \<A>1" 
    unfolding NFA_isomorphic_wf_def NFA_isomorphic_def by auto

  with inj_f have inj_f' : "inj_on f (\<Q> (NFA_reverse \<A>1))"
    by simp

  have \<A>2_eq': "NFA_reverse \<A>2 = NFA_rename_states (NFA_reverse \<A>1) f"
    unfolding NFA_reverse_def \<A>2_eq NFA_rename_states_def
    apply simp
    apply auto 
  done

  from inj_f' \<A>2_eq' NFA_reverse___is_well_formed [OF wf_\<A>1] show ?thesis
    unfolding NFA_isomorphic_wf_def NFA_isomorphic_def by blast
qed

subsection \<open>  Right quotient \<close>

definition NFA_right_quotient :: "('q, 'a) NFA_rec 
                                  \<Rightarrow> ('a list) set \<Rightarrow> ('q, 'a) NFA_rec" where
  "NFA_right_quotient \<A> L = 
     \<lparr> \<Q> = \<Q> \<A>, 
       \<Delta> = \<Delta> \<A>, 
       \<I> = \<I> \<A>, 
       \<F> = {q. q \<in> \<Q> \<A> \<and> \<L>_in_state \<A> q \<inter> L \<noteq> {}} \<rparr>"

lemma [simp] : "\<Q> (NFA_right_quotient \<A> L) = \<Q> \<A>" by (simp add: NFA_right_quotient_def)
lemma [simp] : "\<I> (NFA_right_quotient \<A> L) = \<I> \<A>" by (simp add: NFA_right_quotient_def)
lemma [simp] : "\<Delta> (NFA_right_quotient \<A> L) = \<Delta> \<A>" by (simp add: NFA_right_quotient_def)
lemma [simp] : "\<F> (NFA_right_quotient \<A> L) = {q. q \<in> \<Q> \<A> \<and> \<L>_in_state \<A> q \<inter> L \<noteq> {}}" by (simp add: NFA_right_quotient_def)


lemma NFA_right_quotient___is_well_formed :
  "NFA \<A> \<Longrightarrow> NFA (NFA_right_quotient \<A> L)"
unfolding NFA_def NFA_right_quotient_def
by auto

lemma (in NFA) NFA_right_quotient___accepts :
  "NFA_accept (NFA_right_quotient \<A> L) w \<longleftrightarrow>
   (\<exists>w2 \<in> L. NFA_accept \<A> (w @ w2))"
unfolding NFA_def NFA_right_quotient_def
using NFA_\<Delta>_cons___LTS_is_reachable \<I>_consistent
by (simp add: NFA_accept_def Bex_def LTS_is_reachable_concat subset_iff
              ex_simps[symmetric] \<L>_in_state_def ex_in_conv [symmetric]
         del: ex_simps )
    metis

subsection \<open> automata concatentation \<close>


definition NFA_concatenation :: "('a, 'b) NFA_rec \<Rightarrow> ('a, 'b) NFA_rec \<Rightarrow> ('a, 'b) NFA_rec" 
    where "
    NFA_concatenation \<A>1 \<A>2 =
    \<lparr> \<Q> = \<Q> \<A>1 \<union> \<Q> \<A>2, 
      \<Delta> = \<Delta> \<A>1 \<union> \<Delta> \<A>2 \<union> 
                {(q, a, q'') | 
                    q q' a q''.
                    (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> (\<F> \<A>1) \<and> q'' \<in> (\<I> \<A>2)}, 
      \<I> = if (\<I> \<A>1 \<inter> \<F> \<A>1 \<noteq> {}) then  
          (\<I> \<A>1 \<union> \<I> \<A>2) else \<I> \<A>1,
      \<F> = \<F> \<A>2 \<rparr>
    "

lemma NFA_concatenation_subset :
  "\<lbrakk> NFA \<A>1;  NFA \<A>2 ; \<Q> \<A>1 \<inter> \<Q> \<A>2 = {}\<rbrakk> \<Longrightarrow> 
   \<Delta> \<A>1 \<subseteq> (\<Delta> (NFA_concatenation \<A>1 \<A>2)) \<and> 
   \<Delta> \<A>2 \<subseteq> (\<Delta> (NFA_concatenation \<A>1 \<A>2))"
  unfolding NFA_def 
  by (auto simp add: NFA_concatenation_def)



lemma NFA_concatenation___is_well_formed :
  "\<lbrakk> NFA \<A>1;  NFA \<A>2 ; \<Q> \<A>1 \<inter> \<Q> \<A>2 = {}\<rbrakk> \<Longrightarrow> NFA (NFA_concatenation \<A>1 \<A>2)"
  unfolding NFA_def 
  by (auto simp add: NFA_concatenation_def)
  

fun language_concatenation :: 
     "'a list set \<Rightarrow> 'a list set \<Rightarrow> 'a list set" 
     where "language_concatenation \<L>1 \<L>2 = {w1 @ w2| w1 w2. w1\<in> \<L>1 \<and> w2 \<in> \<L>2}"

lemma accept_NFA_concatenation:  
  assumes wf1: "NFA \<A>1" and
          wf2: "NFA \<A>2" and 
       nempty: "\<Q> \<A>1 \<inter> \<Q> \<A>2 = {}"
   shows "NFA_accept (NFA_concatenation \<A>1 \<A>2) w = 
          (\<exists> w1 w2. w = w1 @ w2 \<and> NFA_accept \<A>1 w1 \<and> NFA_accept \<A>2 w2)" 
using NFA.\<F>_consistent [OF wf1] NFA.\<F>_consistent [OF wf2]
  apply (auto simp add: NFA_accept_def 
             subset_iff Bex_def NFA_concatenation_def) 
  defer
proof -
  from wf1 wf2 nempty have prem1: 
        "\<And>q \<alpha> q'. (q, \<alpha>, q') \<in> \<Delta> \<A>1 \<longrightarrow> q \<in> \<Q> \<A>1 \<and> q' \<in> \<Q> \<A>1"
    by (simp add: NFA.\<Delta>_consistent)
  from wf1 wf2 nempty have prem2: 
        "\<And>q \<alpha> q'. (q, \<alpha>, q') \<in> \<Delta> \<A>2 \<longrightarrow> q \<in> \<Q> \<A>2 \<and> q' \<in> \<Q> \<A>2"
    by (simp add: NFA.\<Delta>_consistent)

  from wf1 wf2 nempty have prem3: 
        "\<And>q \<alpha> q'. (q, \<alpha>, q') \<in> {uu.\<exists>q q' a q''. uu = (q, a, q'') \<and>
                       (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2} 
                   \<longrightarrow> q \<in> \<Q> \<A>1 \<and> q' \<in> \<Q> \<A>2"
  using NFA.\<I>_consistent Pair_inject prem1 by auto

  {fix w1 w2 x xa xb xc
    assume x_in_I_\<A>1: "x \<in> \<I> \<A>1" and
          xa_in_I_\<A>2: "xa \<in> \<I> \<A>2" and
          xb_in_F_\<A>1: " xb \<in> \<F> \<A>1" and
          xc_in_F_\<A>2: " xc \<in> \<F> \<A>2" and
        reachable_\<A>1: "LTS_is_reachable (\<Delta> \<A>1) x w1 xb" and
        reachable_\<A>2: "LTS_is_reachable (\<Delta> \<A>2) xa w2 xc" and
  I_\<A>1_F_\<A>1_noempty:  "\<I> \<A>1 \<inter> \<F> \<A>1 = {}"

  
    from this have "x \<noteq> xb \<and> w1 \<noteq> []" by auto
    from this I_\<A>1_F_\<A>1_noempty reachable_\<A>1 LTS_is_reachable_concat 
        obtain w a where
        w1_w: "w1 = w @ [a]" 
          by (meson neq_Nil_rev_conv)
    from this I_\<A>1_F_\<A>1_noempty reachable_\<A>1 LTS_is_reachable_concat
    obtain x1 where 
    "LTS_is_reachable (\<Delta> \<A>1) x w x1 \<and> LTS_is_reachable (\<Delta> \<A>1) x1 [a] xb"
      by auto
    from this obtain \<alpha> where \<alpha>_exist: "(x1, \<alpha>, xb) \<in> (\<Delta> \<A>1) \<and> a \<in> \<alpha>" by auto
    from this xa_in_I_\<A>2 xb_in_F_\<A>1 
      have x1_xa_concat: "(x1, \<alpha>, xa) \<in> \<Delta> (NFA_concatenation \<A>1 \<A>2)" 
      apply (simp add: NFA_concatenation_def) 
      by auto
    from this LTS_is_reachable_onestep LTS_is_reachable_concat
         reachable_\<A>1 reachable_\<A>2
    have "LTS_is_reachable (\<Delta> (NFA_concatenation \<A>1 \<A>2))
                    x w x1"
      apply auto
      by (meson LTS_is_reachable_mono 
          NFA_concatenation_subset \<open>LTS_is_reachable (\<Delta> \<A>1) x w x1 \<and> 
              LTS_is_reachable (\<Delta> \<A>1) x1 [a] xb\<close> nempty wf1 wf2)
     from this LTS_is_reachable_onestep LTS_is_reachable_concat
         reachable_\<A>1 reachable_\<A>2 x1_xa_concat w1_w \<alpha>_exist
     have reach_x_xa: "LTS_is_reachable (\<Delta> (NFA_concatenation \<A>1 \<A>2))
                    x w1 xa"
       by auto
     from reachable_\<A>2 NFA_concatenation_subset LTS_is_reachable_subset
      have "LTS_is_reachable (\<Delta> (NFA_concatenation \<A>1 \<A>2))
            xa w2 xc" 
        by (metis nempty wf1 wf2)
     from this reach_x_xa LTS_is_reachable_concat
     have "LTS_is_reachable (\<Delta> (NFA_concatenation \<A>1 \<A>2))
                    x (w1 @ w2) xc 
      "
       by fastforce
     from this x_in_I_\<A>1 xc_in_F_\<A>2 
     show "\<exists>x. x \<in> \<I> \<A>1 \<and>
           (\<exists>xa. xa \<in> \<F> \<A>2 \<and>
                 LTS_is_reachable
                  (\<Delta> \<A>1 \<union> \<Delta> \<A>2 \<union>
                   {uu.
                    \<exists>q q' a q''.
                       uu = (q, a, q'') \<and>
                       (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2})
                  x (w1 @ w2) xa)" 
       apply (simp add: NFA_concatenation_def)
       by auto   
   }
   {fix x xa xb
     assume x_in_\<I>_A1: "x \<in> \<I> \<A>1" and
            x_in_\<F>_\<A>1: "x \<in> \<F> \<A>1" and
            xb_in_\<F>_\<A>2: "xb \<in> \<F> \<A>2" and
            xa_in_\<I>_\<A>1: "xa \<in> \<I> \<A>1" and
            reachable: " LTS_is_reachable
        (\<Delta> \<A>1 \<union> \<Delta> \<A>2 \<union>
         {uu.
          \<exists>q q' a q''.
             uu = (q, a, q'') \<and> (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2})
        xa w xb"
     have xaxb: "xa \<in> \<Q> \<A>1 \<and> xb \<in> \<Q> \<A>2"
       using NFA.\<I>_consistent \<open>\<F> \<A>2 \<subseteq> \<Q> \<A>2\<close> wf1 xa_in_\<I>_\<A>1 xb_in_\<F>_\<A>2 by blast
  note reachable_split =  LTS_is_reachable_disjoint [of "(\<Q> \<A>1)" "(\<Q> \<A>2)" 
            "(\<Delta> \<A>1)" "(\<Delta> \<A>2)" "{uu.
          \<exists>q q' a q''.
             uu = (q, a, q'') \<and> (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2}" xa
              xb w, OF nempty prem1 prem2 prem3 xaxb reachable]
      from this LTS_is_reachable_disjoint nempty prem1 prem2 prem3
      have "\<exists> xi1 xi2 w1 w2 a \<alpha>. 
       LTS_is_reachable (\<Delta> \<A>1) xa w1 xi1 \<and> 
       xi1 \<in> \<Q> \<A>1 \<and>
       LTS_is_reachable (\<Delta> \<A>2) xi2 w2 xb \<and>
       xi2 \<in> \<Q> \<A>2 \<and>
       w = w1 @ [a] @ w2 \<and>
       (xi1, \<alpha>, xi2) \<in>  {uu.
          \<exists>q q' a q''.
             uu = (q, a, q'') \<and> (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2} \<and> 
          a \<in> \<alpha>"
        apply (insert reachable_split)
        by blast
        
     from this  
      obtain xi1 xi2 w1 w2 a \<alpha> where
      p1: "w = w1 @ [a] @ w2" and 
      p2: "LTS_is_reachable (\<Delta> \<A>1) xa w1 xi1" and
      p3: "(xi1, \<alpha>, xi2) \<in>  {uu.
          \<exists>q q' a q''.
             uu = (q, a, q'') \<and> (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2}
          \<and> a \<in> \<alpha>" and
      p4: "LTS_is_reachable (\<Delta> \<A>2) xi2 w2 xb"
        by blast

      from p3 obtain xi3 where
        con1: "(xi1, \<alpha>, xi3) \<in> \<Delta> \<A>1 \<and> xi3 \<in>  \<F> \<A>1 \<and> a \<in> \<alpha>"
        by blast
      from this have con2: "LTS_is_reachable (\<Delta> \<A>1) xi1 [a] xi3"  by auto

      from p2 con1 con2 LTS_is_reachable_concat xa_in_\<I>_\<A>1 have
      con4: "LTS_is_reachable (\<Delta> \<A>1) xa (w1 @ [a]) xi3 \<and> xa \<in> \<I> \<A>1 \<and> xi3 \<in> \<F> \<A>1"
        by auto
      from p3 p4 xb_in_\<F>_\<A>2 have con5: "LTS_is_reachable (\<Delta> \<A>2) xi2 w2 xb \<and> 
                                   xi2 \<in> \<I> \<A>2 \<and> xb \<in> \<F> \<A>2"
        by auto
      from p1 con4 con5 show "\<exists>w1 w2.
          w = w1 @ w2 \<and>
          (\<exists>x. x \<in> \<I> \<A>1 \<and> (\<exists>xa. xa \<in> \<F> \<A>1 \<and> LTS_is_reachable (\<Delta> \<A>1) x w1 xa)) \<and>
          (\<exists>x. x \<in> \<I> \<A>2 \<and> (\<exists>xa. xa \<in> \<F> \<A>2 \<and> LTS_is_reachable (\<Delta> \<A>2) x w2 xa))"
        by (metis append.assoc)
    
    }
    {
      fix x xa xb
      assume p1 : "xa \<in> \<I> \<A>2" and
             p2 : "xb \<in> \<F> \<A>2" and
             p3: "LTS_is_reachable
        (\<Delta> \<A>1 \<union> \<Delta> \<A>2 \<union>
         {uu.
          \<exists>q q' a q''.
             uu = (q, a, q'') \<and> (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2})
        xa w xb" and
             p4: "x \<in> \<I> \<A>1" and
             p5: "x \<in> \<F> \<A>1"
      from p1 p2 have con1: "xa \<in> \<Q> \<A>2 \<and> xb \<in> \<Q> \<A>2" 
        using NFA.\<I>_consistent \<open>\<F> \<A>2 \<subseteq> \<Q> \<A>2\<close> wf2 by blast
      note LTS_closure = LTS_is_reachable_closure[OF nempty prem1 prem2 prem3 con1
                          , of w]
      from p3  LTS_closure have con2: "LTS_is_reachable (\<Delta> \<A>2) xa w xb" by auto
      from p4 have con3: "LTS_is_reachable (\<Delta> \<A>1) x [] x" by auto
      have con4: "w = [] @ w" by auto
      from p4 p5 con3 con2 con1 con4 show "\<exists>w1 w2.
          w = w1 @ w2 \<and>
          (\<exists>x. x \<in> \<I> \<A>1 \<and> (\<exists>xa. xa \<in> \<F> \<A>1 \<and> LTS_is_reachable (\<Delta> \<A>1) x w1 xa)) \<and>
          (\<exists>x. x \<in> \<I> \<A>2 \<and> (\<exists>xa. xa \<in> \<F> \<A>2 \<and> LTS_is_reachable (\<Delta> \<A>2) x w2 xa))"
        using p1 p2 by blast
    }
    {
      fix x w1 w2 xa xb xc xd
      assume 
       p1: "x \<in> \<I> \<A>1" and
       p2: "x \<in> \<F> \<A>1" and
       p3: "w = w1 @ w2" and
       p4: "xa \<in> \<I> \<A>1" and
       p5: "xb \<in> \<I> \<A>2" and
       p6: "xc \<in> \<F> \<A>1" and
       p7: "LTS_is_reachable (\<Delta> \<A>1) xa w1 xc" and
       p8: "xd \<in> \<F> \<A>2" and 
       p9: "LTS_is_reachable (\<Delta> \<A>2) xb w2 xd" 
      show "
       \<exists>x. (x \<in> \<I> \<A>1 \<or> x \<in> \<I> \<A>2) \<and>
           (\<exists>xa. xa \<in> \<F> \<A>2 \<and>
                 LTS_is_reachable
                  (\<Delta> \<A>1 \<union> \<Delta> \<A>2 \<union>
                   {uu.
                    \<exists>q q' a q''.
                       uu = (q, a, q'') \<and>
                       (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2})
                  x (w1 @ w2) xa)"
      proof (cases "w1 = []")
      case True
      then show ?thesis 
        by (metis (no_types, lifting) LTS_is_reachable_subset empty_append_eq_id p5 p8 p9 sup.coboundedI1 sup_ge2)
      next
      case False
      assume "w1 \<noteq> []"
      from this obtain a w1' where "w1 = w1' @ [a]" 
        by (meson neq_Nil_rev_conv)
      from this p7 LTS_is_reachable_concat obtain xi where
        p10: "LTS_is_reachable (\<Delta> \<A>1) xi [a] xc" and 
        p11: "LTS_is_reachable (\<Delta> \<A>1) xa w1' xi"
        by auto
      from p10 obtain \<alpha> where
       p12: "(xi, \<alpha>, xc) \<in> \<Delta> \<A>1 \<and> a \<in> \<alpha>" by auto
      from this p5 have con1: "(xi, \<alpha>, xb) \<in> {uu.
                    \<exists>q q' a q''.
                       uu = (q, a, q'') \<and>
                       (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2}"
        using p6 by blast
      from this p10 p9 p12 p8 LTS_is_reachable_subset       
      have con2: "(xi, \<alpha>, xb) \<in> {uu.
                    \<exists>q q' a q''.
                       uu = (q, a, q'') \<and>
                       (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2}"
        by auto
      from this p10 p9 p12 p8 LTS_is_reachable_subset
      have con3: "LTS_is_reachable
                  (\<Delta> \<A>1 \<union> \<Delta> \<A>2 \<union>
                   {uu.
                    \<exists>q q' a q''.
                       uu = (q, a, q'') \<and>
                       (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2})
                  xb w2 xd"
        by (metis (no_types, lifting) Un_upper2 le_supI1)
        
      from con2 con3 this p10 p9 p12 p8 LTS_is_reachable_subset       
      have con3: "
           (
           LTS_is_reachable
                  (\<Delta> \<A>1 \<union> \<Delta> \<A>2 \<union>
                   {uu.
                    \<exists>q q' a q''.
                       uu = (q, a, q'') \<and>
                       (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2})
                  xi (a # w2) xd)
      " 
        by auto
      from p11 have con4: 
      "LTS_is_reachable
                  (\<Delta> \<A>1 \<union> \<Delta> \<A>2 \<union>
                   {uu.
                    \<exists>q q' a q''.
                       uu = (q, a, q'') \<and>
                       (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2})
                  xa w1' xi"
        by (meson LTS_is_reachable_mono inf_sup_ord(3))
      have "w1 @ w2 = w1' @ (a # w2)" 
        using \<open>w1 = w1' @ [a]\<close> by auto
      from this con3 con4 LTS_is_reachable_concat[of "\<Delta> \<A>1 \<union> \<Delta> \<A>2 \<union>
                   {uu.
                    \<exists>q q' a q''.
                       uu = (q, a, q'') \<and>
                       (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2}" 
              xa "w1' @ [a]" "w2" xd] p4
      have "LTS_is_reachable
     (\<Delta> \<A>1 \<union> \<Delta> \<A>2 \<union>
      {uu.
       \<exists>q q' a q''. uu = (q, a, q'') \<and> (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2})
     xa ((w1' @ [a]) @ w2) xd
     " by auto
      from this show ?thesis  
        using \<open>w1 = w1' @ [a]\<close> p4 p8 by blast
      qed      
    }
    {
      fix x xa
      assume 
      p1: "\<I> \<A>1 \<inter> \<F> \<A>1 = {}" and
      p2: "x \<in> \<I> \<A>1" and
      p3: "xa \<in> \<F> \<A>2" and
      p4: "LTS_is_reachable 
        (\<Delta> \<A>1 \<union> \<Delta> \<A>2 \<union>
         {uu.
          \<exists>q q' a q''.
             uu = (q, a, q'') \<and> (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2})
        x w xa" 
      show "\<exists>w1 w2.
          w = w1 @ w2 \<and>
          (\<exists>x. x \<in> \<I> \<A>1 \<and> (\<exists>xa. xa \<in> \<F> \<A>1 \<and> LTS_is_reachable (\<Delta> \<A>1) x w1 xa)) \<and>
          (\<exists>x. x \<in> \<I> \<A>2 \<and> (\<exists>xa. xa \<in> \<F> \<A>2 \<and> LTS_is_reachable (\<Delta> \<A>2) x w2 xa))"
  proof -
     have xaxb: "x \<in> \<Q> \<A>1 \<and> xa \<in> \<Q> \<A>2"
       using NFA.\<I>_consistent \<open>\<F> \<A>2 \<subseteq> \<Q> \<A>2\<close> p2 p3 wf1 by blast
  note reachable_split =  LTS_is_reachable_disjoint [of "(\<Q> \<A>1)" "(\<Q> \<A>2)" 
            "(\<Delta> \<A>1)" "(\<Delta> \<A>2)" "{uu.
          \<exists>q q' a q''.
             uu = (q, a, q'') \<and> (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2}"
           x xa w, OF nempty prem1 prem2 prem3 xaxb p4]
      from this LTS_is_reachable_disjoint nempty prem1 prem2 prem3
      have "\<exists> xi1 xi2 w1 w2 a \<alpha>. 
       LTS_is_reachable (\<Delta> \<A>1) x w1 xi1 \<and> 
       xi1 \<in> \<Q> \<A>1 \<and>
       LTS_is_reachable (\<Delta> \<A>2) xi2 w2 xa \<and>
       xi2 \<in> \<Q> \<A>2 \<and>
       w = w1 @ [a] @ w2 \<and>
       (xi1, \<alpha>, xi2) \<in>  {uu.
          \<exists>q q' a q''.
             uu = (q, a, q'') \<and> (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2} \<and> 
          a \<in> \<alpha>"
        apply (insert reachable_split)
        by blast
        
     from this  
      obtain xi1 xi2 w1 w2 a \<alpha> where
      p11: "w = w1 @ [a] @ w2" and 
      p21: "LTS_is_reachable (\<Delta> \<A>1) x w1 xi1" and
      p31: "(xi1, \<alpha>, xi2) \<in>  {uu.
          \<exists>q q' a q''.
             uu = (q, a, q'') \<and> (q, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> q'' \<in> \<I> \<A>2}
          \<and> a \<in> \<alpha>" and
      p41: "LTS_is_reachable (\<Delta> \<A>2) xi2 w2 xa"
        by blast

      from p31 obtain xi3 where
        con1: "(xi1, \<alpha>, xi3) \<in> \<Delta> \<A>1 \<and> xi3 \<in>  \<F> \<A>1 \<and> a \<in> \<alpha>"
        by blast
      from this have con2: "LTS_is_reachable (\<Delta> \<A>1) xi1 [a] xi3"  by auto

      from p2 con1 con2 LTS_is_reachable_concat p21 have
      con4: "LTS_is_reachable (\<Delta> \<A>1) x (w1 @ [a]) xi3 \<and> x \<in> \<I> \<A>1 \<and> xi3 \<in> \<F> \<A>1"
        by auto
      from p31 p41 p3 have con5: "LTS_is_reachable (\<Delta> \<A>2) xi2 w2 xa \<and> 
                                   xi2 \<in> \<I> \<A>2 \<and> xa \<in> \<F> \<A>2"
        by auto
      from p11 con4 con5 show "\<exists>w1 w2.
          w = w1 @ w2 \<and>
          (\<exists>x. x \<in> \<I> \<A>1 \<and> (\<exists>xa. xa \<in> \<F> \<A>1 \<and> LTS_is_reachable (\<Delta> \<A>1) x w1 xa)) \<and>
          (\<exists>x. x \<in> \<I> \<A>2 \<and> (\<exists>xa. xa \<in> \<F> \<A>2 \<and> LTS_is_reachable (\<Delta> \<A>2) x w2 xa))"
        by (metis append.assoc)
    qed
    }
  qed



lemma \<L>_NFA_concatenation :
  "\<lbrakk> NFA \<A>1;  NFA \<A>2 ; \<Q> \<A>1 \<inter> \<Q> \<A>2 = {}\<rbrakk> \<Longrightarrow> 
    \<L> (NFA_concatenation \<A>1 \<A>2) = language_concatenation (\<L> \<A>1) (\<L> \<A>2)" 
  unfolding \<L>_def
  apply (auto simp add: accept_NFA_concatenation)
  by (metis)

definition efficient_NFA_concatenation where
  "efficient_NFA_concatenation \<A>1 \<A>2 = 
   NFA_remove_unreachable_states (NFA_concatenation \<A>1 \<A>2)"

lemma efficient_NFA_concatenation___is_well_formed :
  "\<lbrakk> NFA \<A>1;  NFA \<A>2 ; \<Q> \<A>1 \<inter> \<Q> \<A>2 = {}\<rbrakk> \<Longrightarrow> 
        NFA (efficient_NFA_concatenation \<A>1 \<A>2)"
unfolding efficient_NFA_concatenation_def
  by (simp add: NFA_concatenation___is_well_formed)

thm NFA_concatenation___is_well_formed

lemma accept_efficient_NFA_concatenation :
  "\<lbrakk>NFA \<A>1;  NFA \<A>2 ; \<Q> \<A>1 \<inter> \<Q> \<A>2 = {}\<rbrakk> \<Longrightarrow> NFA_accept (efficient_NFA_concatenation \<A>1 \<A>2) w = 
   (\<exists> w1 w2. w = w1 @ w2 \<and>  NFA_accept \<A>1 w1 \<and> NFA_accept \<A>2 w2)" 
  by (simp add: efficient_NFA_concatenation_def 
                accept_NFA_concatenation)

lemma \<L>_efficient_NFA_concatenation :
  "\<lbrakk> NFA \<A>1;  NFA \<A>2; \<Q> \<A>1 \<inter> \<Q> \<A>2 = {}\<rbrakk> \<Longrightarrow> 
        \<L> (efficient_NFA_concatenation \<A>1 \<A>2) = 
          language_concatenation (\<L> \<A>1) (\<L> \<A>2)"
  unfolding \<L>_def
  apply (auto simp add: accept_efficient_NFA_concatenation)
  by fastforce 

lemma NFA_isomorphic_NFA_concatenation :
assumes equiv_1: "NFA_isomorphic_wf \<A>1 \<A>1'"
    and equiv_2: "NFA_isomorphic_wf \<A>2 \<A>2'"
    and disjoint1: "\<Q> \<A>1 \<inter> \<Q> \<A>2 = {}"
    and disjoint2: "\<Q> \<A>1' \<inter> \<Q> \<A>2' = {}"
  shows "NFA_isomorphic_wf (NFA_concatenation \<A>1 \<A>2) 
                           (NFA_concatenation \<A>1' \<A>2')"
proof - 
  from equiv_1 obtain f1 where inj_f1 : "inj_on f1 (\<Q> \<A>1)" and
                 \<A>1'_eq: "\<A>1' = NFA_rename_states \<A>1 f1" and
                 wf_\<A>1 : "NFA \<A>1" 
    unfolding NFA_isomorphic_wf_def NFA_isomorphic_def by auto
  from this have con1: "\<And> q. q \<in> \<Q> \<A>1 \<longrightarrow> f1 q \<in> \<Q> \<A>1'" by auto
  from equiv_2 obtain f2 where  inj_f2 : "inj_on f2 (\<Q> \<A>2)" and
                 \<A>2'_eq: "\<A>2' = NFA_rename_states \<A>2 f2" and
                 wf_\<A>2: "NFA \<A>2" 
    unfolding NFA_isomorphic_wf_def NFA_isomorphic_def by auto
  from this equiv_2 have con9: "\<F> \<A>2' = f2 ` (\<F> \<A>2)"
    unfolding NFA_isomorphic_wf_def NFA_isomorphic_def NFA_rename_states_def
    by simp
  from inj_f2 \<A>2'_eq have con2: "\<And> q. q \<in> \<Q> \<A>2 \<longrightarrow> f2 q \<in> \<Q> \<A>2'" by auto
  define f where "f = (\<lambda> q. if q \<in> (\<Q> \<A>1)  then (f1 q) else (f2 q))"
  from disjoint1 disjoint2 inj_f1 inj_f2 have con3: "inj_on f (\<Q> \<A>1 \<union> \<Q> \<A>2)"
    apply (simp_all add: inj_on_def f_def if_splits)
  proof 
    fix x
    assume 
     p1: "\<Q> \<A>1 \<inter> \<Q> \<A>2 = {}" and
     p2: "\<Q> \<A>1' \<inter> \<Q> \<A>2' = {}" and
     p3: "\<forall>x\<in>\<Q> \<A>1. \<forall>y\<in>\<Q> \<A>1. f1 x = f1 y \<longrightarrow> x = y" and
     p4: "\<forall>x\<in>\<Q> \<A>2. \<forall>y\<in>\<Q> \<A>2. f2 x = f2 y \<longrightarrow> x = y" and
     p5: "x \<in> \<Q> \<A>1 \<union> \<Q> \<A>2"
    show "(x \<in> \<Q> \<A>1 \<longrightarrow>
          (\<forall>y\<in>\<Q> \<A>1 \<union> \<Q> \<A>2.
              (y \<in> \<Q> \<A>1 \<longrightarrow> f1 x = f1 y) \<and> (y \<notin> \<Q> \<A>1 \<longrightarrow> f1 x = f2 y) \<longrightarrow> x = y)) \<and>
         (x \<notin> \<Q> \<A>1 \<longrightarrow>
          (\<forall>y\<in>\<Q> \<A>1 \<union> \<Q> \<A>2.
              (y \<in> \<Q> \<A>1 \<longrightarrow> f2 x = f1 y) \<and> (y \<notin> \<Q> \<A>1 \<longrightarrow> f2 x = f2 y) \<longrightarrow> x = y))"
      apply (rule conjI)
      apply (rule impI)
      defer
      apply (rule impI)
    proof 
      {
         fix y
         assume p6: "x \<notin> \<Q> \<A>1" and
                p7: "y \<in> \<Q> \<A>1 \<union> \<Q> \<A>2"
         show "(y \<in> \<Q> \<A>1 \<longrightarrow> f2 x = f1 y) \<and> (y \<notin> \<Q> \<A>1 \<longrightarrow> f2 x = f2 y) \<longrightarrow> x = y"
           apply auto
           apply (subgoal_tac "x \<in> \<Q> \<A>2")
           using p4 p7 apply auto[1] 
           using p6 p5 apply blast
           using disjoint2 
           apply (subgoal_tac "x \<in> \<Q> \<A>2 \<and> f2 x \<in> \<Q> \<A>2' \<and> f1 y \<in> \<Q> \<A>1'")
           apply fastforce
           using p6 p5 apply simp
           using  con1 con2 apply fastforce
           by (metis UnE con1 con2 disjoint_iff_not_equal inj_f2 inj_onD p2 p5 p6 p7)
       }
       {
         assume p7: "x \<in> \<Q> \<A>1"
         show "\<forall>y\<in>\<Q> \<A>1 \<union> \<Q> \<A>2.
           (y \<in> \<Q> \<A>1 \<longrightarrow> f1 x = f1 y) \<and> (y \<notin> \<Q> \<A>1 \<longrightarrow> f1 x = f2 y) \<longrightarrow> x = y"
         proof 
           fix y
           assume p8: "y \<in> \<Q> \<A>1 \<union> \<Q> \<A>2"
           show "(y \<in> \<Q> \<A>1 \<longrightarrow> f1 x = f1 y) \<and> (y \<notin> \<Q> \<A>1 \<longrightarrow> f1 x = f2 y) \<longrightarrow> x = y"
             apply auto
             using p7 disjoint2 
             apply (subgoal_tac "y \<in> \<Q> \<A>2 \<and> f1 x \<in> \<Q> \<A>1' \<and> f2 y \<in> \<Q> \<A>2'")
             apply fastforce
             using p8 apply simp
             using con1 con2 apply fastforce
             apply (simp add: p3 p7)
             using con1 con2 inj_f1 inj_onD p2 p7 p8 by fastforce
         qed
       } 
     qed
   qed
  with  con3 inj_f1 inj_f2 
    have inj_f : "inj_on f (\<Q> (NFA_concatenation \<A>1 \<A>2))"
    apply (subgoal_tac "\<Q> (NFA_concatenation \<A>1 \<A>2) = \<Q> \<A>1 \<union> \<Q> \<A>2")
    using subset_inj_on apply auto[1]
    unfolding NFA_concatenation_def
    by simp

  from wf_\<A>2 have "\<F> \<A>2 \<subseteq> \<Q> \<A>2" 
    unfolding NFA_def by auto
  from con9 this
  have "\<F> (NFA_concatenation \<A>1' \<A>2') = f ` (\<F> (NFA_concatenation \<A>1 \<A>2))"
    unfolding NFA_concatenation_def
    apply simp
    unfolding f_def
    using disjoint1 by auto

  hence prod_eq': "NFA_concatenation \<A>1' \<A>2' = 
                  NFA_rename_states (NFA_concatenation \<A>1 \<A>2) f"
    unfolding \<A>1'_eq \<A>2'_eq NFA_concatenation_def 
    apply (rule_tac NFA_rec.equality)
    apply (simp_all)
    apply (simp add: NFA_rename_states_def)
    using disjoint1 f_def apply auto[1]
     apply (simp add: NFA_rename_states_def)
     apply (simp add: set_eq_iff)
     apply (rule allI)+
    apply simp
     defer 
     apply (rule conjI)
  proof -
    {
      assume "f2 ` \<F> \<A>2 = f ` \<F> \<A>2"
      show "\<I> \<A>1 \<inter> \<F> \<A>1 = {} \<longrightarrow>
    (f1 ` \<I> \<A>1 \<inter> f1 ` \<F> \<A>1 = {} \<longrightarrow> f1 ` \<I> \<A>1 = f ` \<I> \<A>1) \<and>
    (f1 ` \<I> \<A>1 \<inter> f1 ` \<F> \<A>1 \<noteq> {} \<longrightarrow> f1 ` \<I> \<A>1 \<union> f2 ` \<I> \<A>2 = f ` \<I> \<A>1)"
        apply (rule impI)
         apply (rule conjI)
      proof -
        assume "\<I> \<A>1 \<inter> \<F> \<A>1 = {}"
        have "f1 ` \<I> \<A>1 = f ` \<I> \<A>1"
          using NFA.\<I>_consistent f_def wf_\<A>1 by auto
        from this 
        show "f1 ` \<I> \<A>1 \<inter> f1 ` \<F> \<A>1 = {} \<longrightarrow> f1 ` \<I> \<A>1 = f ` \<I> \<A>1" by auto
        show "f1 ` \<I> \<A>1 \<inter> f1 ` \<F> \<A>1 \<noteq> {} \<longrightarrow> f1 ` \<I> \<A>1 \<union> f2 ` \<I> \<A>2 = f ` \<I> \<A>1"
          by (metis NFA.\<F>_consistent NFA.\<I>_consistent \<open>\<I> \<A>1 \<inter> \<F> \<A>1 = {}\<close> image_empty inj_f1 inj_on_image_Int wf_\<A>1)
      qed
      }
      {
      assume "f2 ` \<F> \<A>2 = f ` \<F> \<A>2"
      show "\<I> \<A>1 \<inter> \<F> \<A>1 \<noteq> {} \<longrightarrow>
    (f1 ` \<I> \<A>1 \<inter> f1 ` \<F> \<A>1 = {} \<longrightarrow> f1 ` \<I> \<A>1 = f ` (\<I> \<A>1 \<union> \<I> \<A>2)) \<and>
    (f1 ` \<I> \<A>1 \<inter> f1 ` \<F> \<A>1 \<noteq> {} \<longrightarrow> f1 ` \<I> \<A>1 \<union> f2 ` \<I> \<A>2 = f ` (\<I> \<A>1 \<union> \<I> \<A>2))"
       apply (rule impI)
        apply (rule conjI)
      proof -
        assume "\<I> \<A>1 \<inter> \<F> \<A>1 \<noteq> {}"
        show "f1 ` \<I> \<A>1 \<inter> f1 ` \<F> \<A>1 = {} \<longrightarrow> f1 ` \<I> \<A>1 = f ` (\<I> \<A>1 \<union> \<I> \<A>2)"
          using \<open>\<I> \<A>1 \<inter> \<F> \<A>1 \<noteq> {}\<close> by blast
        have "\<I> \<A>1 \<subseteq> \<Q> \<A>1 \<and> \<I> \<A>2 \<subseteq> \<Q> \<A>2" 
          by (simp add: NFA.\<I>_consistent wf_\<A>1 wf_\<A>2)
        from this show "f1 ` \<I> \<A>1 \<inter> f1 ` \<F> \<A>1 \<noteq> {} \<longrightarrow> 
                f1 ` \<I> \<A>1 \<union> f2 ` \<I> \<A>2 = f ` (\<I> \<A>1 \<union> \<I> \<A>2)"
        using disjoint1 f_def by auto
    qed
  }
  {
    fix a aa b
    show "((\<exists>s1. a = f1 s1 \<and>
              (\<exists>a. (\<forall>x. (x \<in> aa) = (x \<in> a)) \<and>
                   (\<exists>s2. b = f1 s2 \<and> (s1, a, s2) \<in> \<Delta> \<A>1))) \<or>
        (\<exists>s1. a = f2 s1 \<and>
              (\<exists>a. (\<forall>x. (x \<in> aa) = (x \<in> a)) \<and>
                   (\<exists>s2. b = f2 s2 \<and> (s1, a, s2) \<in> \<Delta> \<A>2))) \<or>
        (\<exists>q' ab.
            (\<forall>x. (x \<in> aa) = (x \<in> ab)) \<and>
            (\<exists>q q'a. (q, ab, q'a) \<in> \<Delta> \<A>1 \<and> a = f1 q \<and> q' = f1 q'a) \<and>
            q' \<in> f1 ` \<F> \<A>1 \<and> b \<in> f2 ` \<I> \<A>2)) =
       (\<exists>s1. a = f s1 \<and>
             (\<exists>a. (\<forall>x. (x \<in> aa) = (x \<in> a)) \<and>
                  (\<exists>s2. b = f s2 \<and>
                        ((s1, a, s2) \<in> \<Delta> \<A>1 \<or>
                         (s1, a, s2) \<in> \<Delta> \<A>2 \<or>
                         (\<exists>q'. (s1, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> s2 \<in> \<I> \<A>2)))))"
    proof 
      show "(\<exists>s1. a = f1 s1 \<and>
          (\<exists>a. (\<forall>x. (x \<in> aa) = (x \<in> a)) \<and> (\<exists>s2. b = f1 s2 \<and> (s1, a, s2) \<in> \<Delta> \<A>1))) \<or>
    (\<exists>s1. a = f2 s1 \<and>
          (\<exists>a. (\<forall>x. (x \<in> aa) = (x \<in> a)) \<and> (\<exists>s2. b = f2 s2 \<and> (s1, a, s2) \<in> \<Delta> \<A>2))) \<or>
    (\<exists>q' ab.
        (\<forall>x. (x \<in> aa) = (x \<in> ab)) \<and>
        (\<exists>q q'a. (q, ab, q'a) \<in> \<Delta> \<A>1 \<and> a = f1 q \<and> q' = f1 q'a) \<and>
        q' \<in> f1 ` \<F> \<A>1 \<and> b \<in> f2 ` \<I> \<A>2) \<Longrightarrow>
    \<exists>s1. a = f s1 \<and>
         (\<exists>a. (\<forall>x. (x \<in> aa) = (x \<in> a)) \<and>
              (\<exists>s2. b = f s2 \<and>
                    ((s1, a, s2) \<in> \<Delta> \<A>1 \<or>
                     (s1, a, s2) \<in> \<Delta> \<A>2 \<or>
                     (\<exists>q'. (s1, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> s2 \<in> \<I> \<A>2))))"
        apply auto
        apply (metis NFA.\<Delta>_consistent f_def wf_\<A>1)
        apply (metis NFA.\<Delta>_consistent disjoint1 disjoint_iff_not_equal f_def wf_\<A>2)
      proof -
        fix ab q q'a x xa
        assume p1: "\<forall>x. (x \<in> aa) = (x \<in> ab)" and
               p2: "x \<in> \<F> \<A>1" and
               p3: "xa \<in> \<I> \<A>2" and
               p4: "b = f2 xa " and
               p5: "(q, ab, q'a) \<in> \<Delta> \<A>1" and
               p6: "f1 x = f1 q'a" and
               p7: "a = f1 q"
        from p5 p6 have "(q, ab, x) \<in> \<Delta> \<A>1"
          using NFA.\<Delta>_consistent NFA.\<F>_consistent inj_f1 inj_onD p2 wf_\<A>1 by fastforce
        from p5 have "q \<in> \<Q> \<A>1" 
          by (meson NFA.\<Delta>_consistent wf_\<A>1)
        from this have "f1 q = f q"
          by (simp add: f_def)
        from p1 have "(\<forall>x. (x \<in> ab) = (x \<in> ab))" by auto
        from p3 have "xa \<in> \<Q> \<A>2" 
          using NFA.\<I>_consistent wf_\<A>2 by blast
        from this have "f2 xa = f xa" 
          using \<open>xa \<in> \<Q> \<A>2\<close> disjoint1 f_def by auto
        have "((q, ab, x) \<in> \<Delta> \<A>1 \<and> x \<in> \<F> \<A>1 \<and> xa \<in> \<I> \<A>2)"
          by (simp add: \<open>(q, ab, x) \<in> \<Delta> \<A>1\<close> p2 p3)
        have "f1 q = f q \<and>
            ((\<forall>x. (x \<in> ab) = (x \<in> ab)) \<and>
                 (f2 xa = f xa \<and>
                        (\<exists>q'. (q, ab, x) \<in> \<Delta> \<A>1 \<and> x \<in> \<F> \<A>1 \<and> xa \<in> \<I> \<A>2)))"
          using \<open>(q, ab, x) \<in> \<Delta> \<A>1\<close> \<open>f1 q = f q\<close> \<open>f2 xa = f xa\<close> p2 p3 by blast
        from this show " \<exists>s1. f1 q = f s1 \<and>
            (\<exists>a. (\<forall>x. (x \<in> ab) = (x \<in> a)) \<and>
                 (\<exists>s2. f2 xa = f s2 \<and>
                       ((s1, a, s2) \<in> \<Delta> \<A>1 \<or>
                        (s1, a, s2) \<in> \<Delta> \<A>2 \<or>
                        (\<exists>q'. (s1, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> s2 \<in> \<I> \<A>2))))"
          by auto
      qed
      show "\<exists>s1. a = f s1 \<and>
         (\<exists>a. (\<forall>x. (x \<in> aa) = (x \<in> a)) \<and>
              (\<exists>s2. b = f s2 \<and>
                    ((s1, a, s2) \<in> \<Delta> \<A>1 \<or>
                     (s1, a, s2) \<in> \<Delta> \<A>2 \<or>
                     (\<exists>q'. (s1, a, q') \<in> \<Delta> \<A>1 \<and> q' \<in> \<F> \<A>1 \<and> s2 \<in> \<I> \<A>2)))) \<Longrightarrow>
    (\<exists>s1. a = f1 s1 \<and>
          (\<exists>a. (\<forall>x. (x \<in> aa) = (x \<in> a)) \<and> (\<exists>s2. b = f1 s2 \<and> (s1, a, s2) \<in> \<Delta> \<A>1))) \<or>
    (\<exists>s1. a = f2 s1 \<and>
          (\<exists>a. (\<forall>x. (x \<in> aa) = (x \<in> a)) \<and> (\<exists>s2. b = f2 s2 \<and> (s1, a, s2) \<in> \<Delta> \<A>2))) \<or>
    (\<exists>q' ab.
        (\<forall>x. (x \<in> aa) = (x \<in> ab)) \<and>
        (\<exists>q q'a. (q, ab, q'a) \<in> \<Delta> \<A>1 \<and> a = f1 q \<and> q' = f1 q'a) \<and>
        q' \<in> f1 ` \<F> \<A>1 \<and> b \<in> f2 ` \<I> \<A>2)"
        apply auto
        apply (meson NFA.\<Delta>_consistent f_def wf_\<A>1)
        apply (metis NFA.\<Delta>_consistent disjoint1 disjoint_iff_not_equal f_def wf_\<A>2)
      proof -
        fix s1 ab s2 q'
        assume 
          p1 : "a = f s1" and
          p2 : "\<forall>x. (x \<in> aa) = (x \<in> ab)" and
          p3 : "b = f s2" and
          p4 : "\<forall>s1a. f s1 = f1 s1a \<longrightarrow>
             (\<forall>a. (\<exists>x. (x \<in> ab) = (x \<notin> a)) \<or>
                  (\<forall>s2a. f s2 = f1 s2a \<longrightarrow> (s1a, a, s2a) \<notin> \<Delta> \<A>1))" and
          p5: "(s1, ab, q') \<in> \<Delta> \<A>1" and
          p6: "q' \<in> \<F> \<A>1" and
          p7: "s2 \<in> \<I> \<A>2" and 
          p8: " \<forall>q'. q' \<in> f1 ` \<F> \<A>1 \<longrightarrow>
            (\<forall>aba. (\<exists>x. (x \<in> ab) = (x \<notin> aba)) \<or>
                   (\<forall>q. f s1 = f1 q \<longrightarrow>
                        (\<forall>q'a. (q, aba, q'a) \<in> \<Delta> \<A>1 \<longrightarrow> q' \<noteq> f1 q'a)) \<or>
                   f s2 \<notin> f2 ` \<I> \<A>2) "
        from p6 have "f q' \<in> f1 ` \<F> \<A>1" 
          using NFA.\<Delta>_consistent f_def p5 wf_\<A>1 by fastforce 
        from this p8 have con1: "(\<exists>x. (x \<in> ab) = (x \<notin> ab)) \<or>
                   (\<forall>q. f s1 = f1 q \<longrightarrow>
                        (\<forall>q'a. (q, ab, q'a) \<in> \<Delta> \<A>1 \<longrightarrow> f q' \<noteq> f1 q'a)) \<or>
                   f s2 \<notin> f2 ` \<I> \<A>2" 
          by blast
        have "(\<exists>x. (x \<in> ab) = (x \<notin> ab)) = False" 
          by simp
        from p7 have "f s2 \<in> f2 ` \<I> \<A>2" 
          using NFA.\<I>_consistent disjoint1 f_def wf_\<A>2 by auto
       from this con1 have "(\<forall>q. f s1 = f1 q \<longrightarrow>
                        (\<forall>q'a. (q, ab, q'a) \<in> \<Delta> \<A>1 \<longrightarrow> f q' \<noteq> f1 q'a))"
         by blast
       from this have "f s1 = f1 s1 \<longrightarrow>
                        (\<forall>q'a. (s1, ab, q'a) \<in> \<Delta> \<A>1 \<longrightarrow> f q' \<noteq> f1 q'a)"
         by auto
       from this have "(\<forall>q'a. (s1, ab, q'a) \<in> \<Delta> \<A>1 \<longrightarrow> f q' \<noteq> f1 q'a)" 
         by (simp add: NFA.\<Delta>_consistent f_def wf_\<A>1)
       from this have "(s1, ab, q') \<in> \<Delta> \<A>1 \<longrightarrow> f q' \<noteq> f1 q'"
         by auto 
       from this have "f q' \<noteq> f1 q'"
         using p5 by blast
       from this have False
         by (meson NFA.\<Delta>_consistent f_def p5 wf_\<A>1)
       from this
        show "\<exists>s1a. f s1 = f2 s1a \<and>
             (\<exists>a. (\<forall>x. (x \<in> ab) = (x \<in> a)) \<and>
                  (\<exists>s2a. f s2 = f2 s2a \<and> (s1a, a, s2a) \<in> \<Delta> \<A>2))"
          by auto
      qed qed
      }qed
    

  from inj_f prod_eq' 
       NFA_concatenation___is_well_formed [OF wf_\<A>1 wf_\<A>2]
  show ?thesis
    unfolding NFA_isomorphic_wf_def NFA_isomorphic_def 
    using disjoint1 by auto
qed

lemma NFA_isomorphic_efficient_NFA_concatenation :
assumes equiv_1: "NFA_isomorphic_wf \<A>1 \<A>1'"
    and equiv_2: "NFA_isomorphic_wf \<A>2 \<A>2'"
    and disjoint1: "\<Q> \<A>1 \<inter> \<Q> \<A>2 = {}"
    and disjoint2: "\<Q> \<A>1' \<inter> \<Q> \<A>2' = {}"
shows "NFA_isomorphic_wf 
    (efficient_NFA_concatenation \<A>1 \<A>2) (efficient_NFA_concatenation \<A>1' \<A>2')"
unfolding efficient_NFA_concatenation_def
apply (rule NFA_isomorphic_wf___NFA_remove_unreachable_states)
apply (rule_tac NFA_isomorphic_NFA_concatenation)
  apply (simp_all add: equiv_1 equiv_2 disjoint1 disjoint2)
  done


definition NFA_concate :: "
  ('q::{NFA_states}, 'a) NFA_rec \<Rightarrow> 
  ('q, 'a) NFA_rec \<Rightarrow> ('q, 'a) NFA_rec" where
  "NFA_concate \<A>1 \<A>2 = NFA_normalise_states (efficient_NFA_concatenation \<A>1 \<A>2)"


lemma NFA_concate___isomorphic_wf :
"NFA \<A>1 \<Longrightarrow> NFA \<A>2 \<Longrightarrow> \<Q> \<A>1 \<inter> \<Q> \<A>2 = {} \<Longrightarrow>
 NFA_isomorphic_wf (efficient_NFA_concatenation \<A>1 \<A>2) 
                   (NFA_concate \<A>1 \<A>2)"
unfolding NFA_isomorphic_def NFA_concate_def
apply (rule NFA_isomorphic_wf_normalise_states)
apply (simp add: efficient_NFA_concatenation___is_well_formed)
done


definition efficient_NFA_rename_concatenation where
  "efficient_NFA_rename_concatenation f1 f2 \<A>1 \<A>2 = 
   NFA_remove_unreachable_states 
   (NFA_concatenation (NFA_rename_states \<A>1 f1) 
                      (NFA_rename_states \<A>2 f2))"


lemma NFA_isomorphic_efficient_NFA_rename_concatenation :
assumes equiv_1: "NFA_isomorphic_wf \<A>1 \<A>1'"
    and equiv_2: "NFA_isomorphic_wf \<A>2 \<A>2'"
    and  inj_f1: "inj_on f1 (\<Q> \<A>1)"
    and  inj_f2: "inj_on f2 (\<Q> \<A>2)"
    and  inj_f1': "inj_on f1' (\<Q> \<A>1')"
    and  inj_f2': "inj_on f2' (\<Q> \<A>2')"
    and disjoint1: "f1 ` (\<Q> \<A>1) \<inter> f2 ` (\<Q> \<A>2) = {}"
    and disjoint2: "f1' ` (\<Q> \<A>1') \<inter> f2' ` (\<Q> \<A>2') = {}"
shows "NFA_isomorphic_wf 
    (efficient_NFA_rename_concatenation f1 f2 \<A>1 \<A>2) 
    (efficient_NFA_rename_concatenation f1' f2' \<A>1' \<A>2')"
   unfolding efficient_NFA_rename_concatenation_def
   apply (rule NFA_isomorphic_wf___NFA_remove_unreachable_states)
   apply (rule_tac NFA_isomorphic_NFA_concatenation)
   apply (simp_all add: equiv_1 equiv_2 disjoint1 disjoint2)
   apply (simp add: NFA_isomorphic_wf___rename_states_cong equiv_1 inj_f1 inj_f1')
   by (simp add: NFA_isomorphic_wf___rename_states_cong equiv_2 inj_f2 inj_f2') 

lemma NFA_concate_rename___isomorphic_wf :
"NFA \<A>1 \<Longrightarrow> NFA \<A>2 \<Longrightarrow> \<Q> \<A>1 \<inter> \<Q> \<A>2 = {} \<Longrightarrow>
 inj_on f1 (\<Q> \<A>1) \<Longrightarrow> inj_on f2 (\<Q> \<A>2) \<Longrightarrow>
 f1 ` (\<Q> \<A>1) \<inter> f2 ` (\<Q> \<A>2) = {} \<Longrightarrow>
 NFA_isomorphic_wf (efficient_NFA_rename_concatenation f1 f2 \<A>1 \<A>2) 
                   (NFA_concate \<A>1 \<A>2)"
  unfolding NFA_isomorphic_def NFA_concate_def
proof -
  assume p1: "NFA \<A>1"
     and p2: "NFA \<A>2"
     and p3: "\<Q> \<A>1 \<inter> \<Q> \<A>2 = {}"
     and p4: "inj_on f1 (\<Q> \<A>1)"
     and p5: "inj_on f2 (\<Q> \<A>2)"
     and p6: "f1 ` \<Q> \<A>1 \<inter> f2 ` \<Q> \<A>2 = {}"

  from p1
  have c1: "NFA_isomorphic_wf \<A>1 (NFA_rename_states \<A>1 f1)"
    by (simp add: NFA_isomorphic_wf___NFA_rename_states p4)

  from p2
  have c2: "NFA_isomorphic_wf \<A>2 (NFA_rename_states \<A>2 f2)"
    by (simp add: NFA_isomorphic_wf___NFA_rename_states p5)

  have c3: "NFA_isomorphic_wf \<A>1 \<A>1" 
    by (simp add: NFA_isomorphic_wf_refl p1)
  have c4: "NFA_isomorphic_wf \<A>2 \<A>2" 
    by (simp add: NFA_isomorphic_wf_refl p2)

  have c5 : "inj_on id (\<Q> \<A>1)"
    by fastforce
  have c6 : "inj_on id (\<Q> \<A>2)"
    by fastforce

  have c7: "efficient_NFA_rename_concatenation id id \<A>1 \<A>2 = 
           efficient_NFA_concatenation \<A>1 \<A>2"
    by (simp add: efficient_NFA_concatenation_def efficient_NFA_rename_concatenation_def)

  from p1 p2
  have c8: "NFA (efficient_NFA_concatenation \<A>1 \<A>2)"
    by (simp add: efficient_NFA_concatenation___is_well_formed p3)

  from NFA_isomorphic_efficient_NFA_rename_concatenation
      [OF c3 c4 c5 c6 p4 p5] this p3 p6 c7
  have c1: "NFA_isomorphic_wf (efficient_NFA_concatenation \<A>1 \<A>2)
     (efficient_NFA_rename_concatenation f1 f2 \<A>1 \<A>2)"
    by force

  from this NFA_isomorphic_wf_normalise_states
            [of "efficient_NFA_concatenation \<A>1 \<A>2"] c8
  show "NFA_isomorphic_wf (efficient_NFA_rename_concatenation f1 f2 \<A>1 \<A>2)
     (NFA_normalise_states (efficient_NFA_concatenation \<A>1 \<A>2))"
    using NFA_isomorphic_wf___NFA_normalise_states NFA_isomorphic_wf_sym by blast
qed


end













