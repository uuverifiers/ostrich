theory Set_map_extend

imports "Collections.Collections"  LTS_Impl

begin


locale set_iteratei = finite_set \<alpha> invar
    for \<alpha> :: "'s \<Rightarrow> ('u::linorder) set" and invar
    +
    fixes iterateoi :: "'s \<Rightarrow> ('u,'\<sigma>) set_iterator"
    assumes iteratei_rule: 
      "invar s \<Longrightarrow> set_iterator (iterateoi s) (\<alpha> s)"

lemma set_iteratei_alt_def :
  "set_iteratei \<alpha> invar it \<longleftrightarrow> 
   (\<forall>s. invar s \<longrightarrow> set_iterator (\<lambda>c f \<sigma>. it s c f \<sigma>) (\<alpha> s))"   
proof (intro allI impI iffI)
  fix s
  assume it_OK: "set_iteratei \<alpha> invar it"
     and invar_s: "invar s"
  thus "set_iterator (\<lambda>c f. it s c f) (\<alpha> s)"
    apply (insert it_OK)
    unfolding set_iterator_def set_iterator_def
              set_iteratei_def finite_set_def
              set_iteratei_axioms_def
              set_iterator_linord_def
    by (auto simp add: invar_s)
next
  assume rs: "\<forall>s. invar s \<longrightarrow> set_iterator (\<lambda>c f. it s c f) (\<alpha> s)"

  have "\<forall>s. invar s \<longrightarrow> finite (\<alpha> s)"
  proof (intro allI impI)
    fix s 
    assume "invar s"
    with rs have "set_iterator (\<lambda>c f. it s c f) (\<alpha> s)" 
      unfolding set_iterator_def by simp
    show "finite (\<alpha> s)"
      using \<open>set_iterator (it s) (\<alpha> s)\<close> set_iterator_finite by blast
  qed

  with rs show "set_iteratei \<alpha> invar it"
    unfolding set_iterator_def set_iterator_def 
              set_iteratei_def finite_set_def
              set_iteratei_axioms_def
    by blast
qed

definition map_to_set_iterator where
  "map_to_set_iterator m it = (\<lambda> c f. it m c f)"
locale map_iteratei = finite_map +
  constrains \<alpha> :: "'a \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes iteratei :: "'a \<Rightarrow> ('u \<times> 'v,'\<sigma>) set_iterator"
  assumes iteratei_rule: "invar m \<Longrightarrow> map_iterator (iteratei m) (\<alpha> m)"
  

begin
  lemma iteratei_rule_P:
    assumes "invar m"
        and I0: "I (dom (\<alpha> m)) \<sigma>0"
        and IP: "\<And> k v it \<sigma>. 
                   \<lbrakk> c \<sigma>; k \<in> it; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                    \<Longrightarrow> I (it - {k}) (f (k, v) \<sigma>)"
        and IF: "\<And> \<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>"
        and II: "\<And> \<sigma> it. \<lbrakk> it \<subseteq> dom (\<alpha> m); it \<noteq> {}; \<not> c \<sigma>; I it \<sigma> \<rbrakk> \<Longrightarrow> P \<sigma>"
    shows "P (iteratei m c f \<sigma>0)"
    using map_iterator_rule_P [OF iteratei_rule, of m I \<sigma>0 c f P]
    by (simp_all add: assms)

  lemma iteratei_rule_insert_P:
    assumes  
      "invar m" 
      "I {} \<sigma>0"
      "!!k v it \<sigma>. \<lbrakk> c \<sigma>; k \<in> (dom (\<alpha> m) - it); \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
          \<Longrightarrow> I (insert k it) (f (k, v) \<sigma>)"
      "!!\<sigma>. I (dom (\<alpha> m)) \<sigma> \<Longrightarrow> P \<sigma>"
      "!!\<sigma> it. \<lbrakk> it \<subseteq> dom (\<alpha> m); it \<noteq> dom (\<alpha> m); 
               \<not> (c \<sigma>); 
               I it \<sigma> \<rbrakk> \<Longrightarrow> P \<sigma>"
    shows "P (iteratei m c f \<sigma>0)"
    using map_iterator_rule_insert_P [OF iteratei_rule, of m I \<sigma>0 c f P]
    by (simp_all add: assms)

  lemma iterate_rule_P:
    "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> k \<in> it; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f (k, v) \<sigma>);
      !!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>
    \<rbrakk> \<Longrightarrow> P (iteratei m (\<lambda>_. True) f \<sigma>0)"
    using iteratei_rule_P [of m I \<sigma>0 "\<lambda>_. True" f P]
    by fast

  lemma iterate_rule_insert_P:
    "\<lbrakk>
      invar m;
      I {} \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> k \<in> (dom (\<alpha> m) - it); \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (insert k it) (f (k, v) \<sigma>);
      !!\<sigma>. I (dom (\<alpha> m)) \<sigma> \<Longrightarrow> P \<sigma>
    \<rbrakk> \<Longrightarrow> P (iteratei m (\<lambda>_. True) f \<sigma>0)"
    using iteratei_rule_insert_P [of m I \<sigma>0 "\<lambda>_. True" f P]
    by fast

 
