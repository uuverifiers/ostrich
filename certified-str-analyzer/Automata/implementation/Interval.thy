
theory Interval

imports Main

begin

locale interval = 
  fixes sem_interval :: "('a::linorder) \<times> 'a \<Rightarrow> 'a set"
  fixes empty:: "'a \<times> 'a \<Rightarrow> bool"
  fixes noempty:: "'a \<times> 'a \<Rightarrow> bool"
  fixes intersect:: "'a \<times> 'a  \<Rightarrow> 'a \<times> 'a \<Rightarrow> 'a \<times> 'a"
  fixes elem:: "'a  \<Rightarrow> 'a \<times> 'a \<Rightarrow> bool"
  assumes 
    sem_interval_def : "sem_interval s = {e. (fst s) \<le> e \<and> e \<le> (snd s)}" and
    empty_sem: "empty s = ({e. (fst s) \<le> e \<and> e \<le> (snd s)} = {})" and
    noempty_sem: "noempty s = ({e. (fst s) \<le> e \<and> e \<le> (snd s)} \<noteq> {})" and
    intersect_sem: "{e. fst (intersect s1 s2) \<le> e \<and>
                     e \<le> snd (intersect s1 s2)} = 
                                 {e. (fst s1) \<le> e \<and> e \<le> (snd s1)} \<inter>
                                 {e. (fst s2) \<le> e \<and> e \<le> (snd s2)}" and
    elem_sem: "elem a s = ((fst s) \<le> a \<and> a \<le> (snd s))"
begin 

lemma empty_sem_alt: "empty s = (sem_interval s = {})" 
  by (auto simp add: empty_sem sem_interval_def)

lemma intersect_sem_alt: "sem_interval (intersect s1 s2) = 
                          sem_interval s1 \<inter> sem_interval s2" 
     by (auto simp add: intersect_sem sem_interval_def)

lemma elem_sem_alt: "elem a s = (a \<in> (sem_interval s))"
  by (auto simp add: elem_sem sem_interval_def)
end

definition semI :: "'a::linorder \<times> 'a \<Rightarrow> 'a set" where
    "semI s = {e. fst s \<le> e \<and> e \<le> snd s}"

definition empI where
    "empI s = ((snd s) < (fst s))"

definition nempI where
    "nempI s = ((fst s) \<le> (snd s))"


definition intersectI where
    "intersectI s1 s2 = ((if (fst s1) < (fst s2) then fst s2 else fst s1),
                        (if (snd s1) < (snd s2) then snd s1 else snd s2))"



definition elemI where
    "elemI a s = ((fst s) \<le> a \<and> a \<le> (snd s))"


theorem interval_impl_correct: "interval semI empI nempI intersectI elemI"
  by (auto simp add: interval_def empI_def intersectI_def elemI_def semI_def 
       nempI_def)
  

lemma inj_semI_aux: "\<And> x y. semI x \<noteq> {} \<and> semI y \<noteq> {} \<and> semI x = semI y 
                 \<Longrightarrow> fst x = fst y \<and> snd x = snd y"
proof -
  fix x y
  assume ass: "semI x \<noteq> {} \<and> semI y \<noteq> {} \<and> semI x = semI y"
  from this have cons1: "fst x \<le> snd x"
    by (metis (mono_tags, lifting) empI_def interval_def 
        interval_impl_correct not_le_imp_less)
  from ass have cons2: "fst y \<le> snd y"
        by (metis (mono_tags, lifting) empI_def interval_def 
        interval_impl_correct not_le_imp_less)
  from ass cons1 cons2 show "fst x = fst y \<and> snd x = snd y"
    apply (simp add: semI_def)
    using antisym by auto
qed

lemma inj_semI: "\<And> x y. semI x \<noteq> {} \<longrightarrow> semI y \<noteq> {}  \<longrightarrow> (semI x = semI y 
                 \<longleftrightarrow> x = y)"
  using inj_semI_aux by fastforce

lemma inter_correct : "semI (intersectI s1 s2) = 
                       (semI s1 \<inter> semI s2)"
  unfolding intersectI_def
  apply (simp add: if_split)
  apply auto
  apply (metis (mono_tags, lifting) dual_order.strict_trans1 fst_conv interval.sem_interval_def interval_impl_correct mem_Collect_eq order.strict_implies_order snd_conv)
  apply (metis (no_types, lifting) dual_order.strict_implies_order dual_order.strict_trans2 fst_conv interval.sem_interval_def interval_impl_correct mem_Collect_eq snd_conv)
       apply (simp add: semI_def)
  apply (metis (mono_tags, lifting) dual_order.strict_trans1 interval.sem_interval_def interval_impl_correct leI mem_Collect_eq order_less_imp_le)
  apply (metis (mono_tags, lifting) dual_order.strict_implies_order dual_order.strict_trans2 interval.sem_interval_def interval_impl_correct mem_Collect_eq not_le_imp_less)
  apply (metis (no_types, lifting) dual_order.strict_trans1 eq_fst_iff interval.sem_interval_def interval_impl_correct leI mem_Collect_eq snd_conv)
  apply (metis (no_types, lifting) dual_order.strict_trans2 eq_fst_iff interval.sem_interval_def interval_impl_correct mem_Collect_eq not_le_imp_less snd_conv)
  by (metis (no_types, lifting) fst_conv interval.sem_interval_def interval_impl_correct mem_Collect_eq snd_conv)

lemma inter_correct1: "semI (intersectI s1 s2) \<noteq> {} \<longrightarrow>
                       semI s1 \<noteq> {} \<and> semI s2 \<noteq> {}"
  by (auto simp add: inter_correct)

lemma inter_correct2: "semI s1  \<inter> semI s2 \<noteq> {} \<longrightarrow>
                       semI s1 \<noteq> {} \<and> semI s2 \<noteq> {}"
  by (auto simp add: inter_correct)

lemma nempI_correct: "nempI x \<longleftrightarrow> (semI x \<noteq> {})" 
  apply (simp add: nempI_def semI_def)
  by fastforce


lemma nempI_inter_correct: "nempI (intersectI (fst a) (snd a)) \<longleftrightarrow> 
                            semI (fst a) \<inter> semI (snd a) \<noteq> {}"
  by (simp add: inter_correct nempI_correct)

end



