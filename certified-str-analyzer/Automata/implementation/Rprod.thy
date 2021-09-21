
theory Rprod

imports Main "Refine_Monadic.Refine_Monadic" "CAVA_Base.CAVA_Base" "Collections.Collections"

begin
 

text \<open> Component-wise refinement for product types: \<close>
definition [simp]: "rprod R1 R2 \<equiv> { ((a,b),(a',b')) . (a,a')\<in>R1 \<and> (b,b')\<in>R2 }"


lemma rprod_RELATES[refine_dref_RELATES]:
  "RELATES Ra \<Longrightarrow> RELATES Rb \<Longrightarrow> RELATES (rprod Ra Rb)"
  by (simp add: RELATES_def)

lemma rprod_sv[refine_hsimp]:
  "\<lbrakk>single_valued R1; single_valued R2\<rbrakk> \<Longrightarrow> single_valued (rprod R1 R2)"
  by (auto intro: single_valuedI dest: single_valuedD)



text \<open>
    Product splitting has not yet been solved properly. Below, you see the
    current hack that works in many cases.
    \<close>
  lemma rprod_iff [simp]:
    "((a,b),(a',b'))\<in>rprod R1 R2 \<longleftrightarrow> (a,a')\<in>R1 \<and> (b,b')\<in>R2" by auto
  (*lemmas [autoref_simp] = split_paired_all*)

  lemma prod_id_split [simp]: "Id = rprod Id Id" by auto

  lemma prod_split_elim [simp]:
    "\<lbrakk>(x,x')\<in>rprod Ra Rb;
      \<And>a b a' b'. \<lbrakk>x=(a,b); x'=(a',b'); (a,a')\<in>Ra; (b,b')\<in>Rb\<rbrakk>
        \<Longrightarrow> (f a b,f' (a',b'))\<in>R
    \<rbrakk>
    \<Longrightarrow> (case_prod f x,f' x')\<in>R" by auto

  lemma prod_split_elim_prg[simp]:
    "\<lbrakk>(x,x')\<in>rprod Ra Rb;
      \<And>a b a' b'. \<lbrakk>x=(a,b); x'=(a',b'); (a,a')\<in>Ra; (b,b')\<in>Rb\<rbrakk>
        \<Longrightarrow> f a b \<le> \<Down>R (f' (a',b'))
    \<rbrakk>
    \<Longrightarrow> case_prod f x \<le>\<Down>R (f' x')" by auto

  lemma rprod_spec:
    fixes ca :: 'ca and cb::'cb and aa::'aa and ab::'ab
    assumes "(ca,aa)\<in>Ra"
    assumes "(cb,ab)\<in>Rb"
    shows "((ca,cb),(aa,ab))\<in>rprod Ra Rb"
    using assms by auto

  text \<open> This will split all products by default. In most cases, this is
    the desired behaviour, otherwise the lemma should be removed in your local
    theory by @{text "declare rprod_spec[autoref_spec del]"}
    \<close>

  lemma prod_case_autoref_ex[simp]:
    assumes "(f, f' a' b')\<in>R"
    shows "(f, case_prod f' (a',b'))\<in>R"
    using assms by auto

lemma prod_case_autoref_prg[simp]:
    assumes "f \<le>\<Down>R (f' a' b')"
    shows "f \<le>\<Down>R (case_prod f' (a',b'))"
    using assms by auto

  lemma pair_autoref[simp]:
    "\<lbrakk> (a,a')\<in>Ra; (b,b')\<in>Rb \<rbrakk> \<Longrightarrow> ((a,b),(a',b'))\<in>rprod Ra Rb"
    by auto

end 