(*  Title:       Nondeterministic Finite Automata
    Authors:     Thomas Tuerk <tuerk@in.tum.de>
                 Petra Dietrich <petra@ecs.vuw.ac.nz>
*)

section \<open> Nondeterministic Finite Automata \<close>

theory NFA_Impl
imports Main 
        "HOL-Library.Code_Binary_Nat"
        "HOL-Library.Nat_Bijection"
        "../NFA_set"  
        "Collections.Collections"
    
begin

locale states_set_encodeCollections = set +
  constrains \<alpha> :: "'a \<Rightarrow> ('q :: {NFA_states}) set" 
  fixes states_set_encode_impl :: "'a \<Rightarrow> 'q"
  assumes states_set_encode_impl_correct:
    "invar s \<Longrightarrow> states_set_encode_impl s = states_set_encode (\<alpha> s)"


text \<open> Provide an instantiation for natural numbers.\<close>

definition set_encode_impl where
  "set_encode_impl it Q =
   it (\<lambda>(n::nat) (s::nat). s + 2 ^ n) Q 0"


lemma set_encode_impl_correct :
fixes \<alpha> :: "'s \<Rightarrow> nat set" 
assumes it_OK: "set_iterate \<alpha> invar it"
shows "states_set_encodeCollections \<alpha> invar (set_encode_impl it)"
proof 
  interpret it: set_iterate \<alpha> invar it by (fact it_OK)

  fix Q 
  assume invar_Q: "invar Q"

  show "set_encode_impl it Q = states_set_encode (\<alpha> Q)"
  unfolding set_encode_impl_def states_set_encode_nat_def
  proof (induct rule: it.iterate_rule_insert_P 
    [where I = "\<lambda>QQ n. set_encode QQ = n"])
    case (3 q it a) note assms=this

    from invar_Q have "finite (\<alpha> Q)" by simp

    with assms(2) have "finite it" by (metis finite_subset)
    with assms show ?case by simp
  qed (simp_all add: invar_Q)
qed


locale NFACollectionsLocale = 
    LTSCollectionsLocale set_opsQAQ set_opsQ set_opsA map_opsQAs map_opsQAq
    qaq_qaQ_iterate q_qaq_iterate q_qaQ_iterate qaQ_qaq_iterate qaQ_qaQ_iterate +
    q_qaQ_it: set_iterate qS.\<alpha> qS.invar q_qaQ_iterate +
    q_q_it: set_iterate qS.\<alpha> qS.invar q_q_iterate +
    q_Q_it: set_iterate qS.\<alpha> qS.invar q_Q_iterate +
    q_qq_it: set_iterate qS.\<alpha> qS.invar q_qq_iterate +
    q_split_it: set_iterate qS.\<alpha> qS.invar q_split_iterate +
    qaQ_qq_it: map_iterate qaQM.\<alpha> qaQM.invar qaQ_qq_iterate +
    q_image_filter: set_image_filter qS.\<alpha> qS.invar qS.\<alpha> qS.invar q_image_filter +
    a_image_filter: set_image_filter aS.\<alpha> aS.invar aS.\<alpha> aS.invar a_image_filter +
    qqM: StdMap map_opsQQ +
    st_set_encode: states_set_encodeCollections qS.\<alpha> qS.invar states_set_encode_impl
    for set_opsQAQ :: "(('q::{NFA_states} \<times> 'a \<times> 'q), 'qaq_set, 'qaq_more) set_ops_scheme"
    and set_opsQ   :: "('q, 'q_set, 'q_more) set_ops_scheme"
    and set_opsA   :: "('a, 'a_set, 'a_more) set_ops_scheme"
    and map_opsQAs :: "(('q \<times> 'a), 'q_set, 'qas_map, 'qas_more) map_ops_scheme"
    and map_opsQAq :: "(('q \<times> 'a), 'q, 'qa_map, 'qa_more) map_ops_scheme"
    and map_opsQQ :: "('q, 'q, 'q_map, 'qq_more) map_ops_scheme"
    and qaq_qaQ_iterate :: "('qaq_set,('q \<times> 'a \<times> 'q),'qas_map) iterator" 
    and q_q_iterate :: "('q_set,'q,'q) iterator" 
    and q_Q_iterate :: "('q_set,'q,'q_set) iterator" 
    and q_qq_iterate :: "('q_set,'q,'q_map) iterator" 
    and q_split_iterate :: "('q_set,'q,('q \<times> 'q_set) \<times> ('q \<times> 'q_set)) iterator" 
    and q_qaq_iterate :: "('q_set,'q,'qaq_set) iterator" 
    and q_qaQ_iterate :: "('q_set,'q,'qas_map) iterator" 
    and qaQ_qaq_iterate :: "('qas_map,('q \<times> 'a), 'q_set,'qaq_set) map_iterator" 
    and qaQ_qq_iterate :: "('qas_map,('q \<times> 'a), 'q_set,'qq_map) map_iterator" 
    and qaQ_qaQ_iterate :: "('qas_map,('q \<times> 'a), 'q_set,'qas_map) map_iterator" 
    and q_image_filter :: "('q \<Rightarrow> 'q option) \<Rightarrow> 'q_set \<Rightarrow> 'q_set" 
    and a_image_filter :: "('a \<Rightarrow> 'a option) \<Rightarrow> 'a_set \<Rightarrow> 'a_set" 
    and states_set_encode_impl :: "'q_set \<Rightarrow> 'q" +
    assumes no_invar_qqM [simp]: "\<And>s. qqM.invar s"
begin


subsection {* Wellformedness *}


subsection {* Constructing / Destructing Automata *}


fun destruct_NFA_collect_aux ::
  "'q \<Rightarrow> 'q \<Rightarrow> 'a list  \<Rightarrow> ('q \<times> 'a \<times> 'q) list \<Rightarrow> ('q \<times> 'a \<times> 'q) list \<Rightarrow> 
   'a list \<times> ('q \<times> 'a \<times> 'q) list"
