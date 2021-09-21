theory NFAByLTS_Interval
                                      
imports "Collections.Collections" "HOL.Enum"
      "../../General/Accessible_Impl"
  LTSSpec LTSGA NFASpec LTS_Impl Interval

begin

subsection \<open> Locales for NFAs and a common locale \<close>

locale automaton_by_lts_interval_syntax = 
  s: StdSetDefs s_ops   (* Set operations on states *) +
  l: StdSetDefs l_ops   (* Set operations on labels *) +
  d: StdCommonLTSDefs d_ops elemI  (* An LTS *) 
  for s_ops::"('q::{NFA_states},'q_set,_) set_ops_scheme"
  and l_ops::"('a::linorder,'a_set,_) set_ops_scheme"
  and d_ops::"('q,'a \<times> 'a,'a,'d,_) common_lts_ops_scheme" 



locale automaton_by_lts_interval_defs = automaton_by_lts_interval_syntax 
      s_ops l_ops d_ops +
  s: StdSet s_ops (* Set operations on states *) +
  l: StdSet l_ops (* Set operations on labels *) +
  d: StdCommonLTS d_ops elemI (* An LTS *) 
  for s_ops::"('q::{NFA_states},'q_set,_) set_ops_scheme"
  and l_ops::"('a :: linorder,'a_set,_) set_ops_scheme"
  and d_ops::"('q,'a \<times> 'a,'a,'d,_) common_lts_ops_scheme" 
   

locale nfa_by_lts_interval_defs = automaton_by_lts_interval_defs s_ops l_ops d_ops + 
  s: StdSet s_ops (* Set operations on states *) +
  l: StdSet l_ops (* Set operations on labels *) +
  d: StdLTS d_ops elemI(* An LTS *) 
  for s_ops::"('q :: {NFA_states},'q_set,_) set_ops_scheme"
  and l_ops::"('a ::linorder,'a_set,_) set_ops_scheme"
  and d_ops::"('q,'a \<times> 'a,'a,'d,_) lts_ops_scheme"


lemma nfa_by_lts_interval_defs___sublocale :
  "nfa_by_lts_interval_defs s_ops l_ops d_ops \<Longrightarrow>
   automaton_by_lts_interval_defs s_ops l_ops d_ops"
  unfolding nfa_by_lts_interval_defs_def automaton_by_lts_interval_defs_def
  by (simp add: StdLTS_sublocale)

lemma nfa_by_lts_defs___sublocale :
  "nfa_by_lts_interval_defs s_ops l_ops d_ops \<Longrightarrow>
   automaton_by_lts_interval_defs s_ops l_ops d_ops"
  unfolding nfa_by_lts_interval_defs_def automaton_by_lts_interval_defs_def
  by (simp add: StdLTS_sublocale)

locale nfa_dfa_by_lts_interval_defs = 
  s: StdSet s_ops (* Set operations on states *) +
  ss: StdSet ss_ops (* Set operations on states *) +
  l: StdSet l_ops (* Set operations on labels *) +
  d_nfa: StdLTS d_nfa_ops elemI (* An LTS *) +
  dd_nfa: StdLTS dd_nfa_ops elemI (* An LTS *)
  for s_ops::"('q::{NFA_states},'q_set,_) set_ops_scheme"
  and ss_ops::"('q \<times> 'q,'qq_set,_) set_ops_scheme"
  and l_ops::"('a ::linorder,'a_set,_) set_ops_scheme"
  and d_nfa_ops::"('q,'a \<times> 'a,'a,'d_nfa,_) lts_ops_scheme"
  and dd_nfa_ops::"('q \<times> 'q,'a \<times> 'a,'a,'dd_nfa,_) lts_ops_scheme"

sublocale nfa_dfa_by_lts_interval_defs < 
          nfa: nfa_by_lts_interval_defs 
          s_ops l_ops d_nfa_ops by unfold_locales

context automaton_by_lts_interval_syntax
begin

definition nfa_states :: "'q_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> 'q_set" where
  "nfa_states A = fst A"
lemma [simp]: "nfa_states (Q, D, I, F) = Q" by (simp add: nfa_states_def)


fun interval_to_set :: "'q \<times> ('a \<times> 'a) \<times> 'q \<Rightarrow> 'q \<times> 'a set \<times> 'q"  where
    "interval_to_set (q, s, q') = (q, semI s, q')"

definition nfa_trans :: 
        "'q_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> 'd" where
  "nfa_trans A = (fst (snd A))"
lemma [simp]: "nfa_trans (Q, D, I, F) = D" by (simp add: nfa_trans_def)

definition nfa_initial :: "'q_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> 'q_set" where
  "nfa_initial A = fst (snd (snd  A))"
lemma [simp]: "nfa_initial (Q, D, I, F) = I" by (simp add: nfa_initial_def)

definition nfa_accepting :: "'q_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> 'q_set" where
  "nfa_accepting A = snd (snd (snd  A))"
lemma [simp]: "nfa_accepting (Q, D, I, F) = F" by (simp add: nfa_accepting_def)


(***********)

definition nfa_statep :: "'qq_set \<times> 'dd_nfa \<times> 'qq_set \<times> 'qq_set \<Rightarrow> 'qq_set" where
  "nfa_statep A = fst A"
lemma [simp]: "nfa_statep (Q, D, I, F) = Q" by (simp add: nfa_statep_def)


definition nfa_transp :: 
        "'qq_set \<times> 'dd_nfa \<times> 'qq_set \<times> 'qq_set \<Rightarrow> 'dd_nfa" where
  "nfa_transp A = (fst (snd A))"
lemma [simp]: "nfa_transp (Q, D, I, F) = D" by (simp add: nfa_transp_def)

definition nfa_initialp :: "'qq_set \<times> 'dd_nfa \<times> 'qq_set \<times> 'qq_set \<Rightarrow> 'qq_set" where
  "nfa_initialp A = fst (snd (snd  A))"
lemma [simp]: "nfa_initialp (Q, D, I, F) = I" by (simp add: nfa_initialp_def)

definition nfa_acceptingp :: "'qq_set \<times> 'dd_nfa \<times> 'qq_set \<times> 'qq_set \<Rightarrow> 'qq_set" where
  "nfa_acceptingp A = snd (snd (snd  A))"
lemma [simp]: "nfa_acceptingp (Q, D, I, F) = F" by (simp add: nfa_acceptingp_def)

lemmas nfa_selectors_def = nfa_accepting_def nfa_states_def 
       nfa_trans_def nfa_initial_def


definition nfa_invar :: "'q_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> bool" where
  "nfa_invar A =
   (s.invar (nfa_states A) \<and>
    d.invar (nfa_trans A) \<and>
    s.invar (nfa_initial A) \<and> 
    s.invar (nfa_accepting A))"


definition nfa_\<alpha> :: "'q_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> ('q, 'a) NFA_rec" 
  where
  "nfa_\<alpha> A =
   \<lparr> \<Q> = s.\<alpha> (nfa_states A), 
     \<Delta> = interval_to_set ` (d.\<alpha> (nfa_trans A)),
     \<I> = s.\<alpha> (nfa_initial A), 
     \<F> = s.\<alpha> (nfa_accepting A) \<rparr>"

definition nfa_to_set :: "'q_set \<Rightarrow> 'q set" where
   "nfa_to_set s = s.\<alpha> s"

definition nfa_invar_NFA :: "'q_set \<times> 'd \<times> 'q_set \<times> 'q_set \<Rightarrow> bool" where
  "nfa_invar_NFA A \<equiv> (nfa_invar A \<and> NFA (nfa_\<alpha> A))"


end

context automaton_by_lts_interval_defs
begin

lemma nfa_by_map_correct [simp]:
    "nfa nfa_\<alpha> nfa_invar_NFA"
    unfolding nfa_def nfa_invar_NFA_def
    by simp
end

context automaton_by_lts_interval_defs
begin

fun rename_states_gen_impl where
  "rename_states_gen_impl im im2 (Q, D, I, F) = (\<lambda> f.
   (im f Q, im2 (\<lambda>qaq. (f (fst qaq), fst (snd qaq), f (snd (snd qaq)))) D,
    im f I, im f F))"


thm nfa_rename_states.intro

lemma rename_states_impl_correct :
assumes wf_target: "nfa_by_lts_interval_defs s_ops' l_ops d_ops'"
assumes im_OK: "set_image s.\<alpha> s.invar (set_op_\<alpha> s_ops') (set_op_invar s_ops') im"
assumes im2_OK: "lts_image d.\<alpha> d.invar (clts_op_\<alpha> d_ops') (clts_op_invar d_ops') im2"
shows "nfa_rename_states nfa_\<alpha> nfa_invar_NFA
           (automaton_by_lts_interval_syntax.nfa_\<alpha> s_ops' d_ops')
           (automaton_by_lts_interval_syntax.nfa_invar_NFA s_ops' d_ops')
           (rename_states_gen_impl im im2)"
proof (intro nfa_rename_states.intro 
             nfa_rename_states_axioms.intro
             automaton_by_lts_interval_defs.nfa_by_map_correct)
  show "automaton_by_lts_interval_defs s_ops l_ops d_ops" 
  by (fact automaton_by_lts_interval_defs_axioms)
  show "automaton_by_lts_interval_defs s_ops' l_ops d_ops'" 
    by (intro nfa_by_lts_defs___sublocale wf_target)
  fix n f
  assume invar: "nfa_invar_NFA n"
  obtain QL DL IL FL where n_eq[simp]: "n = (QL, DL, IL, FL)" 
        by (cases n, blast)

  interpret s': StdSet s_ops' using wf_target 
        unfolding nfa_by_lts_interval_defs_def by simp
  interpret d': StdLTS d_ops' elemI using wf_target 
        unfolding nfa_by_lts_interval_defs_def by simp
  interpret im: set_image s.\<alpha> s.invar s'.\<alpha> s'.invar im by fact
  interpret im2: lts_image d.\<alpha> d.invar d'.\<alpha> d'.invar im2 by fact

  from invar have invar_weak: "nfa_invar n" and wf: "NFA (nfa_\<alpha> n)"
    unfolding nfa_invar_NFA_def by simp_all

  let ?nfa_\<alpha>' = "automaton_by_lts_interval_syntax.nfa_\<alpha> s_ops' d_ops'"
  let ?nfa_invar' = "automaton_by_lts_interval_syntax.nfa_invar s_ops' d_ops'"
  let ?nfa_invar_NFA' = "automaton_by_lts_interval_syntax.nfa_invar_NFA s_ops' d_ops'"
  thm im.image_correct
  from invar_weak
  have "?nfa_invar' (rename_states_gen_impl im im2 n f) \<and>
        ?nfa_\<alpha>' (rename_states_gen_impl im im2 n f) = 
         NFA_rename_states (nfa_\<alpha> n) f"
    
    apply (simp add: automaton_by_lts_interval_syntax.nfa_invar_def 
                     automaton_by_lts_interval_syntax.nfa_\<alpha>_def
                     automaton_by_lts_interval_syntax.nfa_selectors_def
                      NFA_rename_states_def 
                     im.image_correct im2.lts_image_correct 
                     rename_states_gen_impl.simps
                     semI_def)
    apply (simp add: semI_def 
                          interval_to_set.simps)
    thm automaton_by_lts_interval_syntax.nfa_\<alpha>_def
    apply (simp add: image_iff)
    apply (simp add: set_eq_iff)
    apply auto
    apply (metis automaton_by_lts_interval_syntax.interval_to_set.simps prod.inject)
  proof -
    fix aa a ac b ba
    assume p1: "\<forall>x. (x \<in> aa) = (x \<in> semI (ac, b))" and
           p2: "(a, (ac, b), ba) \<in> d.\<alpha> DL" 
    from p2 have c1: "automaton_by_lts_interval_syntax.interval_to_set 
       (f a, (ac, b), f ba)
       \<in> automaton_by_lts_interval_syntax.interval_to_set `
          (\<lambda>qaq. (f (fst qaq), fst (snd qaq), f (snd (snd qaq)))) ` d.\<alpha> DL"
      by force
    from p1 have "aa = semI (ac, b)" by auto
    from this p1 have "automaton_by_lts_interval_syntax.interval_to_set 
       (f a, (ac, b), f ba) = (f a, aa ,f ba)"
      by (simp add: automaton_by_lts_interval_syntax.interval_to_set.simps)
    from this c1 show "(f a, aa, f ba)
       \<in> automaton_by_lts_interval_syntax.interval_to_set `
          (\<lambda>qaq. (f (fst qaq), fst (snd qaq), f (snd (snd qaq)))) ` d.\<alpha> DL"
      by auto
  qed
  thus "?nfa_\<alpha>' (rename_states_gen_impl im im2 n f) = 
        NFA_rename_states (nfa_\<alpha> n) f"
       "?nfa_invar_NFA' (rename_states_gen_impl im im2 n f)"
    unfolding automaton_by_lts_interval_syntax.nfa_invar_NFA_def
    using NFA_rename_states___is_well_formed[OF wf, of f]
      by (simp_all add: NFA_remove_states___is_well_formed)
qed


fun nfa_destruct where
   "nfa_destruct (Q, D, I, F) =
    (s.to_list Q,
     d.to_collect_list D,
     s.to_list I,
     s.to_list F)"
declare nfa_destruct.simps [simp del]




  subsection \<open> Constructing Automata \<close>



definition nfa_construct_interval_aux ::
  "'q_set \<times>  'd \<times> 'q_set \<times> 'q_set \<Rightarrow> 'q \<times> ('a \<times> 'a) \<times> 'q \<Rightarrow> 
   'q_set \<times>  'd \<times> 'q_set \<times> 'q_set" where 
   "nfa_construct_interval_aux = (\<lambda>(Q, D, I, F) (q1, l, q2).
    (s.ins q1 (s.ins q2 Q), 
     d.add q1 l q2 D,
     I, F))"



lemma nfa_construct_interval_aux_correct :
fixes q1 q2
assumes invar: "nfa_invar A"
    and d_add_OK: 
        "lts_add d.\<alpha> d.invar d.add"
shows "nfa_invar (nfa_construct_interval_aux A (q1, l, q2))"
      "nfa_\<alpha> (nfa_construct_interval_aux A (q1, l, q2)) =
              construct_NFA_interval_aux (nfa_\<alpha> A) (q1, l, q2)"
proof -
  obtain QL DL IL FL 
     where A_eq[simp]: "A = (QL, DL, IL, FL)" by (cases A, blast)
  
  have DL_OK : "d.invar DL \<Longrightarrow> 
     (lts_add d.\<alpha> d.invar d.add) \<Longrightarrow>
                d.invar (d.add q1 l q2 DL) \<and>
                d.\<alpha> (d.add q1 l q2 DL) =
                d.\<alpha> DL \<union> {(q1, l, q2)}"
    proof -
      assume add_OK: "lts_add d.\<alpha> d.invar d.add" 
      assume invard: "d.invar DL" 
      then show ?thesis
        by (auto simp add: lts_add.lts_add_correct[OF add_OK invard] invar)
    qed

    from DL_OK invar d_add_OK
    show "nfa_\<alpha> (nfa_construct_interval_aux A (q1, l, q2)) = 
                construct_NFA_interval_aux (nfa_\<alpha> A) (q1, l, q2)"
       "nfa_invar (nfa_construct_interval_aux A (q1, l, q2))"
      by (simp_all add: nfa_construct_interval_aux_def 
                        nfa_\<alpha>_def s.correct nfa_invar_def)
qed


fun nfa_construct_interval  where
   "nfa_construct_interval (QL, DL, IL, FL) =
    foldl nfa_construct_interval_aux 
     (s.from_list (QL @ IL @ FL),
      d.empty,
      s.from_list IL,
      s.from_list FL) DL"
declare nfa_construct_interval.simps [simp del]



lemma nfa_construct_correct_gen :
fixes ll :: "'q list \<times> ('q \<times> ('a ::linorder \<times> 'a) \<times> 'q) list \<times> 'q list \<times> 'q list"
assumes d_add_OK: "lts_add d.\<alpha> d.invar d.add" 
shows "nfa_invar (nfa_construct_interval ll)"
      "nfa_\<alpha> (nfa_construct_interval ll) = NFA_construct_interval ll" 
proof -
  obtain QL DL IL FL where l_eq[simp]: 
      "ll = (QL, DL, IL, FL)" by (cases ll, blast)
  let ?A = 
      "(s.from_list (QL @ IL @ FL),  d.empty, s.from_list IL, 
        s.from_list FL)"

  have A_invar: "nfa_invar ?A" 
     unfolding nfa_invar_def by (simp add: s.correct l.correct d.correct_common)
  have A_\<alpha>: "nfa_\<alpha> ?A = \<lparr>\<Q> = set (QL @ IL @ FL), \<Delta> = {}, \<I> = set IL, \<F> = set FL\<rparr>"
    by (simp add: nfa_\<alpha>_def s.correct d.correct_common l.correct)
  { fix A DL'
    have " nfa_invar A \<Longrightarrow> set DL' \<subseteq> set DL \<Longrightarrow>
        (lts_add d.\<alpha> d.invar d.add) \<Longrightarrow>
        nfa_invar (foldl nfa_construct_interval_aux A DL') \<and>
        nfa_\<alpha> (foldl nfa_construct_interval_aux A DL') =
        foldl construct_NFA_interval_aux (nfa_\<alpha> A) DL'"
    proof (induct DL' arbitrary: A)
      case Nil thus ?case by simp
    next
      case (Cons qlq DL')
      note ind_hyp = Cons(1)
      note invar_A = Cons(2)
      note set_DL'_subset = Cons(3)
      note d_add_OK' = Cons(4)

      let ?A' = "nfa_construct_interval_aux A qlq"
      obtain q1 l q2 where qlq_eq[simp]: "qlq = (q1,  l, q2)" by (metis prod.exhaust)
      note aux_correct = nfa_construct_interval_aux_correct 
          [of A q1 l q2, OF invar_A d_add_OK]
      from ind_hyp [of ?A'] set_DL'_subset aux_correct d_add_OK
      show ?case by auto
    qed
  } note step = this [of ?A DL]

  with A_\<alpha> A_invar show \<alpha>_OK: "nfa_\<alpha> (nfa_construct_interval ll) = 
                               NFA_construct_interval ll" 
                    and weak_invar: "nfa_invar (nfa_construct_interval ll)" 
    by (simp_all add: nfa_construct_interval.simps NFA_construct_interval.simps 
          Ball_def d.correct_common d_add_OK)
qed

lemma (in nfa_by_lts_interval_defs) nfa_construct_interval_correct :
  "nfa_from_list_interval nfa_\<alpha> nfa_invar_NFA nfa_construct_interval"
proof -
   from nfa_by_lts_interval_defs_axioms have "lts_add d.\<alpha> d.invar d.add" 
     unfolding nfa_by_lts_interval_defs_def StdLTS_def by simp
   with nfa_construct_correct_gen
   show ?thesis
     apply (intro nfa_from_list_interval.intro nfa_by_map_correct 
                  nfa_from_list_interval_axioms.intro)
     apply (simp_all add: nfa_invar_NFA_def NFA_construct_interval___is_well_formed)
   done
qed



end

context nfa_dfa_by_lts_interval_defs 
begin

lemma (in automaton_by_lts_interval_syntax) automaton_by_lts_correct :
  "nfa nfa_\<alpha> nfa_invar_NFA"
  unfolding nfa_\<alpha>_def nfa_invar_NFA_def nfa_def nfa_invar_def
  by simp

end

locale NFA_construct_reachable_locale = 
  automaton_by_lts_interval_defs s_ops l_ops d_ops +
  qm: StdMap qm_ops (* The index max *)
  for s_ops::"('q::{NFA_states},'q_set,_) set_ops_scheme"
  and l_ops::"('a::linorder,'a_set,_) set_ops_scheme"
  and d_ops::"('q, 'a \<times> 'a , 'a, 'd,_) common_lts_ops_scheme"
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

definition NFA_construct_reachable_init_interval_impl where
  "NFA_construct_reachable_init_interval_impl I =
   foldl (\<lambda> ((qm, n), Is) q. 
          ((qm.update_dj (ff q) (states_enumerate n) qm, Suc n),
                             s.ins_dj (states_enumerate n) Is))
          ((qm.empty (), 0), s.empty ()) I"

lemma NFA_construct_reachable_init_interval_impl_correct :
fixes II D
defines "I \<equiv> map q2_\<alpha> II"
defines "S \<equiv> accessible (LTS_forget_labels D) (set I)"
assumes f_inj_on: "inj_on f S"
    and dist_I: "distinct I"
    and invar_I: "\<And>q. q \<in> set II \<Longrightarrow> q2_invar q"
    and ff_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
shows
   "RETURN (NFA_construct_reachable_init_interval_impl II) \<le> \<Down> 
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
  res_eq: "NFA_construct_reachable_init_interval_impl II = ((qm', n'), Is')" by (metis prod.exhaust)
  
  define tmpsempty where "tmpsempty = s.empty ()"
  note ind_proof' = ind_proof [OF pre1 pre2 pre3 pre4 pre5 _ _ pre6, 
          of tmpsempty qm' n' Is',
    folded NFA_construct_reachable_init_interval_impl_def]

  from ind_proof' show ?thesis 
   apply (rule_tac SPEC_refine)+
    apply (simp add: s.correct 
     I_def tmpsempty_def br_def
     state_map_\<alpha>_def state_map_invar_def single_valued_def
    res_eq S_def NFA_construct_reachable_map_OK_def f_inj_on)
    using NFA_construct_reachable_init_interval_impl_def res_eq 
    by (auto simp add: tmpsempty_def br_def single_valued_def)
qed


definition NFA_construct_reachable_impl_step_rel where
  "NFA_construct_reachable_impl_step_rel =
    build_rel (\<lambda>DS. (\<lambda>(a::'a \<times> 'a, q'). (semI a, q2_\<alpha> q')) ` DS)
              (\<lambda>DS. (\<forall>a q'. (a, q') \<in> DS \<longrightarrow> q2_invar q') \<and>
                    (\<forall>a q' q''. (a, q') \<in> DS \<longrightarrow> (a, q'') \<in> DS \<longrightarrow> 
                       ((q2_\<alpha> q' = q2_\<alpha> q'') \<longleftrightarrow> q' = q'')))"


