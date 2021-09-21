(*  Title:       Isabelle Collections Library
    Author:      Peter Lammich <peter dot lammich at uni-muenster.de>
    Maintainer:  Peter Lammich <peter dot lammich at uni-muenster.de>
*)
section {* \chapter{Specifications} \label{ch:specs} \isaheader{Specification of Maps} *}

theory MapSpec
imports Main
begin
text_raw{*\label{thy:MapSpec}*}

text {*
  This theory specifies map operations by means of mapping to
  HOL's map type, i.e. @{typ "'k \<rightharpoonup> 'v"}.
*}

locale map = 
  fixes \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"                 
  fixes invar :: "'s \<Rightarrow> bool"                   

subsection "Basic Map Functions"

subsubsection "Empty Map"
locale map_empty = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes empty :: "'s"
  assumes empty_correct:
    "\<alpha> empty = Map.empty"
    "invar empty"

subsubsection "Lookup"
locale map_lookup = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes lookup :: "'u \<Rightarrow> 's \<Rightarrow> 'v option"
  assumes lookup_correct:
    "invar m \<Longrightarrow> lookup k m = \<alpha> m k"

subsubsection "Update"
locale map_update = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes update :: "'u \<Rightarrow> 'v \<Rightarrow> 's \<Rightarrow> 's"
  assumes update_correct:
    "invar m \<Longrightarrow> \<alpha> (update k v m) = (\<alpha> m)(k \<mapsto> v)"
    "invar m \<Longrightarrow> invar (update k v m)"

subsubsection "Disjoint Update"
locale map_update_dj = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes update_dj :: "'u \<Rightarrow> 'v \<Rightarrow> 's \<Rightarrow> 's"
  assumes update_dj_correct: 
    "\<lbrakk>invar m; k\<notin>dom (\<alpha> m)\<rbrakk> \<Longrightarrow> \<alpha> (update_dj k v m) = (\<alpha> m)(k \<mapsto> v)"
    "\<lbrakk>invar m; k\<notin>dom (\<alpha> m)\<rbrakk> \<Longrightarrow> invar (update_dj k v m)"

 
subsubsection "Delete"
locale map_delete = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes delete :: "'u \<Rightarrow> 's \<Rightarrow> 's"
  assumes delete_correct: 
    "invar m \<Longrightarrow> \<alpha> (delete k m) = (\<alpha> m) |` (-{k})"
    "invar m \<Longrightarrow> invar (delete k m)"

subsubsection "Add"
locale map_add = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes add :: "'s \<Rightarrow> 's \<Rightarrow> 's"
  assumes add_correct:
    "invar m1 \<Longrightarrow> invar m2 \<Longrightarrow> \<alpha> (add m1 m2) = \<alpha> m1 ++ \<alpha> m2"
    "invar m1 \<Longrightarrow> invar m2 \<Longrightarrow> invar (add m1 m2)"

locale map_add_dj = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes add_dj :: "'s \<Rightarrow> 's \<Rightarrow> 's"
  assumes add_dj_correct:
    "\<lbrakk>invar m1; invar m2; dom (\<alpha> m1) \<inter> dom (\<alpha> m2) = {}\<rbrakk> \<Longrightarrow> \<alpha> (add_dj m1 m2) = \<alpha> m1 ++ \<alpha> m2"
    "\<lbrakk>invar m1; invar m2; dom (\<alpha> m1) \<inter> dom (\<alpha> m2) = {} \<rbrakk> \<Longrightarrow> invar (add_dj m1 m2)"

subsubsection "Emptiness Check"
locale map_isEmpty = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes isEmpty :: "'s \<Rightarrow> bool"
  assumes isEmpty_correct : "invar m \<Longrightarrow> isEmpty m \<longleftrightarrow> \<alpha> m = Map.empty"

subsubsection "Singleton Maps"
locale map_sng = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes sng :: "'u \<Rightarrow> 'v \<Rightarrow> 's"
  assumes sng_correct : 
    "\<alpha> (sng k v) = [k \<mapsto> v]"
    "invar (sng k v)"

locale map_isSng = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'k \<rightharpoonup> 'v"
  fixes isSng :: "'s \<Rightarrow> bool"
  assumes isSng_correct:
    "invar s \<Longrightarrow> isSng s \<longleftrightarrow> (\<exists>k v. \<alpha> s = [k \<mapsto> v])"
