(*  
    Authors:     Shuanglong Kan <shuanglong@uni-kl.de>
                 Thomas Tuerk <tuerk@in.tum.de>             
*)

theory Accessible
imports Main "Workset"
begin


subsection \<open> accessible \<close>

text \<open> Let's define the set of value that are accessible/reachable from
 a given value using a binary relation. \<close>

definition accessible where
  "accessible R ws \<equiv> R\<^sup>* `` ws"

lemma accessible_empty [simp] :
  "accessible R {} = {}" by (simp add: accessible_def)

lemma accessible_union :
  "accessible R (ws \<union> ws') = 
   accessible R ws \<union> accessible R ws'" 
unfolding accessible_def by (rule Image_Un)

lemma accessible_Union :
  "accessible R (\<Union> wss) = \<Union> (accessible R ` wss)" 
by (auto simp add: accessible_def)

lemma accessible_insert :
  "accessible R (insert x ws) = 
   {y. (x, y) \<in> R\<^sup>*} \<union> accessible R ws" 
by (auto simp add: accessible_def)

lemma accessible_eq_empty [simp] :
   "(accessible R ws = {}) \<longleftrightarrow> (ws = {})"
unfolding accessible_def by auto

lemma accessible_mono :
  "ws \<subseteq> ws' \<Longrightarrow> (accessible R ws \<subseteq> accessible R ws')"
unfolding accessible_def by auto

lemma accessible_subset_ws :
  "ws \<subseteq> accessible R ws"
by (auto simp add: subset_iff accessible_def)

lemma accessible_insert2 :
  "accessible R (insert x ws) = 
   insert x (accessible R (ws \<union> {y. (x, y) \<in> R}))"
apply (auto simp add: accessible_def Image_iff Bex_def)
  apply (metis converse_rtranclE)
apply (metis converse_rtrancl_into_rtrancl)
done

lemma accessible_subset_R_ws_gen : 
assumes ws_S: "ws \<subseteq> S"
    and R_S: "\<And>x y. x \<in> S \<and> (x, y) \<in> R \<Longrightarrow> y \<in> S"
shows "accessible R ws \<subseteq> S"
proof -
  have "\<And>x y. \<lbrakk>(x, y) \<in> R\<^sup>*; x \<in> S\<rbrakk> \<Longrightarrow> y \<in> S"
  proof -
    fix x y
    show "\<lbrakk>(x, y) \<in> R\<^sup>*; x \<in> S\<rbrakk> \<Longrightarrow> y \<in> S"
      apply (induct rule: converse_rtrancl_induct)
      apply simp
      apply (metis R_S)
    done
  qed
  thus ?thesis
    unfolding accessible_def
    using ws_S
    by auto
qed

lemma accessible_subset_R_ws: "accessible R ws \<subseteq> snd ` R \<union> ws"
unfolding accessible_def
by (auto simp add: image_iff Bex_def, metis rtranclE)

lemma accessible_finite___args_finite :
assumes fin_R: "finite R"
    and fin_ws: "finite ws"
shows "finite (accessible R ws)"
proof -
  have acc_subset: "accessible R ws \<subseteq> snd ` R \<union> ws" 
    by (simp add: accessible_subset_R_ws)
  
  have "finite (snd ` R \<union> ws)" 
    by (simp add: fin_ws fin_R)
  with acc_subset show ?thesis by (metis finite_subset) 
qed

lemma accessible_accessible_idempot :
   "(accessible R (accessible R ws)) = accessible R ws"
by (auto simp add: accessible_def Image_iff Bex_def,
    metis rtrancl_trans)

lemma accessible_subset_accessible :
   "accessible R ws1 \<subseteq> accessible R ws2 \<longleftrightarrow>
    ws1 \<subseteq> accessible R ws2"
unfolding accessible_def
by (auto simp add: accessible_def Image_iff Bex_def subset_iff,
    metis rtrancl_trans)

definition accessible_restrict where
  "accessible_restrict R rs ws \<equiv> 
   rs \<union> accessible (R - (rs \<times> UNIV)) ws"

