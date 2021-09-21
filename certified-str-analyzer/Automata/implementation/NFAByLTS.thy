section \<open> "Implementing Finite Automata using Labelled Transition Systems" \<close>


theory NFAByLTS
imports "Collections.Collections" "HOL.Enum"
      "../../General/Accessible_Impl"
  LTSSpec LTSGA NFASpec LTS_Impl
begin

subsection \<open> Locales for NFAs and a common locale \<close>

locale automaton_by_lts_syntax = 
  s: StdSetDefs s_ops   (* Set operations on states *) +
  l: StdSetDefs l_ops   (* Set operations on labels *) +
  d: StdCommonLTSDefs d_ops "(\<in>)" (* An LTS *) 
  for s_ops::"('q::{NFA_states},'q_set,_) set_ops_scheme"
  and l_ops::"('a,'a_set,_) set_ops_scheme"
  and d_ops::"('q,'a set,'a,'d,_) common_lts_ops_scheme" 



locale automaton_by_lts_defs = automaton_by_lts_syntax 
      s_ops l_ops d_ops +
  s: StdSet s_ops (* Set operations on states *) +
  l: StdSet l_ops (* Set operations on labels *) +
  d: StdCommonLTS d_ops "(\<in>)" (* An LTS *) 
  for s_ops::"('q::{NFA_states},'q_set,_) set_ops_scheme"
  and l_ops::"('a,'a_set,_) set_ops_scheme"
  and d_ops::"('q,'a set,'a,'d,_) common_lts_ops_scheme" 
   

locale nfa_by_lts_defs = automaton_by_lts_defs s_ops l_ops d_ops + 
  s: StdSet s_ops (* Set operations on states *) +
  l: StdSet l_ops (* Set operations on labels *) +
  d: StdLTS d_ops "(\<in>)"(* An LTS *) 
  for s_ops::"('q :: {NFA_states},'q_set,_) set_ops_scheme"
  and l_ops::"('a,'a_set,_) set_ops_scheme"
  and d_ops::"('q,'a set,'a,'d,_) lts_ops_scheme"


lemma nfa_by_lts_defs___sublocale :
  "nfa_by_lts_defs s_ops l_ops d_ops \<Longrightarrow>
   automaton_by_lts_defs s_ops l_ops d_ops"
  unfolding nfa_by_lts_defs_def automaton_by_lts_defs_def
  by (simp add: StdLTS_sublocale)


locale nfa_dfa_by_lts_defs = 
  s: StdSet s_ops (* Set operations on states *) +
  l: StdSet l_ops (* Set operations on labels *) +
  d_nfa: StdLTS d_nfa_ops "(\<in>)" (* An LTS *)
  for s_ops::"('q::{NFA_states},'q_set,_) set_ops_scheme"
  and l_ops::"('a,'a_set,_) set_ops_scheme"
  and d_nfa_ops::"('q,'a set,'a,'d_nfa,_) lts_ops_scheme" 

  sublocale nfa_dfa_by_lts_defs < 
          nfa: nfa_by_lts_defs 
          s_ops l_ops d_nfa_ops by unfold_locales


context automaton_by_lts_syntax
begin

definition nfa_states :: "'q_set \<times> 'a_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> 'q_set" where
  "nfa_states A = fst A"
lemma [simp]: "nfa_states (Q, A, D, I, F) = Q" by (simp add: nfa_states_def)

definition nfa_labels :: "'q_set \<times> 'a_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> 'a_set" where
  "nfa_labels A = fst (snd A)"
lemma [simp]: "nfa_labels (Q, A, D, I, F) = A" by (simp add: nfa_labels_def)

definition nfa_trans :: "'q_set \<times> 'a_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> 'd" where
  "nfa_trans A = fst (snd (snd A))"
lemma [simp]: "nfa_trans (Q, A, D, I, F) = D" by (simp add: nfa_trans_def)

definition nfa_initial :: "'q_set \<times> 'a_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> 'q_set" where
  "nfa_initial A = fst (snd (snd (snd A)))"
lemma [simp]: "nfa_initial (Q, A, D, I, F) = I" by (simp add: nfa_initial_def)

definition nfa_accepting :: "'q_set \<times> 'a_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> 'q_set" where
  "nfa_accepting A = snd (snd (snd (snd A)))"
lemma [simp]: "nfa_accepting (Q, A, D, I, F) = F" by (simp add: nfa_accepting_def)

lemmas nfa_selectors_def = nfa_accepting_def nfa_states_def nfa_labels_def nfa_trans_def nfa_initial_def


definition nfa_\<alpha> :: "'q_set \<times> 'a_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> ('q, 'a) NFA_rec" where
  "nfa_\<alpha> A =
   \<lparr> \<Q> = s.\<alpha> (nfa_states A), 
     \<Sigma> = l.\<alpha> (nfa_labels A), 
     \<Delta> = d.\<alpha> (nfa_trans A),
     \<I> = s.\<alpha> (nfa_initial A), 
     \<F> = s.\<alpha> (nfa_accepting A) \<rparr>"

lemma nfa_\<alpha>_simp [simp] :
  "\<Q> (nfa_\<alpha> A) = s.\<alpha> (nfa_states A) \<and>
   \<Sigma> (nfa_\<alpha> A) = l.\<alpha> (nfa_labels A) \<and>
   \<Delta> (nfa_\<alpha> A) = d.\<alpha> (nfa_trans A) \<and>
   \<I> (nfa_\<alpha> A) = s.\<alpha> (nfa_initial A) \<and>
   \<F> (nfa_\<alpha> A) = s.\<alpha> (nfa_accepting A)"
by (simp add: nfa_\<alpha>_def)

definition nfa_invar :: "'q_set \<times> 'a_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> bool" where
  "nfa_invar A =
   (s.invar (nfa_states A) \<and>
    l.invar (nfa_labels A) \<and>
    d.invar (nfa_trans A) \<and>
    s.invar (nfa_initial A) \<and> 
    s.invar (nfa_accepting A))"

definition nfa_invar_NFA :: "'q_set \<times> 'a_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> bool" where
  "nfa_invar_NFA A \<equiv> (nfa_invar A \<and> NFA (nfa_\<alpha> A))"

end



context automaton_by_lts_defs
begin

lemma nfa_by_map_correct [simp]: 
    "nfa nfa_\<alpha> nfa_invar_NFA"    
    unfolding nfa_def nfa_invar_NFA_def
    by simp



subsection \<open> Constructing Automata \<close>

definition nfa_construct_aux ::
  "'q_set \<times> 'a_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> 'q \<times> 'a list \<times> 'q \<Rightarrow> 
   'q_set \<times> 'a_set \<times> 'd \<times> 'q_set \<times> 'q_set" where 
   "nfa_construct_aux = (\<lambda>(Q, A, D, I, F) (q1, l, q2).
    (s.ins q1 (s.ins q2 Q), 
     foldl (\<lambda>s x. l.ins x s) A l,
      d.add q1 (set l) q2 D,
     I, F))"