definition NFA_construct_reachable_impl_step_interval where
"NFA_construct_reachable_impl_step_interval DS qm0 n D0 q =
  FOREACH {(a,q').(a,q') \<in> (DS q)} 
  (\<lambda>(a, q') ((qm, n), DD', N). 
   if (nempI a) then do {
   let ((qm', n'), r') =
    (let r'_opt = qm.lookup (ff q') qm in
      if (r'_opt = None) then
         ((qm.update_dj (ff q') (states_enumerate n) qm, Suc n), states_enumerate n)
      else
         ((qm, n), the r'_opt)
    );
  RETURN ((qm', n'), 
    (d.add (the (qm.lookup (ff q) qm0)) a r' DD'), q' # N)
} else RETURN ((qm, n), DD', N)) ((qm0, n), D0, [])"


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
    and D0'_eq: "D0' = d.\<alpha> D0" "interval_to_set ` D0' = \<Delta> \<A>"
    and invar_D0: "d.invar D0"
    and rm_q:  "rm (q2_\<alpha> q) = Some r"
    and r_nin: "r \<notin> \<Q> \<A>"
    and invar_q: "q2_invar q"
    and q_in_S: "q2_\<alpha> q \<in> S"
    and DS_OK1: "inj_on (\<lambda>(a, q'). (semI a, q2_\<alpha> q')) (DS q) "
    and DS_OK: "(DS q, {(a, q'). (q2_\<alpha> q, a, q') \<in> D}) \<in> 
          NFA_construct_reachable_impl_step_rel"
    and weak_invar: "NFA_construct_reachable_abstract_impl_weak_invar 
                     I FP D (rm, \<A>)"
shows "NFA_construct_reachable_impl_step_interval DS qm0 n D0 q \<le> 
  \<Down> (rprod (build_rel state_map_\<alpha> state_map_invar) (rprod (build_rel 
           (\<lambda> d. interval_to_set ` d.\<alpha> d) d.invar) 
           (map_list_rel (build_rel q2_\<alpha> q2_invar))))
     (NFA_construct_reachable_abstract_impl_step S D rm (\<Delta> \<A>) 
                                                        (q2_\<alpha> q))"

  apply (subgoal_tac "NFA_construct_reachable_impl_step_interval DS qm0 n D0 q \<le> 
  \<Down> (rprod (build_rel state_map_\<alpha> state_map_invar) (rprod (build_rel 
           (\<lambda> d. interval_to_set ` d.\<alpha> d) d.invar) 
           (map_list_rel (build_rel q2_\<alpha> q2_invar))))
     (NFA_construct_reachable_abstract_impl_step S D rm (interval_to_set ` D0') 
                                                        (q2_\<alpha> q))")
  apply (simp add: assms(9))
  unfolding NFA_construct_reachable_impl_step_interval_def
            NFA_construct_reachable_abstract_impl_step_def
            nempI_correct
  using [[goals_limit = 10]]
  apply (refine_rcg)
  (* "preprocess goals" *)
  apply (subgoal_tac "inj_on (\<lambda>(a, q'). (semI a, q2_\<alpha> q')) 
                ({(a, q'). (a, q') \<in> DS q})")
  apply assumption
  apply (simp add: DS_OK1)
  (* "goal solved" *)
  apply (insert DS_OK inj_semI) []
  apply (simp add: NFA_construct_reachable_impl_step_rel_def)
  apply (simp add: in_br_conv br_def)
  (* "goal solved" *)
  apply (simp add: rm_eq D0'_eq invar_qm0_n invar_D0)
  apply (simp add: in_br_conv)
  apply (simp add: invar_D0 invar_qm0_n)
  apply (simp add:  br_def in_br_conv)
  apply (simp add: assms(8) invar_D0)
  (* "goal solved" *)
  apply (simp add: br_def)
    apply (clarify, simp)+
   
  apply (rename_tac it N x y q''  qm n D' NN a b q')
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
  apply (rename_tac it N x y q'' qm n D' NN r' qm' n' a b q')
  defer
  apply (simp add: br_def)
  defer
proof -
  fix it x N y q'' qm n D' NN a b q'
  assume aq'_in_it: "((a, b), q') \<in> it"
     and aq''_in_it: "((x, y), q'') \<in> it"
     and it_subset: "it \<subseteq> DS q"
     and q''_q'_eq: "q2_\<alpha> q'' = q2_\<alpha> q'"
     and semI_a_b: "semI (a, b) \<noteq> {}"
  let ?it' = "(\<lambda> (a, q'). (semI a, q2_\<alpha> q')) ` it"
  assume invar_foreach: 
     "NFA_construct_reachable_abstract_impl_foreach_invar 
      S D rm (interval_to_set ` d.\<alpha> D0) (q2_\<alpha> q) ?it'
               (state_map_\<alpha> (qm, n),interval_to_set `  d.\<alpha> D', N)"
     and invar_qm_n: "state_map_invar (qm, n)"
     and invar_D': "d.invar D'"
  from aq'_in_it aq''_in_it it_subset DS_OK
  have invar_q': "q2_invar q'" and invar_q'': "q2_invar q''"
    by (auto simp add: NFA_construct_reachable_impl_step_rel_def br_def)   
  have q'_in_S: "q2_\<alpha> q' \<in> S"
  proof -
    from DS_OK have "
        {(a, q'). (q2_\<alpha> q, a, q') \<in> D \<and> a \<noteq> {}} = 
         (\<lambda> (a, q'). (semI a, q2_\<alpha> q')) ` {(a,q'). (a, q') \<in> DS q \<and> semI a \<noteq> {}}"
      unfolding NFA_construct_reachable_impl_step_rel_def 
       apply (insert DS_OK) []
  apply (simp add: NFA_construct_reachable_impl_step_rel_def)
  apply (simp add: in_br_conv br_def)
  apply (simp only: set_eq_iff)
      by (fastforce)
     with aq'_in_it it_subset semI_a_b have "(semI (a,b), q2_\<alpha> q') \<in> 
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
     D'_eq: "interval_to_set ` d.\<alpha> D' = (interval_to_set ` D0') \<union>
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
    assume semI_eq: "semI (x, y) = semI (a, b)" 
    from this semI_a_b 
      have semI_ab_noempty: "semI (a, b) \<noteq> {} \<and> semI (x,y) \<noteq> {} " 
        by auto
      from inj_semI_aux semI_eq semI_ab_noempty this  
      have xayb: "x = a \<and> y = b" 
      by fastforce
    have "insert (r, (a, b), r') (d.\<alpha> D') = d.\<alpha> (d.add r (a, b) r' D') \<and>
          d.invar (d.add r (a, b) r' D')"
      by (metis d_add_OK invar_D' lts_add_def)
    from semI_ab_noempty inj_semI xayb this D0'_eq semI_eq show 
          "insert (the (state_map_\<alpha> (qm, n) (q2_\<alpha> q)), semI (a, b), r') 
            (interval_to_set `d.\<alpha> D') =
          interval_to_set ` d.\<alpha> (d.add (the (qm.lookup (ff q) qm0)) (x, y) r' D') \<and>
          d.invar (d.add (the (qm.lookup (ff q) qm0)) (x, y) r' D') \<and>
          q2_invar q''"   
      apply (simp add: r_intro1 r_intro2 invar_q'' )
      by (smt image_insert interval_to_set.simps)
  } 
qed


definition NFA_construct_reachable_interval_impl where
  "NFA_construct_reachable_interval_impl S I FP DS  =
   do {
     let ((qm, n), Is) = NFA_construct_reachable_init_interval_impl I;
     (((qm, n), \<A>), _) \<leftarrow> WORKLISTT (\<lambda>_. True)
      (\<lambda>((qm, n), AA) q. 
         if (s.memb (the (qm.lookup (ff q) qm)) (nfa_states AA)) then
           (RETURN (((qm, n), AA), []))
         else                    
           do {
             ASSERT (q2_invar q \<and> q2_\<alpha> q \<in> S);
             ((qm', n'), DD', N) \<leftarrow> 
             NFA_construct_reachable_impl_step_interval DS qm n (nfa_trans AA) q;
             RETURN (((qm', n'), 
                 (s.ins_dj (the (qm.lookup (ff q) qm)) (nfa_states AA), 
                   DD', nfa_initial AA, 
                  (if (FP q) then (s.ins_dj (the (qm.lookup (ff q) qm))) 
                    (nfa_accepting AA) else (nfa_accepting AA)))), N)
           }
        ) (((qm, n), (s.empty (), d.empty, Is, s.empty ())), I);
     RETURN \<A>
   }"

term nfa_construct_interval



lemma NFA_construct_reachable_impl_correct :
fixes D II
defines "I \<equiv> map q2_\<alpha> II"
defines "R \<equiv> build_rel nfa_\<alpha> nfa_invar"
defines "R' \<equiv> build_rel state_map_\<alpha> state_map_invar"
defines "S \<equiv> accessible (LTS_forget_labels D) (set I)"
assumes f_inj_on: "inj_on f S"
    and ff_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
    and d_add_OK:
          "lts_add d.\<alpha> d.invar d.add"
    and dist_I: "distinct I"
    and invar_I: "\<And>q. q \<in> set II \<Longrightarrow> q2_invar q" 
    and DS_OK1: "\<And>q. inj_on (\<lambda>(a, q'). (semI a, q2_\<alpha> q')) (DS q)"
    and DS_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> 
       (DS q, {(a, q'). (q2_\<alpha> q, a, q') \<in> D}) 
        \<in> NFA_construct_reachable_impl_step_rel"
    and FFP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> FFP q \<longleftrightarrow> FP (q2_\<alpha> q)"
shows "NFA_construct_reachable_interval_impl S II FFP DS \<le>
   \<Down> R (NFA_construct_reachable_abstract2_impl I FP D)"
unfolding NFA_construct_reachable_interval_impl_def 
          NFA_construct_reachable_abstract2_impl_def 
          WORKLISTT_def
using [[goals_limit = 5]]
apply (refine_rcg)
(* preprocess goals
   initialisation is OK *)
  apply (unfold I_def)
  apply (rule NFA_construct_reachable_init_interval_impl_correct)
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
          s.correct d.correct_common  nfa_\<alpha>_def)
  (* goal solved *)
  defer
  apply simp
  (* goal solved *)
  apply simp
  (* goal solved *)
  apply (clarify, simp add: br_def)+
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
                       d_add_OK DS_OK[unfolded S_def] nfa_\<alpha>_def DS_OK1) [14] 
  (* goal solved *)
  apply (simp add: rprod_sv R'_def R_def  br_def)
  (* goal solved *)
  apply (simp add: R_def br_def R'_def)
  (* goal solved *)
  apply (clarify, simp  add: R_def br_def)+
  apply (unfold S_def[symmetric] nfa_accepting_def snd_conv)
  apply (simp add: br_def nfa_invar_def)
  apply (simp add: nfa_\<alpha>_def)
  apply (simp add: rprod_sv R'_def R_def  br_def nfa_\<alpha>_def nfa_invar_def)
  apply (clarify, simp add: br_def)
  apply (clarify, simp add: br_def  R'_def)
  apply (rename_tac x1 x2 x3 x4 qm'' q' As n'' \<A>  qm n 
                    Qs DD Is Fs q2 q1 bga qm' n' D' bja r)
  apply (clarify, simp add: br_def DS_OK R'_def)
  defer
  apply (rename_tac y As x q rm \<A> qm n Qs DD Is Fs r)
using [[goals_limit = 6]]
proof -
  
  fix q rm \<A> qm n Qs As DD Is Fs r
  {
   assume rm_q: "state_map_\<alpha> (qm, n) (q2_\<alpha> q) = Some r" and
         in_R': "rm = state_map_\<alpha> (qm, n) \<and> state_map_invar (qm, n)" and
         in_R: "\<A> = nfa_\<alpha> (Qs, DD, Is, Fs) \<and> nfa_invar (Qs, DD, Is, Fs)" and
         invar_q: "q2_invar q" and
         q_in: "q2_\<alpha> q \<in> accessible (LTS_forget_labels D) (q2_\<alpha> ` set II)"

  from q_in have q_in_S: "q2_\<alpha> q \<in> S" unfolding S_def I_def by simp

  from in_R' rm_q ff_OK[OF invar_q q_in_S] have "qm.lookup (ff q) qm = Some r"
    unfolding R'_def 
    by (simp add: state_map_invar_def state_map_\<alpha>_def qm.correct br_def)

  with in_R show "s.memb (the (qm.lookup (ff q) qm)) Qs = 
                (r \<in> \<Q> (nfa_\<alpha> (Qs, DD, Is, Fs)))"
    unfolding R_def by (simp add: nfa_invar_def s.correct nfa_\<alpha>_def)
}
  {
  fix x1 x2 x1b x2a x2b q' qm'' n'' \<A> qm n Qs As DD Is Fs q2 q1 bga qm' n' D' bja r
  assume r_nin_Q: "r \<notin> \<Q> \<A>" and 
       rm_q': "state_map_\<alpha> (qm, n) (q2_\<alpha> q') = Some r" and
       weak_invar: "NFA_construct_reachable_abstract_impl_weak_invar 
             I FP D
         (state_map_\<alpha> (qm, n), \<A>)" and
       invar_qm_n: "
       state_map_invar (qm', n')" and
       p1: "d.invar D'" and
       in_R: "((Qs, DD, Is, Fs), \<A>) \<in> R" and
       p2: "state_map_invar (qm, n)" and
       invar_q': "q2_invar q'" and 
       q'_in_S: "q2_\<alpha> q' \<in> S"
 

  from rm_q' invar_qm_n ff_OK[OF invar_q' q'_in_S] 
      have qm_f_q': "qm.lookup (ff q') qm = Some r"
     unfolding state_map_\<alpha>_def state_map_invar_def 
     apply (simp add: qm.correct)
     using in_R p2 qm.lookup_correct state_map_invar_def by auto

   from in_R r_nin_Q have r_nin_Qs: "r \<notin> s.\<alpha> Qs" 
     by (simp add: R_def br_def nfa_\<alpha>_def)

  from weak_invar have "\<F> \<A> \<subseteq> \<Q> \<A>"
    unfolding NFA_construct_reachable_abstract_impl_weak_invar_def by auto
  with r_nin_Q have "r \<notin> \<F> \<A>" by auto
  with in_R have r_nin_Fs: "r \<notin> s.\<alpha> Fs" 
      by (simp add: R_def br_def nfa_\<alpha>_def)

  from in_R FFP_OK[OF invar_q' q'_in_S]
  have "((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, D', Is,
         if FFP q' then s.ins_dj (the (qm.lookup (ff q') qm)) 
          (snd (snd (snd ((Qs, DD, Is, Fs))))) else 
           (snd (snd (snd ((Qs,  DD, Is, Fs)))))),
        \<lparr>\<Q> = insert r (\<Q> \<A>), \<Delta> = interval_to_set ` d.\<alpha> D', \<I> = \<I> \<A>,
           \<F> = if FP (q2_\<alpha> q') then insert 
           (the (state_map_\<alpha> (qm, n) (q2_\<alpha> q'))) (\<F> \<A>) else \<F> \<A>\<rparr>)
       \<in> R" 
    by (simp add: rm_q' qm_f_q' R_def nfa_\<alpha>_def p1
                nfa_invar_def invar_qm_n s.correct r_nin_Qs r_nin_Fs br_def)
  from this show "(FFP q' \<longrightarrow>
        (FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, D', Is,
           s.ins_dj (the (qm.lookup (ff q') qm)) Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Delta> = interval_to_set ` d.\<alpha> D', \<I> = \<I> \<A>, \<F> = insert r (\<F> \<A>)\<rparr>)
         \<in> R) \<and>
        (\<not> FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, D', Is,
           s.ins_dj (the (qm.lookup (ff q') qm)) Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Delta> = interval_to_set ` d.\<alpha> D', \<I> = \<I> \<A>, \<F> = \<F> \<A>\<rparr>)
         \<in> R)) \<and>
       (\<not> FFP q' \<longrightarrow>
        (FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, D', Is, Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Delta> = interval_to_set ` d.\<alpha> D', \<I> = \<I> \<A>, \<F> = insert r (\<F> \<A>)\<rparr>)
         \<in> R) \<and>
        (\<not> FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, D', Is, Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Delta> = interval_to_set ` d.\<alpha> D', \<I> = \<I> \<A>, \<F> = \<F> \<A>\<rparr>)
         \<in> R)) "
    using rm_q' by auto
}
qed

lemma NFA_construct_reachable_interval_impl_alt_def :
  "NFA_construct_reachable_interval_impl S I FP DS =
   do {
     let ((qm, n), Is) = NFA_construct_reachable_init_interval_impl I;
     ((_, \<A>), _) \<leftarrow> WORKLISTT (\<lambda>_. True)
      (\<lambda>((qm, n), (Qs, DD, Is, Fs)) q. do { 
         let r = the (qm.lookup (ff q) qm);
         if (s.memb r Qs) then
           (RETURN (((qm, n), (Qs, DD, Is, Fs)), []))
         else                    
           do {
             ASSERT (q2_invar q \<and> q2_\<alpha> q \<in> S);
             ((qm', n'), DD', N) \<leftarrow> NFA_construct_reachable_impl_step_interval 
                          DS qm n DD q;
             RETURN (((qm', n'), 
                 (s.ins_dj r Qs, 
                  DD', Is, 
                  (if (FP q) then (s.ins_dj r Fs) else Fs))), N)
           }
         }
        ) (((qm, n), (s.empty (), d.empty, Is, s.empty ())), I);
     RETURN \<A>
   }"
unfolding NFA_construct_reachable_interval_impl_def
apply (simp add: Let_def split_def)
apply (unfold nfa_selectors_def fst_conv snd_conv prod.collapse)
apply simp
done


schematic_goal NFA_construct_reachable_interval_impl_code_aux: 
fixes D_it :: "'q2_rep \<Rightarrow> ((('a \<times> 'a) \<times> 'q2_rep),
                     ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) set_iterator"
assumes D_it_OK[rule_format, refine_transfer]: 
         "\<forall>q. q2_invar q \<longrightarrow> q2_\<alpha> q \<in> S \<longrightarrow> set_iterator (D_it q) 
          {p. p \<in> DS q}"
shows "RETURN ?f \<le> NFA_construct_reachable_interval_impl S I FP DS"

 unfolding NFA_construct_reachable_interval_impl_alt_def nempI_correct
    WORKLISTT_def NFA_construct_reachable_impl_step_interval_def
  apply (unfold split_def snd_conv fst_conv prod.collapse)
  apply (rule refine_transfer | assumption  | erule conjE)+
done


definition (in automaton_by_lts_interval_defs) 
NFA_construct_reachable_interval_impl_code where
"NFA_construct_reachable_interval_impl_code 
 qm_ops (ff::'q2_rep \<Rightarrow> 'i) I FP D_it =
(let ((qm, n), Is) = foldl (\<lambda>((qm, n), Is) q. 
         ((map_op_update_dj qm_ops (ff q) (states_enumerate n) qm, Suc n),
             s.ins_dj (states_enumerate n) Is))
                ((map_op_empty qm_ops (), 0), s.empty()) I;
     ((_, AA), _) = worklist (\<lambda>_. True)
        (\<lambda>((qm, n), Qs, DD, Is, Fs) (q::'q2_rep).
            let r = the (map_op_lookup qm_ops (ff q) qm)
            in if set_op_memb s_ops r Qs then (((qm, n), Qs, DD, Is, Fs), [])
               else let ((qm', n'), DD', N) = D_it q (\<lambda>_::(('m \<times> nat) \<times> 'd \<times> 'q2_rep list). True)
                           (\<lambda>(a, q') ((qm::'m, n::nat), DD'::'d, N::'q2_rep list).
                              if (nempI a) then
                               let r'_opt = map_op_lookup qm_ops (ff q') qm; 
                                   ((qm', n'), r') = if r'_opt = None then 
                                       let r'' = states_enumerate n in 
                                          ((map_op_update_dj qm_ops (ff q') r'' qm, Suc n), r'') 
                                      else ((qm, n), the r'_opt)
                               in ((qm', n'), clts_op_add d_ops r a r' DD', q' # N)
                              else ((qm, n), DD', N))
                           ((qm, n), DD, [])
                    in (((qm', n'), set_op_ins_dj s_ops r Qs, DD', Is, if FP q then set_op_ins_dj s_ops r Fs else Fs), N))
        (((qm, n), set_op_empty s_ops (),
   clts_op_empty d_ops, Is, set_op_empty s_ops ()), I)
 in AA)"


lemma NFA_construct_reachable_interval_impl_code_correct: 
fixes D_it :: "'q2_rep \<Rightarrow> ((('a\<times>'a) \<times> 'q2_rep),
                     ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) set_iterator"
assumes D_it_OK: "\<forall> q. q2_invar q \<longrightarrow> q2_\<alpha> q \<in> S \<longrightarrow> 
                         set_iterator (D_it q) {p. p \<in> DS q}"
shows "RETURN (NFA_construct_reachable_interval_impl_code qm_ops ff I FP D_it) \<le> 
               NFA_construct_reachable_interval_impl S I FP DS"
proof -
  have rule: 
   "\<And>f1 f2. \<lbrakk>RETURN f1 \<le> NFA_construct_reachable_interval_impl S I FP DS; f1 = f2\<rbrakk> \<Longrightarrow>
              RETURN f2 \<le> NFA_construct_reachable_interval_impl S I FP DS" by simp
  
  note aux_thm = NFA_construct_reachable_interval_impl_code_aux[OF D_it_OK, of I FP]

  note rule' = rule[OF aux_thm]
  show ?thesis 
    apply (rule rule')
    apply (simp add: NFA_construct_reachable_interval_impl_code_def 
            split_def Let_def NFA_construct_reachable_init_interval_impl_def
               nempI_correct
                cong: if_cong)
  done
qed

lemma NFA_construct_reachable_interval_impl_code_correct_full: 
fixes D_it :: "'q2_rep \<Rightarrow> ((('a \<times> 'a) \<times> 'q2_rep),('m \<times> nat) 
        \<times> 'd \<times> 'q2_rep list) set_iterator"
fixes II D DS
defines "S \<equiv> accessible (LTS_forget_labels D) (set (map q2_\<alpha> II))"
assumes f_inj_on: "inj_on f S"
    and ff_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
    and d_add_OK: 
          "lts_add d.\<alpha> d.invar d.add"
    and dist_I: "distinct (map q2_\<alpha> II)"
    and invar_I: "\<And>q. q \<in> set II \<Longrightarrow> q2_invar q" 
    and fin_S: "finite S"
    and fin_D: "\<And>q. finite {(a, q'). (q, a, q') \<in> D}"
    and DS_OK1: "\<And>q. inj_on (\<lambda>(a, q'). (semI a, q2_\<alpha> q')) (DS q)"
    and D_it_OK: "(\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> 
            (set_iterator_genord (D_it q) {p. p \<in> DS q} selP \<and>
             ((DS q), {(a, q'). (q2_\<alpha> q, a, q') \<in> D }) \<in> 
            NFA_construct_reachable_impl_step_rel))"
    and FFP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> FFP q \<longleftrightarrow> FP (q2_\<alpha> q)"
shows "NFA_isomorphic (NFA_construct_reachable (set (map q2_\<alpha> II)) FP D)
    (nfa_\<alpha> (NFA_construct_reachable_interval_impl_code qm_ops ff II FFP D_it)) \<and>
    nfa_invar (NFA_construct_reachable_interval_impl_code qm_ops ff II FFP D_it)"
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
      set_iterator (D_it q) {p. p \<in> DS q}"
  proof (intro allI impI)
    fix q
    assume "q2_invar q" "q2_\<alpha> q \<in> S"
    with D_it_OK[of q] show
      "set_iterator (D_it q) {p. p \<in> DS q}"
      using set_iterator_intro by blast
    qed 
  
  note NFA_construct_reachable_interval_impl_code_correct [OF D_it_OK'']
  also have "NFA_construct_reachable_interval_impl 
             S II FFP DS \<le> \<Down> (build_rel nfa_\<alpha> nfa_invar)
     (NFA_construct_reachable_abstract2_impl (map q2_\<alpha> II) FP D)"
    using NFA_construct_reachable_impl_correct 
        [OF f_inj_on[unfolded S_def] ff_OK[unfolded S_def] d_add_OK
          dist_I invar_I, of DS FFP FP] FFP_OK S_def 
    by (auto simp add: FFP_OK D_it_OK DS_OK1)
      also note NFA_construct_reachable_abstract2_impl_correct
  also note NFA_construct_reachable_abstract_impl_correct
  finally have "RETURN (NFA_construct_reachable_interval_impl_code 
            qm_ops ff II FFP D_it) \<le> \<Down> (build_rel nfa_\<alpha> nfa_invar)
     (SPEC (NFA_isomorphic (NFA_construct_reachable 
        (set (map q2_\<alpha> II))  FP D)))"
    using S_def fin_S fin_D
    by (simp add: S_def[symmetric] fin_S fin_Ds)
    
  thus ?thesis 
    by (erule_tac RETURN_ref_SPECD, simp add: br_def)
qed

lemma NFA_construct_reachable_interval_impl_code_correct___remove_unreachable: 
fixes D_it :: "'q2_rep \<Rightarrow> ((('a \<times> 'a) \<times> 'q2_rep) , ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) 
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
    and fin_D: "finite (\<Delta> \<A>)"
     and DS_OK1: "\<And>q. inj_on (\<lambda>(a, q'). (semI a, q2_\<alpha> q')) (DS q)"
    and D_it_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow>
                    set_iterator_genord (D_it q) {p. p \<in> DS q} selP \<and>
                    (DS q, {(a, q'). (q2_\<alpha> q, a, q') \<in> \<Delta> \<A>}) 
                    \<in> NFA_construct_reachable_impl_step_rel"
    and FP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> FP q \<longleftrightarrow> (q2_\<alpha> q) \<in> \<F> \<A>"
    and wf_\<A>: "NFA \<A>"
shows "nfa_invar_NFA (NFA_construct_reachable_interval_impl_code qm_ops ff II FP D_it) \<and>
       NFA_isomorphic_wf (nfa_\<alpha> (NFA_construct_reachable_interval_impl_code 
                                qm_ops ff II FP D_it))
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
      apply (rule finite_subset [OF _ fin_D])
      apply auto
    done
  } note fin_D = this


  let ?FP = "\<lambda>q. q \<in> \<F> \<A>"
  let ?I = "map q2_\<alpha> II"
  thm NFA_construct_reachable_interval_impl_code_correct_full
  from NFA_construct_reachable_interval_impl_code_correct_full 
        [OF f_inj_on' ff_OK d_add_OK dist_I invar_I
         fin_S, where ?FP = ?FP and ?D_it=D_it and selP=selP, 
         OF _ _ _ fin_D DS_OK1 D_it_OK FP_OK] 
         S_subset 
  have step1:
    "NFA_isomorphic (NFA_construct_reachable (set ?I) ?FP (\<Delta> \<A>))
      (nfa_\<alpha> (NFA_construct_reachable_interval_impl_code qm_ops ff II FP D_it))"
    "nfa_invar (NFA_construct_reachable_interval_impl_code qm_ops ff II FP D_it)" 
      by (simp_all add: subset_iff)
 
  from NFA.NFA_remove_unreachable_states_implementation 
            [OF wf_\<A> I_OK, of "?FP" "\<Delta> \<A>"]
  have step2: "NFA_construct_reachable (set ?I)
           ?FP (\<Delta> \<A>) = NFA_remove_unreachable_states \<A>" by simp
 
  from step1(1) step2 NFA_remove_unreachable_states___is_well_formed [OF wf_\<A>] have 
    step3: "NFA_isomorphic_wf (NFA_remove_unreachable_states \<A>) 
                       (nfa_\<alpha> (NFA_construct_reachable_interval_impl_code 
                        qm_ops ff II FP D_it))"
    by (simp add: NFA_isomorphic_wf_def)

  from step3 have step4: "NFA (nfa_\<alpha> 
        (NFA_construct_reachable_interval_impl_code qm_ops ff II FP D_it))"
    unfolding NFA_isomorphic_wf_alt_def by simp

  from step3 step1(2) step4 show ?thesis
    unfolding nfa_invar_NFA_def by simp (metis NFA_isomorphic_wf_sym)
qed


subsection \<open> The following reachable function is for product of two automata \<close>

definition NFA_construct_reachable_impl_step_prod_rel where
  "NFA_construct_reachable_impl_step_prod_rel =
    build_rel (\<lambda>DS. (\<lambda>(a::('a \<times> 'a) \<times> ('a \<times> 'a), q'). 
          (((semI (fst a), semI (snd a))), q2_\<alpha> q')) ` DS)
              (\<lambda>DS. (\<forall>a q'. (a, q') \<in> DS \<longrightarrow> q2_invar q') \<and>
                    (\<forall>a q' q''. (a, q') \<in> DS \<longrightarrow> (a, q'') \<in> DS \<longrightarrow> 
                       ((q2_\<alpha> q' = q2_\<alpha> q'') \<longleftrightarrow> q' = q'')))"


definition NFA_construct_reachable_interval_impl_step_prod where
"NFA_construct_reachable_interval_impl_step_prod DS qm0 n D0 q =
  FOREACH {(a, q'). (a, q') \<in> DS q} 
  (\<lambda>(a, q') ((qm, n), DD', N). 
  if (nempI (intersectI (fst a) (snd a))) then do {
   let ((qm', n'), r') =
    (let r'_opt = qm.lookup (ff q') qm in
      if (r'_opt = None) then
         ((qm.update_dj (ff q') (states_enumerate n) qm, Suc n), states_enumerate n)
      else
         ((qm, n), the r'_opt)
    );
  RETURN ((qm', n'), 
    (d.add (the (qm.lookup (ff q) qm0)) 
    (intersectI (fst a) (snd a)) r' DD'), 
      q' # N )
} else RETURN ((qm, n), DD', N)) ((qm0, n), D0, [])"


lemma inj_product_interval:
  fixes S
  assumes pree1: "(\<forall>a q' q''.
                  (a, q') \<in> S \<longrightarrow>
                  (a, q'') \<in> S \<longrightarrow> (q2_\<alpha> q' = q2_\<alpha> q'') = (q' = q''))" and
          pree2: "\<And>q a b q'. ((a,b), q') \<in> S \<longrightarrow> fst a \<le> snd a \<and> fst b \<le> snd b"
        shows "inj_on (\<lambda>((a1,a2), q'). ((semI a1, semI a2), q2_\<alpha> q'))
               ({(a, q'). (a, q') \<in> S})"
  apply (auto simp add: inj_on_def if_split )
proof -
  fix a b aa ba bb ab bc ac bd be
  assume pre1: "(((a, b), aa, ba), bb) \<in> S" and
         pre2: "(((ab, bc), ac, bd), be) \<in> S" and
         pre3: "q2_\<alpha> bb = q2_\<alpha> be" and
         pre4: "semI (a, b) = semI (ab, bc)" and
         pre5: "semI (aa, ba) = semI (ac, bd)"
  from pre1 pre2 pree2 have  "a \<le> b \<and> aa \<le> ba \<and> ab \<le> bc \<and> ac \<le> bd"
    by auto
  from this semI_def have wellform: "semI (a,b) \<noteq> {} \<and> semI (aa,ba) \<noteq> {} \<and>semI (ab,bc) \<noteq> {} 
                 \<and>semI (ac,bd) \<noteq> {}" 
    apply (simp add: semI_def)
    by auto
    from pre4 inj_semI wellform show c1: "a = ab" by fastforce 
    from pre4 inj_semI wellform show c2:"b = bc" by fastforce
    from pre5 inj_semI wellform show c3:"aa = ac" by fastforce
    from pre5 inj_semI wellform show c4:"ba = bd" by fastforce
    from c1 c2 c3 c4 have "((a, b), aa, ba) = ((ab, bc), ac, bd)" by auto
    from this pree1 pre1 pre2 pre3 show "bb = be" by auto
  qed



lemma inj_same:
  assumes pre1: "{(a, q'). (q2_\<alpha> q, a, q') \<in> D} =
    (\<lambda>x. case x of (a, q') \<Rightarrow> ((semI (fst a), semI (snd a)), q2_\<alpha> q')) `
    {(((a, b), aa, ba), q') |a b aa ba q'. (((a, b), aa, ba), q') \<in> DS q} \<and>
    (\<forall>a b aa ba q'. (((a, b), aa, ba), q') \<in> DS q \<longrightarrow> q2_invar q') \<and>
    (\<forall>a b aa ba q'.
        (((a, b), aa, ba), q') \<in> DS q \<longrightarrow>
        (\<forall>q''. (((a, b), aa, ba), q'') \<in> DS q \<longrightarrow>
               (q2_\<alpha> q' = q2_\<alpha> q'') = (q' = q'')))" 
         and 
       pre2: "(\<And>a b q' q. ((a, b), q') \<in> DS q \<longrightarrow> fst a \<le> snd a \<and> fst b \<le> snd b)"
  shows "{(a, q'). (q2_\<alpha> q, a, q') \<in> D} = (\<lambda>x. case x of
         (x, xa) \<Rightarrow> (case x of (a1, a2) \<Rightarrow> \<lambda>q'. ((semI a1, semI a2), q2_\<alpha> q')) xa) `
         DS q"

proof -
  let ?f = "(\<lambda>x. case x of (a, q') \<Rightarrow> ((semI (fst a), semI (snd a)), q2_\<alpha> q'))"
  from pre1 have con1: "{(a, q'). (q2_\<alpha> q, a, q') \<in> D} =
    ?f ` DS q" 
    by auto
  from this inj_semI inter_correct2 con1 
  have con2: "\<And> a q'. (a, q') \<in> DS q  \<longrightarrow>
        ?f (a, q') = ((semI (fst a), semI (snd a)), q2_\<alpha> q')" by auto

  from this inj_semI inter_correct2 con1 
  have con3: "\<And> a q'. (a, q') \<in> DS q  \<longrightarrow>
        ?f (a, q') = ((semI (fst a), semI (snd a)), q2_\<alpha> q')" by auto

  show "{(a, q'). (q2_\<alpha> q, a, q') \<in> D} =
    (\<lambda>x. case x of
         (x, xa) \<Rightarrow> (case x of (a1, a2) \<Rightarrow> \<lambda>q'. ((semI a1, semI a2), q2_\<alpha> q')) xa) `
    DS q"
    apply (simp add: set_eq_iff)
    apply (rule_tac allI)+
    by (metis (no_types, lifting) case_prod_beta case_prod_conv con1 image_cong mem_Collect_eq)
qed

  
    

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
    and rm_eq: "rm = state_map_\<alpha> (qm0, n)"
    and invar_qm0_n: "state_map_invar (qm0, n)"
    and D0'_eq: "D0' = d.\<alpha> D0" "interval_to_set ` D0' = \<Delta> \<A>"
    and invar_D0: "d.invar D0"
    and rm_q:  "rm (q2_\<alpha> q) = Some r"
    and r_nin: "r \<notin> \<Q> \<A>"
    and invar_q: "q2_invar q"
    and q_in_S: "q2_\<alpha> q \<in> S"
    and DS_OK1: "\<And>q a b q'. ((a,b), q') \<in> DS q \<longrightarrow> fst a \<le> snd a \<and> fst b \<le> snd b"
    and DS_OK: "({(a, q') | a q'.(a, q') \<in> DS q}, 
                 {(a, q'). (q2_\<alpha> q, a, q') \<in> D}) \<in> 
          NFA_construct_reachable_impl_step_prod_rel"
    and weak_invar: "NFA_construct_reachable_abstract_impl_weak_invar 
                     I FP {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D} 
                     (rm, \<A>)"
shows "NFA_construct_reachable_interval_impl_step_prod DS qm0 n D0 q \<le> 
  \<Down> (rprod (build_rel state_map_\<alpha> state_map_invar) 
           (rprod (build_rel (\<lambda> d. interval_to_set ` d.\<alpha> d) d.invar)  
           (map_list_rel (build_rel q2_\<alpha> q2_invar))))
     (NFA_construct_reachable_abstract_impl_step_prod
      S D rm (\<Delta> \<A>) (q2_\<alpha> q))"

  apply (subgoal_tac "NFA_construct_reachable_interval_impl_step_prod 
        DS qm0 n D0 q \<le> 
  \<Down> (rprod (build_rel state_map_\<alpha> state_map_invar) (rprod (build_rel 
           (\<lambda> d. interval_to_set ` d.\<alpha> d) d.invar) 
           (map_list_rel (build_rel q2_\<alpha> q2_invar))))
     (NFA_construct_reachable_abstract_impl_step_prod S D rm (interval_to_set ` D0') 
                                                        (q2_\<alpha> q))")
  apply (simp add: assms(9))

  unfolding NFA_construct_reachable_interval_impl_step_prod_def
          NFA_construct_reachable_abstract_impl_step_prod_def 
          nempI_inter_correct
  using [[goals_limit = 10]]
  apply (refine_rcg)
  (* "preprocess goals" *)
  apply (subgoal_tac "inj_on (\<lambda>((a1,a2), q'). ((semI a1, semI a2), q2_\<alpha> q'))
               ({(a, q'). (a, q') \<in> DS q })")
  apply assumption
  apply (insert DS_OK DS_OK1) []
  apply (simp only: NFA_construct_reachable_impl_step_prod_rel_def)
  apply (rule_tac inj_product_interval)
  apply (simp add: br_def )
  apply (simp add: DS_OK1)
  (* "goal solved" *)
  apply (insert DS_OK) []
  apply (simp add: NFA_construct_reachable_impl_step_prod_rel_def)
  apply (simp add: br_def)
  apply (subgoal_tac "
   {(a, q'). (q2_\<alpha> q, a, q') \<in> D} =
    (\<lambda>x. case x of
         (x, xa) \<Rightarrow> (case x of (a1, a2) \<Rightarrow> \<lambda>q'. ((semI a1, semI a2), q2_\<alpha> q')) xa) `
    DS q")
  apply simp
  apply (rule_tac inj_same)
  apply (simp)
  apply (simp add: DS_OK1)
  (* "goal solved" *)
  apply (simp add: rm_eq D0'_eq invar_qm0_n invar_D0)
  apply (simp add: assms(9) assms(8) invar_D0 br_def invar_qm0_n)
  (* "goal solved" *)
  apply (clarify, simp add: br_def)+
  apply (rename_tac it y z d e k q'' qm n N x D' NN a b q')
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
  add:  ff_OK pw_le_iff refine_pw_simps rprod_sv) 
  apply (rule conjI)
  apply (rule impI)
  defer
  apply (rule impI)
  apply (erule exE)
  apply (rename_tac r)
  defer
  apply (clarify, simp add: br_def)+
  defer
  apply (simp add: br_def D0'_eq)
  defer
  defer
  apply (rename_tac it N z d e k q'' qm n D' t r' NN qm' x y a b q')
  apply simp
    defer
    defer
proof -
  fix it N z d e k q'' qm n D' NN x y a b q'
  assume aq'_in_it: "(((x, y), a, b), q') \<in> it"
     and aq''_in_it: "(((z, d), e, k), q'') \<in> it"
     and it_subset: "it \<subseteq> DS q"
     and q''_q'_eq: "q2_\<alpha> q'' = q2_\<alpha> q'"
     and sem_eq1: "semI (z, d) = semI (x, y)" 
     and sem_eq2: " semI (e, k) = semI (a, b)"
     and neq: "semI (x, y) \<inter> semI (a, b) \<noteq> {}"
  let ?it' = "((\<lambda>x. case x of
              (x, xa) \<Rightarrow>
                (case x of (a1, a2) \<Rightarrow> \<lambda>q'. ((semI a1, semI a2), q2_\<alpha> q')) xa) `
         it)"
  let ?f = "(\<lambda> (a, q'). ((semI (fst a), semI (snd a)), q2_\<alpha> q'))"
  assume invar_foreach: 
     "NFA_construct_reachable_abstract_impl_foreach_invar_prod
      S D rm (interval_to_set ` D0') (q2_\<alpha> q) ?it'
               (state_map_\<alpha> (qm, n), interval_to_set ` d.\<alpha> D', N)"
     and invar_qm_n: "state_map_invar (qm, n)"
     and invar_D': "d.invar D'"
  from DS_OK1 have semInopemtpy: "semI (z,d) \<noteq> {} \<and> semI (e,k) \<noteq> {}" 
    apply (simp add: semI_def)
    using aq''_in_it it_subset by fastforce

  from aq'_in_it aq''_in_it it_subset DS_OK
  have invar_q': "q2_invar q'" and invar_q'': "q2_invar q''"
    by (auto simp add: NFA_construct_reachable_impl_step_prod_rel_def br_def)   
  have q'_in_S: "q2_\<alpha> q' \<in> S"
  proof -
    from DS_OK have "
    {(a, q'). (q2_\<alpha> q, a, q') \<in> D} = 
     (\<lambda>x. case x of
         (x, xa) \<Rightarrow> (case x of (a1, a2) \<Rightarrow> \<lambda>q'. ((semI a1, semI a2), q2_\<alpha> q')) xa)
      ` DS q"
      unfolding NFA_construct_reachable_impl_step_prod_rel_def 
  apply (insert DS_OK ) []
  apply (simp add: NFA_construct_reachable_impl_step_prod_rel_def)
  apply (simp only:  br_def)
  apply (rule inj_same)
  apply simp
  by (simp add: DS_OK1)

  with aq'_in_it it_subset have "?f (((x, y), (a, b)), q') \<in> 
          {(a, q'). (q2_\<alpha> q, a, q') \<in> D}"
    apply simp
  proof -
    assume pre1: "(((x, y), a, b), q') \<in> it" and
           pre2: "it \<subseteq> DS q"
    show " ((semI (x, y), semI (a, b)), q2_\<alpha> q')
    \<in> (\<lambda>x. case x of
            (x, xa) \<Rightarrow> (case x of (a1, a2) \<Rightarrow> \<lambda>q'. ((semI a1, semI a2), q2_\<alpha> q')) xa) `
       DS q"
      using image_iff pre1 pre2 by fastforce
  qed
  from this have
     "((semI (x, y), semI (a, b)), q2_\<alpha> q') \<in> 
          {(a, q'). (q2_\<alpha> q, a, q') \<in> D}"
    by auto 
  from this neq have "(q2_\<alpha> q, q2_\<alpha> q') \<in> LTS_forget_labels 
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
     D'_eq: "interval_to_set ` d.\<alpha> D' = interval_to_set ` D0' \<union>
       {(the (state_map_\<alpha> (qm, n) (q2_\<alpha> q)), fst a \<inter> snd a, 
         the (state_map_\<alpha> (qm, n) q')) |a q'. (a, q') \<in> D''}"
    unfolding NFA_construct_reachable_abstract_impl_foreach_invar_prod.simps 
              NFA_construct_reachable_map_OK_def
              D''_def[symmetric] 
    apply (simp add: D''_def D0'_eq )
    apply (subgoal_tac "snd `
    ({((a1, a2), q'). (q2_\<alpha> q, (a1, a2), q') \<in> D \<and> a1 \<inter> a2 \<noteq> {}} -
     (\<lambda>x. case x of
          (x, xa) \<Rightarrow> (case x of (a1, a2) \<Rightarrow> \<lambda>q'. ((semI a1, semI a2), q2_\<alpha> q')) xa) `
     it)
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
    apply (smt Collect_cong case_prod_conv prod.collapse)
    by (simp add:  D0'_eq 
          NFA_construct_reachable_abstract_impl_foreach_invar_prod.simps D''_def)
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
        "\<exists>a. ((qm.update_dj (ff q'') (states_enumerate n) qm, Suc n), a)
           \<in> br state_map_\<alpha> state_map_invar \<and>
           NFA_construct_reachable_map_OK S (state_map_\<alpha> (qm, n)) {q2_\<alpha> q'} a \<and>
           a (q2_\<alpha> q') = Some (states_enumerate n)"
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
    assume pre1 :"semI (z, d) = semI (x, y)" and
           pre2 : "semI (e, k) = semI (a, b)"
    from semInopemtpy pre1 pre2 have pre3: "z = x \<and> d = y \<and> e = a \<and> k = b"
      apply (simp)
      apply (subgoal_tac "semI (z, d) \<noteq>{} \<and> semI (e, k) \<noteq> {}")
       apply (simp add: inj_semI)
      by auto
      
    from qm_OK rm_q have r_intro1: "state_map_\<alpha> (qm, n) (q2_\<alpha> q) = Some r"
      unfolding NFA_construct_reachable_map_OK_def by simp

    from rm_q rm_eq have r_intro2: "qm.lookup (ff q) qm0 = Some r" 
      using invar_qm0_n
      unfolding state_map_\<alpha>_def state_map_invar_def
      using ff_OK [OF invar_q q_in_S] by (simp add: qm.correct)
    have "insert (r, semI (x, y) \<inter> semI (a, b), r') (interval_to_set ` d.\<alpha> D') = 
          interval_to_set `
          d.\<alpha> (d.add r (intersectI (x, y) (a, b)) r' D') \<and>
          d.invar (d.add r  (intersectI (x, y) (a, b)) r' D')"
      by (metis (no_types, lifting) Interval.inter_correct 
          automaton_by_lts_interval_syntax.interval_to_set.simps 
          d_add_OK image_insert invar_D' lts_add.lts_add_correct(1) 
          lts_add.lts_add_correct(2))
    from pre1 pre2 this D0'_eq have 
       "insert (the (state_map_\<alpha> (qm, n) (q2_\<alpha> q)), semI (x, y) \<inter> semI (a, b), r')
       (interval_to_set ` d.\<alpha> D') =
       interval_to_set `
       d.\<alpha> (d.add (the (qm.lookup (ff q) qm0)) (intersectI (x, y) (a, b)) r' D') \<and>
       d.invar (d.add (the (qm.lookup (ff q) qm0)) (intersectI (x, y) (a, b)) r' D') \<and>
       q2_invar q''"   
      by (simp add: r_intro1 r_intro2 invar_q'')
    from this pre1 pre2 pre3 show "
      insert (the (state_map_\<alpha> (qm, n) (q2_\<alpha> q)), semI (x, y) \<inter> semI (a, b), r')
        (interval_to_set ` d.\<alpha> D') =
       interval_to_set `
       d.\<alpha> (d.add (the (qm.lookup (ff q) qm0)) (intersectI (z, d) (e, k)) r' D') \<and>
       d.invar (d.add (the (qm.lookup (ff q) qm0)) (intersectI (z, d) (e, k)) r' D') \<and>
       q2_invar q''
    "
      by (simp add: pre1 pre2)
  } 
qed

definition NFA_construct_reachable_prod_interval_impl where
  "NFA_construct_reachable_prod_interval_impl S I FP DS  =
   do {
     let ((qm, n), Is) = NFA_construct_reachable_init_interval_impl I;
     (((qm, n), \<A>), _) \<leftarrow> WORKLISTT (\<lambda>_. True)
      (\<lambda>((qm, n), AA) q. 
         if (s.memb (the (qm.lookup (ff q) qm)) (nfa_states AA)) then
           (RETURN (((qm, n), AA), []))
         else                    
           do {
             ASSERT (q2_invar q \<and> q2_\<alpha> q \<in> S);
             ((qm', n'), DD', N) \<leftarrow> 
             NFA_construct_reachable_interval_impl_step_prod 
                    DS qm n (nfa_trans AA) q;
             RETURN (((qm', n'), 
                 (s.ins_dj (the (qm.lookup (ff q) qm)) (nfa_states AA), 
                  DD', nfa_initial AA, 
                  (if (FP q) then (s.ins_dj (the (qm.lookup (ff q) qm))) 
                    (nfa_accepting AA) else (nfa_accepting AA)))), N)
           }
        ) (((qm, n), (s.empty (), d.empty, Is, s.empty ())), I);
     RETURN \<A>
   }"



lemma NFA_construct_reachable_prod_interval_impl_correct :
fixes D II
defines "I \<equiv> map q2_\<alpha> II"
defines "R \<equiv> build_rel nfa_\<alpha> nfa_invar"
defines "R' \<equiv> build_rel state_map_\<alpha> state_map_invar"
defines "S \<equiv> accessible (LTS_forget_labels 
          {(q,a1 \<inter> a2, q')|q a1 a2 q'. (q, (a1,a2),q') \<in> D}) (set I)"
assumes f_inj_on: "inj_on f S"
    and ff_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
    and d_add_OK: 
          "lts_add d.\<alpha> d.invar d.add"
    and dist_I: "distinct I"
    and invar_I: "\<And>q. q \<in> set II \<Longrightarrow> q2_invar q" 
    and DS_OK1: "\<And>q a b q'. ((a,b), q') \<in> DS q \<longrightarrow> fst a \<le> snd a \<and> fst b \<le> snd b"
    and DS_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> 
       (DS q, {(a, q'). (q2_\<alpha> q, a, q') \<in> D}) 
        \<in> NFA_construct_reachable_impl_step_prod_rel"
    and FFP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> FFP q \<longleftrightarrow> FP (q2_\<alpha> q)"
shows "NFA_construct_reachable_prod_interval_impl S II FFP DS \<le>
   \<Down> R (NFA_construct_reachable_abstract2_prod_impl I FP D)"

unfolding NFA_construct_reachable_prod_interval_impl_def 
          NFA_construct_reachable_abstract2_prod_impl_def 
          WORKLISTT_def
using [[goals_limit = 5]]
apply (refine_rcg)
(* preprocess goals
   initialisation is OK *)
   apply (unfold I_def)
   apply (rule NFA_construct_reachable_init_interval_impl_correct)
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
          s.correct d.correct_common nfa_\<alpha>_def)
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
  apply (unfold I_def )
  apply (rule_tac NFA_construct_reachable_impl_step_prod_correct)
  apply (unfold I_def[symmetric])
  apply (simp_all add: nfa_invar_def f_inj_on[unfolded S_def] ff_OK[unfolded S_def] 
                       d_add_OK DS_OK[unfolded S_def]) [14] 
  (* goal solved *)
      apply (simp add: rprod_sv R'_def R_def br_def nfa_\<alpha>_def)
    (* goal solved *)
     apply (simp add: rprod_sv R'_def R_def br_def nfa_\<alpha>_def)
(* goal solved *)
    apply (simp add: rprod_sv R'_def R_def br_def nfa_\<alpha>_def)
  (* goal solved *)
  apply (simp add: R_def br_def R'_def)
  (* goal solved *)
  apply (clarify, simp split del: if_splits add: R_def br_def)+
  apply (unfold S_def[symmetric] nfa_accepting_def snd_conv)
  apply (simp add: br_def nfa_invar_def 
                    NFA_construct_reachable_impl_step_prod_rel_def)
  apply (simp add: DS_OK1)
  apply (insert DS_OK)
  apply (subgoal_tac "\<And> q. {((a, b), q') |a b q'. ((a, b), q') \<in> DS q} = DS q")
  apply (simp add: br_def nfa_invar_def DS_OK DS_OK1 nfa_\<alpha>_def)
  apply fast
  apply (simp add: br_def nfa_invar_def DS_OK DS_OK1 nfa_\<alpha>_def)
  apply (clarify, simp  add:  R'_def )
  apply (rename_tac q' qm'' rm \<A> qm n Qs DD Is Fs n'' q bga qm' n' D' bja r)
  apply (simp add: br_def)
  defer
  apply (rename_tac As q rm \<A> qm n Qs DD Is Fs r)
using [[goals_limit = 6]]
proof -
  fix x y q rm \<A> qm n Qs As DD Is Fs r
  {
   assume rm_q: "state_map_\<alpha> (qm, n) (q2_\<alpha> q) = Some r" and
         in_R': "rm = state_map_\<alpha> (qm, n) \<and> state_map_invar (qm, n)" and
         in_R: "\<A> = nfa_\<alpha> (Qs, DD, Is, Fs) \<and> nfa_invar (Qs, DD, Is, Fs)" and
         invar_q: "q2_invar q" and
         q_in: "q2_\<alpha> q \<in> accessible (LTS_forget_labels 
                {(q, a1 \<inter> a2, q') |q a1 a2 q'. (q, (a1, a2), q') \<in> D}
                ) (q2_\<alpha> ` set II)"

  from q_in have q_in_S: "q2_\<alpha> q \<in> S" unfolding S_def I_def by simp

  from in_R' rm_q ff_OK[OF invar_q q_in_S] have "qm.lookup (ff q) qm = Some r"
    unfolding R'_def 
    by (simp add: state_map_invar_def state_map_\<alpha>_def qm.correct br_def)

  with in_R show "s.memb (the (qm.lookup (ff q) qm)) 
                Qs = (r \<in> \<Q> (nfa_\<alpha> (Qs, DD, Is, Fs)))"
    unfolding R_def by (simp add: nfa_invar_def s.correct nfa_\<alpha>_def)
}

  {
  fix x1 x2 x1b x2a x2b q qm'' rm \<A> qm n Qs DD Is Fs n'' q' bga qm' n' D' bja r
    assume r_nin_Q: "r \<notin> \<Q> \<A>" and 
       rm_q': "state_map_\<alpha> (qm, n) (q2_\<alpha> q') = Some r" and
       weak_invar: "NFA_construct_reachable_abstract_impl_weak_invar 
             I FP {(q, a1 \<inter> a2, q') |q a1 a2 q'. (q, (a1, a2), q') \<in> D}
         (state_map_\<alpha> (qm, n), \<A>)" and
       invar_qm_n: "n'' = state_map_\<alpha> (qm', n') \<and>
       state_map_invar (qm', n') \<and>
       q = interval_to_set ` d.\<alpha> D' \<and>
       d.invar D' \<and> list_all2 (\<lambda>x x'. x' = q2_\<alpha> x \<and> q2_invar x) bja bga" and
       in_R_R_\<A>: "rm = state_map_\<alpha> (qm, n) \<and>
       state_map_invar (qm, n) \<and> ((Qs, DD, Is, Fs), \<A>) \<in> R" and
       invar_q': "q2_invar q'" and 
       q'_in_S: "q2_\<alpha> q' \<in> S"
 

  from rm_q'  ff_OK[OF invar_q' q'_in_S] 
      have qm_f_q': "qm.lookup (ff q') qm = Some r"
     unfolding state_map_\<alpha>_def state_map_invar_def 
     apply (simp add: qm.correct)
     using in_R_R_\<A> qm.lookup_correct state_map_invar_def by auto

   from in_R_R_\<A> r_nin_Q  have r_nin_Qs: "r \<notin> s.\<alpha> Qs" 
     by (simp add: R_def br_def nfa_\<alpha>_def)

  from weak_invar have "\<F> \<A> \<subseteq> \<Q> \<A>"
    unfolding NFA_construct_reachable_abstract_impl_weak_invar_def by auto
  with r_nin_Q have "r \<notin> \<F> \<A>" by auto
  with in_R_R_\<A>  have r_nin_Fs: "r \<notin> s.\<alpha> Fs" 
    by (simp add: R_def br_def nfa_\<alpha>_def)

  from in_R_R_\<A> FFP_OK[OF invar_q' q'_in_S]
  have "((s.ins_dj (the (qm.lookup (ff q') qm)) Qs,  D', Is,
         if FFP q' then s.ins_dj (the (qm.lookup (ff q') qm)) 
          (snd (snd (snd ((Qs, DD, Is, Fs))))) else 
           (snd (snd (snd ((Qs, DD, Is, Fs)))))),
        \<lparr>\<Q> = insert r (\<Q> \<A>), \<Delta> = (interval_to_set ` (d.\<alpha> D')), \<I> = \<I> \<A>,
           \<F> = if FP (q2_\<alpha> q') then insert 
           (the (state_map_\<alpha> (qm, n) (q2_\<alpha> q'))) (\<F> \<A>) else \<F> \<A>\<rparr>)
       \<in> R" 
    by (simp add: rm_q' qm_f_q' R_def nfa_\<alpha>_def 
                nfa_invar_def invar_qm_n s.correct r_nin_Qs r_nin_Fs br_def)
  from this show "(FFP q' \<longrightarrow>
        (FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, D', Is,
           s.ins_dj (the (qm.lookup (ff q') qm)) Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Delta> = interval_to_set ` (d.\<alpha> D'), \<I> = \<I> \<A>, \<F> = insert r (\<F> \<A>)\<rparr>)
         \<in> R) \<and>
        (\<not> FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs,  D', Is,
           s.ins_dj (the (qm.lookup (ff q') qm)) Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Delta> = interval_to_set ` (d.\<alpha> D'), 
           \<I> = \<I> \<A>, \<F> = \<F> \<A>\<rparr>)
         \<in> R)) \<and>
       (\<not> FFP q' \<longrightarrow>
        (FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, D', Is, Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Delta> = interval_to_set ` (d.\<alpha> D'), \<I> = \<I> \<A>, \<F> = insert r (\<F> \<A>)\<rparr>)
         \<in> R) \<and>
        (\<not> FP (q2_\<alpha> q') \<longrightarrow>
         ((s.ins_dj (the (qm.lookup (ff q') qm)) Qs, D', Is, Fs),
          \<lparr>\<Q> = insert r (\<Q> \<A>), \<Delta> = interval_to_set ` (d.\<alpha> D'), \<I> = \<I> \<A>, \<F> = \<F> \<A>\<rparr>)
         \<in> R)) "
    using rm_q' by auto
}
qed

lemma NFA_construct_reachable_prod_impl_alt_def :
  "NFA_construct_reachable_prod_interval_impl S I FP DS =
   do {
     let ((qm, n), Is) = NFA_construct_reachable_init_interval_impl I;
     ((_, \<A>), _) \<leftarrow> WORKLISTT (\<lambda>_. True)
      (\<lambda>((qm, n), (Qs, DD, Is, Fs)) q. do { 
         let r = the (qm.lookup (ff q) qm);
         if (s.memb r Qs) then
           (RETURN (((qm, n), (Qs, DD, Is, Fs)), []))
         else                    
           do {
             ASSERT (q2_invar q \<and> q2_\<alpha> q \<in> S);
             ((qm', n'), DD', N) \<leftarrow> 
                NFA_construct_reachable_interval_impl_step_prod DS qm n DD q;
             RETURN (((qm', n'), 
                 (s.ins_dj r Qs, 
                   DD', Is, 
                  (if (FP q) then (s.ins_dj r Fs) else Fs))), N)
           }
         }
        ) (((qm, n), (s.empty (), d.empty, Is, s.empty ())), I);
     RETURN \<A>
   }"
unfolding NFA_construct_reachable_prod_interval_impl_def
apply (simp add: split_def)
apply (unfold nfa_selectors_def fst_conv snd_conv prod.collapse)
apply simp
done



schematic_goal NFA_construct_reachable_prod_impl_code_aux: 
fixes D_it :: "'q2_rep \<Rightarrow> (((('a \<times> 'a) \<times> ('a \<times> 'a)) \<times> 'q2_rep),
                     ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) set_iterator"
assumes D_it_OK[rule_format, refine_transfer]: 
         "\<forall>q. q2_invar q \<longrightarrow> q2_\<alpha> q \<in> S \<longrightarrow> set_iterator (D_it q) {p. p \<in> DS q}"
shows "RETURN ?f \<le> NFA_construct_reachable_prod_interval_impl S I FP DS"
 unfolding NFA_construct_reachable_prod_impl_alt_def nempI_inter_correct
    WORKLISTT_def NFA_construct_reachable_interval_impl_step_prod_def
  apply (unfold split_def snd_conv fst_conv prod.collapse)
  apply (rule refine_transfer | assumption | erule conjE)+
done


definition (in automaton_by_lts_interval_defs) 
  NFA_construct_reachable_prod_interval_impl_code where
"NFA_construct_reachable_prod_interval_impl_code qm_ops (ff::'q2_rep \<Rightarrow> 'i) I FP D_it =
(let ((qm, n), Is) = foldl (\<lambda>((qm, n), Is) q. 
         ((map_op_update_dj qm_ops (ff q) (states_enumerate n) qm, Suc n),
             s.ins_dj (states_enumerate n) Is))
                ((map_op_empty qm_ops (), 0), s.empty()) I;
     ((_, AA), _) = worklist (\<lambda>_. True)
        (\<lambda>((qm, n), Qs, DD, Is, Fs) (q::'q2_rep).
            let r = the (map_op_lookup qm_ops (ff q) qm)
            in if set_op_memb s_ops r Qs then (((qm, n), Qs, DD, Is, Fs), [])
               else let ((qm', n'), DD', N) = D_it q (\<lambda>_::(('m \<times> nat) \<times> 'd \<times> 'q2_rep list). True)
                (\<lambda>(a, q') ((qm::'m, n::nat), DD'::'d, N::'q2_rep list).
                   if (nempI (intersectI (fst a) (snd a))) then
                               let r'_opt = map_op_lookup qm_ops (ff q') qm; 
                                   ((qm', n'), r') = if r'_opt = None then 
                                       let r'' = states_enumerate n in 
                                          ((map_op_update_dj qm_ops (ff q') r'' qm, Suc n), r'') 
                                      else ((qm, n), the r'_opt)
                               in ((qm', n'), clts_op_add d_ops r 
              (intersectI (fst a) (snd a)) r' DD', q' # N) else ((qm, n), DD', N))
                           ((qm, n), DD, [])
              in (((qm', n'), set_op_ins_dj s_ops r Qs, DD', Is, 
              if FP q then set_op_ins_dj s_ops r Fs else Fs), N))
        (((qm, n), set_op_empty s_ops (), 
   clts_op_empty d_ops, Is, set_op_empty s_ops ()), I)
 in AA)"


lemma NFA_construct_reachable_prod_interval_impl_code_correct: 
fixes D_it :: "'q2_rep \<Rightarrow> (((('a \<times> 'a) \<times> ('a \<times> 'a)) \<times> 'q2_rep),
                     ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) set_iterator"
assumes D_it_OK: "\<forall> q. q2_invar q \<longrightarrow> q2_\<alpha> q \<in> S \<longrightarrow> 
                  set_iterator (D_it q) {p. p \<in> DS q}"
shows "RETURN (NFA_construct_reachable_prod_interval_impl_code qm_ops ff I FP D_it) 
              \<le> 
               NFA_construct_reachable_prod_interval_impl S I FP DS"
proof -
  have rule: 
   "\<And>f1 f2. \<lbrakk>RETURN f1 \<le> NFA_construct_reachable_prod_interval_impl S I FP DS; f1 = f2\<rbrakk> \<Longrightarrow>
              RETURN f2 \<le> NFA_construct_reachable_prod_interval_impl S I FP DS" by simp
  
  note aux_thm = NFA_construct_reachable_prod_impl_code_aux[OF D_it_OK, of I FP ]

  note rule' = rule[OF aux_thm]
  show ?thesis 
    apply (rule rule')
    apply (simp add: NFA_construct_reachable_prod_interval_impl_code_def 
              split_def NFA_construct_reachable_init_interval_impl_def
              nempI_inter_correct
                cong: if_cong)
  done
qed

lemma NFA_construct_reachable_prod_impl_code_correct_full: 
fixes D_it :: "'q2_rep \<Rightarrow> (((('a \<times> 'a) \<times> ('a \<times> 'a)) \<times> 'q2_rep),('m \<times> nat) 
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
    and fin_S: "finite S"
    and fin_D: "\<And>q. finite {(a, q'). (q, a, q') \<in> D}"
    and DS_OK1: "\<And>q a b q'. ((a,b), q') \<in> DS q \<longrightarrow> fst a \<le> snd a \<and> fst b \<le> snd b"
    and D_it_OK: "(\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> 
            (set_iterator_genord (D_it q) 
            {p. p \<in> DS q} selP \<and>
             ((DS q), {(a, q'). (q2_\<alpha> q, a, q') \<in> D }) \<in> 
            NFA_construct_reachable_impl_step_prod_rel))"
    and FFP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> S \<Longrightarrow> FFP q \<longleftrightarrow> FP (q2_\<alpha> q)"
  shows "NFA_isomorphic 
    (NFA_construct_reachable (set (map q2_\<alpha> II))  FP 
                               {(q, a1 \<inter> a2, q') |q a1 a2 q'. (q, (a1, a2), q') \<in> D})
    (nfa_\<alpha> (NFA_construct_reachable_prod_interval_impl_code qm_ops ff II FFP D_it)) 
      \<and>
       nfa_invar (NFA_construct_reachable_prod_interval_impl_code qm_ops ff II FFP D_it)"
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
      set_iterator (D_it q) {p. p \<in> DS q}"
  proof (intro allI impI)
    fix q
    assume "q2_invar q" "q2_\<alpha> q \<in> S"
    with D_it_OK[of q] show
      "set_iterator (D_it q) {p. p \<in> DS q}"
      using set_iterator_intro by blast
    qed 
    thm NFA_construct_reachable_prod_interval_impl_correct 
       
  note NFA_construct_reachable_prod_interval_impl_code_correct [OF D_it_OK'']
  also 
  have "NFA_construct_reachable_prod_interval_impl S II FFP DS \<le> \<Down> (build_rel nfa_\<alpha> nfa_invar)
     (NFA_construct_reachable_abstract2_prod_impl (map q2_\<alpha> II) FP D)"
    using NFA_construct_reachable_prod_interval_impl_correct 
        [OF f_inj_on[unfolded S_def] ff_OK[unfolded S_def] d_add_OK
          dist_I invar_I, of DS FFP FP] FFP_OK S_def 
    by (auto simp add: FFP_OK D_it_OK DS_OK1)
  also note NFA_construct_reachable_abstract2_impl_prod_correct
  also note NFA_construct_reachable_abstract_impl_prod_correct
  finally have 
    "RETURN (NFA_construct_reachable_prod_interval_impl_code qm_ops ff II FFP D_it) 
      \<le> \<Down> (build_rel nfa_\<alpha> nfa_invar)
     (SPEC (NFA_isomorphic (NFA_construct_reachable
       (set (map q2_\<alpha> II))  FP 
        {(q, a1 \<inter> a2, q') |q a1 a2 q'. (q, (a1, a2), q') \<in> D})))"
    using S_def fin_S fin_D
    by (simp add: S_def[symmetric] fin_S fin_Ds)
  thus ?thesis 
    by (erule_tac RETURN_ref_SPECD, simp add: br_def)
qed
term nfa_\<alpha>
lemma NFA_construct_reachable_prod_impl_code_correct___remove_unreachable: 
fixes D_it :: "'q2_rep \<Rightarrow> (((('a \<times> 'a) \<times> ('a \<times> 'a)) \<times> 'q2_rep) , 
              ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) 
      set_iterator"
fixes II D DS
assumes d_add_OK: 
  (* "\<forall>q a q' q''. (q, a, q') \<in> \<Delta> \<A> \<and> (q, a, q'') \<in> \<Delta> \<A> \<and> q'' \<noteq> q' \<longrightarrow> *)
          "lts_add d.\<alpha> d.invar d.add"
    and f_inj_on: "inj_on f (\<Q> \<A>)"
    and D_\<A>_ok: "\<Delta> \<A> = {(q,fst a \<inter> snd a, q')| q a q'. (q, a, q') \<in> D}"
    and finite_D: "finite D"
    and fin_D: "finite (\<Delta> \<A>)"
    and ff_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> (\<Q> \<A>) \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
    and dist_I: "distinct (map q2_\<alpha> II)" 
    and invar_I: "\<And>q. q \<in> set II \<Longrightarrow> q2_invar q" 
    and I_OK: "set (map q2_\<alpha> II) = \<I> \<A>"
    and DS_OK1: "\<And>q a b q'. ((a,b), q') \<in> DS q \<longrightarrow> fst a \<le> snd a \<and> fst b \<le> snd b"
    and D_it_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow>
                    set_iterator_genord (D_it q) {p. p \<in> DS q} selP \<and>
                    (DS q, {(a, q'). (q2_\<alpha> q, a, q') \<in> D}) 
                    \<in> NFA_construct_reachable_impl_step_prod_rel"
    and FP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> FP q \<longleftrightarrow> (q2_\<alpha> q) \<in> \<F> \<A>"
    and wf_\<A>: "NFA \<A>"
  shows "nfa_invar_NFA 
          (NFA_construct_reachable_prod_interval_impl_code qm_ops ff II FP D_it) \<and>
           NFA_isomorphic_wf (nfa_\<alpha> (NFA_construct_reachable_prod_interval_impl_code 
                                    qm_ops ff II FP D_it))
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
      apply (rule finite_subset [OF _ fin_D])
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
           fin_S', where ?FP = ?FP and ?D_it=D_it and 
           selP=selP, OF _ _ _ finite_D' DS_OK1 D_it_OK FP_OK] 
       S_subset 
  have step1:
    "NFA_isomorphic (NFA_construct_reachable (set ?I) ?FP (\<Delta> \<A>))
      (nfa_\<alpha> (NFA_construct_reachable_prod_interval_impl_code qm_ops ff II FP D_it))"
    "nfa_invar (NFA_construct_reachable_prod_interval_impl_code qm_ops ff II FP D_it)" 
    by (simp_all add: subset_iff D_\<A>_ok)
   
 
  from NFA.NFA_remove_unreachable_states_implementation [OF wf_\<A> I_OK , of "?FP" "\<Delta> \<A>"]
  have step2: "NFA_construct_reachable (set ?I)  ?FP (\<Delta> \<A>) = NFA_remove_unreachable_states \<A>" by simp
 
  from step1(1) step2 NFA_remove_unreachable_states___is_well_formed [OF wf_\<A>] have 
    step3: "NFA_isomorphic_wf (NFA_remove_unreachable_states \<A>) 
                       (nfa_\<alpha> (NFA_construct_reachable_prod_interval_impl_code 
                                qm_ops ff II  FP D_it))"
    by (simp add: NFA_isomorphic_wf_def)

  from step3 have step4: "NFA (nfa_\<alpha> 
        (NFA_construct_reachable_prod_interval_impl_code qm_ops ff II FP D_it))"
    unfolding NFA_isomorphic_wf_alt_def by simp

  from step3 step1(2) step4 show ?thesis
    unfolding nfa_invar_NFA_def by simp (metis NFA_isomorphic_wf_sym)
qed


end

lemma (in nfa_by_lts_interval_defs) NFA_construct_reachable_prod_impl_code_correct :
  fixes qm_ops :: "('i, 'q::{NFA_states}, 'm, _) map_ops_scheme" 
    and q2_\<alpha> :: "'q2_rep \<Rightarrow> 'q2"
    and q2_invar :: "'q2_rep \<Rightarrow> bool" 
  assumes "StdMap qm_ops"
  shows "NFASpec.nfa_construct_prod nfa_\<alpha> nfa_invar_NFA  q2_\<alpha> q2_invar 
                 (NFA_construct_reachable_prod_interval_impl_code qm_ops)"
proof (intro nfa_construct_prod.intro nfa_by_map_correct 
       nfa_construct_prod_axioms.intro)
  fix \<A>:: "('q2, 'a) NFA_rec" and f :: "'q2 \<Rightarrow> 'i" and ff I A FP D_it selP
  fix D_it :: "'q2_rep \<Rightarrow> (((('a \<times> 'a) \<times> ('a \<times> 'a)) \<times> 'q2_rep), 
      ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) set_iterator"
  fix D DS
  assume wf_\<A>: "NFA \<A>" 
     and D_\<A>_ok: "{(q, (fst a) \<inter>  (snd a), q')| q a q'. (q, a, q') \<in> D} = (\<Delta> \<A>)"
     and finite_D: "finite D"
     and finite_\<Delta>: "finite (\<Delta> \<A>)"
     and f_inj_on: "inj_on f (\<Q> \<A>)"
     and f_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> (\<Q> \<A>) \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
     and dist_I: "distinct (map q2_\<alpha> I)"
     and invar_I: "\<And>q. q \<in> set I \<Longrightarrow> q2_invar q"
     and I_OK: "q2_\<alpha> ` set I = \<I> \<A>"
     and FP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> FP q = (q2_\<alpha> q \<in> \<F> \<A>)"
     and DS_OK1: "\<And>q a b q'. ((a,b), q') \<in> DS q \<longrightarrow> fst a \<le> snd a \<and> fst b \<le> snd b"
     and D_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> 
              set_iterator (D_it q) {(a, q'). (a, q') \<in> (DS q)} \<and>
                   {(a, q'). (q2_\<alpha> q, a, q') \<in> D} = 
                    (\<lambda>(a, q'). ((semI (fst a), semI (snd a)), q2_\<alpha> q')) ` (DS q) \<and>
                   (\<forall>a q'. (a, q') \<in> (DS q) \<longrightarrow> q2_invar q') \<and>
                   (\<forall>a q'. (a, q') \<in> (DS q) \<longrightarrow>
                           (\<forall>q''. (a, q'') \<in> (DS q) \<longrightarrow> 
                    (q2_\<alpha> q' = q2_\<alpha> q'') = (q' = q'')))"

  from nfa_by_lts_interval_defs_axioms have d_OK: "lts_add d.\<alpha> d.invar d.add" 
    unfolding nfa_by_lts_interval_defs_def StdLTS_def by simp

  from D_\<A>_ok have D_\<A>_ok': 
      "(\<Delta> \<A>) = {(q,(fst a) \<inter> (snd a), q')
    | q a q'. (q, a, q') \<in> D}" by simp

  from `StdMap qm_ops` 
  interpret reach: NFA_construct_reachable_locale s_ops l_ops d_ops qm_ops f ff q2_\<alpha> q2_invar
    using automaton_by_lts_interval_defs_axioms f_OK
    unfolding NFA_construct_reachable_locale_def 
        automaton_by_lts_interval_defs_def by simp
  
  thm reach.NFA_construct_reachable_prod_impl_code_correct___remove_unreachable
  note correct = 
      reach.NFA_construct_reachable_prod_impl_code_correct___remove_unreachable
  [OF _ f_inj_on D_\<A>_ok' finite_D finite_\<Delta> f_OK dist_I invar_I _ DS_OK1 _  _ wf_\<A>, 
    of D_it "(\<lambda> q. q)" "(\<lambda>_ _. True)" FP] 



  show "nfa_invar_NFA (NFA_construct_reachable_prod_interval_impl_code qm_ops ff I FP D_it) \<and>
       NFA_isomorphic_wf (nfa_\<alpha> (NFA_construct_reachable_prod_interval_impl_code 
            qm_ops ff I FP D_it))
        (NFA_remove_unreachable_states \<A>)"
    apply (rule_tac correct)
          apply (simp_all add: I_OK d_OK FP_OK 
            reach.NFA_construct_reachable_impl_step_prod_rel_def)
    apply (insert D_OK f_OK)
    by (simp add:  set_iterator_def br_def)
qed
  

lemma (in nfa_by_lts_interval_defs) NFA_construct_reachable_prod_impl_code_correct_no_enc:
  assumes qm_OK: "StdMap qm_ops"
  shows "NFASpec.nfa_construct_no_enc_prod
       nfa_\<alpha> nfa_invar_NFA  (NFA_construct_reachable_prod_interval_impl_code qm_ops)"
  by  (intro NFASpec.nfa_construct_no_enc_prod_default
      NFA_construct_reachable_prod_impl_code_correct qm_OK)


lemma (in nfa_by_lts_interval_defs) NFA_construct_reachable_impl_code_correct :
  fixes qm_ops :: "('i, 'q::{NFA_states}, 'm, _) map_ops_scheme" 
    and q2_\<alpha> :: "'q2_rep \<Rightarrow> 'q2"
    and q2_invar :: "'q2_rep \<Rightarrow> bool" 
  assumes "StdMap qm_ops"
  shows "NFASpec.nfa_construct nfa_\<alpha> nfa_invar_NFA  q2_\<alpha> q2_invar 
                 (NFA_construct_reachable_interval_impl_code qm_ops)"
proof (intro nfa_construct.intro nfa_by_map_correct nfa_construct_axioms.intro)
  fix \<A>:: "('q2, 'a) NFA_rec" and f :: "'q2 \<Rightarrow> 'i" and ff I FP D_it selP
  fix D_it :: "'q2_rep \<Rightarrow> ((('a \<times> 'a) \<times> 'q2_rep), 
      ('m \<times> nat) \<times> 'd \<times> 'q2_rep list) set_iterator"
  fix DS
  assume wf_\<A>: "NFA \<A>" 
     and f_inj_on: "inj_on f (\<Q> \<A>)"
     and f_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> (\<Q> \<A>) \<Longrightarrow> ff q = f (q2_\<alpha> q)" 
     and finite_\<Delta> : "finite (\<Delta> \<A>)"
     and dist_I: "distinct (map q2_\<alpha> I)"
     and invar_I: "\<And>q. q \<in> set I \<Longrightarrow> q2_invar q"
     and I_OK: "q2_\<alpha> ` set I = \<I> \<A>"
     and FP_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> FP q = (q2_\<alpha> q \<in> \<F> \<A>)"
     and DS_OK1: "\<And>q. inj_on (\<lambda>(a, q'). (semI a, q2_\<alpha> q')) (DS q)"
     and D_OK: "\<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> 
              set_iterator (D_it q) {(a, q'). (a, q') \<in> (DS q)} \<and>
                   {(a, q'). (q2_\<alpha> q, a, q') \<in> \<Delta> \<A>} = 
                    (\<lambda>(a, q'). (semI a, q2_\<alpha> q')) ` (DS q) \<and>
                   (\<forall>a q'. (a, q') \<in> (DS q) \<longrightarrow> q2_invar q') \<and>
                   (\<forall>a q'. (a, q') \<in> (DS q) \<longrightarrow>
                           (\<forall>q''. (a, q'') \<in> (DS q) \<longrightarrow> 
                    (q2_\<alpha> q' = q2_\<alpha> q'') = (q' = q'')))"

  from nfa_by_lts_interval_defs_axioms have d_OK: "lts_add d.\<alpha> d.invar d.add" 
    unfolding nfa_by_lts_interval_defs_def StdLTS_def by simp

  from `StdMap qm_ops` 
  interpret reach: NFA_construct_reachable_locale s_ops l_ops d_ops qm_ops f ff q2_\<alpha> q2_invar
    using automaton_by_lts_interval_defs_axioms f_OK
    unfolding NFA_construct_reachable_locale_def automaton_by_lts_interval_defs_def by simp

 
  thm reach.NFA_construct_reachable_interval_impl_code_correct___remove_unreachable
  note correct = reach.NFA_construct_reachable_interval_impl_code_correct___remove_unreachable
    [OF _ f_inj_on f_OK dist_I invar_I _  finite_\<Delta> DS_OK1  _ _ wf_\<A>, 
     of D_it id "(\<lambda>_ _. True)" FP]

  show "nfa_invar_NFA (NFA_construct_reachable_interval_impl_code qm_ops ff I FP D_it) \<and>
       NFA_isomorphic_wf
        (nfa_\<alpha> (NFA_construct_reachable_interval_impl_code qm_ops ff I FP D_it))
        (NFA_remove_unreachable_states \<A>)"
    apply (rule_tac correct)
          apply (simp_all add: I_OK d_OK FP_OK 
            reach.NFA_construct_reachable_impl_step_rel_def)
    apply (insert D_OK f_OK)
    by (simp add:  set_iterator_def br_def)
qed

lemma (in nfa_by_lts_interval_defs) NFA_construct_reachable_impl_code_correct_no_enc:
  assumes qm_OK: "StdMap qm_ops"
  shows "NFASpec.nfa_construct_no_enc 
       nfa_\<alpha> nfa_invar_NFA  (NFA_construct_reachable_interval_impl_code qm_ops)"
  by  (intro NFASpec.nfa_construct_no_enc_default 
      NFA_construct_reachable_impl_code_correct qm_OK)


subsection \<open> concatenation \<close>

definition tri_union_iterator where 
   "tri_union_iterator 
      (it_1:: 'q1 \<Rightarrow> (('a \<times> 'a) \<times> 'q1, '\<sigma>) set_iterator)
      (it_2:: 'q1 \<Rightarrow> (('a \<times> 'a) \<times> 'q1, '\<sigma>) set_iterator)
      (it_3:: 'q1 \<Rightarrow> (('a \<times> 'a) \<times> 'q1, '\<sigma>) set_iterator) = 
    (\<lambda> q. set_iterator_union (it_1 q) (set_iterator_union (it_2 q) (it_3 q)))"



lemma tri_union_iterator_correct :
fixes D1 :: "('q \<times> ('a \<times> 'a) \<times> 'q) set"
fixes D2 :: "('q \<times> ('a \<times> 'a) \<times> 'q) set"
fixes D3 :: "('q \<times> ('a \<times> 'a) \<times> 'q) set"
assumes it_1_OK: "set_iterator_genord (it_1 q1) 
                  {(a , q1'). (q1, a, q1') \<in> D1} (\<lambda> _ _. True)" and
        it_2_OK: "set_iterator_genord (it_2 q1) 
                  {(a , q1'). (q1, a, q1') \<in> D2} (\<lambda> _ _. True)" and
        it_3_OK: "set_iterator_genord (it_3 q1) 
                  {(a , q1'). (q1, a, q1') \<in> D3} (\<lambda> _ _. True)" and
      disjoint1: "{(a , q1'). (q1, a, q1') \<in> D1} \<inter>
                  {(a , q1'). (q1, a, q1') \<in> D2} = {}" and
      disjoint2: "{(a , q1'). (q1, a, q1') \<in> D1} \<inter>
                  {(a , q1'). (q1, a, q1') \<in> D3} = {}" and
      disjoint3: "{(a , q1'). (q1, a, q1') \<in> D2} \<inter>
                  {(a , q1'). (q1, a, q1') \<in> D3} = {}"
shows "set_iterator (tri_union_iterator it_1 it_2 it_3 q1)
          {(a, q). (q1, a, q) \<in> D1 \<union> D2 \<union> D3}"

proof -
  have con1: "(\<And>a b. a \<in> {(a, q1'). (q1, a, q1') \<in> D2} \<Longrightarrow>
                b \<in> {(a, q1'). (q1, a, q1') \<in> D3} \<Longrightarrow> True)" by auto
  from con1 set_iterator_genord_union_correct[OF it_2_OK it_3_OK disjoint3]
  have "set_iterator_genord (set_iterator_union (it_2 q1) (it_3 q1))
     ({(a, q1'). (q1, a, q1') \<in> D2} \<union> {(a, q1'). (q1, a, q1') \<in> D3}) (\<lambda>_ _. True)"
    by auto
  from this have it_2_3_OK: "set_iterator_genord (set_iterator_union 
                    (it_2 q1) (it_3 q1))
     {(a, q1'). (q1, a, q1') \<in> D2 \<union> D3} (\<lambda>_ _. True)" 
    apply (subgoal_tac 
          "({(a, q1'). (q1, a, q1') \<in> D2} \<union> {(a, q1'). (q1, a, q1') \<in> D3}) = 
            {(a, q1'). (q1, a, q1') \<in> D2 \<union> D3}")
    by auto
  from disjoint1 disjoint2 disjoint3 have con2: 
  "{(a, q1'). (q1, a, q1') \<in> D1} \<inter> {(a, q1'). (q1, a, q1') \<in> D2 \<union> D3} = {}"
    by auto
  have con3: "(\<And>a b. a \<in> {(a, q1'). (q1, a, q1') \<in> D1} \<Longrightarrow>
          b \<in> {(a, q1'). (q1, a, q1') \<in> D2 \<union> D3} \<Longrightarrow> True)" by auto
  from con3 set_iterator_genord_union_correct[OF it_1_OK it_2_3_OK con2]
  have "set_iterator_genord (set_iterator_union (it_1 q1) 
            (set_iterator_union (it_2 q1) (it_3 q1)))
     ({(a, q1'). (q1, a, q1') \<in> D1} \<union> {(a, q1'). (q1, a, q1') \<in> D2 \<union> D3}) (\<lambda>_ _. True)"
    by auto
  from this have con4: "set_iterator_genord 
          (set_iterator_union (it_1 q1) (set_iterator_union (it_2 q1) (it_3 q1)))
     ({(a, q1'). (q1, a, q1') \<in> D1 \<union> D2 \<union> D3}) (\<lambda>_ _. True)"
    apply (subgoal_tac "{(a, q1'). (q1, a, q1') \<in> D1} \<union> {(a, q1'). (q1, a, q1') \<in> D2 \<union> D3} = 
                        {(a, q1'). (q1, a, q1') \<in> D1 \<union> D2 \<union> D3}")
    by auto
  from con4 show ?thesis
    unfolding tri_union_iterator_def set_iterator_def .
qed


definition concat_impl_aux where
"concat_impl_aux c_inter c_nempty const f it_1 it_2 it_3 I1 I2 I1' F1' I2' FP1 FP2 =
 (\<lambda> AA1 AA2. const f (if (c_nempty (c_inter (I1' AA1) (F1' AA1)))
    then (I1 AA1) @ (I2 AA2) else (I1 AA1))
    (\<lambda> q'.(FP2 AA2 q')) 
    (tri_union_iterator (it_1 AA1) (it_2 AA2) (it_3 AA1 (FP1 AA1) 
    (I2' AA2))))"

lemma concat_impl_aux_correct:
assumes const_OK: "nfa_construct_no_enc \<alpha>3 invar3 const"
    and nfa_1_OK: "nfa \<alpha>1 invar1"
    and nfa_2_OK: "nfa \<alpha>2 invar2"
    and f_inj_on: "\<And>n1 n2. inj_on f (\<Q> (\<alpha>1 n1) \<union> \<Q> (\<alpha>2 n2))"
    and I1_OK: "\<And>n1. invar1 n1 \<Longrightarrow> distinct (I1 n1) \<and> set (I1 n1) = \<I> (\<alpha>1 n1)"
    and I1'_F1'_OK: "\<And> n1. invar1 n1 \<Longrightarrow> 
                c_nempty (c_inter (I1' n1) (F1' n1)) \<longleftrightarrow> (\<I> (\<alpha>1 n1) \<inter> \<F> (\<alpha>1 n1) \<noteq> {})"
    and I2_OK: "\<And>n2. invar2 n2 \<Longrightarrow> distinct (I2 n2) \<and> set (I2 n2) = \<I> (\<alpha>2 n2)"
    and FP2_OK: "\<And>n2 q. invar2 n2 \<Longrightarrow> q \<in> \<Q> (\<alpha>2 n2) \<Longrightarrow> FP2 n2 q \<longleftrightarrow> (q \<in> \<F> (\<alpha>2 n2))"
    and FP21_OK: "\<And>n1 n2 q. invar1 n1 \<Longrightarrow> q \<in> \<Q> (\<alpha>1 n1) \<Longrightarrow> invar2 n2 \<Longrightarrow>
                    \<Q> (\<alpha>1 n1) \<inter> \<Q> (\<alpha>2 n2) = {} \<Longrightarrow> \<not> FP2 n2 q"
    and \<alpha>1_\<Delta>: "\<And> n1. invar1 n1 \<Longrightarrow>
                      \<exists> D1.{(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (\<alpha>1 n1)
                              \<and> finite D1"
    and \<alpha>2_\<Delta>: "\<And> n2. invar2 n2 \<Longrightarrow> 
                      \<exists> D2.{(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (\<alpha>2 n2)
                              \<and> finite D2"
    and it_1_OK: "\<And> q n1 D1.{(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (\<alpha>1 n1)
      \<Longrightarrow> finite D1   
      \<Longrightarrow> invar1 n1 \<Longrightarrow> (set_iterator_genord (it_1 n1 q)
                               {(a, q'). (q, a, q') \<in> D1}) (\<lambda>_ _.True)" 
    and it_2_OK: "\<And> q n2 D2.{(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (\<alpha>2 n2) 
      \<Longrightarrow> finite D2
      \<Longrightarrow> invar2 n2 \<Longrightarrow> set_iterator_genord (it_2 n2 q)
                               {(a2, q'). (q, a2, q') \<in> D2} (\<lambda>_ _.True) \<and> 
                    {(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (\<alpha>2 n2)"
    and it_12_OK: "\<And> q n1 n2 D1 D2.
          {(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (\<alpha>1 n1)
      \<Longrightarrow> finite D1 
      \<Longrightarrow> invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> 
          set_iterator_genord (it_3 n1 (FP1 n1) (I2' n2) q)
             {(a, q') | a q'' q'. (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) 
                        \<and> q' \<in> \<I> (\<alpha>2 n2)} 
             (\<lambda>_ _.True)"
    and inj_12: "\<And> q n1 n2 D1 D2. 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (\<alpha>1 n1) \<and> finite D1 \<Longrightarrow> 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (\<alpha>2 n2) \<and> finite D2 \<Longrightarrow>
      invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow>
     inj_on (\<lambda>(a, y). (semI a, y))
     {(a, q').
      (q, a, q')
      \<in> {(q, a, q').
          (q, a, q') \<in> D1 \<or>
          (q, a, q') \<in> D2 \<or>
          (q, a, q')
          \<in> {uu.
              \<exists>q a q' q''.
                 uu = (q, a, q') \<and>
                 (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' \<in> \<I> (\<alpha>2 n2)}}}"
shows "nfa_concat \<alpha>1 invar1 \<alpha>2 invar2 \<alpha>3 invar3
       (concat_impl_aux c_inter c_nempty 
    const f it_1 it_2 it_3 I1 I2 I1' F1' I2' FP1 FP2)"


proof (intro nfa_concat.intro 
             nfa_1_OK nfa_2_OK 
             nfa_concat_axioms.intro)
  from const_OK show "nfa \<alpha>3 invar3" 
  unfolding nfa_construct_no_enc_def by simp

  fix n1 n2
  assume invar_1: "invar1 n1"
     and invar_2: "invar2 n2"
     and Q1Q2_empty: "\<Q> (\<alpha>1 n1) \<inter> \<Q> (\<alpha>2 n2) = {}"
  let ?AA' = "NFA_concatenation (\<alpha>1 n1) (\<alpha>2 n2)"


  from Q1Q2_empty
  have Q1_Q2_empty: "\<Q> (\<alpha>1 n1) \<inter> \<Q> (\<alpha>2 n2) = {}"
    by simp
  from \<alpha>1_\<Delta> invar_1
  obtain D1 where 
    \<alpha>1_\<Delta>_eq: "{(q, semI a, q')| q a q'. (q, a ,q') \<in> D1} = \<Delta> (\<alpha>1 n1)" and 
    finite_D1: "finite D1"
    by meson

  from this it_1_OK have it_1_OK' :"
     \<And> q. invar1 n1 \<Longrightarrow> (set_iterator_genord (it_1 n1 q)
                               {(a, q'). (q, a, q') \<in> D1}) (\<lambda>_ _.True)"
    by auto

  from \<alpha>2_\<Delta> invar_2
  obtain D2 where 
    \<alpha>2_\<Delta>_eq: "{(q, semI a, q')| q a q'. (q, a ,q') \<in> D2} = \<Delta> (\<alpha>2 n2)" and 
    finite_D2: "finite D2"
    by meson

 from this it_2_OK have it_2_OK' :"
     \<And> q a. invar2 n2 \<Longrightarrow> (set_iterator_genord (it_2 n2 q)
                               {(a, q'). (q, a, q') \<in> D2}) (\<lambda>_ _.True)"
   by auto

  let ?D12 = "{(q, a, q')| q a q' q''. (q, a, q'') \<in> D1 \<and> 
                          q'' \<in> \<F> (\<alpha>1 n1) 
                        \<and> q'  \<in> \<I> (\<alpha>2 n2)}"

  

  from \<alpha>1_\<Delta>_eq \<alpha>2_\<Delta>_eq finite_D1 finite_D2 
  have
    \<alpha>12_\<Delta>_eq : "{(q, semI a, q')| q a q'. (q, a, q') \<in> ?D12} = 
                 {(q, a, q')| q a q'' q'.  (q, a, q'') \<in> \<Delta> (\<alpha>1 n1)
                        \<and> q'' \<in> \<F> (\<alpha>1 n1) 
                        \<and> q' \<in> \<I> (\<alpha>2 n2)}"
    apply auto
    apply fastforce
    proof -
       fix q ab q'' q'
       assume a1: "q'' \<in> \<F> (\<alpha>1 n1)"
       assume a2: "(q, ab, q'') \<in> \<Delta> (\<alpha>1 n1)"
       assume "{(q, semI (a, b), q') |q a b q'. (q, (a, b), q') \<in> D1} = \<Delta> (\<alpha>1 n1)"
       then have "\<exists>b c ca ba. (q, ab, q'') = (b, semI (c, ca), ba) \<and> (b, (c, ca), ba) \<in> D1"
         using a2 by blast
       then show "\<exists>c ca. ab = semI (c, ca) \<and> (\<exists>b. (q, (c, ca), b) \<in> D1 \<and> b \<in> \<F> (\<alpha>1 n1))"
          using a1 by blast
      qed
  have finite_I_n2: "finite (\<I> (\<alpha>2 n2))"
    by (meson NFA.finite_\<I> invar_2 nfa.nfa_is_wellformed nfa_2_OK)
  from finite_D1 this \<alpha>1_\<Delta>
  have finite_F: "finite {(q, a, q'). (q, a, q') \<in> D1
                        \<and> q' \<in> \<F> (\<alpha>1 n1) 
                       }" 
    apply (subgoal_tac "{(q, a, q''). (q, a, q'') \<in> D1
                        \<and> q'' \<in> \<F> (\<alpha>1 n1)} \<subseteq> D1")
    apply auto
    by (simp add: rev_finite_subset)
  have finiteeq: "\<And> A B. finite A \<Longrightarrow> A = B \<Longrightarrow> finite B " by auto
  from finite_F finite_I_n2 have con2: "\<And> a. a \<in> \<I> (\<alpha>2 n2) \<Longrightarrow> 
                        finite {(q, b, q'). \<exists> q''. (q, b, q'') \<in> D1
                        \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' = a}"
  proof -
    fix a
    assume p1: "a \<in> \<I> (\<alpha>2 n2)"
    have con1: "\<And> q''. q'' \<in> \<I> (\<alpha>2 n2) \<Longrightarrow>
                       finite ((\<lambda> (q, a, q'). (q, a, q'')) `
                       {(q, a, q'). (q, a, q') \<in> D1
                        \<and> q' \<in> \<F> (\<alpha>1 n1)})"
    
    proof -
      fix q''
      assume p1: "q'' \<in> \<I> (\<alpha>2 n2)" 
      from this finite_F show "finite
            ((\<lambda>(q, a, q'). (q, a, q'')) `
             {(q, a, q'). (q, a, q') \<in> D1 \<and> q' \<in> \<F> (\<alpha>1 n1)})"       
        apply (rule_tac finite_imageI)
        using finite_F by simp
    qed
    have "(\<lambda> (q, b, q'). (q, b, a)) `
                       {(q, a, q'). (q, a, q') \<in> D1
                        \<and> q' \<in> \<F> (\<alpha>1 n1)} = {(q, b, q'). \<exists> q''. (q, b, q'') \<in> D1
                        \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' = a}"
      apply (auto simp add: set_eq_iff)
      by force
    from this con1[OF p1] show 
      "finite {(q, b, q'). \<exists>q''. (q, b, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' = a}"
      by simp
  qed
  let ?A = "{{(q, b, q'). \<exists> q''. (q, b, q'') \<in> D1
                        \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' = a}| a. a \<in> \<I> (\<alpha>2 n2)}"
  from con2 have con3: "\<And> s. s \<in> ?A \<Longrightarrow> finite s"
  proof -
    fix s
    assume p1: "(\<And>a. a \<in> \<I> (\<alpha>2 n2) \<Longrightarrow>
               finite
                {(q, b, q'). \<exists>q''. (q, b, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' = a})" and
           p2: "s \<in> {{(q, b, q'). \<exists>q''. (q, b, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' = a} |a.
              a \<in> \<I> (\<alpha>2 n2)}"
    from p2 
    have "\<exists> a. s = {(q, b, q'). \<exists>q''. (q, b, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' = a}
          \<and> a \<in> \<I> (\<alpha>2 n2) "
      by fastforce
    from this obtain a where
    "s = {(q, b, q'). \<exists>q''. (q, b, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' = a}
          \<and> a \<in> \<I> (\<alpha>2 n2)"
      by auto
    from this p1 show "finite s"
      by force
  qed
  from this finite_I_n2 have con4: "finite (\<Union> ?A)"
    using finite_Union[of ?A] by auto
  have con5:  "{(q, a, q')| q a q'' q'.  (q, a, q'') \<in> D1
                        \<and> q'' \<in> \<F> (\<alpha>1 n1) 
                        \<and> q' \<in> \<I> (\<alpha>2 n2)} = (\<Union> ?A)"
    by blast

  from this con4 have finite_D12: "finite ?D12"
  proof -
    assume "{uu.
     \<exists>q a q'' q'.
        uu = (q, a, q') \<and> (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' \<in> \<I> (\<alpha>2 n2)} =
    \<Union> {{(q, b, q'). \<exists>q''. (q, b, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' = a} |a.
        a \<in> \<I> (\<alpha>2 n2)}"
    from this have "
     {uu.
      \<exists>q a q' q''.
         uu = (q, a, q') \<and> (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' \<in> \<I> (\<alpha>2 n2)}=
     {uu.
      \<exists>q a q'' q'.
         uu = (q, a, q') \<and> (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' \<in> \<I> (\<alpha>2 n2)}"
      by auto
    from this con4 con5 show "finite
     {uu.
      \<exists>q a q' q''.
         uu = (q, a, q') \<and> (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' \<in> \<I> (\<alpha>2 n2)}"
      by simp
  qed

  from it_12_OK[OF \<alpha>1_\<Delta>_eq finite_D1] have it_12_OK' :"
     \<And> q. invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> (set_iterator_genord 
              (it_3 n1 (FP1 n1) (I2' n2) q)
                               {(a, q'). (q, a, q') \<in> ?D12}) (\<lambda>_ _.True)"
  proof -
    fix q
    assume p1: "invar1 n1" and
           p2: "invar2 n2"
    from it_12_OK[OF \<alpha>1_\<Delta>_eq finite_D1  p1 p2, of q]
    show "set_iterator_genord (it_3 n1 (FP1 n1) (I2' n2) q)
          {(a, q').
           (q, a, q')
           \<in> {uu.
               \<exists>q a q' q''.
                  uu = (q, a, q') \<and>
                  (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' \<in> \<I> (\<alpha>2 n2)}}
          (\<lambda>_ _. True)"
      apply (subgoal_tac "{uu.
    \<exists>a q'' q'. uu = (a, q') \<and> (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' \<in> \<I> (\<alpha>2 n2)} = 
    {(a, q').
           (q, a, q')
           \<in> {uu.
               \<exists>q a q' q''.
                  uu = (q, a, q') \<and>
                  (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' \<in> \<I> (\<alpha>2 n2)}}")
       apply simp
      by fastforce
  qed
  have f_inj_on': "inj_on f (\<Q> ?AA')" using f_inj_on 
    by (simp add: NFA_concatenation_def)

  from invar_1 invar_2 nfa_1_OK nfa_2_OK have AA'_wf: "NFA ?AA'"
    apply (rule_tac NFA_concatenation___is_well_formed)
      apply (simp_all add: nfa_def Q1_Q2_empty)
    done


  from Q1_Q2_empty have "\<I> (\<alpha>1 n1) \<subseteq>  \<Q> (\<alpha>1 n1)"
    by (meson NFA.\<I>_consistent invar_1 nfa.nfa_is_wellformed nfa_1_OK)

  from Q1_Q2_empty have "\<I> (\<alpha>2 n2) \<subseteq>  \<Q> (\<alpha>2 n2)"
    by (meson NFA.\<I>_consistent invar_2 nfa.nfa_is_wellformed nfa_2_OK)


  let ?II = "(if c_nempty (c_inter (I1' n1) (F1' n1))
    then (I1 n1) @ (I2 n2) else (I1 n1))"
  have dist_II: "distinct ?II" and set_II: "set ?II = \<I> ?AA'"
    apply (simp add: if_splits)
    apply (insert I1_OK[OF invar_1] I2_OK[OF invar_2] Q1_Q2_empty)
    apply (simp_all)
    using \<open>\<I> (\<alpha>1 n1) \<subseteq> \<Q> (\<alpha>1 n1)\<close> \<open>\<I> (\<alpha>2 n2) \<subseteq> \<Q> (\<alpha>2 n2)\<close> apply blast
    unfolding NFA_concatenation_def
    apply (simp)
    apply (rule conjI)+
     defer
     apply (rule impI)
    defer
  proof {
      assume p1: "\<I> (\<alpha>1 n1) \<inter> \<F> (\<alpha>1 n1) = {}"
      show "c_nempty (c_inter (I1' n1) (F1' n1)) \<longrightarrow> \<I> (\<alpha>1 n1) \<union> \<I> (\<alpha>2 n2) = \<I> (\<alpha>1 n1)"
        apply (rule impI)
      proof -
        assume p2: "c_nempty (c_inter (I1' n1) (F1' n1))"
        
        from p2 invar_1 I1'_F1'_OK[OF invar_1] 
        have "(\<I> (\<alpha>1 n1) \<inter> \<F> (\<alpha>1 n1) \<noteq> {})"
           by blast
         from p1 this have "False"    
           by auto
         from this show "\<I> (\<alpha>1 n1) \<union> \<I> (\<alpha>2 n2) = \<I> (\<alpha>1 n1)" by auto
       qed
     }
     {
       assume p1: "\<I> (\<alpha>1 n1) \<inter> \<F> (\<alpha>1 n1) \<noteq> {}"
       show "\<not> c_nempty (c_inter (I1' n1) (F1' n1)) \<longrightarrow> \<I> (\<alpha>1 n1) = \<I> (\<alpha>1 n1) \<union> \<I> (\<alpha>2 n2)"
         apply (rule impI)
       proof -
       assume p2: "\<not> c_nempty (c_inter (I1' n1) (F1' n1))"
        from p2 invar_1 I1'_F1'_OK[OF invar_1] 
        have "(\<I> (\<alpha>1 n1) \<inter> \<F> (\<alpha>1 n1) = {})" by auto
        from p1 this have "False"    
           by auto
         from this show "\<I> (\<alpha>1 n1) = \<I> (\<alpha>1 n1) \<union> \<I> (\<alpha>2 n2)" by auto
       qed
     }
   qed
    
  have con6: "\<Q> (\<alpha>2 n2) \<subseteq> \<Q> (NFA_concatenation (\<alpha>1 n1) (\<alpha>2 n2))"
    unfolding NFA_concatenation_def
    by simp
 
  let ?FP = "(\<lambda> q. FP2 n2 q)"  
  from con6 FP21_OK[OF invar_1] FP2_OK[OF invar_2]
  have FP_OK: "\<And>q. q \<in> \<Q> ?AA' \<Longrightarrow> ?FP q = (q \<in> \<F> ?AA')" 
    unfolding NFA_concatenation_def
    apply (simp add: if_splits)
  proof -
    fix q
    assume p1: "q \<in> \<Q> (\<alpha>1 n1) \<or> q \<in> \<Q> (\<alpha>2 n2)" and
           p2: "(\<And>q. q \<in> \<Q> (\<alpha>2 n2) \<Longrightarrow> FP2 n2 q = (q \<in> \<F> (\<alpha>2 n2)))"
    show "FP2 n2 q = (q \<in> \<F> (\<alpha>2 n2))" 
    proof (cases "q \<in> \<Q> (\<alpha>1 n1)")
      case True
      assume p3: "q \<in> \<Q> (\<alpha>1 n1)"
      from this Q1_Q2_empty have p4: "q \<notin> \<F> (\<alpha>2 n2)" 
        by (meson NFA.\<F>_consistent disjoint_iff_not_equal invar_2 nfa.nfa_is_wellformed nfa_2_OK subsetD)
      from this FP21_OK[OF invar_1 p3 invar_2] Q1_Q2_empty have "\<not> FP2 n2 q" 
        by simp
      from this p4 show ?thesis  by simp
next
  case False
  assume p5: "q \<notin> \<Q> (\<alpha>1 n1)"
  from p1 p5 have "q \<in> \<Q> (\<alpha>2 n2)" by auto
  from this FP2_OK[OF invar_2] show ?thesis by auto
qed
qed

  let ?D_it = "tri_union_iterator (it_1 n1) (it_2 n2) 
              (it_3 n1 (FP1 n1) (I2' n2))"

 
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

   let ?D = "{(q, a, q'). (q, a, q') \<in> D1 \<or> (q, a, q') \<in> D2 \<or> (q, a, q') \<in> ?D12}"

  define fm where  "fm = (\<lambda> (q1::'e, (a1:: 'c \<times> 'c), q1'::'e)
                          (q2::'f, (a2:: 'c \<times> 'c), q2'::'f). 
             ((q1,q2), (a1, a2), (q1', q2')))"
  from finite_D1 finite_D2 finite_D12 have finite_D : "finite ?D"
    apply (subgoal_tac "?D = D1 \<union> D2 \<union> ?D12")
    by auto

  from \<alpha>1_\<Delta>_eq \<alpha>2_\<Delta>_eq
  have D_\<A>: "{(q, semI a, q') |q a q'. (q, a, q') \<in> ?D} =
        \<Delta> (NFA_concatenation (\<alpha>1 n1) (\<alpha>2 n2))" 
    apply (simp add: NFA_concatenation_def)
    apply (subgoal_tac "\<Delta> (\<alpha>1 n1) = {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} \<and>
                        \<Delta> (\<alpha>2 n2) = {(q, semI a, q') |q a q'. (q, a, q') \<in> D2}")
    apply simp
    apply fast
    by simp
    
 

  have it_1_OK'' : "\<And>q. (set_iterator_genord (it_1 n1 q)
                               {(a, q'). (q, a, q') \<in> D1}) (\<lambda>_ _.True)"
    by (simp add: it_1_OK'[OF invar_1])

  have it_2_OK'' : "\<And>q. set_iterator_genord (it_2 n2 q)
                               {(a2, q'). (q, a2, q') \<in> D2} (\<lambda>_ _.True)"
    by (simp add: it_2_OK'[OF invar_2])

  from it_12_OK'[OF invar_1 invar_2] 
    have it_12_OK'' : "\<And>q. set_iterator_genord (it_3 n1 (FP1 n1) (I2' n2) q)
                               {(a2, q'). (q, a2, q') \<in> ?D12} (\<lambda>_ _.True)"
    by (simp add: it_12_OK')

  have cc1: "\<forall> q a q'. (q, a, q') \<in> \<Delta> (\<alpha>1 n1) \<longrightarrow> 
                q \<in> \<Q> (\<alpha>1 n1) \<and> q' \<in> \<Q> (\<alpha>1 n1)"
    by (simp add: NFA.\<Delta>_consistent NFA_\<alpha>1_n1)

  have cc2: "\<forall> q a q'. (q, a, q') \<in> \<Delta> (\<alpha>2 n2) \<longrightarrow> 
                q \<in> \<Q> (\<alpha>2 n2) \<and> q' \<in> \<Q> (\<alpha>2 n2)"
    by (simp add: NFA.\<Delta>_consistent NFA_\<alpha>2_n2)

  have "\<I> (\<alpha>2 n2) \<subseteq> \<Q> (\<alpha>2 n2)" 
    using \<open>\<I> (\<alpha>2 n2) \<subseteq> \<Q> (\<alpha>2 n2)\<close> by auto

  from \<alpha>1_\<Delta>_eq \<alpha>2_\<Delta>_eq this
  have cc3: "\<forall> q a q'. (q, a, q') \<in> ?D12 \<longrightarrow> 
                q \<in> \<Q> (\<alpha>1 n1) \<and> q' \<in> \<Q> (\<alpha>2 n2)"
    using cc1 by fastforce
    
  
  from Q1_Q2_empty \<alpha>1_\<Delta>_eq \<alpha>2_\<Delta>_eq cc1 cc2
  have \<Delta>1\<Delta>2_empty: "\<And> q.  {(a, q1'). (q, a, q1') \<in> D1}  \<inter>  {(a, q1'). (q, a, q1') \<in> D2} = {}"
    apply simp
    by fastforce

  from Q1_Q2_empty \<alpha>1_\<Delta>_eq \<alpha>2_\<Delta>_eq cc1 cc2
  have \<Delta>1\<Delta>12_empty: "\<And> q.  {(a, q1'). (q, a, q1') \<in> D1}  \<inter>  {(a, q1'). (q, a, q1') \<in> ?D12} = {}"
  proof -
    fix q
    show "{(a, q1'). (q, a, q1') \<in> D1}  \<inter>  {(a, q1'). (q, a, q1') \<in> ?D12} = {}"
    proof (cases "q \<in> \<Q> (\<alpha>1 n1)")
      case True
      assume "q \<in> \<Q> (\<alpha>1 n1)"
      have ccc1: "\<And> a q'. (a, q') \<in>{(a, q1'). (q, a, q1') \<in> D1} \<longrightarrow> q' \<in> \<Q> (\<alpha>1 n1)"
        using \<alpha>1_\<Delta>_eq cc1 by fastforce
      have ccc2: "\<And> a q'. (a, q') \<in>{(a, q1'). (q, a, q1') \<in> ?D12} \<longrightarrow> q' \<in> \<Q> (\<alpha>2 n2)"
        using \<open>\<I> (\<alpha>2 n2) \<subseteq> \<Q> (\<alpha>2 n2)\<close> by auto
      from ccc1 ccc2 Q1_Q2_empty 
      have "\<And> a1 q1 a2 q2 . (a1, q1) \<in>{(a, q1'). (q, a, q1') \<in> D1} \<and>
                             (a2, q2) \<in>{(a, q1'). (q, a, q1') \<in> ?D12} \<longrightarrow>
                            q1 \<noteq> q2" 
        by blast
      from this show ?thesis by fastforce 
next
  case False
  assume p1: "q \<notin> \<Q> (\<alpha>1 n1)"
  from this cc1 \<alpha>1_\<Delta>_eq have ccc1: 
   "{(a, q1'). (q, a, q1') \<in> D1} = {}" by fastforce
  then show ?thesis by auto
qed qed
  from Q1_Q2_empty \<alpha>1_\<Delta>_eq \<alpha>2_\<Delta>_eq cc1 cc2
  have \<Delta>2\<Delta>12_empty: "\<And> q.  {(a, q1'). (q, a, q1') \<in> D2}  \<inter>  {(a, q1'). (q, a, q1') \<in> ?D12} = {}"
  proof -
    fix q
    show "{(a, q1'). (q, a, q1') \<in> D2}  \<inter>  {(a, q1'). (q, a, q1') \<in> ?D12} = {}"
    proof (cases "q \<in> \<Q> (\<alpha>2 n2)")
      case True
      assume "q \<in> \<Q> (\<alpha>2 n2)"
      from this cc3 \<alpha>1_\<Delta>_eq \<alpha>2_\<Delta>_eq 
      have "{(a, q1'). (q, a, q1') \<in> ?D12} = {}" 
        by (metis (no_types, lifting) Collect_empty_eq Q1_Q2_empty case_prodE disjoint_iff_not_equal)
      from this show ?thesis by auto
    next
      case False
      assume "q \<notin> \<Q> (\<alpha>2 n2)"
      from this \<alpha>2_\<Delta>_eq cc2 
      have "{(a, q1'). (q, a, q1') \<in> D2} = {}" by fastforce
      then show ?thesis by auto
    qed
  qed


  from invar_1 invar_2 tri_union_iterator_correct 
         [where ?it_1.0 = "it_1 n1" and ?it_2.0 = "it_2 n2" 
              and ?it_3.0 = "it_3 n1 (FP1 n1) (I2' n2)",
         OF it_1_OK' it_2_OK' it_12_OK' \<Delta>1\<Delta>2_empty \<Delta>1\<Delta>12_empty \<Delta>2\<Delta>12_empty]
  have D_it_OK: "\<And>q. q \<in> \<Q> (NFA_concatenation (\<alpha>1 n1) (\<alpha>2 n2)) \<Longrightarrow> set_iterator 
    (tri_union_iterator (it_1 n1) (it_2 n2) (it_3 n1 (FP1 n1) (I2' n2) ) q)
    {(a, q').
    (q, a, q')
    \<in> D1 \<union> D2 \<union> ?D12}"
    unfolding set_iterator_def
  proof -
    fix q
    from invar_1 invar_2 tri_union_iterator_correct 
         [where ?it_1.0 = "it_1 n1" and ?it_2.0 = "it_2 n2" 
            and ?it_3.0 = "it_3 n1 (FP1 n1) (I2' n2)",
         OF it_1_OK' it_2_OK' it_12_OK' \<Delta>1\<Delta>2_empty \<Delta>1\<Delta>12_empty \<Delta>2\<Delta>12_empty, of q]
    show "set_iterator_genord (tri_union_iterator (it_1 n1) (it_2 n2) 
          (it_3 n1 (FP1 n1) (I2' n2)) q)
          {(a, q').
           (q, a, q')
           \<in> D1 \<union> D2 \<union>
              {uu.
               \<exists>q a q' q''.
                  uu = (q, a, q') \<and>
                  (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' \<in> \<I> (\<alpha>2 n2)}}
          (\<lambda>_ _. True)"
      unfolding set_iterator_def
      by auto
  qed

  from this have D_it_OK': "
   \<And>q. q \<in> \<Q> (NFA_concatenation (\<alpha>1 n1) (\<alpha>2 n2)) \<Longrightarrow>
      set_iterator (?D_it q)
       {(a, q').
        (q, a, q')
        \<in> {(q, a, q').
            (q, a, q') \<in> D1 \<or>
            (q, a, q') \<in> D2 \<or>
            (q, a, q')
            \<in> {uu.
                \<exists>q a q' q''.
                   uu = (q, a, q') \<and>
                   (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' \<in> \<I> (\<alpha>2 n2)}}}
  "
  apply (subgoal_tac "\<And> q. {(a, q').
        (q, a, q')
        \<in> {(q, a, q').
            (q, a, q') \<in> D1 \<or>
            (q, a, q') \<in> D2 \<or>
            (q, a, q')
            \<in> {uu.
                \<exists>q a q' q''.
                   uu = (q, a, q') \<and>
                   (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' \<in> \<I> (\<alpha>2 n2)}}} = 
    {(a, q').
    (q, a, q')
    \<in> D1 \<union> D2 \<union>
       {uu.
        \<exists>q a q' q''.
           uu = (q, a, q') \<and> (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' \<in> \<I> (\<alpha>2 n2)}}")
     apply simp
    by auto

  thm D_it_OK'

  thm nfa_construct_no_enc.nfa_construct_no_enc_correct [OF const_OK 
        AA'_wf f_inj_on' dist_II set_II finite_D  ]
  from  \<alpha>1_\<Delta>_eq finite_D1
  have pp1: "{(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = \<Delta> (\<alpha>1 n1) \<and> finite D1"
    by simp
  from  \<alpha>2_\<Delta>_eq finite_D2
  have pp2: "{(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = \<Delta> (\<alpha>2 n2) \<and> finite D2"
    by simp
  
  note  inj_12' =  inj_12[OF pp1 pp2 invar_1 invar_2]
  from this have inj_12'': "
    \<forall> q. inj_on (\<lambda>(a, y). (semI a, y))
   {(a, q').
    (q, a, q')
    \<in> {(q, a, q').
        (q, a, q') \<in> D1 \<or>
        (q, a, q') \<in> D2 \<or>
        (q, a, q')
        \<in> {uu. \<exists>q a q' q''.
                   uu = (q, a, q') \<and>
                   (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' \<in> \<I> (\<alpha>2 n2)}}}
  " by simp
 note construct_correct = 
        nfa_construct_no_enc.nfa_construct_no_enc_correct [OF const_OK 
        AA'_wf f_inj_on' dist_II set_II finite_D inj_12'' D_\<A> FP_OK, of 
        "(tri_union_iterator (it_1 n1) (it_2 n2) (it_3 n1 (FP1 n1) (I2' n2)))" ]
  from construct_correct 
  show "invar3
        (concat_impl_aux c_inter c_nempty const f it_1 it_2 it_3 I1 I2 I1' F1' I2' FP1
          FP2 n1 n2) \<and>
       NFA_isomorphic_wf
        (\<alpha>3 (concat_impl_aux c_inter c_nempty const f it_1 it_2 it_3 I1 I2 I1' F1' I2'
               FP1 FP2 n1 n2))
        (efficient_NFA_concatenation (\<alpha>1 n1) (\<alpha>2 n2))" 
    unfolding concat_impl_aux_def efficient_NFA_concatenation_def
    using D_it_OK' by blast
qed


definition concat_rename_impl_aux where
"concat_rename_impl_aux 
 c_inter c_nempty const f it_1 it_2 it_3 I1 I2 I1' F1' I2' FP1 FP2 
 rename1 rename2 f1 f2 =
 (\<lambda> A1 A2. 
    let AA1 = rename1 A1 f1 in
    let AA2 = rename2 A2 f2 in
    concat_impl_aux c_inter c_nempty const f it_1 it_2 it_3 I1 I2 I1' 
    F1' I2' FP1 FP2 AA1 AA2)" 


lemma concat_rename_impl_aux_correct:
  fixes \<alpha>1 :: "('q,'a::linorder,'nfa) nfa_\<alpha>"
    and \<alpha>2 :: "('q,'a::linorder,'nfa) nfa_\<alpha>"
assumes const_OK: "nfa_construct_no_enc \<alpha>3 invar3 const"
    and nfa_1_OK: "nfa \<alpha>1' invar1'"
    and nfa_2_OK: "nfa \<alpha>2' invar2'"
    and nfa_1_OK': "nfa \<alpha>1 invar1 \<and> 
                    (\<forall> n. invar1' n \<longrightarrow> invar1 (rename1 n f1))"
    and nfa_2_OK': "nfa \<alpha>2 invar2 \<and> 
                    (\<forall> n. invar2' n \<longrightarrow> invar2 (rename2 n f2))"
    and rename_inter: "\<And> n1 n2. invar1' n1 \<and> invar2' n2 \<longrightarrow> 
                                 \<Q> (\<alpha>1 (rename1 n1 f1)) \<inter> 
                                \<Q> (\<alpha>2 (rename2 n2 f2)) = {}"
    and rename1_OK: "\<And> n. invar1' n \<longrightarrow> \<alpha>1 (rename1 n f1) = (NFA_rename_states (\<alpha>1' n) f1)"
    and rename2_OK: "\<And> n. invar2' n \<longrightarrow> \<alpha>2 (rename2 n f2) = (NFA_rename_states (\<alpha>2' n) f2)"
    and f_inj_on: "\<And>n1 n2. inj_on f (\<Q> (\<alpha>1 n1) \<union> \<Q> (\<alpha>2 n2))"
    and I1_OK: "\<And>n1. invar1 n1 \<Longrightarrow> distinct (I1 n1) \<and> set (I1 n1) = \<I> (\<alpha>1 n1)"
    and I1'_F1'_OK: "\<And> n1. invar1 n1 \<Longrightarrow> 
                c_nempty (c_inter (I1' n1) (F1' n1)) \<longleftrightarrow> (\<I> (\<alpha>1 n1) \<inter> \<F> (\<alpha>1 n1) \<noteq> {})"
    and I2_OK: "\<And>n2. invar2 n2 \<Longrightarrow> distinct (I2 n2) \<and> set (I2 n2) = \<I> (\<alpha>2 n2)"
    and FP2_OK: "\<And>n2 q. invar2 n2 \<Longrightarrow> q \<in> \<Q> (\<alpha>2 n2) \<Longrightarrow> FP2 n2 q \<longleftrightarrow> (q \<in> \<F> (\<alpha>2 n2))"
    and FP21_OK: "\<And>n1 n2 q. invar1 n1 \<Longrightarrow> q \<in> \<Q> (\<alpha>1 n1) \<Longrightarrow> invar2 n2 \<Longrightarrow>
                    \<Q> (\<alpha>1 n1) \<inter> \<Q> (\<alpha>2 n2) = {} \<Longrightarrow> \<not> FP2 n2 q"
    and \<alpha>1_\<Delta>: "\<And> n1. invar1 n1 \<Longrightarrow>
                      \<exists> D1.{(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (\<alpha>1 n1)
                              \<and> finite D1"
    and \<alpha>2_\<Delta>: "\<And> n2. invar2 n2 \<Longrightarrow> 
                      \<exists> D2.{(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (\<alpha>2 n2)
                              \<and> finite D2"
    and it_1_OK: "\<And> q n1 D1.{(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (\<alpha>1 n1)
      \<Longrightarrow> finite D1   
      \<Longrightarrow> invar1 n1 \<Longrightarrow> (set_iterator_genord (it_1 n1 q)
                               {(a, q'). (q, a, q') \<in> D1}) (\<lambda>_ _.True)" 
    and it_2_OK: "\<And> q n2 D2.{(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (\<alpha>2 n2) 
      \<Longrightarrow> finite D2
      \<Longrightarrow> invar2 n2 \<Longrightarrow> set_iterator_genord (it_2 n2 q)
                               {(a2, q'). (q, a2, q') \<in> D2} (\<lambda>_ _.True) \<and> 
                    {(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (\<alpha>2 n2)"
    and it_12_OK: "\<And> q n1 n2 D1 D2.
          {(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (\<alpha>1 n1)
      \<Longrightarrow> finite D1 
      \<Longrightarrow> invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> 
          set_iterator_genord (it_3 n1 (FP1 n1) (I2' n2) q)
             {(a, q') | a q'' q'. (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) 
                        \<and> q' \<in> \<I> (\<alpha>2 n2)} 
             (\<lambda>_ _.True)"
    and inj_12: "\<And> q n1 n2 D1 D2. 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (\<alpha>1 n1) \<and> finite D1 \<Longrightarrow> 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (\<alpha>2 n2) \<and> finite D2 \<Longrightarrow>
      invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow>
      inj_on (\<lambda>(a, y). (semI a, y))
      {(a, q').
       (q, a, q')
        \<in> {(q, a, q').
          (q, a, q') \<in> D1 \<or>
          (q, a, q') \<in> D2 \<or>
          (q, a, q')
            \<in> {uu.
              \<exists>q a q' q''.
                 uu = (q, a, q') \<and>
                 (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (\<alpha>1 n1) \<and> q' \<in> \<I> (\<alpha>2 n2)}}}"
shows "nfa_concat_rename \<alpha>1' invar1' \<alpha>2' invar2' \<alpha>3 invar3
    (concat_rename_impl_aux c_inter c_nempty 
     const f it_1 it_2 it_3 I1 I2 I1' F1' I2' FP1 FP2 rename1 rename2) f1 f2"
proof -
  have invar1': "(\<And>n1. invar1 n1 \<Longrightarrow> invar1 n1)"
    by auto
  note th1 =  concat_impl_aux_correct
      [of \<alpha>3 invar3 const \<alpha>1 invar1 \<alpha>2 invar2 f I1 c_nempty c_inter
          I1' F1' I2 FP2 it_1 it_2 it_3 FP1 I2',  
      OF ]  const_OK nfa_1_OK' nfa_2_OK' f_inj_on
  from th1 I1_OK I1'_F1'_OK I2_OK FP2_OK FP21_OK 
       \<alpha>1_\<Delta> \<alpha>2_\<Delta> it_1_OK it_2_OK it_12_OK inj_12 invar1'
  have c1:"nfa_concat \<alpha>1 invar1 \<alpha>2 invar2 \<alpha>3 invar3
     (concat_impl_aux c_inter c_nempty const f it_1 it_2 it_3 I1 
                      I2 I1' F1' I2' FP1 FP2)"
    by force
  from this show ?thesis
    unfolding nfa_concat_def nfa_concat_rename_def
              nfa_concat_rename_axioms_def 
              nfa_concat_axioms_def
  proof -
    assume p1: 
      "(nfa \<alpha>1 invar1 \<and> nfa \<alpha>2 invar2) \<and>
    nfa \<alpha>3 invar3 \<and>
    (\<forall>n1 n2.
        invar1 n1 \<longrightarrow>
        invar2 n2 \<longrightarrow>
        \<Q> (\<alpha>1 n1) \<inter> \<Q> (\<alpha>2 n2) = {} \<longrightarrow>
        invar3
         (concat_impl_aux c_inter c_nempty const f it_1 it_2 it_3 I1 I2 I1' F1' I2' FP1
           FP2 n1 n2) \<and>
        NFA_isomorphic_wf
         (\<alpha>3 (concat_impl_aux c_inter c_nempty const f it_1 it_2 it_3 I1 I2 I1' F1' I2'
                FP1 FP2 n1 n2))
         (efficient_NFA_concatenation (\<alpha>1 n1) (\<alpha>2 n2)))"
    show "(nfa \<alpha>1' invar1' \<and> nfa \<alpha>2' invar2') \<and>
    nfa \<alpha>3 invar3 \<and>
    (\<forall>n1 n2.
        invar1' n1 \<longrightarrow>
        invar2' n2 \<longrightarrow>
        inj_on f1 (\<Q> (\<alpha>1' n1)) \<longrightarrow>
        inj_on f2 (\<Q> (\<alpha>2' n2)) \<longrightarrow>
        f1 ` \<Q> (\<alpha>1' n1) \<inter> f2 ` \<Q> (\<alpha>2' n2) = {} \<longrightarrow>
        invar3
         (concat_rename_impl_aux c_inter c_nempty const f it_1 it_2 it_3 I1 I2 I1' F1'
           I2' FP1 FP2 rename1 rename2 f1 f2 n1 n2) \<and>
        NFA_isomorphic_wf
         (\<alpha>3 (concat_rename_impl_aux c_inter c_nempty const f it_1 it_2 it_3 I1 I2 I1'
                F1' I2' FP1 FP2 rename1 rename2 f1 f2 n1 n2))
         (efficient_NFA_rename_concatenation f1 f2 (\<alpha>1' n1) (\<alpha>2' n2)))"
      apply (rule conjI)
      using nfa_1_OK nfa_2_OK apply simp
      apply (rule conjI)
      using p1 apply simp
      apply (rule allI impI) +
    proof -
      fix n1 n2
      assume p2: "invar1' n1"
         and p3: "invar2' n2"
         and p4: "inj_on f1 (\<Q> (\<alpha>1' n1))"
         and p5: "inj_on f2 (\<Q> (\<alpha>2' n2))"
         and p6: "f1 ` \<Q> (\<alpha>1' n1) \<inter> f2 ` \<Q> (\<alpha>2' n2) = {}"
      let ?n1 = "rename1 n1 f1"
      let ?n2 = "rename2 n2 f2"
      from p2 nfa_1_OK'
      have c1: "invar1 ?n1"
        by auto
      from p3 nfa_2_OK'
      have c2: "invar2 ?n2"
        by auto
      from rename_inter p2 p3
      have
      c3: "\<Q> (\<alpha>1 ?n1) \<inter> \<Q> (\<alpha>2 ?n2) = {}"
        by auto
      from c1 c2 c3 p1
      have "invar3
         (concat_impl_aux c_inter c_nempty const f it_1 it_2 it_3 I1 I2 I1' F1' I2' FP1
           FP2 ?n1 ?n2) \<and>
        NFA_isomorphic_wf
         (\<alpha>3 (concat_impl_aux c_inter c_nempty const f it_1 it_2 it_3 I1 I2 I1' F1' I2'
                FP1 FP2 ?n1 ?n2))
         (efficient_NFA_concatenation (\<alpha>1 ?n1) (\<alpha>2 ?n2))"
        by blast

      from this 
      show " invar3
        (concat_rename_impl_aux c_inter c_nempty const f it_1 it_2 it_3 I1 I2 I1' F1'
          I2' FP1 FP2 rename1 rename2 f1 f2 n1 n2) \<and>
       NFA_isomorphic_wf
        (\<alpha>3 (concat_rename_impl_aux c_inter c_nempty const f it_1 it_2 it_3 I1 I2 I1'
               F1' I2' FP1 FP2 rename1 rename2 f1 f2 n1 n2))
        (efficient_NFA_rename_concatenation f1 f2 (\<alpha>1' n1) (\<alpha>2' n2))"
        apply (rule_tac conjI)
        unfolding concat_rename_impl_aux_def
        apply force
        apply auto
        unfolding efficient_NFA_rename_concatenation_def
                  efficient_NFA_concatenation_def
        using rename1_OK rename2_OK
        by (simp add: p2 p3)
  qed qed qed
      
    
    

subsection \<open> boolean combinations \<close>



definition product_iterator where
  "product_iterator (it_1::'q1 \<Rightarrow> (('a \<times> 'a) \<times> 'q1, '\<sigma>) set_iterator)
     (it_2::'q2 \<Rightarrow> ('a \<times> 'a)  \<Rightarrow> (('a \<times> 'a) \<times> 'q2, '\<sigma>) set_iterator) = (\<lambda>(q1, q2).
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
fixes D1 :: "('q1 \<times> ('a \<times> 'a) \<times> 'q1) set"
fixes D2 :: "('q2 \<times> ('a \<times> 'a) \<times> 'q2) set"
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

  thm set_iterator_genord_product_correct
  note thm_1 = set_iterator_genord_product_correct [where ?it_a = "it_1 q1" and 
    ?it_b = "(it_2 q2) \<circ> fst", OF it_1_OK it_2_OK']

  let ?f = "\<lambda>((a1, q1'), (a2, q2')). 
             ((a1, a2), (q1', q2'))"
  have inj_on_f: "\<And>S. inj_on ?f S"
    unfolding inj_on_def 
    apply (simp add: split_def)
    apply auto
    done
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

term product_iterator
definition bool_comb_impl_aux where
"bool_comb_impl_aux const f it_1 it_2 I I' FP FP' =
 (\<lambda> bc AA1 AA2. const f (List.product (I AA1) (I' AA2))
  (\<lambda>(q1', q2'). bc (FP AA1 q1') (FP' AA2 q2')) 
    (product_iterator (it_1 AA1) (it_2 AA2)))"





lemma bool_comb_impl_aux_correct:
assumes const_OK: "nfa_construct_no_enc_prod \<alpha>3 invar3 const"
    and nfa_1_OK: "nfa \<alpha>1 invar1"
    and nfa_2_OK: "nfa \<alpha>2 invar2"
    and f_inj_on: "\<And>n1 n2. inj_on f (\<Q> (\<alpha>1 n1) \<times> \<Q> (\<alpha>2 n2))"
    and I1_OK: "\<And>n1. invar1 n1 \<Longrightarrow> distinct (I1 n1) \<and> set (I1 n1) = \<I> (\<alpha>1 n1)" 
    and I2_OK: "\<And>n2. invar2 n2 \<Longrightarrow> distinct (I2 n2) \<and> set (I2 n2) = \<I> (\<alpha>2 n2)"
    and FP1_OK: "\<And>n1 q. invar1 n1 \<Longrightarrow> q \<in> \<Q> (\<alpha>1 n1) \<Longrightarrow> FP1 n1 q \<longleftrightarrow> (q \<in> \<F> (\<alpha>1 n1))"
    and FP2_OK: "\<And>n2 q. invar2 n2 \<Longrightarrow> q \<in> \<Q> (\<alpha>2 n2) \<Longrightarrow> FP2 n2 q \<longleftrightarrow> (q \<in> \<F> (\<alpha>2 n2))"
    and \<alpha>1_\<Delta>: "\<And> n1. invar1 n1 \<Longrightarrow> 
                      \<exists> D1.{(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (\<alpha>1 n1)
                              \<and> finite D1"
    and \<alpha>2_\<Delta>: "\<And> n2. invar2 n2 \<Longrightarrow> 
                      \<exists> D2.{(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (\<alpha>2 n2)
                              \<and> finite D2"
    and it_1_OK: "\<And> q n1 D1. {(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (\<alpha>1 n1)
      \<Longrightarrow> finite D1   
      \<Longrightarrow> invar1 n1 \<Longrightarrow> (set_iterator_genord (it_1 n1 q)
                               {(a, q'). (q, a, q') \<in> D1}) (\<lambda>_ _.True)" 
    and it_2_OK: "\<And>q n2 a D2. {(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (\<alpha>2 n2) 
      \<Longrightarrow> finite D2 \<Longrightarrow>  
              invar2 n2 \<Longrightarrow> set_iterator_genord (it_2 n2 q a)
                               {(a2, q'). (q, a2, q') \<in> D2} (\<lambda>_ _.True) \<and> 
                    {(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (\<alpha>2 n2)"
    and sem_OK: "\<And> n1 n2 D1 D2. 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (\<alpha>1 n1) \<Longrightarrow>
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (\<alpha>2 n2) \<Longrightarrow>
      invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow>
      \<forall>q a b aa ba q'.
     (q, ((a, b), aa, ba), q')
     \<in> {(q, a, q').
         (q, a, q')
         \<in> {((q1, q2), (a1, a2), q1', q2') |q1 a1 q1' q2 a2 q2'.
             (q1, a1, q1') \<in> D1 \<and> (q2, a2, q2') \<in> D2}} \<longrightarrow>
     a \<le> b \<and> aa \<le> ba"

shows "nfa_bool_comb \<alpha>1 invar1 \<alpha>2 invar2 \<alpha>3 invar3
       (bool_comb_impl_aux const f it_1 it_2 I1 I2 FP1 FP2)"
proof (intro nfa_bool_comb.intro 
             nfa_1_OK nfa_2_OK 
             nfa_bool_comb_axioms.intro)
  from const_OK show "nfa \<alpha>3 invar3" 
    unfolding nfa_construct_no_enc_prod_def by simp

  fix n1 n2 bc
  assume invar_1: "invar1 n1"
     and invar_2: "invar2 n2"
  let ?AA' = "bool_comb_NFA bc (\<alpha>1 n1) (\<alpha>2 n2)"

  from \<alpha>1_\<Delta> invar_1
  obtain D1 where 
    \<alpha>1_\<Delta>_eq: "{(q, semI a, q')| q a q'. (q, a ,q') \<in> D1} = \<Delta> (\<alpha>1 n1)" and 
    finite_D1: "finite D1"
    by meson

  from this it_1_OK have it_1_OK' :"
     \<And> q. invar1 n1 \<Longrightarrow> (set_iterator_genord (it_1 n1 q)
                               {(a, q'). (q, a, q') \<in> D1}) (\<lambda>_ _.True)"
    by auto

  from \<alpha>2_\<Delta> invar_2
  obtain D2 where 
    \<alpha>2_\<Delta>_eq: "{(q, semI a, q')| q a q'. (q, a ,q') \<in> D2} = \<Delta> (\<alpha>2 n2)" and 
    finite_D2: "finite D2"
    by meson

 from this it_2_OK have it_2_OK' :"
     \<And> q a. invar2 n2 \<Longrightarrow> (set_iterator_genord (it_2 n2 q a)
                               {(a, q'). (q, a, q') \<in> D2}) (\<lambda>_ _.True)"
    by auto
  
    
  have f_inj_on': "inj_on f (\<Q> ?AA')" 
      using f_inj_on by (simp add: bool_comb_NFA_def)

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


  let ?FP = "(\<lambda>(q1', q2'). bc (FP1 n1 q1') (FP2 n2 q2'))"  
  from FP1_OK[OF invar_1] FP2_OK[OF invar_2]
  have FP_OK: "\<And>q. q \<in> \<Q> ?AA' \<Longrightarrow> ?FP q = (q \<in> \<F> ?AA')" by auto

  let ?D_it = "product_iterator (it_1 n1) (it_2 n2)"

  let ?D = "{((q1,q2), (a1, a2), (q1',q2'))
              | q1 a1 q1' q2 a2 q2'. 
                (q1,a1,q1') \<in> D1 \<and> 
                (q2,a2,q2') \<in> D2}"

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
  from finite_D1 finite_D2 have finite_D : "finite ?D"
  proof -
    from finite_D1  have inte1: "D1 \<times> D2 = {((q1, a1, q1'), (q2, a2, q2')) |q1 a1 q1' q2 a2 q2'.
      (q1, a1, q1') \<in> D1 \<and> (q2, a2, q2') \<in> D2}" by auto
    from finite_D1 finite_D2 have inte2: "finite (D1 \<times> D2)" by auto 
    let ?ff  = "\<lambda> ((q1, a1, q1'), (q2, a2, q2')).
               ((q1, q2), (a1, a2), q1', q2')"
    have "?D = ?ff ` {((q1, a1, q1'), (q2, a2, q2')) |q1 a1 q1' q2 a2 q2'.
      (q1, a1, q1') \<in> D1 \<and> (q2, a2, q2') \<in> D2}" 
      apply (simp)
      apply auto
    proof -
      fix q1 ad bd q1' q2 ae be q2'
      assume D1_p: "(q1, (ad, bd), q1') \<in> D1" and
             D2_p: "(q2, (ae, be), q2') \<in> D2" 
      from this have "?ff ((q1, (ad, bd), q1'), (q2, (ae, be), q2')) = 
        ((q1, q2), ((ad, bd), ae, be), q1', q2')" by auto
      from this D1_p D2_p show "((q1, q2), ((ad, bd), ae, be), q1', q2')
       \<in> ?ff `
          {((q1, (a, b), q1'), q2, (aa, ba), q2') |q1 a b q1' q2 aa ba q2'.
           (q1, (a, b), q1') \<in> D1 \<and> (q2, (aa, ba), q2') \<in> D2}"
        by (metis (mono_tags, lifting) image_eqI mem_Collect_eq)
    qed
    from this finite_D1 finite_D2  inte1 inte2 show "finite
     {((q1, q2), (a1, a2), q1', q2') |q1 a1 q1' q2 a2 q2'.
      (q1, a1, q1') \<in> D1 \<and> (q2, a2, q2') \<in> D2}"
      by auto
  qed

  have D_\<A>: "{(q, semI (fst a) \<inter> semI (snd a), q') |q a q'. (q, a, q') \<in> ?D} =
  \<Delta> (bool_comb_NFA bc (\<alpha>1 n1) (\<alpha>2 n2))" 
    apply (simp add: LTS_product_def)
  proof -
    show "{((a, b), semI (aa, ba) \<inter> semI (ab, bb), ac, bc) |a b aa ba ab bb ac bc.
     (a, (aa, ba), ac) \<in> D1 \<and> (b, (ab, bb), bc) \<in> D2} =
    {((p, q), \<sigma>1 \<inter> \<sigma>2, p', q') |p p' \<sigma>1 \<sigma>2 q q'.
     (p, \<sigma>1, p') \<in> \<Delta> (\<alpha>1 n1) \<and> (q, \<sigma>2, q') \<in> \<Delta> (\<alpha>2 n2)}"
      apply (simp only: set_eq_iff)
      proof
      fix x
      show "(x \<in> {((a, b), semI (aa, ba) \<inter> semI (ab, bb), ac, bc) |a b aa ba ab bb ac bc.
               (a, (aa, ba), ac) \<in> D1 \<and> (b, (ab, bb), bc) \<in> D2}) \<longleftrightarrow>
         (x \<in> {((p, q), \<sigma>1 \<inter> \<sigma>2, p', q') |p p' \<sigma>1 \<sigma>2 q q'.
                (p, \<sigma>1, p') \<in> \<Delta> (\<alpha>1 n1) \<and> (q, \<sigma>2, q') \<in> \<Delta> (\<alpha>2 n2)})"
      proof  
        {
      assume pre1: "(x \<in> {((a, b), semI (aa, ba) \<inter> semI (ab, bb), ac, bc) |a b aa ba ab bb ac bc.
               (a, (aa, ba), ac) \<in> D1 \<and> (b, (ab, bb), bc) \<in> D2})"
      from this obtain a b aa ba ab bb ac bc where
               D1_in: "(a, (aa, ba), ac) \<in> D1" and
               D2_in: "(b, (ab, bb), bc) \<in> D2" and 
               x_in:   "x = ((a, b), semI (aa, ba) \<inter> semI (ab, bb), ac, bc)" by auto
      from D1_in D2_in \<alpha>2_\<Delta>_eq \<alpha>1_\<Delta>_eq obtain p \<sigma>1 p' q \<sigma>2 q' where
           "(p,\<sigma>1,p') \<in> \<Delta> (\<alpha>1 n1)" and 
           "(p,\<sigma>1,p') = (a, semI (aa, ba), ac)" and
           "(q,\<sigma>2,q') \<in> \<Delta> (\<alpha>2 n2)" and 
           "(q,\<sigma>2,q') = (b, semI (ab, bb), bc)"
        by fast
      from this pre1  D1_in D2_in x_in \<alpha>2_\<Delta>_eq \<alpha>1_\<Delta>_eq
      show
          con1: "(x \<in> {((p, q), \<sigma>1 \<inter> \<sigma>2, p', q') |p p' \<sigma>1 \<sigma>2 q q'.
                (p, \<sigma>1, p') \<in> \<Delta> (\<alpha>1 n1) \<and> (q, \<sigma>2, q') \<in> \<Delta> (\<alpha>2 n2)})" 
        by auto
       
    }{
      assume pre2: "(x \<in> {((p, q), \<sigma>1 \<inter> \<sigma>2, p', q') |p p' \<sigma>1 \<sigma>2 q q'.
                (p, \<sigma>1, p') \<in> \<Delta> (\<alpha>1 n1) \<and> (q, \<sigma>2, q') \<in> \<Delta> (\<alpha>2 n2)})"

      from this obtain p \<sigma>1 p' q \<sigma>2 q' where
          n1_in:  "(p,\<sigma>1,p') \<in> \<Delta> (\<alpha>1 n1)" and 
          n2_in:  "(q,\<sigma>2,q') \<in> \<Delta> (\<alpha>2 n2)" and
          x_in: "x = ((p, q), \<sigma>1 \<inter> \<sigma>2, p', q')" by auto
      from  n1_in \<alpha>2_\<Delta>_eq \<alpha>1_\<Delta>_eq n2_in \<alpha>2_\<Delta>_eq \<alpha>1_\<Delta>_eq 
        obtain a b aa ba ab bb ac bc where
               "(a, (aa, ba), ac) \<in> D1" and
               "(a, semI (aa, ba), ac) = (p,\<sigma>1,p')" and
               "(b, (ab, bb), bc) \<in> D2" and 
               "(b, semI (ab, bb), bc) = (q,\<sigma>2,q')" 
        by (smt mem_Collect_eq old.prod.exhaust)    
    from this pre2 \<alpha>2_\<Delta>_eq \<alpha>1_\<Delta>_eq n1_in n2_in x_in 
      show con2: "(x \<in> {((a, b), semI (aa, ba) \<inter> semI (ab, bb), ac, bc) |a b aa ba ab bb ac bc.
               (a, (aa, ba), ac) \<in> D1 \<and> (b, (ab, bb), bc) \<in> D2})" by auto
    }
  qed qed qed
 

  have it_1_OK'' : "\<And>q. (set_iterator_genord (it_1 n1 q)
                               {(a, q'). (q, a, q') \<in> D1}) (\<lambda>_ _.True)"
    by (simp add: it_1_OK'[OF invar_1])

   have it_2_OK'' : "\<And>q a. set_iterator_genord (it_2 n2 q a)
                               {(a2, q'). (q, a2, q') \<in> D2} (\<lambda>_ _.True)"
    by (simp add: it_2_OK'[OF invar_2])
    
   from product_iterator_correct [where ?it_1.0 = "it_1 n1" and ?it_2.0 = "it_2 n2",
         OF it_1_OK' it_2_OK']
    have D_it_OK: "\<And>q. set_iterator (product_iterator (it_1 n1) (it_2 n2) q)
     {(a, q'). (q, a, q') \<in> ?D}"
    unfolding set_iterator_def
    apply (case_tac q) 
    apply (simp_all add: split_def product_iterator_correct prod.exhaust)
    apply auto
  proof -
    fix aa ba
    assume pre1: "(\<And>q1 q2. invar1 n1 \<Longrightarrow>
           invar2 n2 \<Longrightarrow>
           set_iterator_genord (product_iterator (it_1 n1) (it_2 n2) (q1, q2))
            {p. (q1, fst (fst p), fst (snd p)) \<in> D1 \<and>
                (q2, snd (fst p), snd (snd p)) \<in> D2}
            (\<lambda>_ _. True))"
    have "{p. \<exists>a b q1' ab bb.
               fst p = ((a, b), ab, bb) \<and>
               (\<exists>q2'. snd p = (q1', q2') \<and>
                      (aa, (a, b), q1') \<in> D1 \<and> (ba, (ab, bb), q2') \<in> D2)} = 
       {p. (aa, fst (fst p), fst (snd p)) \<in> D1 \<and>
                (ba, snd (fst p), snd (snd p)) \<in> D2} "
      by fastforce
    from pre1 invar_1 invar_2 this show "set_iterator_genord (product_iterator (it_1 n1) (it_2 n2) (aa, ba))
        {p. \<exists>a b q1' ab bb.
               fst p = ((a, b), ab, bb) \<and>
               (\<exists>q2'. snd p = (q1', q2') \<and>
                      (aa, (a, b), q1') \<in> D1 \<and> (ba, (ab, bb), q2') \<in> D2)}
        (\<lambda>_ _. True)"
      by simp
  qed 
  note sem_OK' = sem_OK[of D1 n1 D2 n2, OF \<alpha>1_\<Delta>_eq \<alpha>2_\<Delta>_eq invar_1 invar_2]
 note construct_correct = 
        nfa_construct_no_enc_prod.nfa_construct_no_enc_correct [OF const_OK
    AA'_wf f_inj_on' dist_II set_II finite_D sem_OK' D_\<A>, OF FP_OK D_it_OK]
  thus "invar3 (bool_comb_impl_aux const f it_1 it_2 I1 I2 FP1 FP2 bc n1 n2) \<and> 
        NFA_isomorphic_wf (\<alpha>3 (bool_comb_impl_aux const f it_1 it_2 I1 I2 FP1 FP2 bc n1 n2))
        (efficient_bool_comb_NFA bc (\<alpha>1 n1) (\<alpha>2 n2))" 
    apply (simp_all add: bool_comb_impl_aux_def efficient_bool_comb_NFA_def)
    done
qed


context nfa_dfa_by_lts_interval_defs 
begin

  fun rename_states_impl where
  "rename_states_impl im im2  = 
    nfa.rename_states_gen_impl im im2"

schematic_goal rename_states_code:
  "rename_states_impl im im2 (Q, D, I, F) f = ?rename_states_code"
  unfolding rename_states_impl.simps
            nfa.rename_states_gen_impl.simps  
   by (rule refl)+

 term nfa.NFA_construct_reachable_interval_impl_code




fun nfa_construct_reachable where
  "nfa_construct_reachable qm_ops it A = 
   nfa.NFA_construct_reachable_interval_impl_code qm_ops id
   (s.to_list (nfa.nfa_initial A))
   (\<lambda> q. s.memb q (nfa.nfa_accepting A)) (it (nfa.nfa_trans A))
  "

schematic_goal nfa_construct_reachable_code :
  "nfa_construct_reachable qm_ops it (Q2, D2, I2, F2) = ?XXX1"
unfolding nfa_construct_reachable.simps 
            nfa.nfa_selectors_def  snd_conv fst_conv
            nfa.NFA_construct_reachable_interval_impl_code_def 
 by (rule refl)+

  fun bool_comb_gen_impl where
    "bool_comb_gen_impl qm_ops it_1_nfa it_2_nfa
       A' bc =
        (bool_comb_impl_aux 
         (nfa.NFA_construct_reachable_prod_interval_impl_code qm_ops) id 
          (\<lambda>A. it_1_nfa (nfa.nfa_trans A)) (\<lambda>A. it_2_nfa (nfa.nfa_trans A))
           (\<lambda>A. (s.to_list (nfa.nfa_initial A))) 
            (\<lambda>A. (s.to_list (nfa.nfa_initial A))) 
             (\<lambda>A q. s.memb q (nfa.nfa_accepting A)) 
              (\<lambda>A q. s.memb q (nfa.nfa_accepting A)) A' bc)"

schematic_goal bool_comb_gen_impl_code :
  "bool_comb_gen_impl qm_ops it_1_nfa it_2_nfa
    bc (Q1, D1, I1, F1) (Q2, D2, I2, F2) = ?XXX1"
  unfolding bool_comb_gen_impl.simps 
            bool_comb_impl_aux_def product_iterator_alt_def
            nfa.nfa_selectors_def  snd_conv fst_conv
            nfa.NFA_construct_reachable_prod_interval_impl_code_def 
 by (rule refl)+

fun bool_comb_impl where
     "bool_comb_impl qm_ops it_1_nfa it_2_nfa bc =
      bool_comb_gen_impl qm_ops it_1_nfa it_2_nfa bc"

schematic_goal bool_comb_impl_code :
  "bool_comb_impl qm_ops it_1_nfa it_2_nfa
     bc (Q1, D1, I1, F1) (Q2, D2, I2, F2) = ?XXX1"
 unfolding bool_comb_impl.simps bool_comb_gen_impl_code
           nfa.nfa_selectors_def snd_conv fst_conv
 by (rule refl)+


definition (in nfa_dfa_by_lts_interval_defs) nfa_dfa_invar where
     "nfa_dfa_invar n = (nfa.nfa_invar_NFA n)"

definition (in nfa_dfa_by_lts_interval_defs) nfa_dfa_\<alpha> where
     "nfa_dfa_\<alpha> n = (nfa.nfa_\<alpha> n)"

lemma automaton_by_lts_correct :
  "nfa nfa_dfa_\<alpha> nfa_dfa_invar"
  unfolding nfa_dfa_\<alpha>_def nfa_dfa_invar_def
  by simp


lemma bool_comb_gen_impl_correct :
assumes qm_ops_OK: "StdMap qm_ops"
    and it_1_nfa_OK: "lts_succ_label_it d_nfa.\<alpha> d_nfa.invar it_1_nfa"
    and it_2_nfa_OK: "lts_succ_it d_nfa.\<alpha> d_nfa.invar it_2_nfa" 
    and \<Delta>_\<A>1: "\<And> n1. nfa.nfa_invar_NFA n1 \<Longrightarrow> 
          \<exists>D1. {(q, semI a, q')| q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa.nfa_\<alpha> n1) \<and>
               finite D1"
    and \<Delta>_\<A>2: "\<And> n2. nfa.nfa_invar_NFA n2 \<Longrightarrow> 
          \<exists>D2. {(q, semI a, q')| q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha> n2) \<and>
               finite D2"
    and \<Delta>_it_ok1: "\<And> q D1 n1. {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa_\<alpha> n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa_invar_NFA n1 \<Longrightarrow>
       set_iterator_genord (it_1_nfa (nfa.nfa_trans n1) q) {(a, q'). (q, a, q') \<in> D1}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok2: "\<And> q D2 n2 a. {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = 
       \<Delta> (nfa.nfa_\<alpha> n2) \<Longrightarrow>
       finite D2 \<Longrightarrow>
       nfa.nfa_invar_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_2_nfa (nfa.nfa_trans n2) q a) 
    {(a, q'). (q, a, q') \<in> D2}
        (\<lambda>_ _. True)"

     and sem_OK: "\<And> n1 n2 D1 D2. 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (nfa.nfa_\<alpha> n1) \<Longrightarrow>
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha> n2) \<Longrightarrow>
      nfa.nfa_invar_NFA n1 \<Longrightarrow> nfa.nfa_invar_NFA n2 \<Longrightarrow>
      \<forall>q a b aa ba q'.
     (q, ((a, b), aa, ba), q')
     \<in> {(q, a, q').
         (q, a, q')
         \<in> {((q1, q2), (a1, a2), q1', q2') |q1 a1 q1' q2 a2 q2'.
             (q1, a1, q1') \<in> D1 \<and> (q2, a2, q2') \<in> D2}} \<longrightarrow>
     a \<le> b \<and> aa \<le> ba"
    
shows "nfa_bool_comb_same nfa_dfa_\<alpha> nfa_dfa_invar 
       (bool_comb_gen_impl qm_ops it_1_nfa it_2_nfa)"
proof (intro nfa_bool_comb_same.intro 
             nfa_bool_comb.intro 
             automaton_by_lts_correct
             nfa_bool_comb_axioms.intro)
  fix a1 a2 bc
  assume invar_1: "nfa_dfa_invar a1"
     and invar_2: "nfa_dfa_invar a2"
    

  note const_nfa_OK = 
      nfa.NFA_construct_reachable_prod_impl_code_correct_no_enc [OF qm_ops_OK]

  note correct_nfa = nfa_bool_comb.bool_comb_correct_aux 
      [OF bool_comb_impl_aux_correct,
        where bc = bc, OF const_nfa_OK _ _ _ _ _ _ _ _ _ _ _ ]
  

  note it_1_nfa_OK' = lts_succ_label_it.lts_succ_label_it_correct [OF it_1_nfa_OK]
  note it_2_nfa_OK' = lts_succ_it.lts_succ_it_correct [OF it_2_nfa_OK]


  show "nfa_dfa_invar (bool_comb_gen_impl qm_ops it_1_nfa it_2_nfa bc a1 a2) \<and>
        NFA_isomorphic_wf
          (nfa_dfa_\<alpha> (bool_comb_gen_impl qm_ops it_1_nfa it_2_nfa  bc a1 a2))
          (efficient_bool_comb_NFA bc (nfa_dfa_\<alpha> a1) (nfa_dfa_\<alpha> a2))"
  proof -
    note correct_nfa' = correct_nfa [OF nfa.nfa_by_map_correct, 
        where ?n1.0 = a1]
    show ?thesis
    proof -
      note correct_nfa'' = correct_nfa' 
                    [OF nfa.nfa_by_map_correct, 
                      where ?n2.0 = a2
        ]
     thm sem_OK
      from invar_1 invar_2  
      show ?thesis 
        apply (simp add: nfa_dfa_invar_def  nfa_dfa_\<alpha>_def)
        apply (rule_tac correct_nfa'')
        apply (insert \<Delta>_\<A>1 \<Delta>_\<A>2 \<Delta>_it_ok1 \<Delta>_it_ok2 sem_OK)
        apply auto
        by (simp_all add: 
              nfa.nfa_trans_def 
              set_iterator_def nfa.nfa_\<alpha>_def
              s.correct nfa.nfa_invar_NFA_def 
              nfa.nfa_invar_def sem_OK)
        
qed
qed
qed

lemma bool_comb_impl_correct :
assumes qm_ops_OK: "StdMap qm_ops"
    and it_1_nfa_OK: "lts_succ_label_it d_nfa.\<alpha> d_nfa.invar it_1_nfa"
    and it_2_nfa_OK: "lts_succ_it d_nfa.\<alpha> d_nfa.invar it_2_nfa"
    and \<Delta>_\<A>1: "\<And> n1. nfa.nfa_invar_NFA n1 \<Longrightarrow> 
          \<exists>D1. {(q, semI a, q')| q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa.nfa_\<alpha> n1) \<and>
               finite D1"
    and \<Delta>_\<A>2: "\<And> n2. nfa.nfa_invar_NFA n2 \<Longrightarrow> 
          \<exists>D2. {(q, semI a, q')| q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha> n2) \<and>
               finite D2"
    and \<Delta>_it_ok1: "\<And> q D1 n1. {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa_\<alpha> n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa_invar_NFA n1 \<Longrightarrow>
       set_iterator_genord (it_1_nfa (nfa.nfa_trans n1) q) {(a, q'). (q, a, q') \<in> D1}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok2: "\<And> q D2 n2 a. {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = 
       \<Delta> (nfa.nfa_\<alpha> n2) \<Longrightarrow>
       finite D2 \<Longrightarrow>
       nfa.nfa_invar_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_2_nfa (nfa.nfa_trans n2) q a) 
    {(a, q'). (q, a, q') \<in> D2}
        (\<lambda>_ _. True)" and
    sem_OK: "\<And>n1 n2 D1 D2.
      {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa.nfa_\<alpha> n1) \<Longrightarrow>
      {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha> n2) \<Longrightarrow>
      nfa.nfa_invar_NFA n1 \<Longrightarrow>
      nfa.nfa_invar_NFA n2 \<Longrightarrow>
      \<forall>q a b aa ba q'.
         (q, ((a, b), aa, ba), q')
         \<in> {(q, a, q').
             (q, a, q')
             \<in> {((q1, q2), (a1, a2), q1', q2') |q1 a1 q1' q2 a2 q2'.
                 (q1, a1, q1') \<in> D1 \<and> (q2, a2, q2') \<in> D2}} \<longrightarrow>
         a \<le> b \<and> aa \<le> ba"
shows "nfa_bool_comb_same nfa_dfa_\<alpha> nfa_dfa_invar 
       (bool_comb_impl qm_ops it_1_nfa it_2_nfa)"
proof (intro nfa_bool_comb_same.intro 
             nfa_bool_comb.intro 
             nfa_bool_comb_axioms.intro
             automaton_by_lts_correct)
  fix a1 a2 bc
  assume invar_1: "nfa_dfa_invar a1"
     and invar_2: "nfa_dfa_invar a2"
    

  from bool_comb_gen_impl_correct [OF assms]
  have "nfa_bool_comb_same nfa_dfa_\<alpha> nfa_dfa_invar
       (bool_comb_gen_impl qm_ops it_1_nfa it_2_nfa)" by simp
  note gen_correct = nfa_bool_comb.bool_comb_correct_aux 
      [OF this[unfolded nfa_bool_comb_same_def],
    OF invar_1 invar_2, of bc]

  from gen_correct
  show "nfa_dfa_invar (bool_comb_impl qm_ops it_1_nfa it_2_nfa bc a1 a2) \<and>
        NFA_isomorphic_wf
        (nfa_dfa_\<alpha> (bool_comb_impl qm_ops it_1_nfa it_2_nfa bc a1 a2))
        (efficient_bool_comb_NFA bc (nfa_dfa_\<alpha> a1) (nfa_dfa_\<alpha> a2))"
    by (case_tac a1, simp_all)
qed


subsection \<open> concatenation implementation \<close>



fun nfa_concat_gen_impl where
    "nfa_concat_gen_impl qm_ops it_1_nfa it_2_nfa it_3_nfa
       A' =
        (concat_impl_aux 
        (s.inter)
        (\<lambda> x. \<not> (s.isEmpty x))
         (nfa.NFA_construct_reachable_interval_impl_code qm_ops) id 
          (\<lambda>A. it_1_nfa (nfa.nfa_trans A)) (\<lambda>A. it_2_nfa (nfa.nfa_trans A))
           (\<lambda>A B C. it_3_nfa (nfa.nfa_trans A) B C)
            (\<lambda>A. (s.to_list (nfa.nfa_initial A))) 
             (\<lambda>A. (s.to_list (nfa.nfa_initial A)))
              (\<lambda>A. ((nfa.nfa_initial A))) 
               (\<lambda>A. ((nfa.nfa_accepting A)))
                (\<lambda>A. (nfa.nfa_initial A))
                 (\<lambda>A. (nfa.nfa_accepting A)) 
                  (\<lambda>A q. s.memb q (nfa.nfa_accepting A)) A')"


schematic_goal nfa_concat_gen_impl_code :
  "nfa_concat_gen_impl qm_ops it_1_nfa it_2_nfa it_3_nfa
  (Q1, D1, I1, F1) (Q2, D2, I2, F2) = ?XXX1"
  unfolding nfa_concat_gen_impl.simps 
            concat_impl_aux_def tri_union_iterator_def
            nfa.nfa_selectors_def  snd_conv fst_conv
            nfa.NFA_construct_reachable_interval_impl_code_def 
 by (rule refl)+

fun nfa_concat_impl where
     "nfa_concat_impl qm_ops it_1_nfa it_2_nfa it_3_nfa =
      nfa_concat_gen_impl qm_ops it_1_nfa it_2_nfa it_3_nfa"

schematic_goal nfa_concat_impl_code :
  "nfa_concat_impl qm_ops it_1_nfa it_2_nfa it_3_nfa
     (Q1, D1, I1, F1) (Q2, D2, I2, F2) = ?XXX1"
 unfolding nfa_concat_impl.simps nfa_concat_gen_impl_code
           nfa.nfa_selectors_def snd_conv fst_conv
  by (rule refl)+




lemma nfa_concat_gen_impl_correct :
assumes qm_ops_OK: "StdMap qm_ops"
    and it_1_nfa_OK: "lts_succ_label_it d_nfa.\<alpha> d_nfa.invar it_1_nfa"
    and it_2_nfa_OK: "lts_succ_label_it d_nfa.\<alpha> d_nfa.invar it_2_nfa" 
    and it_3_nfa_OK: "lts_connect_it d_nfa.\<alpha> d_nfa.invar s.\<alpha> s.invar it_3_nfa"
    and \<Delta>_\<A>1: "\<And> n1. nfa.nfa_invar_NFA n1 \<Longrightarrow> 
          \<exists>D1. {(q, semI a, q')| q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa.nfa_\<alpha> n1) \<and>
               finite D1"
    and \<Delta>_\<A>2: "\<And> n2. nfa.nfa_invar_NFA n2 \<Longrightarrow> 
          \<exists>D2. {(q, semI a, q')| q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha> n2) \<and>
               finite D2"
    and \<Delta>_it_ok1: "\<And> q D1 n1. {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa_\<alpha> n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa_invar_NFA n1 \<Longrightarrow>
       set_iterator_genord (it_1_nfa (nfa.nfa_trans n1) q) {(a, q'). (q, a, q') \<in> D1}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok2: "\<And> q D2 n2. {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = 
       \<Delta> (nfa.nfa_\<alpha> n2) \<Longrightarrow>
       finite D2 \<Longrightarrow>
       nfa.nfa_invar_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_2_nfa (nfa.nfa_trans n2) q) 
    {(a, q'). (q, a, q') \<in> D2}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok3: "\<And> q D1 n1 n2. 
       {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa_\<alpha> n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa_invar_NFA n1 \<Longrightarrow>
       nfa.nfa_invar_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_3_nfa (nfa.nfa_trans n1) 
                                     (nfa.nfa_accepting n1)
                                     (nfa.nfa_initial n2)
                                      q)
       {(a, q'). \<exists> q''. (q, a, q'') \<in> D1 \<and> q'' \<in> (s.\<alpha> (nfa.nfa_accepting n1))
                                   \<and> q' \<in> (s.\<alpha> (nfa.nfa_initial n2))}
        (\<lambda>_ _. True)"
    and inj_12: "\<And> q n1 n2 D1 D2. 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (nfa.nfa_\<alpha> n1) \<and> finite D1 \<Longrightarrow> 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha> n2) \<and> finite D2 \<Longrightarrow>
      nfa.nfa_invar_NFA n1 \<Longrightarrow> nfa.nfa_invar_NFA n2 \<Longrightarrow>
     inj_on (\<lambda>(a, y). (semI a, y))
     {(a, q').
      (q, a, q')
      \<in> {(q, a, q').
          (q, a, q') \<in> D1 \<or>
          (q, a, q') \<in> D2 \<or>
          (q, a, q')
          \<in> {uu.
              \<exists>q a q' q''.
                 uu = (q, a, q') \<and>
                 (q, a, q'') \<in> D1 \<and> q'' \<in> (s.\<alpha> (nfa.nfa_accepting n1)) \<and> 
                  q' \<in> (s.\<alpha> (nfa.nfa_initial n2))}}}"
    and Q1Q2_empty: "\<And> n1 n2. nfa.nfa_invar_NFA n1 \<Longrightarrow> nfa.nfa_invar_NFA n2 \<Longrightarrow>
                               \<Q> (nfa.nfa_\<alpha> n1) \<inter> \<Q> (nfa.nfa_\<alpha> n2) = {}"
shows "nfa_concat_same nfa_dfa_\<alpha> nfa_dfa_invar 
       (nfa_concat_gen_impl qm_ops it_1_nfa it_2_nfa it_3_nfa)"
proof (intro nfa_concat_same.intro 
             nfa_concat.intro 
             automaton_by_lts_correct
             nfa_concat_axioms.intro)
  fix n1 n2
  assume invar_1: "nfa_dfa_invar n1"
     and invar_2: "nfa_dfa_invar n2"



  note const_nfa_OK = 
      nfa.NFA_construct_reachable_impl_code_correct_no_enc [OF qm_ops_OK]

  note correct_nfa = nfa_concat.nfa_concat_correct_aux 
      [OF concat_impl_aux_correct, OF const_nfa_OK]
 

  note it_1_nfa_OK' = lts_succ_label_it.lts_succ_label_it_correct [OF it_1_nfa_OK]
  note it_2_nfa_OK' = lts_succ_label_it.lts_succ_label_it_correct [OF it_2_nfa_OK]
  note it_3_nfa_OK' = lts_connect_it.lts_connect_it_correct [OF it_3_nfa_OK]



  show "nfa_dfa_invar (nfa_concat_gen_impl qm_ops it_1_nfa it_2_nfa it_3_nfa n1 n2) \<and>
       NFA_isomorphic_wf
        (nfa_dfa_\<alpha> (nfa_concat_gen_impl qm_ops it_1_nfa it_2_nfa it_3_nfa n1 n2))
        (efficient_NFA_concatenation (nfa_dfa_\<alpha> n1) (nfa_dfa_\<alpha> n2))"
  proof -
    note correct_nfa' = correct_nfa [OF nfa.nfa_by_map_correct, where ?n1.0 = n1]
    show ?thesis
    proof -
      note correct_nfa'' = correct_nfa' 
                    [OF nfa.nfa_by_map_correct, where ?n2.0 = n2]
      from invar_1 invar_2  
      show ?thesis 
        apply (simp add: nfa_dfa_invar_def  nfa_dfa_\<alpha>_def)
        apply (rule_tac correct_nfa'')
        defer defer
        apply (insert \<Delta>_\<A>1 \<Delta>_\<A>2 \<Delta>_it_ok1 \<Delta>_it_ok2 \<Delta>_it_ok3 Q1Q2_empty)  
        apply auto
        apply (simp_all add: 
              nfa.nfa_trans_def 
              set_iterator_def nfa.nfa_\<alpha>_def
              s.correct nfa.nfa_invar_NFA_def 
              nfa.nfa_invar_def )
         defer
      proof -
        {
          fix a aa ab b x
          assume p1: "s.\<alpha> ab \<inter> s.\<alpha> b = {}"
             and p2: "x \<in> s.\<alpha> ab" and
                 p3: "x \<in> s.\<alpha> b"
          from this have "s.\<alpha> ab \<inter> s.\<alpha> b \<noteq> {}"
            by auto
          from p1 this show "False"
            by blast
        }
        {
        fix q a aa ab b ac ad ae ba D1
        assume 
           p2: "{(q, semI (a, b), q') |q a b q'. (q, (a, b), q') \<in> D1} =
       nfa.interval_to_set ` d_nfa.\<alpha> aa" and
           p3: "finite D1" and
           p4: "s.invar a \<and>
       d_nfa.invar aa \<and>
       s.invar ab \<and>
       s.invar b \<and>
       NFA \<lparr>\<Q> = s.\<alpha> a, \<Delta> = nfa.interval_to_set ` d_nfa.\<alpha> aa, \<I> = s.\<alpha> ab, \<F> = s.\<alpha> b\<rparr>" and
        p5: "s.invar ac \<and>
       d_nfa.invar ad \<and>
       s.invar ae \<and>
       s.invar ba \<and>
       NFA \<lparr>\<Q> = s.\<alpha> ac, \<Delta> = nfa.interval_to_set ` d_nfa.\<alpha> ad, \<I> = s.\<alpha> ae,
              \<F> = s.\<alpha> ba\<rparr>" and
           p1: "(\<And>D1 a aa ab b ac ad ae ba q.
           {(q, semI (a, b), q') |q a b q'. (q, (a, b), q') \<in> D1} =
           nfa.interval_to_set ` d_nfa.\<alpha> aa \<Longrightarrow>
           finite D1 \<Longrightarrow>
           s.invar a \<and>
           d_nfa.invar aa \<and>
           s.invar ab \<and>
           s.invar b \<and>
           NFA \<lparr>\<Q> = s.\<alpha> a, \<Delta> = nfa.interval_to_set ` d_nfa.\<alpha> aa, \<I> = s.\<alpha> ab,
                  \<F> = s.\<alpha> b\<rparr> \<Longrightarrow>
           s.invar ac \<and>
           d_nfa.invar ad \<and>
           s.invar ae \<and>
           s.invar ba \<and>
           NFA \<lparr>\<Q> = s.\<alpha> ac, \<Delta> = nfa.interval_to_set ` d_nfa.\<alpha> ad, \<I> = s.\<alpha> ae,
                  \<F> = s.\<alpha> ba\<rparr> \<Longrightarrow>
           set_iterator_genord (it_3_nfa aa b ae q)
            {(a, q'). \<exists>q''. (q, a, q'') \<in> D1 \<and> q'' \<in> s.\<alpha> b \<and> q' \<in> s.\<alpha> ae}
            (\<lambda>_ _. True))"   
        from p1[OF p2 p3 p4 p5, of q] 
        have "set_iterator_genord (it_3_nfa aa b ae q)
            {(a, q'). \<exists>q''. (q, a, q'') \<in> D1 \<and> q'' \<in> s.\<alpha> b \<and> q' \<in> s.\<alpha> ae}
            (\<lambda>_ _. True)" by auto
        from this show "set_iterator_genord (it_3_nfa aa b ae q)
        {uu.
         \<exists>a ba q'' q'.
            uu = ((a, ba), q') \<and> (q, (a, ba), q'') \<in> D1 \<and> q'' \<in> s.\<alpha> b \<and> q' \<in> s.\<alpha> ae}
        (\<lambda>_ _. True)"
         apply (subgoal_tac "{uu.
         \<exists>a ba q'' q'.
            uu = ((a, ba), q') \<and> (q, (a, ba), q'') \<in> D1 \<and> q'' \<in> s.\<alpha> b \<and> q' \<in> s.\<alpha> ae} = 
          {(a, q'). \<exists>q''. (q, a, q'') \<in> D1 \<and> q'' \<in> s.\<alpha> b \<and> q' \<in> s.\<alpha> ae}")
           apply simp
          by fastforce
      }
      {
        fix a aa ab b ac ad ae ba q
        assume p1: "s.invar a \<and>
                    d_nfa.invar aa \<and>
                    s.invar ab \<and>
                    s.invar b \<and>
                    NFA \<lparr>\<Q> = s.\<alpha> a, \<Delta> = nfa.interval_to_set ` d_nfa.\<alpha> aa, \<I> = s.\<alpha> ab, \<F> = s.\<alpha> b\<rparr>"
           and p2: "s.invar ac \<and>
       d_nfa.invar ad \<and>
       s.invar ae \<and>
       s.invar ba \<and>
       NFA \<lparr>\<Q> = s.\<alpha> ac, \<Delta> = nfa.interval_to_set ` d_nfa.\<alpha> ad, \<I> = s.\<alpha> ae,
              \<F> = s.\<alpha> ba\<rparr>"
          and p3: "(\<And>a aa ab b ac ad ae ba.
           s.invar a \<and>
           d_nfa.invar aa \<and>
           s.invar ab \<and>
           s.invar b \<and>
           NFA \<lparr>\<Q> = s.\<alpha> a, \<Delta> = nfa.interval_to_set ` d_nfa.\<alpha> aa, \<I> = s.\<alpha> ab,
                  \<F> = s.\<alpha> b\<rparr> \<Longrightarrow>
           s.invar ac \<and>
           d_nfa.invar ad \<and>
           s.invar ae \<and>
           s.invar ba \<and>
           NFA \<lparr>\<Q> = s.\<alpha> ac, \<Delta> = nfa.interval_to_set ` d_nfa.\<alpha> ad, \<I> = s.\<alpha> ae,
                  \<F> = s.\<alpha> ba\<rparr> \<Longrightarrow>
           s.\<alpha> a \<inter> s.\<alpha> ac = {})"
           and p4: "q \<in> s.\<alpha> ba" 
           and p5: "q \<in> s.\<alpha> a"
        from p2 have con1: "s.\<alpha> ba \<subseteq> s.\<alpha> ac"  
          unfolding NFA_def
          by auto
        have "s.\<alpha> a \<inter> s.\<alpha> ac = {}"
          apply (rule p3)
          apply (insert p1 p2)
          by force+
        from this con1 have "s.\<alpha> a \<inter> s.\<alpha> ba = {}" by auto
        from this p5 have "q \<notin> s.\<alpha> ba" by auto
        from this p4 show False by auto 
      }
      { fix q a aa ab b ac ad ae ba D1 D2
        assume pc1: " s.invar a \<and>
           d_nfa.invar aa \<and>
           s.invar ab \<and>
           s.invar b \<and>
           NFA \<lparr>\<Q> = s.\<alpha> a, \<Delta> = nfa.interval_to_set ` d_nfa.\<alpha> aa, \<I> = s.\<alpha> ab,
                  \<F> = s.\<alpha> b\<rparr>" and
               pc2: "s.invar ac \<and>
           d_nfa.invar ad \<and>
           s.invar ae \<and>
           s.invar ba \<and>
           NFA \<lparr>\<Q> = s.\<alpha> ac, \<Delta> = nfa.interval_to_set ` d_nfa.\<alpha> ad, \<I> = s.\<alpha> ae,
                  \<F> = s.\<alpha> ba\<rparr>" and
           pc3: "{(q, semI (a, b), q') |q a b q'. (q, (a, b), q') \<in> D1} =
       nfa.interval_to_set ` d_nfa.\<alpha> aa" and
           pc4: "finite D1" and
           pc5: "{(q, semI (a, b), q') |q a b q'. (q, (a, b), q') \<in> D2} =
       nfa.interval_to_set ` d_nfa.\<alpha> ad" and
           pc6: "finite D2"
        from this obtain \<A>1 \<A>2 where 
        cp1: "\<A>2 =  \<lparr>\<Q> = s.\<alpha> ac, \<Delta> = nfa.interval_to_set ` d_nfa.\<alpha> ad, \<I> = s.\<alpha> ae,
                  \<F> = s.\<alpha> ba\<rparr>" and
        cp2: "\<A>1 = \<lparr>\<Q> = s.\<alpha> a, \<Delta> = nfa.interval_to_set ` d_nfa.\<alpha> aa, \<I> = s.\<alpha> ab,
                  \<F> = s.\<alpha> b\<rparr>" and
        cp3: "NFA \<A>1" and
        cp4: "NFA \<A>2"
          by auto
        from cp1 obtain n1' n2' where
        n2'_def: "n2' = (ac, ad, ae, ba)" and
        n1'_def: "n1' = (a, aa, ab, b)"
          by auto

        from n1'_def pc3 
        have "{(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa.nfa_\<alpha> n1')" 
          unfolding nfa.nfa_\<alpha>_def
          apply simp
          unfolding nfa.nfa_trans_def .
        from this pc4 have pre1: 
         "{(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa.nfa_\<alpha> n1') \<and> finite D1 "
          by simp

       from n2'_def pc5
        have "{(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha> n2')" 
          unfolding nfa.nfa_\<alpha>_def
          by simp
        from this pc6 have pre2: 
         "{(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha> n2') \<and> finite D2"
          by simp
        from n1'_def
        have pre3: "nfa.nfa_invar_NFA n1'"
          unfolding nfa.nfa_invar_NFA_def nfa.nfa_invar_def nfa.nfa_\<alpha>_def
          apply simp
          using pc1 by auto
        from n2'_def
        have pre4: "nfa.nfa_invar_NFA n2'"
          unfolding nfa.nfa_invar_NFA_def nfa.nfa_invar_def nfa.nfa_\<alpha>_def
          apply simp
          using pc2 by auto

        from inj_12[of D1 n1' D2 n2', OF pre1 pre2 pre3 pre4] n1'_def n2'_def
        show " inj_on (\<lambda>(a, y). (semI a, y))
        {(a, q').
         (q, a, q') \<in> D1 \<or>
         (q, a, q') \<in> D2 \<or>
         (\<exists>aa ba.
             a = (aa, ba) \<and>
             (\<exists>q''. (q, (aa, ba), q'') \<in> D1 \<and> q'' \<in> s.\<alpha> b \<and> q' \<in> s.\<alpha> ae))}"
          by auto
      }
         qed qed qed qed

lemma nfa_concat_impl_correct :
assumes qm_ops_OK: "StdMap qm_ops"
    and it_1_nfa_OK: "lts_succ_label_it d_nfa.\<alpha> d_nfa.invar it_1_nfa"
    and it_2_nfa_OK: "lts_succ_label_it d_nfa.\<alpha> d_nfa.invar it_2_nfa"
    and it_3_nfa_OK: "lts_connect_it d_nfa.\<alpha> d_nfa.invar s.\<alpha> s.invar it_3_nfa"
    and \<Delta>_\<A>1: "\<And> n1. nfa.nfa_invar_NFA n1 \<Longrightarrow> 
          \<exists>D1. {(q, semI a, q')| q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa.nfa_\<alpha> n1) \<and>
               finite D1"
    and \<Delta>_\<A>2: "\<And> n2. nfa.nfa_invar_NFA n2 \<Longrightarrow> 
          \<exists>D2. {(q, semI a, q')| q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha> n2) \<and>
               finite D2"
    and \<Delta>_it_ok1: "\<And> q D1 n1. {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa_\<alpha> n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa_invar_NFA n1 \<Longrightarrow>
       set_iterator_genord (it_1_nfa (nfa.nfa_trans n1) q) {(a, q'). (q, a, q') \<in> D1}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok2: "\<And> q D2 n2. {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = 
       \<Delta> (nfa.nfa_\<alpha> n2) \<Longrightarrow>
       finite D2 \<Longrightarrow>
       nfa.nfa_invar_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_2_nfa (nfa.nfa_trans n2) q) 
    {(a, q'). (q, a, q') \<in> D2}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok3: "\<And> q D1 n1 n2. 
       {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa.nfa_\<alpha> n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa.nfa_invar_NFA n1 \<Longrightarrow>
       nfa.nfa_invar_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_3_nfa (nfa.nfa_trans n1) 
                                     (nfa.nfa_accepting n1)
                                     (nfa.nfa_initial n2)
                                      q)
       {(a, q'). \<exists> q''. (q, a, q'') \<in> D1 \<and> q'' \<in> (s.\<alpha> (nfa.nfa_accepting n1))
                                   \<and> q' \<in> (s.\<alpha> (nfa.nfa_initial n2))}
        (\<lambda>_ _. True)"
    and inj_12: "\<And> q n1 n2 D1 D2. 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (nfa.nfa_\<alpha> n1) \<and> finite D1 \<Longrightarrow> 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (nfa.nfa_\<alpha> n2) \<and> finite D2 \<Longrightarrow>
      nfa.nfa_invar_NFA n1 \<Longrightarrow> nfa.nfa_invar_NFA n2 \<Longrightarrow>
     inj_on (\<lambda>(a, y). (semI a, y))
     {(a, q').
      (q, a, q')
      \<in> {(q, a, q').
          (q, a, q') \<in> D1 \<or>
          (q, a, q') \<in> D2 \<or>
          (q, a, q')
          \<in> {uu.
              \<exists>q a q' q''.
                 uu = (q, a, q') \<and>
                 (q, a, q'') \<in> D1 \<and> q'' \<in> (s.\<alpha> (nfa.nfa_accepting n1)) \<and> 
                  q' \<in> (s.\<alpha> (nfa.nfa_initial n2))}}}"
    and Q1Q2_empty: "\<And> n1 n2. nfa.nfa_invar_NFA n1 \<Longrightarrow> nfa.nfa_invar_NFA n2 \<Longrightarrow>
                               \<Q> (nfa.nfa_\<alpha> n1) \<inter> \<Q> (nfa.nfa_\<alpha> n2) = {}"
shows "nfa_concat_same nfa_dfa_\<alpha> nfa_dfa_invar 
       (nfa_concat_impl qm_ops it_1_nfa it_2_nfa it_3_nfa)"
proof (intro nfa_concat_same.intro 
             nfa_concat.intro 
             nfa_concat_axioms.intro
             automaton_by_lts_correct)
  fix n1 n2
  assume invar_1: "nfa_dfa_invar n1"
     and invar_2: "nfa_dfa_invar n2"
     and inter_emp: "\<Q> (nfa_dfa_\<alpha> n1) \<inter> \<Q> (nfa_dfa_\<alpha> n2) = {}"
    
  
  from nfa_concat_gen_impl_correct [OF assms]
  have "nfa_concat_same nfa_dfa_\<alpha> nfa_dfa_invar
       (nfa_concat_gen_impl qm_ops it_1_nfa it_2_nfa it_3_nfa)" by simp
  note gen_correct = nfa_concat.nfa_concat_correct_aux 
      [OF this[unfolded nfa_concat_same_def],
    OF invar_1 invar_2]
 from gen_correct inter_emp
  show "nfa_dfa_invar (nfa_concat_impl qm_ops it_1_nfa it_2_nfa it_3_nfa n1 n2) \<and>
       NFA_isomorphic_wf
        (nfa_dfa_\<alpha> (nfa_concat_impl qm_ops it_1_nfa it_2_nfa it_3_nfa n1 n2))
        (efficient_NFA_concatenation (nfa_dfa_\<alpha> n1) (nfa_dfa_\<alpha> n2))"
    by (case_tac n1, simp_all)
qed


term concat_rename_impl_aux

fun nfa_concat_rename_impl where
    "nfa_concat_rename_impl qm_ops it_1_nfa it_2_nfa it_3_nfa
      im1 im2 f1 f2 
        (A1::'q_set \<times> 'd_nfa \<times> 'q_set \<times> 'q_set) A2 =
        (concat_rename_impl_aux 
        (ss.inter)
        (\<lambda> x. \<not> (ss.isEmpty x))
         (nfa.NFA_construct_reachable_interval_impl_code qm_ops) id 
          (\<lambda>A. it_1_nfa (nfa.nfa_transp A)) 
          (\<lambda>A. it_2_nfa (nfa.nfa_transp A))
           (\<lambda>A B C. it_3_nfa (nfa.nfa_transp A) B C)
            (\<lambda>A. (ss.to_list (nfa.nfa_initialp A))) 
             (\<lambda>A. (ss.to_list (nfa.nfa_initialp A)))
              (\<lambda>A. ((nfa.nfa_initialp A))) 
               (\<lambda>A. ((nfa.nfa_acceptingp A)))
                (\<lambda>A. (nfa.nfa_initialp A))
                 (\<lambda>A. (nfa.nfa_acceptingp A)) 
                  (\<lambda>A q. ss.memb q (nfa.nfa_acceptingp A))
                   (rename_states_impl im1 im2)
                   (rename_states_impl im1 im2)
                    f1 f2 A1 A2 
                     )"

schematic_goal nfa_concat_impl_rename_code:
  "nfa_concat_rename_impl qm_ops it_1_nfa it_2_nfa it_3_nfa
   im1 im2 f1 f2 (Q1, D1, I1, F1) (Q2, D2, I2, F2) = ?XXX1"
  unfolding nfa_concat_rename_impl.simps 
            concat_impl_aux_def tri_union_iterator_def
            nfa.nfa_selectors_def  snd_conv fst_conv
  unfolding rename_states_impl.simps
            nfa.rename_states_gen_impl.simps 
            nfa.NFA_construct_reachable_interval_impl_code_def 
 by (rule refl)+

fun interval_to_set  where
    "interval_to_set (q, s, q') = (q, semI s, q')"

definition nfa_\<alpha>p :: "'qq_set \<times> 'dd_nfa \<times> 'qq_set \<times> 'qq_set \<Rightarrow> ('q\<times>'q, 'a) NFA_rec" 
  where
  "nfa_\<alpha>p A =
   \<lparr> \<Q> = ss.\<alpha> (nfa.nfa_statep A), 
     \<Delta> = interval_to_set ` (dd_nfa.\<alpha> (nfa.nfa_transp A)),
     \<I> = ss.\<alpha> (nfa.nfa_initialp A), 
     \<F> = ss.\<alpha> (nfa.nfa_acceptingp A) \<rparr>"

definition nfa_invarp :: "'qq_set \<times> 'dd_nfa \<times> 'qq_set \<times> 'qq_set \<Rightarrow> bool" where
  "nfa_invarp A =
   (ss.invar (nfa.nfa_statep A) \<and>
    dd_nfa.invar (nfa.nfa_transp A) \<and>
    ss.invar (nfa.nfa_initialp A) \<and> 
    ss.invar (nfa.nfa_acceptingp A) \<and> NFA (nfa_\<alpha>p A))"

definition nfa_invarp_NFA where
  "nfa_invarp_NFA A = 
   (nfa_invarp A \<and> NFA (nfa_\<alpha>p A))"

thm nfa.nfa_by_map_correct

lemma nfa_by_map_correct [simp]:
    "nfa nfa_\<alpha>p nfa_invarp_NFA"
  unfolding nfa_def nfa_\<alpha>p_def nfa_invarp_NFA_def
  by simp

lemma rename_states_impl_correct :
assumes wf_target: "nfa_dfa_by_lts_interval_defs s_ops ss_ops l_ops 
                                                   d_nfa_ops dd_nfa_ops"
assumes im_OK: "set_image s.\<alpha> s.invar (set_op_\<alpha> ss_ops) (set_op_invar ss_ops) im"
assumes im2_OK: "lts_image d_nfa.\<alpha> d_nfa.invar 
                 (clts_op_\<alpha> dd_nfa_ops) (clts_op_invar dd_nfa_ops) im2"
shows "nfa_rename_states nfa.nfa_\<alpha> nfa.nfa_invar_NFA
           (nfa_\<alpha>p)
           (nfa_invarp_NFA)
           (nfa.rename_states_gen_impl im im2)"
proof (intro nfa_rename_states.intro 
             nfa_rename_states_axioms.intro
             nfa_by_map_correct)
  {
    from nfa.nfa_by_map_correct
    show "nfa nfa.nfa_\<alpha> nfa.nfa_invar_NFA"
      by simp
  }
  fix n f
  assume invar: " nfa.nfa_invar_NFA n"
  obtain QL DL IL FL where n_eq[simp]: "n = (QL, DL, IL, FL)" 
        by (cases n, blast)


  interpret ss: StdSet ss_ops using wf_target 
        unfolding nfa_dfa_by_lts_interval_defs_def by simp
  interpret dd_nfa: StdLTS dd_nfa_ops elemI using wf_target 
        unfolding nfa_dfa_by_lts_interval_defs_def by simp

interpret im: set_image s.\<alpha> s.invar ss.\<alpha> ss.invar im by fact

interpret im2: lts_image d_nfa.\<alpha> d_nfa.invar dd_nfa.\<alpha> dd_nfa.invar im2 
    using im2_OK by auto

  from invar have invar_weak: "nfa.nfa_invar n" and wf: "NFA (nfa.nfa_\<alpha> n)"
    unfolding nfa.nfa_invar_NFA_def by simp_all

  
  from invar_weak wf
  have c1: "nfa_invarp (nfa.rename_states_gen_impl im im2 n f) \<and>
        nfa_\<alpha>p (nfa.rename_states_gen_impl im im2 n f) = 
         NFA_rename_states (nfa.nfa_\<alpha> n) f"
    apply (simp add: nfa.nfa_invar_def 
                     nfa.nfa_\<alpha>_def
                     nfa.nfa_selectors_def
                     ss.correct NFA_rename_states_def dd_nfa.correct_common
                     s.correct d_nfa.correct_common
                     im.image_correct im2.lts_image_correct 
                     nfa.rename_states_gen_impl.simps
                     nfa_invarp_def nfa_\<alpha>p_def
                     semI_def wf NFA_def prod.inject
                     interval_to_set.simps)
    apply (simp add: semI_def 
                          interval_to_set.simps)
    
    apply (simp add: image_iff)
    apply (simp add: set_eq_iff)    
    apply (auto)
    apply fastforce
    apply fastforce
     defer
  proof -
    {
    fix a b aa ab ba ad ae bb bc
    assume p1: "\<forall>x. (x \<in> aa) = (x \<in> semI (ae, bb))" and
           p2: "(ad, (ae, bb), bc) \<in> d_nfa.\<alpha> DL" 
    from p2 have c1: "interval_to_set 
       (f ad, (ae, bb), f bc)
       \<in> interval_to_set `
          (\<lambda>qaq. (f (fst qaq), fst (snd qaq), f (snd (snd qaq)))) ` d_nfa.\<alpha> DL"
      by force
    from p1 have "aa = semI (ae, bb)" by auto
    from this p1 have "interval_to_set 
       (f ad, (ae, bb), f bc) = (f ad, aa ,f bc)"
      by (simp add: automaton_by_lts_interval_syntax.interval_to_set.simps)
    from this c1 show "(f ad, aa, f bc)
       \<in> interval_to_set `
          (\<lambda>qaq. (f (fst qaq), fst (snd qaq), f (snd (snd qaq)))) ` d_nfa.\<alpha> DL"
      by auto
  }
  {
    fix a b ab ba ac bb ae bd af ag be bf
    assume p1: "(af, (ag, be), bf) \<in> d_nfa.\<alpha> DL"
    from this
    have "f af = f af \<and>
            (\<forall>x. (x \<in> semI (ag, be)) = (x \<in> semI (ag, be)) \<and>
                 (f bf = f bf \<and>
                       (\<exists>x\<in>d_nfa.\<alpha> DL. (af, semI (ag, be), bf) = 
             nfa.interval_to_set (af, (ag, be), bf))))"
      by auto
    from this p1
    show "\<exists>s1. f af = f s1 \<and>
            (\<exists>a. (\<forall>x. (x \<in> semI (ag, be)) = (x \<in> a)) \<and>
                 (\<exists>s2. f bf = f s2 \<and>
                       (\<exists>x\<in>d_nfa.\<alpha> DL. (s1, a, s2) = nfa.interval_to_set x)))"
      by blast
  }
qed
  from this wf show 
   "nfa_invarp_NFA (nfa.rename_states_gen_impl im im2 n f)"
    unfolding nfa_invarp_NFA_def 
    unfolding automaton_by_lts_interval_syntax.nfa_invar_NFA_def
    using NFA_rename_states___is_well_formed[OF wf, of f]
    by (simp_all add: NFA_remove_states___is_well_formed)
  from c1
  show "nfa_\<alpha>p (nfa.rename_states_gen_impl im im2 n f) =
           NFA_rename_states (nfa.nfa_\<alpha> n) f"
    by simp
qed

term ss.\<alpha>

lemma nfa_concat_rename_impl_correct :
  fixes f1 
  assumes qm_ops_OK: "StdMap qm_ops"
    and wf_target: "nfa_dfa_by_lts_interval_defs s_ops ss_ops l_ops d_nfa_ops dd_nfa_ops"
    and im_OK: "set_image s.\<alpha> s.invar (set_op_\<alpha> ss_ops) (set_op_invar ss_ops) im1"
    and im2_OK: "lts_image d_nfa.\<alpha> d_nfa.invar 
                 (clts_op_\<alpha> dd_nfa_ops) (clts_op_invar dd_nfa_ops) im2"
    and      inj_f1: "inj f1"
    and      inj_f2: "inj f2"
    and it_1_nfa_OK: "lts_succ_label_it dd_nfa.\<alpha> dd_nfa.invar it_1_nfa"
    and it_2_nfa_OK: "lts_succ_label_it dd_nfa.\<alpha> dd_nfa.invar it_2_nfa"
    and it_3_nfa_OK: "lts_connect_it dd_nfa.\<alpha> dd_nfa.invar ss.\<alpha> ss.invar it_3_nfa"
    and \<Delta>_\<A>1: "\<And> n1. nfa_invarp_NFA n1 \<Longrightarrow> 
          \<exists>D1. {(q, semI a, q')| q a q'. (q, a, q') \<in> D1} = 
                \<Delta> (nfa_\<alpha>p n1) \<and>
               finite D1"
    and \<Delta>_\<A>2: "\<And> n2. nfa_invarp_NFA n2 \<Longrightarrow> 
          \<exists>D2. {(q, semI a, q')| q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa_\<alpha>p n2) \<and>
               finite D2"
    and \<Delta>_it_ok1: "\<And> q D1 n1. {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa_\<alpha>p n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa_invarp_NFA n1 \<Longrightarrow>
       set_iterator_genord (it_1_nfa (nfa.nfa_transp 
                    n1) q) {(a, q')| a q'. 
          (q, a, q') \<in> D1}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok2: "\<And> q D2 n2. {(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = 
       \<Delta> (nfa_\<alpha>p n2) \<Longrightarrow>
       finite D2 \<Longrightarrow>
       nfa_invarp_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_2_nfa (nfa.nfa_transp 
              n2) q) 
    {(a, q')| a q'. (q, a, q') \<in> D2}
        (\<lambda>_ _. True)"
    and \<Delta>_it_ok3: "\<And> q D1 n1 n2. 
       {(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = 
       \<Delta> (nfa_\<alpha>p n1) \<Longrightarrow>
       finite D1 \<Longrightarrow>
       nfa_invarp_NFA n1 \<Longrightarrow>
       nfa_invarp_NFA n2 \<Longrightarrow>
       set_iterator_genord (it_3_nfa (nfa.nfa_transp n1) 
                                     (nfa.nfa_acceptingp n1)
                                     (nfa.nfa_initialp n2)
                                      q)
       {(a, q')| a q' q''. (q, a, q'') \<in> D1 \<and> q'' \<in> (ss.\<alpha> (nfa.nfa_acceptingp n1))
                                   \<and> q' \<in> (ss.\<alpha> (nfa.nfa_initialp n2))}
        (\<lambda>_ _. True)"
    and inj_12: "\<And> q n1 n2 D1 D2. 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D1} = \<Delta> (nfa_\<alpha>p n1) \<and> finite D1 \<Longrightarrow> 
      {(q, semI a, q')| q a q'. (q,a,q') \<in> D2} = \<Delta> (nfa_\<alpha>p n2) \<and> finite D2 \<Longrightarrow>
      nfa_invarp_NFA n1 \<Longrightarrow> nfa_invarp_NFA n2 \<Longrightarrow>
      inj_on (\<lambda>(a, y). (semI a, y))
      {(a, q').
       (q, a, q')
        \<in> {(q, a, q').
          (q, a, q') \<in> D1 \<or>
          (q, a, q') \<in> D2 \<or>
          (q, a, q')
            \<in> {uu.
              \<exists>q a q' q''.
                 uu = (q, a, q') \<and>
                 (q, a, q'') \<in> D1 \<and> q'' \<in> \<F> (nfa_\<alpha>p n1) \<and> q' \<in> \<I> (nfa_\<alpha>p n2)}}}"
    and Q1Q2_empty: "\<And> n1 n2.
                       f1 ` \<Q> (nfa.nfa_\<alpha> n1) \<inter> f2 ` \<Q> (nfa.nfa_\<alpha> n2) = {}"
shows "nfa_concat_rename_same f1 f2 nfa_dfa_\<alpha> nfa_dfa_invar 
       (nfa_concat_rename_impl qm_ops it_1_nfa it_2_nfa it_3_nfa im1 im2)"

proof (intro nfa_concat_rename_same.intro 
             nfa_concat_rename.intro 
             automaton_by_lts_correct
             nfa_concat_rename_axioms.intro)
  fix n1 n2
  assume invar_1: "nfa_dfa_invar n1"
     and invar_2: "nfa_dfa_invar n2"
     and   inj_1: "inj_on f1 (\<Q> (nfa_dfa_\<alpha> n1))"
     and   inj_2: "inj_on f2 (\<Q> (nfa_dfa_\<alpha> n2))"
     and   empty: "f1 ` \<Q> (nfa_dfa_\<alpha> n1) \<inter> f2 ` \<Q> (nfa_dfa_\<alpha> n2) = {}"

  note const_nfa_OK = 
      nfa.NFA_construct_reachable_impl_code_correct_no_enc [OF qm_ops_OK]

  note correct_nfa = nfa_concat_rename.nfa_rename_concat_correct_aux 
      [OF concat_rename_impl_aux_correct, OF const_nfa_OK]

  thm concat_rename_impl_aux_correct

  note it_1_nfa_OK' = lts_succ_label_it.lts_succ_label_it_correct [OF it_1_nfa_OK]
  note it_2_nfa_OK' = lts_succ_label_it.lts_succ_label_it_correct [OF it_2_nfa_OK]
  note it_3_nfa_OK' = lts_connect_it.lts_connect_it_correct [OF it_3_nfa_OK]

  from rename_states_impl_correct[OF wf_target im_OK im2_OK] 
       
  have c0: "nfa_rename_states nfa.nfa_\<alpha> nfa.nfa_invar_NFA nfa_\<alpha>p nfa_invarp_NFA
   (nfa.rename_states_gen_impl im1 im2)"
    by simp
  from this
  have c1: "(\<And> n f. nfa.nfa_invar_NFA n \<longrightarrow>
         nfa_invarp_NFA (nfa.rename_states_gen_impl im1 im2 n f)) "
    unfolding nfa_rename_states_def 
              nfa_rename_states_axioms_def
    by blast

  from c0 have c2: "(\<And>n f. nfa.nfa_invar_NFA n \<longrightarrow>
         nfa_\<alpha>p (nfa.rename_states_gen_impl im1 im2 n f) =
         NFA_rename_states (nfa.nfa_\<alpha> n) f)"
    unfolding nfa_rename_states_def 
              nfa_rename_states_axioms_def
    by blast
  from c1 c2
  have c3: "\<And> n f. nfa.nfa_invar_NFA n \<longrightarrow> 
         nfa_invarp_NFA (nfa.rename_states_gen_impl im1 im2 n f) \<and>
         nfa_\<alpha>p (nfa.rename_states_gen_impl im1 im2 n f) =
         NFA_rename_states (nfa.nfa_\<alpha> n) f"
    by simp

  from c3[of n1 f1]
      NFA_rename_states_def[of "nfa.nfa_\<alpha> n1" f1] nfa.nfa_\<alpha>_def
  have c4: "\<And> n1. nfa.nfa_invar_NFA n1 \<longrightarrow>
            \<Q> (NFA_rename_states (nfa.nfa_\<alpha> n1) f1) = f1 ` \<Q> (nfa.nfa_\<alpha> n1)"
    by simp

  from this c3 invar_1 
  have c4: "\<And> n1. nfa.nfa_invar_NFA n1 \<longrightarrow> 
            \<Q> (nfa_\<alpha>p (nfa.rename_states_gen_impl im1 im2 n1 f1)) 
            = f1 ` \<Q> (nfa.nfa_\<alpha> n1)" by auto

  from Q1Q2_empty c3[of n2 f2]
      NFA_rename_states_def[of "nfa.nfa_\<alpha> n2" f2] nfa.nfa_\<alpha>_def
  have c5: "\<And> n2. nfa.nfa_invar_NFA n2 \<longrightarrow>
            \<Q> (NFA_rename_states (nfa.nfa_\<alpha> n2) f2) = f2 ` \<Q> (nfa.nfa_\<alpha> n2)"
    by simp
  from this c3 invar_2 nfa_dfa_invar_def
  have c5: "\<And> n2. nfa.nfa_invar_NFA n2 \<longrightarrow>
        \<Q> (nfa_\<alpha>p (nfa.rename_states_gen_impl im1 im2 n2 f2)) 
        = f2 ` \<Q> (nfa.nfa_\<alpha> n2)" by simp


  show "nfa_dfa_invar
        (nfa_concat_rename_impl qm_ops it_1_nfa it_2_nfa it_3_nfa im1 im2 f1 f2 n1 n2) \<and>
       NFA_isomorphic_wf
        (nfa_dfa_\<alpha>
          (nfa_concat_rename_impl qm_ops it_1_nfa it_2_nfa it_3_nfa im1 im2 f1 f2 n1
            n2))
        (efficient_NFA_rename_concatenation f1 f2 (nfa_dfa_\<alpha> n1) (nfa_dfa_\<alpha> n2))"
  proof -
    note correct_nfa' = correct_nfa [OF nfa.nfa_by_map_correct, where ?n1.0 = n1]
    show ?thesis
    proof -
      note correct_nfa'' = correct_nfa' 
                    [OF nfa.nfa_by_map_correct, 
                      where ?n2.0 = n2,
                      where ?rename1.1 = "nfa.rename_states_gen_impl im1 im2",
                      where ?rename2.1 = "nfa.rename_states_gen_impl im1 im2",
                      where ?invar1.1 = "nfa_invarp_NFA",
                      where ?invar2.1 = "nfa_invarp_NFA",
                      where ?f1.0 = f1,
                      where ?f2.0 = f2,
                      where ?\<alpha>1.1 = "nfa_\<alpha>p",
                      where ?\<alpha>2.1 = "nfa_\<alpha>p"
                      
                      ]
      from invar_1 invar_2  
      show ?thesis 
        apply (simp add: nfa_dfa_invar_def  nfa_dfa_\<alpha>_def)
        apply (rule_tac correct_nfa'')
        defer defer
        using Q1Q2_empty c4 c5
                  
        apply (simp_all add: 
              nfa.nfa_transp_def 
              set_iterator_def (*nfa.nfa_\<alpha>_def*)
              s.correct nfa.nfa_invar_NFA_def 
              nfa.nfa_invar_def c3 ss.correct)
        using nfa_invarp_NFA_def ss.correct
              nfa_\<alpha>p_def nfa_invarp_def
                     apply auto[4]
        defer
        using \<Delta>_\<A>1 \<Delta>_\<A>1 apply auto[2]     
        defer defer defer defer
        using inj_f1 
        using inj_1 nfa_dfa_\<alpha>_def apply auto[1]

        using inj_f2
        using inj_2 nfa_dfa_\<alpha>_def apply auto[1]
      proof -
        {
          fix n1a n2a q
          assume p1: "nfa_invarp_NFA n1a"
             and p2: "q \<in> \<Q> (nfa_\<alpha>p n1a)"
             and p3: "nfa_invarp_NFA n2a"
             and p4: "\<Q> (nfa_\<alpha>p n1a) \<inter> \<Q> (nfa_\<alpha>p n2a) = {}"
             and p5: "(\<And>n1 n2. f1 ` \<Q> (nfa.nfa_\<alpha> n1) \<inter> f2 ` \<Q> (nfa.nfa_\<alpha> n2) = {})"

          from p3 nfa_invarp_NFA_def nfa_invarp_def
               NFA_def[of "nfa_\<alpha>p n2a"]
          have cc1: "\<F> (nfa_\<alpha>p n2a) \<subseteq> \<Q> (nfa_\<alpha>p n2a)"
            by simp
          from nfa_\<alpha>p_def[of n2a]  
          have  cc2: "\<F> (nfa_\<alpha>p n2a) = ss.\<alpha> (nfa.nfa_acceptingp n2a)"
            by simp

          from p1 nfa_invarp_NFA_def nfa_invarp_def
               NFA_def[of "nfa_\<alpha>p n1a"]
          have "\<F> (nfa_\<alpha>p n1a) \<subseteq> \<Q> (nfa_\<alpha>p n1a)"
            by simp
          from nfa_\<alpha>p_def[of n1a]  
          have "\<F> (nfa_\<alpha>p n1a) = ss.\<alpha> (nfa.nfa_acceptingp n1a)"
            by simp
          from p2 p4
          have "q \<notin> \<Q> (nfa_\<alpha>p n2a)"
            by auto

          from this cc1
          have cp1: "q \<notin> \<F> (nfa_\<alpha>p n2a)"
            by auto
          from p3 nfa_invarp_NFA_def nfa_invarp_def
          have "ss.invar (nfa.nfa_acceptingp n2a)"
            by simp
          from cp1 this cc2 ss.correct(5)[of "nfa.nfa_acceptingp n2a" q]
          show "\<not> ss.memb q (nfa.nfa_acceptingp n2a)"
            by simp
        }   
        {
          fix q n1a D1
          assume pb1: "{((a, b), semI (aa, ba), ab, bb) |a b aa ba ab bb.
                        ((a, b), (aa, ba), ab, bb) \<in> D1} = \<Delta> (nfa_\<alpha>p n1a)"
             and pb2: "finite D1 "
             and pb3: "nfa_invarp_NFA n1a"
             and pb4: "(\<And>n1 n2. f1 ` \<Q> (nfa.nfa_\<alpha> n1) \<inter> f2 ` \<Q> (nfa.nfa_\<alpha> n2) = {})"

          from pb1 
          have pb1': "{(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa_\<alpha>p n1a)"
            by force

          have "{(a, q') |a q'. (q, a, q') \<in> D1} = {(a, q'). (q, a, q') \<in> D1}"
            by blast

          from this \<Delta>_it_ok1[OF pb1' pb2 pb3, of q] nfa.nfa_transp_def[of n1a]
          show "set_iterator_genord (it_1_nfa (fst (snd n1a)) q) {(a, q'). (q, a, q') \<in> D1}
               (\<lambda>_ _. True)"
            by auto
        }
  {
          fix q n2a D2
          assume pb1: "{((a, b), semI (aa, ba), ab, bb) |a b aa ba ab bb.
                        ((a, b), (aa, ba), ab, bb) \<in> D2} = \<Delta> (nfa_\<alpha>p n2a)"
             and pb2: "finite D2"
             and pb3: "nfa_invarp_NFA n2a"
             and pb4: "(\<And>n1 n2. f1 ` \<Q> (nfa.nfa_\<alpha> n1) \<inter> f2 ` \<Q> (nfa.nfa_\<alpha> n2) = {})"

          from pb1 
          have pb1': "{(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa_\<alpha>p n2a)"
            by force

          have "{(a, q') |a q'. (q, a, q') \<in> D2} = {(a, q'). (q, a, q') \<in> D2}"
            by blast

          from this \<Delta>_it_ok2[OF pb1' pb2 pb3, of q] nfa.nfa_transp_def[of n2a]
          show "set_iterator_genord (it_2_nfa (fst (snd n2a)) q) 
                {(a, q'). (q, a, q') \<in> D2}
               (\<lambda>_ _. True)"
            by auto
        }
        {
          fix q n1a n2a D1
          
          assume pb1: "{((a, b), semI (aa, ba), ab, bb) |a b aa ba ab bb.
                        ((a, b), (aa, ba), ab, bb) \<in> D1} = \<Delta> (nfa_\<alpha>p n1a)"
             and pb2: "finite D1 "
             and pb3: "nfa_invarp_NFA n1a"
             and pb4: "(\<And>n1 n2. f1 ` \<Q> (nfa.nfa_\<alpha> n1) \<inter> f2 ` \<Q> (nfa.nfa_\<alpha> n2) = {})"
             and pb5: "nfa_invarp_NFA n2a"
             
          from pb1 
          have pb1': "{(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa_\<alpha>p n1a)"
            by force

          from nfa_\<alpha>p_def[of n1a]
          have cc1: "ss.\<alpha> (nfa.nfa_acceptingp n1a) = \<F> (nfa_\<alpha>p n1a)"
            by simp

          from nfa_\<alpha>p_def[of n2a]
          have cc2: "ss.\<alpha> (nfa.nfa_initialp n2a) = \<I> (nfa_\<alpha>p n2a)"
            by simp
          from cc1 cc2
          have "{uu. \<exists>a q' q''.
                     uu = (a, q') \<and>
                     (q, a, q'') \<in> D1 \<and>
                      q'' \<in> ss.\<alpha> (nfa.nfa_acceptingp n1a) \<and> 
                      q' \<in> ss.\<alpha> (nfa.nfa_initialp n2a)} = 
                {uu.
         \<exists>a b aa ba ab bb.
            uu = ((a, b), ab, bb) \<and>
            (q, (a, b), aa, ba) \<in> D1 \<and>
            (aa, ba) \<in> \<F> (nfa_\<alpha>p n1a) \<and> (ab, bb) \<in> \<I> (nfa_\<alpha>p n2a)}"
            by force

          from this \<Delta>_it_ok3[OF pb1' pb2 pb3 pb5, of q] nfa.nfa_transp_def[of n1a]
          show "set_iterator_genord
        (it_3_nfa (fst (snd n1a)) (nfa.nfa_acceptingp n1a) (nfa.nfa_initialp n2a) q)
        {uu.
         \<exists>a b aa ba ab bb.
            uu = ((a, b), ab, bb) \<and>
            (q, (a, b), aa, ba) \<in> D1 \<and>
            (aa, ba) \<in> \<F> (nfa_\<alpha>p n1a) \<and> (ab, bb) \<in> \<I> (nfa_\<alpha>p n2a)}
        (\<lambda>_ _. True)"
            by auto
        }
      { fix q n1a n2a D1 D2
        assume pc1: "{((a, b), semI (aa, ba), ab, bb) |a b aa ba ab bb.
        ((a, b), (aa, ba), ab, bb) \<in> D1} =
       \<Delta> (nfa_\<alpha>p n1a) \<and>
       finite D1" and
          pc2: "{((a, b), semI (aa, ba), ab, bb) |a b aa ba ab bb.
        ((a, b), (aa, ba), ab, bb) \<in> D2} =
       \<Delta> (nfa_\<alpha>p n2a) \<and>
       finite D2" and
          pc3: "nfa_invarp_NFA n1a" and
           pc4: "nfa_invarp_NFA n2a" and
         pc5: "(\<And>n1 n2. f1 ` \<Q> (nfa.nfa_\<alpha> n1) \<inter> f2 ` \<Q> (nfa.nfa_\<alpha> n2) = {})"

        from pc1 have 
        w1: "{(q, semI a, q') |q a q'. (q, a, q') \<in> D1} = \<Delta> (nfa_\<alpha>p n1a) \<and> finite D1" 
          by simp
        from pc2 have 
        w2: "{(q, semI a, q') |q a q'. (q, a, q') \<in> D2} = \<Delta> (nfa_\<alpha>p n2a) \<and> finite D2" 
          by simp

        from inj_12[OF w1 w2 pc3 pc4, of q]
        show "inj_on (\<lambda>(a, y). (semI a, y))
        {(a, q').
         (q, a, q') \<in> D1 \<or>
         (q, a, q') \<in> D2 \<or>
         (\<exists>aa b.
             q = (aa, b) \<and>
             (\<exists>ab ba.
                 a = (ab, ba) \<and>
                 (\<exists>a bb.
                     q' = (a, bb) \<and>
                     (\<exists>ac bc.
                         ((aa, b), (ab, ba), ac, bc) \<in> D1 \<and>
                         (ac, bc) \<in> \<F> (nfa_\<alpha>p n1a) \<and> (a, bb) \<in> \<I> (nfa_\<alpha>p n2a)))))}"
          by fastforce          
      }
         qed qed qed qed

end


context nfa_dfa_by_lts_interval_defs
begin

definition nfa_construct_interval where
    "nfa_construct_interval AA = (nfa.nfa_construct_interval AA)"



schematic_goal nfa_construct_interval_code :
     "nfa_construct_interval (QL, DL, IL, FL) = ?code_nfa"
  unfolding nfa_construct_interval_def nfa.nfa_construct_interval.simps 
              nfa.nfa_construct_interval_aux_def split
    by (rule refl)+

lemma nfa_construct_interval_correct :
    "nfa_from_list_interval nfa_dfa_\<alpha> nfa_dfa_invar nfa_construct_interval"
    using nfa.nfa_construct_interval_correct
    apply (simp add: nfa_from_list_interval_def 
                  automaton_by_lts_correct 
                  nfa_from_list_axioms_def
                  nfa_construct_interval_def)
    apply (unfold nfa_construct_interval_def nfa_dfa_invar_def nfa_dfa_\<alpha>_def)
    by auto

definition nfa_construct_reachable_interval where
   "nfa_construct_reachable_interval qm_ops f I FP D_it =
    nfa.NFA_construct_reachable_interval_impl_code qm_ops f I FP D_it"


schematic_goal nfa_construct_reachable_interval_code :
  "nfa_construct_reachable_interval qm_ops f I FP D_it = ?code"
unfolding nfa_construct_reachable_interval_def
          nfa.NFA_construct_reachable_interval_impl_code_def
  by (rule refl)


lemma nfa_construct_reachable_interval_correct :
  assumes qm_OK: "StdMap qm_ops"
  shows "NFASpec.nfa_construct nfa_dfa_\<alpha> 
          nfa_dfa_invar  q2_\<alpha> 
          q2_invar (nfa_construct_reachable_interval qm_ops)"
  using nfa.NFA_construct_reachable_impl_code_correct [OF qm_OK]
  by (simp add: NFASpec.nfa_construct_def 
                nfa_construct_axioms_def 
                nfa_construct_reachable_interval_def
                automaton_by_lts_correct nfa_dfa_invar_def nfa_dfa_\<alpha>_def)

definition nfa_construct_reachable_prod_interval where
   "nfa_construct_reachable_prod_interval qm_ops f I FP D_it =
    nfa.NFA_construct_reachable_prod_interval_impl_code qm_ops f I FP D_it"


schematic_goal nfa_construct_reachable_prod_interval_code :
  "nfa_construct_reachable_prod_interval qm_ops f I FP D_it = ?code"
unfolding nfa_construct_reachable_prod_interval_def
          nfa.NFA_construct_reachable_interval_impl_code_def
  by (rule refl)


lemma nfa_construct_reachable_prod_interval_correct :
  assumes qm_OK: "StdMap qm_ops"
  shows "NFASpec.nfa_construct_prod nfa_dfa_\<alpha> 
          nfa_dfa_invar  q2_\<alpha> 
          q2_invar (nfa_construct_reachable_prod_interval qm_ops)"
  using nfa.NFA_construct_reachable_prod_impl_code_correct [OF qm_OK]
  apply (simp add: NFASpec.nfa_construct_prod_def 
                nfa_construct_axioms_def 
                nfa_construct_reachable_interval_def
                automaton_by_lts_correct)
  unfolding nfa_construct_reachable_prod_interval_def
            nfa_dfa_invar_def nfa_dfa_\<alpha>_def
  by auto

definition nfa_destruct where
     "nfa_destruct AA = nfa.nfa_destruct AA"

thm nfa.nfa_destruct.simps
schematic_goal nfa_destruct_code :
  "nfa_destruct (Q, D, I, F) = ?code"
  unfolding nfa_destruct_def 
  unfolding  nfa.nfa_destruct.simps
  by (rule refl)+




end

end