lemma accessible_restrict_empty :
  "accessible_restrict R {} ws = accessible R ws"
  by (simp add: accessible_restrict_def)

lemma accessible_restrict_final [simp] :
  "accessible_restrict R rs {} = rs"
  by (simp add: accessible_restrict_def)

lemma accessible_restrict_insert_in :
  "x \<in> rs \<Longrightarrow> 
   accessible_restrict R rs (insert x ws) = 
   accessible_restrict R rs ws"
unfolding accessible_restrict_def
by (auto simp add: accessible_insert2)

lemma accessible_restrict_diff_rs :
  "accessible_restrict R rs ws = 
   accessible_restrict R rs (ws - rs)"
proof -
  { fix x y 
    have "\<lbrakk>(x, y) \<in> (R - rs \<times> UNIV)\<^sup>*;y \<notin> rs\<rbrakk> \<Longrightarrow> x \<notin> rs" 
    by (erule converse_rtranclE, simp_all)
  }
  thus ?thesis
    unfolding accessible_def accessible_restrict_def Image_def Bex_def
    by auto 
qed

lemma accessible_restrict_insert_nin :
  "x \<notin> rs \<Longrightarrow> 
   accessible_restrict R rs (insert x ws) = 
   accessible_restrict R (insert x rs) (ws \<union> {y. (x, y) \<in> R})"
proof -
  assume x_nin_rs: "x \<notin> rs" 
  obtain R_res where R_res_def: "R_res = (\<lambda>rs. (R - (rs \<times> UNIV)))" 
    by blast
   
  have "accessible (R_res (insert x rs)) (ws \<union> {y. (x, y) \<in> R}) =
        accessible (R_res rs) (ws \<union> {y. (x, y) \<in> R})"
        (is "?acc1 = ?acc2")
  proof (intro set_eqI iffI)
    fix e
    assume e_in_acc1: "e \<in> ?acc1"

    have "R_res (insert x rs) \<subseteq> R_res rs" unfolding R_res_def by force
    from rtrancl_mono[OF this] e_in_acc1 
      show "e \<in> ?acc2"
      unfolding accessible_def
      by auto
  next 
    fix e
    let ?ws' = "ws \<union> {y. (x, y) \<in> R}"

    have ind_part: "\<And>y. \<lbrakk>(y, e) \<in> (R_res rs)\<^sup>*; y \<in> ?ws'\<rbrakk> \<Longrightarrow>
                         \<exists>y'. y' \<in> ?ws' \<and> (y', e) \<in> (R_res (insert x rs))\<^sup>*"
    proof -
      fix y
      show "\<lbrakk>(y, e) \<in> (R_res rs)\<^sup>*; y \<in> ?ws'\<rbrakk> \<Longrightarrow>
             \<exists>y'. y' \<in> ?ws' \<and> (y', e) \<in> (R_res (insert x rs))\<^sup>*"
      proof (induct rule: rtrancl_induct)
        case base thus ?case by auto
      next
        case (step y2 z)
        note y2_z_in_R_res = step(2)
        note ind_hyp = step(3)[OF step(4)]

        show "\<exists>y'. y' \<in> ?ws' \<and> (y', z) \<in> (R_res (insert x rs))\<^sup>*"
        proof (cases "(y2, z) \<in> (R_res (insert x rs))")
          case True with ind_hyp show ?thesis by auto
        next
          case False
          hence "(x, z) \<in> R" using y2_z_in_R_res unfolding R_res_def
            by simp
          hence "z \<in> ?ws'" by simp
          thus ?thesis by auto
        qed
      qed
    qed

    assume e_in_acc2: "e \<in> ?acc2"
    with ind_part show "e \<in> ?acc1"
      by (auto simp add: accessible_def)
  qed

  with x_nin_rs show 
   "accessible_restrict R rs (insert x ws) = 
    accessible_restrict R (insert x rs) (ws \<union> {y. (x, y) \<in> R})"
    unfolding accessible_restrict_def R_res_def
    by (simp add: accessible_insert2)