end

lemma map_iteratei_alt_D :
  "map_iteratei \<alpha> invar it \<Longrightarrow>
   invar m \<Longrightarrow> set_iterator (map_to_set_iterator m it) (map_to_set (\<alpha> m))"

  apply (simp add: map_to_set_iterator_def map_iteratei_def map_iteratei_axioms_def)
  done

lemma set_iteratei_alt_D :
  "set_iteratei \<alpha> invar it \<Longrightarrow>
   invar s \<Longrightarrow> set_iterator (\<lambda>c f \<sigma>. it s c f \<sigma>) (\<alpha> s)"
by (simp add: set_iteratei_alt_def)

lemma map_iteratei_I :
  assumes "\<And>m. invar m \<Longrightarrow> map_iterator (iti m) (\<alpha> m)"
  shows "map_iteratei \<alpha> invar iti"
proof
  fix m 
  assume invar_m: "invar m"
  from assms(1)[OF invar_m] show it_OK: "map_iterator (iti m) (\<alpha> m)" .
  
  from set_iterator_genord.finite_S0 [OF it_OK[unfolded set_iterator_def]]
  show "finite (dom (\<alpha> m))" by (simp add: finite_map_to_set) 
qed



lemma map_iteratei_alt_def :
  "map_iteratei \<alpha> invar it \<longleftrightarrow>
   (\<forall>m. invar m \<longrightarrow> set_iterator (map_to_set_iterator m it) 
                                 (map_to_set (\<alpha> m)))"
proof (intro allI impI iffI)
  fix m
  assume it_OK: "map_iteratei \<alpha> invar it"
     and invar_m: "invar m"
  show "set_iterator (map_to_set_iterator m it) (map_to_set (\<alpha> m))"
    apply (insert it_OK)
    unfolding map_iteratei_def map_to_set_iterator_def map_iteratei_axioms_def
    by (auto simp add: invar_m)
next
  assume rs: "\<forall>m. invar m \<longrightarrow> set_iterator (map_to_set_iterator m it) 
                                           (map_to_set (\<alpha> m))"
  show "map_iteratei \<alpha> invar it"
    apply (insert rs)
    unfolding map_iteratei_def map_iteratei_axioms_def map_to_set_iterator_def
    finite_map_def
    using map_iterator_finite by blast
qed




lemma rm_iteratei_impl: 
      "map_iteratei rm.\<alpha> rm.invar rm_iteratei"
  unfolding Set_map_extend.map_iteratei_def
  unfolding finite_map_def
  apply simp
  unfolding Set_map_extend.map_iteratei_axioms_def
  apply simp
  by (simp add: rm.iteratei_correct)


lemma rs_iteratei_impl:
  shows "set_iteratei rs.\<alpha> rs.invar rs_iteratei"
  unfolding set_iteratei_def
  unfolding finite_set_def
  apply simp
  unfolding set_iteratei_axioms_def
  apply simp
  by (simp add: rs.iteratei_correct)

end
