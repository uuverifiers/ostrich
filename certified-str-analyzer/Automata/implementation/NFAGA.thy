theory NFAGA
imports NFASpec
begin

subsection \<open> Construct with functions \<close>




subsection{* Brzozowski *}

definition Brzozowski_impl :: "('nfa \<Rightarrow> 'nfa) \<Rightarrow> ('nfa \<Rightarrow> 'nfa) \<Rightarrow> 'nfa \<Rightarrow> 'nfa" where
  "Brzozowski_impl r d A = d (r (d (r A)))"

lemma Brzozowski_impl_correct :
assumes r_OK: "nfa_reverse \<alpha> invar \<alpha> invar r"
    and d_OK: "nfa_determinise \<alpha> invar \<alpha> invar d"
shows "nfa_minimise \<alpha> invar \<alpha> invar (Brzozowski_impl r d)"
unfolding Brzozowski_impl_def
proof (intro nfa_minimise.intro nfa_minimise_axioms.intro conjI)
  from r_OK show nfa_OK: "nfa \<alpha> invar" and "nfa \<alpha> invar" unfolding nfa_reverse_def by simp_all

  note nfa_correct = nfa.nfa_is_wellformed [OF nfa_OK]
  note r_correct = nfa_reverse.reverse_correct___isomorphic [OF r_OK]
  note d_correct = nfa_determinise.determinise_correct___isomorphic [OF d_OK]

  fix n
  assume invar_n: "invar n"
  hence wf_n: "NFA (\<alpha> n)" by (simp add: nfa_correct)

  show "invar (d (r (d (r n))))"
    by (intro d_correct(1) r_correct(1) invar_n)

  have "NFA_isomorphic_wf (\<alpha> (d (r (d (r n))))) (Brzozowski (\<alpha> n))"
    unfolding Brzozowski_def Brzozowski_halfway_def
    by (intro d_correct r_correct invar_n NFA_isomorphic_wf_refl wf_n)
  with Brzozowski___minimise[OF wf_n]
  show "NFA_isomorphic_wf (\<alpha> (d (r (d (r n))))) (NFA_minimise (\<alpha> n))"
    by (metis NFA_isomorphic_wf_trans)
qed



subsection{* Minimisation combined with determinisation *}

lemma NFAGA_minimisation_with_determinisation :
fixes \<alpha>1::"'nfa1 \<Rightarrow> ('q1::{NFA_states}, 'a) NFA_rec"
  and \<alpha>2::"'nfa2 \<Rightarrow> ('q2::{NFA_states}, 'a) NFA_rec"
  and \<alpha>3::"'nfa3 \<Rightarrow> ('q3, 'a) NFA_rec"
assumes d_OK: "nfa_determinise \<alpha>1 invar1 \<alpha>2 invar2 d"
    and m_OK: "dfa_minimise \<alpha>2 invar2 \<alpha>3 invar3 m"
shows "nfa_minimise \<alpha>1 invar1 \<alpha>3 invar3 (m \<circ> d)"
proof (intro nfa_minimise.intro nfa_minimise_axioms.intro conjI)
  from d_OK show nfa1_OK: "nfa \<alpha>1 invar1" unfolding nfa_determinise_def by simp
  from m_OK show "nfa \<alpha>3 invar3" unfolding dfa_minimise_def by simp

  fix a
  assume invar_a: "invar1 a"

  from nfa1_OK invar_a have NFA_a: "NFA (\<alpha>1 a)" unfolding nfa_def by simp

  let ?da = "NFA_determinise (\<alpha>1 a)"

  from nfa_determinise.determinise_correct___same [OF d_OK, OF invar_a]
  have invar_da: "invar2 (d a)" and
       iso_da: "NFA_isomorphic_wf (\<alpha>2 (d a)) ?da"
    by (simp_all add: NFA_isomorphic_wf___NFA_normalise_states_cong)

  have DFA_da : "DFA ?da" by (simp add: NFA_determinise_is_DFA NFA_a)
  have con_da: "NFA_is_initially_connected ?da"
    unfolding NFA_determinise_def
    by (intro NFA_is_initially_connected___normalise_states
              efficient_determinise_NFA___is_initially_connected)
 
  from dfa_minimise.dfa_minimise_correct___isomorphic [OF m_OK, OF invar_da, OF DFA_da con_da iso_da]
  have invar_mda: "invar3 ((m \<circ> d) a)" and
       iso_mda: "NFA_isomorphic_wf (\<alpha>3 ((m \<circ> d) a)) (NFA_minimise ?da)" 
    by simp_all

  from invar_mda show "invar3 ((m \<circ> d) a)" .

  from iso_mda NFA_a DFA_da DFA_implies_NFA[OF DFA_da]
  show "NFA_isomorphic_wf (\<alpha>3 ((m \<circ> d) a)) (NFA_minimise (\<alpha>1 a))"
    by (simp add: NFA_isomorphic_wf___minimise DFA_alt_def 
                  NFA_determinise_\<L>)
qed

end