qed


lemmas accessible_restrict_insert =
       accessible_restrict_insert_nin accessible_restrict_insert_in

lemma accessible_restrict_union :
  "accessible_restrict R rs (ws \<union> ws') = 
   (accessible_restrict R rs ws) \<union> (accessible_restrict R rs ws')" 
  unfolding accessible_restrict_def
  by (auto simp add: accessible_union)

lemma accessible_restrict_Union :
  "wss \<noteq> {} \<Longrightarrow>
   accessible_restrict R rs (\<Union> wss) = (\<Union>ws \<in> wss. (accessible_restrict R rs ws))" 
  unfolding accessible_restrict_def
  by (simp add: accessible_Union)

lemma accessible_restrict_subset_ws :
  "ws \<subseteq> accessible_restrict R rs ws"
unfolding accessible_restrict_def
using accessible_subset_ws [of ws]
by fast

subsection \<open> Define a new order \<close>

definition bounded_superset_rel where
  "bounded_superset_rel S \<equiv>
   {(x, y). (y \<subset> x \<and> x \<subseteq> S)}"

lemma wf_bounded_superset_rel [simp] :
fixes S :: "'a set"
assumes fin_S: "finite S"
shows "wf (bounded_superset_rel S)"
proof -
  have "bounded_superset_rel S \<subseteq> measure (\<lambda>s. card (S - s))"
  proof 
    fix xy :: "'a set \<times> 'a set"
    obtain x y where xy_eq: "xy = (x, y)" by (cases xy, blast)

    assume "xy \<in> bounded_superset_rel S"
    hence "y \<subset> x \<and> x \<subseteq> S" unfolding bounded_superset_rel_def xy_eq
      by simp
    hence "S - x \<subset> S - y" by auto

    hence "card (S - x) < card (S - y)"
      using psubset_card_mono finite_Diff fin_S
      by metis
    thus "xy \<in> measure (\<lambda>s. card (S - s))"
      using xy_eq
      by simp
  qed
  thus ?thesis
    using wf_measure wf_subset
    by metis
qed



subsection \<open> Implementation of Accessible \<close>

text \<open> Now let's implement the algorithm using lists \<close>

definition accessible_worklist_invar where
"accessible_worklist_invar exit R rs S \<equiv> (\<lambda>s. 
(rs \<subseteq> snd (fst s)) \<and>
(fst (fst s) = (\<exists>e \<in> (snd (fst s) - rs). exit e)) \<and>
(S = accessible_restrict R (snd (fst s)) (set (snd s))))"


definition accessible_worklist where
  "accessible_worklist exit R rs wl =
   WORKLISTIT (accessible_worklist_invar exit R rs (accessible_restrict R rs (set wl))) 
    (\<lambda>s. \<not> (fst s))
    (\<lambda>s e. 
       if (e \<in> snd s) then
         (RETURN (s, []))
       else                    
         do {
           N \<leftarrow> SPEC (\<lambda>wl. set wl = {y. (e,y) \<in> R});
           RETURN ((exit e, insert e (snd s)), N)
         }
     ) ((False, rs), wl)"

lemma accessible_worklist_thm :
fixes R :: "('e \<times> 'e) set" and rs wl
defines "S \<equiv> (accessible_restrict R rs (set wl))"
assumes fin_S: "finite S"
shows "accessible_worklist exit R rs wl \<le>
       SPEC (\<lambda>((ex, rs'), wl'). 
            (accessible_restrict R rs' (set wl') = S) \<and>
            (ex \<longleftrightarrow> (\<exists>e \<in> rs'-rs. exit e)) \<and> (\<not>ex \<longrightarrow> wl' = []))"
unfolding accessible_worklist_def S_def[symmetric]
proof (rule WORKLISTIT_rule [where R = "inv_image (bounded_superset_rel S) snd"])
  show "accessible_worklist_invar exit R rs S ((False, rs), wl)"
    unfolding accessible_worklist_invar_def S_def
    by simp
next
  show "wf (inv_image (bounded_superset_rel S) snd)"
    using fin_S wf_bounded_superset_rel by simp
next
  fix s
  assume invar: "accessible_worklist_invar exit R rs S (s, [])"
  obtain ex rs' where s_eq[simp]: "s = (ex, rs')" by (rule prod.exhaust)

  from invar
  show "(\<lambda>((ex, rs'), wl').
            accessible_restrict R rs' (set wl') = S \<and>
            ex = (\<exists>e\<in>rs' - rs. exit e) \<and> (\<not> ex \<longrightarrow> wl' = []))
         (s, [])"
    unfolding accessible_worklist_invar_def
    by simp
