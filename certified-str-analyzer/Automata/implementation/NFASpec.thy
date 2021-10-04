
section \<open> Interface for NFAs and DFAs \<close>

theory NFASpec
 
imports Main 
  "../NFA_set" 
  "Collections.Collections"
 (** "../DFA" *)

begin
type_synonym ('q,'a,'nfa) nfa_\<alpha> = "'nfa \<Rightarrow> ('q, 'a) NFA_rec"

  locale nfa =
    fixes \<alpha> :: "('q,'a,'nfa) nfa_\<alpha>"
    fixes invar :: "'nfa \<Rightarrow> bool"
    assumes nfa_is_wellformed: "invar n \<Longrightarrow> NFA (\<alpha> n)"


  text \<open>construct nfa from lists \<close>

  type_synonym ('q,'a,'nfa) nfa_from_list = 
    "('q list \<times>  ('q \<times> 'a list \<times> 'q) list \<times> 'q list \<times> 'q list) \<Rightarrow> 'nfa"

  locale nfa_from_list = nfa +
    constrains \<alpha> :: "('q,'a,'nfa) nfa_\<alpha>"
    fixes from_list :: "('q,'a,'nfa) nfa_from_list"
    assumes nfa_from_list_correct:
      "invar (from_list l)"  
      "\<alpha> (from_list l) = NFA_construct l"
  begin
    lemma nfa_from_list_correct___isomorphic :
      "invar (from_list l)"
      "NFA_isomorphic_wf (\<alpha> (from_list l)) (NFA_construct l)"
    by (simp_all add: nfa_from_list_correct NFA_isomorphic_wf_def NFA_isomorphic_refl
                      NFA_construct___is_well_formed)
  end

  type_synonym ('q,'a,'nfa) nfa_from_list_interval = 
    "('q list \<times> ('q \<times> ('a \<times> 'a) \<times> 'q) list 
      \<times> 'q list \<times> 'q list) \<Rightarrow> 'nfa"



  locale nfa_from_list_interval = nfa +
    constrains \<alpha> :: "('q,'a::linorder,'nfa) nfa_\<alpha>"
    fixes from_interval :: "('q,'a,'nfa) nfa_from_list_interval"
    assumes nfa_from_list_interval_correct:
      "invar (from_interval l)"  
      "\<alpha> (from_interval l) = NFA_construct_interval l"
  begin
    lemma nfa_from_list_interval_correct___isomorphic :
      "invar (from_interval l)"
      "(\<forall> (q,d,q') \<in> set (fst (snd l)). finite (semI d)) \<longrightarrow>
         NFA_isomorphic_wf (\<alpha> (from_interval l)) (NFA_construct_interval l)"
      apply auto
      by (simp_all add: nfa_from_list_interval_correct 
                        NFA_isomorphic_wf_def NFA_isomorphic_refl
                        NFA_construct_interval___is_well_formed)
      
  end

  type_synonym ('q,'a,'nfa) nfa_to_list = 
    "'nfa \<Rightarrow> ('q list \<times> ('q \<times> 'a list \<times> 'q) list \<times> 'q list \<times> 'q list)"
  locale nfa_to_list = nfa +
    constrains \<alpha> :: "('q,'a,'nfa) nfa_\<alpha>"
    fixes to_list :: "('q,'a,'nfa) nfa_to_list"
    assumes to_list_correct:
      "invar n \<Longrightarrow> NFA_construct (to_list n) = \<alpha> n"
  begin
    lemma to_list_correct___isomorphic :
      "invar n \<Longrightarrow>  NFA_isomorphic_wf (\<alpha> n) (NFA_construct (to_list n))"
    using to_list_correct[of n]
      apply (simp add: NFA_isomorphic_wf_def NFA_isomorphic_refl)
      apply (metis NFA_construct___is_well_formed)
    done
  end


  locale nfa_stats = nfa +
    constrains \<alpha> :: "('q,'a,'nfa) nfa_\<alpha>"
    fixes states_no :: "'nfa \<Rightarrow> nat"
    fixes trans_no :: "'nfa \<Rightarrow> nat"
    fixes initial_no :: "'nfa \<Rightarrow> nat"
    fixes final_no :: "'nfa \<Rightarrow> nat"
    assumes stats_correct:
      "invar n \<Longrightarrow> states_no n = card (\<Q> (\<alpha> n))"
      "invar n \<Longrightarrow> trans_no n = card (\<Delta> (\<alpha> n))"
      "invar n \<Longrightarrow> initial_no n = card (\<I> (\<alpha> n))"
      "invar n \<Longrightarrow> final_no n = card (\<F> (\<alpha> n))"
  begin
    lemma stats_correct___isomorphic :
    fixes \<A> :: "('q2, 'a, _) NFA_rec_scheme"
    shows
      "invar n \<Longrightarrow> NFA_isomorphic_wf (\<alpha> n) \<A> \<Longrightarrow> states_no n = card (\<Q> \<A>)"
      "invar n \<Longrightarrow> NFA_isomorphic_wf (\<alpha> n) \<A> \<Longrightarrow> trans_no n = card (\<Delta> \<A>)"
      "invar n \<Longrightarrow> NFA_isomorphic_wf (\<alpha> n) \<A> \<Longrightarrow> initial_no n = card (\<I> \<A>)"
      "invar n \<Longrightarrow> NFA_isomorphic_wf (\<alpha> n) \<A> \<Longrightarrow> final_no n = card (\<F> \<A>)"
    proof -
      fix n and \<A>:: "('q2, 'a, _) NFA_rec_scheme"
      assume invar_n: "invar n" and iso_\<A>: "NFA_isomorphic_wf (\<alpha> n) \<A>"

      note [simp] = stats_correct [OF invar_n]
      from iso_\<A> obtain f where inj_f: "inj_on f (\<Q> (\<alpha> n))"
                            and \<A>_eq[simp]: "\<A> = NFA_rename_states (\<alpha> n) f"
                            and wf: "NFA (\<alpha> n)"
        unfolding NFA_isomorphic_wf_def NFA_isomorphic_def by blast

      show "states_no n = card (\<Q> \<A>)" by (simp add: card_image inj_f)
 
      from wf [THEN NFA.\<I>_consistent, THEN subset_inj_on[OF inj_f]]
      show "initial_no n = card (\<I> \<A>)" by (simp add: card_image inj_f)

      from wf [THEN NFA.\<F>_consistent, THEN subset_inj_on[OF inj_f]]
      show "final_no n = card (\<F> \<A>)" by (simp add: card_image inj_f)

      show "trans_no n = card (\<Delta> \<A>)" 
      proof -
        have "{(f s1, a, f s2) |s1 a s2. (s1, a, s2) \<in> \<Delta> (\<alpha> n)} =
              (\<lambda>(s1, a, s2). (f s1, a, f s2)) ` (\<Delta> (\<alpha> n))" 
          by (auto simp add: image_iff Bex_def, metis)
        moreover
          have "inj_on (\<lambda>(s1, a, s2). (f s1, a, f s2)) (\<Delta> (\<alpha> n))"
            using inj_f wf[THEN NFA.\<Delta>_consistent]
            by (simp add: inj_on_def Ball_def)
        ultimately show ?thesis 
          by (simp add: NFA_rename_states_def card_image)
      qed
    qed
  end

(*
  lemma (in nfa_from_list) \<alpha>_exists :
    "NFA \<A> \<Longrightarrow> \<exists>AA. invar AA \<and> \<A> = \<alpha> AA"
  by (metis NFA_construct_exists nfa_from_list_correct)
*)
  type_synonym ('q,'a,'nfa) nfa_accept = 
    "'nfa \<Rightarrow> 'a list \<Rightarrow> bool"
  locale nfa_accept = nfa +
    constrains \<alpha> :: "('q,'a,'nfa) nfa_\<alpha>"
    fixes accept :: "'nfa \<Rightarrow> 'a list \<Rightarrow> bool"
    assumes accept_correct:
      "invar n \<Longrightarrow> (accept n w = NFA_accept (\<alpha> n) w)"
  begin
    lemma accept_correct___isomorphic :
      assumes invar: "invar n"
          and iso: "NFA_isomorphic_wf (\<alpha> n) (\<A> :: ('q2, 'a) NFA_rec)"
      shows "accept n w = NFA_accept \<A> w"
    using assms
    by (metis NFA_isomorphic_wf_accept accept_correct)
  end


  locale nfa_remove_states = nfa \<alpha> invar + set \<alpha>_s invar_s 
    for \<alpha> :: "('q,'a,'nfa) nfa_\<alpha>" and invar
    and \<alpha>_s :: "'q_set \<Rightarrow> 'q set" and invar_s +
    fixes remove_states :: "'nfa \<Rightarrow> 'q_set \<Rightarrow> 'nfa"
    assumes remove_states_correct:
      "invar n \<Longrightarrow> invar_s S \<Longrightarrow> (invar (remove_states n S))"
      "invar n \<Longrightarrow> invar_s S \<Longrightarrow> 
       (\<alpha> (remove_states n S) = NFA_remove_states (\<alpha> n) (\<alpha>_s S))"

  locale nfa_rename_states = nfa \<alpha>1 invar1 + nfa \<alpha>2 invar2  
    for \<alpha>1 :: "('q1,'a,'nfa1) nfa_\<alpha>" and invar1 and
        \<alpha>2 :: "('q2,'a,'nfa2) nfa_\<alpha>" and invar2 +
    fixes rename_states :: "'nfa1 \<Rightarrow> ('q1 \<Rightarrow> 'q2) \<Rightarrow> 'nfa2"
    assumes nfa_rename_states_correct:
      "invar1 n \<Longrightarrow> (invar2 (rename_states n f))"
      "invar1 n \<Longrightarrow> (\<alpha>2 (rename_states n f) = NFA_rename_states (\<alpha>1 n) f)"

  type_synonym ('a1,'a2,'nfa1,'nfa2) nfa_rename_labels = "'nfa1 \<Rightarrow> ('a1 \<Rightarrow> 'a2) \<Rightarrow> 'nfa2"
  locale nfa_rename_labels = n1:nfa \<alpha>1 invar1 + n2:nfa \<alpha>2 invar2  
    for \<alpha>1 :: "('q,'a1,'nfa1) nfa_\<alpha>" and invar1 and
        \<alpha>2 :: "('q,'a2,'nfa2) nfa_\<alpha>" and invar2 +
    fixes rename_labels :: "('a1,'a2,'nfa1,'nfa2) nfa_rename_labels"
    assumes rename_labels_correct:
      "invar1 n \<Longrightarrow> (invar2 (rename_labels n f))"
      "invar1 n \<Longrightarrow> (\<alpha>2 (rename_labels n f) = NFA_rename_labels (\<alpha>1 n) f)"
  begin
    lemma rename_labels_correct___isomorphic :
      "invar1 n \<Longrightarrow> (invar2 (rename_labels n f))"
      "invar1 n \<Longrightarrow> NFA_isomorphic_wf (\<alpha>1 n) \<A> \<Longrightarrow> 
                    NFA_isomorphic_wf (\<alpha>2 (rename_labels n f)) (NFA_rename_labels \<A> f)"
    using rename_labels_correct[of n f] n2.nfa_is_wellformed
          NFA_isomorphic_wf___NFA_rename_labels_cong [of "\<alpha>1 n" \<A> f]

    by simp_all
  end

type_synonym ('a1,'a2,'a_set,'nfa1,'nfa2) nfa_rename_labels_gen = 
  "'nfa1 \<Rightarrow> 'a_set \<Rightarrow> ('a1 \<Rightarrow> 'a2) \<Rightarrow> 'nfa2"

locale nfa_rename_labels_gen = n1: nfa \<alpha>1 invar1 + 
                               n2: nfa \<alpha>2 invar2 + 
                               set \<alpha>3 invar3  
    for \<alpha>1 :: "('q,'a1,'nfa1) nfa_\<alpha>" and invar1 and
        \<alpha>2 :: "('q,'a2,'nfa2) nfa_\<alpha>" and invar2 and
        \<alpha>3 :: "'a_set \<Rightarrow> 'a2 set" and invar3 +
    fixes rename_labels_gen :: "('a1,'a2,'a_set,'nfa1,'nfa2) nfa_rename_labels_gen"
    assumes rename_labels_gen_correct:
      "invar1 n \<Longrightarrow> invar3 A
          \<Longrightarrow> (invar2 (rename_labels_gen n A f))"
      "invar1 n \<Longrightarrow> invar3 A 
          \<Longrightarrow> (\<alpha>2 (rename_labels_gen n A f) = NFA_rename_labels (\<alpha>1 n) f)"
  begin
    lemma rename_labels_gen_correct___isomorphic :
      "invar1 n \<Longrightarrow> invar3 A \<Longrightarrow>  (invar2 (rename_labels_gen n A f))"
      "invar1 n \<Longrightarrow> invar3 A \<Longrightarrow> 
         NFA_isomorphic_wf (\<alpha>1 n) \<A> \<Longrightarrow>
         NFA_isomorphic_wf (\<alpha>2 (rename_labels_gen n A f)) (NFA_rename_labels \<A> f)"
    using rename_labels_gen_correct[of n A f] n2.nfa_is_wellformed
          NFA_isomorphic_wf___NFA_rename_labels_cong [of "\<alpha>1 n" \<A> f]
    by simp_all 
end

  lemma nfa_rename_labels_gen_impl :
    assumes "nfa_rename_labels_gen \<alpha>1 invar1 \<alpha>2 invar2 invar3 rl"
        and "\<And>n f. invar1 n \<Longrightarrow> invar3 (im n f) "
    shows "nfa_rename_labels \<alpha>1 invar1 \<alpha>2 invar2 (\<lambda>AA f. rl AA (im AA f) f)"
    using assms
    unfolding nfa_rename_labels_def nfa_rename_labels_gen_def nfa_rename_labels_axioms_def
              nfa_rename_labels_gen_axioms_def
    by simp

  locale nfa_reverse = nfa \<alpha>1 invar1 + nfa \<alpha>2 invar2   
    for \<alpha>1 :: "('q,'a,'nfa1) nfa_\<alpha>" and invar1 and
        \<alpha>2 :: "('q,'a,'nfa2) nfa_\<alpha>" and invar2 +
    fixes reverse :: "'nfa1 \<Rightarrow> 'nfa2"
    assumes reverse_correct:
      "invar1 n \<Longrightarrow> invar2 (reverse n)"
      "invar1 n \<Longrightarrow> (\<alpha>2 (reverse n) = NFA_reverse (\<alpha>1 n))"
  begin
    lemma reverse_correct___isomorphic :
      "invar1 n \<Longrightarrow> invar2 (reverse n)"
      "invar1 n \<Longrightarrow> NFA_isomorphic_wf (\<alpha>1 n) (\<A> :: ('q2, 'a) NFA_rec) \<Longrightarrow>
                    NFA_isomorphic_wf (\<alpha>2 (reverse n)) (NFA_reverse \<A>)"
      apply (simp add: reverse_correct)
      apply (insert reverse_correct(2)[of n] 
                  NFA_isomorphic_wf___NFA_reverse_cong [of "\<alpha>1 n" \<A>])
      apply (simp)
    done
  end



  type_synonym ('q2,'i,'a,'\<sigma>,'nfa) nfa_construct = 
    "('q2 \<Rightarrow> 'i) \<Rightarrow> 'q2 list \<Rightarrow>  ('q2 \<Rightarrow> bool) \<Rightarrow> 
     ('q2 \<Rightarrow> (('a \<times> 'a) \<times>'q2,'\<sigma>) set_iterator) \<Rightarrow> 'nfa"

  locale nfa_construct_no_enc = nfa \<alpha> invar + set s_\<alpha> s_invar 
    for \<alpha> and invar and s_\<alpha> :: "'a_set \<Rightarrow> 'a::linorder set" and s_invar + 
    constrains \<alpha> :: "('q,'a,'nfa) nfa_\<alpha>"
    fixes construct :: "('q2,'i,'a,'\<sigma>,'nfa) nfa_construct"
    assumes nfa_construct_no_enc_correct:
       "\<lbrakk>NFA (\<A>::('q2, 'a) NFA_rec); 
         inj_on f (\<Q> \<A>); 
         distinct I; 
         set I = \<I> \<A>;
         finite D;
         \<forall>q. inj_on (\<lambda>(a, y). (semI a, y)) ({(a, q'). (q, a, q') \<in> D});
         {(q, semI a, q') | q a q'. (q, a, q') \<in> D} = (\<Delta> \<A>); 
         \<And>q. q \<in> \<Q> \<A> \<Longrightarrow> FP q \<longleftrightarrow> q \<in> \<F> \<A>;
         \<And>q. q \<in> \<Q> \<A> \<Longrightarrow> set_iterator (D_it q) 
              {(a, q'). (q, a, q') \<in> D}\<rbrakk> \<Longrightarrow> 
         (invar (construct f I FP D_it) \<and>
         NFA_isomorphic_wf (\<alpha> (construct f I FP D_it)) 
         (NFA_remove_unreachable_states \<A>))"


  


  type_synonym ('q2,'i,'a,'\<sigma>,'nfa) nfa_construct_prod = 
    "('q2 \<Rightarrow> 'i) \<Rightarrow> 'q2 list  \<Rightarrow> ('q2 \<Rightarrow> bool) \<Rightarrow> 
     ('q2 \<Rightarrow> ((('a \<times> 'a) \<times> ('a \<times> 'a)) \<times>'q2,'\<sigma>) set_iterator) \<Rightarrow> 'nfa"

    locale nfa_construct_no_enc_prod = nfa \<alpha> invar + set s_\<alpha> s_invar 
    for \<alpha> and invar and s_\<alpha> :: "'a_set \<Rightarrow> ('a:: linorder) set" and s_invar + 
    constrains \<alpha> :: "('q,'a,'nfa) nfa_\<alpha>"
    fixes construct :: "('q2,'i,'a,'\<sigma>,'nfa) nfa_construct_prod"
    assumes nfa_construct_no_enc_correct:
       "\<lbrakk>NFA (\<A>::('q2, 'a) NFA_rec); 
         inj_on f (\<Q> \<A>); 
         distinct I; 
         set I = \<I> \<A>;
         finite D;
         (\<forall>q a b aa ba q'.
         ((q, ((a, b), aa, ba), q') \<in> {(q, a, q'). (q, a, q') \<in> D}) \<longrightarrow> a \<le> b \<and> aa \<le> ba);
         {(q, semI (fst a) \<inter> semI (snd a), q') | q a q'. (q,a,q') \<in> D} = (\<Delta> \<A>);  
         \<And>q. q \<in> \<Q> \<A> \<Longrightarrow> FP q \<longleftrightarrow> q \<in> \<F> \<A>;
         \<And>q. set_iterator (D_it q) 
              {(a, q'). (q, a, q') \<in> D}\<rbrakk> \<Longrightarrow> 
         (invar (construct f I FP D_it) \<and>
         NFA_isomorphic_wf (\<alpha> (construct f I FP D_it)) 
         (NFA_remove_unreachable_states \<A>))"

  locale nfa_construct = nfa \<alpha> invar + set s_\<alpha> s_invar 
    for \<alpha> and invar and s_\<alpha> :: "'a_set \<Rightarrow> 'a::linorder set"  and s_invar + 
    constrains \<alpha> :: "('q,'a,'nfa) nfa_\<alpha>" 
    fixes q2_\<alpha> :: "'q2_rep \<Rightarrow> 'q2" 
      and q2_invar :: "'q2_rep \<Rightarrow> bool" 
      and construct :: "('q2_rep,'i,'a,'\<sigma>,'nfa) nfa_construct"
    assumes nfa_construct_correct:
       "\<lbrakk>NFA (\<A>::('q2, 'a) NFA_rec); inj_on f (\<Q> \<A>);
         \<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> ff q = (f (q2_\<alpha> q));
         distinct (map q2_\<alpha> I);
         finite (\<Delta> \<A>);
         \<And>q. inj_on (\<lambda>(a, q'). (semI a, q2_\<alpha> q')) (DS q);
         \<And>q. q \<in> set I \<Longrightarrow> q2_invar q; q2_\<alpha> ` (set I) = \<I> \<A>;
         \<And> q. \<lbrakk>q2_invar q; q2_\<alpha> q \<in> \<Q> \<A>\<rbrakk> \<Longrightarrow> FP q \<longleftrightarrow> q2_\<alpha> q \<in> \<F> \<A>;
         \<And> q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> 
          set_iterator
          (D_it q) {(a, q'). (a, q') \<in> (DS q)} \<and>
          {(a, q'). (q2_\<alpha> q, a, q') \<in> \<Delta> \<A>} = 
           (\<lambda>(a, q'). (semI a, q2_\<alpha> q')) ` (DS q) \<and>
               (\<forall>a q'. (a, q') \<in> (DS q) \<longrightarrow> q2_invar q') \<and>
               (\<forall>a q'. (a, q') \<in> (DS q) \<longrightarrow> (\<forall>q''. (a, q'') \<in> (DS q) 
                \<longrightarrow> (q2_\<alpha> q' = q2_\<alpha> q'') = (q' = q'')))
            \<rbrakk> \<Longrightarrow>
         (invar (construct ff I FP D_it) \<and>
          NFA_isomorphic_wf 
          (\<alpha> (construct ff I FP D_it)) 
          (NFA_remove_unreachable_states \<A>))"

  locale nfa_construct_prod = nfa \<alpha> invar + set s_\<alpha> s_invar 
    for \<alpha> and invar and s_\<alpha> :: "'a_set \<Rightarrow> 'a::linorder set"  and s_invar + 
    constrains \<alpha> :: "('q,'a,'nfa) nfa_\<alpha>" 
    fixes q2_\<alpha> :: "'q2_rep \<Rightarrow> 'q2" 
      and q2_invar :: "'q2_rep \<Rightarrow> bool" 
      and construct :: "('q2_rep,'i,'a,'\<sigma>,'nfa) nfa_construct_prod"
    assumes nfa_construct_correct:
       "\<lbrakk>NFA (\<A>::('q2, 'a) NFA_rec); inj_on f (\<Q> \<A>);
         \<And>q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> ff q = (f (q2_\<alpha> q));
         distinct (map q2_\<alpha> I);
         finite D;
         finite (\<Delta> \<A>);
         \<And>q a b q'. ((a,b), q') \<in> DS q \<longrightarrow> fst a \<le> snd a \<and> fst b \<le> snd b;
         {(q,  (fst a) \<inter>  (snd a), q') | q a q'. (q,a,q') \<in> D} = (\<Delta> \<A>);
         \<And>q. q \<in> set I \<Longrightarrow> q2_invar q; q2_\<alpha> ` (set I) = \<I> \<A>;
         \<And> q. \<lbrakk>q2_invar q; q2_\<alpha> q \<in> \<Q> \<A>\<rbrakk> \<Longrightarrow> FP q \<longleftrightarrow> q2_\<alpha> q \<in> \<F> \<A>;
         \<And> q. q2_invar q \<Longrightarrow> q2_\<alpha> q \<in> \<Q> \<A> \<Longrightarrow> 
          set_iterator
          (D_it q) {(a, q'). (a, q') \<in> (DS q)} 
          \<and>
          {(a, q'). (q2_\<alpha> q, a, q') \<in> D} = 
           (\<lambda>(a, q'). ((semI (fst a), semI (snd a)), q2_\<alpha> q')) ` (DS q) \<and>
               (\<forall>a q'. (a, q') \<in> (DS q) \<longrightarrow> q2_invar q') \<and>
               (\<forall>a q'. (a, q') \<in> (DS q) \<longrightarrow> (\<forall>q''. (a, q'') \<in> (DS q) 
                \<longrightarrow> (q2_\<alpha> q' = q2_\<alpha> q'') = (q' = q'')))
            \<rbrakk> \<Longrightarrow>
         (invar (construct ff I FP D_it) \<and>
          NFA_isomorphic_wf 
          (\<alpha> (construct ff I FP D_it)) 
          (NFA_remove_unreachable_states \<A>))"


  lemma nfa_construct_no_enc_default :
    "nfa_construct \<alpha> invar  id (\<lambda>_. True) construct \<Longrightarrow>
     nfa_construct_no_enc \<alpha> invar  construct"
    apply (simp add: nfa_construct_def 
                  nfa_construct_no_enc_def 
                  nfa_construct_no_enc_axioms_def
                  nfa_construct_axioms_def)
  proof 
    fix \<A>
    assume p1: "nfa \<alpha> invar \<and>
         (\<forall>\<A>. NFA \<A> \<longrightarrow>
               (\<forall>f. inj_on f (\<Q> \<A>) \<longrightarrow>
                    (\<forall>ff. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> ff q = f q) \<longrightarrow>
                          (\<forall>I. distinct I \<longrightarrow>
                               finite (\<Delta> \<A>) \<longrightarrow>
                               (\<forall>DS. (\<forall>q. inj_on (\<lambda>(a, y). (semI a, y)) (DS q)) \<longrightarrow>
                                     set I = \<I> \<A> \<longrightarrow>
                                     (\<forall>FP. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
                                           (\<forall>D_it.
   (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
        set_iterator (D_it q) (DS q) \<and>
        {(a, q'). (q, a, q') \<in> \<Delta> \<A>} = (\<lambda>x. case x of (a, x) \<Rightarrow> (semI a, x)) ` DS q) \<longrightarrow>
   invar (construct ff I FP D_it) \<and>
   NFA_isomorphic_wf (\<alpha> (construct ff I FP D_it))
    (NFA_remove_unreachable_states \<A>))))))))"
    show "NFA \<A> \<longrightarrow>
         (\<forall>f. inj_on f (\<Q> \<A>) \<longrightarrow>
              (\<forall>I. distinct I \<longrightarrow>
                   set I = \<I> \<A> \<longrightarrow>
                   (\<forall>D. finite D \<longrightarrow>
                        (\<forall>q. inj_on (\<lambda>(a, y). (semI a, y))
                              {(a, q'). (q, a, q') \<in> D}) \<longrightarrow>
                        {(q, semI (a, b), q') |q a b q'. (q, (a, b), q') \<in> D} = \<Delta> \<A> \<longrightarrow>
                        (\<forall>FP. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
                              (\<forall>D_it.
                                  (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
                                       set_iterator (D_it q)
                                        {(a, q'). (q, a, q') \<in> D}) \<longrightarrow>
                                  invar (construct f I FP D_it) \<and>
                                  NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
                                   (NFA_remove_unreachable_states \<A>))))))"
      apply (rule impI allI)+
    proof -
      fix f I D FP D_it
      show "NFA \<A> \<Longrightarrow>
       inj_on f (\<Q> \<A>) \<Longrightarrow>
       distinct I \<Longrightarrow>
       set I = \<I> \<A> \<Longrightarrow>
       finite D \<Longrightarrow>
       \<forall>q. inj_on (\<lambda>(a, y). (semI a, y)) {(a, q'). (q, a, q') \<in> D} \<Longrightarrow>
       {(q, semI (a, b), q') |q a b q'. (q, (a, b), q') \<in> D} = \<Delta> \<A> \<Longrightarrow>
       \<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>) \<Longrightarrow>
       \<forall>q. q \<in> \<Q> \<A> \<longrightarrow> set_iterator (D_it q) {(a, q'). (q, a, q') \<in> D} \<Longrightarrow>
       invar (construct f I FP D_it) \<and>
       NFA_isomorphic_wf (\<alpha> (construct f I FP D_it)) (NFA_remove_unreachable_states \<A>)"
      proof -
      assume p2: "NFA \<A>" and
             p3: "inj_on f (\<Q> \<A>)" and
             p4: "distinct I" and
             p5: "set I = \<I> \<A>" and
             p6: "finite D" and
             p7: "{(q, semI (a, b), q') |q a b q'. (q, (a, b), q') \<in> D} = \<Delta> \<A>" and
             p8: "\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)" and
             p9: "\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> set_iterator (D_it q) {(a, q'). (q, a, q') \<in> D}" and
             p10: "(\<forall>q. inj_on (\<lambda>(a, y). (semI a, y))
                              {(a, q'). (q, a, q') \<in> D})"

      from this p1
      have "(\<forall>f. inj_on f (\<Q> \<A>) \<longrightarrow>
                    (\<forall>ff. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> ff q = f q) \<longrightarrow>
                          (\<forall>I. distinct I \<longrightarrow>
                               finite (\<Delta> \<A>) \<longrightarrow>
                               (\<forall>DS. (\<forall>q. inj_on (\<lambda>(a, y). (semI a, y)) (DS q)) \<longrightarrow>
                                     set I = \<I> \<A> \<longrightarrow>
                                     (\<forall>FP. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
                                           (\<forall>D_it.
   (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
        set_iterator (D_it q) (DS q) \<and>
        {(a, q'). (q, a, q') \<in> \<Delta> \<A>} = (\<lambda>x. case x of (a, x) \<Rightarrow> (semI a, x)) ` DS q) \<longrightarrow>
   invar (construct ff I FP D_it) \<and>
   NFA_isomorphic_wf (\<alpha> (construct ff I FP D_it))
    (NFA_remove_unreachable_states \<A>)))))))"
        by simp
      from p1 p2 p3 p4 p5 p6 p7 p8 p9 have "
        inj_on f (\<Q> \<A>) \<longrightarrow>
                    (\<forall>ff. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> ff q = f q) \<longrightarrow>
                          (\<forall>I. distinct I \<longrightarrow>
                               finite (\<Delta> \<A>) \<longrightarrow>
                               (\<forall>DS. (\<forall>q. inj_on (\<lambda>(a, y). (semI a, y)) (DS q)) \<longrightarrow>
                                     set I = \<I> \<A> \<longrightarrow>
                                     (\<forall>FP. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
                                           (\<forall>D_it.
   (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
        set_iterator (D_it q) (DS q) \<and>
        {(a, q'). (q, a, q') \<in> \<Delta> \<A>} = (\<lambda>x. case x of (a, x) \<Rightarrow> (semI a, x)) ` DS q) \<longrightarrow>
   invar (construct ff I FP D_it) \<and>
   NFA_isomorphic_wf (\<alpha> (construct ff I FP D_it))
    (NFA_remove_unreachable_states \<A>))))))"
        by simp

     from p1 p2 p3 p4 p5 p6 p7 p8 p9 have "
        (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> f q = f q) \<longrightarrow>
                          (\<forall>I. distinct I \<longrightarrow>
                               finite (\<Delta> \<A>) \<longrightarrow>
                               (\<forall>DS. (\<forall>q. inj_on (\<lambda>(a, y). (semI a, y)) (DS q)) \<longrightarrow>
                                     set I = \<I> \<A> \<longrightarrow>
                                     (\<forall>FP. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
                                           (\<forall>D_it.
   (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
        set_iterator (D_it q) (DS q) \<and>
        {(a, q'). (q, a, q') \<in> \<Delta> \<A>} = (\<lambda>x. case x of (a, x) \<Rightarrow> (semI a, x)) ` DS q) \<longrightarrow>
   invar (construct f I FP D_it) \<and>
   NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
    (NFA_remove_unreachable_states \<A>)))))"
        by simp
  from p6 p7 have finiteA: "finite (\<Delta> \<A>)"
    apply (subgoal_tac "{(q, semI (a, b), q') |q a b q'. (q, (a, b), q') \<in> D} = 
                        (\<lambda> (q, a, q'). (q, semI a, q')) ` D")
    using finite_imageI[OF p6, of "\<lambda> (q, a, q'). (q, semI a, q')"]
    apply simp
    apply (simp only: set_eq_iff)
  proof 
    fix x
    assume p1: "\<forall>x. (x \<in> {(q, semI (a, b), q') |q a b q'. (q, (a, b), q') \<in> D}) =
             (x \<in> \<Delta> \<A>)"
    show "(x \<in> \<Delta> \<A>) = (x \<in> (\<lambda>(q, a, q'). (q, semI a, q')) ` D)"
    proof
      { assume "x \<in> \<Delta> \<A>"
        from p1 this obtain q a b q' where
         "x = (q, semI (a, b), q') \<and> (q, (a, b), q') \<in> D" by blast
        from p1 this
        show "x \<in> (\<lambda>(q, a, q'). (q, semI a, q')) ` D"
          by force 
      }
      {
        assume " x \<in> (\<lambda>(q, a, q'). (q, semI a, q')) ` D "
        from p1 this show "x \<in> \<Delta> \<A>"
          by fastforce 
      }
    qed qed
    
    
  from p1 p2 p3 p4 p5 p6 p7 p8 p9 finiteA this have "
            (\<forall>DS. (\<forall>q. inj_on (\<lambda>(a, y). (semI a, y)) (DS q)) \<longrightarrow>
                set I = \<I> \<A> \<longrightarrow>
                  (\<forall>FP. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
                    (\<forall>D_it.
   (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
        set_iterator (D_it q) (DS q) \<and>
        {(a, q'). (q, a, q') \<in> \<Delta> \<A>} = (\<lambda>x. case x of (a, x) \<Rightarrow> (semI a, x)) ` DS q) \<longrightarrow>
   invar (construct f I FP D_it) \<and>
   NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
    (NFA_remove_unreachable_states \<A>))))"
    by simp

  from p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 this have "
                set I = \<I> \<A> \<longrightarrow>
                  (\<forall>FP. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
                    (\<forall>D_it.
   (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
        set_iterator (D_it q) {(a, q'). (q, a, q') \<in> D} \<and>
        {(a, q'). (q, a, q') \<in> \<Delta> \<A>} = (\<lambda>x. case x of (a, x) \<Rightarrow> 
          (semI a, x)) ` {(a, q'). (q, a, q') \<in> D}) \<longrightarrow>
   invar (construct f I FP D_it) \<and>
   NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
    (NFA_remove_unreachable_states \<A>)))"
    by simp

  from p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 this have "
                  (\<forall>FP. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
                    (\<forall>D_it.
   (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
        set_iterator (D_it q) {(a, q'). (q, a, q') \<in> D} \<and>
        {(a, q'). (q, a, q') \<in> \<Delta> \<A>} = (\<lambda>x. case x of (a, x) \<Rightarrow> 
          (semI a, x)) ` {(a, q'). (q, a, q') \<in> D}) \<longrightarrow>
   invar (construct f I FP D_it) \<and>
   NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
    (NFA_remove_unreachable_states \<A>)))"
    by simp

  from p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 this have "
                    (\<forall>D_it.
   (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
        set_iterator (D_it q) {(a, q'). (q, a, q') \<in> D} \<and>
        {(a, q'). (q, a, q') \<in> \<Delta> \<A>} = (\<lambda>x. case x of (a, x) \<Rightarrow> 
          (semI a, x)) ` {(a, q'). (q, a, q') \<in> D}) \<longrightarrow>
   invar (construct f I FP D_it) \<and>
   NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
    (NFA_remove_unreachable_states \<A>))"
        by simp

   from p9 p7 this have cc1: "
   (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
        set_iterator (D_it q) {(a, q'). (q, a, q') \<in> D} \<and>
        {(a, q'). (q, a, q') \<in> \<Delta> \<A>} = (\<lambda>x. case x of (a, x) \<Rightarrow> 
          (semI a, x)) ` {(a, q'). (q, a, q') \<in> D}) \<longrightarrow>
   invar (construct f I FP D_it) \<and>
   NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
    (NFA_remove_unreachable_states \<A>)"
        by simp
      from  p6 p7 p9
      have "(\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
       set_iterator (D_it q) {(a, q'). (q, a, q') \<in> D} \<and>
       {(a, q'). (q, a, q') \<in> \<Delta> \<A>} =
       (\<lambda>x. case x of (a, x) \<Rightarrow> (semI a, x)) ` {(a, q'). (q, a, q') \<in> D})"
        apply (rule_tac allI)
      proof 
        fix q
        assume c1: "q \<in> \<Q> \<A>"
        from this show "set_iterator (D_it q) {(a, q'). (q, a, q') \<in> D} \<and>
         {(a, q'). (q, a, q') \<in> \<Delta> \<A>} =
         (\<lambda>x. case x of (a, x) \<Rightarrow> (semI a, x)) ` {(a, q'). (q, a, q') \<in> D}"
          apply auto
          using p7 p9 c1 apply simp
        proof -
          {
            fix a b
            assume p1: "q \<in> \<Q> \<A>" and
                   p2: "(q, a, b) \<in> \<Delta> \<A>"
            from p7 this 
            obtain a1 a2 where
            "(q, (a1,a2), b) \<in> D \<and> a = semI (a1, a2)"
              by blast
            from this p1 p2 p7
            show "(a, b) \<in> (\<lambda>x. case x of (a, x) \<Rightarrow>
                    (semI a, x)) ` {(a, q'). (q, a, q') \<in> D}"
              by auto
          }
          {
            fix aa ba bb
            assume p1: "q \<in> \<Q> \<A>" and
                   p2: "(q, (aa, ba), bb) \<in> D"
            from this p7 
            show "(q, semI (aa, ba), bb) \<in> \<Delta> \<A>"
              by blast
          }
        qed qed
        from this cc1
  show "invar (construct f I FP D_it) \<and>
    NFA_isomorphic_wf (\<alpha> (construct f I FP D_it)) (NFA_remove_unreachable_states \<A>)"
    by simp
qed qed qed

  lemma nfa_construct_no_enc_prod_default :
    "nfa_construct_prod \<alpha> invar  id (\<lambda>_. True) construct \<Longrightarrow>
     nfa_construct_no_enc_prod \<alpha> invar  construct"
    apply (simp add: nfa_construct_prod_def 
                  nfa_construct_no_enc_prod_def 
                  nfa_construct_no_enc_prod_axioms_def
                  nfa_construct_prod_axioms_def)
   proof 
    fix \<A>
    assume p1: " nfa \<alpha> invar \<and>
         (\<forall>\<A>. NFA \<A> \<longrightarrow>
               (\<forall>f. inj_on f (\<Q> \<A>) \<longrightarrow>
                    (\<forall>ff. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> ff q = f q) \<longrightarrow>
                          (\<forall>I. distinct I \<longrightarrow>
                               (\<forall>D. finite D \<longrightarrow>
                                    finite (\<Delta> \<A>) \<longrightarrow>
                                    (\<forall>DS. (\<forall>q a b aa ba.
  (\<exists>q'. (((a, b), aa, ba), q') \<in> DS q) \<longrightarrow> a \<le> b \<and> aa \<le> ba) \<longrightarrow>
                                          {(q, a \<inter> b, q') |q a b q'.
                                           (q, (a, b), q') \<in> D} =
                                          \<Delta> \<A> \<longrightarrow>
                                          set I = \<I> \<A> \<longrightarrow>
                                          (\<forall>FP.
  (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
  (\<forall>D_it.
      (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
           set_iterator (D_it q) (DS q) \<and>
           {(a, q'). (q, a, q') \<in> D} =
           (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) ` DS q) \<longrightarrow>
      invar (construct ff I FP D_it) \<and>
      NFA_isomorphic_wf (\<alpha> (construct ff I FP D_it))
       (NFA_remove_unreachable_states \<A>)))))))))"
    show " NFA \<A> \<longrightarrow>
         (\<forall>f. inj_on f (\<Q> \<A>) \<longrightarrow>
              (\<forall>I. distinct I \<longrightarrow>
                   set I = \<I> \<A> \<longrightarrow>
                   (\<forall>D. finite D \<longrightarrow>
                        (\<forall>q a b aa ba.
                            (\<exists>q'. (q, ((a, b), aa, ba), q') \<in> D) \<longrightarrow>
                            a \<le> b \<and> aa \<le> ba) \<longrightarrow>
                        {(q, semI (a, b) \<inter> semI (aa, ba), q') |q a b aa ba q'.
                         (q, ((a, b), aa, ba), q') \<in> D} =
                        \<Delta> \<A> \<longrightarrow>
                        (\<forall>FP. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
                              (\<forall>D_it.
                                  (\<forall>q. set_iterator (D_it q)
                                        {(a, q'). (q, a, q') \<in> D}) \<longrightarrow>
                                  invar (construct f I FP D_it) \<and>
                                  NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
                                   (NFA_remove_unreachable_states \<A>))))))"
      apply (rule impI allI)+
    proof -
      fix f I D FP D_it
      show "NFA \<A> \<Longrightarrow>
       inj_on f (\<Q> \<A>) \<Longrightarrow>
       distinct I \<Longrightarrow>
       set I = \<I> \<A> \<Longrightarrow>
       finite D \<Longrightarrow>
       \<forall>q a b aa ba. (\<exists>q'. (q, ((a, b), aa, ba), q') \<in> D) \<longrightarrow> a \<le> b \<and> aa \<le> ba \<Longrightarrow>
       {(q, semI (a, b) \<inter> semI (aa, ba), q') |q a b aa ba q'.
        (q, ((a, b), aa, ba), q') \<in> D} =
       \<Delta> \<A> \<Longrightarrow>
       \<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>) \<Longrightarrow>
       \<forall>q. set_iterator (D_it q) {(a, q'). (q, a, q') \<in> D} \<Longrightarrow>
       invar (construct f I FP D_it) \<and>
       NFA_isomorphic_wf (\<alpha> (construct f I FP D_it)) (NFA_remove_unreachable_states \<A>)"
      proof -
       
              assume p2: "NFA \<A>" 
             and
             p3: "inj_on f (\<Q> \<A>)" and
             p4: "distinct I" and
             p5: "set I = \<I> \<A>" and
             p6: "finite D" and p11: "(\<forall>q a b aa ba.
                            (\<exists>q'. (q, ((a, b), aa, ba), q') \<in> D) \<longrightarrow>
                            a \<le> b \<and> aa \<le> ba)" and
             p7: " {(q, semI (a, b) \<inter> semI (aa, ba), q') |q a b aa ba q'.
     (q, ((a, b), aa, ba), q') \<in> D} =
    \<Delta> \<A>" and
             p8: "\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)" and
             p9: "\<forall>q. set_iterator (D_it q) {(a, q'). (q, a, q') \<in> D} "     
      from this p1
      have " (\<forall>f. inj_on f (\<Q> \<A>) \<longrightarrow>
                    (\<forall>ff. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> ff q = f q) \<longrightarrow>
                          (\<forall>I. distinct I \<longrightarrow>
                               (\<forall>D. finite D \<longrightarrow>
                                    finite (\<Delta> \<A>) \<longrightarrow>
                                    (\<forall>DS. (\<forall>q a b aa ba.
  (\<exists>q'. (((a, b), aa, ba), q') \<in> DS q) \<longrightarrow> a \<le> b \<and> aa \<le> ba) \<longrightarrow>
                                          {(q, a \<inter> b, q') |q a b q'.
                                           (q, (a, b), q') \<in> D} =
                                          \<Delta> \<A> \<longrightarrow>
                                          set I = \<I> \<A> \<longrightarrow>
                                          (\<forall>FP.
  (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
  (\<forall>D_it.
      (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
           set_iterator (D_it q) (DS q) \<and>
           {(a, q'). (q, a, q') \<in> D} =
           (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) ` DS q) \<longrightarrow>
      invar (construct ff I FP D_it) \<and>
      NFA_isomorphic_wf (\<alpha> (construct ff I FP D_it))
       (NFA_remove_unreachable_states \<A>))))))))"
        by simp
      from p1 p2 p3 p4 p5 p6 p7 p8 p9 have "
                    (\<forall>ff. (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> ff q = f q) \<longrightarrow>
                          (\<forall>I. distinct I \<longrightarrow>
                               (\<forall>D. finite D \<longrightarrow>
                                    finite (\<Delta> \<A>) \<longrightarrow>
                                    (\<forall>DS. (\<forall>q a b aa ba.
  (\<exists>q'. (((a, b), aa, ba), q') \<in> DS q) \<longrightarrow> a \<le> b \<and> aa \<le> ba) \<longrightarrow>
                                          {(q, a \<inter> b, q') |q a b q'.
                                           (q, (a, b), q') \<in> D} =
                                          \<Delta> \<A> \<longrightarrow>
                                          set I = \<I> \<A> \<longrightarrow>
                                          (\<forall>FP.
  (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
  (\<forall>D_it.
      (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
           set_iterator (D_it q) (DS q) \<and>
           {(a, q'). (q, a, q') \<in> D} =
           (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) ` DS q) \<longrightarrow>
      invar (construct ff I FP D_it) \<and>
      NFA_isomorphic_wf (\<alpha> (construct ff I FP D_it))
       (NFA_remove_unreachable_states \<A>)))))))"
        by simp

     from p1 p2 p3 p4 p5 p6 p7 p8 p9 have "
                          (\<forall>I. distinct I \<longrightarrow>
                               (\<forall>D. finite D \<longrightarrow>
                                    finite (\<Delta> \<A>) \<longrightarrow>
                                    (\<forall>DS. (\<forall>q a b aa ba.
  (\<exists>q'. (((a, b), aa, ba), q') \<in> DS q) \<longrightarrow> a \<le> b \<and> aa \<le> ba) \<longrightarrow>
                                          {(q, a \<inter> b, q') |q a b q'.
                                           (q, (a, b), q') \<in> D} =
                                          \<Delta> \<A> \<longrightarrow>
                                          set I = \<I> \<A> \<longrightarrow>
                                          (\<forall>FP.
  (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
  (\<forall>D_it.
      (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
           set_iterator (D_it q) (DS q) \<and>
           {(a, q'). (q, a, q') \<in> D} =
           (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) ` DS q) \<longrightarrow>
      invar (construct f I FP D_it) \<and>
      NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
       (NFA_remove_unreachable_states \<A>))))))"
       by simp

   from p1 p2 p3 p4 p5 p6 p7 p8 p9 have "
                               (\<forall>D. finite D \<longrightarrow>
                                    finite (\<Delta> \<A>) \<longrightarrow>
                                    (\<forall>DS. (\<forall>q a b aa ba.
  (\<exists>q'. (((a, b), aa, ba), q') \<in> DS q) \<longrightarrow> a \<le> b \<and> aa \<le> ba) \<longrightarrow>
                                          {(q, a \<inter> b, q') |q a b q'.
                                           (q, (a, b), q') \<in> D} =
                                          \<Delta> \<A> \<longrightarrow>
                                          set I = \<I> \<A> \<longrightarrow>
                                          (\<forall>FP.
  (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
  (\<forall>D_it.
      (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
           set_iterator (D_it q) (DS q) \<and>
           {(a, q'). (q, a, q') \<in> D} =
           (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) ` DS q) \<longrightarrow>
      invar (construct f I FP D_it) \<and>
      NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
       (NFA_remove_unreachable_states \<A>)))))"
     by simp

   let ?D = "{(q, (semI a, semI b), q') | q a b q'. (q, (a, b), q') \<in> D}"
   have finite_D': "finite ?D"
     apply (subgoal_tac "
      (\<lambda> (q, (a, b), q'). (q, (semI a, semI b), q')) `  D =
      {(q, (semI a, semI b), q') |q a b q'. (q, (a, b), q') \<in> D}")
     using finite_imageI[OF p6, of "\<lambda> (q, (a, b), q'). (q, (semI a, semI b), q')"]
      apply simp
      apply (simp add: set_eq_iff)
     apply auto
   proof -
     fix a aa b ba ab bb ac bc
     assume pr1: "\<forall>x. (x \<in> aa) = (x \<in> semI (ab, bb))" and
            pr2: "\<forall>x. (x \<in> b) = (x \<in> semI (ac, bc))" and
            pr3: "(a, ((ab, bb), ac, bc), ba) \<in> D" 
     from pr1 have cr1: "aa = semI (ab, bb)" by auto
     from pr2 have cr2: "b = semI (ac, bc)" by auto
     from cr1 cr2 pr3 show "(a, (aa, b), ba)
       \<in> (\<lambda>x. case x of
               (q, xa, xb) \<Rightarrow>
                 (case xa of (a, b) \<Rightarrow> \<lambda>q'. (q, (semI a, semI b), q')) xb) `
          D"  
       apply (simp add: if_splits)
       by force
   qed

   from p1 p2 p3 p4 p5 p6 p7 p8 p9  this have pz1: "
                                    finite (\<Delta> \<A>) \<longrightarrow>
                                    (\<forall>DS. (\<forall>q a b aa ba.
  (\<exists>q'. (((a, b), aa, ba), q') \<in> DS q) \<longrightarrow> a \<le> b \<and> aa \<le> ba) \<longrightarrow>
                                          {(q, a \<inter> b, q') |q a b q'.
                                           (q, (a, b), q') \<in> ?D} =
                                          \<Delta> \<A> \<longrightarrow>
                                          set I = \<I> \<A> \<longrightarrow>
                                          (\<forall>FP.
  (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
  (\<forall>D_it.
      (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
           set_iterator (D_it q) (DS q) \<and>
           {(a, q'). (q, a, q') \<in> ?D} =
           (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) ` DS q) \<longrightarrow>
      invar (construct f I FP D_it) \<and>
      NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
       (NFA_remove_unreachable_states \<A>))))"
       by simp
  
  from p6 p7 have finiteA: "finite (\<Delta> \<A>)"
    apply (subgoal_tac "{(q, semI (a, b) \<inter> semI (aa, ba), q') |q a b aa ba q'.
     (q, ((a, b), aa, ba), q') \<in> D} = 
                        (\<lambda> (q, (a , b), q'). (q, (semI a) \<inter> (semI b), q')) ` D")
    using finite_imageI[OF p6, of "\<lambda> (q, (a , b), q'). (q, (semI a) \<inter> (semI b), q')"]
    apply simp
    apply (simp add: set_eq_iff)
    apply auto
    defer
     apply fastforce
  proof -
    fix a aa b
    assume pt1: "(a, aa, b) \<in> \<Delta> \<A>" 
    from pt1 p7
    show " (a, aa, b)
       \<in> (\<lambda>x. case x of
               (q, xa, xb) \<Rightarrow> (case xa of (a, b) \<Rightarrow> \<lambda>q'. (q, semI a \<inter> semI b, q')) xb) `
          D"
      using image_iff by fastforce
  qed
    
  from p1 p2 p3 p4 p5 p6 p7 p8 p9  finiteA this pz1 have "
  (\<forall>DS. (\<forall>q a b aa ba.
  (\<exists>q'. (((a, b), aa, ba), q') \<in> DS q) \<longrightarrow> a \<le> b \<and> aa \<le> ba) \<longrightarrow>
                                          {(q, a \<inter> b, q') |q a b q'.
                                           (q, (a, b), q') \<in> ?D} =
                                          \<Delta> \<A> \<longrightarrow>
                                          set I = \<I> \<A> \<longrightarrow>
                                          (\<forall>FP.
  (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
  (\<forall>D_it.
      (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
           set_iterator (D_it q) (DS q) \<and>
           {(a, q'). (q, a, q') \<in> ?D} =
           (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) ` DS q) \<longrightarrow>
      invar (construct f I FP D_it) \<and>
      NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
       (NFA_remove_unreachable_states \<A>))))"
    by simp

  from this have yu1:"(\<And>DS. (\<forall>q a b aa ba.
  (\<exists>q'. (((a, b), aa, ba), q') \<in> DS q) \<longrightarrow> a \<le> b \<and> aa \<le> ba) \<longrightarrow>
                                          {(q, a \<inter> b, q') |q a b q'.
                                           (q, (a, b), q') \<in> ?D} =
                                          \<Delta> \<A> \<longrightarrow>
                                          set I = \<I> \<A> \<longrightarrow>
                                          (\<forall>FP.
  (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
  (\<forall>D_it.
      (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
           set_iterator (D_it q) (DS q) \<and>
           {(a, q'). (q, a, q') \<in> ?D} =
           (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) 
            ` DS q) \<longrightarrow>
      invar (construct f I FP D_it) \<and>
      NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
       (NFA_remove_unreachable_states \<A>))))"
    by simp
  
  from p1 p2 p3 p4 p5 p6 p7 p8 p9  p11 yu1[of "\<lambda> q.{(a, q'). (q, a, q') \<in> D}"]
  have "(\<forall>q a b aa ba.
  (\<exists>q'. (((a, b), aa, ba), q') \<in> {(a, q'). (q, a, q') \<in> D}) \<longrightarrow> a \<le> b \<and> aa \<le> ba) \<longrightarrow>
                                          {(q, a \<inter> b, q') |q a b q'.
                                           (q, (a, b), q') \<in> ?D} =
                                          \<Delta> \<A> \<longrightarrow>
                                          set I = \<I> \<A> \<longrightarrow>
                                          (\<forall>FP.
  (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
  (\<forall>D_it.
      (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
           set_iterator (D_it q) ({(a, q'). (q, a, q') \<in> D}) \<and>
           {(a, q'). (q, a, q') \<in> ?D} =
           (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) 
            ` {(a, q'). (q, a, q') \<in> D}) \<longrightarrow>
      invar (construct f I FP D_it) \<and>
      NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
       (NFA_remove_unreachable_states \<A>)))"
    by simp

  from p1 p2 p3 p4 p5 p6 p7 p8 p9  p11 this have ck1: "
                  {(q, a \<inter> b, q') |q a b q'.
                                           (q, (a, b), q') \<in> ?D} =
                                          \<Delta> \<A> \<longrightarrow>
                                          set I = \<I> \<A> \<longrightarrow>
                                          (\<forall>FP.
  (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
  (\<forall>D_it.
      (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
           set_iterator (D_it q) ({(a, q'). (q, a, q') \<in> D}) \<and>
           {(a, q'). (q, a, q') \<in> ?D} =
           (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) 
            ` {(a, q'). (q, a, q') \<in> D}) \<longrightarrow>
      invar (construct f I FP D_it) \<and>
      NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
       (NFA_remove_unreachable_states \<A>)))"
    by simp
  from  p7 have "{(q, a \<inter> b, q') |q a b q'.
     (q, (a, b), q') \<in> {(q, (semI a, semI b), q') |q a b q'. (q, (a, b), q') \<in> D}} =
    \<Delta> \<A>"
    apply simp
    apply auto
    apply fastforce
  proof -
  fix a :: 'd and aa :: "'c set" and b :: 'd
  assume a1: "(a, aa, b) \<in> \<Delta> \<A>"
  assume "{(q, semI (a, b) \<inter> semI (aa, ba), q') |q a b aa ba q'. (q, ((a, b), aa, ba), q') \<in> D} = \<Delta> \<A>"
  then have "\<exists>d c ca cb cc da. (a, aa, b) = (d, semI (c, ca) \<inter> semI (cb, cc), da) \<and> (d, ((c, ca), cb, cc), da) \<in> D"
    using a1 by blast
  then show "\<exists>C Ca. aa = C \<inter> Ca \<and> (\<exists>c ca. C = semI (c, ca) \<and> (\<exists>cb cc. Ca = semI (cb, cc) \<and> (a, ((c, ca), cb, cc), b) \<in> D))"
    by (metis (no_types) Pair_inject)
qed
 from p1 p2 p3 p4 p5 p6 p7 p8 p9  p11 this ck1 have "
   set I = \<I> \<A> \<longrightarrow> (\<forall>FP.
  (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
  (\<forall>D_it.
      (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
           set_iterator (D_it q) ({(a, q'). (q, a, q') \<in> D}) \<and>
           {(a, q'). (q, a, q') \<in> ?D} =
           (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) 
            ` {(a, q'). (q, a, q') \<in> D}) \<longrightarrow>
      invar (construct f I FP D_it) \<and>
      NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
       (NFA_remove_unreachable_states \<A>)))"
   by simp

from p1 p2 p3 p4 p5 p6 p7 p8 p9 p11 this have "
    (\<forall>FP.
  (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow> FP q = (q \<in> \<F> \<A>)) \<longrightarrow>
  (\<forall>D_it.
      (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
           set_iterator (D_it q) ({(a, q'). (q, a, q') \<in> D}) \<and>
           {(a, q'). (q, a, q') \<in> ?D} =
           (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) 
            ` {(a, q'). (q, a, q') \<in> D}) \<longrightarrow>
      invar (construct f I FP D_it) \<and>
      NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
       (NFA_remove_unreachable_states \<A>)))"
    by simp

from p1 p2 p3 p4 p5 p6 p7 p8 p9 p11 this have "
  (\<forall>D_it.
      (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
           set_iterator (D_it q) ({(a, q'). (q, a, q') \<in> D}) \<and>
           {(a, q'). (q, a, q') \<in> ?D} =
           (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) 
            ` {(a, q'). (q, a, q') \<in> D}) \<longrightarrow>
      invar (construct f I FP D_it) \<and>
      NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
       (NFA_remove_unreachable_states \<A>))"
    by simp

from p1 p2 p3 p4 p5 p6 p7 p8 p9 p11 this have suc1: "
      (\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
           set_iterator (D_it q) ({(a, q'). (q, a, q') \<in> D}) \<and>
           {(a, q'). (q, a, q') \<in> ?D} =
           (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) 
            ` {(a, q'). (q, a, q') \<in> D}) \<longrightarrow>
      invar (construct f I FP D_it) \<and>
      NFA_isomorphic_wf (\<alpha> (construct f I FP D_it))
       (NFA_remove_unreachable_states \<A>)"
  by simp

from p2 p3 p4 p5 p6 p7 p8 p9 p11
  have "(\<forall>q. q \<in> \<Q> \<A> \<longrightarrow>
         set_iterator (D_it q) {(a, q'). (q, a, q') \<in> D} \<and>
         {(a, q').
          (q, a, q') \<in> {(q, (semI a, semI b), q') |q a b q'. (q, (a, b), q') \<in> D}} =
         (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) `
         {(a, q'). (q, a, q') \<in> D})"
    apply (rule_tac allI impI)+
  proof -
    fix q
    assume pi1: "\<forall>q. set_iterator (D_it q) {(a, q'). (q, a, q') \<in> D}"
    from this show "set_iterator (D_it q) {(a, q'). (q, a, q') \<in> D} \<and>
         {(a, q').
          (q, a, q') \<in> {(q, (semI a, semI b), q') |q a b q'. (q, (a, b), q') \<in> D}} =
         (\<lambda>x. case x of (a, x) \<Rightarrow> ((semI (fst a), semI (snd a)), x)) `
         {(a, q'). (q, a, q') \<in> D}"
      apply simp
      by force
  qed
    

from p2 p3 p4 p5 p6 p7 p8 p9 p11 this suc1 show "invar (construct f I FP D_it) \<and>
    NFA_isomorphic_wf (\<alpha> (construct f I FP D_it)) (NFA_remove_unreachable_states \<A>)"
    by simp
qed qed qed

  locale nfa_normalise = nfa +
    constrains \<alpha> :: "('q,'a,'nfa) nfa_\<alpha>"
    fixes normalise :: "'nfa \<Rightarrow> 'nfa" 
    assumes normalise_correct:
       "invar n \<Longrightarrow> invar (normalise n)"
       "invar n \<Longrightarrow> NFA_isomorphic_wf (\<alpha> (normalise n)) (NFA_remove_unreachable_states (\<alpha> n))"
  begin
    lemma normalise_correct___isomorphic:
       "invar n \<Longrightarrow> invar (normalise n)"
       "\<lbrakk>invar n; NFA_isomorphic_wf (\<alpha> n) (\<A> :: ('q2, 'a) NFA_rec)\<rbrakk> \<Longrightarrow> 
         NFA_isomorphic_wf (\<alpha> (normalise n)) (NFA_remove_unreachable_states \<A>)"
    proof -
      fix n
      assume invar_n: "invar n"
      with normalise_correct show invar_norm: "invar (normalise n)" by simp

      from normalise_correct[OF invar_n] 
      have iso_wf: "NFA_isomorphic_wf (\<alpha> (normalise n)) (NFA_remove_unreachable_states (\<alpha> n))"
        by simp

      assume "NFA_isomorphic_wf (\<alpha> n) (\<A> :: ('q2, 'a) NFA_rec)"
      note NFA_isomorphic_wf___NFA_remove_unreachable_states[OF this]
      from NFA_isomorphic_wf_trans[OF iso_wf this] 
      show "NFA_isomorphic_wf (\<alpha> (normalise n)) (NFA_remove_unreachable_states \<A>)" .
    qed
  end

locale nfa_bool_comb_gen = nfa \<alpha>1 invar1 + 
                           nfa \<alpha>2 invar2 + 
                           nfa \<alpha>3 invar3 + 
                           set \<alpha>4 invar4
    for \<alpha>1 :: "('q1,'a,'nfa1) nfa_\<alpha>" and invar1 and
        \<alpha>2 :: "('q2,'a,'nfa2) nfa_\<alpha>" and invar2 and
        \<alpha>3 :: "('q3,'a,'nfa3) nfa_\<alpha>" and invar3 and
        \<alpha>4 :: "'a_set \<Rightarrow> 'a set" and invar4 +
    fixes bool_comb :: 
          "'a_set \<Rightarrow> (bool \<Rightarrow> bool \<Rightarrow> bool) \<Rightarrow> 'nfa1 \<Rightarrow> 'nfa2 \<Rightarrow> 'nfa3"
    assumes bool_comb_correct_aux:
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> invar4 as  \<Longrightarrow> 
       invar3 (bool_comb as bc n1 n2) \<and>
       NFA_isomorphic_wf (\<alpha>3 (bool_comb as bc n1 n2)) 
                          (efficient_bool_comb_NFA bc (\<alpha>1 n1) (\<alpha>2 n2))"
  begin
    lemma bool_comb_correct:
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> invar4 as \<Longrightarrow> 
         invar3 (bool_comb as bc n1 n2)"
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> invar4 as \<Longrightarrow> 
         NFA_isomorphic_wf (\<alpha>3 (bool_comb as bc n1 n2)) 
         (efficient_bool_comb_NFA bc (\<alpha>1 n1) (\<alpha>2 n2))"
      using bool_comb_correct_aux by simp_all

    lemma bool_comb_correct___isomorphic:
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> invar4 as \<Longrightarrow> 
          invar3 (bool_comb as bc n1 n2)"
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> invar4 as \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha>1 n1) \<A>1 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha>2 n2) \<A>2 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha>3 (bool_comb as bc n1 n2)) (efficient_bool_comb_NFA bc \<A>1 \<A>2)"
      apply (simp add: bool_comb_correct)
      apply (insert bool_comb_correct(2)[of n1 n2 as bc]
                    NFA_isomorphic_efficient_bool_comb_NFA [of "\<alpha>1 n1" \<A>1 "\<alpha>2 n2" \<A>2 bc])
      apply (metis NFA_isomorphic_wf_trans)
    done
  end

  locale nfa_bool_comb = nfa \<alpha>1 invar1 + nfa \<alpha>2 invar2 + nfa \<alpha>3 invar3   
    for \<alpha>1 :: "('q1,'a::linorder,'nfa1) nfa_\<alpha>" and invar1 and
        \<alpha>2 :: "('q2,'a,'nfa2) nfa_\<alpha>" and invar2 and
        \<alpha>3 :: "('q3,'a,'nfa3) nfa_\<alpha>" and invar3 +
    fixes bool_comb :: "(bool \<Rightarrow> bool \<Rightarrow> bool) \<Rightarrow> 'nfa1 \<Rightarrow> 'nfa2 \<Rightarrow> 'nfa3"
  assumes bool_comb_correct_aux:
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> 
       invar3 (bool_comb bc n1 n2) \<and>
       NFA_isomorphic_wf (\<alpha>3 (bool_comb bc n1 n2)) 
         (efficient_bool_comb_NFA bc (\<alpha>1 n1) (\<alpha>2 n2))"
  begin
    lemma bool_comb_correct:
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> invar3 (bool_comb bc n1 n2)"
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> NFA_isomorphic_wf (\<alpha>3 (bool_comb bc n1 n2)) 
                                     (efficient_bool_comb_NFA bc (\<alpha>1 n1) (\<alpha>2 n2))"
      using bool_comb_correct_aux by (simp_all)

    lemma bool_comb_correct___isomorphic:
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow>  invar3 (bool_comb bc n1 n2)"
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha>1 n1) \<A>1 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha>2 n2) \<A>2 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha>3 (bool_comb bc n1 n2)) (efficient_bool_comb_NFA bc \<A>1 \<A>2)"
      apply (simp add: bool_comb_correct)
      apply (insert bool_comb_correct(2)[of n1 n2 bc]
                    NFA_isomorphic_efficient_bool_comb_NFA [of "\<alpha>1 n1" \<A>1 "\<alpha>2 n2" \<A>2 bc])
      apply (metis NFA_isomorphic_wf_trans)
    done
end



locale nfa_concat = nfa \<alpha>1 invar1 + nfa \<alpha>2 invar2 + nfa \<alpha>3 invar3   
    for \<alpha>1 :: "('q,'a::linorder,'nfa) nfa_\<alpha>" and invar1 and
        \<alpha>2 :: "('q,'a,'nfa) nfa_\<alpha>" and invar2 and
        \<alpha>3 :: "('q3,'a,'nfa1) nfa_\<alpha>" and invar3 +
    fixes concate :: "'nfa \<Rightarrow> 'nfa \<Rightarrow> 'nfa1"
  assumes nfa_concat_correct_aux:
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> 
       \<Q> (\<alpha>1 n1) \<inter> \<Q> (\<alpha>2 n2) = {} \<Longrightarrow>
       invar3 (concate n1 n2) \<and>
       NFA_isomorphic_wf (\<alpha>3 (concate n1 n2)) 
         (efficient_NFA_concatenation (\<alpha>1 n1) (\<alpha>2 n2))"
  begin
    lemma nfa_concat_correct:
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> \<Q> (\<alpha>1 n1) \<inter> \<Q> (\<alpha>2 n2) = {} \<Longrightarrow> invar3 (concate n1 n2)"
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> \<Q> (\<alpha>1 n1) \<inter> \<Q> (\<alpha>2 n2) = {} \<Longrightarrow> 
                                     NFA_isomorphic_wf (\<alpha>3 (concate n1 n2)) 
                                     (efficient_NFA_concatenation (\<alpha>1 n1) (\<alpha>2 n2))"
      using nfa_concat_correct_aux by (simp_all)

    lemma nfa_concat_correct___isomorphic:
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow>  \<Q> (\<alpha>1 n1) \<inter> \<Q> (\<alpha>2 n2) = {} \<Longrightarrow> invar3 (concate n1 n2)"
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha>1 n1) \<A>1 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha>2 n2) \<A>2 \<Longrightarrow> 
      \<Q> (\<alpha>1 n1) \<inter> \<Q> (\<alpha>2 n2) = {} \<Longrightarrow>
      \<Q> \<A>1 \<inter> \<Q> \<A>2 = {} \<Longrightarrow>
       NFA_isomorphic_wf (\<alpha>3 (concate n1 n2)) 
        (efficient_NFA_concatenation \<A>1 \<A>2)"
      apply (simp add: nfa_concat_correct_aux)
      apply (insert nfa_concat_correct(2)[of n1 n2]
             NFA_isomorphic_efficient_NFA_concatenation [of "\<alpha>1 n1" \<A>1 "\<alpha>2 n2" \<A>2])
      apply (metis NFA_isomorphic_wf_trans)
    done
end

locale nfa_concat_rename = nfa \<alpha>1 invar1 + nfa \<alpha>2 invar2 + nfa \<alpha>3 invar3   
    for \<alpha>1 :: "('q,'a::linorder,'nfa) nfa_\<alpha>" and invar1 and
        \<alpha>2 :: "('q,'a,'nfa) nfa_\<alpha>" and invar2 and
        \<alpha>3 :: "('q2,'a,'nfa1) nfa_\<alpha>" and invar3 +
      fixes concate :: "('q \<Rightarrow> 'q1) \<Rightarrow> ('q \<Rightarrow> 'q1) \<Rightarrow> 'nfa \<Rightarrow> 'nfa \<Rightarrow> 'nfa1" and
                 f1 :: "'q \<Rightarrow> 'q1" and
                 f2 :: "'q \<Rightarrow> 'q1"
  assumes nfa_rename_concat_correct_aux:
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> 
       inj_on f1 (\<Q> (\<alpha>1 n1)) \<Longrightarrow> 
       inj_on f2 (\<Q> (\<alpha>2 n2)) \<Longrightarrow>
       f1 ` (\<Q> (\<alpha>1 n1)) \<inter> f2 `(\<Q> (\<alpha>2 n2)) = {} \<Longrightarrow>
       invar3 (concate f1 f2 n1 n2) \<and>
       NFA_isomorphic_wf (\<alpha>3 (concate f1 f2 n1 n2)) 
         (efficient_NFA_rename_concatenation f1 f2 (\<alpha>1 n1) (\<alpha>2 n2))"
  begin
    lemma nfa_rename_concat_correct:
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> inj_on f1 (\<Q> (\<alpha>1 n1)) \<Longrightarrow> 
       f1 ` (\<Q> (\<alpha>1 n1)) \<inter> f2 ` (\<Q> (\<alpha>2 n2)) = {} \<Longrightarrow>
       inj_on f2 (\<Q> (\<alpha>2 n2)) \<Longrightarrow> invar3 (concate f1 f2 n1 n2)"
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> 
       inj_on f1 (\<Q> (\<alpha>1 n1)) \<Longrightarrow> 
       inj_on f2 (\<Q> (\<alpha>2 n2)) \<Longrightarrow>
       f1 ` (\<Q> (\<alpha>1 n1)) \<inter> f2 ` (\<Q> (\<alpha>2 n2)) = {} \<Longrightarrow>
       NFA_isomorphic_wf (\<alpha>3 (concate f1 f2 n1 n2)) 
               (efficient_NFA_rename_concatenation f1 f2 (\<alpha>1 n1) (\<alpha>2 n2))"
      using nfa_rename_concat_correct_aux[of n1 n2]
      by simp_all
      

    lemma nfa_rename_concat_correct___isomorphic:
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> inj_on f1 (\<Q> (\<alpha>1 n1)) \<Longrightarrow> 
       inj_on f2 (\<Q> (\<alpha>2 n2)) \<Longrightarrow> 
       f1 ` (\<Q> (\<alpha>1 n1)) \<inter> f2 ` (\<Q> (\<alpha>2 n2)) = {} \<Longrightarrow> invar3 (concate f1 f2 n1 n2)"
      "invar1 n1 \<Longrightarrow> invar2 n2 \<Longrightarrow> 
       inj_on f1 (\<Q> (\<alpha>1 n1)) \<Longrightarrow> 
       inj_on f2 (\<Q> (\<alpha>2 n2)) \<Longrightarrow>
       NFA_isomorphic_wf (\<alpha>1 n1) \<A>1 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha>2 n2) \<A>2 \<Longrightarrow> 
       inj_on f1' (\<Q> \<A>1) \<Longrightarrow> 
       inj_on f2' (\<Q> \<A>2) \<Longrightarrow>
      f1 ` \<Q> (\<alpha>1 n1) \<inter> f2 ` \<Q> (\<alpha>2 n2) = {} \<Longrightarrow>
      f1' ` (\<Q> \<A>1) \<inter> f2' ` (\<Q> \<A>2) = {} \<Longrightarrow>
       NFA_isomorphic_wf (\<alpha>3 (concate f1 f2 n1 n2)) 
        (efficient_NFA_rename_concatenation f1' f2' \<A>1 \<A>2)"
      apply (simp add: nfa_rename_concat_correct_aux)
      apply (insert nfa_rename_concat_correct(2)[of n1 n2]
             NFA_isomorphic_efficient_NFA_rename_concatenation 
             [of "\<alpha>1 n1" \<A>1 "\<alpha>2 n2" \<A>2 f1 f2 f1' f2'])
      apply (metis NFA_isomorphic_wf_trans)
    done
  end


  locale nfa_bool_comb_gen_same = nfa_bool_comb_gen \<alpha> invar \<alpha> invar \<alpha> invar \<alpha>_s invar_s bool_comb
    for \<alpha> :: "('q::{NFA_states},'a,'nfa1) nfa_\<alpha>" and invar and
        \<alpha>_s :: "'a_set \<Rightarrow> 'a set" and invar_s bool_comb
  begin
    lemma bool_comb_correct___same:
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> invar_s as \<Longrightarrow> 
         invar (bool_comb as bc n1 n2)"
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> invar_s as \<Longrightarrow> 
         NFA_isomorphic_wf (\<alpha> (bool_comb as bc n1 n2))
              (NFA_bool_comb bc (\<alpha> n1) (\<alpha> n2))"
       using bool_comb_correct [of n1 n2 as bc] nfa_axioms[unfolded nfa_def]
             NFA_bool_comb___isomorphic_wf [of "\<alpha> n1" "\<alpha> n2" bc]
       by (simp_all, metis NFA_isomorphic_wf_trans)

    lemma bool_comb_correct___same_isomorphic:
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> invar_s as \<Longrightarrow> 
          invar (bool_comb as bc n1 n2)"
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> invar_s as \<Longrightarrow> 
         
       NFA_isomorphic_wf (\<alpha> n1) \<A>1 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha> n2) \<A>2 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha> (bool_comb as bc n1 n2)) (NFA_bool_comb bc \<A>1 \<A>2)"
      apply (simp add: bool_comb_correct)
      apply (insert bool_comb_correct___isomorphic(2)[of n1 n2 as \<A>1 \<A>2 bc] 
             nfa_axioms[unfolded nfa_def]
             NFA_bool_comb___isomorphic_wf [of \<A>1 \<A>2 bc])
      apply (simp add: NFA_isomorphic_wf_refl)
      apply (metis NFA_isomorphic_wf_trans NFA_isomorphic_wf_alt_def)
    done
  end


  locale nfa_bool_comb_same = nfa_bool_comb \<alpha> invar \<alpha> invar \<alpha> invar bool_comb
    for \<alpha> :: "('q::{NFA_states},'a::linorder,'nfa1) nfa_\<alpha>" and invar bool_comb
  begin
    lemma bool_comb_correct___same:
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> 
       invar (bool_comb bc n1 n2)"
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> 
                NFA_isomorphic_wf (\<alpha> (bool_comb bc n1 n2))
              (NFA_bool_comb bc (\<alpha> n1) (\<alpha> n2))"
       using bool_comb_correct [of n1 n2 bc] nfa_axioms[unfolded nfa_def]
             NFA_bool_comb___isomorphic_wf [of "\<alpha> n1" "\<alpha> n2" bc]
       by (simp_all, metis NFA_isomorphic_wf_trans)

    lemma bool_comb_correct___same_isomorphic:
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> 
          invar (bool_comb bc n1 n2)"
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha> n1) \<A>1 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha> n2) \<A>2 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha> (bool_comb bc n1 n2)) (NFA_bool_comb bc \<A>1 \<A>2)"
      apply (simp add: bool_comb_correct)
      apply (insert bool_comb_correct___isomorphic(2)[of n1 n2 \<A>1 \<A>2 bc] 
             nfa_axioms[unfolded nfa_def]
             NFA_bool_comb___isomorphic_wf [of \<A>1 \<A>2 bc])
      apply (simp add: NFA_isomorphic_wf_refl)
      apply (metis NFA_isomorphic_wf_trans NFA_isomorphic_wf_alt_def)
    done
end

locale nfa_concat_same = nfa_concat \<alpha> invar \<alpha> invar \<alpha> invar concate
  for \<alpha> :: "('q::{NFA_states},'a::linorder,'nfa1) nfa_\<alpha>" and 
      invar concate
  begin
    lemma nfa_concate_correct___same:
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> \<Q> (\<alpha> n1) \<inter> \<Q> (\<alpha> n2) = {} \<Longrightarrow>
       invar (concate n1 n2)"
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> \<Q> (\<alpha> n1) \<inter> \<Q> (\<alpha> n2) = {} \<Longrightarrow>
                NFA_isomorphic_wf (\<alpha> (concate n1 n2))
              (NFA_concate (\<alpha> n1) (\<alpha> n2))"
       using nfa_concat_correct [of n1 n2] nfa_axioms[unfolded nfa_def]
             NFA_concate___isomorphic_wf [of "\<alpha> n1" "\<alpha> n2"]   
       by (simp_all, metis NFA_isomorphic_wf_trans)

    lemma nfa_concate_correct___same_isomorphic:
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> \<Q> (\<alpha> n1) \<inter> \<Q> (\<alpha> n2) = {} \<Longrightarrow>
          invar (concate n1 n2)"
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha> n1) \<A>1 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha> n2) \<A>2 \<Longrightarrow> 
       \<Q> (\<alpha> n1) \<inter> \<Q> (\<alpha> n2) = {} \<Longrightarrow>
       \<Q> \<A>1 \<inter> \<Q> \<A>2 = {} \<Longrightarrow>
       NFA_isomorphic_wf (\<alpha> (concate n1 n2)) (NFA_concate \<A>1 \<A>2)"
      apply (simp add: nfa_concat_correct)
      apply (insert nfa_concat_correct___isomorphic(2)[of n1 n2 \<A>1 \<A>2] 
             nfa_axioms[unfolded nfa_def]
              NFA_concate___isomorphic_wf [of \<A>1 \<A>2])
      apply (simp add: NFA_isomorphic_wf_refl)
      apply (metis NFA_isomorphic_wf_trans NFA_isomorphic_wf_alt_def)
    done
end


locale nfa_concat_rename_same = nfa_concat_rename \<alpha> invar \<alpha> invar \<alpha> invar concate
  for \<alpha> :: "('q::{NFA_states},'a::linorder,'nfa1) nfa_\<alpha>" and 
      invar concate
  begin
    lemma nfa_concate_correct___same:
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> \<Q> (\<alpha> n1) \<inter> \<Q> (\<alpha> n2) = {} \<Longrightarrow>
       inj_on f1 (\<Q> (\<alpha> n1)) \<Longrightarrow> inj_on f2 (\<Q> (\<alpha> n2)) \<Longrightarrow>
       (f1 ` \<Q> (\<alpha> n1) \<inter> f2 ` \<Q> (\<alpha> n2) = {}) \<Longrightarrow>
       invar (concate f1 f2 n1 n2)"
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> \<Q> (\<alpha> n1) \<inter> \<Q> (\<alpha> n2) = {} \<Longrightarrow>
       inj_on f1 (\<Q> (\<alpha> n1)) \<Longrightarrow> inj_on f2 (\<Q> (\<alpha> n2)) \<Longrightarrow>
       (f1 ` \<Q> (\<alpha> n1) \<inter> f2 ` \<Q> (\<alpha> n2) = {}) \<Longrightarrow>
                NFA_isomorphic_wf (\<alpha> (concate f1 f2 n1 n2))
              (NFA_concate (\<alpha> n1) (\<alpha> n2))"
       using nfa_rename_concat_correct [of n1 n2] nfa_axioms[unfolded nfa_def]
             NFA_concate_rename___isomorphic_wf [of "\<alpha> n1" "\<alpha> n2"]  
       apply auto
     proof -
       assume p1 : "invar n1"
          and p2 : "invar n2"
          and p3 : "\<Q> (\<alpha> n1) \<inter> \<Q> (\<alpha> n2) = {}"
          and p4 : "inj_on f1 (\<Q> (\<alpha> n1))"
          and p5 : "inj_on f2 (\<Q> (\<alpha> n2))"
          and p6 : "f1 ` \<Q> (\<alpha> n1) \<inter> f2 ` \<Q> (\<alpha> n2) = {}"
          and p7 : "NFA_isomorphic_wf (\<alpha> (concate f1 f2 n1 n2)) 
                    (efficient_NFA_rename_concatenation f1 f2 (\<alpha> n1) (\<alpha> n2))"
       from p1 
       have c1: "NFA (\<alpha> n1)"
         by (simp add: \<open>\<forall>n. invar n \<longrightarrow> NFA (\<alpha> n)\<close>)

       from p2 
       have c2: "NFA (\<alpha> n2)"
         by (simp add: \<open>\<forall>n. invar n \<longrightarrow> NFA (\<alpha> n)\<close>)
  
       from NFA_concate_rename___isomorphic_wf [of "\<alpha> n1" "\<alpha> n2"]
            c1 c2 p3 p4 p5 p6
       have c1: "NFA_isomorphic_wf (efficient_NFA_rename_concatenation f1 f2 (\<alpha> n1) (\<alpha> n2))
     (NFA_concate (\<alpha> n1) (\<alpha> n2))"
         by auto
       from  nfa_rename_concat_correct(2)[of n1 n2] c1 c2 p1 p2 p3 p4 p5 p6
       have "NFA_isomorphic_wf (\<alpha> (concate f1 f2 n1 n2))
             (efficient_NFA_rename_concatenation f1 f2 (\<alpha> n1) (\<alpha> n2))"
         by auto
      
       from this c1 NFA_isomorphic_wf_trans[of "(\<alpha> (concate f1 f2 n1 n2))"
            "(efficient_NFA_rename_concatenation f1 f2 (\<alpha> n1) (\<alpha> n2))"
            "(NFA_concate (\<alpha> n1) (\<alpha> n2))" ]
       show "NFA_isomorphic_wf (\<alpha> (concate f1 f2 n1 n2)) (NFA_concate (\<alpha> n1) (\<alpha> n2))"
         by auto qed 

    lemma nfa_concate_correct___same_isomorphic:
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> \<Q> (\<alpha> n1) \<inter> \<Q> (\<alpha> n2) = {} \<Longrightarrow>
       inj_on f1 (\<Q> (\<alpha> n1)) \<Longrightarrow> inj_on f2 (\<Q> (\<alpha> n2)) \<Longrightarrow>
       (f1 ` \<Q> (\<alpha> n1) \<inter> f2 ` \<Q> (\<alpha> n2) = {}) \<Longrightarrow>
          invar (concate f1 f2 n1 n2)"
      "invar n1 \<Longrightarrow> invar n2 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha> n1) \<A>1 \<Longrightarrow> 
       NFA_isomorphic_wf (\<alpha> n2) \<A>2 \<Longrightarrow> 
       \<Q> (\<alpha> n1) \<inter> \<Q> (\<alpha> n2) = {} \<Longrightarrow>
       \<Q> \<A>1 \<inter> \<Q> \<A>2 = {} \<Longrightarrow>
       inj_on f1 (\<Q> (\<alpha> n1)) \<Longrightarrow> inj_on f2 (\<Q> (\<alpha> n2)) \<Longrightarrow>
       (f1 ` \<Q> (\<alpha> n1) \<inter> f2 ` \<Q> (\<alpha> n2) = {}) \<Longrightarrow>
       NFA_isomorphic_wf (\<alpha> (concate f1 f2 n1 n2)) (NFA_concate \<A>1 \<A>2)"
      apply (simp add: nfa_rename_concat_correct)
      apply (insert nfa_rename_concat_correct___isomorphic(2)[of n1 n2 \<A>1 \<A>2] 
             nfa_axioms[unfolded nfa_def]
              NFA_concate_rename___isomorphic_wf [of \<A>1 \<A>2])
      apply (simp add: NFA_isomorphic_wf_refl)
      using NFA_isomorphic_wf_trans NFA_isomorphic_wf_alt_def
    proof -
      assume p1 : "invar n1"
          and p2 : "invar n2"
          and p3 : "\<Q> (\<alpha> n1) \<inter> \<Q> (\<alpha> n2) = {}"
          and p4 : "inj_on f1 (\<Q> (\<alpha> n1))"
          and p5 : "inj_on f2 (\<Q> (\<alpha> n2))"
          and p6 : "f1 ` \<Q> (\<alpha> n1) \<inter> f2 ` \<Q> (\<alpha> n2) = {}"
          and p8 : "NFA_isomorphic_wf (\<alpha> n1) \<A>1"
          and p9 : "NFA_isomorphic_wf (\<alpha> n2) \<A>2"
          and p10: "\<Q> \<A>1 \<inter> \<Q> \<A>2 = {}"
      from p10
      have "inj_on id (\<Q> \<A>1) \<and> inj_on id (\<Q> \<A>2) \<and> id ` \<Q> \<A>1 \<inter> id ` \<Q> \<A>2 = {} "
        by fastforce

      from this nfa_rename_concat_correct___isomorphic(2)
                [of n1 n2 \<A>1 \<A>2 id id, OF p1 p2 p4 p5 p8 p9 _ _ p6]
      have c1: "NFA_isomorphic_wf (\<alpha> (concate f1 f2 n1 n2))
            (efficient_NFA_rename_concatenation id id \<A>1 \<A>2)"
        by auto

      have c2: "NFA \<A>1"
        by (meson NFA_isomorphic_wf_D(2) p8)

      have c3: "NFA \<A>2"
        by (meson NFA_isomorphic_wf_D(2) p9)

      from p3 p4 p5 p6 p8 p9 p10
           NFA_concate_rename___isomorphic_wf [of \<A>1 \<A>2 id id, OF c2 c3]
      have c4: "NFA_isomorphic_wf (efficient_NFA_rename_concatenation id id \<A>1 \<A>2) 
           (NFA_concate \<A>1 \<A>2)"
        by auto

      from c1 c4 NFA_isomorphic_wf_trans
      show "NFA_isomorphic_wf (\<alpha> (concate f1 f2 n1 n2)) (NFA_concate \<A>1 \<A>2)"
        by auto
    qed


  end


  subsection \<open>  Record Based Interface \<close>

  record ('q,'a,'nfa) nfa_ops =
    nfa_op_\<alpha> :: "('q::{NFA_states},'a,'nfa) nfa_\<alpha>"
    nfa_op_invar :: "'nfa \<Rightarrow> bool"
    nfa_op_nfa_from_list_interval :: "('q,'a::linorder,'nfa) nfa_from_list_interval"
    nfa_op_bool_comb :: "(bool \<Rightarrow> bool \<Rightarrow> bool) \<Rightarrow> 'nfa \<Rightarrow> 'nfa \<Rightarrow> 'nfa"
    nfa_op_concate :: "'nfa \<Rightarrow> 'nfa \<Rightarrow> 'nfa"

  locale StdNFADefs =
    fixes ops :: "('q::{NFA_states},'a ::linorder ,'nfa) nfa_ops"
  begin
    abbreviation \<alpha> where "\<alpha> \<equiv> nfa_op_\<alpha> ops"
    abbreviation invar where "invar \<equiv> nfa_op_invar ops"
    abbreviation nfa_from_list_interval where "nfa_from_list_interval \<equiv> nfa_op_nfa_from_list_interval ops"
end



  locale StdNFA = StdNFADefs +
    nfa \<alpha> invar +
    nfa_from_list_interval \<alpha> invar nfa_from_list_interval 
  begin
  
    lemmas correct = nfa_from_list_interval_correct 

    lemmas correct_isomorphic = 
       nfa_from_list_interval_correct___isomorphic 
  
  end
end