begin
  lemma isSng_correct_exists1 :
    "invar s \<Longrightarrow> (isSng s \<longleftrightarrow> (\<exists>!k. \<exists>v. (\<alpha> s k = Some v)))"
    apply (auto simp add: isSng_correct split: if_split_asm)
    apply (rule_tac x=k in exI)
    apply (rule_tac x=v in exI)
    apply (rule ext)
    apply (case_tac "\<alpha> s x")
    apply auto
    apply force
    done

  lemma isSng_correct_card :
    "invar s \<Longrightarrow> (isSng s \<longleftrightarrow> (card (dom (\<alpha> s)) = 1))"
    by (auto simp add: isSng_correct card_Suc_eq dom_eq_singleton_conv)

end

subsubsection "Finite Maps"
locale finite_map = map +
  assumes finite[simp, intro!]: "invar m \<Longrightarrow> finite (dom (\<alpha> m))"

subsubsection "Size"
locale map_size = finite_map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes size :: "'s \<Rightarrow> nat"
  assumes size_correct: "invar s \<Longrightarrow> size s = card (dom (\<alpha> s))"
  
locale map_size_abort = finite_map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes size_abort :: "nat \<Rightarrow> 's \<Rightarrow> nat"
  assumes size_abort_correct: "invar s \<Longrightarrow> size_abort m s = min m (card (dom (\<alpha> s)))"

subsubsection "Iterators"
text {*
  An iteration combinator over a map applies a function to a state for each 
  map entry, in arbitrary order.
  Proving of properties is done by invariant reasoning.
*}
type_synonym
  ('s,'u,'v,'\<sigma>) map_iterator = "('u \<Rightarrow> 'v \<Rightarrow> '\<sigma> \<Rightarrow> '\<sigma>) \<Rightarrow> 's \<Rightarrow> '\<sigma> \<Rightarrow> '\<sigma>"

locale map_iterate = finite_map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes iterate :: "('s,'u,'v,'\<sigma>) map_iterator"

  assumes iterate_rule: "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> k \<in> it; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k v \<sigma>)
    \<rbrakk> \<Longrightarrow> I {} (iterate f m \<sigma>0)"
begin
  lemma iterate_rule_P':
    "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> k \<in> it; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k v \<sigma>);
      I {} (iterate f m \<sigma>0) \<Longrightarrow> P
    \<rbrakk> \<Longrightarrow> P"
    by (metis iterate_rule)

  lemma iterate_rule_insert_P':
    assumes A: 
      "invar m" 
      "I {} \<sigma>0"
      "!!k v it \<sigma>. \<lbrakk> k \<in> (dom (\<alpha> m) - it); \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
          \<Longrightarrow> I (insert k it) (f k v \<sigma>)"
    assumes C: 
      "I (dom (\<alpha> m)) (iterate f m \<sigma>0) \<Longrightarrow> P"
    shows 
      "P"
  proof -
    let ?I' = "\<lambda>it \<sigma>. I (dom(\<alpha> m) - it) \<sigma>"

    have pre :"!!k v it \<sigma>. \<lbrakk> k \<in> it; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); ?I' it \<sigma> \<rbrakk> 
                  \<Longrightarrow> ?I' (it - {k}) (f k v \<sigma>)"
    proof -
      fix k v it \<sigma>
      assume AA : "k \<in> it" "\<alpha> m k = Some v" "it \<subseteq> dom (\<alpha> m)" "?I' it \<sigma>"  

      from AA(1) AA(3) have "dom (\<alpha> m) - (it - {k}) = insert k (dom (\<alpha> m) - it)" by auto
      moreover
      note A(3) [of k "dom (\<alpha> m) - it" v "\<sigma>"] AA
      ultimately show "?I' (it - {k}) (f k v \<sigma>)"
        by auto
    qed

    note iterate_rule_P' [of m ?I' \<sigma>0 f P] pre
    thus "P" using A C by auto
  qed

  lemma iterate_rule_P:
    "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> k \<in> it; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k v \<sigma>);
      !!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>
    \<rbrakk> \<Longrightarrow> P (iterate f m \<sigma>0)"
    using iterate_rule_P' [of m I \<sigma>0 f "P (iterate f m \<sigma>0)"] 
    by fast

  lemma iterate_rule_insert_P:
    "\<lbrakk>
      invar m;
      I {} \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> k \<in> (dom (\<alpha> m) - it); \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (insert k it) (f k v \<sigma>);
      !!\<sigma>. I (dom (\<alpha> m)) \<sigma> \<Longrightarrow> P \<sigma>
    \<rbrakk> \<Longrightarrow> P (iterate f m \<sigma>0)"
    using iterate_rule_insert_P' [of m I \<sigma>0 f "P (iterate f m \<sigma>0)"]
    by fast