next
  fix s wl
  assume invar: "accessible_worklist_invar exit R rs S (s, wl)"
  assume "\<not> (\<not> fst s)"
  obtain ex rs' where s_eq[simp]: "s = (ex, rs')" by (rule prod.exhaust)

  from `\<not>(\<not> fst s)` have "ex = True" by simp

  with invar show "(\<lambda>((ex, rs'), wl').
           accessible_restrict R rs' (set wl') = S \<and>
           ex = (\<exists>e\<in>rs' - rs. exit e) \<and> (\<not> ex \<longrightarrow> wl' = []))
        (s, wl)" 
    unfolding accessible_worklist_invar_def
    by simp
next
  fix s wl e
  assume invar: "accessible_worklist_invar exit R rs S (s, e # wl)"
  assume "(\<not> fst s)"
  obtain ex rs' where s_eq[simp]: "s = (ex, rs')" by (rule prod.exhaust)

  from `\<not>(fst s)` have not_ex: "ex = False" by simp

  show "(if e \<in> snd s then RETURN (s, [])
        else SPEC (\<lambda>wl. set wl = {y. (e, y) \<in> R}) \<bind>
             (\<lambda>N. RETURN ((exit e, insert e (snd s)), N))) \<le> SPEC
          (\<lambda>s'N.
              accessible_worklist_invar exit R rs S
               (fst s'N, snd s'N @ wl) \<and>
              ((fst s'N, s) \<in> inv_image (bounded_superset_rel S) snd \<or>
               s'N = (s, [])))"
  proof (cases "e \<in> rs'")
    case True note e_in_rs' = this
    with invar have
      "accessible_worklist_invar exit R rs S ((ex, rs'), wl)" 
      unfolding accessible_worklist_invar_def workbag_update_def
      by (simp add: accessible_restrict_insert_in)
    with e_in_rs' show ?thesis by simp
  next
    case False note e_nin_rs' = this

    have "S = accessible_restrict R rs' (set (e # wl))" using invar
      unfolding accessible_worklist_invar_def by simp
    moreover
    have "rs' \<subset> insert e rs'" using e_nin_rs' by auto
    moreover
    have "rs' \<subseteq> accessible_restrict R rs' (set (e # wl))" by (simp add: accessible_restrict_def)
    moreover
    have "e \<in> accessible_restrict R rs' (set (e # wl))"
      using accessible_restrict_subset_ws [of "set (e # wl)" R rs'] 
      by (simp add: subset_iff)
    ultimately have in_R: "(insert e rs', rs') \<in> bounded_superset_rel S"
      unfolding bounded_superset_rel_def
      by simp

    { fix N
      assume N_eq: "set N = {y. (e, y) \<in> R}"

      with invar
      have "accessible_worklist_invar exit R rs S
            ((exit e, insert e rs'), N @ wl)" 
        unfolding accessible_worklist_invar_def workbag_update_def
        apply (simp add: accessible_restrict_insert_nin e_nin_rs' Bex_def not_ex subset_iff)
        apply (metis e_nin_rs' Un_commute)
      done
    } note invar' = this

    from e_nin_rs' in_R invar'
    show ?thesis 
      by (simp add: subset_iff image_iff pw_le_iff refine_pw_simps)
  qed
qed

end