where
  "destruct_NFA_collect_aux q1 q2 as L [] = (as, L)"
 |"destruct_NFA_collect_aux q1 q2 as L ((q1', a, q2') # D) =
   (if ((q1 = q1') \<and> (q2 = q2')) then
     (destruct_NFA_collect_aux q1 q2 (a # as) L D)
   else
     (destruct_NFA_collect_aux q1 q2 as ((q1', a, q2') # L) D)
   )"




subsection {* remove states *}

definition remove_states_impl_trans where
  "remove_states_impl_trans m D =
   image_filter_trans (\<lambda>(qa, Q).
     (if (qS.memb (fst qa) D) then None else
     (Some (qa, qS.diff Q D)))) m"


lemma remove_states_impl_trans_correct :
"LTS_succ_map_\<alpha> (remove_states_impl_trans m D) =
 { (s1,a,s2) . (s1,a,s2) \<in> LTS_succ_map_\<alpha> m \<and> s1 \<notin> qS.\<alpha> D \<and> s2 \<notin> qS.\<alpha> D}"

apply (simp add: remove_states_impl_trans_def 
                 image_filter_trans_correct qS.correct)
apply (auto simp add: LTS_succ_map_\<alpha>_def MS.in_map_set_\<alpha>)
done


definition remove_states_impl where
  "remove_states_impl A S =
   (qS.diff (NFA_Impl_states A) S,
    NFA_Impl_labels A,
    remove_states_impl_trans (NFA_Impl_trans A) S,
    qS.diff (NFA_Impl_initial A) S,
    qS.diff (NFA_Impl_accepting A) S)"

lemma remove_states_impl_correct :
  "NFA_Impl_\<alpha> (remove_states_impl A S) =
   remove_states (NFA_Impl_\<alpha> A) (qS.\<alpha> S)"
by (simp add: NFA_Impl_\<alpha>_def remove_states_def
  remove_states_impl_def qS.correct
  remove_states_impl_trans_correct)

lemma remove_states_impl_code :
  "remove_states_impl (Q, A, D, I, F) S =
   (qS.diff Q S,
    A,
    image_filter_trans
     (\<lambda>(qa, Q). if qS.memb (fst qa) S then None else Some (qa, qS.diff Q S))
     D,
    qS.diff I S,
    qS.diff F S)"
by (simp add: remove_states_impl_def remove_states_impl_trans_def)


fun remove_unreachable_states_impl :: "'q_set \<times> 'a_set \<times> 'qas_map \<times> 'q_set \<times> 'q_set \<Rightarrow> 'q_set \<times> 'a_set \<times> 'qas_map \<times> 'q_set \<times> 'q_set" where
 "remove_unreachable_states_impl (Q, A, D, I, F) =
  construct_reachable_NFA_impl id A (qS.to_list I)
    (\<lambda>q. qS.memb q F)
    (\<lambda>qa. case qaQM.lookup qa D of None \<Rightarrow> [] | Some Ns \<Rightarrow> qS.to_list Ns)"

lemma remove_unreachable_states_impl_correct :
assumes wf_AA: "NFA (NFA_Impl_\<alpha> AA)"
shows "NFA_Impl_\<alpha> (remove_unreachable_states_impl AA) =
       remove_unreachable_states (NFA_Impl_\<alpha> AA)"
proof -
  obtain Q A D I F where AA_eq: "AA = (Q, A, D, I, F)" by (cases AA, blast)

  let ?FP = "\<lambda>q. qS.memb q F"
  let ?D = "\<lambda>qa. let Ns_opt = qaQM.lookup qa D in 
         case Ns_opt of None \<Rightarrow> [] | Some Ns \<Rightarrow> qS.to_list Ns"

  have inj_id: "inj_on id (qS.\<alpha> Q)"
    unfolding inj_on_def by simp
  have finite_Q: "finite (qS.\<alpha> Q)" by simp

  note NFA.\<I>_consistent [OF wf_AA]
  hence I_in: "set (qS.to_list I) \<subseteq> (qS.\<alpha> Q)"
    unfolding AA_eq NFA_Impl_\<alpha>_def
    by (simp add: qS.correct)


  with NFA.\<Delta>_consistent [OF wf_AA] 
  have "\<And>q \<sigma> Q q'. \<lbrakk>qaQM.\<alpha> D (q, \<sigma>) = Some Q; q' \<in> qS.\<alpha> Q\<rbrakk> \<Longrightarrow> \<sigma> \<in> aS.\<alpha> A"
    unfolding AA_eq NFA_Impl_\<alpha>_def 
    by (auto simp add: LTS_succ_map_\<alpha>_in)
  hence D_eq: "construct_reachable_NFA_wsa_D_\<alpha> (aS.to_list A) ?D =
        LTS_succ_map_\<alpha> D"
    unfolding construct_reachable_NFA_wsa_D_\<alpha>_def LTS_succ_map_\<alpha>_def
    apply(auto simp add: qS.correct aS.correct qaQM.correct MS.in_map_set_\<alpha>)  
    apply metis
  done

  have D_in: "\<And>q \<sigma> q'.
    (q, \<sigma>, q') \<in> construct_reachable_NFA_wsa_D_\<alpha> (aS.to_list A) ?D \<Longrightarrow> q' \<in> qS.\<alpha> Q"
    using NFA.\<Delta>_consistent [OF wf_AA] 
    unfolding AA_eq NFA_Impl_\<alpha>_def D_eq 
    by simp

  from D_in construct_reachable_NFA_impl_correct_simple 
    [OF inj_id finite_Q I_in, 
     where A = A and FP = ?FP and D = ?D]
  have "NFA_Impl_\<alpha> (remove_unreachable_states_impl AA) = 
        construct_reachable_NFA (qS.\<alpha> I) (aS.\<alpha> A)
          (\<lambda>q. q \<in> qS.\<alpha> F \<and> q \<in> qS.\<alpha> Q)
          {(q, \<sigma>, q') | q \<sigma> q'. q \<in> qS.\<alpha> Q \<and> (q, \<sigma>, q') \<in> LTS_succ_map_\<alpha> D}"
    unfolding AA_eq
    unfolding remove_unreachable_states_impl.simps D_eq
    by (simp add: qS.correct)

  also have "... =
        construct_reachable_NFA (qS.\<alpha> I) (aS.\<alpha> A)
          (\<lambda>q. q \<in> qS.\<alpha> F)
          (LTS_succ_map_\<alpha> D)"
  proof -
    have FP_OK: "(\<lambda>q. (q \<in> qS.\<alpha> F \<and> q \<in> qS.\<alpha> Q)) = (\<lambda>q. (q \<in> qS.\<alpha> F))"
      using NFA.\<F>_consistent [OF wf_AA]
      apply (simp add: fun_eq_iff AA_eq NFA_Impl_\<alpha>_def)
      apply auto
    done

    have D_OK: "{(q, \<sigma>, q') | q \<sigma> q'. q \<in> qS.\<alpha> Q \<and> (q, \<sigma>, q') \<in> LTS_succ_map_\<alpha> D} =
                LTS_succ_map_\<alpha> D"
      using NFA.\<Delta>_consistent [OF wf_AA]
      apply (simp add: set_eq_iff AA_eq NFA_Impl_\<alpha>_def)
      apply auto
    done

    from FP_OK D_OK show ?thesis by simp
  qed
 
  also have "... = remove_unreachable_states (NFA_Impl_\<alpha> AA)"
    unfolding NFA.remove_unreachable_states_implementation [OF wf_AA]
    unfolding AA_eq NFA_Impl_\<alpha>_def
    by simp

  finally show ?thesis .
qed


subsection {* rename states *}

definition rename_states_impl_trans where
  "rename_states_impl_trans f m =
   image_filter_trans (\<lambda>((q,a), Q).
     (case f q of None \<Rightarrow> None 
                | Some q' \<Rightarrow>
     (Some ((q',a), q_image_filter f Q)))) m"


lemma rename_states_impl_trans_correct :
"LTS_succ_map_\<alpha> (rename_states_impl_trans f m) =
 { (q1,a,q2) | q1 q2 q1' a q2'. (q1',a,q2') \<in> LTS_succ_map_\<alpha> m \<and> (f q1' = Some q1) \<and> (f q2' = Some q2)}"
apply (simp add: rename_states_impl_trans_def image_filter_trans_correct
                 q_image_filter.image_filter_correct
            split: option.split)
apply (auto simp add: LTS_succ_map_\<alpha>_expand)
apply metis
apply (metis the.simps)
done


definition rename_states_impl where
  "rename_states_impl f A =
   (q_image_filter f (NFA_Impl_states A),
    NFA_Impl_labels A,
    rename_states_impl_trans f (NFA_Impl_trans A),
    q_image_filter f (NFA_Impl_initial A),
    q_image_filter f (NFA_Impl_accepting A))"


lemma rename_states_impl_correct :
assumes wf_A: "NFA (NFA_Impl_\<alpha> A)"
    and f_ft_eq: "\<And>q. q \<in> qS.\<alpha> (NFA_Impl_states A) \<Longrightarrow> (f q = Some (ft q))"
shows "NFA_Impl_\<alpha> (rename_states_impl f A) =
       rename_states (NFA_Impl_\<alpha> A) ft"
proof -
  obtain QL AL DL IL FL where A_eq: "A = (QL, AL, DL, IL, FL)" by (cases A, blast)

  from f_ft_eq A_eq 
  have image_f_correct: 
     "\<And>S. qS.\<alpha> S \<subseteq> qS.\<alpha> QL \<Longrightarrow> qS.\<alpha> (q_image_filter f S) = ft ` (qS.\<alpha> S)"
  by (simp add: q_image_filter.image_filter_correct subset_iff, auto)

  from wf_A have "qS.\<alpha> QL \<subseteq> qS.\<alpha> QL \<and>
                  qS.\<alpha> IL \<subseteq> qS.\<alpha> QL \<and>
                  qS.\<alpha> FL \<subseteq> qS.\<alpha> QL"
    by (simp add: NFA_def A_eq NFA_Impl_\<alpha>_def)
  with image_f_correct have images_correct :
    "qS.\<alpha> (q_image_filter f QL) = ft ` (qS.\<alpha> QL) \<and>
     qS.\<alpha> (q_image_filter f IL) = ft ` (qS.\<alpha> IL) \<and>
     qS.\<alpha> (q_image_filter f FL) = ft ` (qS.\<alpha> FL)" by simp

  have DL_correct: "LTS_succ_map_\<alpha> (rename_states_impl_trans f DL) =
          {(ft q1, a, ft q2) |q1 a q2. (q1, a, q2) \<in> LTS_succ_map_\<alpha> DL}"
        (is "?s1 = ?s2")
  proof (intro set_eqI iffI)
    fix qaq :: "'q \<times> 'a \<times> 'q"
    obtain q1 a q2 where qaq_eq: "qaq = (q1, a, q2)" by (cases qaq, blast)

    from wf_A 
    have DL_wf: "\<And>q1' a q2'. (q1', a, q2') \<in> LTS_succ_map_\<alpha> DL \<Longrightarrow>
      q1' \<in> qS.\<alpha> QL \<and> q2' \<in> qS.\<alpha> QL"
       by (simp add: A_eq NFA_Impl_\<alpha>_def NFA_def)

    {
      assume "qaq \<in> ?s1"
      then obtain q1' q2' where q12'_eqns:
        "(q1', a, q2') \<in> LTS_succ_map_\<alpha> DL \<and> f q1' = Some q1 \<and> f q2' = Some q2"
        by (simp add: rename_states_impl_trans_correct qaq_eq, metis)
      hence "q1' \<in> qS.\<alpha> QL \<and> q2' \<in> qS.\<alpha> QL" by (metis DL_wf)
      with q12'_eqns f_ft_eq have "ft q1' = q1 \<and> ft q2' = q2"
        by (simp add: A_eq)
      with q12'_eqns show "qaq \<in> ?s2"
        by (auto simp add: qaq_eq)
    }

    {
      assume "qaq \<in> ?s2"
      then obtain q1' q2' where q12'_eqns:
        "(q1', a, q2') \<in> LTS_succ_map_\<alpha> DL \<and> ft q1' = q1 \<and> ft q2' = q2"
           by (auto simp add: qaq_eq)
      hence "q1' \<in> qS.\<alpha> QL \<and> q2' \<in> qS.\<alpha> QL" by (metis DL_wf)
      with q12'_eqns f_ft_eq have "f q1' = (Some q1) \<and> f q2' = Some q2"
        by (simp add: A_eq)
      with q12'_eqns show "qaq \<in> ?s1"
        by (simp add: rename_states_impl_trans_correct qaq_eq, metis)
    }
  qed

  from images_correct DL_correct show ?thesis
    by (simp add: NFA_Impl_\<alpha>_def rename_states_def
         rename_states_impl_def A_eq)
qed


subsection {* rename letters *}

definition rename_labels_impl_trans where
  "rename_labels_impl_trans f m =
   image_filter_trans (\<lambda>((q,a), Q).
     (case f a of None \<Rightarrow> None 
                | Some a' \<Rightarrow>
     (Some ((q,a'), Q)))) m"

lemma rename_labels_impl_trans_correct :
"LTS_succ_map_\<alpha> (rename_labels_impl_trans f m) =
 { (q1,a,q2) | q1 a a' q2. (q1,a',q2) \<in> LTS_succ_map_\<alpha> m \<and> (f a' = Some a)}"
apply (simp add: rename_labels_impl_trans_def image_filter_trans_correct
                 q_image_filter.image_filter_correct
            split: option.split)
apply (auto simp add: LTS_succ_map_\<alpha>_expand)
apply metis
apply (metis the.simps)
done


definition rename_labels_impl where
  "rename_labels_impl f A =
   (NFA_Impl_states A,
    a_image_filter f (NFA_Impl_labels A),
    rename_labels_impl_trans f (NFA_Impl_trans A),
    NFA_Impl_initial A,
    NFA_Impl_accepting A)"

lemma rename_labels_impl_correct :
assumes wf_A: "NFA (NFA_Impl_\<alpha> A)"
    and f_ft_eq: "\<And>q. q \<in> aS.\<alpha> (NFA_Impl_labels A) \<Longrightarrow> (f q = Some (ft q))"
shows "NFA_Impl_\<alpha> (rename_labels_impl f A) =
       rename_labels (NFA_Impl_\<alpha> A) ft"
proof -
  obtain QL AL DL IL FL where A_eq: "A = (QL, AL, DL, IL, FL)" by (cases A, blast)

  from A_eq f_ft_eq
  have image_correct: 
     "aS.\<alpha> (a_image_filter f AL) = ft ` (aS.\<alpha> AL)"
  by (simp add: a_image_filter.image_filter_correct subset_iff, auto)

  have DL_correct: "LTS_succ_map_\<alpha> (rename_labels_impl_trans f DL) =
          {(q1, ft a, q2) | q1 a q2. (q1, a, q2) \<in> LTS_succ_map_\<alpha> DL}"
        (is "?s1 = ?s2")
  proof (intro set_eqI iffI)
    fix qaq :: "'q \<times> 'a \<times> 'q"
    obtain q1 a q2 where qaq_eq: "qaq = (q1, a, q2)" by (cases qaq, blast)

    from wf_A 
    have DL_wf: "\<And>q1' a q2'. (q1', a, q2') \<in> LTS_succ_map_\<alpha> DL \<Longrightarrow> a \<in> aS.\<alpha> AL"
       by (simp add: A_eq NFA_Impl_\<alpha>_def NFA_def)

    {
      assume "qaq \<in> ?s1"
      then obtain a' where a'_eqns:
        "(q1, a', q2) \<in> LTS_succ_map_\<alpha> DL \<and> f a' = Some a"
        by (simp add: rename_labels_impl_trans_correct qaq_eq, metis)
      hence "a' \<in> aS.\<alpha> AL" by (metis DL_wf)
      with a'_eqns f_ft_eq have "ft a' = a" by (simp add: A_eq)
      with a'_eqns show "qaq \<in> ?s2"
        by (auto simp add: qaq_eq)
    }

    {
      assume "qaq \<in> ?s2"
      then obtain a' where a'_eqns:
        "(q1, a', q2) \<in> LTS_succ_map_\<alpha> DL \<and> ft a' = a"
           by (auto simp add: qaq_eq)
      hence "a' \<in> aS.\<alpha> AL" by (metis DL_wf)
      with a'_eqns f_ft_eq have "f a' = (Some a)" by (simp add: A_eq)
      with a'_eqns show "qaq \<in> ?s1"
        by (simp add: rename_labels_impl_trans_correct qaq_eq, metis)
    }
  qed

  from image_correct DL_correct show ?thesis
    by (simp add: NFA_Impl_\<alpha>_def rename_labels_def
        rename_labels_impl_def A_eq)
qed

(* Play around with renaming states *)

definition normalise_states where
  "normalise_states A =
   (let fm = snd (foldl (\<lambda>(n, fm) q.
        (Suc n, qqM.update_dj q (states_enumerate n) fm))
        (0, qqM.empty)
        (qS.to_list (NFA_Impl_states A))) in
    rename_states_impl (\<lambda>k. qqM.lookup k fm) A)"

lemma normalise_states_correct :
assumes wf_A : "NFA (NFA_Impl_\<alpha> A)"
shows "NFA_isomorphic_wf (NFA_Impl_\<alpha> (normalise_states A)) (NFA_Impl_\<alpha> A)"
proof -
  def fm_gen \<equiv> "\<lambda>l n fm. (snd (foldl (\<lambda>(n, fm) q.
        (Suc n, qqM.update_dj q (states_enumerate n) fm))
        (n, fm) l))"

  have fm_gen_props: "\<And>l n fm. 
    \<lbrakk>dom (qqM.\<alpha> fm) \<inter> set l = {}; distinct l;
     inj_on (qqM.\<alpha> fm) (dom (qqM.\<alpha> fm));
     (\<forall>q q'. qqM.\<alpha> fm q = Some q' \<longrightarrow> (\<exists>n'. n' < n \<and> q' = states_enumerate n'))\<rbrakk> \<Longrightarrow>
    ((dom (qqM.\<alpha> (fm_gen l n fm)) = dom (qqM.\<alpha> fm) \<union> set l) \<and>
    inj_on (qqM.\<alpha> (fm_gen l n fm)) (dom (qqM.\<alpha> fm) \<union> set l))"
  proof -
    fix l n fm
    show "
    \<lbrakk>dom (qqM.\<alpha> fm) \<inter> set l = {}; distinct l;
     inj_on (qqM.\<alpha> fm) (dom (qqM.\<alpha> fm));
     (\<forall>q q'. qqM.\<alpha> fm q = Some q' \<longrightarrow> (\<exists>n'. n' < n \<and> q' = states_enumerate n'))\<rbrakk> \<Longrightarrow>
    ((dom (qqM.\<alpha> (fm_gen l n fm)) = dom (qqM.\<alpha> fm) \<union> set l) \<and>
    inj_on (qqM.\<alpha> (fm_gen l n fm)) (dom (qqM.\<alpha> fm) \<union> set l))"
    proof (induct l arbitrary: n fm)
      case Nil thus ?case
        by (simp add: fm_gen_def)
    next
      case (Cons q l n fm)
      note ind_hyp = Cons(1)
      from Cons(2) have dom_disj: "dom (qqM.\<alpha> fm) \<inter> set l = {}" and 
          q_nin_dom: "q \<notin> dom (qqM.\<alpha> fm)" by simp_all
      from Cons(3) have q_nin: "q \<notin> set l" and dist_l: "distinct l" by simp_all
      note inj_fm = Cons(4)
      note enum_fm = Cons(5)

      def fm' \<equiv> "qqM.update_dj q (states_enumerate n) fm"
      have fm_gen_step: "fm_gen (q # l) n fm =
                         fm_gen l (Suc n) fm'"
        unfolding fm_gen_def fm'_def by simp
      have fm'_alpha: "qqM.\<alpha> fm' = (qqM.\<alpha> fm) (q \<mapsto> (states_enumerate n))"
        by (simp add: fm'_def qqM.correct q_nin_dom)
      have dom_fm': "dom (qqM.\<alpha> fm') = insert q (dom (qqM.\<alpha> fm))" 
        unfolding fm'_alpha by auto

      have inj_fm': "inj_on (qqM.\<alpha> fm') (dom (qqM.\<alpha> fm'))"
      unfolding inj_on_def dom_fm'
      proof (intro ballI impI)
        fix q1 q2
        assume q1_in: "q1 \<in> insert q (dom (qqM.\<alpha> fm))"
        assume q2_in: "q2 \<in> insert q (dom (qqM.\<alpha> fm))"
        assume fn_q12_eq: "(qqM.\<alpha> fm') q1 = (qqM.\<alpha> fm') q2"

        have enum_dist: "\<And>q' q''. qqM.\<alpha> fm q' = Some q'' \<Longrightarrow> q'' \<noteq> states_enumerate n"
        proof -
          fix q' q''
          assume "qqM.\<alpha> fm q' = Some q''"
          with enum_fm obtain n' where n'_le: "n' < n" and q''_eq: "q'' = states_enumerate n'"
            by auto
          thus "q'' \<noteq> states_enumerate n"
            by (simp add: states_enumerate_eq)
        qed

        from q1_in q2_in fn_q12_eq
        show "q1 = q2"
        unfolding fm'_alpha
          apply (cases "q1 = q")
            apply (cases "q2 = q") 
              apply simp
              apply (simp, metis enum_dist) 
            apply (cases "q2 = q") 
              apply (simp, metis enum_dist) 
              apply (simp, metis inj_fm inj_on_def)
        done
      qed

      have enum_fm': "\<forall>q q'. qqM.\<alpha> fm' q = Some q' \<longrightarrow>
                     (\<exists>n'<Suc n. q' = states_enumerate n')"
        using enum_fm unfolding fm'_alpha
        by auto (metis less_Suc_eq)

      from dom_disj q_nin have dom_disj_fm': "dom (qqM.\<alpha> fm') \<inter> set l = {}"
        unfolding dom_fm' by auto

      note ind_hyp [of "fm'" "Suc n", OF dom_disj_fm' dist_l inj_fm' enum_fm']
      thus ?case
        by (simp add: fm_gen_step dom_fm')
    qed
  qed

  def fm \<equiv> "qqM.\<alpha> (fm_gen (qS.to_list (NFA_Impl_states A)) 0 qqM.empty)"

  from fm_gen_props [of "qqM.empty" "qS.to_list (NFA_Impl_states A)" 0]
  have fm_props: "dom fm = qS.\<alpha> (NFA_Impl_states A) \<and>
                  inj_on fm (qS.\<alpha> (NFA_Impl_states A))"
    by (simp add: qqM.correct qS.correct fm_def[symmetric])

  from fm_props have dom_fm: "\<And>q. q \<in> (\<Q> (NFA_Impl_\<alpha> A)) \<Longrightarrow> ~(fm q = None)" 
    by (auto simp add: domIff NFA_Impl_\<alpha>_simp2)   
  with fm_props have part1: "inj_on (\<lambda>k. the (fm k)) (\<Q> (NFA_Impl_\<alpha> A))"
    by (simp add: inj_on_def Ball_def NFA_Impl_\<alpha>_simp2, metis the.simps)

  have part2: "NFA_Impl_\<alpha> (normalise_states A) =
               rename_states (NFA_Impl_\<alpha> A) (\<lambda>k. the (fm k))"
   unfolding normalise_states_def Let_def
  proof (rule rename_states_impl_correct [OF wf_A])
    fix q
    assume "q \<in> qS.\<alpha> (NFA_Impl_states A)"
    with dom_fm obtain q' where fm_q: "fm q = Some q'" by (auto simp add: NFA_Impl_\<alpha>_simp2)

    with fm_def fm_gen_def
    show "qqM.lookup q (snd (foldl
                (\<lambda>(n, fm) q. (Suc n, map_op_update_dj map_opsQQ q (states_enumerate n) fm))
                (0, map_op_empty map_opsQQ)
                (set_op_to_list set_opsQ (NFA_Impl_states A)))) =
          Some (the (fm q))"
      by (simp add: qqM.correct)
  qed

  from part1 part2 have equiv: "NFA_isomorphic (NFA_Impl_\<alpha> A) 
    (NFA_Impl_\<alpha> (normalise_states A))" unfolding NFA_isomorphic_def by auto

  from NFA_isomorphic_sym_impl [OF wf_A equiv]
       NFA_isomorphic___well_formed [OF wf_A equiv] 
  show "NFA_isomorphic_wf (NFA_Impl_\<alpha> (normalise_states A)) (NFA_Impl_\<alpha> A)" 
    unfolding NFA_isomorphic_wf_def ..
qed


subsection {* Product Automata *}

definition states_cross_product_list where
  "states_cross_product_list = (\<lambda>Q1 Q2.
     [(q1, q2). q1 \<leftarrow> (qS.to_list Q1), q2 \<leftarrow> (qS.to_list Q2)])"

lemma states_cross_product_list___set [simp] :
  "set (states_cross_product_list Q1 Q2) = qS.\<alpha> Q1 \<times> qS.\<alpha> Q2"
unfolding states_cross_product_list_def
by (auto simp add: qS.correct)


fun bool_comb_NFA_impl :: 
  "(bool \<Rightarrow> bool \<Rightarrow> bool) \<Rightarrow>
   ('q_set \<times> 'a_set \<times> 'qas_map \<times> 'q_set \<times> 'q_set) \<Rightarrow> 
   ('q_set \<times> 'a_set \<times> 'qas_map \<times> 'q_set \<times> 'q_set) \<Rightarrow> 
   'q_set \<times> 'a_set \<times> 'qas_map \<times> 'q_set \<times> 'q_set" where
 "bool_comb_NFA_impl bc (Q1, A1, D1, I1, F1) (Q2, A2, D2, I2, F2) =
  construct_reachable_NFA_impl states_prod_encode
    (aS.inter A1 A2) 
    (states_cross_product_list I1 I2)
    (\<lambda>(q1, q2). bc (qS.memb q1 F1) (qS.memb q2 F2)) 
    (\<lambda>((q1, q2), a).      
        (case qaQM.lookup (q1,a) D1 of None \<Rightarrow> [] | Some Ns1 \<Rightarrow> 
         (case qaQM.lookup (q2,a) D2 of None \<Rightarrow> [] | Some Ns2 \<Rightarrow> 
           (states_cross_product_list Ns1 Ns2))))"


lemma bool_comb_NFA_impl_correct :
assumes wf_AA1: "NFA (NFA_Impl_\<alpha> AA1)"
    and wf_AA2: "NFA (NFA_Impl_\<alpha> AA2)"
shows "NFA_Impl_\<alpha> (bool_comb_NFA_impl bc AA1 AA2) =
       efficient_bool_comb_NFA___same_states bc (NFA_Impl_\<alpha> AA1) (NFA_Impl_\<alpha> AA2)" 
proof -
  obtain Q1 A1 D1 I1 F1 where AA1_eq: "AA1 = (Q1, A1, D1, I1, F1)" by (cases AA1, blast)
  obtain Q2 A2 D2 I2 F2 where AA2_eq: "AA2 = (Q2, A2, D2, I2, F2)" by (cases AA2, blast)

  let ?D = "(\<lambda>((q1, q2), a).      
        (case qaQM.lookup (q1,a) D1 of None \<Rightarrow> [] | Some Ns1 \<Rightarrow> 
         (case qaQM.lookup (q2,a) D2 of None \<Rightarrow> [] | Some Ns2 \<Rightarrow> 
           (states_cross_product_list Ns1 Ns2))))"

  have fin_S: "finite (qS.\<alpha> Q1 \<times> qS.\<alpha> Q2)" by simp
  have init_S: "set (states_cross_product_list I1 I2) \<subseteq> (qS.\<alpha> Q1 \<times> qS.\<alpha> Q2)"
    using NFA.\<I>_consistent [OF wf_AA1] NFA.\<I>_consistent [OF wf_AA2]
    unfolding AA1_eq AA2_eq NFA_Impl_\<alpha>_def
    by auto

  have D_eq: "construct_reachable_NFA_wsa_D_\<alpha> (aS.to_list (aS.inter A1 A2)) ?D =
       product (LTS_succ_map_\<alpha> D1) (LTS_succ_map_\<alpha> D2)"
       (is "?ls = ?rs") 
  proof (rule set_eqI)
    fix qaq :: "('q \<times> 'q) \<times> 'a \<times> ('q \<times> 'q)"
    obtain q1 q2 \<sigma> q1' q2' where qaq_eq: "qaq = ((q1, q2), \<sigma>, (q1', q2'))" 
      apply (cases qaq, rename_tac q a q1' q2')
      apply (case_tac q, blast)
    done

    have "qaq \<in> ?rs \<Longrightarrow> \<sigma> \<in> aS.\<alpha> A1 \<inter> aS.\<alpha> A2"
      using NFA.\<Delta>_consistent [OF wf_AA1] 
      using NFA.\<Delta>_consistent [OF wf_AA2] 
      unfolding AA1_eq AA2_eq NFA_Impl_\<alpha>_def qaq_eq 
      by auto
    thus "qaq \<in> ?ls = (qaq \<in> ?rs)"
      unfolding qaq_eq  
      unfolding construct_reachable_NFA_wsa_D_\<alpha>_def 
      apply (simp add: qS.correct aS.correct qaQM.correct
               LTS_succ_map_\<alpha>_def MS.in_map_set_\<alpha>)
      apply metis
    done
  qed

  have D_in: "\<And>q \<sigma> q'. (q, \<sigma>, q') \<in> construct_reachable_NFA_wsa_D_\<alpha> (aS.to_list (aS.inter A1 A2)) ?D \<Longrightarrow> q' \<in> qS.\<alpha> Q1 \<times> qS.\<alpha> Q2"
    using NFA.\<Delta>_consistent [OF wf_AA1] 
    using NFA.\<Delta>_consistent [OF wf_AA2] 
    unfolding AA1_eq AA2_eq NFA_Impl_\<alpha>_def D_eq 
    by auto

  from construct_reachable_NFA_impl_correct_simple [of states_prod_encode
    "qS.\<alpha> Q1 \<times> qS.\<alpha> Q2"
    "states_cross_product_list I1 I2"
    "aS.inter A1 A2" ?D 
    "\<lambda>(q1, q2). bc (qS.memb q1 F1) (qS.memb q2 F2)",
     OF states_prod_encode_inj_on fin_S init_S] D_in
  have step1: "NFA_Impl_\<alpha> (bool_comb_NFA_impl bc AA1 AA2) = 
    rename_states
        (construct_reachable_NFA (qS.\<alpha> I1 \<times> qS.\<alpha> I2)
          (aS.\<alpha> A1 \<inter> aS.\<alpha> A2)
          (\<lambda>q. (case q of
                (q1, q2) \<Rightarrow> bc (q1 \<in> qS.\<alpha>  F1) (q2 \<in> qS.\<alpha>  F2)) \<and>
               q \<in> qS.\<alpha>  Q1 \<times> qS.\<alpha>  Q2)
          {(q, a, q') |q a q'.
           q \<in> qS.\<alpha> Q1 \<times> qS.\<alpha> Q2 \<and>
           (fst q, a, fst q') \<in> LTS_succ_map_\<alpha> D1 \<and> (snd q, a, snd q') \<in> LTS_succ_map_\<alpha> D2})
        states_prod_encode" (is "_ = rename_states ?const _")
    unfolding bool_comb_NFA_impl.simps AA1_eq AA2_eq
     by (simp add: aS.correct qS.correct D_eq)

  have step2: "?const = efficient_bool_comb_NFA bc (NFA_Impl_\<alpha> AA1) (NFA_Impl_\<alpha> AA2)"
  proof -
    have D_OK: "{(q, a, q') |q a q'.
           q \<in> qS.\<alpha> Q1 \<times> qS.\<alpha> Q2 \<and>
           (fst q, a, fst q') \<in> LTS_succ_map_\<alpha> D1 \<and> (snd q, a, snd q') \<in> LTS_succ_map_\<alpha> D2}
          = product (LTS_succ_map_\<alpha> D1) (LTS_succ_map_\<alpha> D2)"
      using NFA.\<Delta>_consistent [OF wf_AA1]
      using NFA.\<Delta>_consistent [OF wf_AA2]
      unfolding AA1_eq AA2_eq 
      by (auto simp add: NFA_Impl_\<alpha>_def)

    have FP_OK: "(\<lambda>q. (case q of (q1, q2) \<Rightarrow> bc (q1 \<in> qS.\<alpha> F1) (q2 \<in> qS.\<alpha> F2)) \<and>
          q \<in> qS.\<alpha> Q1 \<times> qS.\<alpha> Q2) =
        (\<lambda>q. q \<in> qS.\<alpha> Q1 \<times> qS.\<alpha> Q2 \<and> bc (fst q \<in> qS.\<alpha> F1) (snd q \<in> qS.\<alpha> F2))"
      using NFA.\<F>_consistent [OF wf_AA1]
      using NFA.\<F>_consistent [OF wf_AA2]
      unfolding AA1_eq AA2_eq 
      apply (simp add: NFA_Impl_\<alpha>_def fun_eq_iff) 
      apply blast
    done

    show ?thesis 
      using efficient_bool_comb_NFA_compute [OF wf_AA1 wf_AA2] D_OK FP_OK
      unfolding AA1_eq AA2_eq
      by (simp add: NFA_Impl_\<alpha>_def)
  qed
  
  from step1 step2 show ?thesis
    unfolding efficient_bool_comb_NFA___same_states_def
    by simp
qed

lemma bool_comb_NFA_impl_correct_2 :
assumes wf_AA1: "NFA (NFA_Impl_\<alpha> AA1)"
    and wf_AA2: "NFA (NFA_Impl_\<alpha> AA2)"
shows "NFA_isomorphic_wf (NFA_Impl_\<alpha> (bool_comb_NFA_impl bc AA1 AA2)) 
                         (efficient_bool_comb_NFA bc (NFA_Impl_\<alpha> AA1) (NFA_Impl_\<alpha> AA2))"
using efficient_bool_comb_NFA___same_states___isomorphic_wf [OF wf_AA1 wf_AA2, of bc]
      bool_comb_NFA_impl_correct[OF wf_AA1 wf_AA2, of bc]
by simp (metis NFA_isomorphic_wf_sym)

fun product_NFA_impl where
  "product_NFA_impl (Q1, A1, D1, I1, F1) (Q2, A2, D2, I2, F2) =
   bool_comb_NFA_impl op\<and> (Q1, A1, D1, I1, F1) (Q2, A2, D2, I2, F2)"

lemma product_NFA_impl_code :
  "product_NFA_impl (Q1, A1, D1, I1, F1) (Q2, A2, D2, I2, F2) =
   construct_reachable_NFA_impl states_prod_encode
    (aS.inter A1 A2) 
    (states_cross_product_list I1 I2)
    (\<lambda>(q1, q2). (qS.memb q1 F1) \<and> (qS.memb q2 F2)) 
    (\<lambda>((q1, q2), a).      
        (case qaQM.lookup (q1,a) D1 of None \<Rightarrow> [] | Some Ns1 \<Rightarrow> 
         (case qaQM.lookup (q2,a) D2 of None \<Rightarrow> [] | Some Ns2 \<Rightarrow> 
           (states_cross_product_list Ns1 Ns2))))"
unfolding product_NFA_impl.simps
unfolding bool_comb_NFA_impl.simps
by simp

lemma product_NFA_impl_correct :
assumes wf_AA1: "NFA (NFA_Impl_\<alpha> AA1)"
    and wf_AA2: "NFA (NFA_Impl_\<alpha> AA2)"
shows "NFA_Impl_\<alpha> (product_NFA_impl AA1 AA2) =
       efficient_product_NFA___same_states (NFA_Impl_\<alpha> AA1) (NFA_Impl_\<alpha> AA2)"
proof -
  obtain Q1 A1 D1 I1 F1 where AA1_eq: "AA1 = (Q1, A1, D1, I1, F1)" by (cases AA1, blast)
  obtain Q2 A2 D2 I2 F2 where AA2_eq: "AA2 = (Q2, A2, D2, I2, F2)" by (cases AA2, blast)

  from bool_comb_NFA_impl_correct [of AA1 AA2 "op\<and>",
     OF wf_AA1 wf_AA2]
  show ?thesis
    unfolding product_NFA_impl.simps AA1_eq AA2_eq efficient_product_NFA___same_states_alt_def
    by (simp add: NFA_Impl_\<alpha>_def qS.correct)
qed
    
lemma bool_comb_NFA_impl___equiv :
fixes A1 :: "('q, 'a) NFA_rec"
fixes A2 :: "('q, 'a) NFA_rec"
assumes equiv_1: "NFA_isomorphic_wf (NFA_Impl_\<alpha> Ai1) A1"
    and equiv_2: "NFA_isomorphic_wf (NFA_Impl_\<alpha> Ai2) A2"
shows "NFA_isomorphic_wf (NFA_Impl_\<alpha>
          (bool_comb_NFA_impl bc Ai1 Ai2))
          (efficient_bool_comb_NFA___same_states bc A1 A2)"
proof -
  note wf_A1 = NFA_isomorphic_wf_D(1) [OF equiv_1]
  note wf_A2 = NFA_isomorphic_wf_D(1) [OF equiv_2]

  note step1 = NFA_isomorphic_bool_comb_NFA [OF equiv_1 equiv_2, of bc]
  note step2 = NFA_isomorphic_remove_unreachable_states [OF step1, 
    folded efficient_bool_comb_NFA_def]
  note step3 = NFA_isomorphic_wf_rename_states_frame [OF 
    states_prod_encode_inj_on states_prod_encode_inj_on step2]

  from step3 bool_comb_NFA_impl_correct [OF wf_A1 wf_A2, of bc]
  show ?thesis
    unfolding efficient_bool_comb_NFA___same_states_def
    by simp
qed

subsection {* Reverse *}

fun reverse_NFA_impl where
  "reverse_NFA_impl (Q, A, D, I, F) =
   (Q, A, LTS_reverse_impl D, F, I)"

lemma reverse_NFA_impl_correct :
"NFA_Impl_\<alpha> (reverse_NFA_impl AA) =
 reverse (NFA_Impl_\<alpha> AA)"
apply (cases AA)
apply (simp add: NFA_Impl_\<alpha>_def reverse_def
   LTS_reverse_impl_correct)
done

subsection {* Complement *}

fun complement_DFA_impl where
  "complement_DFA_impl (Q, A, D, I, F) =
   (Q, A, D, I, qS.diff Q F)"

lemma complement_DFA_impl_correct :
"NFA_Impl_\<alpha> (complement_DFA_impl AA) =
 complement (NFA_Impl_\<alpha> AA)"
apply (cases AA)
apply (simp add: qS.correct NFA_Impl_\<alpha>_def complement_def)
done


subsection {* Right Quotient *}

fun right_quotient_NFA_impl where
  "right_quotient_NFA_impl QA (Q, A, D, I, F) =
   (Q, A, D, I, LTS_accessible_impl QA (LTS_reverse_impl D) F)"

lemma right_quotient_NFA_impl_correct :
assumes wf_AA: "NFA (NFA_Impl_\<alpha> AA)" 
shows "NFA_Impl_\<alpha> (right_quotient_NFA_impl QA AA) =
       right_quotient_NFA (NFA_Impl_\<alpha> AA) (lists (set QA))"
proof -
  obtain Q A D I F where AA_eq: "AA = (Q, A, D, I, F)" by (cases AA, blast)
  

  from NFA.\<Delta>_cons___is_reachable [OF reverse___well_formed [OF wf_AA]]
       NFA.\<F>_consistent [OF wf_AA]
  show ?thesis
    unfolding AA_eq right_quotient_NFA___alt_def NFA_Impl_\<alpha>_def reverse_def 
  apply (simp add:
          LTS_accessible_impl_correct accessible_def
          rtrancl_LTS_forget_labels_pred Bex_def
          LTS_reverse_impl_correct subset_iff)
  apply (simp del: ex_simps add: set_eq_iff ex_simps[symmetric])
  apply blast
  done
qed


subsection {* Determinism check *}

fun is_deterministic_NFA_impl where
  "is_deterministic_NFA_impl (Q, A, D, I, F) =
   (LTS_is_deterministic_impl Q A D \<and>
    qS.isSng I)"

lemma is_deterministic_NFA_impl_correct :
"is_deterministic_NFA_impl AA \<longleftrightarrow>
 is_deterministic_NFA (NFA_Impl_\<alpha> AA)"
apply (cases AA)
apply (simp add: NFA_Impl_\<alpha>_def is_deterministic_NFA_def
   LTS_is_deterministic_impl_correct qS.correct)
done


subsection {* Determinisation *}

fun NFA_determinise_raw_impl :: 
  "('q_set \<times> 'a_set \<times> 'qas_map \<times> 'q_set \<times> 'q_set) \<Rightarrow> 
   'q_set \<times> 'a_set \<times> 'qas_map \<times> 'q_set \<times> 'q_set" where
 "NFA_determinise_raw_impl (Q, A, D, I, F) =
  construct_reachable_NFA_impl states_set_encode_impl A 
    [I]
    (\<lambda>q. \<not>(qS.disjoint q F)) 
    (\<lambda>(Q, a). 
        [q_Q_iterate (\<lambda>q Q'.      
        (case qaQM.lookup (q,a) D of None \<Rightarrow> Q' | Some Ns \<Rightarrow> 
         qS.union Q' Ns)) Q qS.empty])"
    
lemma NFA_determinise_raw_impl_correct :
assumes wf_AA: "NFA (NFA_Impl_\<alpha> AA)"
shows "NFA_Impl_\<alpha> (NFA_determinise_raw_impl AA) =
       efficient_NFA_determinise___same_states (NFA_Impl_\<alpha> AA)"
proof -
  obtain Q A D I F where AA_eq: "AA = (Q, A, D, I, F)" by (cases AA, blast)

  let ?S = "Pow (qS.\<alpha> Q)"
  let ?FP = "\<lambda>q. \<not>(qS.disjoint q F)"
  let ?FP' = "\<lambda>q. q \<inter> qS.\<alpha> F \<noteq> {}"

  obtain Dfun where Dfun_eq: "Dfun = (\<lambda>Q a. q_Q_iterate (\<lambda>q Q'.      
        (case qaQM.lookup (q,a) D of None \<Rightarrow> Q' | Some Ns \<Rightarrow> 
         qS.union Q' Ns)) Q qS.empty)" by blast
  obtain D' where D'_eq : "D' = (\<lambda>(Q, a). [Dfun Q a])" by blast

  have D''_eq: "construct_reachable_NFA_wsa_D_\<alpha> (aS.to_list A) D' = 
     {(q, a, Dfun q a) |q a. (a \<in> aS.\<alpha> A)}"
    unfolding construct_reachable_NFA_wsa_D_\<alpha>_def
    by (simp add: aS.correct D'_eq)

  have Dfun_sem : "\<And>Q a. qS.\<alpha> (Dfun Q a) = 
     {q'. (\<exists>q \<in> qS.\<alpha> Q. (q, a, q') \<in> LTS_succ_map_\<alpha> D)}"
  proof -
  fix Q a
  show "qS.\<alpha> (Dfun Q a) = 
     {q'. (\<exists>q \<in> qS.\<alpha> Q. (q, a, q') \<in> LTS_succ_map_\<alpha> D)}"
  unfolding Dfun_eq
  proof (induct rule: q_Q_it.iterate_rule_insert_P 
      [where ?I = "\<lambda>Q S. qS.\<alpha> S = 
     {q'. (\<exists>q \<in> Q. (q, a, q') \<in> LTS_succ_map_\<alpha> D)}"])
     case (3 q it S) note assms = this
     thus ?case
       apply (simp add: qaQM.correct LTS_succ_map_\<alpha>_in 
         qS.correct Collect_disj_eq
         split: option.split)
       apply auto
     done
  qed (simp_all add: qS.correct)
  qed

  note impl_correct0 = construct_reachable_NFA_impl_correct [of states_set_encode_impl
    states_set_encode qS.\<alpha> ?S ?FP ?FP' A D' "[I]"]
 
  have step1: "NFA_Impl_\<alpha> (NFA_determinise_raw_impl AA) =
     rename_states
      (construct_reachable_NFA (qS.\<alpha> ` set [I]) (aS.\<alpha> A)
        (\<lambda>Q. Q \<inter> qS.\<alpha> F \<noteq> {} \<and> Q \<in> ?S)
        {(qS.\<alpha> q, a, qS.\<alpha> q') |q a q'. qS.\<alpha> q \<in> ?S \<and> (q, a, q') \<in> 
          construct_reachable_NFA_wsa_D_\<alpha> (aS.to_list A) D'})
      states_set_encode" (is "_ = rename_states ?const _")
    unfolding NFA_determinise_raw_impl.simps AA_eq D'_eq [symmetric, unfolded Dfun_eq]
    proof (rule impl_correct0)
      show "states_set_encode_impl = states_set_encode \<circ> qS.\<alpha>"
        by (simp add: fun_eq_iff states_set_encode_impl_correct)
    next
      show "finite ?S" by simp
    next
      show "inj_on states_set_encode ?S"
        unfolding inj_on_def Ball_def
      proof (intro allI impI)
        fix x y
        assume x_in: "x \<in> ?S"
        assume y_in: "y \<in> ?S"
        assume enc_eq: "(states_set_encode x) = (states_set_encode y)"

        have finite_Q: "finite (qS.\<alpha> Q)" by simp
        from x_in have fin_x : "finite x"
          by (simp, metis finite_Q finite_subset)
        from y_in have fin_y : "finite y"
          by (simp, metis finite_Q finite_subset)

        from fin_x fin_y enc_eq 
        show "x = y"
          by (simp add: states_set_encode_eq)
      qed
    next
      show "\<And>q. ?FP q \<longleftrightarrow> ?FP' (qS.\<alpha> q)"
        by (simp add: qS.correct)
    next
      show "qS.\<alpha> ` (set [I]) \<subseteq> ?S"
        using NFA.\<I>_consistent [OF wf_AA]
        by (simp add: AA_eq NFA_Impl_\<alpha>_def)
    next
      fix q \<sigma> q'
      assume "(q, \<sigma>, q')  \<in> construct_reachable_NFA_wsa_D_\<alpha> (aS.to_list A) D'"
      with NFA.\<Delta>_consistent [OF wf_AA]
      show "qS.\<alpha> q' \<in> ?S"
        apply (simp add: D''_eq Dfun_sem AA_eq NFA_Impl_\<alpha>_def)
        apply auto
      done
    next
      fix q1 q2 a q1'
      assume q1_equiv: "qS.\<alpha> q1 = qS.\<alpha> q2"
      assume "(q1, a, q1') \<in> construct_reachable_NFA_wsa_D_\<alpha> (aS.to_list A) D'"
      hence q1'_eq: "q1' = Dfun q1 a \<and> a \<in> aS.\<alpha> A" by (simp add: D''_eq)

      hence q2'_in: "(q2, a, Dfun q2 a) \<in> construct_reachable_NFA_wsa_D_\<alpha> (aS.to_list A) D'"
        by (simp add: D''_eq)

      from q1_equiv 
      have q1'_equiv: "qS.\<alpha> q1' = qS.\<alpha> (Dfun q2 a)"
        by (simp add: q1'_eq Dfun_sem)
      from q1'_equiv q2'_in show
         "\<exists>q2'. qS.\<alpha> q1' = qS.\<alpha> q2' \<and>
                (q2, a, q2')
                \<in> construct_reachable_NFA_wsa_D_\<alpha> (set_op_to_list set_opsA A)
                   D'" by blast
    qed

  have step2 : "?const = efficient_NFA_determinise (NFA_Impl_\<alpha> AA)"
  proof -  
    have FP_OK: 
     "(\<lambda>Qa. Qa \<inter> qS.\<alpha> F \<noteq> {} \<and> Qa \<subseteq> qS.\<alpha> Q) =
      (\<lambda>Qa. Qa \<subseteq> qS.\<alpha> Q \<and> Qa \<inter> qS.\<alpha> F \<noteq> {})"
     by (simp add: fun_eq_iff, auto)

    have D_OK: "
     {(qS.\<alpha> q, a, qS.\<alpha> q') |q a q'. qS.\<alpha> q \<subseteq> qS.\<alpha> Q \<and>
      (q, a, q') \<in> construct_reachable_NFA_wsa_D_\<alpha> (aS.to_list A) D'} =
     {(Qa, \<sigma>, {q'. \<exists>q\<in>Qa. (q, \<sigma>, q') \<in> LTS_succ_map_\<alpha> D}) |Qa \<sigma>.
      Qa \<subseteq> qS.\<alpha> Q \<and> \<sigma> \<in> aS.\<alpha> A}" (is "?s1 = ?s2")
    proof (intro set_eqI iffI)
      fix x
      assume "x \<in> ?s1"
      thus "x \<in> ?s2" 
        by (auto simp add: D''_eq Dfun_sem)
    next
      fix x
      assume "x \<in> ?s2"
      then obtain QQ a 
        where x_eq: "x = (QQ, a, {q'. \<exists>q\<in>QQ. (q, a, q') \<in> LTS_succ_map_\<alpha> D})"
          and QQ_sub: "QQ \<subseteq> qS.\<alpha> Q" 
          and a_in: "a \<in> aS.\<alpha> A" by auto

      have "finite (qS.\<alpha> Q)" by simp
      with QQ_sub have "finite QQ" by (rule finite_subset)
      then obtain QQQ where QQQ_\<alpha>: "qS.\<alpha> QQQ = QQ"
        using qS.encoding_exists by blast
      
      show "x \<in> ?s1"
        apply (auto simp add: D''_eq Dfun_sem)
        apply (rule exI [where x = QQQ])
        apply (rule exI [where x = a])
        apply (simp add: QQQ_\<alpha> x_eq a_in QQ_sub)
      done
    qed

    show ?thesis
      using NFA.efficient_NFA_determinise_compute [OF wf_AA]
      unfolding AA_eq
      by (simp add: NFA_Impl_\<alpha>_def D_OK FP_OK)
  qed

  from step1 step2 show ?thesis 
    unfolding efficient_NFA_determinise___same_states_def 
    by simp
qed    

definition NFA_determinise_impl where
 "NFA_determinise_impl AA =
  normalise_states (NFA_determinise_raw_impl AA)"

lemma NFA_determinise_impl_correct :
assumes wf_AA: "NFA (NFA_Impl_\<alpha> AA)"
shows "NFA_isomorphic_wf (NFA_Impl_\<alpha> (NFA_determinise_impl AA)) 
                         (efficient_NFA_determinise___same_states (NFA_Impl_\<alpha> AA))"
proof -
  note impl_alpha = NFA_determinise_raw_impl_correct [OF wf_AA]

  from efficient_NFA_determinise___same_states___isomorphic_wf [OF wf_AA]
  have wf_alpha: "NFA (NFA_Impl_\<alpha> (NFA_determinise_raw_impl AA))"
    unfolding NFA_isomorphic_wf_alt_def impl_alpha by simp

  from wf_alpha
  have iso1: "NFA_isomorphic_wf (NFA_Impl_\<alpha> (NFA_determinise_raw_impl AA))
           (efficient_NFA_determinise___same_states (NFA_Impl_\<alpha> AA))" 
    by (simp add: impl_alpha NFA_isomorphic_wf_refl)

  note iso2 = normalise_states_correct [OF wf_alpha]

  from NFA_isomorphic_wf_trans [OF iso2 iso1]
  show ?thesis
    unfolding NFA_determinise_impl_def .
qed


subsection {* Brzozowski minimisation *}

definition Brzozowski_halfway_impl where
 "Brzozowski_halfway_impl AA =
  NFA_determinise_impl (reverse_NFA_impl AA)"

lemma Brzozowski_halfway_impl_correct :
assumes wf_AA: "NFA (NFA_Impl_\<alpha> AA)"
shows "NFA_isomorphic_wf (NFA_Impl_\<alpha> (Brzozowski_halfway_impl AA)) 
                         (Brzozowski_halfway___same_states (NFA_Impl_\<alpha> AA))"
proof -
  from NFA_determinise_impl_correct [of "reverse_NFA_impl AA"]
  show ?thesis
    unfolding Brzozowski_halfway___same_states_def efficient_NFA_determinise_def[symmetric]
              Brzozowski_halfway_impl_def    
    by (simp add: reverse_NFA_impl_correct reverse___well_formed [OF wf_AA])
qed

lemma Brzozowski_halfway_impl_correct_2 :
assumes wf_AA: "NFA (NFA_Impl_\<alpha> AA)"
shows "NFA_isomorphic_wf (NFA_Impl_\<alpha> (Brzozowski_halfway_impl AA)) 
                         (Brzozowski_halfway (NFA_Impl_\<alpha> AA))"
using Brzozowski_halfway_impl_correct [OF wf_AA]
      Brzozowski_halfway___same_states___isomorphic_wf [OF wf_AA]
by (metis NFA_isomorphic_wf_sym NFA_isomorphic_wf_trans)

definition Brzozowski_impl where
 "Brzozowski_impl AA =
  Brzozowski_halfway_impl (
    Brzozowski_halfway_impl (
      normalise_states AA
    )
  )"

lemma Brzozowski_impl_correct :
assumes wf_AA: "NFA (NFA_Impl_\<alpha> AA)"
shows "NFA_isomorphic_wf (NFA_Impl_\<alpha> (Brzozowski_impl AA)) 
                         (Brzozowski___same_states (NFA_Impl_\<alpha> AA))"
proof -
  note step1 = normalise_states_correct [OF wf_AA]

  have step_thm: "\<And>AA \<A>::('q, 'a) NFA_rec. NFA_isomorphic_wf (NFA_Impl_\<alpha> AA) \<A> \<Longrightarrow>
                    NFA_isomorphic_wf (NFA_Impl_\<alpha> (Brzozowski_halfway_impl AA))
                                      (Brzozowski_halfway___same_states \<A>)"
  proof -
    fix AA 
    fix \<A> :: "('q, 'a) NFA_rec"
    assume pre: "NFA_isomorphic_wf (NFA_Impl_\<alpha> AA) \<A>"
    note stepa = Brzozowski_halfway_impl_correct [OF NFA_isomorphic_wf_D(1) [OF pre]]
    note stepb = iffD1 [OF NFA_isomorphic_wf_sym
      Brzozowski_halfway___same_states___isomorphic_wf  [OF NFA_isomorphic_wf_D(1) [OF pre]]]
    note stepc = NFA_isomorphic_Brzozowski_halfway [OF pre]
    note stepd = Brzozowski_halfway___same_states___isomorphic_wf  [OF NFA_isomorphic_wf_D(2) [OF pre]]

    from stepa stepb stepc stepd show 
      "NFA_isomorphic_wf (NFA_Impl_\<alpha> (Brzozowski_halfway_impl AA))
                         (Brzozowski_halfway___same_states \<A>)"
      by (metis NFA_isomorphic_wf_trans)
  qed

  note step2 = step_thm [OF step1]
  note step3 = step_thm [OF step2]

  from step3 show ?thesis 
    unfolding Brzozowski_impl_def Brzozowski___same_states_def
    .
qed

lemma Brzozowski_impl_correct_2 :
assumes wf_AA: "NFA (NFA_Impl_\<alpha> AA)"
shows "NFA_isomorphic_wf (NFA_Impl_\<alpha> (Brzozowski_impl AA)) 
                         (Brzozowski (NFA_Impl_\<alpha> AA))"
proof -
  note step1 = Brzozowski_impl_correct [OF wf_AA]
  note step2 = iffD1 [OF NFA_isomorphic_wf_sym
      Brzozowski___same_states___isomorphic_wf [OF wf_AA]]
  from NFA_isomorphic_wf_trans [OF step1 step2]
  show ?thesis .
qed


subsection {* Hopcroft's Minimisation *}

definition `_wa_lists_impl_\<alpha>_L where
 "Hopcroft_wa_lists_impl_\<alpha>_L L =
  map (\<lambda>(as, p). (aS.\<alpha> as, qS.\<alpha> p)) L"

lemma Hopcroft_wa_lists_impl_\<alpha>_L_Nil [simp] :
 "Hopcroft_wa_lists_impl_\<alpha>_L [] = []"
unfolding Hopcroft_wa_lists_impl_\<alpha>_L_def
by simp

lemma Hopcroft_wa_lists_impl_\<alpha>_L_Cons [simp] :
 "Hopcroft_wa_lists_impl_\<alpha>_L (asp # L) = 
  (aS.\<alpha> (fst asp), qS.\<alpha> (snd asp)) # Hopcroft_wa_lists_impl_\<alpha>_L L"
unfolding Hopcroft_wa_lists_impl_\<alpha>_L_def
by (cases asp, simp_all)

lemma Hopcroft_wa_lists_impl_\<alpha>_L_rev [simp] :
 "Hopcroft_wa_lists_impl_\<alpha>_L (rev L) =
  rev (Hopcroft_wa_lists_impl_\<alpha>_L L)"
unfolding Hopcroft_wa_lists_impl_\<alpha>_L_def
by (simp add: rev_map)

lemma Hopcroft_wa_lists_impl_\<alpha>_L_append [simp] :
 "Hopcroft_wa_lists_impl_\<alpha>_L (L1 @ L2) =
  Hopcroft_wa_lists_impl_\<alpha>_L L1 @ Hopcroft_wa_lists_impl_\<alpha>_L L2"
unfolding Hopcroft_wa_lists_impl_\<alpha>_L_def
by simp

definition Hopcroft_wa_lists_impl_\<alpha> where
 "Hopcroft_wa_lists_impl_\<alpha> = (\<lambda>((P_sing, P), L).
   ((map qS.\<alpha> P_sing, map qS.\<alpha> P), Hopcroft_wa_lists_impl_\<alpha>_L L))"

definition Hopcroft_wa_lists_update_L_initial_impl where
  "Hopcroft_wa_lists_update_L_initial_impl as a p L =
   (let as' = aS.delete a as in
      if (aS.isEmpty as') then L else (as', p) # L)"

lemma Hopcroft_wa_lists_update_L_initial_correct :
  "Hopcroft_wa_lists_impl_\<alpha>_L (Hopcroft_wa_lists_update_L_initial_impl as a p L) =
   Hopcroft_wa_lists_update_L_initial (aS.\<alpha> as) a (qS.\<alpha> p) (Hopcroft_wa_lists_impl_\<alpha>_L L)"
unfolding Hopcroft_wa_lists_update_L_initial_def Hopcroft_wa_lists_update_L_initial_impl_def
          Hopcroft_wa_lists_impl_\<alpha>_def Hopcroft_wa_lists_impl_\<alpha>_L_def
by (simp add: Let_def aS.correct)

definition split_language_equiv_partition_impl where
  "split_language_equiv_partition_impl p1 pre_pa =
   (let p2_int = qS.inter p1 pre_pa in
   (p2_int, qS.diff p1 p2_int))"

lemma split_language_equiv_partition_impl_correct :
assumes pre_pa_eq: "qS.\<alpha> pre_pa = {q |q q'. q' \<in> qS.\<alpha> p2 \<and> 
          (q, a, q') \<in> LTS_succ_map_\<alpha> (NFA_Impl_trans AA)}"
shows
  "let (p1a, p1b) = (split_language_equiv_partition_impl p1 pre_pa) in
   (split_language_equiv_partition (NFA_Impl_\<alpha> AA) (qS.\<alpha> p1) a (qS.\<alpha> p2) = 
       (qS.\<alpha> p1a, qS.\<alpha> p1b))"
unfolding split_language_equiv_partition_impl_def 
unfolding split_language_equiv_partition_precomputed_thm [of
  "qS.\<alpha> p1" "qS.\<alpha> p2" a "NFA_Impl_\<alpha> AA", symmetric]  
apply (simp add: qS.correct Let_def pre_pa_eq
        NFA_Impl_\<alpha>_simp2 split_language_equiv_partition_precomputed_def)
apply auto
done


fun Hopcroft_wa_lists_update_L_step_impl :: 
  "'a_set \<Rightarrow> 'q \<Rightarrow> 'q_set \<Rightarrow> 'q_set \<Rightarrow> 
    ('a_set \<times> 'q_set) list  \<Rightarrow> ('a_set \<times> 'q_set) list \<Rightarrow>
    ('a_set \<times> 'q_set) list \<times> ('a_set \<times> 'q_set) list" where
 "Hopcroft_wa_lists_update_L_step_impl A q p2_min p2_max L_acc [] =
    ([(A, p2_min)], rev L_acc)"
|"Hopcroft_wa_lists_update_L_step_impl A q p2_min p2_max L_acc ((as, p) # L) =
    (if (qS.memb q p) then 
       ([(A, p2_min), (as, p2_max)], (rev L_acc @ L))
     else
       Hopcroft_wa_lists_update_L_step_impl A q p2_min p2_max ((as, p) # L_acc) L)"

lemma Hopcroft_wa_lists_update_L_step_impl___subset_L:
"let (L_acc', L') = 
     Hopcroft_wa_lists_update_L_step_impl (NFA_Impl_labels AA) q p2_min p2_max L_acc L in
     (set L' \<subseteq> set (L_acc @ L) \<and>
     (\<forall>as p. (as, p) \<in> set L_acc' \<longrightarrow> p = p2_min \<or> p = p2_max))"
proof (induct L arbitrary: L_acc)
  case Nil thus ?case by simp 
next
  case (Cons asp L L_acc)

  from Cons[of "asp # L_acc"]
  show ?case 
  apply (cases asp, simp split: prod.split add: qS.correct)
  apply auto
  done
qed

lemma Hopcroft_wa_lists_update_L_step_impl_correct :
assumes q_in_p2: "q \<in> p2"
    and L_OK: "\<forall>as p. ((as, p) \<in> set L \<and> (qS.\<alpha> p) \<noteq> p2) \<longrightarrow> (qS.\<alpha> p) \<inter> p2 = {}"
shows "let (L_acc', L') = Hopcroft_wa_lists_update_L_step_impl A q p2_min p2_max L_acc L in
       (Hopcroft_wa_lists_impl_\<alpha>_L L_acc', Hopcroft_wa_lists_impl_\<alpha>_L L') =
       Hopcroft_wa_lists_update_L_step (aS.\<alpha> A) p2 (qS.\<alpha> p2_min) (qS.\<alpha> p2_max)
         (Hopcroft_wa_lists_impl_\<alpha>_L L_acc) (Hopcroft_wa_lists_impl_\<alpha>_L L)"
using L_OK
proof (induct L arbitrary: L_acc)
  case Nil thus ?case 
    unfolding Hopcroft_wa_lists_impl_\<alpha>_L_def
    by (simp add: rev_map)
next
  case (Cons asp L L_acc) 
  note ind_hyp = Cons(1)
  note L_OK = Cons(2)
  obtain as p where asp_eq[simp]: "asp = (as, p)" by (rule PairE)

  obtain L_acc' L' where split_eq: "Hopcroft_wa_lists_update_L_step_impl A q p2_min p2_max
             ((as, p) # L_acc) L = (L_acc', L')" by (rule PairE)
  from ind_hyp [of "(as, p) # L_acc"] split_eq L_OK
  have ind_hyp': 
    "Hopcroft_wa_lists_update_L_step (set_op_\<alpha> set_opsA A) p2
      (qS.\<alpha>  p2_min) (qS.\<alpha>  p2_max)
      (Hopcroft_wa_lists_impl_\<alpha>_L ((as, p) # L_acc))
      (Hopcroft_wa_lists_impl_\<alpha>_L L) =
     (Hopcroft_wa_lists_impl_\<alpha>_L L_acc', Hopcroft_wa_lists_impl_\<alpha>_L L')" 
  by simp metis

  from L_OK q_in_p2
  have "q \<in> qS.\<alpha> p \<longleftrightarrow> p2 = qS.\<alpha> p" 
    by auto

  with ind_hyp'
  show ?case
    by (simp add: qS.correct split_eq q_in_p2)
qed

fun Hopcroft_wa_lists_step_impl where
  "Hopcroft_wa_lists_step_impl AA pre_pa P_sing P_acc L_acc [] L = 
     ((P_sing, P_acc), L_acc @ L)"
| "Hopcroft_wa_lists_step_impl AA pre_pa P_sing P_acc L_acc (p2 # P) L =
   (let (p2a, p2b) = split_language_equiv_partition_impl p2 pre_pa in
   (if (qS.isEmpty p2a \<or> qS.isEmpty p2b) then 
      (Hopcroft_wa_lists_step_impl AA pre_pa P_sing (p2 # P_acc) L_acc P L)
    else
      (let (p2ac, p2bc) = (qS.size p2a, qS.size p2b) in
       let (P_sing', P_acc') = (if p2ac = 1 then (p2a # P_sing, P_acc) else
                                                (P_sing, p2a # P_acc)) in
       let (P_sing'', P_acc'') = (if p2bc = 1 then (p2b # P_sing', P_acc') else
                                                (P_sing', p2b # P_acc')) in
       let (p2_min, p2_max) = (if p2ac \<le> p2bc then (p2a, p2b) else (p2b, p2a)) in
       let p2_el = the (qS.sel p2 (\<lambda>_. True)) in
       let (L'_acc, L') = Hopcroft_wa_lists_update_L_step_impl 
           (NFA_Impl_labels AA) p2_el p2_min p2_max [] L in
       Hopcroft_wa_lists_step_impl AA pre_pa P_sing'' P_acc'' (L'_acc @ L_acc) P L'
       )))"

lemma Hopcroft_wa_lists_step_impl_correct :
assumes pre_pa_eq: "qS.\<alpha> pre_pa = {q |q q'. q' \<in> qS.\<alpha> p \<and> 
          (q, a, q') \<in> LTS_succ_map_\<alpha> (NFA_Impl_trans AA)}"
assumes ind_assms: "\<forall>as p p'. (p' \<in> set P \<and> (as, p) \<in> set L \<and> qS.\<alpha> p \<noteq> qS.\<alpha> p') \<longrightarrow> 
                    qS.\<alpha> p \<inter> qS.\<alpha> p' = {}"
                   "\<forall>p. p \<in> set P \<longrightarrow> qS.\<alpha> p \<noteq> {}"
shows "Hopcroft_wa_lists_impl_\<alpha> (Hopcroft_wa_lists_step_impl AA pre_pa P_sing P_acc L_acc P L) =
       Hopcroft_wa_lists_step (NFA_Impl_\<alpha> AA) (qS.\<alpha> p) a (map qS.\<alpha> P_sing) (map qS.\<alpha> P_acc) 
           (Hopcroft_wa_lists_impl_\<alpha>_L L_acc) (map qS.\<alpha> P) (Hopcroft_wa_lists_impl_\<alpha>_L L)"
using ind_assms
proof (induct P arbitrary: P_sing P_acc L_acc L)
  case Nil thus ?case 
    unfolding Hopcroft_wa_lists_impl_\<alpha>_def
    by simp
next
  case (Cons p2 P P_sing P_acc L_acc L)
  note ind_hyp = Cons(1)
  note L_P_prop = Cons(2)
  note P_prop = Cons(3)

  from P_prop have p2_neq_Emp: "qS.\<alpha> p2 \<noteq> {}" 
               and P_prop': "\<forall>p. p \<in> set P \<longrightarrow> qS.\<alpha> p \<noteq> {}" by simp_all

  obtain p2a p2b where split_impl_eq:
    "split_language_equiv_partition_impl p2 pre_pa = (p2a, p2b)"
    by (rule PairE)

  from split_language_equiv_partition_impl_correct [OF pre_pa_eq, of p2]
  have split_eq: "split_language_equiv_partition (NFA_Impl_\<alpha> AA) (qS.\<alpha> p2) a
      (qS.\<alpha> p) = (qS.\<alpha> p2a, qS.\<alpha> p2b)" by (simp add: split_impl_eq)
 
  note p2ab_union = split_language_equiv_partition_union [OF split_eq]
  note p2ab_disj = split_language_equiv_partition_disjoint [OF split_eq]

  def p2ac \<equiv> "qS.size p2a"
  def p2bc \<equiv> "qS.size p2b"

  obtain P_sing' P_acc' where add_step_1:
     "(if card (qS.\<alpha> p2a) = Suc 0 then (p2a # P_sing, P_acc) else (P_sing, p2a # P_acc)) =
      (P_sing', P_acc')" by (rule PairE)
  obtain P_sing'' P_acc'' where add_step_2:
     "(if card (qS.\<alpha> p2b) = Suc 0 then (p2b # P_sing', P_acc') else (P_sing', p2b # P_acc')) =
      (P_sing'', P_acc'')" by (rule PairE)

  from add_step_1 add_step_2
  have sing_add_eq: 
       "Hopcroft_wa_lists_split_sing_add
           [qS.\<alpha> p2a, qS.\<alpha> p2b]
           (map qS.\<alpha> P_sing, map qS.\<alpha> P_acc) =
        (map qS.\<alpha> P_sing'', map qS.\<alpha> P_acc'')" 
    by (auto simp add: qS.correct)
 
  def emp_cond \<equiv> "qS.\<alpha> p2a = {} \<or> qS.\<alpha> p2b = {}"

  show ?case 
  proof (cases emp_cond)
    case True note cond_true = this

    from L_P_prop have L_P_prop': 
      "\<forall>as p p'. (p' \<in> set P \<and> (as, p) \<in> set L \<and> qS.\<alpha> p \<noteq> qS.\<alpha> p') \<longrightarrow> 
                 qS.\<alpha> p \<inter> qS.\<alpha> p' = {}"
      by simp force
    
    from ind_hyp [OF L_P_prop' P_prop'] cond_true show ?thesis
      by (simp add: split_impl_eq qS.correct emp_cond_def[symmetric] split_eq)
  next
    case False note cond_false = this

    obtain p2_min p2_max where p2_minmax_eq: 
      "(if card (qS.\<alpha> p2a) \<le> card (qS.\<alpha> p2b) then (p2a, p2b) else (p2b, p2a)) = (p2_min, p2_max)"
      by (rule PairE)
    
    hence p2_minmax' :
      "(if card (qS.\<alpha> p2a) \<le> card (qS.\<alpha> p2b)
          then (qS.\<alpha> p2a, qS.\<alpha> p2b)
          else (qS.\<alpha> p2b, qS.\<alpha> p2a)) =
       (qS.\<alpha> p2_min, qS.\<alpha> p2_max)"
       by (auto simp add: qS.correct p2ac_def p2bc_def)
     
    def q \<equiv> "(the (set_op_sel set_opsQ p2 (\<lambda>_. True)))"
    have q_in_p2: "q \<in> qS.\<alpha> p2"
    proof -
      from p2_neq_Emp obtain qq where qq_in: "qq \<in> qS.\<alpha> p2" by auto
    
      thus ?thesis
        unfolding q_def
        apply (rule_tac qS.sel'E [of p2 qq "\<lambda>_. True"])
        apply simp_all
      done
    qed

    obtain L_acc' L' where step_impl_eq:
      "Hopcroft_wa_lists_update_L_step_impl (NFA_Impl_labels AA) q p2_min p2_max [] L =
       (L_acc', L')" by (rule PairE)

    from L_P_prop have L_prop: "\<forall>as p. (as, p) \<in> set L \<and> set_op_\<alpha> set_opsQ p \<noteq> set_op_\<alpha> set_opsQ p2 \<longrightarrow>
         set_op_\<alpha> set_opsQ p \<inter> set_op_\<alpha> set_opsQ p2 = {}"
      by auto

    from Hopcroft_wa_lists_update_L_step_impl_correct [OF q_in_p2 L_prop, of "(NFA_Impl_labels AA)"
       p2_min p2_max "[]"] step_impl_eq
    have step_eq: "Hopcroft_wa_lists_update_L_step (\<Sigma> (NFA_Impl_\<alpha> AA))
      (qS.\<alpha> p2) (qS.\<alpha> p2_min) (qS.\<alpha> p2_max) [] (Hopcroft_wa_lists_impl_\<alpha>_L L) = 
        (Hopcroft_wa_lists_impl_\<alpha>_L L_acc', Hopcroft_wa_lists_impl_\<alpha>_L L')" 
      by (simp add: NFA_Impl_\<alpha>_def)

    from step_impl_eq Hopcroft_wa_lists_update_L_step_impl___subset_L [of AA q p2_min p2_max 
         "[]" L] have "set L' \<subseteq> set L" by simp
    with L_P_prop have L_P_prop': 
      "\<forall>as p p'. (p' \<in> set P \<and> (as, p) \<in> set L' \<and> qS.\<alpha> p \<noteq> qS.\<alpha> p') \<longrightarrow> 
                 qS.\<alpha> p \<inter> qS.\<alpha> p' = {}"
      by auto
        
    from ind_hyp [OF L_P_prop' P_prop'] cond_false
    show ?thesis
        by (simp add: split_impl_eq split_eq qS.correct emp_cond_def [symmetric]
                 add_step_1 add_step_2 p2ac_def[symmetric] p2_minmax_eq sing_add_eq 
                 p2_minmax' step_eq step_impl_eq q_def[symmetric]
                 del: Hopcroft_wa_lists_split_sing_add.simps 
                 split del: if_splits cong: if_cong)
  qed
qed

definition LTS_get_succs_set where
  "LTS_get_succs_set D Q a =
   q_Q_iterate (\<lambda>q S. case qaQM.lookup (q,a) D of None \<Rightarrow> S
                        | Some S' \<Rightarrow> qS.union S' S) Q qS.empty"

lemma LTS_get_succs_set_correct :
  "qS.\<alpha> (LTS_get_succs_set D Q a) =
   {q' | q q'. q \<in> qS.\<alpha> Q \<and> (q, a, q') \<in> LTS_succ_map_\<alpha> D}"
unfolding LTS_get_succs_set_def
proof (rule q_Q_it.iterate_rule_insert_P [where ?I =
   "\<lambda>QQ S. qS.\<alpha> S = {q' | q q'. q \<in> QQ \<and> (q, a, q') \<in> LTS_succ_map_\<alpha> D}"])
case (goal3 q S QQ)
  note q_in = goal3(1)
  note S_subset = goal3(2)
  note QQ_eq = goal3(3)
  show ?case
  proof (cases "qaQM.lookup (q, a) D")
    case None thus ?thesis
      by (auto simp add: QQ_eq qaQM.correct LTS_succ_map_\<alpha>_in)
  next
    case (Some S') with q_in show ?thesis
      by (auto simp add: QQ_eq qS.correct qaQM.correct LTS_succ_map_\<alpha>_in)
  qed
qed (simp_all add: qS.correct)


definition Hopcroft_wa_lists_impl where
  "Hopcroft_wa_lists_impl RD AA = \<lparr> 
     wa_impl_cond = (\<lambda>((P_sing, P), L). L \<noteq> []),
     wa_impl_step = (\<lambda>((P_sing, P), L).
       let (as, p) = hd L in
       let a = the (aS.sel as (\<lambda>_. True)) in
       let pre_pa = LTS_get_succs_set RD p a in
       let L' = Hopcroft_wa_lists_update_L_initial_impl as a p (tl L) in
       (if qS.isEmpty pre_pa then ((P_sing, rev P), L') else
       Hopcroft_wa_lists_step_impl AA pre_pa P_sing [] [] P L')) \<rparr>"

lemma Hopcroft_wa_lists_step_skip :
assumes pre_pa_emp: "{q | q q'. q' \<in> p \<and> (q, a, q') \<in> (\<Delta> \<A>)} = {}"
shows "Hopcroft_wa_lists_step \<A> p a P_sing P_acc [] P L =
       ((P_sing, (rev P) @ P_acc), L)"
proof (induct P arbitrary: P_acc)
  case Nil thus ?case by simp
next
  case (Cons p2 P)
  note ind_hyp = Cons

  from pre_pa_emp
  have "split_language_equiv_partition \<A> p2 a p = ({}, p2)" 
    by (simp add: split_language_equiv_partition_def split_set_def)
  thus ?case by (simp add: ind_hyp)
qed

lemma Hopcroft_wa_lists_impl_correct :
assumes wf_A: "DFA (NFA_Impl_\<alpha> AA)"
    and RD_OK: "LTS_succ_map_\<alpha> RD =
                {(q, a, p) |q a p. (p, a, q) \<in> LTS_succ_map_\<alpha> (NFA_Impl_trans AA)}" 
shows "implements_while_algorithm Hopcroft_wa_lists_impl_\<alpha> 
    (Hopcroft_wa_lists_invar_full (NFA_Impl_\<alpha> AA)) 
    (Hopcroft_wa_lists_impl RD AA)
    (Hopcroft_wa_lists (NFA_Impl_\<alpha> AA))"
proof
  fix PPL :: "('q_set list \<times> 'q_set list) \<times> ('a_set \<times> 'q_set) list" 
  obtain P_sing P L where PPL_eq[simp]: "PPL = ((P_sing, P), L)"
    by (cases PPL, rename_tac PP L, case_tac PP, blast)

  show "wa_impl_cond (Hopcroft_wa_lists_impl RD AA) PPL =
        while_algorithm.wa_cond (Hopcroft_wa_lists (NFA_Impl_\<alpha> AA))
          (Hopcroft_wa_lists_impl_\<alpha> PPL)"
    unfolding Hopcroft_wa_lists_impl_def Hopcroft_wa_lists_def 
              Hopcroft_wa_lists_impl_\<alpha>_def
              Hopcroft_wa_lists_impl_\<alpha>_L_def
    by simp
next
  fix PPL  :: "('q_set list \<times> 'q_set list) \<times> ('a_set \<times> 'q_set) list" 
  fix PPL' :: "('q_set list \<times> 'q_set list) \<times> ('a_set \<times> 'q_set) list" 
  obtain P_sing P L where PPL_eq[simp]: "PPL = ((P_sing, P), L)"
    by (cases PPL, rename_tac PP L, case_tac PP, blast)
  obtain P_sing' P' L' where PPL'_eq[simp]: "PPL' = ((P_sing', P'), L')"
    by (cases PPL', rename_tac PP L, case_tac PP, blast)

  assume step: "wa_impl_step (Hopcroft_wa_lists_impl RD AA) PPL = PPL'"
  assume cond: "wa_impl_cond (Hopcroft_wa_lists_impl RD AA) PPL"
  assume invar: "Hopcroft_wa_lists_invar_full (NFA_Impl_\<alpha> AA)
        (Hopcroft_wa_lists_impl_\<alpha> PPL)"

  from cond have "L \<noteq> []"
    unfolding Hopcroft_wa_lists_impl_def
    by simp
  then obtain as p L_tl where L_eq: "L = (as, p) # L_tl"
     by (cases L, simp_all, rename_tac asp L_tl, case_tac asp, blast)  

  def a \<equiv> "the (aS.sel as (\<lambda>_. True))"
  have a_in: "a \<in> aS.\<alpha> as"
  proof -
    from invar have as_neq_Emp: "aS.\<alpha> as \<noteq> {}"
      unfolding Hopcroft_wa_lists_invar_full_def Hopcroft_wa_lists_invar_def
                Hopcroft_wa_lists_invar_L_def Hopcroft_wa_lists_impl_\<alpha>_def 
      by (simp add: L_eq)
    then obtain aa where aa_in: "aa \<in> aS.\<alpha> as" by auto
    
    thus ?thesis
      unfolding a_def
      apply (rule_tac aS.sel'E [of as aa "\<lambda>_. True"])
      apply simp_all
    done
  qed

  from step have step_impl_eq: "
     (let pre_pa = LTS_get_succs_set RD p a;
          L' = Hopcroft_wa_lists_update_L_initial_impl as a p L_tl
     in if qS.isEmpty pre_pa then ((P_sing, rev P), L')
        else Hopcroft_wa_lists_step_impl AA pre_pa P_sing [] [] P L') =
    ((P_sing', P'), L')"
    unfolding Hopcroft_wa_lists_impl_def
    by (simp add: a_def[symmetric] L_eq)

  from invar
  have part_invar: "is_partition (\<Q> (NFA_Impl_\<alpha> AA)) (qS.\<alpha> ` set (P_sing @ P))" and
       L_OK: "\<And>a p. (a, p) \<in> Hopcroft_wa_lists_\<alpha>_L (Hopcroft_wa_lists_impl_\<alpha>_L L) \<Longrightarrow>
              (p \<in> qS.\<alpha> ` set (P_sing @ P))" and
       L_not_emp: "\<And>as p. (as, p) \<in> set L \<Longrightarrow> aS.\<alpha> as \<noteq> {}"
    unfolding Hopcroft_wa_lists_invar_full_def Hopcroft_wa_lists_invar_def
              Hopcroft_wa_invar_def Hopcroft_wa_lists_impl_\<alpha>_def
              Hopcroft_wa_lists_invar_L_def Hopcroft_wa_lists_impl_\<alpha>_L_def
              Hopcroft_wa_lists_\<alpha>_def Ball_def is_weak_language_equiv_partition_def
    apply (simp_all add: image_Un list_all_iff Ball_def image_iff Bex_def)
    apply auto
  done

  from part_invar have P_prop: "\<forall>p. p \<in> set P \<longrightarrow> set_op_\<alpha> set_opsQ p \<noteq> {}"
    unfolding is_partition_def
    by (simp add: image_iff Ball_def, auto)

  have L_prop: "\<forall>as' p'' p'.
     p' \<in> set P \<and> (as', p'') \<in> set (Hopcroft_wa_lists_update_L_initial_impl as a p L_tl) \<and> 
     qS.\<alpha> p'' \<noteq> qS.\<alpha> p' \<longrightarrow> qS.\<alpha> p'' \<inter> qS.\<alpha> p' = {}" 
  proof (intro allI impI)
    fix as' p'' p'
    assume pre: "p' \<in> set P \<and> (as', p'') \<in> set (Hopcroft_wa_lists_update_L_initial_impl as a p L_tl) \<and> 
                qS.\<alpha> p'' \<noteq> qS.\<alpha> p'"

    from pre have p''_neq: "qS.\<alpha> p'' \<noteq> qS.\<alpha> p'" by fast
    from pre have p'_in_P: "p' \<in> set P" by fast
 
    have "\<exists>p'''. p''' \<in> set (P_sing @ P) \<and> qS.\<alpha> p'' = qS.\<alpha> p'''"
    proof -
      from pre have "(as', p'') \<in> set (Hopcroft_wa_lists_update_L_initial_impl as a p L_tl)"
        by simp
      then obtain as'' where p''_in_L: "(as'', p'') \<in> set L"
        unfolding Hopcroft_wa_lists_update_L_initial_impl_def
        apply (cases "set_op_\<alpha> set_opsA as \<subseteq> {a}")
        apply (auto simp add: Let_def qS.correct aS.correct Ball_def Bex_def L_eq)
      done
      with L_not_emp obtain a where a_in : "a \<in> aS.\<alpha> as''" by auto

      with p''_in_L have in_L': "(a, qS.\<alpha> p'') \<in> Hopcroft_wa_lists_\<alpha>_L (Hopcroft_wa_lists_impl_\<alpha>_L L)"
        apply (simp add: Hopcroft_wa_lists_\<alpha>_L_def Hopcroft_wa_lists_impl_\<alpha>_L_def image_iff
                         Bex_def Ball_def)
        apply metis
      done
      from L_OK [OF in_L'] show ?thesis
        by auto
    qed
    then obtain p''' where p'''_in_P: "p''' \<in> set (P_sing @ P)" and
                           p''_sem: "qS.\<alpha> p'' = qS.\<alpha> p'''" by auto

    
    from part_invar p'_in_P p''_sem p'''_in_P p''_neq 
    show "qS.\<alpha> p'' \<inter> qS.\<alpha> p' = {}"
      unfolding is_partition_def
      by auto
  qed
  
  show "(Hopcroft_wa_lists_impl_\<alpha> PPL') \<in> 
          while_algorithm.wa_step (Hopcroft_wa_lists (NFA_Impl_\<alpha> AA))
          (Hopcroft_wa_lists_impl_\<alpha> PPL)"
  proof (cases "qS.isEmpty (LTS_get_succs_set RD p a)")
    case False
    with  Hopcroft_wa_lists_step_impl_correct [where AA=AA and P_sing=P_sing and p = p and a = a and
    P_acc = "[]" and L_acc="[]" and P=P and pre_pa = "LTS_get_succs_set RD p a" and
    L="(Hopcroft_wa_lists_update_L_initial_impl as a p L_tl)", OF _ L_prop P_prop, symmetric]  
      step_impl_eq LTS_get_succs_set_correct [of RD p a]
    show "?thesis"
      unfolding Hopcroft_wa_lists_def
      apply (simp add: Hopcroft_wa_lists_impl_\<alpha>_def L_eq Hopcroft_wa_lists_update_L_initial_correct
               RD_OK Let_def)
      apply (rule_tac exI [where x = a])
      apply (simp add: a_in)
    done
  next
    case True thus ?thesis
      using step_impl_eq Hopcroft_wa_lists_step_skip [of "qS.\<alpha> p" a "NFA_Impl_\<alpha> AA"
        "map qS.\<alpha> P_sing'" "[]"]
      unfolding Hopcroft_wa_lists_def
      apply (simp add: Hopcroft_wa_lists_impl_\<alpha>_def L_eq 
               RD_OK Let_def qS.correct LTS_get_succs_set_correct
               Hopcroft_wa_lists_update_L_initial_correct[symmetric])
      apply (rule_tac exI [where x = a])
      apply (auto simp add: a_in NFA_Impl_\<alpha>_simp2 rev_map)
    done 
  qed
qed


definition "Hopcroft_wa_lists_init_impl AA \<equiv> (
  ([], let Q' = qS.diff (NFA_Impl_states AA) (NFA_Impl_accepting AA) in
  if (qS.isEmpty Q') then [NFA_Impl_accepting AA] else [Q', NFA_Impl_accepting AA]), 
  if (aS.isEmpty (NFA_Impl_labels AA)) then [] else [(NFA_Impl_labels AA, NFA_Impl_accepting AA)])"

lemma Hopcroft_wa_lists_init_impl_correct :
  "Hopcroft_wa_lists_impl_\<alpha> (Hopcroft_wa_lists_init_impl AA) =
   Hopcroft_wa_lists_init (NFA_Impl_\<alpha> AA)"
unfolding Hopcroft_wa_lists_init_impl_def Hopcroft_wa_lists_init_def NFA_Impl_\<alpha>_def
          Hopcroft_wa_lists_impl_\<alpha>_def
by (simp add: qS.correct aS.correct)

definition "Hopcroft_compute_equiv_fun_impl_aux RD AA = while_impl (Hopcroft_wa_lists_impl RD AA)"

lemma Hopcroft_compute_equiv_fun_impl_aux_code1 :
   "Hopcroft_compute_equiv_fun_impl_aux RD AA ((P_sing, P), []) = ((P_sing, P), [])"
unfolding Hopcroft_compute_equiv_fun_impl_aux_def Hopcroft_wa_lists_impl_def
by (simp add: while_impl_unfold)

lemma Hopcroft_compute_equiv_fun_impl_aux_code2 :
   "Hopcroft_compute_equiv_fun_impl_aux RD AA ((P_sing, P), (as, p) # L) = 
    (Hopcroft_compute_equiv_fun_impl_aux RD AA
     (let a = the (set_op_sel set_opsA as (\<lambda>_. True)) in
     (let L' = Hopcroft_wa_lists_update_L_initial_impl as a p L in
     (let pre_pa = LTS_get_succs_set RD p a in
       (if qS.isEmpty pre_pa then 
            ((P_sing, rev P), L') else
       Hopcroft_wa_lists_step_impl AA pre_pa P_sing [] [] P
          L')))))"
by (simp add: Hopcroft_compute_equiv_fun_impl_aux_def
              Hopcroft_wa_lists_impl_def while_impl_unfold Let_def)

lemmas Hopcroft_compute_equiv_fun_impl_aux_code =
  Hopcroft_compute_equiv_fun_impl_aux_code1
  Hopcroft_compute_equiv_fun_impl_aux_code2

definition Hopcroft_compute_equiv_fun_impl where
  "Hopcroft_compute_equiv_fun_impl AA =
   (if (qS.isEmpty (NFA_Impl_accepting AA)) then
     (if qS.isEmpty (NFA_Impl_states AA) then [] else [NFA_Impl_states AA])
    else
   (let ((P_sing, P), L) = 
       Hopcroft_compute_equiv_fun_impl_aux 
           (LTS_reverse_impl (NFA_Impl_trans AA)) AA (Hopcroft_wa_lists_init_impl AA) in
    (P_sing @ P)))"

lemma Hopcroft_compute_equiv_fun_impl_correct :
assumes wf_A: "DFA (NFA_Impl_\<alpha> AA)"
shows "set (map qS.\<alpha> (Hopcroft_compute_equiv_fun_impl AA)) =
       is_strong_language_equiv_partition_fun (NFA_Impl_\<alpha> AA) \<and>
       distinct (map qS.\<alpha> (Hopcroft_compute_equiv_fun_impl AA))"
proof (cases "\<F> (NFA_Impl_\<alpha> AA) \<noteq> {}")
  case False note F_eq = this

  show ?thesis
  proof (cases "\<Q> (NFA_Impl_\<alpha> AA) = {}")
    case True
    with F_eq have "Hopcroft_compute_equiv_fun_impl AA = []"
      by (simp add: Hopcroft_compute_equiv_fun_impl_def qS.correct NFA_Impl_\<alpha>_def)
    with True show ?thesis
     using is_strong_language_equiv_partition_fun___\<Q>_emp [of "NFA_Impl_\<alpha> AA"]
     by simp
  next
    case False
    with F_eq have "Hopcroft_compute_equiv_fun_impl AA = [NFA_Impl_states AA]"
      by (simp add: Hopcroft_compute_equiv_fun_impl_def qS.correct NFA_Impl_\<alpha>_def)
    with False F_eq show ?thesis
     using is_strong_language_equiv_partition_fun___\<F>_emp [of "NFA_Impl_\<alpha> AA"]
     by (simp add: NFA_Impl_\<alpha>_def)
  qed
next
  case True note F_OK = this
  def RD \<equiv> "LTS_reverse_impl (NFA_Impl_trans AA)"
  obtain P_sing P L where
     impl_eq: "while_impl (Hopcroft_wa_lists_impl RD AA) (Hopcroft_wa_lists_init_impl AA) =
               ((P_sing, P), L)"
     by (cases "while_impl (Hopcroft_wa_lists_impl RD AA) (Hopcroft_wa_lists_init_impl AA)",
         rename_tac PP L, case_tac PP, blast)

  from while_impl_correct [OF DFA.Hopcroft_wa_lists_variant_exists [OF wf_A]
                              Hopcroft_wa_lists_impl_correct [OF wf_A], 
                           of RD "Hopcroft_wa_lists_init_impl AA"]
       LTS_reverse_impl_correct [of "NFA_Impl_trans AA", folded RD_def]
       DFA.Hopcroft_wa_lists_invar_init [OF wf_A F_OK]
  have in_rel: "while_relation (Hopcroft_wa_lists (NFA_Impl_\<alpha> AA))
     (Hopcroft_wa_lists_init (NFA_Impl_\<alpha> AA))
     ((map qS.\<alpha> P_sing, map qS.\<alpha> P),
      Hopcroft_wa_lists_impl_\<alpha>_L L)"
    apply (simp add: Hopcroft_wa_lists_init_impl_correct impl_eq)
    apply (simp add: Hopcroft_wa_lists_impl_\<alpha>_def)
  done

  from DFA.Hopcroft_wa_lists_correct [OF wf_A F_OK in_rel] F_OK
  show ?thesis
    unfolding Hopcroft_compute_equiv_fun_impl_def Hopcroft_compute_equiv_fun_impl_aux_def
       RD_def[symmetric]
    by (simp add: impl_eq qS.correct NFA_Impl_\<alpha>_def)
qed

definition Hopcroft_equiv_partition_add_to_rename_fun_aux where
   "Hopcroft_equiv_partition_add_to_rename_fun_aux rf q' p = 
    q_qq_iterate (\<lambda>q rf. qqM.update_dj q q' rf) p rf"

lemma Hopcroft_equiv_partition_add_to_rename_fun_aux_correct :
assumes disj_dom: "dom (qqM.\<alpha> rf) \<inter> qS.\<alpha> p = {}"
shows "qqM.\<alpha> (Hopcroft_equiv_partition_add_to_rename_fun_aux rf n p) =
      (\<lambda>q. if (q \<in> qS.\<alpha> p) then Some n else (qqM.\<alpha> rf) q)"
unfolding Hopcroft_equiv_partition_add_to_rename_fun_aux_def
proof (induct rule: q_qq_it.iterate_rule_insert_P
   [where I = "\<lambda>p \<sigma>. qqM.\<alpha> \<sigma> = (\<lambda>q. if q \<in> p then Some n else qqM.\<alpha> rf q)"])
  case 1 thus ?case by simp
next
  case 2 thus ?case by simp
next
  case 4 thus ?case by simp
next
  case (3 q p' rf')
  from 3(1) have q_in: "q \<in> qS.\<alpha> p" and q_nin: "q \<notin> p'" by simp_all
  note p'_subset = 3(2)
  note rf'_eval = 3(3)  
  
  from disj_dom q_in
  have "q \<notin> dom (qqM.\<alpha> rf')" 
    by (simp add: rf'_eval dom_def set_eq_iff q_nin) fastforce

  thus ?case
    by (simp add: qqM.correct rf'_eval fun_eq_iff) 
qed


fun Hopcroft_equiv_partition_add_to_rename_fun where
   "Hopcroft_equiv_partition_add_to_rename_fun rf n [] = rf"
 | "Hopcroft_equiv_partition_add_to_rename_fun rf n (p # ps) =
    Hopcroft_equiv_partition_add_to_rename_fun 
       (Hopcroft_equiv_partition_add_to_rename_fun_aux rf (states_enumerate n) p)
       (Suc n) ps"

lemma Hopcroft_equiv_partition_add_to_rename_fun_correct :
assumes "\<forall>p \<in> set ps. dom (qqM.\<alpha> rf) \<inter> qS.\<alpha> p = {}"
    and "\<forall>p \<in> set ps. \<forall>p' \<in> set ps. qS.\<alpha> p \<noteq> qS.\<alpha> p' \<longrightarrow> qS.\<alpha> p' \<inter> qS.\<alpha> p = {}"
    and "distinct (map qS.\<alpha> ps)"
shows "dom (qqM.\<alpha> (Hopcroft_equiv_partition_add_to_rename_fun rf n ps)) =
       dom (qqM.\<alpha> rf) \<union> (\<Union> qS.\<alpha> ` set ps) \<and>
       (\<forall>q. q \<notin> (\<Union> qS.\<alpha> ` set ps) \<longrightarrow> 
            qqM.\<alpha> ((Hopcroft_equiv_partition_add_to_rename_fun rf n ps)) q =
            qqM.\<alpha> rf q) \<and>
       (\<forall>q m. (m < length ps \<and> q \<in> qS.\<alpha> (ps ! m)) \<longrightarrow>
            qqM.\<alpha> ((Hopcroft_equiv_partition_add_to_rename_fun rf n ps)) q =
            Some (states_enumerate (n + m)))"
       (is "?prop1 ps rf n \<and> ?prop2 ps rf n \<and> ?prop3 ps rf n")
using assms
proof (induct ps arbitrary: rf n)
  case Nil thus ?case by simp
next
  case (Cons p ps rf n)
  note ind_hyp = Cons(1)
  note rf_dom_disj = Cons(2)
  note p_ps_disj = Cons(3)
  note dist_p_ps = Cons(4)
  let ?rf' = "Hopcroft_equiv_partition_add_to_rename_fun_aux rf (states_enumerate n) p"
 
  from rf_dom_disj Hopcroft_equiv_partition_add_to_rename_fun_aux_correct [of rf p]
  have rf'_\<alpha>: "qqM.\<alpha> ?rf' = (\<lambda>q. if q \<in> qS.\<alpha> p then Some (states_enumerate n) else qqM.\<alpha> rf q)"
    by simp
  hence dom_rf': "dom (qqM.\<alpha> ?rf') = dom (qqM.\<alpha> rf) \<union> (qS.\<alpha> p)"
    by (auto simp add: dom_def)

  from dist_p_ps p_ps_disj have 
    p_disj: "\<forall>pa\<in>set ps. set_op_\<alpha> set_opsQ p \<inter> set_op_\<alpha> set_opsQ pa = {}"
    by auto

  from rf_dom_disj p_disj
  have rf'_dom_disj : "\<forall>p\<in>set ps. dom (qqM.\<alpha> ?rf') \<inter> qS.\<alpha> p = {}"
    by (simp add: dom_rf' Int_Un_distrib2)

  from p_ps_disj have ps_disj: "\<forall>p\<in>set ps.
     \<forall>p'\<in>set ps. (qS.\<alpha> p \<noteq> qS.\<alpha> p') \<longrightarrow> set_op_\<alpha> set_opsQ p' \<inter> set_op_\<alpha> set_opsQ p = {}" by auto
  from dist_p_ps have dist_ps: "distinct (map qS.\<alpha> ps)" by simp

  note ind_hyp' = ind_hyp [OF rf'_dom_disj ps_disj dist_ps, of "Suc n"]
  note prop1' = conjunct1 [OF ind_hyp']
  note prop2' = conjunct1 [OF conjunct2 [OF ind_hyp']]
  note prop3' = conjunct2 [OF conjunct2 [OF ind_hyp']]

  have prop1: "?prop1 (p # ps) rf n" 
    using prop1'
    by (auto simp add: dom_rf')

  have prop2: "?prop2 (p # ps) rf n" 
    using prop2'
    by (simp add: rf'_\<alpha>)

  have prop3: "?prop3 (p # ps) rf n" 
  proof (intro allI impI)
    fix q m
    assume pre: "m < length (p # ps) \<and> q \<in> set_op_\<alpha> set_opsQ ((p # ps) ! m)"
    show "qqM.\<alpha> (Hopcroft_equiv_partition_add_to_rename_fun rf n (p # ps)) q =
          Some (states_enumerate (n + m))"
    proof (cases m)
      case 0 note m_eq = this
      with pre have q_in: "q \<in> qS.\<alpha> p" by simp

      with p_disj have q_nin: "q \<notin> \<Union>qS.\<alpha> ` set ps" 
        by auto

      from q_in prop2' q_nin
      show ?thesis 
        by (simp add: rf'_\<alpha> m_eq)
    next
      case (Suc m') note m_eq = this
      with pre have pre': "m' < length ps \<and> q \<in> set_op_\<alpha> set_opsQ (ps ! m')"
         by simp
      from prop3' pre' show ?thesis 
        by (simp add: m_eq)
    qed
  qed
  from prop1 prop2 prop3
  show ?case by fast
qed


definition Hopcroft_equiv_partition_to_rename_fun where
  "Hopcroft_equiv_partition_to_rename_fun ps =
   Hopcroft_equiv_partition_add_to_rename_fun qqM.empty 0 ps"

lemma Hopcroft_equiv_partition_to_rename_fun_correct :
assumes disj_ps: "\<forall>p \<in> set ps. \<forall>p' \<in> set ps. qS.\<alpha> p \<noteq> qS.\<alpha> p' \<longrightarrow> qS.\<alpha> p' \<inter> qS.\<alpha> p = {}"
    and dist_ps: "distinct (map qS.\<alpha> ps)"
shows "dom (qqM.\<alpha> (Hopcroft_equiv_partition_to_rename_fun ps)) = (\<Union> qS.\<alpha> ` set ps)"
       (is "?prop1 ps")
  and "\<And>q q'. (qqM.\<alpha> ((Hopcroft_equiv_partition_to_rename_fun ps)) q = Some q') \<longleftrightarrow>
              (\<exists>m. q' = states_enumerate m \<and> m < length ps \<and> q \<in> qS.\<alpha> (ps ! m))"
       (is "\<And>q q'. ?prop2 q q' ps")
  and "\<And>q. (qqM.\<alpha> ((Hopcroft_equiv_partition_to_rename_fun ps)) q = None) \<longleftrightarrow>
            (\<forall>p \<in> set ps. q \<notin> qS.\<alpha> p)"
       (is "\<And>q. ?prop3 q ps")
  and "\<And>q m. \<lbrakk>m < length ps; q \<in> qS.\<alpha> (ps ! m)\<rbrakk> \<Longrightarrow>
              (qqM.\<alpha> ((Hopcroft_equiv_partition_to_rename_fun ps)) q = Some (states_enumerate m))"
proof -
  from disj_ps dist_ps Hopcroft_equiv_partition_add_to_rename_fun_correct [of ps "qqM.empty" 0]
  have prop1: "?prop1 ps" and prop2a: "(\<forall>q m. m < length ps \<and> q \<in> qS.\<alpha> (ps ! m) \<longrightarrow>
           qqM.\<alpha> (Hopcroft_equiv_partition_to_rename_fun ps) q =
           Some (states_enumerate m))"
    by (simp_all add: qqM.correct Hopcroft_equiv_partition_to_rename_fun_def [symmetric])
  from prop1 show "?prop1 ps" .
  
  {
    fix q
    from prop1 show "?prop3 q ps"
      by (auto simp add: domIff)
  }
  
  {
    fix q m
    assume "m < length ps" "q \<in> qS.\<alpha> (ps ! m)"
    with prop2a show
      "qqM.\<alpha> ((Hopcroft_equiv_partition_to_rename_fun ps)) q = Some (states_enumerate m)"
      by simp
  }

  have prop2b: "\<And>q q'. qqM.\<alpha> (Hopcroft_equiv_partition_to_rename_fun ps) q = Some q' \<Longrightarrow>
         (\<exists>m. (q' = states_enumerate m) \<and> m < length ps \<and> q \<in> qS.\<alpha> (ps ! m))"
  proof -
    fix q q'
    assume pre: "qqM.\<alpha> (Hopcroft_equiv_partition_to_rename_fun ps) q = Some q'"

    from pre prop1 have "q \<in> (\<Union> qS.\<alpha> ` set ps)" by auto 
    then obtain m where m_le: "m < length ps" and q_in_ps_m: "q \<in> qS.\<alpha> (ps ! m)" 
      by (simp add: Bex_def in_set_conv_nth) blast

    with prop2a have "qqM.\<alpha> (Hopcroft_equiv_partition_to_rename_fun ps) q =
                     Some (states_enumerate m)" by simp
    with pre m_le q_in_ps_m show "?thesis q q'" by simp blast
  qed

  {
    fix q q'
    from prop2a prop2b show "?prop2 q q' ps"
    by metis
  } 
qed

lemma Hopcroft_equiv_partition_to_rename_fun_correct___strong_language_equiv_partition :
assumes set_eq: "set (map qS.\<alpha> ps) = is_strong_language_equiv_partition_fun \<A>" and
        dist: "distinct (map qS.\<alpha> ps)"
shows "let rm = Hopcroft_equiv_partition_to_rename_fun ps in
       dom (qqM.\<alpha> rm) = \<Q> \<A> \<and> 
       is_strong_equivalence_rename_fun \<A> (\<lambda>q. case (qqM.\<alpha> rm q) of Some q' \<Rightarrow> q' 
                                                                   | None \<Rightarrow> q)"
proof -
  have "\<forall>p\<in>set ps. \<forall>p'\<in>set ps. qS.\<alpha> p \<noteq> qS.\<alpha> p' \<longrightarrow> qS.\<alpha> p' \<inter> qS.\<alpha> p = {}"
  proof (intro ballI impI)
    fix p p'
    assume p_in_ps: "p \<in> set ps"
       and p'_in_ps: "p' \<in> set ps"
       and neq_p_p': "qS.\<alpha> p \<noteq> qS.\<alpha> p'"

    from set_eq[symmetric] p_in_ps have p_in_part: 
      "qS.\<alpha> p \<in> is_strong_language_equiv_partition_fun \<A>"
      by simp

    from set_eq[symmetric] p'_in_ps have p'_in_part: 
      "qS.\<alpha> p' \<in> is_strong_language_equiv_partition_fun \<A>"
      by simp
    
    from p_in_part p'_in_part neq_p_p' show "qS.\<alpha> p' \<inter> qS.\<alpha> p = {}"
      unfolding is_strong_language_equiv_partition_fun_def by auto      
  qed
  note rm_props = Hopcroft_equiv_partition_to_rename_fun_correct [of ps, OF this dist]

  have dom_eq: "dom (qqM.\<alpha> (Hopcroft_equiv_partition_to_rename_fun ps)) = \<Q> \<A>"
  proof -    
    have "dom (qqM.\<alpha> (Hopcroft_equiv_partition_to_rename_fun ps)) = \<Union> set (map qS.\<alpha> ps)"
       by (simp add: rm_props(1))
    also have "\<dots> = \<Union> (is_strong_language_equiv_partition_fun \<A>)"
      unfolding set_eq ..
    also have "\<dots> = \<Q> \<A>"
      unfolding is_strong_language_equiv_partition_fun_def by auto
    finally show ?thesis .
  qed

  let ?f = "\<lambda>q. case (qqM.\<alpha> (Hopcroft_equiv_partition_to_rename_fun ps) q) of 
                   Some q' \<Rightarrow> q' | None \<Rightarrow> q"
  have is_rename_fun: "is_strong_equivalence_rename_fun \<A> ?f"
  proof (rule is_strong_equivalence_rename_fun___partition)
    fix pa q1
    assume pa_in_part: "pa \<in> is_strong_language_equiv_partition_fun \<A>" and
           q1_in_p: "q1 \<in> pa"

    from pa_in_part obtain p where p_in_ps: "p \<in> set ps" and
                                   pa_eq: "pa = qS.\<alpha> p"
      unfolding set_eq[symmetric] by fastforce
    from p_in_ps obtain m where m_le: "m < length ps" and p_eq: "ps ! m = p"
      by (metis in_set_conv_nth)

    show "\<forall>q2\<in>\<Q> \<A>. (?f q1 = ?f q2) = (q2 \<in> pa)"
    proof (intro ballI)
      fix q2
      assume q2_in_Q: "q2 \<in> \<Q> \<A>"

      hence "{q' \<in> \<Q> \<A>. \<L>_in_state \<A> q' = \<L>_in_state \<A> q2} \<in>
             is_strong_language_equiv_partition_fun \<A>"
        unfolding is_strong_language_equiv_partition_fun_def by auto
      with set_eq have "{q' \<in> \<Q> \<A>. \<L>_in_state \<A> q' = \<L>_in_state \<A> q2} \<in>
             (set (map qS.\<alpha> ps))" by simp
      then obtain p' where 
         p'_in_ps: "p' \<in> set ps" and
         p'_alpha: "qS.\<alpha> p' = {q' \<in> \<Q> \<A>. \<L>_in_state \<A> q' = \<L>_in_state \<A> q2}"
        by auto

      from p'_alpha q2_in_Q have q2_in_p': "q2 \<in> qS.\<alpha> p'"
        by simp

      from p'_in_ps obtain m' where m'_le: "m' < length ps" and p'_eq: "ps ! m' = p'"
        by (metis in_set_conv_nth)

      have f_q1: "?f q1 = states_enumerate m"
        using rm_props(4) [OF m_le, of q1] p_eq q1_in_p
        by (simp add: pa_eq)

      have f_q2: "?f q2 = states_enumerate m'"
        using rm_props(4) [OF m'_le, of q2] p'_eq q2_in_p'
        by (simp add: pa_eq)

      show "?f q1 = ?f q2 \<longleftrightarrow> q2 \<in> pa"
        unfolding f_q1 f_q2 states_enumerate_eq
        proof (rule iffI)
          assume "m = m'"
          thus "q2 \<in> pa"
            using q2_in_p'
            by (simp add: p'_eq[symmetric] pa_eq p_eq[symmetric])
        next
          assume q2_in_p: "q2 \<in> pa"
              
          from p'_in_ps p_in_ps have 
               p_p'_alpha_in: "qS.\<alpha> p \<in> is_strong_language_equiv_partition_fun \<A> \<and>
                               qS.\<alpha> p' \<in> is_strong_language_equiv_partition_fun \<A>"
            unfolding set_eq[symmetric] 
            by simp

          with q2_in_p' q2_in_p have "qS.\<alpha> p = qS.\<alpha> p'"
            by (auto simp add: is_strong_language_equiv_partition_fun_def pa_eq)
          with dist m_le m'_le show "m = m'"
            unfolding p_eq[symmetric] p'_eq[symmetric] distinct_conv_nth
            by simp metis
        qed
    qed
  qed  

  from is_rename_fun dom_eq
  show ?thesis
    by (simp add: Let_def)
qed

definition Hopcroft_minimise_impl where
 "Hopcroft_minimise_impl AA =
  (let rm = Hopcroft_equiv_partition_to_rename_fun (Hopcroft_compute_equiv_fun_impl AA) in
   rename_states_impl (\<lambda>q. qqM.lookup q rm) AA)"

lemma Hopcroft_minimise_impl_correct :
assumes wf_AA: "DFA (NFA_Impl_\<alpha> AA)"
shows "NFA_isomorphic_wf (NFA_Impl_\<alpha> (Hopcroft_minimise_impl AA)) 
                         (Hopcroft_minimise (NFA_Impl_\<alpha> AA))"
proof -
  def rm \<equiv> "Hopcroft_equiv_partition_to_rename_fun
                  (Hopcroft_compute_equiv_fun_impl AA)"
  def rf \<equiv> "\<lambda>q. case qqM.\<alpha> rm q of None \<Rightarrow> q | Some q' \<Rightarrow> q'"
  def rf' \<equiv> "SOME f::('q \<Rightarrow> 'q). is_strong_equivalence_rename_fun (NFA_Impl_\<alpha> AA) f \<and>
         (\<forall>q \<in> \<Q> (NFA_Impl_\<alpha> AA). f q \<in> \<Q> (NFA_Impl_\<alpha> AA))"

  from Hopcroft_compute_equiv_fun_impl_correct [OF wf_AA]
       Hopcroft_equiv_partition_to_rename_fun_correct___strong_language_equiv_partition 
         [of "Hopcroft_compute_equiv_fun_impl AA" "NFA_Impl_\<alpha> AA"]       
  have rm_dom: "dom (qqM.\<alpha> rm) = \<Q> (NFA_Impl_\<alpha> AA)" and
       rf_prop: "is_strong_equivalence_rename_fun (NFA_Impl_\<alpha> AA) rf"
    by (simp_all add: rm_def[symmetric] rf_def)

  from wf_AA have wf_NFA_AA: "NFA (NFA_Impl_\<alpha> AA)" by (simp add: DFA_alt_def)

  from rename_states_impl_correct [OF wf_NFA_AA, of "\<lambda>q. qqM.lookup q rm" rf] rm_dom[symmetric]       
  have rename_impl_eq: 
     "NFA_Impl_\<alpha> (rename_states_impl (\<lambda>q. qqM.lookup q rm) AA) =
      rename_states (NFA_Impl_\<alpha> AA) rf"
    unfolding rf_def
    by (simp add: NFA_Impl_\<alpha>_simp2 qqM.correct domIff)
       (metis option.simps(5))
 
  have rf'_prop: "is_strong_equivalence_rename_fun (NFA_Impl_\<alpha> AA) rf'"
    using someI [of "\<lambda>f. is_strong_equivalence_rename_fun (NFA_Impl_\<alpha> AA) f \<and>
                         (\<forall>q \<in> \<Q> (NFA_Impl_\<alpha> AA). f q \<in> \<Q> (NFA_Impl_\<alpha> AA))"]
    using is_strong_equivalence_rename_fun_exists [of "NFA_Impl_\<alpha> AA"]
    by (simp add: rf'_def[symmetric]) blast

  from is_strong_equivalence_rename_fun___isomorph [OF rf_prop rf'_prop]
  obtain rf'' where rf'_eq: "\<And>q. q\<in>\<Q> (NFA_Impl_\<alpha> AA) \<Longrightarrow> rf' q = rf'' (rf q)" and
                    rf'_inj: "inj_on rf'' (rf ` \<Q> (NFA_Impl_\<alpha> AA))"
    by fastforce

  have rename_eq: "rename_states (NFA_Impl_\<alpha> AA) rf' = rename_states (NFA_Impl_\<alpha> AA) (rf'' \<circ> rf)"
    apply (rule NFA.rename_states_agree_on_Q [OF wf_NFA_AA])
    apply (simp add: rf'_eq) 
  done

  show ?thesis
    unfolding Hopcroft_minimise_def Hopcroft_minimise_impl_def
              rm_def[symmetric] 
    apply (simp add: rename_impl_eq NFA_isomorphic_wf_def
                     rename_states___well_formed [OF wf_NFA_AA]
                     NFA_isomorphic_def rf'_def[symmetric])
    apply (rule exI [where x = rf''])
    apply (simp add: rf'_inj rename_eq)    
  done
qed
   

definition Hopcroft_minimise_DFA_impl where
 "Hopcroft_minimise_DFA_impl AA =
  Hopcroft_minimise_impl (remove_unreachable_states_impl AA)"

lemma Hopcroft_minimise_DFA_impl_correct :
assumes wf_AA: "DFA (NFA_Impl_\<alpha> AA)"
shows "NFA_isomorphic_wf (NFA_Impl_\<alpha> (Hopcroft_minimise_DFA_impl AA)) 
                         (Hopcroft_minimise_DFA (NFA_Impl_\<alpha> AA))"
proof -
  let ?AA' = "remove_unreachable_states_impl AA"

  from wf_AA have wf_NFA_AA: "NFA (NFA_Impl_\<alpha> AA)"
    by (simp add: DFA_alt_def)

  note AA'_alpha = remove_unreachable_states_impl_correct [OF wf_NFA_AA]

  from DFA.DFA___remove_unreachable_states [OF wf_AA] AA'_alpha
  have wf_AA': "DFA (NFA_Impl_\<alpha> ?AA')" by simp

  from Hopcroft_minimise_impl_correct [OF wf_AA']
       AA'_alpha
  show ?thesis
    unfolding Hopcroft_minimise_DFA_impl_def Hopcroft_minimise_DFA_def
    by simp
qed    


definition Hopcroft_minimise_NFA_impl where
 "Hopcroft_minimise_NFA_impl AA =
  Hopcroft_minimise_impl (NFA_determinise_impl AA)"

lemma Hopcroft_minimise_NFA_impl_correct :
assumes isomorphic: "NFA_isomorphic_wf (NFA_Impl_\<alpha> AA) \<A>"
shows "NFA_isomorphic_wf (NFA_Impl_\<alpha> (Hopcroft_minimise_NFA_impl AA)) 
                         (Hopcroft_minimise_NFA \<A>)"
proof -
  let ?AA' = "NFA_determinise_impl AA"
   
  from NFA_isomorphic_wf_D[OF isomorphic] 
  have wf_AA: "NFA (NFA_Impl_\<alpha> AA)" and wf_A: "NFA \<A>"
    by simp_all
  from NFA_determinise_impl_correct [OF wf_AA]
  have iso_AA': "NFA_isomorphic_wf (NFA_Impl_\<alpha> ?AA')
                       (efficient_NFA_determinise___same_states (NFA_Impl_\<alpha> AA))" .


  hence "NFA_isomorphic_wf (efficient_NFA_determinise___same_states (NFA_Impl_\<alpha> AA)) (NFA_Impl_\<alpha> ?AA')" 
    by (metis NFA_isomorphic_wf_sym)
  hence "NFA_isomorphic (efficient_NFA_determinise___same_states (NFA_Impl_\<alpha> AA)) (NFA_Impl_\<alpha> ?AA')"
    by (simp add: NFA_isomorphic_wf_def)
  with NFA_isomorphic___well_formed_DFA [of "efficient_NFA_determinise___same_states (NFA_Impl_\<alpha> AA)" 
     "NFA_Impl_\<alpha> ?AA'"]  DFA.efficient_NFA_determinise___same_states_is_DFA[OF wf_AA]
  have wf_DFA_AA': "DFA (NFA_Impl_\<alpha> ?AA')" by simp

  from Hopcroft_minimise_impl_correct [OF wf_DFA_AA']
  have iso2: "NFA_isomorphic_wf
      (NFA_Impl_\<alpha> (Hopcroft_minimise_NFA_impl AA))
      (Hopcroft_minimise (NFA_Impl_\<alpha> (NFA_determinise_impl AA)))"
    unfolding Hopcroft_minimise_NFA_impl_def by simp

  have iso3: "NFA_isomorphic_wf
      (Hopcroft_minimise (NFA_Impl_\<alpha> (NFA_determinise_impl AA)))
      (Hopcroft_minimise_NFA \<A>)"
  proof -
    note iso_AA'_2 = NFA_isomorphic_wf_D [OF iso_AA'] 

    have conn_AA': "is_initially_connected (NFA_Impl_\<alpha> ?AA')"
      apply (rule is_initially_connected___NFA_isomorphic [OF iso_AA'_2(4)])
      apply (simp add: efficient_NFA_determinise___same_states_def)
      apply (rule is_initially_connected___rename_states)
      apply (simp add: efficient_NFA_determinise_def 
                       remove_unreachable_states___is_initially_connected)
    done

    note min_props1 = Hopcroft_minimise_NFA_correct [OF wf_A]
    note min_props2 = Hopcroft_minimise_correct [OF wf_DFA_AA' conn_AA'] 
    
    show ?thesis
    proof (rule is_minimal___isomorph_wf)
       show "is_minimal (Hopcroft_minimise_NFA \<A>)"
         by (fact min_props1(1))
    next
       show "is_minimal (Hopcroft_minimise (NFA_Impl_\<alpha> (NFA_determinise_impl AA)))"
         by (fact min_props2(1))
    next
       show "\<L> (Hopcroft_minimise (NFA_Impl_\<alpha> (NFA_determinise_impl AA))) =
             \<L> (Hopcroft_minimise_NFA \<A>)"
         apply (simp add: min_props1(2) min_props2(2))
         apply (simp add: NFA_isomorphic_wf_\<L> [OF iso_AA']
                          NFA_isomorphic_wf_\<L> [OF isomorphic]
                          efficient_NFA_determinise___same_states_\<L>[OF wf_AA])
       done
    next
       from NFA_isomorphic_wf_\<Sigma> [OF iso_AA']
            NFA_isomorphic_wf_\<Sigma> [OF isomorphic]
       show "\<Sigma> (Hopcroft_minimise (NFA_Impl_\<alpha> (NFA_determinise_impl AA))) =
             \<Sigma> (Hopcroft_minimise_NFA \<A>)"
         unfolding Hopcroft_minimise_def Hopcroft_minimise_NFA_def
         by (simp add: efficient_NFA_determinise_def
                       efficient_NFA_determinise___same_states_def) 
    qed
  qed

  from NFA_isomorphic_wf_trans [OF iso2 iso3]
  show ?thesis .
qed    

fun is_partition_impl where
  "is_partition_impl Q [] = qS.isEmpty Q"
| "is_partition_impl Q (p # ps) =
   (\<not>(qS.isEmpty p) \<and> qS.subset p Q \<and> is_partition_impl (qS.diff Q p) ps)"

lemma is_partition_impl_correct :
  "is_partition_impl Q ps =
   ((is_partition (qS.\<alpha> Q) (set (map qS.\<alpha> ps))) \<and> distinct (map qS.\<alpha> ps))"
proof (induct ps arbitrary: Q)
  case Nil
  thus ?case by (simp add: qS.correct)
next
  case (Cons p ps Q)
  note ind_hyp = this

  show ?case
  proof (cases "qS.\<alpha> p = {}")
    case True
    thus ?thesis by (simp add: qS.correct is_partition_def)
  next
    case False note p_not_Emp = this
    show ?thesis
    proof (cases  "qS.\<alpha> p \<in> qS.\<alpha> ` set ps")
      case True with p_not_Emp  
      show ?thesis 
        by (auto simp add: ind_hyp qS.correct is_partition_def)
    next
      case False note p_nin_ps = this
      show ?thesis
        by (simp add: qS.correct p_nin_ps ind_hyp is_partition_Insert)
    qed
  qed
qed


definition is_weak2_language_equiv_partition_aux where
  "is_weak2_language_equiv_partition_aux D rm a q =
   (let Q = the (qaQM.lookup (q, a) D) in
    let q' = the (qS.sel Q (\<lambda>_. True)) in
    let n = the (qqM.lookup q' rm) in
   n)"


definition is_weak2_language_equiv_partition_impl 
  :: "'q_set \<times> 'a_set \<times> 'qas_map \<times> 'q_set \<times> 'q_set \<Rightarrow> 'q_set list \<Rightarrow> bool" where
  "is_weak2_language_equiv_partition_impl AA ps \<longleftrightarrow>
  (is_partition_impl (NFA_Impl_states AA) ps \<and>
   list_all (\<lambda>p. qS.disjoint p (NFA_Impl_accepting AA) \<or>
              qS.subset p (NFA_Impl_accepting AA)) ps \<and>
   (let rm = Hopcroft_equiv_partition_to_rename_fun ps in
    list_all (\<lambda>p. 
       let q = (the (set_op_sel set_opsQ p (\<lambda>_. True))) in
       aS.ball (NFA_Impl_labels AA)
         (\<lambda>a. let n = is_weak2_language_equiv_partition_aux (NFA_Impl_trans AA) rm a q in
              qS.ball p (\<lambda>q'. 
                 is_weak2_language_equiv_partition_aux (NFA_Impl_trans AA) rm a q' = n))) ps))"

lemma is_weak2_language_equiv_partition_impl_correct :
assumes wf_AA: "DFA (NFA_Impl_\<alpha> AA)"
    and weak2_pre: "is_weak2_language_equiv_partition_impl AA ps"
shows "is_weak2_language_equiv_partition (NFA_Impl_\<alpha> AA) (set (map qS.\<alpha> ps)) \<and> 
       distinct (map qS.\<alpha> ps)"
proof -
  interpret DFA_AA : DFA "(NFA_Impl_\<alpha> AA)" by (fact wf_AA)    
   
  from weak2_pre have "is_partition_impl (NFA_Impl_states AA) ps" 
    unfolding is_weak2_language_equiv_partition_impl_def by simp
  with is_partition_impl_correct have 
    is_part_ps: "is_partition (qS.\<alpha> (NFA_Impl_states AA)) (qS.\<alpha> ` set ps)" and
    dist_ps: "distinct (map qS.\<alpha> ps)" by simp_all

  have ps_subset : "\<And>p. p \<in> set ps \<Longrightarrow> qS.\<alpha> p \<subseteq> \<Q> (NFA_Impl_\<alpha> AA)"
    using is_part_ps
    unfolding is_partition_def 
    by (simp add: NFA_Impl_\<alpha>_simp2) auto

  have F_prop_ps : "\<And>p. p \<in> qS.\<alpha> ` set ps \<Longrightarrow>
        (p \<subseteq> \<F> (NFA_Impl_\<alpha> AA) \<or>
         p \<inter> \<F> (NFA_Impl_\<alpha> AA) = {})"
  proof -
    fix p
    assume p_in: "p \<in> qS.\<alpha> ` set ps"
    from weak2_pre have "list_all
       (\<lambda>p. qS.disjoint p (NFA_Impl_accepting AA) \<or>
            qS.subset p (NFA_Impl_accepting AA)) ps" 
      unfolding is_weak2_language_equiv_partition_impl_def by simp
    with p_in show "(p \<subseteq> \<F> (NFA_Impl_\<alpha> AA) \<or>
                     p \<inter> \<F> (NFA_Impl_\<alpha> AA) = {})"
      by (auto simp add: qS.correct list_all_iff Ball_def NFA_Impl_\<alpha>_simp2)
  qed

  have no_split: "\<And>p1 a p2.
         p1 \<in> qS.\<alpha> ` set ps \<Longrightarrow> a \<in> aS.\<alpha> (NFA_Impl_labels AA) \<Longrightarrow>
         p2 \<in> qS.\<alpha> ` set ps \<Longrightarrow>
         (\<not> split_language_equiv_partition_pred (NFA_Impl_\<alpha> AA) p1 a p2)" 
  proof -
    fix p1i a p2i
    assume p1i_in: "p1i \<in> qS.\<alpha> ` set ps"
       and a_in: "a \<in> aS.\<alpha> (NFA_Impl_labels AA)"
       and p2i_in: "p2i \<in> qS.\<alpha> ` set ps"
    
    from p1i_in obtain p1 where p1_in: "p1 \<in> set ps" and p1i_eq[simp]: "p1i = qS.\<alpha> p1"  by auto
    from p2i_in obtain p2 where p2_in: "p2 \<in> set ps" and p2i_eq[simp]: "p2i = qS.\<alpha> p2"  by auto

    def rm \<equiv> "Hopcroft_equiv_partition_to_rename_fun ps"
    def q1 \<equiv> "the (qS.sel p1 (\<lambda>_. True))"
 
    from weak2_pre have aux_prop1: "\<And>q q'. \<lbrakk>q \<in> qS.\<alpha> p1; q' \<in> qS.\<alpha> p1\<rbrakk> \<Longrightarrow>
              is_weak2_language_equiv_partition_aux (NFA_Impl_trans AA) rm a q =
              is_weak2_language_equiv_partition_aux (NFA_Impl_trans AA) rm a q'"
      unfolding is_weak2_language_equiv_partition_impl_def
      apply (simp add: qS.correct list_all_iff aS.correct rm_def[symmetric])
      apply (metis q1_def a_in p1_in)
    done

    from is_partition_in_subset[OF is_part_ps p1i_in, unfolded p1i_eq]
    have \<delta>_p1: "\<forall>q. q \<in> qS.\<alpha> p1 \<longrightarrow> (\<exists>qn. \<delta> (NFA_Impl_\<alpha> AA) (q, a) = Some qn)" 
       using DFA_AA.DFA_\<delta>_is_some [of _ a] a_in
       by (auto simp add: NFA_Impl_\<alpha>_simp2)

    from is_part_ps have "\<forall>p\<in>set ps. \<forall>p'\<in>set ps. qS.\<alpha> p \<noteq> qS.\<alpha> p' \<longrightarrow> qS.\<alpha> p' \<inter> qS.\<alpha> p = {}"
      unfolding is_partition_def by auto
    note rm_props = 
      Hopcroft_equiv_partition_to_rename_fun_correct [of ps, folded rm_def, OF this dist_ps]

    from rm_props(1) is_part_ps
    have dom_rm: "dom (qqM.\<alpha> rm) = qS.\<alpha> (NFA_Impl_states AA)"
      by (simp add: is_partition_def)

    have aux_eq: "\<And>q. q \<in> qS.\<alpha> (NFA_Impl_states AA) \<Longrightarrow>
      is_weak2_language_equiv_partition_aux (NFA_Impl_trans AA) rm a q =
      the (qqM.\<alpha> rm (the (\<delta> (NFA_Impl_\<alpha> AA) (q, a))))"
    proof -
      fix q
      assume q_in_Q: "q \<in> qS.\<alpha> (NFA_Impl_states AA)"

      from DFA_AA.DFA_\<delta>_is_some [of _ a] a_in q_in_Q
      obtain qn where qn_intro: "\<delta> (NFA_Impl_\<alpha> AA) (q, a) = Some qn"
        by (auto simp add: NFA_Impl_\<alpha>_simp2)

      from DFA_AA.\<delta>_in_\<Delta>_iff [symmetric] qn_intro 
      have "(q, a, qn) \<in> \<Delta> (NFA_Impl_\<alpha> AA)" by simp
      then obtain QN where QN_intro: "qaQM.\<alpha> (NFA_Impl_trans AA) (q, a) = Some QN"
                       and qn_in: "qn \<in> qS.\<alpha> QN" 
        by (auto simp add: NFA_Impl_\<alpha>_simp2 LTS_succ_map_\<alpha>_in)

      from QN_intro qn_in have QN_eq: "qS.\<alpha> QN = {qn}"
        using DFA_AA.weak_deterministic
        unfolding is_weak_deterministic_def
        apply (simp add: NFA_Impl_\<alpha>_simp2 LTS_succ_map_\<alpha>_in set_eq_iff)
        apply metis
      done

      have "the (qS.sel QN (\<lambda>_. True)) \<in> qS.\<alpha> QN"
        apply (rule_tac qS.sel'E [of QN qn "\<lambda>_. True"])
        apply (simp_all add: qn_in)
      done
      with QN_eq have sel_eq: "the (qS.sel QN (\<lambda>_. True)) = qn" by simp

      show "is_weak2_language_equiv_partition_aux (NFA_Impl_trans AA) rm a q =
            the (qqM.\<alpha> rm (the (\<delta> (NFA_Impl_\<alpha> AA) (q, a))))"
      by (simp add: is_weak2_language_equiv_partition_aux_def qaQM.correct QN_intro
                    qn_intro sel_eq qqM.correct)
    qed

    have aux_prop2: "\<And>q q'. \<lbrakk>q \<in> qS.\<alpha> (NFA_Impl_states AA); q' \<in> qS.\<alpha> (NFA_Impl_states AA);
              is_weak2_language_equiv_partition_aux (NFA_Impl_trans AA) rm a q =
              is_weak2_language_equiv_partition_aux (NFA_Impl_trans AA) rm a q'\<rbrakk> \<Longrightarrow>
        \<exists>p' qn qn'. p' \<in> set ps \<and> (\<delta> (NFA_Impl_\<alpha> AA) (q, a) = Some qn) \<and>
                    (\<delta> (NFA_Impl_\<alpha> AA) (q', a) = Some qn') \<and>
                    qn \<in> qS.\<alpha> p' \<and> qn' \<in> qS.\<alpha> p'"
    proof -
      fix q q'
      assume q_in : "q \<in> qS.\<alpha> (NFA_Impl_states AA)"
         and q'_in: "q' \<in> qS.\<alpha> (NFA_Impl_states AA)"
         and aux_eq_qq': "is_weak2_language_equiv_partition_aux (NFA_Impl_trans AA) rm a q =
                          is_weak2_language_equiv_partition_aux (NFA_Impl_trans AA) rm a q'"

      from DFA_AA.DFA_\<delta>_is_some [of _ a] a_in q_in
      obtain qn where qn_intro: "\<delta> (NFA_Impl_\<alpha> AA) (q, a) = Some qn"
        by (auto simp add: NFA_Impl_\<alpha>_simp2)
 
      from DFA_AA.DFA_\<delta>_is_some [of _ a] a_in q'_in
      obtain qn' where qn'_intro: "\<delta> (NFA_Impl_\<alpha> AA) (q', a) = Some qn'"
        by (auto simp add: NFA_Impl_\<alpha>_simp2)

      from DFA_AA.\<delta>_wf[OF qn_intro] dom_rm
      obtain cqn where rm_qn_eq: "qqM.\<alpha> rm qn = Some cqn"
        by (auto simp add: NFA_Impl_\<alpha>_simp2)

      from DFA_AA.\<delta>_wf[OF qn'_intro] dom_rm
      obtain cqn' where rm_qn'_eq: "qqM.\<alpha> rm qn' = Some cqn'"
        by (auto simp add: NFA_Impl_\<alpha>_simp2)

      from aux_eq_qq' have cqn'_eq: "cqn = cqn'"
        by (simp add: aux_eq[OF q_in] aux_eq[OF q'_in] qn_intro qn'_intro rm_qn_eq rm_qn'_eq)

      from rm_qn_eq rm_qn'_eq
      show "\<exists>p' qn qn'. p' \<in> set ps \<and> (\<delta> (NFA_Impl_\<alpha> AA) (q, a) = Some qn) \<and>
                    (\<delta> (NFA_Impl_\<alpha> AA) (q', a) = Some qn') \<and>
                    qn \<in> qS.\<alpha> p' \<and> qn' \<in> qS.\<alpha> p'"
        apply (auto simp add: qn'_intro qn_intro cqn'_eq rm_props(2)
          states_enumerate_eq)
        apply (metis nth_mem)
      done
    qed

    have aux_prop: "\<And>q q'. \<lbrakk>q \<in> qS.\<alpha> p1; q' \<in> qS.\<alpha> p1\<rbrakk> \<Longrightarrow>
        \<exists>p' qn qn'. p' \<in> set ps \<and> (\<delta> (NFA_Impl_\<alpha> AA) (q, a) = Some qn) \<and>
                    (\<delta> (NFA_Impl_\<alpha> AA) (q', a) = Some qn') \<and>
                    qn \<in> qS.\<alpha> p' \<and> qn' \<in> qS.\<alpha> p'"
      apply (rule aux_prop2)
        apply (insert is_partition_in_subset[OF is_part_ps p1i_in, unfolded p1i_eq]) [2]
        apply (simp add: subset_iff) 
        apply (simp add: subset_iff) 
      apply (rule aux_prop1)
      apply simp_all
    done

    have p2_prop: "\<And>p'. p' \<in> set ps \<Longrightarrow> (qS.\<alpha> p' = qS.\<alpha> p2) \<or> (qS.\<alpha> p' \<inter> qS.\<alpha> p2) = {}"
      using is_part_ps p2_in 
      unfolding is_partition_def 
      by (simp add: image_iff) metis
       
    have "(\<forall>q qn. (q \<in> qS.\<alpha> p1 \<and> \<delta> (NFA_Impl_\<alpha> AA) (q, a) = Some qn) \<longrightarrow>
                 qn \<in> qS.\<alpha> p2) \<or>
          (\<forall>q qn. (q \<in> qS.\<alpha> p1 \<and> \<delta> (NFA_Impl_\<alpha> AA) (q, a) = Some qn) \<longrightarrow>
                 qn \<notin> qS.\<alpha> p2)"
    proof -
       from is_part_ps p1i_in have "qS.\<alpha> p1 \<noteq> {}"
         unfolding p1i_eq is_partition_def by auto
       then obtain q'' where q''_in: "q'' \<in> qS.\<alpha> p1" by auto
       with \<delta>_p1 obtain qn'' where qn''_intro: "\<delta> (NFA_Impl_\<alpha> AA) (q'', a) = Some qn''"
         by auto

       have "\<And>q qn. \<lbrakk>q \<in> qS.\<alpha> p1; \<delta> (NFA_Impl_\<alpha> AA) (q, a) = Some qn\<rbrakk> \<Longrightarrow>
                 qn \<in> qS.\<alpha> p2 \<longleftrightarrow> qn'' \<in> qS.\<alpha> p2" 
       proof -
         fix q qn
         assume q_in_p1: "q \<in> qS.\<alpha> p1" and
                qn_intro: "\<delta> (NFA_Impl_\<alpha> AA) (q, a) = Some qn"
         from aux_prop[OF q_in_p1 q''_in] 
         obtain p' where p'_in_ps: "p' \<in> set ps" and
                         qn_in: "qn \<in> qS.\<alpha> p'" and
                         qn'_in: "qn'' \<in> qS.\<alpha> p'" 
           by (auto simp add: qn_intro qn''_intro)

         from p2_prop [OF p'_in_ps] qn_in qn'_in
         show "qn \<in> qS.\<alpha> p2 \<longleftrightarrow> qn'' \<in> qS.\<alpha> p2" by auto
       qed
       thus ?thesis by metis
    qed

    with \<delta>_p1 show "\<not>(split_language_equiv_partition_pred (NFA_Impl_\<alpha> AA) p1i a p2i)"
      unfolding split_language_equiv_partition_pred_def
                split_language_equiv_partition_def p1i_eq p2i_eq split_set_def
      apply (simp add: DFA_AA.\<delta>_in_\<Delta>_iff Bex_def)
      apply metis
    done
  qed
  
  have weak2_set: "\<And>p. p \<in> set ps \<Longrightarrow>
        is_weak2_language_equiv_set (NFA_Impl_\<alpha> AA) (qS.\<alpha> p)"  
  proof -
    fix p
    assume p_in: "p \<in> set ps"

    from DFA.split_language_equiv_partition_final___weak2 [OF wf_AA, of "qS.\<alpha> ` set ps"
       "qS.\<alpha> p"] is_part_ps F_prop_ps no_split p_in
    show "is_weak2_language_equiv_set (NFA_Impl_\<alpha> AA) (qS.\<alpha> p)"
      by (simp add: NFA_Impl_\<alpha>_simp2)
  qed

  from is_part_ps weak2_set
  show ?thesis
    unfolding is_weak2_language_equiv_partition_def
    apply (simp add: Ball_def dist_ps NFA_Impl_\<alpha>_simp2 image_iff Bex_def)
    apply auto
  done
qed

end

end