lemma nfa_construct_aux_correct :
fixes q1 q2
(* defines "q1_l_q2_OK \<equiv> 
    (\<lambda>l DL. (\<forall> q2'. q2' \<noteq> q2 \<longrightarrow> (q1, set l, q2') \<notin> d.\<alpha> DL))" *)
assumes invar: "nfa_invar A"
    and d_add_OK: (* "\<not> q1_l_q2_OK l (nfa_trans A) \<longrightarrow> *)
        "lts_add d.\<alpha> d.invar d.add"
shows "nfa_invar (nfa_construct_aux A (q1, l, q2))"
      "nfa_\<alpha> (nfa_construct_aux A (q1, l, q2)) =
              construct_NFA_aux (nfa_\<alpha> A) (q1, l, q2)"
proof -
  obtain QL AL DL IL FL 
     where A_eq[simp]: "A = (QL, AL, DL, IL, FL)" by (cases A, blast)
  
  have AL_OK: "l.invar AL \<Longrightarrow> 
               l.invar (foldl (\<lambda>s x. l.ins x s) AL l) \<and>
               l.\<alpha> (foldl (\<lambda>s x. l.ins x s) AL l) = l.\<alpha> AL \<union> set l"
    by (induct l arbitrary: AL, simp_all add: l.correct)

  have DL_OK : "d.invar DL \<Longrightarrow> 
     (lts_add d.\<alpha> d.invar d.add) \<Longrightarrow>
                d.invar (d.add q1 (set l) q2 DL) \<and>
                d.\<alpha> (d.add q1 (set l) q2 DL) =
                d.\<alpha> DL \<union> {(q1, (set l), q2)}"
    proof -
      assume add_OK: "lts_add d.\<alpha> d.invar d.add" 
      assume invard: "d.invar DL" 
      then show ?thesis
        by (auto simp add: lts_add.lts_add_correct[OF add_OK invard] invar)
    qed

  from AL_OK DL_OK invar d_add_OK
  show "nfa_\<alpha> (nfa_construct_aux A (q1, l, q2)) = construct_NFA_aux (nfa_\<alpha> A) (q1, l, q2)"
       "nfa_invar (nfa_construct_aux A (q1, l, q2))"
  by (simp_all add: nfa_construct_aux_def nfa_\<alpha>_def s.correct nfa_invar_def)
qed

fun nfa_construct where
   "nfa_construct (QL, AL, DL, IL, FL) =
    foldl nfa_construct_aux 
     (s.from_list (QL @ IL @ FL),
      l.from_list AL,
      d.empty,
      s.from_list IL,
      s.from_list FL) DL"
declare nfa_construct.simps [simp del]


lemma nfa_construct_correct_gen :
fixes ll :: "'q list \<times> 'a list \<times> ('q \<times> 'a list \<times> 'q) list \<times> 'q list \<times> 'q list"
assumes d_add_OK: "lts_add d.\<alpha> d.invar d.add"
shows "nfa_invar (nfa_construct ll)"
      "nfa_\<alpha> (nfa_construct ll) = NFA_construct ll" 
proof -
  obtain QL AL DL IL FL where l_eq[simp]: 
      "ll = (QL, AL, DL, IL, FL)" by (cases ll, blast)
  let ?A = 
      "(s.from_list (QL @ IL @ FL), l.from_list AL,  d.empty, s.from_list IL, 
        s.from_list FL)"

  have A_invar: "nfa_invar ?A" 
     unfolding nfa_invar_def by (simp add: s.correct l.correct d.correct_common)
  have A_\<alpha>: "nfa_\<alpha> ?A = \<lparr>\<Q> = set (QL @ IL @ FL), \<Sigma> = set AL, \<Delta> = {}, \<I> = set IL, \<F> = set FL\<rparr>"
    by (simp add: nfa_\<alpha>_def s.correct d.correct_common l.correct)
(*
  define q1_l_q2_OK where "q1_l_q2_OK = 
    (\<lambda>(q1, l, q2) DL. (\<forall>q2'. q2' \<noteq> q2 \<longrightarrow> (q1, set l, q2') \<notin> d.\<alpha> DL))"
*)
  { fix A DL'
    have " nfa_invar A \<Longrightarrow> set DL' \<subseteq> set DL \<Longrightarrow>
        (lts_add d.\<alpha> d.invar d.add) \<Longrightarrow>
        nfa_invar (foldl nfa_construct_aux A DL') \<and>
        nfa_\<alpha> (foldl nfa_construct_aux A DL') =
        foldl construct_NFA_aux (nfa_\<alpha> A) DL'"
    proof (induct DL' arbitrary: A)
      case Nil thus ?case by simp
    next
      case (Cons qlq DL')
      note ind_hyp = Cons(1)
      note invar_A = Cons(2)
      note set_DL'_subset = Cons(3)
      note d_add_OK' = Cons(4)

      let ?A' = "nfa_construct_aux A qlq"
      obtain q1 l q2 where qlq_eq[simp]: "qlq = (q1,  l, q2)" by (metis prod.exhaust)
      thm nfa_construct_aux_correct
      note aux_correct = nfa_construct_aux_correct 
          [of A q1 l q2, OF invar_A d_add_OK]
      moreover
      from aux_correct have 
         "d.\<alpha> (nfa_trans (nfa_construct_aux A (q1, l, q2))) =
          d.\<alpha> (nfa_trans A) \<union> {(q1, set l, q2)}"
        by (simp add: nfa_\<alpha>_def)
      
      from ind_hyp [of ?A'] aux_correct  set_DL'_subset d_add_OK
      show ?case by auto
    qed
  } note step = this [of ?A DL]

  with A_\<alpha> A_invar show \<alpha>_OK: "nfa_\<alpha> (nfa_construct ll) = NFA_construct ll" 
                    and weak_invar: "nfa_invar (nfa_construct ll)" 
    by (simp_all add: nfa_construct.simps NFA_construct.simps 
          Ball_def d.correct_common d_add_OK)
qed


lemma (in nfa_by_lts_defs) nfa_construct_correct :
  "nfa_from_list nfa_\<alpha> nfa_invar_NFA nfa_construct"
proof -
   from nfa_by_lts_defs_axioms have "lts_add d.\<alpha> d.invar d.add" 
     unfolding nfa_by_lts_defs_def StdLTS_def by simp
   with nfa_construct_correct_gen
   show ?thesis
     apply (intro nfa_from_list.intro nfa_by_map_correct nfa_from_list_axioms.intro)
     apply (simp_all add: nfa_invar_NFA_def NFA_construct___is_well_formed)
   done
qed
end


subsection \<open> Acceptance \<close>

context automaton_by_lts_defs 
begin

definition accept_impl where
   "accept_impl A w = 
    s.bex (nfa_initial A) (\<lambda>i. d.is_reachable_impl
       (nfa_trans A) i w (\<lambda>q. s.memb q (nfa_accepting A)))"

lemma accept_impl_code :
   "accept_impl = (\<lambda>(Q1, A1, D1, I1, F1) w.
    s.bex I1 (\<lambda>i. d.is_reachable_impl D1 i w (\<lambda>q. s.memb q F1)))"
  by (simp add: fun_eq_iff accept_impl_def nfa_selectors_def)

lemma is_reachable_impl_correct :
  shows "d.invar l \<Longrightarrow>
   d.is_reachable_impl l q w Q =
   (\<exists>q'. Q q' \<and> LTS_is_reachable (d.\<alpha> l) q w q')"
   apply (induct w arbitrary: q)
   apply (simp_all add: d.correct_common)
   apply (auto) 
done
  
lemma accept_impl_correct :
  "nfa_accept nfa_\<alpha> nfa_invar_NFA accept_impl"
  unfolding nfa_accept_def nfa_accept_axioms_def nfa_invar_NFA_def nfa_invar_def
  apply (simp_all add: NFA.NFA_accept_wf_def Bex_def accept_impl_def s.correct 
              is_reachable_impl_correct nfa_def)
  done

end


subsection \<open> Remove states \<close>

context automaton_by_lts_defs

begin

fun remove_states_impl where
  "remove_states_impl (Q, A, D, I, F) S =
   (s.diff Q S, A, 
    d.filter (\<lambda> q. \<not> (s.memb q S)) (\<lambda>_. True)
             (\<lambda> q. \<not> (s.memb q S)) (\<lambda> t. (fst (snd t)) \<noteq> {}) D,
              s.diff I S, s.diff F S)"

lemma remove_states_impl_correct :
  "nfa_remove_states nfa_\<alpha> nfa_invar_NFA s.\<alpha> s.invar remove_states_impl"
proof (intro nfa_remove_states.intro 
             nfa_remove_states_axioms.intro 
             nfa_by_map_correct)
  fix n S
  assume invar_S: "s.invar S"
  assume invar: "nfa_invar_NFA n"
  obtain QL AL DL IL FL where l_eq[simp]: 
        "n = (QL, AL, DL, IL, FL)" by (cases n, blast)

  from invar have invar_weak: "nfa_invar n" and wf: "NFA (nfa_\<alpha> n)" 
    unfolding nfa_invar_NFA_def by simp_all
  from invar_weak invar_S
  have "nfa_invar (remove_states_impl n S) \<and> 
        nfa_\<alpha> (remove_states_impl n S) = NFA_remove_states (nfa_\<alpha> n) (s.\<alpha> S)"
    apply (simp add: nfa_invar_def nfa_\<alpha>_def s.correct 
           NFA_remove_states_def d.correct_common)
    
    done
  thus "nfa_\<alpha> (remove_states_impl n S) = NFA_remove_states (nfa_\<alpha> n) (s.\<alpha> S)" 
       "nfa_invar_NFA (remove_states_impl n S)"
    unfolding nfa_invar_NFA_def 
    using NFA_remove_states___is_well_formed[OF wf, of "s.\<alpha> S"]
      by (simp_all add: NFA_remove_states___is_well_formed)
qed

end


subsection \<open> Rename states \<close>

context automaton_by_lts_defs 
begin

fun rename_states_impl where
  "rename_states_impl im im2 (Q, A, D, I, F) = (\<lambda>f.
   (im f Q, A, 
    im2 (\<lambda>qaq. (f (fst qaq), fst (snd qaq), f (snd (snd qaq)))) D,
    im f I, im f F))"
declare rename_states_impl.simps[simp del]

lemma rename_states_impl_correct :
assumes wf_target: "nfa_by_lts_defs s_ops' l_ops d_ops'" 
assumes im_OK: "set_image s.\<alpha> s.invar (set_op_\<alpha> s_ops') (set_op_invar s_ops') im"
assumes im2_OK: "lts_image d.\<alpha> d.invar (clts_op_\<alpha> d_ops') (clts_op_invar d_ops') im2"
shows "nfa_rename_states nfa_\<alpha> nfa_invar_NFA 
           (automaton_by_lts_syntax.nfa_\<alpha> s_ops' l_ops d_ops') 
           (automaton_by_lts_syntax.nfa_invar_NFA s_ops' l_ops d_ops') 
           (rename_states_impl im im2)"
proof (intro nfa_rename_states.intro nfa_rename_states_axioms.intro 
             automaton_by_lts_defs.nfa_by_map_correct)
  show "automaton_by_lts_defs s_ops l_ops d_ops" by (fact automaton_by_lts_defs_axioms)
  show "automaton_by_lts_defs s_ops' l_ops d_ops'" by (intro nfa_by_lts_defs___sublocale wf_target)

  fix n f
  assume invar: "nfa_invar_NFA n"
  obtain QL AL DL IL FL where n_eq[simp]: "n = (QL, AL, DL, IL, FL)" by (cases n, blast)

  interpret s': StdSet s_ops' using wf_target unfolding nfa_by_lts_defs_def by simp
  interpret d': StdLTS d_ops' "(\<in>)" 
          using wf_target unfolding nfa_by_lts_defs_def by simp
  interpret im: set_image s.\<alpha> s.invar s'.\<alpha> s'.invar im by fact
  interpret im2: lts_image d.\<alpha> d.invar d'.\<alpha> d'.invar im2 by fact

  from invar have invar_weak: "nfa_invar n" and wf: "NFA (nfa_\<alpha> n)" 
    unfolding nfa_invar_NFA_def by simp_all

  let ?nfa_\<alpha>' = "automaton_by_lts_syntax.nfa_\<alpha> s_ops' l_ops d_ops'"
  let ?nfa_invar' = "automaton_by_lts_syntax.nfa_invar s_ops' l_ops d_ops'"
  let ?nfa_invar_NFA' = "automaton_by_lts_syntax.nfa_invar_NFA s_ops' l_ops d_ops'"

  from invar_weak 
  have "?nfa_invar' (rename_states_impl im im2 n f) \<and> 
        ?nfa_\<alpha>' (rename_states_impl im im2 n f) = NFA_rename_states (nfa_\<alpha> n) f"
    apply (simp add: automaton_by_lts_syntax.nfa_invar_def automaton_by_lts_syntax.nfa_\<alpha>_def 
                     automaton_by_lts_syntax.nfa_selectors_def
                     s.correct NFA_rename_states_def d.correct_common
                     im.image_correct im2.lts_image_correct rename_states_impl.simps)
    apply (auto simp add: image_iff Bex_def)
    apply metis+
  done

  thus "?nfa_\<alpha>' (rename_states_impl im im2 n f) = NFA_rename_states (nfa_\<alpha> n) f" 
       "?nfa_invar_NFA' (rename_states_impl im im2 n f)"
    unfolding automaton_by_lts_syntax.nfa_invar_NFA_def 
    using NFA_rename_states___is_well_formed[OF wf, of f]
      by (simp_all add: NFA_remove_states___is_well_formed)
qed

lemma (in nfa_by_lts_defs) rename_states_impl_correct___self :
assumes im_OK: "set_image s.\<alpha> s.invar s.\<alpha> s.invar im"
shows "nfa_rename_states nfa_\<alpha> nfa_invar_NFA 
           nfa_\<alpha> nfa_invar_NFA
           (rename_states_impl im d.image)"
apply (rule rename_states_impl_correct)
apply (simp_all add: nfa_by_lts_defs_axioms im_OK d.lts_image_axioms)
done

end

subsection \<open> Rename labels \<close> 

context automaton_by_lts_defs 
begin

fun rename_labels_impl_gen where
  "rename_labels_impl_gen im (Q, A, D, I, F) A' f =
   (Q, A', 
    im (\<lambda>qaq. ((fst qaq), f ` (fst (snd qaq)), (snd (snd qaq)))) D,
    I, F)"
declare rename_labels_impl_gen.simps [simp del]

definition rename_labels_impl where
  "rename_labels_impl im im2 = (\<lambda>(Q, A, D, I, F) f.
   rename_labels_impl_gen im (Q, A, D, I, F) (im2 f A) f)"

lemma rename_labels_impl_gen_correct :
fixes l_ops' :: "('a2, 'a2_set, _) set_ops_scheme"
assumes wf_target: "nfa_by_lts_defs s_ops l_ops' d_ops'" 
assumes im_OK: "lts_image d.\<alpha> d.invar (clts_op_\<alpha> d_ops') (clts_op_invar d_ops') im"
shows "nfa_rename_labels_gen nfa_\<alpha> nfa_invar_NFA 
           (automaton_by_lts_syntax.nfa_\<alpha> s_ops l_ops' d_ops') 
           (automaton_by_lts_syntax.nfa_invar_NFA s_ops l_ops' d_ops')
           (set_op_\<alpha> l_ops') (set_op_invar l_ops') 
           (rename_labels_impl_gen im)"
proof (intro nfa_rename_labels_gen.intro nfa_rename_labels_gen_axioms.intro 
             automaton_by_lts_defs.nfa_by_map_correct)
  show "automaton_by_lts_defs s_ops l_ops d_ops" by (fact automaton_by_lts_defs_axioms)
  show "automaton_by_lts_defs s_ops l_ops' d_ops'" by (intro nfa_by_lts_defs___sublocale wf_target)

  interpret l': StdSet l_ops' using wf_target unfolding nfa_by_lts_defs_def by simp
  interpret d': StdLTS d_ops' "(\<in>)" using wf_target unfolding nfa_by_lts_defs_def by simp
  interpret im: lts_image d.\<alpha> d.invar d'.\<alpha> d'.invar im by fact

  fix n AL' and f :: "'a \<Rightarrow> 'a2"
  assume invar: "nfa_invar_NFA n"
     and AL'_OK : "l'.invar AL'" "l'.\<alpha> AL' = f ` \<Sigma> (nfa_\<alpha> n)" 
  obtain QL AL DL IL FL where l_eq[simp]: "n = (QL, AL, DL, IL, FL)" by (cases n, blast)

  from invar have invar_weak: "nfa_invar n" and wf: "NFA (nfa_\<alpha> n)" 
    unfolding nfa_invar_NFA_def by simp_all

  let ?nfa_\<alpha>' = "automaton_by_lts_syntax.nfa_\<alpha> s_ops l_ops' d_ops'"
  let ?nfa_invar' = "automaton_by_lts_syntax.nfa_invar s_ops l_ops' d_ops'"
  let ?nfa_invar_NFA' = "automaton_by_lts_syntax.nfa_invar_NFA s_ops l_ops' d_ops'"

  from invar_weak AL'_OK
  have "?nfa_invar' (rename_labels_impl_gen im n AL' f) \<and> 
        ?nfa_\<alpha>' (rename_labels_impl_gen im n AL' f) = NFA_rename_labels (nfa_\<alpha> n) f"
    apply (simp add: automaton_by_lts_syntax.nfa_invar_def automaton_by_lts_syntax.nfa_\<alpha>_def 
                     automaton_by_lts_syntax.nfa_selectors_def
                     s.correct NFA_rename_labels_def d.correct_common
                     im.lts_image_correct rename_labels_impl_gen.simps)
    apply (auto simp add: image_iff Bex_def)
    apply blast
  done

  thus "?nfa_\<alpha>' (rename_labels_impl_gen im n AL' f) = NFA_rename_labels (nfa_\<alpha> n) f" 
       "?nfa_invar_NFA' (rename_labels_impl_gen im n AL' f)"
    unfolding automaton_by_lts_syntax.nfa_invar_NFA_def
    using NFA.NFA_rename_labels___is_well_formed[OF wf, of f]
      by (simp_all add: NFA_remove_states___is_well_formed)
qed

lemma rename_labels_impl_correct :
fixes l_ops' :: "('a2, 'a2_set, _) set_ops_scheme"
assumes wf_target: "nfa_by_lts_defs s_ops l_ops' d_ops'" 
assumes im_OK: "lts_image d.\<alpha> d.invar (clts_op_\<alpha> d_ops') (clts_op_invar d_ops') im"
assumes im2_OK: "set_image l.\<alpha> l.invar (set_op_\<alpha> l_ops') (set_op_invar l_ops') im2"
shows "nfa_rename_labels nfa_\<alpha> nfa_invar_NFA 
           (automaton_by_lts_syntax.nfa_\<alpha> s_ops l_ops' d_ops') 
           (automaton_by_lts_syntax.nfa_invar_NFA s_ops l_ops' d_ops')
           (rename_labels_impl im im2)"
proof -
  note labels_gen_OK = rename_labels_impl_gen_correct [OF wf_target im_OK]

  let ?im2' = "\<lambda>(QL, AL, DL, IL, FL) f. im2 f AL"

  have pre_OK: "\<And>n f. nfa_invar_NFA n \<Longrightarrow>
       set_op_invar l_ops' (?im2' n f) \<and>
       set_op_\<alpha> l_ops' (?im2' n f) = f ` \<Sigma> (nfa_\<alpha> n)" 
    using im2_OK
    unfolding nfa_invar_NFA_def set_image_def nfa_invar_def
    by auto

  have post_OK: "(\<lambda>AA f. rename_labels_impl_gen im AA ((\<lambda>(QL, AL, DL, IL, FL) f. im2 f AL) AA f) f) = 
        rename_labels_impl im im2" 
    unfolding rename_labels_impl_def by auto

  from nfa_rename_labels_gen_impl[OF labels_gen_OK, of ?im2', OF pre_OK] 
  show ?thesis unfolding post_OK by simp
qed


lemma (in nfa_by_lts_defs) rename_labels_impl_correct___self :
assumes im_OK: "set_image l.\<alpha> l.invar l.\<alpha> l.invar im"
shows "nfa_rename_labels 
           nfa_\<alpha> nfa_invar_NFA 
           nfa_\<alpha> nfa_invar_NFA 
           (rename_labels_impl d.image im)"
by (fact rename_labels_impl_correct [OF nfa_by_lts_defs_axioms d.lts_image_axioms im_OK])

end


subsection \<open> construct reachable NFA \<close>

locale NFA_construct_reachable_locale = 
  automaton_by_lts_defs s_ops l_ops d_ops +
  qm: StdMap qm_ops (* The index max *)
  for s_ops::"('q::{NFA_states},'q_set,_) set_ops_scheme"
  and l_ops::"('a,'a_set,_) set_ops_scheme"
  and d_ops::"('q,'a set, 'a, 'd,_) common_lts_ops_scheme"
  and qm_ops :: "('i, 'q::{NFA_states}, 'm, _) map_ops_scheme" +
  fixes f :: "'q2 \<Rightarrow> 'i"
    and ff :: "'q2_rep \<Rightarrow> 'i"
    and q2_\<alpha> :: "'q2_rep \<Rightarrow> 'q2"  
    and q2_invar :: "'q2_rep \<Rightarrow> bool" 
begin

text \<open> the pair (qm,n) denotes a map qm and the keys are the range 
       0 ... n - 1.
       state_map_\<alpha> is map from a state q to another state q'.
       firstly, the function f maps q to i and then qm maps i to another state q'.
  \<close>

definition state_map_\<alpha> where "state_map_\<alpha> \<equiv> (\<lambda>(qm, n::nat). qm.\<alpha> qm \<circ> f)"
definition state_map_invar where "state_map_invar \<equiv> (\<lambda>(qm, n). qm.invar qm \<and> 
         (\<forall>i q. qm.\<alpha> qm i = Some q \<longrightarrow> (\<exists>n' < n. q = states_enumerate n')))"


lemma state_map_extend_thm:
fixes n qm q
defines "qm'' \<equiv> qm.update_dj (f q) (states_enumerate n) qm"
assumes f_inj_on: "inj_on f S"
    and invar_qm_n: "state_map_invar (qm, n)"
    and q_in_S: "q \<in> S"
    and q_nin_dom: "q \<notin> dom (state_map_\<alpha> (qm, n))"
    and map_OK : "NFA_construct_reachable_map_OK 
                  S Map.empty {} 
                  (state_map_\<alpha> (qm, n))"
shows "state_map_invar (qm'', Suc n)"
      "qm.\<alpha> qm'' = qm.\<alpha> qm ((f q) \<mapsto> states_enumerate n)"
      "NFA_construct_reachable_map_OK S 
          (state_map_\<alpha> (qm, n)) 
          {q} (state_map_\<alpha> (qm'', Suc n))"
      "S \<inter> dom (state_map_\<alpha> (qm'', Suc n)) = 
         insert q ((dom (state_map_\<alpha> (qm, n))) \<inter> S)"
proof -
  from invar_qm_n have invar_qm: "qm.invar qm" unfolding state_map_invar_def by simp

  from q_nin_dom have fq_nin_dom_rm: "f q \<notin> dom (qm.\<alpha> qm)"
    unfolding state_map_\<alpha>_def by (simp add: dom_def)

  have qm''_props: "qm.invar qm''" "qm.\<alpha> qm'' = qm.\<alpha> qm(f q \<mapsto> states_enumerate n)"
    using qm.update_dj_correct [OF invar_qm fq_nin_dom_rm]
    by (simp_all add: qm''_def)  
  show "qm.\<alpha> qm'' = qm.\<alpha> qm(f q \<mapsto> states_enumerate n)" by (fact qm''_props(2))

  show invar_qm''_n: "state_map_invar (qm'', Suc n)"
    using invar_qm_n
    by (simp add: state_map_invar_def qm''_props) (metis less_Suc_eq)

  have rm''_q: "state_map_\<alpha> (qm'', Suc n) q = Some (states_enumerate n)"
    unfolding state_map_\<alpha>_def by (simp add: qm''_props)

  have dom_sub: "insert q (dom (state_map_\<alpha> (qm, n))) \<subseteq> dom (state_map_\<alpha> (qm'', Suc n))"
    unfolding state_map_\<alpha>_def 
    by (simp add: subset_iff dom_def qm''_props o_def)

  show dom_eq: "S \<inter> dom (state_map_\<alpha> (qm'', Suc n)) = insert q ((dom (state_map_\<alpha> (qm, n))) \<inter> S)"
      (is "?ls = ?rs")
  proof (intro set_eqI iffI)
    fix q'
    assume "q' \<in> ?rs" 
    with q_in_S dom_sub show "q' \<in> ?ls" by auto
  next
    fix q'
    assume "q' \<in> ?ls"
    hence q'_in_S: "q' \<in> S" and q'_in_dom: "q' \<in> dom (state_map_\<alpha> (qm'', Suc n))" by simp_all

    from f_inj_on q_in_S q'_in_S have fqq'[simp]: "f q' = f q \<longleftrightarrow> q' = q"
      unfolding inj_on_def by auto

    from q'_in_dom have "q' = q \<or> q' \<in> (dom (state_map_\<alpha> (qm, n)))" unfolding state_map_\<alpha>_def
      by (auto simp add: qm''_props o_def dom_def)
    with q'_in_S show "q' \<in> ?rs" by auto
  qed

  have qm''_inj_on: "inj_on (state_map_\<alpha> (qm'', Suc n)) (S \<inter> dom (state_map_\<alpha> (qm'', Suc n)))"
  proof (rule inj_onI)
    fix q' q''
    assume q'_in: "q' \<in> S \<inter> dom (state_map_\<alpha> (qm'', Suc n))"
    assume q''_in: "q'' \<in> S \<inter> dom (state_map_\<alpha> (qm'', Suc n))"
    assume state_map_\<alpha>_eq: "state_map_\<alpha> (qm'', Suc n) q' = state_map_\<alpha> (qm'', Suc n) q''"
 
    { fix q'''
      assume in_dom: "q''' \<in> S \<inter> dom (state_map_\<alpha> (qm, n))"

      from in_dom q_nin_dom have "q''' \<noteq> q" by auto
      with f_inj_on q_in_S in_dom have f_q'''_neq: "f q''' \<noteq> f q"
        unfolding inj_on_def by auto
            
      have prop1: "state_map_\<alpha> (qm'', Suc n) q''' = state_map_\<alpha> (qm, n) q'''" 
        unfolding state_map_\<alpha>_def
        by (simp add: o_def qm''_props f_q'''_neq)

      from invar_qm_n in_dom obtain n' where "n' < n" and 
           "state_map_\<alpha> (qm, n) q''' = Some (states_enumerate n')" 
        unfolding state_map_invar_def dom_def state_map_\<alpha>_def by auto

      with prop1 have prop2: "state_map_\<alpha> (qm'', Suc n) q''' \<noteq> state_map_\<alpha> (qm'', Suc n) q"
        by (simp add: rm''_q states_enumerate_eq)

      note prop1 prop2
    } note qm''_\<alpha>_props = this

    show "q' = q''"
    proof (cases "q' = q")
      case True note q'_eq[simp] = this
      show ?thesis
      proof (cases "q'' = q")
        case True thus ?thesis by simp
      next
        case False with q''_in dom_eq 
        have "q'' \<in> S \<inter> (dom (state_map_\<alpha> (qm, n)))" by simp
        with qm''_\<alpha>_props(2) [of q''] state_map_\<alpha>_eq have "False" by simp
        thus ?thesis ..
      qed
    next
      case False with q'_in dom_eq 
      have q'_in_dom_qm: "q' \<in> (S \<inter> dom (state_map_\<alpha> (qm, n)))" by simp
      show ?thesis
      proof (cases "q'' = q")
        case True 
        with qm''_\<alpha>_props(2) [of q'] state_map_\<alpha>_eq q'_in_dom_qm have "False" by simp
        thus ?thesis ..
      next
        case False with q''_in dom_eq 
        have q''_in_dom_qm: "q'' \<in> (S \<inter> dom (state_map_\<alpha> (qm, n)))" by simp

        from map_OK have "inj_on (state_map_\<alpha> (qm, n)) (S \<inter> dom (state_map_\<alpha> (qm, n)))"
          unfolding NFA_construct_reachable_map_OK_def by simp
        with q''_in_dom_qm q'_in_dom_qm state_map_\<alpha>_eq qm''_\<alpha>_props(1) show ?thesis
          unfolding inj_on_def by auto
      qed
    qed
  qed          

  show map_OK': "NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm, n)) {q} (state_map_\<alpha> (qm'', Suc n))"
  proof
    show "{q} \<subseteq> dom (state_map_\<alpha> (qm'', Suc n))"
      by (simp add: rm''_q dom_def)
  next
    fix q' r'
    assume "state_map_\<alpha> (qm, n) q' = Some r'"
    with fq_nin_dom_rm show "state_map_\<alpha> (qm'', Suc n) q' = Some r'"
      unfolding state_map_\<alpha>_def by (auto simp add: qm''_props dom_def)
  next
    show "inj_on (state_map_\<alpha> (qm'', Suc n)) (S \<inter> dom (state_map_\<alpha> (qm'', Suc n)))"
      by (fact qm''_inj_on)
  qed
qed


text \<open> qm is a map from indexes to state names \<close>

definition NFA_construct_reachable_init_impl where
  "NFA_construct_reachable_init_impl I =
   foldl (\<lambda> ((qm, n), Is) q. 
          ((qm.update_dj (ff q) (states_enumerate n) qm, Suc n),
                             s.ins_dj (states_enumerate n) Is))
          ((qm.empty (), 0), s.empty ()) I"

lemma NFA_construct_reachable_init_impl_correct :
fixes II D
defines "I \<equiv> map q2_\<alpha> II"
defines "S \<equiv> accessible (LTS_forget_labels D) (set I)"
assumes f_inj_on: "inj_on f S"
    and dist_I: "distinct I"
    and invar_I: "\<And>q. q \<in> set II \<Longrightarrow> q2_invar q"
    and ff_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
shows
   "RETURN (NFA_construct_reachable_init_impl II) \<le> \<Down> 
       (rprod (build_rel state_map_\<alpha> state_map_invar) 
              (build_rel s.\<alpha> s.invar)) 
     (SPEC (\<lambda>(rm, I'). 
        NFA_construct_reachable_map_OK 
          (accessible (LTS_forget_labels D) (set I)) Map.empty (set I) rm \<and>
        I' = (the \<circ> rm) ` (set I)))"
proof -
  let ?step = "(\<lambda>((qm, n), Is) q. 
           ((qm.update_dj (ff q) (states_enumerate n) qm, Suc n),
               s.ins_dj (states_enumerate n) Is))"
  { fix II
    have invar_OK : "\<And>qm n Is qm' n' Is'.
           set (map q2_\<alpha> II) \<subseteq> S \<Longrightarrow>
           distinct (map q2_\<alpha> II) \<Longrightarrow>
            \<forall>q\<in>set II. q2_invar q \<Longrightarrow>      
            dom (state_map_\<alpha> (qm, n)) \<inter> (set (map q2_\<alpha> II)) = {} \<Longrightarrow>
            state_map_invar (qm, n) \<Longrightarrow>
            s.invar Is \<Longrightarrow> 
            (\<And>q. q \<in> s.\<alpha> Is \<Longrightarrow> (\<exists>n' < n. q = states_enumerate n')) \<Longrightarrow>
            NFA_construct_reachable_map_OK S Map.empty {} (state_map_\<alpha> (qm, n)) \<Longrightarrow>
            ((qm', n'), Is') = foldl ?step ((qm, n),Is) II \<Longrightarrow>

              s.invar Is' \<and>
              s.\<alpha> Is' = ((the \<circ> (state_map_\<alpha> (qm', n'))) ` (set (map q2_\<alpha> II))) \<union> s.\<alpha> Is \<and>
              state_map_invar (qm', n') \<and>
           NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm, n)) (set (map q2_\<alpha> II)) (state_map_\<alpha> (qm', n'))" 
    proof (induct II)
      case Nil thus ?case by (simp add: NFA_construct_reachable_map_OK_def)
    next
      case (Cons q II' qm n Is qm' n' Is')
      from Cons(2) have q_in_S: "q2_\<alpha> q \<in> S" and II'_subset: "set (map q2_\<alpha> II') \<subseteq> S" by simp_all
      from Cons(3) have q_nin_I': "q2_\<alpha> q \<notin> set (map q2_\<alpha> II')" and "distinct (map q2_\<alpha> II')" by simp_all
      from Cons(4) have invar_q: "q2_invar q" and invar_II': "\<forall>q\<in>set II'. q2_invar q" by simp_all
      note dom_qII'_dist = Cons(5)
      note invar_qm_n = Cons(6) 
      note invar_Is = Cons(7) 
      note memb_Is = Cons(8) 
      note map_OK = Cons(9)
      note fold_eq = Cons(10)

      let ?I' = "map q2_\<alpha> II'"
      define qm'' where "qm'' = qm.update_dj (ff q) (states_enumerate n) qm"
      define Is'' where "Is'' = s.ins_dj (states_enumerate n) Is"

      note ind_hyp = Cons(1) [OF II'_subset `distinct ?I'` invar_II', 
                              of qm'' "Suc n" Is'' qm' n' Is']

      from dom_qII'_dist have q_nin_dom: "q2_\<alpha> q \<notin> dom (state_map_\<alpha> (qm, n))" by auto

      from state_map_extend_thm [OF f_inj_on invar_qm_n q_in_S q_nin_dom map_OK]
      have invar_qm''_n: "state_map_invar (qm'', Suc n)" and
           qm''_alpha: "map_op_\<alpha> qm_ops qm'' = map_op_\<alpha> qm_ops qm(ff q \<mapsto> states_enumerate n)" and
           map_OK': "NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm, n)) {q2_\<alpha> q} (state_map_\<alpha> (qm'', Suc n))" and
           dom_eq: "S \<inter> dom (state_map_\<alpha> (qm'', Suc n)) = insert (q2_\<alpha> q) ((dom (state_map_\<alpha> (qm, n))) \<inter> S)"
        using qm''_def[symmetric] ff_OK [OF invar_q q_in_S, symmetric]
        by simp_all

      have dom_II'_dist: "dom (state_map_\<alpha> (qm'', Suc n)) \<inter> set ?I' = {}" 
      proof -
        from II'_subset have "dom (state_map_\<alpha> (qm'', Suc n)) \<inter> set (map q2_\<alpha> II') =
             (S \<inter> dom (state_map_\<alpha> (qm'', Suc n))) \<inter> set (map q2_\<alpha> II')" by auto
        hence step: "dom (state_map_\<alpha> (qm'', Suc n)) \<inter> set (map q2_\<alpha> II') = 
                    insert (q2_\<alpha> q) ((dom (state_map_\<alpha> (qm, n))) \<inter> S) \<inter> set (map q2_\<alpha> II')"
          unfolding dom_eq by simp

        from dom_qII'_dist q_nin_I' show ?thesis unfolding step
           by (auto simp add: set_eq_iff) 
      qed

      have state_n_nin_Is: "states_enumerate n \<notin> s.\<alpha> Is"
      proof (rule notI)
        assume "states_enumerate n \<in> s.\<alpha> Is"
        from memb_Is[OF this] show False
          by (simp add: states_enumerate_eq)
      qed

      from state_n_nin_Is invar_Is 
      have Is''_props: "s.invar Is''" "s.\<alpha> Is'' = insert (states_enumerate n) (s.\<alpha> Is)"
        by (simp_all add: Is''_def s.correct)

      have state_n_nin_Is: "states_enumerate n \<notin> s.\<alpha> Is"
      proof (rule notI)
        assume "states_enumerate n \<in> s.\<alpha> Is"
        from memb_Is[OF this] show False
          by (simp add: states_enumerate_eq)
      qed

      from state_n_nin_Is invar_Is 
      have Is''_props: "s.invar Is''" "s.\<alpha> Is'' = insert (states_enumerate n) (s.\<alpha> Is)"
        by (simp_all add: Is''_def s.correct)

      have ind_hyp': "
        s.invar Is' \<and>
        s.\<alpha> Is' = (the \<circ> state_map_\<alpha> (qm', n')) ` set ?I' \<union> s.\<alpha> Is'' \<and>
        state_map_invar (qm', n') \<and>
        NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm'', Suc n)) (set ?I') (state_map_\<alpha> (qm', n'))"
      proof (rule ind_hyp [OF dom_II'_dist invar_qm''_n Is''_props(1)])
        fix q
        assume "q \<in> s.\<alpha> Is''"
        with Is''_props(2) memb_Is show "\<exists>n'<Suc n. q = states_enumerate n'"
          by auto (metis less_Suc_eq)
      next
        from map_OK' 
        show "NFA_construct_reachable_map_OK S Map.empty {} (state_map_\<alpha> (qm'', Suc n))"
          unfolding NFA_construct_reachable_map_OK_def by simp
      next
        from fold_eq show "((qm', n'), Is') = foldl ?step ((qm'', Suc n), Is'') II'" 
          by (simp add: qm''_def Is''_def)
      qed

      show ?case proof (intro conjI)
        show "s.invar Is'" "state_map_invar (qm', n')" by (simp_all add: ind_hyp')
      next
        from ind_hyp' qm''_alpha have "state_map_\<alpha> (qm', n') (q2_\<alpha> q) = Some (states_enumerate n)" 
          unfolding NFA_construct_reachable_map_OK_def state_map_\<alpha>_def 
          by (simp add: ff_OK[OF invar_q q_in_S])
        thus "s.\<alpha> Is' = (the \<circ> state_map_\<alpha> (qm', n')) ` set (map q2_\<alpha> (q # II')) \<union> s.\<alpha> Is"
          by (simp add: ind_hyp' Is''_props)
      next
        show "NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm, n)) (set (map q2_\<alpha> (q # II')))
              (state_map_\<alpha> (qm', n'))"
        proof (rule NFA_construct_reachable_map_OK_trans [of _ _ "{q2_\<alpha> q}"
               "state_map_\<alpha> (qm'', Suc n)" "set ?I'"]) 
          show "set (map q2_\<alpha> (q # II')) \<subseteq> {q2_\<alpha> q} \<union> set ?I'" by auto
        next
          show "NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm'', Suc n)) (set ?I') 
                  (state_map_\<alpha> (qm', n'))"
            using ind_hyp' by simp
        next
          show "NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm, n)) {q2_\<alpha> q} (state_map_\<alpha> (qm'', Suc n))" 
            by (simp add: map_OK')
        qed
      qed
    qed
  } note ind_proof = this

  have pre1 : "set (map q2_\<alpha> II) \<subseteq> S" unfolding S_def I_def by (rule accessible_subset_ws)
  have pre2 : "distinct (map q2_\<alpha> II)" using dist_I[unfolded I_def] by simp
  have pre3 : "\<forall>q\<in>set II. q2_invar q" using invar_I by simp

  have pre4 : "dom (state_map_\<alpha> (qm.empty (), 0)) \<inter> set (map q2_\<alpha> II) = {}"
    unfolding state_map_\<alpha>_def by (simp add: qm.correct o_def)

  have pre5 : "state_map_invar (qm.empty (), 0)"
    unfolding state_map_invar_def by (simp add: qm.correct)

  have pre6 : "NFA_construct_reachable_map_OK S Map.empty {} 
               (state_map_\<alpha> (qm.empty(), 0))"
    unfolding NFA_construct_reachable_map_OK_def state_map_\<alpha>_def by (simp add: qm.correct o_def)

  note ind_proof' = ind_proof [OF ]
  obtain qm' n' Is' where 
  res_eq: "NFA_construct_reachable_init_impl II = ((qm', n'), Is')" by (metis prod.exhaust)
  
  define tmpsempty where "tmpsempty = s.empty ()"
  note ind_proof' = ind_proof [OF pre1 pre2 pre3 pre4 pre5 _ _ pre6, 
          of tmpsempty qm' n' Is',
    folded NFA_construct_reachable_init_impl_def]

  from ind_proof' show ?thesis 
   apply (rule_tac SPEC_refine)+
    apply (simp add: s.correct 
     I_def tmpsempty_def br_def
     state_map_\<alpha>_def state_map_invar_def single_valued_def
    res_eq S_def NFA_construct_reachable_map_OK_def f_inj_on)
    using NFA_construct_reachable_init_impl_def res_eq 
    by (auto simp add: tmpsempty_def br_def single_valued_def)
qed

definition NFA_construct_reachable_impl_step_rel where
  "NFA_construct_reachable_impl_step_rel =
    build_rel (\<lambda>DS. (\<lambda>(a, q'). (a::'a set, q2_\<alpha> q')) ` DS)
              (\<lambda>DS. (\<forall>a q'. (a, q') \<in> DS \<longrightarrow> q2_invar q') \<and>
                    (\<forall>a q' q''. (a, q') \<in> DS \<longrightarrow> (a, q'') \<in> DS \<longrightarrow> 
                       ((q2_\<alpha> q' = q2_\<alpha> q'') \<longleftrightarrow> q' = q'')))"


definition NFA_construct_reachable_impl_step where
"NFA_construct_reachable_impl_step DS qm0 n D0 q =
  FOREACH {(a,q').(a,q') \<in> (DS q) \<and> a \<noteq> {}} 
  (\<lambda>(a, q') ((qm, n), DD', N). do {
   let ((qm', n'), r') =
    (let r'_opt = qm.lookup (ff q') qm in
      if (r'_opt = None) then
         ((qm.update_dj (ff q') (states_enumerate n) qm, Suc n), states_enumerate n)
      else
         ((qm, n), the r'_opt)
    );
  RETURN ((qm', n'), 
    (d.add (the (qm.lookup (ff q) qm0)) a r' DD'), q' # N)
}) ((qm0, n), D0, [])"

lemma NFA_construct_reachable_impl_step_correct :
fixes D II
fixes q :: "'q2_rep"
defines "I \<equiv> map q2_\<alpha> II"
defines "S \<equiv> accessible (LTS_forget_labels D) (set I)"
assumes f_inj_on: "inj_on f S"
    and ff_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
    and d_add_OK: "lts_add d.\<alpha> d.invar d.add" 
    (* \<forall>q a q' q''. (q, a, q') \<in> D \<and> (q, a, q'') \<in> D \<and> q'' \<noteq> q' \<longrightarrow> *)     
    and rm_eq: "rm = state_map_\<alpha> (qm0, n)"
    and invar_qm0_n: "state_map_invar (qm0, n)"
    and D0'_eq: "D0' = d.\<alpha> D0" "D0' = \<Delta> \<A>"
    and invar_D0: "d.invar D0"
    and rm_q:  "rm (q2_\<alpha> q) = Some r"
    and r_nin: "r \<notin> \<Q> \<A>"
    and invar_q: "q2_invar q"
    and q_in_S: "q2_\<alpha> q \<in> S"
    and DS_OK: "(DS q, {(a, q'). (q2_\<alpha> q, a, q') \<in> D}) \<in> 
          NFA_construct_reachable_impl_step_rel"
    and weak_invar: "NFA_construct_reachable_abstract_impl_weak_invar 
                     I (l.\<alpha> A) FP D (rm, \<A>)"
shows "NFA_construct_reachable_impl_step DS qm0 n D0 q \<le> 
  \<Down> (rprod (build_rel state_map_\<alpha> state_map_invar) (rprod (build_rel d.\<alpha> d.invar) 
           (map_list_rel (build_rel q2_\<alpha> q2_invar))))
     (NFA_construct_reachable_abstract_impl_step S D rm D0' (q2_\<alpha> q))"
  unfolding NFA_construct_reachable_impl_step_def
          NFA_construct_reachable_abstract_impl_step_def
  using [[goals_limit = 10]]
  apply (refine_rcg)
  (* "preprocess goals" *)
  apply (subgoal_tac "inj_on (\<lambda>(a, q'). (a, q2_\<alpha> q')) 
                ({(a, q'). (a, q') \<in> DS q \<and> a \<noteq> {}})")
  apply assumption
  apply (insert DS_OK) []
  apply (simp add: inj_on_def Ball_def NFA_construct_reachable_impl_step_rel_def)
  apply (simp add: in_br_conv)
  apply blast
  (* "goal solved" *)
  apply (insert DS_OK) []
  apply (simp add: NFA_construct_reachable_impl_step_rel_def)
  apply (simp add: in_br_conv br_def)
  apply (simp only: set_eq_iff)
  apply (fastforce)
  (* "goal solved" *)
  apply (simp add: rm_eq D0'_eq invar_qm0_n invar_D0)
  apply (simp add: in_br_conv)
  apply (simp add: invar_D0 invar_qm0_n)
  apply (simp add:br_def)
  apply (simp add: assms(8) invar_D0)
  (* "goal solved" *)
  apply (clarify, simp)+
  apply (rename_tac it N q'' qm n D' NN a q')
  apply (subgoal_tac "
    (qm.lookup (ff q'') qm = None \<longrightarrow>
        RETURN
         ((qm.update_dj (ff q'') (states_enumerate n) qm, Suc n), states_enumerate n)
        \<le> \<Down> (rprod (build_rel state_map_\<alpha> state_map_invar) Id)
            (SPEC
              (\<lambda>(rm', r').
                  NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'}
                   rm' \<and>
                  rm' (q2_\<alpha> q') = Some r'))) \<and>
       ((\<exists>y. qm.lookup (ff q'') qm = Some y) \<longrightarrow>
        RETURN ((qm, n), the (qm.lookup (ff q'') qm))
        \<le> \<Down> (rprod (build_rel state_map_\<alpha> state_map_invar) Id)
            (SPEC
              (\<lambda>(rm', r').
                  NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'}
                   rm' \<and>
                  rm' (q2_\<alpha> q') = Some r')))")
  apply assumption
  apply (simp del: br_def rprod_def 
  add: Let_def ff_OK pw_le_iff refine_pw_simps rprod_sv) 
  apply (rule conjI)
  apply (rule impI)
  defer
  apply (rule impI)
  apply (erule exE)
  apply (rename_tac r)
  defer
  apply (clarify, simp add: br_def)+
  apply (simp add: br_def D0'_eq)
  apply (rename_tac it N q'' qm n D' NN r' qm' n' a q')
  defer

proof -
  fix it N q'' qm n D' NN a q'
  assume aq'_in_it: "(a, q') \<in> it"
     and aq''_in_it: "(a, q'') \<in> it"
     and it_subset: "it \<subseteq> {(a, q'). (a, q') \<in> DS q \<and> a \<noteq> {}}"
     and q''_q'_eq: "q2_\<alpha> q'' = q2_\<alpha> q'"
  let ?it' = "(\<lambda> (a, q'). (a, q2_\<alpha> q')) ` it"
  assume invar_foreach: 
     "NFA_construct_reachable_abstract_impl_foreach_invar 
      S D rm (d.\<alpha> D0) (q2_\<alpha> q) ?it'
               (state_map_\<alpha> (qm, n), d.\<alpha> D', N)"
     and invar_qm_n: "state_map_invar (qm, n)"
     and invar_D': "d.invar D'"

  from aq'_in_it aq''_in_it it_subset DS_OK
  have invar_q': "q2_invar q'" and invar_q'': "q2_invar q''"
    by (auto simp add: NFA_construct_reachable_impl_step_rel_def br_def)   
  have q'_in_S: "q2_\<alpha> q' \<in> S"
  proof -
    from DS_OK have "
        {(a, q'). (q2_\<alpha> q, a, q') \<in> D \<and> a \<noteq> {}} = 
         (\<lambda> (a, q'). (a, q2_\<alpha> q')) ` {(a,q'). (a, q') \<in> DS q \<and> a \<noteq> {}}"
      unfolding NFA_construct_reachable_impl_step_rel_def 
       apply (insert DS_OK) []
  apply (simp add: NFA_construct_reachable_impl_step_rel_def)
  apply (simp add: in_br_conv br_def)
  apply (simp only: set_eq_iff)
      by (fastforce)
     with aq'_in_it it_subset have "(a, q2_\<alpha> q') \<in> 
          {(a, q'). (q2_\<alpha> q, a, q') \<in> D \<and> a \<noteq> {}}"
      by (simp add: image_iff Bex_def) blast
    hence "(q2_\<alpha> q, q2_\<alpha> q') \<in> LTS_forget_labels D"
      unfolding LTS_forget_labels_def 
      NFA_construct_reachable_impl_step_rel_def
      by (metis (mono_tags, lifting) aq'_in_it 
                 case_prodD case_prodI 
                 in_mono it_subset mem_Collect_eq)
    with q_in_S show ?thesis unfolding S_def accessible_def
      by (metis rtrancl_image_advance)
  qed
  from q'_in_S q''_q'_eq have q''_in_S: "q2_\<alpha> q''\<in> S" by simp
  from ff_OK[OF invar_q'' q''_in_S] q''_q'_eq have ff_q''_eq[simp]: 
    "ff q'' = f (q2_\<alpha> q')" by simp

  define D'' where "D'' = {(a, q'). (q2_\<alpha> q, a, q') \<in> D \<and> a \<noteq> {}} - ?it'"
  from invar_foreach have
     qm_OK: "NFA_construct_reachable_map_OK S rm (snd ` D'') 
     (state_map_\<alpha> (qm, n))" and
     set_N_eq: "set N = snd ` D''" and
     D'_eq: "d.\<alpha> D' = D0' \<union>
       {(the (state_map_\<alpha> (qm, n) (q2_\<alpha> q)), a, 
         the (state_map_\<alpha> (qm, n) q')) |a q'. (a, q') \<in> D'' \<and> a \<noteq> {}}"
    unfolding NFA_construct_reachable_abstract_impl_foreach_invar.simps 
              NFA_construct_reachable_map_OK_def
              D''_def[symmetric]
    by (auto simp add: D''_def D0'_eq)
  (* "... and the case that the map needs to be extended." *)
  { assume "qm.lookup (ff q'') qm = None"
    with invar_qm_n have q'_nin_dom: 
    "q2_\<alpha> q' \<notin> dom (state_map_\<alpha> (qm, n))"
      unfolding state_map_invar_def state_map_\<alpha>_def 
      by (simp add: qm.correct dom_def)

    from qm_OK have qm_OK':
      "NFA_construct_reachable_map_OK S Map.empty {} (state_map_\<alpha> (qm, n))"
      unfolding NFA_construct_reachable_map_OK_def by simp

    define qm' where "qm'= qm.update_dj 
        (f (q2_\<alpha> q')) (states_enumerate n) qm"
    from state_map_extend_thm [OF f_inj_on invar_qm_n 
                      q'_in_S q'_nin_dom qm_OK', folded qm'_def]
    have invar_qm'_n: "state_map_invar (qm', Suc n)" and
         qm'_alpha: "qm.\<alpha> qm' = qm.\<alpha> qm(f (q2_\<alpha> q') 
          \<mapsto> states_enumerate n)" and
         qm'_OK: 
          "NFA_construct_reachable_map_OK S 
           (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'} 
           (state_map_\<alpha> (qm', Suc n))"
      by simp_all

    from qm'_alpha have rm'_q': 
          "state_map_\<alpha> (qm', Suc n) (q2_\<alpha> q') = Some (states_enumerate n)"
      unfolding state_map_\<alpha>_def by simp

    define aa where "aa = state_map_\<alpha> (qm.update_dj (ff q'') 
                     (states_enumerate n) qm, Suc n)"  
    from invar_qm'_n qm'_OK rm'_q'
    show 
        "\<exists> aa. ((qm.update_dj (ff q'') (states_enumerate n) qm, Suc n), aa)
           \<in> br state_map_\<alpha> state_map_invar \<and> NFA_construct_reachable_map_OK S
        (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'} aa \<and>
        aa (q2_\<alpha> q') =
         Some (states_enumerate n)"
    proof -
      have "((qm.update_dj (ff q'') (states_enumerate n) qm, Suc n), aa)
           \<in> br state_map_\<alpha> state_map_invar \<and> NFA_construct_reachable_map_OK S
        (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'} aa \<and>
        aa (q2_\<alpha> q') =
         Some (states_enumerate n)"
        unfolding qm'_def[symmetric] ff_q''_eq aa_def
        apply (auto simp add: br_def)
        using invar_qm'_n apply blast
        using rm'_q' apply auto[1]
        apply (insert qm'_OK)
        apply (simp add: qm'_def qm'_OK NFA_construct_reachable_map_OK_def)
        apply (simp add: NFA_construct_reachable_map_OK_def)
        apply (simp add: NFA_construct_reachable_map_OK_def rm'_q')
        done
      from this show ?thesis by auto
    qed
  }
  (*  "Consider the case that the map does not need to be extended" *)
  { fix r
    assume "qm.lookup (ff q'') qm = Some r"
    define aa where "aa = (state_map_\<alpha> (qm, n))"
    with invar_qm_n qm_OK
    have " ((qm, n), aa) \<in> br state_map_\<alpha> state_map_invar \<and>
           NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'} aa \<and>
           aa (q2_\<alpha> q') = qm.lookup (ff q'') qm"
     apply (simp add: state_map_\<alpha>_def qm.correct state_map_invar_def
                    NFA_construct_reachable_map_OK_def rm_eq dom_def br_def)
      using \<open>qm.lookup (ff q'') qm = Some r\<close> qm.lookup_correct by auto
    from this
    show "\<exists> aa.((qm, n), aa) \<in> br state_map_\<alpha> state_map_invar \<and>
           NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'} aa \<and>
           aa (q2_\<alpha> q') = qm.lookup (ff q'') qm"
      by auto
  }
 
  { (* It remains to show that adding to the transition systems works. 
        Here, a case distinction
        depending on whether the input is weak deterministic, is needed. *)
    fix r'

    from qm_OK rm_q have r_intro1: "state_map_\<alpha> (qm, n) (q2_\<alpha> q) = Some r"
      unfolding NFA_construct_reachable_map_OK_def by simp

    from rm_q rm_eq have r_intro2: "qm.lookup (ff q) qm0 = Some r" 
      using invar_qm0_n
      unfolding state_map_\<alpha>_def state_map_invar_def
      using ff_OK [OF invar_q q_in_S] by (simp add: qm.correct)



    have "insert (r, a, r') (d.\<alpha> D') = d.\<alpha> (d.add r a r' D') \<and>
          d.invar (d.add r a r' D')"
      by (metis d_add_OK invar_D' lts_add_def)
    from this D0'_eq show "insert (the (state_map_\<alpha> (qm, n) (q2_\<alpha> q)), a, r') (d.\<alpha> D') =
          d.\<alpha> (d.add (the (qm.lookup (ff q) qm0)) a r' D') \<and>
          d.invar (d.add (the (qm.lookup (ff q) qm0)) a r' D') \<and>
          q2_invar q''"   
      by (simp add: r_intro1 r_intro2 invar_q'')
  } 
qed


definition NFA_construct_reachable_impl where
  "NFA_construct_reachable_impl S I A FP DS  =
   do {
     let ((qm, n), Is) = NFA_construct_reachable_init_impl I;
     (((qm, n), \<A>), _) \<leftarrow> WORKLISTT (\<lambda>_. True)
      (\<lambda>((qm, n), AA) q. 
         if (s.memb (the (qm.lookup (ff q) qm)) (nfa_states AA)) then
           (RETURN (((qm, n), AA), []))
         else                    
           do {
             ASSERT (q2_invar q \<and> q2_\<alpha> q \<in> S);
             ((qm', n'), DD', N) \<leftarrow> 
             NFA_construct_reachable_impl_step DS qm n (nfa_trans AA) q;
             RETURN (((qm', n'), 
                 (s.ins_dj (the (qm.lookup (ff q) qm)) (nfa_states AA), 
                  nfa_labels AA, DD', nfa_initial AA, 
                  (if (FP q) then (s.ins_dj (the (qm.lookup (ff q) qm))) 
                    (nfa_accepting AA) else (nfa_accepting AA)))), N)
           }
        ) (((qm, n), (s.empty (), A, d.empty, Is, s.empty ())), I);
     RETURN \<A>
   }"



lemma NFA_construct_reachable_impl_correct :
fixes D II
defines "I \<equiv> map q2_\<alpha> II"
defines "R \<equiv> build_rel nfa_\<alpha> nfa_invar"
defines "R' \<equiv> build_rel state_map_\<alpha> state_map_invar"
defines "S \<equiv> accessible (LTS_forget_labels D) (set I)"
assumes f_inj_on: "inj_on f S"
    and ff_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
    and d_add_OK: (* "\<forall>q a q' q''. (q, a, q') \<in> D \<and> (q, a, q'') \<in> D \<and> q'' \<noteq> q' \<longrightarrow> *)
          "lts_add d.\<alpha> d.invar d.add"
    and dist_I: "distinct I"
    and invar_I: "\<And>q. q \<in> set II \<Longrightarrow> q2_invar q" 
    and invar_A: "l.invar A"
    and DS_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> 
       (DS q, {(a, q'). (q2_\<alpha> q, a, q') \<in> D}) 
        \<in> NFA_construct_reachable_impl_step_rel"
    and FFP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> FFP q \<longleftrightarrow> FP (q2_\<alpha> q)"
shows "NFA_construct_reachable_impl S II A FFP DS \<le>
   \<Down> R (NFA_construct_reachable_abstract2_impl I (l.\<alpha> A) FP D)"

unfolding NFA_construct_reachable_impl_def 
          NFA_construct_reachable_abstract2_impl_def 
          WORKLISTT_def
using [[goals_limit = 5]]
apply (refine_rcg)
(* preprocess goals
   initialisation is OK *)
   apply (unfold I_def)
   apply (rule NFA_construct_reachable_init_impl_correct)
  apply (insert f_inj_on ff_OK dist_I invar_I)[4]
  apply (simp_all add: S_def I_def)[4]
  (* goal solved *)
  apply (subgoal_tac "single_valued (rprod R' R)")
  apply assumption
  apply (simp add: rprod_sv R'_def R_def del: rprod_def br_def)
  (* goal solved *)
  apply (subgoal_tac "single_valued (build_rel q2_\<alpha> q2_invar)")
  apply assumption
  apply (simp del: br_def)
  (* goal solved *)
  apply (simp add: br_def R'_def R_def nfa_invar_def 
          s.correct d.correct_common invar_A)
  (* goal solved *)
  defer
  apply simp
  (* goal solved *)
  apply simp
  (* goal solved *)
  apply (clarify, simp add: br_def)+
  apply (rename_tac q rm \<A> qm n Qs As DD Is Fs r)
  defer
  apply (simp add: rprod_sv R'_def R_def del: rprod_def br_def)
  (* goal solved *)
  apply (simp add: br_def)
  (* goal solved *)
  apply (simp add: br_def)
  (* goal solved *)
  apply (simp add: S_def I_def)
  (* goal solved *)
  defer
  defer
  apply (simp add: S_def I_def)
  apply (simp add: S_def I_def br_def)
  apply (simp add: invar_I list.rel_map(2) list.rel_refl_strong)
  apply (simp add: S_def I_def br_def R_def R'_def)
  defer
  (* goal solved
    -- "step OK *)
  apply (unfold I_def[symmetric])
  apply (clarify, simp)+ 
  apply (simp add: br_def)
  apply (unfold I_def)
  apply (rule_tac NFA_construct_reachable_impl_step_correct)
  apply (unfold I_def[symmetric])
  apply (simp_all add: nfa_invar_def f_inj_on[unfolded S_def] ff_OK[unfolded S_def] 
                       d_add_OK DS_OK[unfolded S_def]) [14] 
  (* goal solved *)
  apply (simp add: rprod_sv R'_def R_def  rprod_def br_def)
  (* goal solved *)
  apply (simp add: R_def br_def R'_def)
  (* goal solved *)
  apply (clarify, simp split del: if_splits add: R_def br_def)+
  apply (unfold S_def[symmetric] nfa_accepting_def snd_conv)
  apply (simp add: br_def nfa_invar_def)
  apply (clarify, simp split del: if_splits add:  R'_def)
  apply (rename_tac q' qm'' n'' \<A> qm n Qs As DD Is Fs q2 q1 bga qm' n' D' bja r)
  apply (simp add: br_def)
  defer
using [[goals_limit = 6]]
proof -
  
  fix q rm \<A> qm n Qs As DD Is Fs r
  {
   assume rm_q: "state_map_\<alpha> (qm, n) (q2_\<alpha> q) = Some r" and
         in_R': "rm = state_map_\<alpha> (qm, n) \<and> state_map_invar (qm, n)" and
         in_R: "\<A> = nfa_\<alpha> (Qs, As, DD, Is, Fs) \<and> nfa_invar (Qs, As, DD, Is, Fs)" and
         invar_q: "q2_invar q" and
         q_in: "q2_\<alpha> q \<in> accessible (LTS_forget_labels D) (q2_\<alpha> ` set II)"

  from q_in have q_in_S: "q2_\<alpha> q \<in> S" unfolding S_def I_def by simp

  from in_R' rm_q ff_OK[OF invar_q q_in_S] have "qm.lookup (ff q) qm = Some r"
    unfolding R'_def 
    by (simp add: state_map_invar_def state_map_\<alpha>_def qm.correct br_def)

  with in_R show "s.memb (the (qm.lookup (ff q) qm)) Qs = (r \<in> s.\<alpha> Qs)"
    unfolding R_def by (simp add: nfa_invar_def s.correct)
}
  {
  fix x1 x2 x1b x2a x2b q' qm'' n'' \<A> qm n Qs As DD Is Fs q2 q1 bga qm' n' D' bja r
    assume r_nin_Q: "r \<notin> \<Q> \<A>" and 
       rm_q': "state_map_\<alpha> (qm, n) (q2_\<alpha> q') = Some r" and
       weak_invar: "NFA_construct_reachable_abstract_impl_weak_invar 
             I (l.\<alpha> A) FP D
         (state_map_\<alpha> (qm, n), \<A>)" and
       invar_qm_n: "q2 = state_map_\<alpha> (qm', n') \<and>
       state_map_invar (qm', n') \<and>
       q1 = d.\<alpha> D' \<and>
       d.invar D' \<and> list_all2 (\<lambda>x x'. x' = q2_\<alpha> x \<and> q2_invar x) bja bga" and
       in_R: "n'' = state_map_\<alpha> (qm, n) \<and>
       state_map_invar (qm, n) \<and> ((Qs, As, DD, Is, Fs), \<A>) \<in> R" and
       invar_q': "q2_invar q'" and 
       q'_in_S: "q2_\<alpha> q' \<in> S"
 

  from rm_q' invar_qm_n ff_OK[OF invar_q' q'_in_S] 
      have qm_f_q': "qm.lookup (ff q') qm = Some r"
     unfolding state_map_\<alpha>_def state_map_invar_def 
     apply (simp add: qm.correct)
     using in_R qm.lookup_correct state_map_invar_def by auto

  from in_R r_nin_Q have r_nin_Qs: "r \<notin> s.\<alpha> Qs" by (simp add: R_def br_def)

  from weak_invar have "\<F> \<A> \<subseteq> \<Q> \<A>"
    unfolding NFA_construct_reachable_abstract_impl_weak_invar_def by auto
  with r_nin_Q have "r \<notin> \<F> \<A>" by auto
  with in_R have r_nin_Fs: "r \<notin> s.\<alpha> Fs" by (simp add: R_def br_def)

  from in_R FFP_OK[OF invar_q' q'_in_S]
  have "((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, As, D', Is,
         if FFP q' then s.ins_dj (the (qm.lookup (ff q') qm)) 
          (snd (snd (snd (snd (Qs, As, DD, Is, Fs))))) else 
           (snd (snd (snd (snd (Qs, As, DD, Is, Fs)))))),
        \<lparr>\<Q> = insert r (\<Q> \<A>), \<Sigma> = \<Sigma> \<A>, \<Delta> = d.\<alpha> D', \<I> = \<I> \<A>,
           \<F> = if FP (q2_\<alpha> q') then insert 
           (the (state_map_\<alpha> (qm, n) (q2_\<alpha> q'))) (\<F> \<A>) else \<F> \<A>\<rparr>)
       \<in> R" 
    by (simp add: rm_q' qm_f_q' R_def nfa_\<alpha>_def 
                nfa_invar_def invar_qm_n s.correct r_nin_Qs r_nin_Fs br_def)
  from this show "(FFP q' \<longrightarrow>
        (FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, As, D', Is,
           s.ins_dj (the (qm.lookup (ff q') qm)) Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Sigma> = \<Sigma> \<A>, \<Delta> = d.\<alpha> D', \<I> = \<I> \<A>, \<F> = insert r (\<F> \<A>)\<rparr>)
         \<in> R) \<and>
        (\<not> FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, As, D', Is,
           s.ins_dj (the (qm.lookup (ff q') qm)) Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Sigma> = \<Sigma> \<A>, \<Delta> = d.\<alpha> D', \<I> = \<I> \<A>, \<F> = \<F> \<A>\<rparr>)
         \<in> R)) \<and>
       (\<not> FFP q' \<longrightarrow>
        (FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, As, D', Is, Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Sigma> = \<Sigma> \<A>, \<Delta> = d.\<alpha> D', \<I> = \<I> \<A>, \<F> = insert r (\<F> \<A>)\<rparr>)
         \<in> R) \<and>
        (\<not> FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, As, D', Is, Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Sigma> = \<Sigma> \<A>, \<Delta> = d.\<alpha> D', \<I> = \<I> \<A>, \<F> = \<F> \<A>\<rparr>)
         \<in> R)) "
    using rm_q' by auto
}
qed


lemma NFA_construct_reachable_impl_alt_def :
  "NFA_construct_reachable_impl S I A FP DS =
   do {
     let ((qm, n), Is) = NFA_construct_reachable_init_impl I;
     ((_, \<A>), _) \<leftarrow> WORKLISTT (\<lambda>_. True)
      (\<lambda>((qm, n), (Qs, As, DD, Is, Fs)) q. do { 
         let r = the (qm.lookup (ff q) qm);
         if (s.memb r Qs) then
           (RETURN (((qm, n), (Qs, As, DD, Is, Fs)), []))
         else                    
           do {
             ASSERT (q2_invar q \<and> q2_\<alpha> q \<in> S);
             ((qm', n'), DD', N) \<leftarrow> NFA_construct_reachable_impl_step DS qm n DD q;
             RETURN (((qm', n'), 
                 (s.ins_dj r Qs, 
                  As, DD', Is, 
                  (if (FP q) then (s.ins_dj r Fs) else Fs))), N)
           }
         }
        ) (((qm, n), (s.empty (), A, d.empty, Is, s.empty ())), I);
     RETURN \<A>
   }"
unfolding NFA_construct_reachable_impl_def
apply (simp add: Let_def split_def)
apply (unfold nfa_selectors_def fst_conv snd_conv prod.collapse)
apply simp
done



schematic_goal NFA_construct_reachable_impl_code_aux: 
fixes D_it :: "'q2_rep \<Rightarrow> (('a set \<times> 'q2_rep),
                     ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) set_iterator"
assumes D_it_OK[rule_format, refine_transfer]: 
         "\<forall>q. q2_invar q \<longrightarrow> q2_\<alpha> q \<in> S \<longrightarrow> set_iterator (D_it q) 
                                            {p \<in> DS q. fst p \<noteq> {}}"
shows "RETURN ?f \<le> NFA_construct_reachable_impl S I A FP DS"
 unfolding NFA_construct_reachable_impl_alt_def 
    WORKLISTT_def NFA_construct_reachable_impl_step_def
  apply (unfold split_def snd_conv fst_conv prod.collapse)
  apply (rule refine_transfer | assumption | erule conjE)+
done


definition (in automaton_by_lts_defs) NFA_construct_reachable_impl_code where
"NFA_construct_reachable_impl_code qm_ops (ff::'q2_rep \<Rightarrow> 'i) I A FP D_it =
(let ((qm, n), Is) = foldl (\<lambda>((qm, n), Is) q. 
         ((map_op_update_dj qm_ops (ff q) (states_enumerate n) qm, Suc n),
             s.ins_dj (states_enumerate n) Is))
                ((map_op_empty qm_ops (), 0), s.empty()) I;
     ((_, AA), _) = worklist (\<lambda>_. True)
        (\<lambda>((qm, n), Qs, As, DD, Is, Fs) (q::'q2_rep).
            let r = the (map_op_lookup qm_ops (ff q) qm)
            in if set_op_memb s_ops r Qs then (((qm, n), Qs, As, DD, Is, Fs), [])
               else let ((qm', n'), DD', N) = D_it q (\<lambda>_::(('m \<times> nat) \<times> 'd \<times> 'q2_rep list). True)
                           (\<lambda>(a, q') ((qm::'m, n::nat), DD'::'d, N::'q2_rep list).
                               let r'_opt = map_op_lookup qm_ops (ff q') qm; 
                                   ((qm', n'), r') = if r'_opt = None then 
                                       let r'' = states_enumerate n in 
                                          ((map_op_update_dj qm_ops (ff q') r'' qm, Suc n), r'') 
                                      else ((qm, n), the r'_opt)
                               in ((qm', n'), clts_op_add d_ops r a r' DD', q' # N))
                           ((qm, n), DD, [])
                    in (((qm', n'), set_op_ins_dj s_ops r Qs, As, DD', Is, if FP q then set_op_ins_dj s_ops r Fs else Fs), N))
        (((qm, n), set_op_empty s_ops (), A, 
   clts_op_empty d_ops, Is, set_op_empty s_ops ()), I)
 in AA)"


lemma NFA_construct_reachable_impl_code_correct: 
fixes D_it :: "'q2_rep \<Rightarrow> (('a set \<times> 'q2_rep),
                     ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) set_iterator"
assumes D_it_OK: "\<forall> q. q2_invar q \<longrightarrow> q2_\<alpha> q \<in> S \<longrightarrow> 
                         set_iterator (D_it q) {p \<in> DS q. fst p \<noteq> {}}"
shows "RETURN (NFA_construct_reachable_impl_code qm_ops ff I A FP D_it) \<le> 
               NFA_construct_reachable_impl S I A FP DS"
proof -
  have rule: 
   "\<And>f1 f2. \<lbrakk>RETURN f1 \<le> NFA_construct_reachable_impl S I A FP DS; f1 = f2\<rbrakk> \<Longrightarrow>
              RETURN f2 \<le> NFA_construct_reachable_impl S I A FP DS" by simp
  
  note aux_thm = NFA_construct_reachable_impl_code_aux[OF D_it_OK, of I FP A]

  note rule' = rule[OF aux_thm]
  show ?thesis 
    apply (rule rule')
    apply (simp add: NFA_construct_reachable_impl_code_def split_def Let_def NFA_construct_reachable_init_impl_def
                cong: if_cong)
  done
qed

lemma NFA_construct_reachable_impl_code_correct_full: 
fixes D_it :: "'q2_rep \<Rightarrow> (('a set \<times> 'q2_rep),('m \<times> nat) 
        \<times> 'd \<times> 'q2_rep list) set_iterator"
fixes II D DS
defines "S \<equiv> accessible (LTS_forget_labels D) (set (map q2_\<alpha> II))"
assumes f_inj_on: "inj_on f S"
    and ff_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
    and d_add_OK: 
          (* "\<forall>q a q' q''. (q, a, q') \<in> D \<and> (q, a, q'') \<in> D \<and> q'' \<noteq> q' \<longrightarrow> *)
          "lts_add d.\<alpha> d.invar d.add"
    and dist_I: "distinct (map q2_\<alpha> II)"
    and invar_I: "\<And>q. q \<in> set II \<Longrightarrow> q2_invar q" 
    and invar_A: "l.invar A"
    and fin_S: "finite S"
    and fin_D: "\<And>q. finite {(a, q'). (q, a, q') \<in> D}"
    and D_it_OK: "(\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> 
            (set_iterator_genord (D_it q) {p \<in> DS q. fst p \<noteq> {}} selP \<and>
             ((DS q), {(a, q'). (q2_\<alpha> q, a, q') \<in> D }) \<in> 
            NFA_construct_reachable_impl_step_rel))"
    and FFP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> FFP q \<longleftrightarrow> FP (q2_\<alpha> q)"
shows "NFA_isomorphic (NFA_construct_reachable (set (map q2_\<alpha> II)) (l.\<alpha> A) FP D)
         (nfa_\<alpha> (NFA_construct_reachable_impl_code qm_ops ff II A FFP D_it)) \<and>
       nfa_invar (NFA_construct_reachable_impl_code qm_ops ff II A FFP D_it)"
proof - 

  have fin_Ds: "(\<And>q. finite {(a, q'). (q, a, q') \<in> D \<and> a \<noteq> {}})"
  proof -
    fix q
    have "finite {(a, q'). (q, a, q') \<in> D}"
      by (simp add: fin_D)
    have "{(a, q'). (q, a, q') \<in> D \<and> a \<noteq> {}} \<subseteq> {(a, q'). (q, a, q') \<in> D}" by auto
    from this show "finite {(a, q'). (q, a, q') \<in> D \<and> a \<noteq> {}}"
    by (simp add: finite_subset fin_D)
  qed
  
  have D_it_OK'' : "\<forall>q. q2_invar q \<longrightarrow> q2_\<alpha> q \<in> S \<longrightarrow>
      set_iterator (D_it q) {p \<in> DS q. fst p \<noteq> {}}"
  proof (intro allI impI)
    fix q
    assume "q2_invar q" "q2_\<alpha> q \<in> S"
    with D_it_OK[of q] show
      "set_iterator (D_it q) {p \<in> DS q. fst p \<noteq> {}}"
      using set_iterator_intro by blast
    qed 
  
  note NFA_construct_reachable_impl_code_correct [OF D_it_OK'']
  also have "NFA_construct_reachable_impl S II A FFP DS \<le> \<Down> (build_rel nfa_\<alpha> nfa_invar)
     (NFA_construct_reachable_abstract2_impl (map q2_\<alpha> II) (l.\<alpha> A) FP D)"
    using NFA_construct_reachable_impl_correct 
        [OF f_inj_on[unfolded S_def] ff_OK[unfolded S_def] d_add_OK
          dist_I invar_I invar_A, of DS FFP FP] FFP_OK S_def 
    by (auto simp add: FFP_OK D_it_OK)
      also note NFA_construct_reachable_abstract2_impl_correct
  also note NFA_construct_reachable_abstract_impl_correct
  finally have "RETURN (NFA_construct_reachable_impl_code qm_ops ff II A FFP D_it) \<le> \<Down> (build_rel nfa_\<alpha> nfa_invar)
     (SPEC (NFA_isomorphic (NFA_construct_reachable (set (map q2_\<alpha> II)) (l.\<alpha> A) FP D)))"
    using S_def fin_S fin_D
    by (simp add: S_def[symmetric] fin_S fin_Ds)
    
  thus ?thesis 
    by (erule_tac RETURN_ref_SPECD, simp add: br_def)
qed

lemma NFA_construct_reachable_impl_code_correct___remove_unreachable: 
fixes D_it :: "'q2_rep \<Rightarrow> (('a set \<times> 'q2_rep) , ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) 
      set_iterator"
fixes II D DS
assumes d_add_OK: 
  (* "\<forall>q a q' q''. (q, a, q') \<in> \<Delta> \<A> \<and> (q, a, q'') \<in> \<Delta> \<A> \<and> q'' \<noteq> q' \<longrightarrow> *)
          "lts_add d.\<alpha> d.invar d.add"
    and f_inj_on: "inj_on f (\<Q> \<A>)"
    and ff_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> (\<Q> \<A>) \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
    and dist_I: "distinct (map q2_\<alpha> II)" 
    and invar_I: "\<And>q. q \<in> set II \<Longrightarrow> q2_invar q" 
    and I_OK: "set (map q2_\<alpha> II) = \<I> \<A>"
    and A_OK: "l.invar A" "l.\<alpha> A = \<Sigma> \<A>"
    and D_it_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow>
                    set_iterator_genord (D_it q) {p \<in> DS q. fst p \<noteq> {}} selP \<and>
                    (DS q, {(a, q'). (q2_\<alpha> q, a, q') \<in> \<Delta> \<A>}) 
                    \<in> NFA_construct_reachable_impl_step_rel"
    and FP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> FP q \<longleftrightarrow> (q2_\<alpha> q) \<in> \<F> \<A>"
    and wf_\<A>: "NFA \<A>"
shows "nfa_invar_NFA (NFA_construct_reachable_impl_code qm_ops ff II A FP D_it) \<and>
       NFA_isomorphic_wf (nfa_\<alpha> (NFA_construct_reachable_impl_code qm_ops ff II A FP D_it))
                         (NFA_remove_unreachable_states \<A>)"
proof -
 find_theorems name: "is_reachable_from_initial_subset"
  interpret NFA \<A> by fact
  let ?S = "accessible (LTS_forget_labels (\<Delta> \<A>)) (set (map q2_\<alpha> II))"
  from LTS_is_reachable_from_initial_finite I_OK have fin_S: "finite ?S" by simp
  from LTS_is_reachable_from_initial_subset I_OK have S_subset: "?S \<subseteq> \<Q> \<A>" by simp
  from f_inj_on S_subset have f_inj_on': "inj_on f ?S" by (rule subset_inj_on)

  { fix q
    have "{(a, q'). (q, a, q') \<in> \<Delta> \<A>} = 
           (\<lambda>(q,a,q'). (a,q')) ` {(q, a, q') | a q'. (q, a, q') \<in> \<Delta> \<A>}"
      by (auto simp add: image_iff)
    hence "finite {(a, q'). (q, a, q') \<in> \<Delta> \<A>}"
      apply simp
      apply (rule finite_imageI)
      apply (rule finite_subset [OF _ finite_\<Delta>])
      apply auto
    done
  } note fin_D = this

  let ?FP = "\<lambda>q. q \<in> \<F> \<A>"
  let ?I = "map q2_\<alpha> II"
  
  from NFA_construct_reachable_impl_code_correct_full [OF f_inj_on' ff_OK d_add_OK dist_I invar_I
      A_OK(1) fin_S, where ?FP = ?FP and ?D_it=D_it and selP=selP, OF _ _ _ fin_D D_it_OK FP_OK] 
       S_subset 
  have step1:
    "NFA_isomorphic (NFA_construct_reachable (set ?I) (l.\<alpha> A) ?FP (\<Delta> \<A>))
      (nfa_\<alpha> (NFA_construct_reachable_impl_code qm_ops ff II A FP D_it))"
    "nfa_invar (NFA_construct_reachable_impl_code qm_ops ff II A FP D_it)" 
      by (simp_all add: subset_iff)
 
  from NFA.NFA_remove_unreachable_states_implementation [OF wf_\<A> I_OK A_OK(2), of "?FP" "\<Delta> \<A>"]
  have step2: "NFA_construct_reachable (set ?I) (l.\<alpha> A) ?FP (\<Delta> \<A>) = NFA_remove_unreachable_states \<A>" by simp
 
  from step1(1) step2 NFA_remove_unreachable_states___is_well_formed [OF wf_\<A>] have 
    step3: "NFA_isomorphic_wf (NFA_remove_unreachable_states \<A>) 
                       (nfa_\<alpha> (NFA_construct_reachable_impl_code qm_ops ff II A FP D_it))"
    by (simp add: NFA_isomorphic_wf_def)

  from step3 have step4: "NFA (nfa_\<alpha> 
        (NFA_construct_reachable_impl_code qm_ops ff II A FP D_it))"
    unfolding NFA_isomorphic_wf_alt_def by simp

  from step3 step1(2) step4 show ?thesis
    unfolding nfa_invar_NFA_def by simp (metis NFA_isomorphic_wf_sym)
qed


subsection \<open> The following reachable function is for product of two automata \<close>

definition NFA_construct_reachable_impl_step_prod_rel where
  "NFA_construct_reachable_impl_step_prod_rel =
    build_rel (\<lambda>DS. (\<lambda>(a, q'). (a::('a set \<times> 'a set), q2_\<alpha> q')) ` DS)
              (\<lambda>DS. (\<forall>a q'. (a, q') \<in> DS \<longrightarrow> q2_invar q') \<and>
                    (\<forall>a q' q''. (a, q') \<in> DS \<longrightarrow> (a, q'') \<in> DS \<longrightarrow> 
                       ((q2_\<alpha> q' = q2_\<alpha> q'') \<longleftrightarrow> q' = q'')))"

definition NFA_construct_reachable_impl_step_prod where
"NFA_construct_reachable_impl_step_prod DS qm0 n D0 q =
  FOREACH {(a, q'). (a, q') \<in> DS q \<and> fst a \<inter> snd a \<noteq> {}} 
  (\<lambda>(a, q') ((qm, n), DD', N). do {
   let ((qm', n'), r') =
    (let r'_opt = qm.lookup (ff q') qm in
      if (r'_opt = None) then
         ((qm.update_dj (ff q') (states_enumerate n) qm, Suc n), states_enumerate n)
      else
         ((qm, n), the r'_opt)
    );
  RETURN ((qm', n'), 
    (d.add (the (qm.lookup (ff q) qm0)) (fst a \<inter> snd a) r' DD'), q' # N)
}) ((qm0, n), D0, [])"



lemma NFA_construct_reachable_impl_step_prod_correct :
fixes D II
fixes q :: "'q2_rep"
defines "I \<equiv> map q2_\<alpha> II"
defines "S \<equiv> accessible (LTS_forget_labels 
              {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) 
              (set I)"
assumes f_inj_on: "inj_on f S"
    and ff_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
    and d_add_OK: "lts_add d.\<alpha> d.invar d.add" 
    (* \<forall>q a q' q''. (q, a, q') \<in> D \<and> (q, a, q'') \<in> D \<and> q'' \<noteq> q' \<longrightarrow> *)     
    and rm_eq: "rm = state_map_\<alpha> (qm0, n)"
    and invar_qm0_n: "state_map_invar (qm0, n)"
    and D0'_eq: "D0' = d.\<alpha> D0" "D0' = \<Delta> \<A>"
    and invar_D0: "d.invar D0"
    and rm_q:  "rm (q2_\<alpha> q) = Some r"
    and r_nin: "r \<notin> \<Q> \<A>"
    and invar_q: "q2_invar q"
    and q_in_S: "q2_\<alpha> q \<in> S"
    and DS_OK: "({(a, q') | a q'.(a, q') \<in> DS q}, 
                 {(a, q'). (q2_\<alpha> q, a, q') \<in> D}) \<in> 
          NFA_construct_reachable_impl_step_prod_rel"
    and weak_invar: "NFA_construct_reachable_abstract_impl_weak_invar 
                     I (l.\<alpha> A) FP {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D} 
                     (rm, \<A>)"
shows "NFA_construct_reachable_impl_step_prod DS qm0 n D0 q \<le> 
  \<Down> (rprod (build_rel state_map_\<alpha> state_map_invar) (rprod (build_rel d.\<alpha> d.invar) 
           (map_list_rel (build_rel q2_\<alpha> q2_invar))))
     (NFA_construct_reachable_abstract_impl_step_prod
      S D rm D0' (q2_\<alpha> q))"
  unfolding NFA_construct_reachable_impl_step_prod_def
          NFA_construct_reachable_abstract_impl_step_prod_def
  using [[goals_limit = 10]]
  apply (refine_rcg)
  (* "preprocess goals" *)
  apply (subgoal_tac "inj_on (\<lambda>(a, q'). (a, q2_\<alpha> q'))
               ({(a, q'). (a, q') \<in> DS q \<and> fst a \<inter> snd a \<noteq> {}})")

  apply assumption
  apply (insert DS_OK) []
  apply (simp add: inj_on_def Ball_def NFA_construct_reachable_impl_step_prod_rel_def)
  apply (simp add: in_br_conv)
  apply blast
  (* "goal solved" *)
  apply (insert DS_OK) []
  apply (simp add: NFA_construct_reachable_impl_step_prod_rel_def)
  apply (simp add: in_br_conv br_def  case_prod_comp)
  apply (simp add: set_eq_iff)
  apply fastforce  
  (* "goal solved" *)
  apply (simp add: rm_eq D0'_eq invar_qm0_n invar_D0)
  apply (simp add: in_br_conv)
  apply (simp add: invar_D0 invar_qm0_n)
  apply (simp add:br_def)
  apply (simp add: assms(8) invar_D0)
  (* "goal solved" *)
  apply (clarify, simp)+
  apply (rename_tac it N q'' qm n D' NN a b q')
  apply (subgoal_tac "
    (qm.lookup (ff q'') qm = None \<longrightarrow>
        RETURN
         ((qm.update_dj (ff q'') (states_enumerate n) qm, Suc n), states_enumerate n)
        \<le> \<Down> (rprod (build_rel state_map_\<alpha> state_map_invar) Id)
            (SPEC
              (\<lambda>(rm', r').
                  NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'}
                   rm' \<and>
                  rm' (q2_\<alpha> q') = Some r'))) \<and>
       ((\<exists>y. qm.lookup (ff q'') qm = Some y) \<longrightarrow>
        RETURN ((qm, n), the (qm.lookup (ff q'') qm))
        \<le> \<Down> (rprod (build_rel state_map_\<alpha> state_map_invar) Id)
            (SPEC
              (\<lambda>(rm', r').
                  NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'}
                   rm' \<and>
                  rm' (q2_\<alpha> q') = Some r')))")
  apply assumption
  apply (simp del: br_def rprod_def 
  add: Let_def ff_OK pw_le_iff refine_pw_simps rprod_sv) 
  apply (rule conjI)
  apply (rule impI)
  defer
  apply (rule impI)
  apply (erule exE)
  apply (rename_tac r)
  defer
  apply (clarify, simp add: br_def)+
  apply (simp add: br_def D0'_eq)
  apply (rename_tac it N q'' qm n D' NN r' qm' n' a b q')
  defer

proof -
  fix it N q'' qm n D' NN a b q'
  assume aq'_in_it: "((a,b), q') \<in> it"
     and aq''_in_it: "((a,b), q'') \<in> it"
     and it_subset: "it \<subseteq> {(a, q'). (a, q') \<in> DS q \<and> fst a \<inter> snd a \<noteq> {}}"
     and q''_q'_eq: "q2_\<alpha> q'' = q2_\<alpha> q'"
  let ?it' = "(\<lambda> (a, q'). (a, q2_\<alpha> q')) ` it"
  assume invar_foreach: 
     "NFA_construct_reachable_abstract_impl_foreach_invar_prod
      S D rm (d.\<alpha> D0) (q2_\<alpha> q) ?it'
               (state_map_\<alpha> (qm, n), d.\<alpha> D', N)"
     and invar_qm_n: "state_map_invar (qm, n)"
     and invar_D': "d.invar D'"

  from aq'_in_it aq''_in_it it_subset DS_OK
  have invar_q': "q2_invar q'" and invar_q'': "q2_invar q''"
    by (auto simp add: NFA_construct_reachable_impl_step_prod_rel_def br_def)   
  have q'_in_S: "q2_\<alpha> q' \<in> S"
  proof -
    from DS_OK have "
        {(a, q'). (q2_\<alpha> q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}} = 
         (\<lambda> (a, q'). (a, q2_\<alpha> q')) ` {(a,q'). (a, q') \<in> DS q \<and> fst a \<inter> snd a \<noteq> {}}"
      unfolding NFA_construct_reachable_impl_step_prod_rel_def 
       apply (insert DS_OK) []
  apply (simp add: NFA_construct_reachable_impl_step_prod_rel_def)
  apply (simp add: in_br_conv br_def)
  apply (simp only: set_eq_iff)
      by (fastforce)
     with aq'_in_it it_subset have "((a, b), q2_\<alpha> q') \<in> 
          {(a, q'). (q2_\<alpha> q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}}"
       by auto
    hence "(q2_\<alpha> q, q2_\<alpha> q') \<in> LTS_forget_labels 
        {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}"
      unfolding LTS_forget_labels_def 
      NFA_construct_reachable_impl_step_prod_rel_def
      apply simp
      by (metis (mono_tags, lifting))
    with q_in_S show ?thesis unfolding S_def accessible_def
      by (simp add: rtrancl_image_advance)
  qed
  from q'_in_S q''_q'_eq have q''_in_S: "q2_\<alpha> q''\<in> S" by simp
  from ff_OK[OF invar_q'' q''_in_S] q''_q'_eq have ff_q''_eq[simp]: 
    "ff q'' = f (q2_\<alpha> q')" by simp

  define D'' where "D'' = {(a, q'). (q2_\<alpha> q, a, q') \<in> D \<and> 
                    fst a \<inter> snd a \<noteq> {}} - ?it'"
  from invar_foreach have
     qm_OK: "NFA_construct_reachable_map_OK S rm (snd ` D'') 
     (state_map_\<alpha> (qm, n))" and
     set_N_eq: "set N = snd ` D''" and
     D'_eq: "d.\<alpha> D' = D0' \<union>
       {(the (state_map_\<alpha> (qm, n) (q2_\<alpha> q)), fst a \<inter> snd a, 
         the (state_map_\<alpha> (qm, n) q')) |a q'. (a, q') \<in> D'' \<and> fst a \<inter> snd a \<noteq> {}}"
    unfolding NFA_construct_reachable_abstract_impl_foreach_invar_prod.simps 
              NFA_construct_reachable_map_OK_def
              D''_def[symmetric] 
      apply (simp add: D''_def D0'_eq )
    apply (subgoal_tac "snd `
    ({((a1, a2), q'). (q2_\<alpha> q, (a1, a2), q') \<in> D \<and> a1 \<inter> a2 \<noteq> {}} -
     (\<lambda>x. case x of (a, q') \<Rightarrow> (a, q2_\<alpha> q')) ` it)
    \<subseteq> dom (state_map_\<alpha> (qm, n))")
    apply (subgoal_tac "(\<lambda>x. case x of (a, q') \<Rightarrow> 
    (a, q2_\<alpha> q')) = (\<lambda>(a, q'). (a, q2_\<alpha> q'))")
    apply simp
    apply (subgoal_tac "{((a1, a2), q'). (q2_\<alpha> q, (a1, a2), q') \<in> D \<and> a1 \<inter> a2 \<noteq> {}}
     =  {(a, q'). (q2_\<alpha> q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}} ")
    apply simp
    apply fastforce
    apply simp
    apply simp
    apply (simp add: D''_def)
    apply (insert invar_foreach)
    apply (simp add: NFA_construct_reachable_abstract_impl_foreach_invar_prod.simps)
    apply fastforce
    apply (simp add:  D0'_eq 
          NFA_construct_reachable_abstract_impl_foreach_invar_prod.simps D''_def)
    apply simp
    by meson
  (* "... and the case that the map needs to be extended." *)
  { assume "qm.lookup (ff q'') qm = None"
    with invar_qm_n have q'_nin_dom: 
    "q2_\<alpha> q' \<notin> dom (state_map_\<alpha> (qm, n))"
      unfolding state_map_invar_def state_map_\<alpha>_def 
      by (simp add: qm.correct dom_def)

    from qm_OK have qm_OK':
      "NFA_construct_reachable_map_OK S Map.empty {} (state_map_\<alpha> (qm, n))"
      unfolding NFA_construct_reachable_map_OK_def by simp

    define qm' where "qm'= qm.update_dj 
        (f (q2_\<alpha> q')) (states_enumerate n) qm"
    from state_map_extend_thm [OF f_inj_on invar_qm_n 
                      q'_in_S q'_nin_dom qm_OK', folded qm'_def]
    have invar_qm'_n: "state_map_invar (qm', Suc n)" and
         qm'_alpha: "qm.\<alpha> qm' = qm.\<alpha> qm(f (q2_\<alpha> q') 
          \<mapsto> states_enumerate n)" and
         qm'_OK: 
          "NFA_construct_reachable_map_OK S 
           (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'} 
           (state_map_\<alpha> (qm', Suc n))"
      by simp_all

    from qm'_alpha have rm'_q': 
          "state_map_\<alpha> (qm', Suc n) (q2_\<alpha> q') = Some (states_enumerate n)"
      unfolding state_map_\<alpha>_def by simp

    define aa where "aa = state_map_\<alpha> (qm.update_dj (ff q'') 
                     (states_enumerate n) qm, Suc n)"  
    from invar_qm'_n qm'_OK rm'_q'
    show 
        "\<exists> aa. ((qm.update_dj (ff q'') (states_enumerate n) qm, Suc n), aa)
           \<in> br state_map_\<alpha> state_map_invar \<and> NFA_construct_reachable_map_OK S
        (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'} aa \<and>
        aa (q2_\<alpha> q') =
         Some (states_enumerate n)"
    proof -
      have "((qm.update_dj (ff q'') (states_enumerate n) qm, Suc n), aa)
           \<in> br state_map_\<alpha> state_map_invar \<and> NFA_construct_reachable_map_OK S
        (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'} aa \<and>
        aa (q2_\<alpha> q') =
         Some (states_enumerate n)"
        unfolding qm'_def[symmetric] ff_q''_eq aa_def
        apply (auto simp add: br_def)
        using invar_qm'_n apply blast
        using rm'_q' apply auto[1]
        apply (insert qm'_OK)
        apply (simp add: qm'_def qm'_OK NFA_construct_reachable_map_OK_def)
        apply (simp add: NFA_construct_reachable_map_OK_def)
        apply (simp add: NFA_construct_reachable_map_OK_def rm'_q')
        done
      from this show ?thesis by auto
    qed
  }
  (*  "Consider the case that the map does not need to be extended" *)
  { fix r
    assume "qm.lookup (ff q'') qm = Some r"
    define aa where "aa = (state_map_\<alpha> (qm, n))"
    with invar_qm_n qm_OK
    have " ((qm, n), aa) \<in> br state_map_\<alpha> state_map_invar \<and>
           NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'} aa \<and>
           aa (q2_\<alpha> q') = qm.lookup (ff q'') qm"
     apply (simp add: state_map_\<alpha>_def qm.correct state_map_invar_def
                    NFA_construct_reachable_map_OK_def rm_eq dom_def br_def)
      using \<open>qm.lookup (ff q'') qm = Some r\<close> qm.lookup_correct by auto
    from this
    show "\<exists> aa.((qm, n), aa) \<in> br state_map_\<alpha> state_map_invar \<and>
           NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'} aa \<and>
           aa (q2_\<alpha> q') = qm.lookup (ff q'') qm"
      by auto
  }
 
  { (* It remains to show that adding to the transition systems works. 
        Here, a case distinction
        depending on whether the input is weak deterministic, is needed. *)
    fix r'

    from qm_OK rm_q have r_intro1: "state_map_\<alpha> (qm, n) (q2_\<alpha> q) = Some r"
      unfolding NFA_construct_reachable_map_OK_def by simp

    from rm_q rm_eq have r_intro2: "qm.lookup (ff q) qm0 = Some r" 
      using invar_qm0_n
      unfolding state_map_\<alpha>_def state_map_invar_def
      using ff_OK [OF invar_q q_in_S] by (simp add: qm.correct)

    have "insert (r, a \<inter> b, r') (d.\<alpha> D') = d.\<alpha> (d.add r (a \<inter> b) r' D') \<and>
          d.invar (d.add r (a \<inter> b) r' D')"
      by (metis d_add_OK invar_D' lts_add_def)
    from this D0'_eq show 
          "insert (the (state_map_\<alpha> (qm, n) (q2_\<alpha> q)), a \<inter> b, r') (d.\<alpha> D') =
          d.\<alpha> (d.add (the (qm.lookup (ff q) qm0)) (a \<inter> b) r' D') \<and>
          d.invar (d.add (the (qm.lookup (ff q) qm0)) (a \<inter> b) r' D') \<and>
          q2_invar q''"   
      by (simp add: r_intro1 r_intro2 invar_q'')
  } 
qed

definition NFA_construct_reachable_prod_impl where
  "NFA_construct_reachable_prod_impl S I A FP DS  =
   do {
     let ((qm, n), Is) = NFA_construct_reachable_init_impl I;
     (((qm, n), \<A>), _) \<leftarrow> WORKLISTT (\<lambda>_. True)
      (\<lambda>((qm, n), AA) q. 
         if (s.memb (the (qm.lookup (ff q) qm)) (nfa_states AA)) then
           (RETURN (((qm, n), AA), []))
         else                    
           do {
             ASSERT (q2_invar q \<and> q2_\<alpha> q \<in> S);
             ((qm', n'), DD', N) \<leftarrow> 
             NFA_construct_reachable_impl_step_prod DS qm n (nfa_trans AA) q;
             RETURN (((qm', n'), 
                 (s.ins_dj (the (qm.lookup (ff q) qm)) (nfa_states AA), 
                  nfa_labels AA, DD', nfa_initial AA, 
                  (if (FP q) then (s.ins_dj (the (qm.lookup (ff q) qm))) 
                    (nfa_accepting AA) else (nfa_accepting AA)))), N)
           }
        ) (((qm, n), (s.empty (), A, d.empty, Is, s.empty ())), I);
     RETURN \<A>
   }"



lemma NFA_construct_reachable_prod_impl_correct :
fixes D II
defines "I \<equiv> map q2_\<alpha> II"
defines "R \<equiv> build_rel nfa_\<alpha> nfa_invar"
defines "R' \<equiv> build_rel state_map_\<alpha> state_map_invar"
defines "S \<equiv> accessible (LTS_forget_labels 
          {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) (set I)"
assumes f_inj_on: "inj_on f S"
    and ff_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
    and d_add_OK: (* "\<forall>q a q' q''. (q, a, q') \<in> D \<and> (q, a, q'') \<in> D \<and> q'' \<noteq> q' \<longrightarrow> *)
          "lts_add d.\<alpha> d.invar d.add"
    and dist_I: "distinct I"
    and invar_I: "\<And>q. q \<in> set II \<Longrightarrow> q2_invar q" 
    and invar_A: "l.invar A"
    and DS_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> 
       (DS q, {(a, q'). (q2_\<alpha> q, a, q') \<in> D}) 
        \<in> NFA_construct_reachable_impl_step_prod_rel"
    and FFP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> FFP q \<longleftrightarrow> FP (q2_\<alpha> q)"
shows "NFA_construct_reachable_prod_impl S II A FFP DS \<le>
   \<Down> R (NFA_construct_reachable_abstract2_prod_impl I (l.\<alpha> A) FP D)"

unfolding NFA_construct_reachable_prod_impl_def 
          NFA_construct_reachable_abstract2_prod_impl_def 
          WORKLISTT_def
using [[goals_limit = 5]]
apply (refine_rcg)
(* preprocess goals
   initialisation is OK *)
   apply (unfold I_def)
   apply (rule NFA_construct_reachable_init_impl_correct)
  apply (insert f_inj_on ff_OK dist_I invar_I)[4]
  apply (simp_all add: S_def I_def)[4]
  (* goal solved *)
  apply (subgoal_tac "single_valued (rprod R' R)")
  apply assumption
  apply (simp add: rprod_sv R'_def R_def del: rprod_def br_def)
  (* goal solved *)
  apply (subgoal_tac "single_valued (build_rel q2_\<alpha> q2_invar)")
  apply assumption
  apply (simp del: br_def)
  (* goal solved *)
  apply (simp add: br_def R'_def R_def nfa_invar_def 
          s.correct d.correct_common invar_A)
  (* goal solved *)
  defer
  apply simp
  (* goal solved *)
  apply simp
  (* goal solved *)
  apply (clarify, simp add: br_def)+
  apply (rename_tac q rm \<A> qm n Qs As DD Is Fs r)
  defer
  apply (simp add: rprod_sv R'_def R_def del: rprod_def br_def)
  (* goal solved *)
  apply (simp add: br_def)
  (* goal solved *)
  apply (simp add: br_def)
  (* goal solved *)
  apply (simp add: S_def I_def)
  (* goal solved *)
  defer
  defer
  apply (simp add: S_def I_def)
  apply (simp add: S_def I_def br_def)
  apply (simp add: invar_I list.rel_map(2) list.rel_refl_strong)
  apply (simp add: S_def I_def br_def R_def R'_def)
  defer
  (* goal solved
    -- "step OK *)
  apply (unfold I_def[symmetric])
  apply (clarify, simp)+ 
  apply (simp add: br_def)
  apply (unfold I_def)
  apply (rule_tac NFA_construct_reachable_impl_step_prod_correct)
  apply (unfold I_def[symmetric])
  apply (simp_all add: nfa_invar_def f_inj_on[unfolded S_def] ff_OK[unfolded S_def] 
                       d_add_OK DS_OK[unfolded S_def]) [14] 
  (* goal solved *)
  apply (simp add: rprod_sv R'_def R_def  rprod_def br_def)
  (* goal solved *)
  apply (simp add: R_def br_def R'_def)
  (* goal solved *)
  apply (clarify, simp split del: if_splits add: R_def br_def)+
  apply (unfold S_def[symmetric] nfa_accepting_def snd_conv)
  apply (simp add: br_def nfa_invar_def 
                    NFA_construct_reachable_impl_step_prod_rel_def)
  apply (insert DS_OK)
  apply (subgoal_tac "\<And> q. {((a, b), q') |a b q'. ((a, b), q') \<in> DS q} = DS q")
  apply (simp add: br_def nfa_invar_def DS_OK)
  apply fast
  apply (clarify, simp split del: if_splits add:  R'_def)
  apply (rename_tac q' qm'' n'' \<A> qm n Qs As DD Is Fs q2 q1 bga qm' n' D' bja r)
  apply (simp add: br_def)
  defer
using [[goals_limit = 6]]
proof -
  fix q rm \<A> qm n Qs As DD Is Fs r
  {
   assume rm_q: "state_map_\<alpha> (qm, n) (q2_\<alpha> q) = Some r" and
         in_R': "rm = state_map_\<alpha> (qm, n) \<and> state_map_invar (qm, n)" and
         in_R: "\<A> = nfa_\<alpha> (Qs, As, DD, Is, Fs) \<and> nfa_invar (Qs, As, DD, Is, Fs)" and
         invar_q: "q2_invar q" and
         q_in: "q2_\<alpha> q \<in> accessible (LTS_forget_labels 
                {(q, a1 \<inter> a2, q') |q a1 a2 q'. (q, (a1, a2), q') \<in> D}
                ) (q2_\<alpha> ` set II)"

  from q_in have q_in_S: "q2_\<alpha> q \<in> S" unfolding S_def I_def by simp

  from in_R' rm_q ff_OK[OF invar_q q_in_S] have "qm.lookup (ff q) qm = Some r"
    unfolding R'_def 
    by (simp add: state_map_invar_def state_map_\<alpha>_def qm.correct br_def)

  with in_R show "s.memb (the (qm.lookup (ff q) qm)) Qs = (r \<in> s.\<alpha> Qs)"
    unfolding R_def by (simp add: nfa_invar_def s.correct)
}
  {
  fix x1 x2 x1b x2a x2b q' qm'' n'' \<A> qm n Qs As DD Is Fs q2 q1 bga qm' n' D' bja r
    assume r_nin_Q: "r \<notin> \<Q> \<A>" and 
       rm_q': "state_map_\<alpha> (qm, n) (q2_\<alpha> q') = Some r" and
       weak_invar: "NFA_construct_reachable_abstract_impl_weak_invar 
             I (l.\<alpha> A) FP {(q, a1 \<inter> a2, q') |q a1 a2 q'. (q, (a1, a2), q') \<in> D}
         (state_map_\<alpha> (qm, n), \<A>)" and
       invar_qm_n: "q2 = state_map_\<alpha> (qm', n') \<and>
       state_map_invar (qm', n') \<and>
       q1 = d.\<alpha> D' \<and>
       d.invar D' \<and> list_all2 (\<lambda>x x'. x' = q2_\<alpha> x \<and> q2_invar x) bja bga" and
       in_R: "n'' = state_map_\<alpha> (qm, n) \<and>
       state_map_invar (qm, n) \<and> ((Qs, As, DD, Is, Fs), \<A>) \<in> R" and
       invar_q': "q2_invar q'" and 
       q'_in_S: "q2_\<alpha> q' \<in> S"
 

  from rm_q' invar_qm_n ff_OK[OF invar_q' q'_in_S] 
      have qm_f_q': "qm.lookup (ff q') qm = Some r"
     unfolding state_map_\<alpha>_def state_map_invar_def 
     apply (simp add: qm.correct)
     using in_R qm.lookup_correct state_map_invar_def by auto

  from in_R r_nin_Q have r_nin_Qs: "r \<notin> s.\<alpha> Qs" by (simp add: R_def br_def)

  from weak_invar have "\<F> \<A> \<subseteq> \<Q> \<A>"
    unfolding NFA_construct_reachable_abstract_impl_weak_invar_def by auto
  with r_nin_Q have "r \<notin> \<F> \<A>" by auto
  with in_R have r_nin_Fs: "r \<notin> s.\<alpha> Fs" by (simp add: R_def br_def)

  from in_R FFP_OK[OF invar_q' q'_in_S]
  have "((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, As, D', Is,
         if FFP q' then s.ins_dj (the (qm.lookup (ff q') qm)) 
          (snd (snd (snd (snd (Qs, As, DD, Is, Fs))))) else 
           (snd (snd (snd (snd (Qs, As, DD, Is, Fs)))))),
        \<lparr>\<Q> = insert r (\<Q> \<A>), \<Sigma> = \<Sigma> \<A>, \<Delta> = d.\<alpha> D', \<I> = \<I> \<A>,
           \<F> = if FP (q2_\<alpha> q') then insert 
           (the (state_map_\<alpha> (qm, n) (q2_\<alpha> q'))) (\<F> \<A>) else \<F> \<A>\<rparr>)
       \<in> R" 
    by (simp add: rm_q' qm_f_q' R_def nfa_\<alpha>_def 
                nfa_invar_def invar_qm_n s.correct r_nin_Qs r_nin_Fs br_def)
  from this show "(FFP q' \<longrightarrow>
        (FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, As, D', Is,
           s.ins_dj (the (qm.lookup (ff q') qm)) Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Sigma> = \<Sigma> \<A>, \<Delta> = d.\<alpha> D', \<I> = \<I> \<A>, \<F> = insert r (\<F> \<A>)\<rparr>)
         \<in> R) \<and>
        (\<not> FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, As, D', Is,
           s.ins_dj (the (qm.lookup (ff q') qm)) Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Sigma> = \<Sigma> \<A>, \<Delta> = d.\<alpha> D', \<I> = \<I> \<A>, \<F> = \<F> \<A>\<rparr>)
         \<in> R)) \<and>
       (\<not> FFP q' \<longrightarrow>
        (FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, As, D', Is, Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Sigma> = \<Sigma> \<A>, \<Delta> = d.\<alpha> D', \<I> = \<I> \<A>, \<F> = insert r (\<F> \<A>)\<rparr>)
         \<in> R) \<and>
        (\<not> FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, As, D', Is, Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Sigma> = \<Sigma> \<A>, \<Delta> = d.\<alpha> D', \<I> = \<I> \<A>, \<F> = \<F> \<A>\<rparr>)
         \<in> R)) "
    using rm_q' by auto
}
qed

lemma NFA_construct_reachable_prod_impl_alt_def :
  "NFA_construct_reachable_prod_impl S I A FP DS =
   do {
     let ((qm, n), Is) = NFA_construct_reachable_init_impl I;
     ((_, \<A>), _) \<leftarrow> WORKLISTT (\<lambda>_. True)
      (\<lambda>((qm, n), (Qs, As, DD, Is, Fs)) q. do { 
         let r = the (qm.lookup (ff q) qm);
         if (s.memb r Qs) then
           (RETURN (((qm, n), (Qs, As, DD, Is, Fs)), []))
         else                    
           do {
             ASSERT (q2_invar q \<and> q2_\<alpha> q \<in> S);
             ((qm', n'), DD', N) \<leftarrow> 
                NFA_construct_reachable_impl_step_prod DS qm n DD q;
             RETURN (((qm', n'), 
                 (s.ins_dj r Qs, 
                  As, DD', Is, 
                  (if (FP q) then (s.ins_dj r Fs) else Fs))), N)
           }
         }
        ) (((qm, n), (s.empty (), A, d.empty, Is, s.empty ())), I);
     RETURN \<A>
   }"
unfolding NFA_construct_reachable_prod_impl_def
apply (simp add: Let_def split_def)
apply (unfold nfa_selectors_def fst_conv snd_conv prod.collapse)
apply simp
done



schematic_goal NFA_construct_reachable_prod_impl_code_aux: 
fixes D_it :: "'q2_rep \<Rightarrow> ((('a set \<times> 'a set) \<times> 'q2_rep),
                     ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) set_iterator"
assumes D_it_OK[rule_format, refine_transfer]: 
         "\<forall>q. q2_invar q \<longrightarrow> q2_\<alpha> q \<in> S \<longrightarrow> set_iterator (D_it q) 
                             {p \<in> DS q. fst (fst p) \<inter> snd (fst p)\<noteq> {}}"
shows "RETURN ?f \<le> NFA_construct_reachable_prod_impl S I A FP DS"
 unfolding NFA_construct_reachable_prod_impl_alt_def 
    WORKLISTT_def NFA_construct_reachable_impl_step_prod_def
  apply (unfold split_def snd_conv fst_conv prod.collapse)
  apply (rule refine_transfer | assumption | erule conjE)+
done


definition (in automaton_by_lts_defs) NFA_construct_reachable_prod_impl_code where
"NFA_construct_reachable_prod_impl_code qm_ops (ff::'q2_rep \<Rightarrow> 'i) I A FP D_it =
(let ((qm, n), Is) = foldl (\<lambda>((qm, n), Is) q. 
         ((map_op_update_dj qm_ops (ff q) (states_enumerate n) qm, Suc n),
             s.ins_dj (states_enumerate n) Is))
                ((map_op_empty qm_ops (), 0), s.empty()) I;
     ((_, AA), _) = worklist (\<lambda>_. True)
        (\<lambda>((qm, n), Qs, As, DD, Is, Fs) (q::'q2_rep).
            let r = the (map_op_lookup qm_ops (ff q) qm)
            in if set_op_memb s_ops r Qs then (((qm, n), Qs, As, DD, Is, Fs), [])
               else let ((qm', n'), DD', N) = D_it q (\<lambda>_::(('m \<times> nat) \<times> 'd \<times> 'q2_rep list). True)
                           (\<lambda>(a, q') ((qm::'m, n::nat), DD'::'d, N::'q2_rep list).
                               let r'_opt = map_op_lookup qm_ops (ff q') qm; 
                                   ((qm', n'), r') = if r'_opt = None then 
                                       let r'' = states_enumerate n in 
                                          ((map_op_update_dj qm_ops (ff q') r'' qm, Suc n), r'') 
                                      else ((qm, n), the r'_opt)
                               in ((qm', n'), clts_op_add d_ops r (fst a \<inter> snd a) r' DD', q' # N))
                           ((qm, n), DD, [])
                    in (((qm', n'), set_op_ins_dj s_ops r Qs, As, DD', Is, if FP q then set_op_ins_dj s_ops r Fs else Fs), N))
        (((qm, n), set_op_empty s_ops (), A, 
   clts_op_empty d_ops, Is, set_op_empty s_ops ()), I)
 in AA)"


lemma NFA_construct_reachable_prod_impl_code_correct: 
fixes D_it :: "'q2_rep \<Rightarrow> ((('a set \<times> 'a set) \<times> 'q2_rep),
                     ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) set_iterator"
assumes D_it_OK: "\<forall> q. q2_invar q \<longrightarrow> q2_\<alpha> q \<in> S \<longrightarrow> 
                  set_iterator (D_it q) {p \<in> DS q. fst (fst p) \<inter> snd (fst p) \<noteq> {}}"
shows "RETURN (NFA_construct_reachable_prod_impl_code qm_ops ff I A FP D_it) \<le> 
               NFA_construct_reachable_prod_impl S I A FP DS"
proof -
  have rule: 
   "\<And>f1 f2. \<lbrakk>RETURN f1 \<le> NFA_construct_reachable_prod_impl S I A FP DS; f1 = f2\<rbrakk> \<Longrightarrow>
              RETURN f2 \<le> NFA_construct_reachable_prod_impl S I A FP DS" by simp
  
  note aux_thm = NFA_construct_reachable_prod_impl_code_aux[OF D_it_OK, of I FP A]

  note rule' = rule[OF aux_thm]
  show ?thesis 
    apply (rule rule')
    apply (simp add: NFA_construct_reachable_prod_impl_code_def 
              split_def Let_def NFA_construct_reachable_init_impl_def
                cong: if_cong)
  done
qed

lemma NFA_construct_reachable_prod_impl_code_correct_full: 
fixes D_it :: "'q2_rep \<Rightarrow> ((('a set \<times> 'a set) \<times> 'q2_rep),('m \<times> nat) 
        \<times> 'd \<times> 'q2_rep list) set_iterator"
fixes II D DS
defines "S \<equiv> accessible (LTS_forget_labels 
             {(q, a1 \<inter> a2, q') |q a1 a2 q'. (q, (a1, a2), q') \<in> D})
             (set (map q2_\<alpha> II))"
assumes f_inj_on: "inj_on f S"
    and ff_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
    and d_add_OK: 
          (* "\<forall>q a q' q''. (q, a, q') \<in> D \<and> (q, a, q'') \<in> D \<and> q'' \<noteq> q' \<longrightarrow> *)
          "lts_add d.\<alpha> d.invar d.add"
    and dist_I: "distinct (map q2_\<alpha> II)"
    and invar_I: "\<And>q. q \<in> set II \<Longrightarrow> q2_invar q" 
    and invar_A: "l.invar A"
    and fin_S: "finite S"
    and fin_D: "\<And>q. finite {(a, q'). (q, a, q') \<in> D}"
    and D_it_OK: "(\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> 
            (set_iterator_genord (D_it q) 
            {p \<in> DS q. fst (fst p) \<inter> snd (fst p) \<noteq> {}} selP \<and>
             ((DS q), {(a, q'). (q2_\<alpha> q, a, q') \<in> D }) \<in> 
            NFA_construct_reachable_impl_step_prod_rel))"
    and FFP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> FFP q \<longleftrightarrow> FP (q2_\<alpha> q)"
  shows "NFA_isomorphic 
    (NFA_construct_reachable (set (map q2_\<alpha> II)) (l.\<alpha> A) FP 
                               {(q, a1 \<inter> a2, q') |q a1 a2 q'. (q, (a1, a2), q') \<in> D})
    (nfa_\<alpha> (NFA_construct_reachable_prod_impl_code qm_ops ff II A FFP D_it)) 
      \<and>
       nfa_invar (NFA_construct_reachable_prod_impl_code qm_ops ff II A FFP D_it)"
proof - 
  have fin_Ds: "(\<And>q. finite {(a, q'). (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}})"
  proof -
    fix q
    have "finite {(a, q'). (q, a, q') \<in> D}"
      by (simp add: fin_D)
    have "{(a, q'). (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}} \<subseteq> 
                    {(a, q'). (q, a, q') \<in> D}" by auto
    from this show "finite {(a, q'). (q, a, q') \<in> D \<and> fst a \<inter> snd a \<noteq> {}}"
    by (simp add: finite_subset fin_D)
  qed
  
  have D_it_OK'' : "\<forall>q. q2_invar q \<longrightarrow> q2_\<alpha> q \<in> S \<longrightarrow>
      set_iterator (D_it q) {p \<in> DS q. fst (fst p) \<inter> snd (fst p) \<noteq> {}}"
  proof (intro allI impI)
    fix q
    assume "q2_invar q" "q2_\<alpha> q \<in> S"
    with D_it_OK[of q] show
      "set_iterator (D_it q) {p \<in> DS q. fst (fst p) \<inter> snd (fst p) \<noteq> {}}"
      using set_iterator_intro by blast
    qed 
  
  note NFA_construct_reachable_prod_impl_code_correct [OF D_it_OK'']
  also 
  have "NFA_construct_reachable_prod_impl S II A FFP DS \<le> \<Down> (build_rel nfa_\<alpha> nfa_invar)
     (NFA_construct_reachable_abstract2_prod_impl (map q2_\<alpha> II) (l.\<alpha> A) FP D)"
    using NFA_construct_reachable_prod_impl_correct 
        [OF f_inj_on[unfolded S_def] ff_OK[unfolded S_def] d_add_OK
          dist_I invar_I invar_A, of DS FFP FP] FFP_OK S_def 
    by (auto simp add: FFP_OK D_it_OK)
  also note NFA_construct_reachable_abstract2_impl_prod_correct
  also note NFA_construct_reachable_abstract_impl_prod_correct
  finally have 
    "RETURN (NFA_construct_reachable_prod_impl_code qm_ops ff II A FFP D_it) 
      \<le> \<Down> (build_rel nfa_\<alpha> nfa_invar)
     (SPEC (NFA_isomorphic (NFA_construct_reachable
       (set (map q2_\<alpha> II)) (l.\<alpha> A) FP 
        {(q, a1 \<inter> a2, q') |q a1 a2 q'. (q, (a1, a2), q') \<in> D})))"
    using S_def fin_S fin_D
    by (simp add: S_def[symmetric] fin_S fin_Ds)
  thus ?thesis 
    by (erule_tac RETURN_ref_SPECD, simp add: br_def)
qed

lemma NFA_construct_reachable_prod_impl_code_correct___remove_unreachable: 
fixes D_it :: "'q2_rep \<Rightarrow> ((('a set \<times> 'a set) \<times> 'q2_rep) , 
              ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) 
      set_iterator"
fixes II D DS
assumes d_add_OK: 
  (* "\<forall>q a q' q''. (q, a, q') \<in> \<Delta> \<A> \<and> (q, a, q'') \<in> \<Delta> \<A> \<and> q'' \<noteq> q' \<longrightarrow> *)
          "lts_add d.\<alpha> d.invar d.add"
    and f_inj_on: "inj_on f (\<Q> \<A>)"
    and D_\<A>_ok: "\<Delta> \<A> = {(q,fst a \<inter> snd a, q')| q a q'. (q, a, q') \<in> D}"
    and finite_D: "finite D"
    and ff_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> (\<Q> \<A>) \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
    and dist_I: "distinct (map q2_\<alpha> II)" 
    and invar_I: "\<And>q. q \<in> set II \<Longrightarrow> q2_invar q" 
    and I_OK: "set (map q2_\<alpha> II) = \<I> \<A>"
    and A_OK: "l.invar A" "l.\<alpha> A = \<Sigma> \<A>"
    and D_it_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow>
                    set_iterator_genord (D_it q) {p \<in> DS q. 
                     fst (fst p) \<inter> snd (fst p) \<noteq> {}} selP \<and>
                    (DS q, {(a, q'). (q2_\<alpha> q, a, q') \<in> D}) 
                    \<in> NFA_construct_reachable_impl_step_prod_rel"
    and FP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> FP q \<longleftrightarrow> (q2_\<alpha> q) \<in> \<F> \<A>"
    and wf_\<A>: "NFA \<A>"
  shows "nfa_invar_NFA 
          (NFA_construct_reachable_prod_impl_code qm_ops ff II A FP D_it) \<and>
           NFA_isomorphic_wf (nfa_\<alpha> (NFA_construct_reachable_prod_impl_code 
                                    qm_ops ff II A FP D_it))
                         (NFA_remove_unreachable_states \<A>)"
proof -
 find_theorems name: "is_reachable_from_initial_subset"
  interpret NFA \<A> by fact
  let ?S = "accessible (LTS_forget_labels (\<Delta> \<A>)) (set (map q2_\<alpha> II))"
  let ?D = "{(q, a1 \<inter> a2, q')| q a1 a2 q'. (q, (a1,a2), q') \<in> D}"
  from LTS_is_reachable_from_initial_finite I_OK have fin_S: "finite ?S" by simp
  from D_\<A>_ok fin_S have fin_S':
   "finite (accessible (LTS_forget_labels (?D)) (set (map q2_\<alpha> II)))" by simp
  from LTS_is_reachable_from_initial_subset I_OK have S_subset: "?S \<subseteq> \<Q> \<A>" by simp
  from f_inj_on S_subset have f_inj_on': "inj_on f ?S" by (rule subset_inj_on)
  from f_inj_on' D_\<A>_ok have f_inj_on'': "inj_on f 
            (accessible 
              (LTS_forget_labels 
               ?D)
              (set (map q2_\<alpha> II)))
            "
    by simp
  
  { fix q
    have "{(a, q'). (q, a, q') \<in> \<Delta> \<A>} = 
           (\<lambda>(q,a,q'). (a,q')) ` {(q, a, q') | a q'. (q, a, q') \<in> \<Delta> \<A>}"
      by (auto simp add: image_iff)
    hence "finite {(a, q'). (q, a, q') \<in> \<Delta> \<A>}"
      apply simp
      apply (rule finite_imageI)
      apply (rule finite_subset [OF _ finite_\<Delta>])
      apply auto
    done
} note fin_D = this

  
{ fix q
  from finite_D 
  have "{(a, q'). (q, a, q') \<in> D} = 
           (\<lambda>(q,a,q'). (a,q')) ` {(q, a, q') | a q'. (q, a, q') \<in> D}"
      by (auto simp add: image_iff)
  hence finite_D': "finite {(a, q'). (q, a, q') \<in> D}"
  apply simp
      apply (rule finite_imageI)
      apply (rule finite_subset [OF _ finite_D])
      apply auto
    done
 }note finite_D' = this
    

  let ?FP = "\<lambda>q. q \<in> \<F> \<A>"
  let ?I = "map q2_\<alpha> II"
  
  from NFA_construct_reachable_prod_impl_code_correct_full 
        [OF f_inj_on'' ff_OK d_add_OK dist_I invar_I
           A_OK(1) fin_S', where ?FP = ?FP and ?D_it=D_it and 
           selP=selP, OF _ _ _ finite_D' D_it_OK FP_OK] 
       S_subset 
  have step1:
    "NFA_isomorphic (NFA_construct_reachable (set ?I) (l.\<alpha> A) ?FP (\<Delta> \<A>))
      (nfa_\<alpha> (NFA_construct_reachable_prod_impl_code qm_ops ff II A FP D_it))"
    "nfa_invar (NFA_construct_reachable_prod_impl_code qm_ops ff II A FP D_it)" 
    by (simp_all add: subset_iff D_\<A>_ok)
   
 
  from NFA.NFA_remove_unreachable_states_implementation [OF wf_\<A> I_OK A_OK(2), of "?FP" "\<Delta> \<A>"]
  have step2: "NFA_construct_reachable (set ?I) (l.\<alpha> A) ?FP (\<Delta> \<A>) = NFA_remove_unreachable_states \<A>" by simp
 
  from step1(1) step2 NFA_remove_unreachable_states___is_well_formed [OF wf_\<A>] have 
    step3: "NFA_isomorphic_wf (NFA_remove_unreachable_states \<A>) 
                       (nfa_\<alpha> (NFA_construct_reachable_prod_impl_code 
                                qm_ops ff II A FP D_it))"
    by (simp add: NFA_isomorphic_wf_def)

  from step3 have step4: "NFA (nfa_\<alpha> 
        (NFA_construct_reachable_prod_impl_code qm_ops ff II A FP D_it))"
    unfolding NFA_isomorphic_wf_alt_def by simp

  from step3 step1(2) step4 show ?thesis
    unfolding nfa_invar_NFA_def by simp (metis NFA_isomorphic_wf_sym)
qed


end

lemma (in nfa_by_lts_defs) NFA_construct_reachable_prod_impl_code_correct :
  fixes qm_ops :: "('i, 'q::{NFA_states}, 'm, _) map_ops_scheme" 
    and q2_\<alpha> :: "'q2_rep \<Rightarrow> 'q2"
    and q2_invar :: "'q2_rep \<Rightarrow> bool" 
  assumes "StdMap qm_ops"
  shows "NFASpec.nfa_construct_prod nfa_\<alpha> nfa_invar_NFA l.\<alpha> l.invar q2_\<alpha> q2_invar 
                 (NFA_construct_reachable_prod_impl_code qm_ops)"
proof (intro nfa_construct_prod.intro nfa_by_map_correct 
       nfa_construct_prod_axioms.intro)
  fix \<A>:: "('q2, 'a) NFA_rec" and f :: "'q2 \<Rightarrow> 'i" and ff I A FP D_it selP
  fix D_it :: "'q2_rep \<Rightarrow> ((('a set \<times> 'a set) \<times> 'q2_rep), 
      ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) set_iterator"
  fix D DS
  assume wf_\<A>: "NFA \<A>" 
     and D_\<A>_ok: "{(q,fst a \<inter> snd a, q')| q a q'. (q, a, q') \<in> D} = (\<Delta> \<A>)"
     and finite_D: "finite D"
     and f_inj_on: "inj_on f (\<Q> \<A>)"
     and f_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> (\<Q> \<A>) \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
     and dist_I: "distinct (map q2_\<alpha> I)"
     and invar_I: "\<And>q. q \<in> set I \<Longrightarrow> q2_invar q"
     and I_OK: "q2_\<alpha> ` set I = \<I> \<A>"
     and invar_A: "l.invar A"
     and A_OK: "l.\<alpha> A = \<Sigma> \<A>"
     and FP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> FP q = (q2_\<alpha> q \<in> \<F> \<A>)"
     and D_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> 
              set_iterator (D_it q) {(a, q'). (a, q') \<in> (DS q) 
                     \<and> fst a \<inter> snd a \<noteq> {}} \<and>
                   {(a, q'). (q2_\<alpha> q, a, q') \<in> D} = 
                    (\<lambda>(a, q'). (a, q2_\<alpha> q')) ` (DS q) \<and>
                   (\<forall>a q'. (a, q') \<in> (DS q) \<longrightarrow> q2_invar q') \<and>
                   (\<forall>a q'. (a, q') \<in> (DS q) \<longrightarrow>
                           (\<forall>q''. (a, q'') \<in> (DS q) \<longrightarrow> 
                    (q2_\<alpha> q' = q2_\<alpha> q'') = (q' = q'')))"

  from nfa_by_lts_defs_axioms have d_OK: "lts_add d.\<alpha> d.invar d.add" 
    unfolding nfa_by_lts_defs_def StdLTS_def by simp

  from D_\<A>_ok have D_\<A>_ok': 
      "(\<Delta> \<A>) = {(q,fst a \<inter> snd a, q')| q a q'. (q, a, q') \<in> D}" by simp

  from `StdMap qm_ops` 
  interpret reach: NFA_construct_reachable_locale s_ops l_ops d_ops qm_ops f ff q2_\<alpha> q2_invar
    using automaton_by_lts_defs_axioms f_OK
    unfolding NFA_construct_reachable_locale_def automaton_by_lts_defs_def by simp

  thm reach.NFA_construct_reachable_prod_impl_code_correct___remove_unreachable
  [OF _ f_inj_on D_\<A>_ok' finite_D f_OK dist_I invar_I _ invar_A A_OK _ _ wf_\<A>]
  note correct = 
      reach.NFA_construct_reachable_prod_impl_code_correct___remove_unreachable
  [OF _ f_inj_on D_\<A>_ok' finite_D f_OK dist_I invar_I _ invar_A A_OK _ _ wf_\<A>, 
     of D_it DS "(\<lambda>_ _. True)" FP]

  show "nfa_invar_NFA (NFA_construct_reachable_prod_impl_code qm_ops ff I A FP D_it) \<and>
       NFA_isomorphic_wf (nfa_\<alpha> (NFA_construct_reachable_prod_impl_code 
            qm_ops ff I A FP D_it))
        (NFA_remove_unreachable_states \<A>)"
    apply (rule_tac correct)
          apply (simp_all add: I_OK d_OK FP_OK 
            reach.NFA_construct_reachable_impl_step_prod_rel_def)
    apply (insert D_OK f_OK)
    apply (simp add:  set_iterator_def br_def)
    
  proof -
    fix q 
    assume q2_invar_q: "q2_invar q" and
           q2_\<alpha>_q: "q2_\<alpha> q \<in> \<Q> \<A>"  and
           prem: "(\<And>q. q2_invar q \<Longrightarrow>
               q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow>
                  set_iterator_genord (D_it q) {(a, q'). (a, q') \<in> (DS q) 
                  \<and> fst a \<inter> snd a \<noteq> {}}
                   (\<lambda>_ _. True) \<and>
                  {(a, q'). (q2_\<alpha> q, a, q') \<in> D} =
                  (\<lambda>x. case x of (a, q') \<Rightarrow> (a, q2_\<alpha> q')) ` (DS q) \<and>
                  (\<forall>a b q'. ((a,b), q') \<in> (DS q) \<longrightarrow> q2_invar q') \<and>
                  (\<forall>a b q'.
                      ((a, b), q') \<in> (DS q) \<longrightarrow>
                      (\<forall>q''. ((a, b), q'') \<in> (DS q) \<longrightarrow>
                             (q2_\<alpha> q' = q2_\<alpha> q'') = (q' = q''))))" and
            q2_invar_ff_f: "(\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> ff q = f (q2_\<alpha> q))"
    from prem this show " set_iterator_genord (D_it q) 
          {p \<in> DS q. fst (fst p) \<inter> snd (fst p) \<noteq> {}} (\<lambda>_ _. True)"
      apply (subgoal_tac "{(a, q'). (a, q') \<in> (DS q) \<and> fst a \<inter> snd a \<noteq> {}} 
                           = {p \<in> DS q. fst (fst p) \<inter> snd (fst p) \<noteq> {}}")
      apply force
      apply auto[1]
      done
  qed
  
qed
  

lemma (in nfa_by_lts_defs) NFA_construct_reachable_prod_impl_code_correct_no_enc:
  assumes qm_OK: "StdMap qm_ops"
  shows "NFASpec.nfa_construct_no_enc_prod
       nfa_\<alpha> nfa_invar_NFA l.\<alpha> l.invar (NFA_construct_reachable_prod_impl_code qm_ops)"
  by  (intro NFASpec.nfa_construct_no_enc_prod_default
      NFA_construct_reachable_prod_impl_code_correct qm_OK)


lemma (in nfa_by_lts_defs) NFA_construct_reachable_impl_code_correct :
  fixes qm_ops :: "('i, 'q::{NFA_states}, 'm, _) map_ops_scheme" 
    and q2_\<alpha> :: "'q2_rep \<Rightarrow> 'q2"
    and q2_invar :: "'q2_rep \<Rightarrow> bool" 
  assumes "StdMap qm_ops"
  shows "NFASpec.nfa_construct nfa_\<alpha> nfa_invar_NFA l.\<alpha> l.invar q2_\<alpha> q2_invar 
                 (NFA_construct_reachable_impl_code qm_ops)"
proof (intro nfa_construct.intro nfa_by_map_correct nfa_construct_axioms.intro)
  fix \<A>:: "('q2, 'a) NFA_rec" and f :: "'q2 \<Rightarrow> 'i" and ff I A FP D_it selP
  fix D_it :: "'q2_rep \<Rightarrow> (('a set \<times> 'q2_rep), 
      ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) set_iterator"
  fix DS
  assume wf_\<A>: "NFA \<A>" 
     and f_inj_on: "inj_on f (\<Q> \<A>)"
     and f_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> (\<Q> \<A>) \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
     and dist_I: "distinct (map q2_\<alpha> I)"
     and invar_I: "\<And>q. q \<in> set I \<Longrightarrow> q2_invar q"
     and I_OK: "q2_\<alpha> ` set I = \<I> \<A>"
     and invar_A: "l.invar A"
     and A_OK: "l.\<alpha> A = \<Sigma> \<A>"
     and FP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> FP q = (q2_\<alpha> q \<in> \<F> \<A>)"
     and D_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> 
              set_iterator (D_it q) {(a, q'). (a, q') \<in> (DS q) \<and> a \<noteq> {}} \<and>
                   {(a, q'). (q2_\<alpha> q, a, q') \<in> \<Delta> \<A>} = 
                    (\<lambda>(a, q'). (a, q2_\<alpha> q')) ` (DS q) \<and>
                   (\<forall>a q'. (a, q') \<in> (DS q) \<longrightarrow> q2_invar q') \<and>
                   (\<forall>a q'. (a, q') \<in> (DS q) \<longrightarrow>
                           (\<forall>q''. (a, q'') \<in> (DS q) \<longrightarrow> 
                    (q2_\<alpha> q' = q2_\<alpha> q'') = (q' = q'')))"

  from nfa_by_lts_defs_axioms have d_OK: "lts_add d.\<alpha> d.invar d.add" 
    unfolding nfa_by_lts_defs_def StdLTS_def by simp

  from `StdMap qm_ops` 
  interpret reach: NFA_construct_reachable_locale s_ops l_ops d_ops qm_ops f ff q2_\<alpha> q2_invar
    using automaton_by_lts_defs_axioms f_OK
    unfolding NFA_construct_reachable_locale_def automaton_by_lts_defs_def by simp

  thm reach.NFA_construct_reachable_impl_code_correct___remove_unreachable
  [OF _ f_inj_on f_OK dist_I invar_I _ invar_A A_OK _ _ wf_\<A>]
  note correct = reach.NFA_construct_reachable_impl_code_correct___remove_unreachable
    [OF _ f_inj_on f_OK dist_I invar_I _ invar_A A_OK _ _ wf_\<A>, 
     of D_it DS "(\<lambda>_ _. True)" FP]

  show "nfa_invar_NFA (NFA_construct_reachable_impl_code qm_ops ff I A FP D_it) \<and>
       NFA_isomorphic_wf (nfa_\<alpha> (NFA_construct_reachable_impl_code qm_ops ff I A FP D_it))
        (NFA_remove_unreachable_states \<A>)"
    apply (rule_tac correct)
          apply (simp_all add: I_OK d_OK FP_OK 
            reach.NFA_construct_reachable_impl_step_rel_def)
    apply (insert D_OK f_OK)
    apply (simp add:  set_iterator_def br_def)
    
  proof -
    fix q 
    assume q2_invar_q: "q2_invar q" and
           q2_\<alpha>_q: "q2_\<alpha> q \<in> \<Q> \<A>"  and
           prem: "(\<And>q. q2_invar q \<Longrightarrow>
               q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow>
                  set_iterator_genord (D_it q) {(a, q'). (a, q') \<in> (DS q) \<and> a \<noteq> {}}
                   (\<lambda>_ _. True) \<and>
                  {(a, q'). (q2_\<alpha> q, a, q') \<in> \<Delta> \<A>} =
                  (\<lambda>x. case x of (a, q') \<Rightarrow> (a, q2_\<alpha> q')) ` (DS q) \<and>
                  (\<forall>a q'. (a, q') \<in> (DS q) \<longrightarrow> q2_invar q') \<and>
                  (\<forall>a q'.
                      (a, q') \<in> (DS q) \<longrightarrow>
                      (\<forall>q''. (a, q'') \<in> (DS q) \<longrightarrow>
                             (q2_\<alpha> q' = q2_\<alpha> q'') = (q' = q''))))" and
            q2_invar_ff_f: "(\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> ff q = f (q2_\<alpha> q))"
    from prem this show " set_iterator_genord (D_it q) 
          {p \<in> DS q. fst p \<noteq> {}} (\<lambda>_ _. True)"
      apply (subgoal_tac "{(a, q'). (a, q') \<in> (DS q) \<and> a \<noteq> {}} 
                           = {p \<in> DS q. fst p \<noteq> {}}")
      apply force
      apply auto[1]
      done
  qed
qed

lemma (in nfa_by_lts_defs) NFA_construct_reachable_impl_code_correct_no_enc:
  assumes qm_OK: "StdMap qm_ops"
  shows "NFASpec.nfa_construct_no_enc 
       nfa_\<alpha> nfa_invar_NFA l.\<alpha> l.invar (NFA_construct_reachable_impl_code qm_ops)"
  by  (intro NFASpec.nfa_construct_no_enc_default 
      NFA_construct_reachable_impl_code_correct qm_OK)



subsection \<open> boolean combinations \<close>



definition product_iterator where
  "product_iterator (it_1::'q1 \<Rightarrow> ('a set \<times> 'q1, '\<sigma>) set_iterator)
     (it_2::'q2 \<Rightarrow> 'a set \<Rightarrow> ('a set \<times> 'q2, '\<sigma>) set_iterator) = (\<lambda>(q1, q2).
     set_iterator_image (\<lambda>((a1, q1'), (a2, q2')).((a1, a2), (q1', q2'))) 
     (set_iterator_product (it_1 q1) 
     (\<lambda>aq. it_2 q2 (fst aq))))"


lemma product_iterator_alt_def :
"product_iterator it_1 it_2 = 
 (\<lambda>(q1, q2) c f. it_1 q1 c (\<lambda>(a1,q1'). it_2 q2 a1 c (\<lambda> (a2, q2') \<sigma>. 
      (f ((a1, a2), (q1', q2')) \<sigma>))))"
  unfolding product_iterator_def 
  unfolding set_iterator_image_filter_def set_iterator_image_def 
              set_iterator_product_def
  apply (simp_all)
  apply (auto simp add: split_def)
  done


lemma product_iterator_correct :
fixes D1 :: "('q1 \<times> 'a set \<times> 'q1) set"
fixes D2 :: "('q2 \<times> 'a set \<times> 'q2) set"
assumes it_1_OK: "set_iterator_genord (it_1 q1) 
                  {(a , q1'). (q1, a, q1') \<in> D1} (\<lambda>_ _.True)"
    and it_2_OK: "\<And>a. 
    set_iterator_genord (it_2 q2 a) 
        {(a2, q2'). (q2, a2, q2') \<in> D2} (\<lambda>_ _.True)"
shows "set_iterator_genord (product_iterator it_1 it_2 (q1, q2)) 
          {((a1, a2), (q1', q2')). (q1, a1, q1') \<in> D1 \<and> (q2, (a2, q2')) \<in> D2} 
          (\<lambda>_ _.True)"
proof -
  from it_2_OK have it_2_OK': 
    "\<And>aq. set_iterator_genord (((it_2 q2) \<circ> fst) aq) 
    {(a2, q2'). (q2, a2, q2') \<in> D2}
    (\<lambda>_ _.True)" by simp

  note thm_1 = set_iterator_genord_product_correct [where ?it_a = "it_1 q1" and 
    ?it_b = "(it_2 q2) \<circ> fst", OF it_1_OK it_2_OK']

  let ?f = "\<lambda>((a1, q1'), (a2, q2')). 
             ((a1, a2), (q1', q2'))"
  have inj_on_f: "\<And>S. inj_on ?f S"
    unfolding inj_on_def 
    apply (simp add: split_def)
    apply auto
    done
  thm set_iterator_genord_image_correct
  note thm_2 = set_iterator_genord_image_correct [OF thm_1 inj_on_f]
  
  let ?Sigma = 
      "(SIGMA a:{(a, q1'). (q1, a, q1') \<in> D1}. 
        {(a2,q2'). (q2, a2, q2') \<in> D2})"
  have aa: "{y.\<exists> x \<in> ?Sigma. ?f x =  y} =  {((a1, a2), (q1', q2')). 
                        (q1, a1 ,q1') \<in> D1 \<and> (q2, a2 , q2') \<in> D2}"
    by (auto simp add: image_iff)

  have "((\<lambda>x. case x of
                  (x, xa) \<Rightarrow>
                    (case x of (a1, q1') \<Rightarrow> \<lambda>(a2, q2'). ((a1, a2), q1', q2')) xa) `
             ({(a, q1'). (q1, a, q1') \<in> D1} \<times> {(a2, q2'). (q2, a2, q2') \<in> D2})) = 
        {((a1, a2), (q1', q2')). 
                        (q1, a1 ,q1') \<in> D1 \<and> (q2, a2 , q2') \<in> D2}"
    by (auto simp add: image_iff)
  with thm_2 show ?thesis 
    apply (simp add: product_iterator_def o_def 
                          set_iterator_genord.intro if_split)
    
    done
qed


text \<open> AA1: an automaton
       AA2: an automaton
         A: \<Sigma>  \<close> 

definition bool_comb_impl_aux where
"bool_comb_impl_aux const f it_1 it_2 I I' FP FP' =
 (\<lambda>A' bc AA1 AA2. const f (List.product (I AA1) (I' AA2)) A'
  (\<lambda>(q1', q2'). bc (FP AA1 q1') (FP' AA2 q2')) 
    (product_iterator (it_1 AA1) (it_2 AA2)))"
 
lemma bool_comb_impl_aux_correct :
assumes const_OK: "nfa_construct_no_enc_prod \<alpha>3 invar3 \<alpha>_s invar_s const"
    and nfa_1_OK: "nfa \<alpha>1 invar1"
    and nfa_2_OK: "nfa \<alpha>2 invar2"
    and f_inj_on: "\<And>n1 n2. inj_on f (\<Q> (\<alpha>1 n1) \<times> \<Q> (\<alpha>2 n2))"
    and I1_OK: "\<And>n1. invar1 n1 \<Longrightarrow> distinct (I1 n1) \<and> set (I1 n1) = \<I> (\<alpha>1 n1)" 
    and I2_OK: "\<And>n2. invar2 n2 \<Longrightarrow> distinct (I2 n2) \<and> set (I2 n2) = \<I> (\<alpha>2 n2)"
    and FP1_OK: "\<And>n1 q. invar1 n1 \<Longrightarrow> q \<in> \<Q> (\<alpha>1 n1) \<Longrightarrow> FP1 n1 q \<longleftrightarrow> (q \<in> \<F> (\<alpha>1 n1))"
    and FP2_OK: "\<And>n2 q. invar2 n2 \<Longrightarrow> q \<in> \<Q> (\<alpha>2 n2) \<Longrightarrow> FP2 n2 q \<longleftrightarrow> (q \<in> \<F> (\<alpha>2 n2))"
    and it_1_OK: "\<And>n1 q. invar1 n1 \<Longrightarrow> (set_iterator_genord (it_1 n1 q) 
                               {(a, q'). (q, a, q') \<in> \<Delta> (\<alpha>1 n1)}) (\<lambda>_ _.True)"
    and it_2_OK: "\<And>n2 q a. invar2 n2 \<Longrightarrow> set_iterator_genord (it_2 n2 q a) 
                               {(a2, q'). (q, a2, q') \<in> \<Delta> (\<alpha>2 n2)} (\<lambda>_ _.True)"
shows "nfa_bool_comb_gen \<alpha>1 invar1 \<alpha>2 invar2 \<alpha>3 invar3 \<alpha>_s invar_s
       (bool_comb_impl_aux const f it_1 it_2 I1 I2 FP1 FP2)"
proof (intro nfa_bool_comb_gen.intro 
             nfa_1_OK nfa_2_OK 
             nfa_bool_comb_gen_axioms.intro)
  from const_OK show "nfa \<alpha>3 invar3" 
    unfolding nfa_construct_no_enc_prod_def by simp

  fix n1 n2 as bc
  assume invar_1: "invar1 n1"
     and invar_2: "invar2 n2"
     and invar_s: "invar_s as"
     and as_OK: "\<alpha>_s as = \<Sigma> (\<alpha>1 n1) \<inter> \<Sigma> (\<alpha>2 n2)"
  let ?AA' = "bool_comb_NFA bc (\<alpha>1 n1) (\<alpha>2 n2)"
  
  have f_inj_on': "inj_on f (\<Q> ?AA')" using f_inj_on by (simp add: bool_comb_NFA_def)

  from invar_1 invar_2 nfa_1_OK nfa_2_OK have AA'_wf: "NFA ?AA'"
    apply (rule_tac bool_comb_NFA___is_well_formed)
    apply (simp_all add: nfa_def)
  done

  let ?II = "List.product (I1 n1) (I2 n2)"
  have dist_II: "distinct ?II" and set_II: "set ?II = \<I> ?AA'"
    apply (intro List.distinct_product)
    apply (insert I1_OK[OF invar_1] I2_OK[OF invar_2])
    apply (simp_all)
  done

  from as_OK have as_OK': "\<alpha>_s as = \<Sigma> ?AA'" by simp

  let ?FP = "(\<lambda>(q1', q2'). bc (FP1 n1 q1') (FP2 n2 q2'))"  
  from FP1_OK[OF invar_1] FP2_OK[OF invar_2]
  have FP_OK: "\<And>q. q \<in> \<Q> ?AA' \<Longrightarrow> ?FP q = (q \<in> \<F> ?AA')" by auto

  let ?D_it = "product_iterator (it_1 n1) (it_2 n2)"

  let ?D = "{((q1,q2), (a1, a2), (q1',q2'))
              | q1 a1 q1' q2 a2 q2'. 
                (q1,a1,q1') \<in> \<Delta> (\<alpha>1 n1) \<and> 
                (q2,a2,q2') \<in> \<Delta> (\<alpha>2 n2)}"

  define fm where  "fm = (\<lambda> (q1::'e, (a1:: 'c set), q1'::'e)
                          (q2::'f, (a2:: 'c set), q2'::'f). 
             ((q1,q2), (a1, a2), (q1', q2')))"
  have NFA_\<alpha>1_n1: "NFA (\<alpha>1 n1)" 
    apply (rule_tac nfa.nfa_is_wellformed[of \<alpha>1 invar1 n1])
    apply (simp add: nfa_1_OK)
    apply (simp add: invar_1)
    done
   have NFA_\<alpha>2_n2: "NFA (\<alpha>2 n2)" 
    apply (rule_tac nfa.nfa_is_wellformed[of \<alpha>2 invar2 n2])
    apply (simp add: nfa_2_OK)
    apply (simp add: invar_2)
    done
  have finite_D : "finite ?D" 
  proof -
    have fin_A1: "finite (\<Delta> (\<alpha>1 n1))" and
           fin_A1: "finite (\<Delta> (\<alpha>2 n2))" 
      apply (simp add: NFA_\<alpha>1_n1 NFA_\<alpha>2_n2 NFA.finite_\<Delta>)
      apply (simp add: NFA_\<alpha>1_n1 NFA_\<alpha>2_n2 NFA.finite_\<Delta>)
      done
    from this have fin_fm: "finite {fm e1 e2 |e1 e2. e1 \<in> (\<Delta> (\<alpha>1 n1)) \<and> e2 \<in> (\<Delta> (\<alpha>2 n2))}"
      apply (rule_tac finite_image_set2)
      by auto
    have "{fm e1 e2 |e1 e2. e1 \<in> (\<Delta> (\<alpha>1 n1)) \<and> e2 \<in> (\<Delta> (\<alpha>2 n2))} = ?D"
      by (simp add: fm_def)
    from this fin_fm show "finite ?D" by auto
  qed
    
  have D_\<A>: "{(q, fst a \<inter> snd a, q') |q a q'. (q, a, q') \<in> ?D} =
  \<Delta> (bool_comb_NFA bc (\<alpha>1 n1) (\<alpha>2 n2))" 
      apply (simp add: LTS_product_def)
      by fastforce
  from product_iterator_correct [where ?it_1.0 = "it_1 n1" and ?it_2.0 = "it_2 n2", 
           OF it_1_OK[OF invar_1] it_2_OK[OF invar_2]]
  have D_it_OK: "\<And>q. set_iterator (product_iterator (it_1 n1) (it_2 n2) q)
     {(a, q'). (q, a, q') \<in> ?D}"
    unfolding set_iterator_def
    apply (case_tac q) 
    apply (auto simp add: split_def product_iterator_correct)
    by (smt Collect_cong fst_conv prod.collapse snd_conv)
  
 thm  nfa_construct_no_enc_prod.nfa_construct_no_enc_correct
  note construct_correct = 
        nfa_construct_no_enc_prod.nfa_construct_no_enc_correct [OF const_OK
    AA'_wf f_inj_on' dist_II set_II finite_D D_\<A>, OF invar_s as_OK' FP_OK D_it_OK]
  thus "invar3 (bool_comb_impl_aux const f it_1 it_2 I1 I2 FP1 FP2 as bc n1 n2) \<and> 
        NFA_isomorphic_wf (\<alpha>3 (bool_comb_impl_aux const f it_1 it_2 I1 I2 FP1 FP2 as bc n1 n2))
        (efficient_bool_comb_NFA bc (\<alpha>1 n1) (\<alpha>2 n2))" 
    apply (simp_all add: bool_comb_impl_aux_def efficient_bool_comb_NFA_def)
    done
qed



context nfa_dfa_by_lts_defs 
begin
  fun bool_comb_gen_impl where
    "bool_comb_gen_impl qm_ops it_1_nfa it_2_nfa
       A' bc A1 A2 =
        (bool_comb_impl_aux 
         (nfa.NFA_construct_reachable_prod_impl_code qm_ops) id 
          (\<lambda>A. it_1_nfa (nfa.nfa_trans A)) (\<lambda>A. it_2_nfa (nfa.nfa_trans A))
           (\<lambda>A. (s.to_list (nfa.nfa_initial A))) 
            (\<lambda>A. (s.to_list (nfa.nfa_initial A))) 
             (\<lambda>A q. s.memb q (nfa.nfa_accepting A)) 
              (\<lambda>A q. s.memb q (nfa.nfa_accepting A)) A' bc A1 A2)"

  term nfa.NFA_construct_reachable_prod_impl_code

schematic_goal bool_comb_gen_impl_code :
  "bool_comb_gen_impl qm_ops it_1_nfa it_2_nfa
     A' bc (Q1, A1, D1, I1, F1) (Q2, A2, D2, I2, F2) = ?XXX1"
  unfolding bool_comb_gen_impl.simps 
            bool_comb_impl_aux_def product_iterator_alt_def
            nfa.nfa_selectors_def  snd_conv fst_conv
            nfa.NFA_construct_reachable_impl_code_def 
 by (rule refl)+

fun bool_comb_impl where
     "bool_comb_impl qm_ops it_1_nfa it_2_nfa bc A1 A2 =
      bool_comb_gen_impl qm_ops it_1_nfa it_2_nfa 
       (nfa.nfa_labels A1) bc A1 A2"

schematic_goal bool_comb_impl_code :
  "bool_comb_impl qm_ops it_1_nfa it_2_nfa
     bc (Q1, A1, D1, I1, F1) (Q2, A2, D2, I2, F2) = ?XXX1"
 unfolding bool_comb_impl.simps bool_comb_gen_impl_code
           nfa.nfa_selectors_def snd_conv fst_conv
 by (rule refl)+


definition nfa_dfa_invar where
     "nfa_dfa_invar n = (nfa.nfa_invar_NFA n)"

definition nfa_dfa_\<alpha> where
     "nfa_dfa_\<alpha> n = (nfa.nfa_\<alpha> n)"

lemma automaton_by_lts_correct :
  "nfa nfa_dfa_\<alpha> nfa_dfa_invar"
  unfolding nfa_dfa_\<alpha>_def nfa_dfa_invar_def
  by simp


lemma bool_comb_gen_impl_correct :
assumes qm_ops_OK: "StdMap qm_ops"
    and it_1_nfa_OK: "lts_succ_label_it d_nfa.\<alpha> d_nfa.invar it_1_nfa"
    and it_2_nfa_OK: "lts_succ_it d_nfa.\<alpha> d_nfa.invar it_2_nfa"
shows "nfa_bool_comb_gen_same nfa_dfa_\<alpha> nfa_dfa_invar l.\<alpha> l.invar
       (bool_comb_gen_impl qm_ops it_1_nfa it_2_nfa)"
proof (intro nfa_bool_comb_gen_same.intro 
             nfa_bool_comb_gen.intro 
            automaton_by_lts_correct
             nfa_bool_comb_gen_axioms.intro)
  thm automaton_by_lts_defs.nfa_by_map_correct
  fix a1 a2 as bc
  assume invar_1: "nfa_dfa_invar a1"
     and invar_2: "nfa_dfa_invar a2"
     and invar_s: "l.invar as"
     and as_OK: "l.\<alpha> as = \<Sigma> (nfa_dfa_\<alpha> a1) \<inter> \<Sigma> (nfa_dfa_\<alpha> a2)"

  note const_nfa_OK = 
      nfa.NFA_construct_reachable_prod_impl_code_correct_no_enc [OF qm_ops_OK]
 
  note correct_nfa = nfa_bool_comb_gen.bool_comb_correct_aux 
      [OF bool_comb_impl_aux_correct,
      where as = as and bc=bc, OF const_nfa_OK]
 

  note it_1_nfa_OK' = lts_succ_label_it.lts_succ_label_it_correct [OF it_1_nfa_OK]
  note it_2_nfa_OK' = lts_succ_it.lts_succ_it_correct [OF it_2_nfa_OK]


  show "nfa_dfa_invar (bool_comb_gen_impl qm_ops it_1_nfa it_2_nfa as bc a1 a2) \<and>
        NFA_isomorphic_wf
          (nfa_dfa_\<alpha> (bool_comb_gen_impl qm_ops it_1_nfa it_2_nfa  as bc a1 a2))
          (efficient_bool_comb_NFA bc (nfa_dfa_\<alpha> a1) (nfa_dfa_\<alpha> a2))"
  proof -
    note correct_nfa' = correct_nfa [OF nfa.nfa_by_map_correct, where ?n1.0 = a1]
    show ?thesis
    proof -
      note correct_nfa'' = correct_nfa' 
                    [OF nfa.nfa_by_map_correct, where ?n2.0 = a2]
      from invar_1 invar_2 invar_s as_OK 
      show ?thesis 
        apply (simp add:  nfa_dfa_invar_def  nfa_dfa_\<alpha>_def)
        apply (rule_tac correct_nfa'')
        apply (insert it_1_nfa_OK' it_2_nfa_OK')
        apply (simp_all add: 
              nfa.nfa_trans_def set_iterator_def  s.correct nfa.nfa_invar_NFA_def nfa.nfa_invar_def)
        apply auto
        by (smt Collect_cong case_prodE case_prodI2)
qed
qed
qed

lemma bool_comb_impl_correct :
assumes qm_ops_OK: "StdMap qm_ops"
    and it_1_nfa_OK: "lts_succ_label_it d_nfa.\<alpha> d_nfa.invar it_1_nfa"
    and it_2_nfa_OK: "lts_succ_it d_nfa.\<alpha> d_nfa.invar it_2_nfa"
shows "nfa_bool_comb_same nfa_dfa_\<alpha> nfa_dfa_invar 
       (bool_comb_impl qm_ops it_1_nfa it_2_nfa)"
proof (intro nfa_bool_comb_same.intro nfa_bool_comb.intro nfa_bool_comb_axioms.intro
             automaton_by_lts_correct)
  fix a1 a2 bc
  assume invar_1: "nfa_dfa_invar a1"
     and invar_2: "nfa_dfa_invar a2"
     and a_OK: "\<Sigma> (nfa_dfa_\<alpha> a1) = \<Sigma> (nfa_dfa_\<alpha> a2)"

  let ?as = " nfa.nfa_labels a1"
  from invar_1 a_OK have as_invar: "l.invar ?as" and as_OK: 
      "l.\<alpha> ?as = \<Sigma> (nfa_dfa_\<alpha> a1) \<inter> \<Sigma> (nfa_dfa_\<alpha> a2)"
    apply (case_tac [!] a1) [2]
    apply (simp_all add: nfa.nfa_invar_NFA_def nfa.nfa_invar_def
          nfa_dfa_invar_def nfa_dfa_\<alpha>_def)
  done

  from bool_comb_gen_impl_correct [OF assms]
  have "nfa_bool_comb_gen_same nfa_dfa_\<alpha> nfa_dfa_invar l.\<alpha> l.invar
       (bool_comb_gen_impl qm_ops it_1_nfa it_2_nfa)" by simp
  note gen_correct = nfa_bool_comb_gen.bool_comb_correct_aux [OF this[unfolded nfa_bool_comb_gen_same_def],
    OF invar_1 invar_2 as_invar as_OK, of bc]

  from gen_correct
  show "nfa_dfa_invar (bool_comb_impl qm_ops it_1_nfa it_2_nfa bc a1 a2) \<and>
        NFA_isomorphic_wf
        (nfa_dfa_\<alpha> (bool_comb_impl qm_ops it_1_nfa it_2_nfa bc a1 a2))
        (efficient_bool_comb_NFA bc (nfa_dfa_\<alpha> a1) (nfa_dfa_\<alpha> a2))"
    by (case_tac a1, simp_all)
qed
 
end






end