end

text {*
  An iterator can also contain a continuation condition. Iteration is
  interrupted if the condition becomes false.
*}
type_synonym
  ('s,'u,'v,'\<sigma>) map_iteratori = 
    "('\<sigma> \<Rightarrow> bool) \<Rightarrow> ('u \<Rightarrow> 'v \<Rightarrow> '\<sigma> \<Rightarrow> '\<sigma>) \<Rightarrow> 's \<Rightarrow> '\<sigma> \<Rightarrow> '\<sigma>"

locale map_iteratei = finite_map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes iteratei :: "('s,'u,'v,'\<sigma>) map_iteratori"

  assumes iteratei_rule: "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k v \<sigma>)
    \<rbrakk> \<Longrightarrow> 
        I {} (iteratei c f m \<sigma>0) \<or> 
        (\<exists>it. it \<subseteq> dom (\<alpha> m) \<and> it \<noteq> {} \<and> 
              \<not> (c (iteratei c f m \<sigma>0)) \<and> 
              I it (iteratei c f m \<sigma>0))"
begin
  lemma iteratei_rule_P':
    "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                  \<Longrightarrow> I (it - {k}) (f k v \<sigma>);
      \<lbrakk> I {} (iteratei c f m \<sigma>0)\<rbrakk>  \<Longrightarrow> P;
      !!it. \<lbrakk> it \<subseteq> dom (\<alpha> m); it \<noteq> {}; 
              \<not> (c (iteratei c f m \<sigma>0)); 
              I it (iteratei c f m \<sigma>0) \<rbrakk> \<Longrightarrow> P
    \<rbrakk> \<Longrightarrow> P"
    using iteratei_rule[of m I \<sigma>0 c f]
    by blast

  lemma iteratei_rule_insert_P':
    assumes A: 
      "invar m" 
      "I {} \<sigma>0"
      "!!k v it \<sigma>. \<lbrakk> c \<sigma>; k \<in> (dom (\<alpha> m) - it); \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
          \<Longrightarrow> I (insert k it) (f k v \<sigma>)"
    assumes C: 
      "I (dom (\<alpha> m)) (iteratei c f m \<sigma>0) \<Longrightarrow> P"
      "!!it. \<lbrakk> it \<subseteq> dom (\<alpha> m); it \<noteq> dom (\<alpha> m); 
               \<not> (c (iteratei c f m \<sigma>0)); 
               I it (iteratei c f m \<sigma>0) \<rbrakk> \<Longrightarrow> P"
    shows 
      "P"
  proof -
    let ?I' = "\<lambda>it \<sigma>. I (dom(\<alpha> m) - it) \<sigma>"

    have pre1: 
      "!!it. \<lbrakk> it \<subseteq> dom (\<alpha> m); it \<noteq> {}; 
              \<not> (c (iteratei c f m \<sigma>0)); 
              ?I' it (iteratei c f m \<sigma>0)
             \<rbrakk> \<Longrightarrow> P"
    proof -
      fix it
      assume AA: 
        "it \<subseteq> dom (\<alpha> m)" "it \<noteq> {}"
        "\<not> (c (iteratei c f m \<sigma>0))" 
        "?I' it (iteratei c f m \<sigma>0)"

      from AA have "dom (\<alpha> m) - it \<noteq> dom (\<alpha> m)" by auto
      moreover
      note C(2) [of "dom (\<alpha> m) - it"] AA
      ultimately show "P" by auto
    qed

    have pre2 :"!!k v it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); ?I' it \<sigma> \<rbrakk> 
                  \<Longrightarrow> ?I' (it - {k}) (f k v \<sigma>)"
    proof -
      fix k v it \<sigma>
      assume AA : "k \<in> it" "\<alpha> m k = Some v" "it \<subseteq> dom (\<alpha> m)" "?I' it \<sigma>" "c \<sigma>" 

      from AA(1) AA(3) have "dom (\<alpha> m) - (it - {k}) = insert k (dom (\<alpha> m) - it)" by auto
      moreover
      note A(3) [of \<sigma> k "dom (\<alpha> m) - it" v] AA
      ultimately show "?I' (it - {k}) (f k v \<sigma>)"
        by auto
    qed

    note iteratei_rule_P' [of m ?I' \<sigma>0 c f P] pre1 pre2 A C
    thus "P" by simp
  qed

  lemma iteratei_rule_P:
    "\<lbrakk>
      invar m;
      I (dom (\<alpha> m)) \<sigma>0;
      !!k v it \<sigma>. \<lbrakk> c \<sigma>; k \<in> it; \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
                    \<Longrightarrow> I (it - {k}) (f k v \<sigma>);
      !!\<sigma>. I {} \<sigma> \<Longrightarrow> P \<sigma>;
      !!\<sigma> it. \<lbrakk> it \<subseteq> dom (\<alpha> m); it \<noteq> {}; \<not> c \<sigma>; I it \<sigma> \<rbrakk> \<Longrightarrow> P \<sigma>
    \<rbrakk> \<Longrightarrow> P (iteratei c f m \<sigma>0)"
    by (rule iteratei_rule_P')

  lemma iteratei_rule_insert_P:
    assumes  
      "invar m" 
      "I {} \<sigma>0"
      "!!k v it \<sigma>. \<lbrakk> c \<sigma>; k \<in> (dom (\<alpha> m) - it); \<alpha> m k = Some v; it \<subseteq> dom (\<alpha> m); I it \<sigma> \<rbrakk> 
          \<Longrightarrow> I (insert k it) (f k v \<sigma>)"
      "!!\<sigma>. I (dom (\<alpha> m)) \<sigma> \<Longrightarrow> P \<sigma>"
      "!!\<sigma> it. \<lbrakk> it \<subseteq> dom (\<alpha> m); it \<noteq> dom (\<alpha> m); 
               \<not> (c \<sigma>); 
               I it \<sigma> \<rbrakk> \<Longrightarrow> P \<sigma>"
    shows 
      "P (iteratei c f m \<sigma>0)"
    using assms 
    using iteratei_rule_insert_P' [of m I \<sigma>0 c f "P (iteratei c f m \<sigma>0)"]
    by simp
end


subsubsection "Bounded Quantification"
locale map_ball = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes ball :: "'s \<Rightarrow> ('u \<Rightarrow> 'v \<Rightarrow> bool) \<Rightarrow> bool"
  assumes ball_correct: "invar m \<Longrightarrow> ball m P \<longleftrightarrow> (\<forall>u v. \<alpha> m u = Some v \<longrightarrow> P u v)"

locale map_bexists = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes bexists :: "'s \<Rightarrow> ('u \<Rightarrow> 'v \<Rightarrow> bool) \<Rightarrow> bool"
  assumes bexists_correct: "invar m \<Longrightarrow> bexists m P \<longleftrightarrow> (\<exists>u v. \<alpha> m u = Some v \<and> P u v)"


subsubsection "Selection of Entry"
locale map_sel = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes sel :: "'s \<Rightarrow> ('u \<Rightarrow> 'v \<Rightarrow> 'r option) \<Rightarrow> ('r) option"
  assumes selE: 
  "\<lbrakk> invar m; \<alpha> m u = Some v; f u v = Some r; 
     !!u v r. \<lbrakk> sel m f = Some r; \<alpha> m u = Some v; f u v = Some r \<rbrakk> \<Longrightarrow> Q 
   \<rbrakk> \<Longrightarrow> Q"
  assumes selI: 
    "\<lbrakk> invar m; \<forall>u v. \<alpha> m u = Some v \<longrightarrow> f u v = None \<rbrakk> \<Longrightarrow> sel m f = None"

begin
  lemma sel_someE: 
    "\<lbrakk> invar m; sel m f = Some r; 
       !!u v. \<lbrakk> \<alpha> m u = Some v; f u v = Some r \<rbrakk> \<Longrightarrow> P
     \<rbrakk> \<Longrightarrow> P"
    apply (cases "\<exists>u v r. \<alpha> m u = Some v \<and> f u v = Some r")
    apply safe
    apply (erule_tac u=u and v=v and r=ra in selE)
    apply assumption
    apply assumption
    apply simp
    apply (auto)
    apply (drule (1) selI)
    apply simp
    done

  lemma sel_noneD: "\<lbrakk>invar m; sel m f = None; \<alpha> m u = Some v\<rbrakk> \<Longrightarrow> f u v = None"
    apply (rule ccontr)
    apply simp
    apply (erule exE)
    apply (erule_tac f=f and u=u and v=v and r=y in selE)
    apply auto
    done

end

 
lemma map_sel_altI:
  assumes S1: 
    "!!s f r P. \<lbrakk> invar s; sel s f = Some r; 
                  !!u v. \<lbrakk>\<alpha> s u = Some v; f u v = Some r\<rbrakk> \<Longrightarrow> P
                \<rbrakk> \<Longrightarrow> P"
  assumes S2: 
    "!!s f u v. \<lbrakk>invar s; sel s f = None; \<alpha> s u = Some v\<rbrakk> \<Longrightarrow> f u v = None"
  shows "map_sel \<alpha> invar sel"
proof -
  show ?thesis
    apply (unfold_locales)
    apply (case_tac "sel m f")
    apply (force dest: S2)
    apply (force elim: S1)
    apply (case_tac "sel m f")
    apply assumption
    apply (force elim: S1)
    done
qed


subsubsection "Selection of Entry (without mapping)"
locale map_sel' = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes sel' :: "'s \<Rightarrow> ('u \<Rightarrow> 'v \<Rightarrow> bool) \<Rightarrow> ('u\<times>'v) option"
  assumes sel'E: 
  "\<lbrakk> invar m; \<alpha> m u = Some v; P u v; 
     !!u v. \<lbrakk> sel' m P = Some (u,v); \<alpha> m u = Some v; P u v\<rbrakk> \<Longrightarrow> Q 
   \<rbrakk> \<Longrightarrow> Q"
  assumes sel'I: 
    "\<lbrakk> invar m; \<forall>u v. \<alpha> m u = Some v \<longrightarrow> \<not> P u v \<rbrakk> \<Longrightarrow> sel' m P = None"

begin
  lemma sel'_someE: 
    "\<lbrakk> invar m; sel' m P = Some (u,v); 
       !!u v. \<lbrakk> \<alpha> m u = Some v; P u v \<rbrakk> \<Longrightarrow> thesis
     \<rbrakk> \<Longrightarrow> thesis"
    apply (cases "\<exists>u v. \<alpha> m u = Some v \<and> P u v")
    apply safe
    apply (erule_tac u=ua and v=va in sel'E)
    apply assumption
    apply assumption
    apply simp
    apply (auto)
    apply (drule (1) sel'I)
    apply simp
    done

  lemma sel'_noneD: "\<lbrakk>invar m; sel' m P = None; \<alpha> m u = Some v\<rbrakk> \<Longrightarrow> \<not> P u v"
    apply (rule ccontr)
    apply simp
    apply (erule (2) sel'E[where P=P])
    apply auto
    done

  lemma sel'_SomeD:
    "\<lbrakk> sel' m P = Some (u, v); invar m \<rbrakk> \<Longrightarrow> \<alpha> m u = Some v \<and> P u v"
    apply(cases "\<exists>u' v'. \<alpha> m u' = Some v' \<and> P u' v'")
     apply clarsimp
     apply(erule (2) sel'E[where P=P])
     apply simp
    apply(clarsimp)
    apply(drule (1) sel'I)
    apply simp
    done
end

subsubsection "Map to List Conversion"
locale map_to_list = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes to_list :: "'s \<Rightarrow> ('u\<times>'v) list"
  assumes to_list_correct: 
    "invar m \<Longrightarrow> map_of (to_list m) = \<alpha> m"
    "invar m \<Longrightarrow> distinct (map fst (to_list m))"


subsubsection "List to Map Conversion"
locale list_to_map = map +
  constrains \<alpha> :: "'s \<Rightarrow> 'u \<rightharpoonup> 'v"
  fixes to_map :: "('u\<times>'v) list \<Rightarrow> 's"
  assumes to_map_correct:
    "\<alpha> (to_map l) = map_of l"
    "invar (to_map l)"

subsubsection "Image of a Map"

text {* This locale allows to apply a function to both the keys and
 the values of a map while at the same time filtering entries. *}

definition transforms_to_unique_keys ::
  "('u1 \<rightharpoonup> 'v1) \<Rightarrow> ('u1 \<Rightarrow> 'v1 \<rightharpoonup> ('u2 \<times> 'v2)) \<Rightarrow> bool"
  where
  "transforms_to_unique_keys m f \<equiv> (\<forall>k1 k2 v1 v2 k' v1' v2'. ( 
         m k1 = Some v1 \<and>
         m k2 = Some v2 \<and>
         f k1 v1 = Some (k', v1') \<and>
         f k2 v2 = Some (k', v2')) -->
       (k1 = k2))"

locale map_image_filter = map \<alpha>1 invar1 + map \<alpha>2 invar2
  for \<alpha>1 :: "'m1 \<Rightarrow> 'u1 \<rightharpoonup> 'v1" and invar1
  and \<alpha>2 :: "'m2 \<Rightarrow> 'u2 \<rightharpoonup> 'v2" and invar2
  +
  fixes map_image_filter :: "('u1 \<Rightarrow> 'v1 \<Rightarrow> ('u2 \<times> 'v2) option) \<Rightarrow> 'm1 \<Rightarrow> 'm2"
  assumes map_image_filter_correct_aux1:
    "\<And>k' v'. 
     \<lbrakk>invar1 m; transforms_to_unique_keys (\<alpha>1 m) f\<rbrakk> \<Longrightarrow> 
     (invar2 (map_image_filter f m) \<and>
      ((\<alpha>2 (map_image_filter f m) k' = Some v') \<longleftrightarrow>
       (\<exists>k v. (\<alpha>1 m k = Some v) \<and> f k v = Some (k', v'))))"
begin

  (*Let's use a definition for the precondition *)

  lemma map_image_filter_correct_aux2 :
    assumes "invar1 m" 
      and "transforms_to_unique_keys (\<alpha>1 m) f"
    shows "(\<alpha>2 (map_image_filter f m) k' = None) \<longleftrightarrow>
      (\<forall>k v v'. \<alpha>1 m k = Some v \<longrightarrow> f k v \<noteq> Some (k', v'))"
  proof -
    note map_image_filter_correct_aux1 [OF assms]
    have Some_eq: "\<And>v'. (\<alpha>2 (map_image_filter f m) k' = Some v') =
          (\<exists>k v. \<alpha>1 m k = Some v \<and> f k v = Some (k', v'))"
      by (simp add: map_image_filter_correct_aux1 [OF assms])
    
    have intro_some: "(\<alpha>2 (map_image_filter f m) k' = None) \<longleftrightarrow>
                      (\<forall>v'. \<alpha>2 (map_image_filter f m) k' \<noteq> Some v')" by auto
    
    from intro_some Some_eq show ?thesis by auto
  qed

  lemmas map_image_filter_correct = 
     conjunct1 [OF map_image_filter_correct_aux1] 
     conjunct2 [OF map_image_filter_correct_aux1] 
     map_image_filter_correct_aux2
end
    

text {* Most of the time the mapping function is only applied to values. Then,
  the precondition disapears.*}

locale map_value_image_filter = map \<alpha>1 invar1 + map \<alpha>2 invar2
  for \<alpha>1 :: "'m1 \<Rightarrow> 'u \<rightharpoonup> 'v1" and invar1
  and \<alpha>2 :: "'m2 \<Rightarrow> 'u \<rightharpoonup> 'v2" and invar2
  +
  fixes map_value_image_filter :: "('u \<Rightarrow> 'v1 \<Rightarrow> 'v2 option) \<Rightarrow> 'm1 \<Rightarrow> 'm2"
  assumes map_value_image_filter_correct :
    "invar1 m \<Longrightarrow> 
     invar2 (map_value_image_filter f m) \<and>
     (\<alpha>2 (map_value_image_filter f m) = 
      (\<lambda>k. Option.bind (\<alpha>1 m k) (f k)))"
begin

  lemma map_value_image_filter_correct_alt :
    "invar1 m \<Longrightarrow> 
     invar2 (map_value_image_filter f m)"
    "invar1 m \<Longrightarrow>
     (\<alpha>2 (map_value_image_filter f m) k = Some v') \<longleftrightarrow>
     (\<exists>v. (\<alpha>1 m k = Some v) \<and> f k v = Some v')"
    "invar1 m \<Longrightarrow>
     (\<alpha>2 (map_value_image_filter f m) k = None) \<longleftrightarrow>
     (\<forall>v. (\<alpha>1 m k = Some v) --> f k v = None)"
  proof -
    assume invar_m : "invar1 m"
    note aux = map_value_image_filter_correct [OF invar_m]

    from aux show "invar2 (map_value_image_filter f m)" by simp
    from aux show "(\<alpha>2 (map_value_image_filter f m) k = Some v') \<longleftrightarrow>
     (\<exists>v. (\<alpha>1 m k = Some v) \<and> f k v = Some v')" 
      by (cases "\<alpha>1 m k", simp_all)
    from aux show "(\<alpha>2 (map_value_image_filter f m) k = None) \<longleftrightarrow>
     (\<forall>v. (\<alpha>1 m k = Some v) --> f k v = None)" 
      by (cases "\<alpha>1 m k", simp_all)
  qed
end


locale map_restrict = map \<alpha>1 invar1 + map \<alpha>2 invar2 
  for \<alpha>1 :: "'m1 \<Rightarrow> 'u \<rightharpoonup> 'v" and invar1
  and \<alpha>2 :: "'m2 \<Rightarrow> 'u \<rightharpoonup> 'v" and invar2
  +
  fixes restrict :: "('u \<Rightarrow> 'v \<Rightarrow> bool) \<Rightarrow> 'm1 \<Rightarrow> 'm2"
  assumes restrict_correct_aux1 :
    "invar1 m \<Longrightarrow> \<alpha>2 (restrict P m) = \<alpha>1 m |` {k. \<exists>v. \<alpha>1 m k = Some v \<and> P k v}"
    "invar1 m \<Longrightarrow> invar2 (restrict P m)"
begin
  lemma restrict_correct_aux2 :
    "invar1 m \<Longrightarrow> \<alpha>2 (restrict (\<lambda>k v. P k) m) = \<alpha>1 m |` {k. P k}"
  proof -
    assume invar_m : "invar1 m"
    have "\<alpha>1 m |` {k. (\<exists>v. \<alpha>1 m k = Some v) \<and> P k} = \<alpha>1 m |` {k. P k}"
      (is "\<alpha>1 m |` ?A1 = \<alpha>1 m |` ?A2")
    proof
      fix k
      show "(\<alpha>1 m |` ?A1) k = (\<alpha>1 m |` ?A2) k"
      proof (cases "k \<in> ?A2")
        case False thus ?thesis by simp
      next
        case True
        hence P_k : "P k" by simp

        show ?thesis
          by (cases "\<alpha>1 m k", simp_all add: P_k)
      qed
    qed
    with invar_m show "\<alpha>2 (restrict (\<lambda>k v. P k) m) = \<alpha>1 m |` {k. P k}"
      by (simp add: restrict_correct_aux1)
  qed

  lemmas restrict_correct = 
     restrict_correct_aux1
     restrict_correct_aux2
end


subsection "Record Based Interface"

  record ('k,'v,'s) map_ops =
    map_op_\<alpha> :: "'s \<Rightarrow> 'k \<rightharpoonup> 'v"
    map_op_invar :: "'s \<Rightarrow> bool"
    map_op_empty :: "'s"
    map_op_sng :: "'k \<Rightarrow> 'v \<Rightarrow> 's"
    map_op_lookup :: "'k \<Rightarrow> 's \<Rightarrow> 'v option"
    map_op_update :: "'k \<Rightarrow> 'v \<Rightarrow> 's \<Rightarrow> 's"
    map_op_update_dj :: "'k \<Rightarrow> 'v \<Rightarrow> 's \<Rightarrow> 's"
    map_op_delete :: "'k \<Rightarrow> 's \<Rightarrow> 's"
    map_op_restrict :: "('k \<Rightarrow> 'v \<Rightarrow> bool) \<Rightarrow> 's \<Rightarrow> 's"
    map_op_add :: "'s \<Rightarrow> 's \<Rightarrow> 's"
    map_op_add_dj :: "'s \<Rightarrow> 's \<Rightarrow> 's"
    map_op_isEmpty :: "'s \<Rightarrow> bool"
    map_op_isSng :: "'s \<Rightarrow> bool"
    map_op_ball :: "'s \<Rightarrow> ('k \<Rightarrow> 'v \<Rightarrow> bool) \<Rightarrow> bool"
    map_op_bexists :: "'s \<Rightarrow> ('k \<Rightarrow> 'v \<Rightarrow> bool) \<Rightarrow> bool"
    map_op_size :: "'s \<Rightarrow> nat"
    map_op_size_abort :: "nat \<Rightarrow> 's \<Rightarrow> nat"
    map_op_sel :: "'s \<Rightarrow> ('k \<Rightarrow> 'v \<Rightarrow> bool) \<Rightarrow> ('k\<times>'v) option" 
    map_op_to_list :: "'s \<Rightarrow> ('k\<times>'v) list"
    map_op_to_map :: "('k\<times>'v) list \<Rightarrow> 's"

  locale StdMapDefs =
    fixes ops :: "('k,'v,'s,'more) map_ops_scheme"
  begin
    abbreviation \<alpha> where "\<alpha> == map_op_\<alpha> ops" 
    abbreviation invar where "invar == map_op_invar ops" 
    abbreviation empty where "empty == map_op_empty ops" 
    abbreviation sng where "sng == map_op_sng ops" 
    abbreviation lookup where "lookup == map_op_lookup ops" 
    abbreviation update where "update == map_op_update ops" 
    abbreviation update_dj where "update_dj == map_op_update_dj ops" 
    abbreviation delete where "delete == map_op_delete ops" 
    abbreviation restrict where "restrict == map_op_restrict ops" 
    abbreviation add where "add == map_op_add ops" 
    abbreviation add_dj where "add_dj == map_op_add_dj ops" 
    abbreviation isEmpty where "isEmpty == map_op_isEmpty ops" 
    abbreviation isSng where "isSng == map_op_isSng ops" 
    abbreviation ball where "ball == map_op_ball ops" 
    abbreviation bexists where "bexists == map_op_bexists ops" 
    abbreviation size where "size == map_op_size ops" 
    abbreviation size_abort where "size_abort == map_op_size_abort ops" 
    abbreviation sel where "sel == map_op_sel ops" 
    abbreviation to_list where "to_list == map_op_to_list ops" 
    abbreviation to_map where "to_map == map_op_to_map ops"
  end


  locale StdMap = StdMapDefs ops +
    map \<alpha> invar +
    map_empty \<alpha> invar empty  +
    map_sng \<alpha> invar sng  +
    map_lookup \<alpha> invar lookup  +
    map_update \<alpha> invar update  +
    map_update_dj \<alpha> invar update_dj  +
    map_delete \<alpha> invar delete  +
    map_restrict \<alpha> invar \<alpha> invar restrict +
    map_add \<alpha> invar add  +
    map_add_dj \<alpha> invar add_dj  +
    map_isEmpty \<alpha> invar isEmpty  +
    map_isSng \<alpha> invar isSng  +
    map_ball \<alpha> invar ball  +
    map_bexists \<alpha> invar bexists  +
    map_size \<alpha> invar size +
    map_size_abort \<alpha> invar size_abort +
    map_sel' \<alpha> invar sel  +
    map_to_list \<alpha> invar to_list  +
    list_to_map \<alpha> invar to_map 
    for ops
  begin
    lemmas correct =
      empty_correct
      sng_correct
      lookup_correct
      update_correct
      update_dj_correct
      delete_correct
      restrict_correct
      add_correct
      add_dj_correct
      isEmpty_correct
      isSng_correct
      ball_correct
      bexists_correct
      size_correct
      size_abort_correct
      to_list_correct
      to_map_correct

  end


end
