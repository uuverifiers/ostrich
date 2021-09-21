(*  
    Authors:     Shuanglong Kan <shuanglong@uni-kl.de>
                 Thomas Tuerk <tuerk@in.tum.de>             
*)

(* Labeled transition systems *)

theory LTS_set
imports Main "HOL.Option"
begin

text \<open>This theory defines labeled transition systems (LTS)\<close> 

subsection \<open> Auxiliary Definitions \<close>
lemma lists_product : 
  "w \<in> lists (\<Sigma>1 \<times> \<Sigma>2) \<longleftrightarrow> (map fst w) \<in> lists \<Sigma>1 \<and>  (map snd w) \<in> lists \<Sigma>2"
by (induct w, auto)

lemma lists_inter : "w \<in> lists (\<Sigma>1 \<inter> \<Sigma>2) = (w \<in> lists \<Sigma>1 \<and> w \<in> lists \<Sigma>2)"
  by (simp add: lists_eq_set)

lemma lists_rev [simp] :
  "(rev w) \<in> lists \<Sigma> \<longleftrightarrow> w \<in> lists \<Sigma>"
by auto

lemma rev_image_lists [simp] :
  "rev ` (lists A) = lists A"
proof (rule set_eqI)
  fix xs
  have "xs \<in> rev ` (lists A) \<longleftrightarrow> rev xs \<in> lists A"
    apply (simp add: image_iff Bex_def)
    apply (metis rev_swap lists_rev)
  done
  thus "xs \<in> rev ` lists A \<longleftrightarrow> xs \<in> lists A"
    by simp
qed


subsection  \<open>Basic Definitions\<close>
subsubsection \<open>Transition Relations \<close>

text \<open> Given a set of states $\mathcal{Q}$ and an alphabet $\Sigma$,
a labeled transition system is a subset of $\mathcal{Q} \times \Sigma
\times \mathcal{Q}$.  Given such a relation $\Delta \subseteq
\mathcal{Q} \times \Sigma \times \mathcal{Q}$, a triple $(q, \sigma,
q')$ is an element of $\Delta$ iff starting in state $q$ the state
$q'$ can be reached reading the label $\sigma$. \<close>


type_synonym ('q,'a) LTS = "('q * 'a set * 'q) set"

subsubsection \<open> Paths \<close>

text  \<open> Given a word $w = w_1\ldots w_n$ over $\Sigma$ then a word $p
= p_0\ldots p_n$ over $\mathcal{Q}$ is called \emph{a path of $w$
through $\Delta$}, iff $(p_i, w_{i+1}, p_{i+1}) \in \Delta$ holds for
all $0 \leq i < n$.  This definition of paths requires however to
always keep track of the lengths of $p$ and $r$. This leads to
complicated simplication rules.  Therefore, the following definition
uses $p_0$ and the combined word $(w_1,r_1)\ldots(w_n,r_n)$ over
$\Sigma \times \mathcal{Q}$ for the definition of paths.  \<close>

fun LTS_is_path :: "('q,'a) LTS \<Rightarrow> 'q \<Rightarrow> ('a set * 'q) list \<Rightarrow> bool" where
  "LTS_is_path \<Delta> q [] = True"
| "LTS_is_path \<Delta> q (\<sigma>q' # xs) = 
      ((q, fst \<sigma>q', snd \<sigma>q') \<in> \<Delta> \<and> LTS_is_path \<Delta> (snd \<sigma>q') xs)"

text \<open> Using this definition, it is easy to prove some properties
  of paths. For example lemmata about concatenating paths are easy to proof. \<close>

lemma LTS_is_path_concat :
  "\<pi> \<noteq> [] \<Longrightarrow>
   (LTS_is_path \<Delta> q (\<pi> @ \<pi>') = (LTS_is_path \<Delta> q \<pi> \<and> LTS_is_path \<Delta> (snd (last \<pi>)) \<pi>'))"
by (induct \<pi> arbitrary: q rule: list_nonempty_induct, simp_all)


subsubsection  \<open>Reachability\<close>

text \<open>Often it is enough to consider just the first and last state of
a path. This leads to the following definition of reachability. Notice, 
that @{term "LTS_is_reachable \<Delta>"} is the reflexive, transitive closure of @{term \<Delta>}.\<close>

fun LTS_is_reachable :: "('q, 'a) LTS \<Rightarrow> 'q \<Rightarrow> 'a list \<Rightarrow> 'q \<Rightarrow> bool" where
   "LTS_is_reachable \<Delta> q [] q' = (q = q')"
 | "LTS_is_reachable \<Delta> q (a # w) q' = 
      (\<exists>q'' \<sigma>. a \<in> \<sigma> \<and> (q, \<sigma>, q'') \<in> \<Delta> \<and> LTS_is_reachable \<Delta> q'' w q')"   

text  \<open> Now let's show the connection with @{term LTS_is_path}. In order
 to establish the connection, a few auxiliary definitions are
 introduced first. \<close>

definition LTS_path :: "('a  * 'q) list \<Rightarrow> 'q list" where
  "LTS_path \<pi> \<equiv> map snd \<pi>"

definition LTS_path_last_S :: "'q \<Rightarrow> ('a  * 'q) list \<Rightarrow> 'q" where
  "LTS_path_last_S q \<pi> \<equiv> last (q # (LTS_path \<pi>))"

definition LTS_path_L :: "('a  * 'q) list \<Rightarrow> 'a list" where
  "LTS_path_L \<pi> \<equiv> map fst \<pi>"

fun inPath :: "'a list \<Rightarrow> 'a set list \<Rightarrow> bool" where 
    "inPath [] [] = True"
  | "inPath (a # rpath) (s # rspath) = ((a \<in> s) \<and> (inPath rpath rspath))"
  | "inPath _ _ = False"

lemma [simp] : "LTS_path [] = []" by (simp add: LTS_path_def)
lemma [simp] : "LTS_path_L [] = []" by (simp add: LTS_path_L_def)
lemma [simp] : "LTS_path (\<sigma>q # \<pi>) = (snd \<sigma>q # LTS_path \<pi>)" by (simp add: LTS_path_def)
lemma [simp] : "LTS_path_L (\<sigma>q # \<pi>) = (fst \<sigma>q # LTS_path_L \<pi>)" by (simp add: LTS_path_L_def)
lemma [simp] : "LTS_path \<pi> = [] \<longleftrightarrow> \<pi> = []" by (simp add: LTS_path_def)
lemma [simp] : "LTS_path_L \<pi> = [] \<longleftrightarrow> \<pi> = []" by (simp add: LTS_path_L_def)
lemma [simp] : "LTS_path_last_S q [] = q" by (simp add: LTS_path_last_S_def LTS_path_def)
lemma [simp] : "LTS_path_last_S q (x # xs) = LTS_path_last_S (snd x) xs" 
   by (simp add: LTS_path_last_S_def LTS_path_def)

lemma LTS_path_divide: 
  "LTS_path \<pi> = l1 @ l2  
        \<Longrightarrow> (\<exists> \<pi>1 \<pi>2. \<pi> = \<pi>1 @ \<pi>2 \<and> LTS_path \<pi>1 = l1 \<and> LTS_path \<pi>2 = l2)"
  apply (induction \<pi> arbitrary: l1)
  apply simp
proof -
  fix a \<pi> l1
  assume p1: "(\<And>l1. LTS_path \<pi> = l1 @ l2 \<Longrightarrow> 
                \<exists>\<pi>1 \<pi>2. \<pi> = \<pi>1 @ \<pi>2 \<and> LTS_path \<pi>1 = l1 \<and> LTS_path \<pi>2 = l2)"
    and  p2: "LTS_path (a # \<pi>) = l1 @ l2"
  show "\<exists>\<pi>1 \<pi>2. a # \<pi> = \<pi>1 @ \<pi>2 \<and>  LTS_path \<pi>1 = l1 \<and> LTS_path \<pi>2 = l2 "
  proof (cases "l1 = []")
    case True
    assume "l1 = []"
    have "LTS_path [] = []" by auto
    from p2 have "LTS_path (a # \<pi>) = l2" 
      by (simp add: True)
    obtain \<pi>1 \<pi>2 where 
      "\<pi>1 = [] \<and> \<pi>2 = (a # \<pi>) \<and> LTS_path \<pi>1 = l1 \<and> LTS_path \<pi>2 = l2"
      using True \<open>LTS_path (a # \<pi>) = l2\<close> \<open>LTS_path [] = []\<close> by blast
    then show ?thesis by auto
  next
    case False
    assume "l1 \<noteq> []"
    from this obtain l' where 
          "l1 = (snd a) # l'"
      by (metis LTS_path_def append_eq_Cons_conv list.simps(9) p2)
    have " LTS_path \<pi> = l' @ l2"
      using \<open>l1 = snd a # l'\<close> p2 by auto
    from this p1 obtain \<pi>1 \<pi>2 where
      "\<pi> = \<pi>1 @ \<pi>2 \<and> LTS_path \<pi>1 = l' \<and> LTS_path \<pi>2 = l2"
      by blast
    from this obtain \<pi>1' where "\<pi>1' = a # \<pi>1" by auto
    from this have "
      a # \<pi> = \<pi>1' @ \<pi>2 \<and> LTS_path \<pi>1' = l1 \<and> LTS_path \<pi>2 = l2
    "
      using \<open>\<pi> = \<pi>1 @ \<pi>2 \<and> LTS_path \<pi>1 = l' \<and> LTS_path \<pi>2 = l2\<close> \<open>l1 = snd a # l'\<close> by auto
    then show ?thesis 
      by blast
  qed
qed

lemma inPath_prop [simp]:
    "inPath ([] :: 'c list) (LTS_path_L (\<pi>::('c set \<times> 'e) list)) \<longrightarrow> \<pi> = []"
  apply (induction \<pi>)
  apply simp
  by simp 

lemma LTS_reachable_aux: 
    "inPath w (LTS_path_L \<pi>) \<and> \<pi> = \<pi>1 @ \<pi>2 \<Longrightarrow> 
      (\<exists> w1 w2. w = w1 @ w2 \<and> inPath w1 (LTS_path_L \<pi>1) 
       \<and> inPath w2 (LTS_path_L \<pi>2))"
  apply (induction w arbitrary: \<pi> \<pi>1 \<pi>2)
  using inPath_prop apply force
proof -
  fix a w \<pi> \<pi>1 \<pi>2
  assume app: "(\<And>\<pi> \<pi>1 \<pi>2.
           inPath w (LTS_path_L (\<pi> :: ('c set \<times> 'e) list)) \<and> \<pi> = \<pi>1 @ \<pi>2 \<Longrightarrow>
           \<exists>w1 w2.
              w = w1 @ w2 \<and> inPath w1 (LTS_path_L \<pi>1) \<and> inPath w2 (LTS_path_L \<pi>2))" and
        
       inpath_LTS: "inPath (a # w) (LTS_path_L \<pi>) \<and> (\<pi> :: ('c set \<times> 'e) list) = \<pi>1 @ \<pi>2"
  show "\<exists>w1 w2. a # w = w1 @ w2 \<and> inPath w1 (LTS_path_L \<pi>1) \<and> inPath w2 (LTS_path_L \<pi>2)"
  proof -
    from inpath_LTS obtain \<pi>' b where
     "\<pi> = b # \<pi>' \<and> a \<in> fst b"
      by (metis (no_types, hide_lams) 
              LTS_path_L_def \<open>inPath (a # w) 
              (LTS_path_L \<pi>) \<and> \<pi> = \<pi>1 @ \<pi>2\<close> inPath.simps(2) 
              inPath.simps(3) map_eq_Cons_D neq_Nil_conv)
    from this have inpath\<pi>': "inPath w (LTS_path_L \<pi>')"
      using \<open>inPath (a # w) (LTS_path_L \<pi>) \<and> \<pi> = \<pi>1 @ \<pi>2\<close> by auto
   
  show "\<exists>w1 w2. a # w = w1 @ w2 \<and> inPath w1 (LTS_path_L \<pi>1) \<and> 
        inPath w2 (LTS_path_L \<pi>2)"
    
  proof (cases "\<pi>1 = []")
  case True
  assume "(\<pi>1) = []"
  obtain w1 w2 where
  "(w1 :: 'c list) = []" and "w2 = a # w" by auto
  from this have 
   "a # w = w1 @ w2 \<and>  inPath w1 (LTS_path_L \<pi>1) \<and> inPath w2 (LTS_path_L \<pi>2)"
    using True \<open>inPath (a # w) (LTS_path_L \<pi>) \<and> \<pi> = \<pi>1 @ \<pi>2\<close> by auto
  then show ?thesis by auto
next
  case False
  assume "\<pi>1 \<noteq> []"
  from this obtain \<pi>1' where
  "\<pi>1 = b # \<pi>1'" 
    by (metis Cons_eq_append_conv \<open>\<pi> = b # \<pi>' \<and> a \<in> fst b\<close> \<open>inPath (a # w) (LTS_path_L \<pi>) \<and> \<pi> = \<pi>1 @ \<pi>2\<close>)
  from this have "\<pi>' = \<pi>1' @ \<pi>2"
    using \<open>\<pi> = b # \<pi>' \<and> a \<in> fst b\<close> \<open>inPath (a # w) (LTS_path_L \<pi>) \<and> \<pi> = \<pi>1 @ \<pi>2\<close> by auto
  from this have inpath\<pi>and : "inPath w (LTS_path_L \<pi>') \<and> \<pi>' = \<pi>1' @ \<pi>2"
    using inpath\<pi>' by blast  
  
  obtain w1 w2 where
     "w = w1 @ w2 \<and> inPath w1 (LTS_path_L \<pi>1') \<and> inPath w2 (LTS_path_L \<pi>2)"
    using app inpath\<pi>and by blast
  from this obtain w1' where
   "w1' = a # w1 \<and> inPath w1' (LTS_path_L \<pi>1)"
    using \<open>\<pi> = b # \<pi>' \<and> a \<in> fst b\<close> \<open>\<pi>1 = b # \<pi>1'\<close> by fastforce
  have "a # w = w1' @ w2 \<and> inPath w1' (LTS_path_L \<pi>1) \<and> inPath w2 (LTS_path_L \<pi>2)"
    using \<open>w = w1 @ w2 \<and> inPath w1 (LTS_path_L \<pi>1') \<and> inPath w2 (LTS_path_L \<pi>2)\<close> \<open>w1' = a # w1 \<and> inPath w1' (LTS_path_L \<pi>1)\<close> by auto
  then show ?thesis by auto
qed qed qed
  


lemma path_last_S_in :
  "LTS_path_last_S q \<pi> \<in> (insert q (set (LTS_path \<pi>)))"
by (induct \<pi> arbitrary: q, auto)

lemma [simp] : "inPath [] (LTS_path_L \<pi>) \<longleftrightarrow> \<pi> = []" 
  apply (induction \<pi>)
  apply (auto)
  done

lemma [simp] : "inPath (a#w) (LTS_path_L (\<sigma>q # \<pi>)) = 
          ((a \<in> fst \<sigma>q) \<and> (inPath w (LTS_path_L \<pi>)))"
  by (simp add: LTS_path_L_def)

lemma inPath_tail : "a \<in> \<sigma> \<and> inPath w l \<longrightarrow> inPath (w @ [a]) (l@[\<sigma>])"
  apply (induction w l rule: inPath.induct)
     apply simp
    apply auto
  done


lemma LTS_is_reachable_alt_def :
  "LTS_is_reachable \<Delta> q w q' = 
       (\<exists>\<pi>. LTS_is_path \<Delta> q \<pi> \<and> LTS_path_last_S q \<pi> = q' \<and> (inPath w (LTS_path_L \<pi>)))"
  (is "_ = (\<exists>\<pi>. ?pathPred q w \<pi>)")
proof (induct w arbitrary: q)
  case Nil thus ?case by simp
next
  case (Cons a w) note ind_hyp = this
  show ?case 
  proof  
    assume "LTS_is_reachable \<Delta> q (a # w) q'"
    then obtain q'' \<sigma> where
      reach_w: "LTS_is_reachable \<Delta> q'' w q'" and
      step_\<Delta>: "a \<in> \<sigma> \<and> (q, \<sigma>, q'') \<in> \<Delta>" 
      by auto
    from reach_w ind_hyp obtain \<pi> where
      "?pathPred q'' w \<pi>" by auto
    with step_\<Delta> have "?pathPred q (a # w) ((\<sigma>, q'') # \<pi>)" by simp
    thus "\<exists>\<pi>. ?pathPred q (a # w) \<pi>" by metis
  next
    assume "\<exists>\<pi>. ?pathPred q (a # w) \<pi>" 
    then obtain \<pi> where path_\<sigma>w: "?pathPred q (a # w) \<pi>" by auto
    then obtain q'' \<pi>' \<sigma> where \<pi>_eq: "a \<in> \<sigma> \<and> \<pi> = (\<sigma>, q'') # \<pi>'"
      by (cases \<pi>, auto)

    from \<pi>_eq path_\<sigma>w have 
      path_w: "?pathPred q'' w \<pi>'" and
      step_\<Delta>: "(q, \<sigma>, q'') \<in> \<Delta>"
      by (simp_all)
    from path_w ind_hyp have "LTS_is_reachable \<Delta> q'' w q'" by auto
    with step_\<Delta> \<pi>_eq show "LTS_is_reachable \<Delta> q (a # w) q'" by auto
  qed
qed

lemma LTS_is_reachable_concat :
   "LTS_is_reachable \<Delta> q (w @ w') q' = 
    (\<exists>q''. LTS_is_reachable \<Delta> q w q'' \<and> LTS_is_reachable \<Delta> q'' w' q')"
  by (induct w arbitrary: q, auto)

lemma LTS_is_reachable_concat_last :
   "LTS_is_reachable \<Delta> q (w @ [a]) q' = 
    (\<exists>q''. LTS_is_reachable \<Delta> q w q'' \<and> LTS_is_reachable \<Delta> q'' [a] q')"
by (induct w arbitrary: q, auto)

lemma LTS_is_reachable_snoc [simp] :
   "LTS_is_reachable \<Delta> q (w @ [a]) q' = 
    (\<exists>q'' \<sigma>. LTS_is_reachable \<Delta> q w q'' \<and> (q'', \<sigma>, q') \<in> \<Delta> \<and> a \<in> \<sigma>)"
  apply (auto simp add: LTS_is_reachable_concat)
  done

lemma LTS_is_reachable_subset [simp] :
   "\<Delta>1 \<subseteq> \<Delta>2 \<longrightarrow> LTS_is_reachable \<Delta>1 q w q' \<longrightarrow> LTS_is_reachable \<Delta>2 q w q'"
  apply (induct w arbitrary: q)
  by (induct w arbitrary: q, auto)

lemma sequence_split_aux:
  assumes empty: "Q1 \<inter> Q2 = {}" and
          sbset: "set l \<subseteq> Q1 \<union> Q2" and
          tail : "b \<in> Q2" 
 shows "a \<in> Q1 \<longrightarrow> (\<exists>l1 l2. l1 \<noteq> [] \<and> l2 \<noteq> [] \<and> 
        a # l @ [b] = l1 @ l2 \<and> last l1 \<in> Q1 \<and> nth l2 0 \<in> Q2)"
  apply (insert sbset)
  apply (induction l arbitrary: a)
  apply (metis append_Cons last.simps list.distinct(1) nth_Cons_0 tail)
  apply (rule impI)
proof -
  fix a l aa
  assume pre1: "(\<And>a. set l \<subseteq> Q1 \<union> Q2 \<Longrightarrow>
             a \<in> Q1 \<longrightarrow>
             (\<exists>l1 l2.
              l1 \<noteq> [] \<and>
              l2 \<noteq> [] \<and> a # l @ [b] = l1 @ l2 \<and> last l1 \<in> Q1 \<and> l2 ! 0 \<in> Q2))" and
         pre2: "aa \<in> Q1" and
         pre3: "set (a # l) \<subseteq> Q1 \<union> Q2"
  from this obtain l1 l2 where
          nempty: "l1 \<noteq> [] \<and> l2 \<noteq> []" and
          compse: "aa # l @ [b] = l1 @ l2" and
          lastc : "last l1 \<in> Q1" and
          headc : "l2 ! 0 \<in> Q2" 
    apply (auto simp add: pre1 [of aa])
     apply blast
    by blast
 from this obtain l' where "l1 = aa # l'" 
   by (metis Cons_eq_append_conv)
 show "\<exists>l1 l2.
          l1 \<noteq> [] \<and>
          l2 \<noteq> [] \<and> aa # (a # l) @ [b] = l1 @ l2 \<and> last l1 \<in> Q1 \<and> l2 ! 0 \<in> Q2"
 proof (cases "a \<in> Q1")
   case True
   assume "a \<in> Q1"
   from this obtain l1' where 
    l1'_const: "l1' = aa # a # l'"  by auto
  from this have l1'_noempty: "l1' \<noteq> []" by auto
  from l1'_const compse have l1'l2'l: "aa # (a # l) @ [b] = l1' @ l2"
    apply simp
    by (simp add: \<open>l1 = aa # l'\<close>)
  have "last l1' \<in> Q1" 
    using True \<open>l1 = aa # l'\<close> l1'_const lastc by auto
 then show ?thesis
   using headc l1'_noempty l1'l2'l nempty by blast
 next
   case False
   assume "a \<notin> Q1" 
   from this have "a \<in> Q2"
     using pre3 by auto
   obtain l1' where "l1' = [aa]" by auto
   obtain l2' where "l2' = a # l' @ l2" by auto
   have "l1' \<noteq> [] \<and> l2' \<noteq> []" 
     by (simp add: \<open>l1' = [aa]\<close> \<open>l2' = a # l' @ l2\<close>)
   have "aa # (a # l) @ [b] = l1' @ l2'" 
     using \<open>l1 = aa # l'\<close> \<open>l1' = [aa]\<close> \<open>l2' = a # l' @ l2\<close> compse by auto 
   have "last l1' \<in> Q1 \<and> l2 ! 0 \<in> Q2"
     by (simp add: \<open>l1' = [aa]\<close> headc pre2)
   then show ?thesis 
     using \<open>a \<in> Q2\<close> \<open>aa # (a # l) @ [b] = l1' @ l2'\<close> \<open>l1' \<noteq> [] \<and> l2' \<noteq> []\<close> \<open>l2' = a # l' @ l2\<close> by auto
 qed
qed

lemma sequence_split:
  assumes empty: "Q1 \<inter> Q2 = {}" and
          sbset: "set l \<subseteq> Q1 \<union> Q2" and
          head: "a \<in> Q1" and
          tail : "b \<in> Q2" 
 shows "(\<exists>l1 l2. l1 \<noteq> [] \<and> l2 \<noteq> [] \<and> 
        a # l @ [b] = l1 @ l2 \<and> last l1 \<in> Q1 \<and> nth l2 0 \<in> Q2)"
  using empty head sbset sequence_split_aux tail by fastforce

lemma LTS_is_reachable_disjoint_aux:
  assumes Q1_Q2_noempty: "Q1 \<inter> Q2 = {}" and
            \<Delta>_in_Q1_Q2: "\<And> q \<alpha> q'. (q, \<alpha>, q') \<in> \<Delta> \<longrightarrow> 
                    (q \<in> Q1 \<or> q \<in> Q2) \<and> (q' \<in> Q1 \<or> q' \<in> Q2)" and
          q1_q2: "q \<in> Q1 \<and> q' \<in> Q2" and
      reachable: "LTS_is_reachable \<Delta> q w q'"
    shows "\<exists> q1 q2 w1 w2 a \<alpha> . LTS_is_reachable \<Delta> q w1 q1 \<and>
                          LTS_is_reachable \<Delta> q2 w2 q' \<and>
                          w = w1 @ [a] @ w2 \<and> q1 \<in> Q1 \<and> q2 \<in> Q2 \<and>
                          (q1, \<alpha>, q2) \<in> \<Delta> \<and> a \<in> \<alpha>"
    
proof - 
  from q1_q2 have qQ1: "q \<in> Q1" by auto 
  from q1_q2 have qQ2: "q' \<in> Q2" by auto
  from reachable LTS_is_reachable_alt_def 
  obtain \<pi> where 
    LTS_is_path_\<Delta>: "LTS_is_path \<Delta> q \<pi>" and
    LTS_path_last_S_q: "LTS_path_last_S q \<pi> = q'" and
    inPath_w: "inPath w (LTS_path_L \<pi>)" 
    by (auto simp add: reachable LTS_is_reachable_alt_def)
  from this have q_Q1_Q2: "\<And>q. q \<in> set (LTS_path \<pi>) \<longrightarrow> q \<in> Q1 \<or> q \<in> Q2"
    apply auto
    apply (induction \<pi> arbitrary: w q)
    apply simp
    apply (simp add: LTS_path_def)
    apply auto[1]
    using \<Delta>_in_Q1_Q2 apply blast
    by (metis imageI inPath.elims(2) list.inject list.simps(3) snd_conv)
  let ?p = "q # (LTS_path \<pi>)"
  obtain l where pl_eq : "?p = q # l @ [q']" 
    by (metis LTS_path_last_S_def LTS_path_last_S_q Q1_Q2_noempty append_butlast_last_id disjoint_iff_not_equal last.simps q1_q2)
  from this have setlQ12: "set l \<subseteq> Q1 \<union> Q2" 
    using q_Q1_Q2 by fastforce
  
  from pl_eq this q_Q1_Q2 q1_q2 LTS_path_last_S_q
  have "\<exists> l1 l2. l1 \<noteq> [] \<and> l2 \<noteq> [] \<and> ?p = l1 @ l2 
          \<and> last l1 \<in> Q1 \<and> nth l2 0 \<in> Q2"
    apply (insert
    sequence_split[of Q1 Q2 l q q', OF Q1_Q2_noempty setlQ12 qQ1 qQ2])
    by (simp add: pl_eq)
  from this obtain l1 l2 where 
  l1l2: "l1 \<noteq> [] \<and> l2 \<noteq> [] \<and> ?p = l1 @ l2 
          \<and> last l1 \<in> Q1 \<and> nth l2 0 \<in> Q2" by auto
  from this pl_eq have
    "\<exists> \<pi>1 \<pi>2. \<pi> = \<pi>1 @ \<pi>2 \<and> q # LTS_path (\<pi>1 @ \<pi>2) = l1 @ l2"
    by fastforce
  have "\<And>\<pi>1 \<pi>2. \<pi> = \<pi>1 @ \<pi>2 \<longrightarrow> LTS_path \<pi> = LTS_path \<pi>1 @ LTS_path \<pi>2"
    by (simp add: LTS_path_def)
  from this pl_eq l1l2 LTS_path_divide have 
      "\<exists> \<pi>1 \<pi>2. \<pi> = \<pi>1 @ \<pi>2 \<and> q # LTS_path \<pi>1 = l1 \<and> 
                LTS_path \<pi>2 = l2"
    by (metis append_eq_Cons_conv)
  from this obtain
  \<pi>1 \<pi>2 where
  \<pi>\<pi>1\<pi>2: "\<pi> = \<pi>1 @ \<pi>2 \<and> q # LTS_path \<pi>1 = l1 \<and> 
                LTS_path \<pi>2 = l2" by auto
  from LTS_reachable_aux obtain w1 w2 where  
      "w = w1 @ w2 \<and> inPath w1 (LTS_path_L \<pi>1) \<and> inPath w2 (LTS_path_L \<pi>2)"
    using \<open>\<pi> = \<pi>1 @ \<pi>2 \<and> q # LTS_path \<pi>1 = l1 \<and> LTS_path \<pi>2 = l2\<close> inPath_w by blast
  from this have con1: "LTS_is_reachable \<Delta> q w1 (last l1)"
    apply (simp add: LTS_is_reachable_alt_def)
  proof -
    have  "LTS_is_path \<Delta> q \<pi>1 \<and> 
          LTS_path_last_S q \<pi>1 = last l1 \<and> inPath w1 (LTS_path_L \<pi>1)"
    by (metis LTS_is_path.simps(1) LTS_is_path_\<Delta> LTS_is_path_concat LTS_path_last_S_def \<open>\<pi> = \<pi>1 @ \<pi>2 \<and> q # LTS_path \<pi>1 = l1 \<and> LTS_path \<pi>2 = l2\<close> \<open>w = w1 @ w2 \<and> inPath w1 (LTS_path_L \<pi>1) \<and> inPath w2 (LTS_path_L \<pi>2)\<close>)
  from this show "\<exists>\<pi>. LTS_is_path \<Delta> q \<pi> \<and> LTS_path_last_S q \<pi> = last l1 \<and> inPath w1 (LTS_path_L \<pi>)"
    by auto
qed
  have "\<pi>2 \<noteq> [] \<and> w2 \<noteq> []"
    using \<open>\<pi> = \<pi>1 @ \<pi>2 \<and> q # LTS_path \<pi>1 = l1 \<and> LTS_path \<pi>2 = l2\<close> \<open>w = w1 @ w2 \<and> inPath w1 (LTS_path_L \<pi>1) \<and> inPath w2 (LTS_path_L \<pi>2)\<close> l1l2 by auto
  from this obtain fa w2' fb \<pi>2' where
    w\<pi>2eq: "w2 = fa # w2' \<and> \<pi>2 = fb # \<pi>2'" 
    by (meson list.exhaust) 
  have con2: "w = w1 @ [fa] @ w2'"
    by (simp add: \<open>w = w1 @ w2 \<and> inPath w1 (LTS_path_L \<pi>1) \<and> inPath w2 (LTS_path_L \<pi>2)\<close> \<open>w2 = fa # w2' \<and> \<pi>2 = fb # \<pi>2'\<close>)
  have con3: "last l1 \<in> Q1 \<and> (snd fb) \<in> Q2"
    using \<open>\<pi> = \<pi>1 @ \<pi>2 \<and> q # LTS_path \<pi>1 = l1 \<and> LTS_path \<pi>2 = l2\<close> \<open>w2 = fa # w2' \<and> \<pi>2 = fb # \<pi>2'\<close> l1l2 by auto

  have inpathw2\<pi>2: "inPath w2 (LTS_path_L \<pi>2)"
    using \<open>w = w1 @ w2 \<and> inPath w1 (LTS_path_L \<pi>1) \<and> inPath w2 (LTS_path_L \<pi>2)\<close> by blast

 
  have con5: "LTS_is_reachable \<Delta> (snd fb) w2' (last l2)"
    apply (simp add: LTS_is_reachable_alt_def)
  proof -
    have Lcon1: "LTS_is_path \<Delta> (snd fb) \<pi>2'" 
      by (metis LTS_is_path.simps(2) LTS_is_path_\<Delta> LTS_is_path_concat \<open>\<pi> = \<pi>1 @ \<pi>2 \<and> q # LTS_path \<pi>1 = l1 \<and> LTS_path \<pi>2 = l2\<close> \<open>w2 = fa # w2' \<and> \<pi>2 = fb # \<pi>2'\<close> append_Nil)
    have Lcon2: "LTS_path_last_S (snd fb) \<pi>2' = last l2"
      using LTS_path_last_S_def \<open>\<pi> = \<pi>1 @ \<pi>2 \<and> q # LTS_path \<pi>1 = l1 \<and> LTS_path \<pi>2 = l2\<close> \<open>w2 = fa # w2' \<and> \<pi>2 = fb # \<pi>2'\<close> by fastforce
    from inpathw2\<pi>2 w\<pi>2eq have Lcon3 : "inPath w2' (LTS_path_L \<pi>2')"
      by simp
    from Lcon1 Lcon2 Lcon3 show "\<exists>\<pi>. LTS_is_path \<Delta> (snd fb) \<pi> \<and>
        LTS_path_last_S (snd fb) \<pi> = last l2 \<and> inPath w2' (LTS_path_L \<pi>)"
      by auto
  qed  
     
   from inpathw2\<pi>2 have con4: "(last l1, fst fb, snd fb) \<in> \<Delta> \<and> fa \<in> fst fb"
    apply (rule_tac conjI)
    defer
    apply (simp add: \<open>w2 = fa # w2' \<and> \<pi>2 = fb # \<pi>2'\<close>)
   proof (cases "\<pi>1 = []")
     case True
     assume "\<pi>1 = []"
     from this have "last l1 = q"
       using \<pi>\<pi>1\<pi>2 by auto
     from this LTS_is_path_concat LTS_is_path_\<Delta> \<pi>\<pi>1\<pi>2 
     have "LTS_is_path \<Delta> (last l1) \<pi>2"
       apply simp
       by (simp add: True)
     then show "(last l1, fst fb, snd fb) \<in> \<Delta>" 
       by (simp add: w\<pi>2eq)
   next
     case False
     assume "\<pi>1 \<noteq> []"
     have "snd (last \<pi>1) = last l1"
       by (metis (no_types, hide_lams) False LTS_path_def \<pi>\<pi>1\<pi>2 append_butlast_last_id last.simps last_appendR list.distinct(1) list.map(2) map_append map_is_Nil_conv)
    from this LTS_is_path_concat LTS_is_path_\<Delta> \<pi>\<pi>1\<pi>2 have 
    "LTS_is_path \<Delta> (last l1) \<pi>2"  
      by (simp add: LTS_is_path_concat False)
   then show "(last l1, fst fb, snd fb) \<in> \<Delta>" sledgehammer
     by (simp add: w\<pi>2eq)
 qed
  from con1 con2 con3 con4 con5 show ?thesis 
    by (metis LTS_path_last_S_def LTS_path_last_S_q l1l2 last_appendR)
qed

lemma LTS_is_reachable_closure:
  assumes Q1_Q2_noempty: "Q1 \<inter> Q2 = {}" and
          \<Delta>1_in_Q1: "\<And> q \<alpha> q'. (q, \<alpha>, q') \<in> \<Delta>1 \<longrightarrow> q \<in> Q1 \<and> q' \<in> Q1" and 
          \<Delta>2_in_Q2: "\<And> q \<alpha> q'. (q, \<alpha>, q') \<in> \<Delta>2 \<longrightarrow> q \<in> Q2 \<and> q' \<in> Q2"  and
          \<Delta>1_\<Delta>2_Q1_Q2: "\<And> q \<alpha> q'. (q, \<alpha>, q') \<in> \<Delta>3 \<longrightarrow> q \<in> Q1 \<and> q' \<in> Q2"  and
                 q_q' : "q2 \<in> Q2 \<and> q' \<in> Q2"  
  shows "LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q2 w2 q' = 
          LTS_is_reachable \<Delta>2 q2 w2 q'"
    apply (subgoal_tac "q2 \<in> Q2")
    defer
    apply (simp add: q_q') 
    apply (subgoal_tac "\<Delta>2 \<subseteq> \<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3")
    defer
    apply auto
    apply (insert LTS_is_reachable_subset)
    defer 
    apply (induction w2 arbitrary: q2)
    apply simp
  proof -
    fix a w2 q2
    assume p1: "(\<And>q2. q2 \<in> Q2 \<Longrightarrow>
              \<Delta>2 \<subseteq> \<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3 \<Longrightarrow>
              LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q2 w2 q' \<Longrightarrow>
              (\<And>\<Delta>1 \<Delta>2 q w q'.
                  \<Delta>1 \<subseteq> \<Delta>2 \<longrightarrow>
                  LTS_is_reachable \<Delta>1 q w q' \<longrightarrow> LTS_is_reachable \<Delta>2 q w q') \<Longrightarrow>
              LTS_is_reachable \<Delta>2 q2 w2 q')" and
           p2: "LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q2 (a # w2) q'" and
           p3: "q2 \<in> Q2"
    from p2 LTS_is_reachable_concat obtain qi where
    p4: "LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q2 [a] qi" and
    p5: "LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) qi w2 q'" by auto 
    from p4 obtain \<alpha> where "(q2, \<alpha>, qi) \<in> (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) \<and> a \<in> \<alpha>"
      by auto
    from q_q' \<Delta>1_in_Q1 \<Delta>2_in_Q2 \<Delta>1_\<Delta>2_Q1_Q2 p3
    have p6: "qi \<in> Q2"
      using Q1_Q2_noempty \<open>(q2, \<alpha>, qi) \<in> \<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3 \<and> a \<in> \<alpha>\<close> by blast 
    have p7: "(q2, \<alpha>, qi) \<in> \<Delta>2 \<and> a \<in> \<alpha>"
      using Q1_Q2_noempty \<Delta>1_\<Delta>2_Q1_Q2 \<Delta>1_in_Q1 \<open>(q2, \<alpha>, qi) \<in> \<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3 \<and> a \<in> \<alpha>\<close> p3 by fastforce
    from this have con3: "LTS_is_reachable \<Delta>2 q2 [a] qi" 
      by auto 
    have subset\<Delta>: "\<Delta>2 \<subseteq> \<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3" by auto
    
    from p1[of qi, OF p6 subset\<Delta> p5 LTS_is_reachable_subset] have
     con4: "LTS_is_reachable \<Delta>2 qi w2 q'" by auto
    from con3 con4 LTS_is_reachable_concat 
    show "LTS_is_reachable \<Delta>2 q2 (a # w2) q'" by auto
  qed

lemma LTS_is_reachable_disjoint:
  assumes Q1_Q2_noempty: "Q1 \<inter> Q2 = {}" and
            \<Delta>1_in_Q1: "\<And> q \<alpha> q'. (q, \<alpha>, q') \<in> \<Delta>1 \<longrightarrow> q \<in> Q1 \<and> q' \<in> Q1" and 
              \<Delta>2_in_Q2: "\<And> q \<alpha> q'. (q, \<alpha>, q') \<in> \<Delta>2 \<longrightarrow> q \<in> Q2 \<and> q' \<in> Q2"  and
          \<Delta>1_\<Delta>2_Q1_Q2: "\<And> q \<alpha> q'. (q, \<alpha>, q') \<in> \<Delta>3 \<longrightarrow> q \<in> Q1 \<and> q' \<in> Q2"  and
                 q_q' : "q \<in> Q1 \<and> q' \<in> Q2"  and
             reachable: "LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q w q'"
  shows "\<exists> q1 q2 w1 w2 a \<alpha> . LTS_is_reachable \<Delta>1 q w1 q1 \<and>
                          LTS_is_reachable \<Delta>2 q2 w2 q' \<and>
                          w = w1 @ [a] @ w2 \<and> q1 \<in> Q1 \<and> q2 \<in> Q2 \<and>
                          (q1, \<alpha>, q2) \<in> \<Delta>3 \<and> a \<in> \<alpha>"
  thm LTS_is_reachable_disjoint_aux
  
proof -
  from \<Delta>1_in_Q1 \<Delta>2_in_Q2 \<Delta>1_\<Delta>2_Q1_Q2 
  have in_\<Delta>123: "(\<And>q \<alpha> q'.
      (q, \<alpha>, q') \<in> \<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3 \<longrightarrow> (q \<in> Q1 \<or> q \<in> Q2) \<and> (q' \<in> Q1 \<or> q' \<in> Q2))"
    by auto
  
  from LTS_is_reachable_disjoint_aux[of Q1 Q2 "\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3" q q' w,
        OF Q1_Q2_noempty in_\<Delta>123 q_q' reachable] 
  obtain q1 q2 w1 w2 a \<alpha> where
  re0: "LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q w1 q1 \<and>
   LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q2 w2 q' \<and>
   w = w1 @ [a] @ w2 \<and> q1 \<in> Q1 \<and> q2 \<in> Q2 \<and>
   (q1, \<alpha>, q2) \<in> (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) \<and> a \<in> \<alpha>" by blast
  have subset\<Delta>: "\<Delta>2 \<subseteq> (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3)" by auto 
  have q2_in_Q1: "q2 \<in> Q2" 
    using \<open>LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q w1 q1 \<and> LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q2 w2 q' \<and> w = w1 @ [a] @ w2 \<and> q1 \<in> Q1 \<and> q2 \<in> Q2 \<and> (q1, \<alpha>, q2) \<in> \<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3 \<and> a \<in> \<alpha>\<close> by blast
  from this have re2: "LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q2 w2 q' = 
        LTS_is_reachable \<Delta>2 q2 w2 q'"
    apply (auto)
    apply (insert subset\<Delta> LTS_is_reachable_subset)
    defer
    apply auto 
    apply (induction w2 arbitrary: q2)
    apply simp
  proof -
    fix a w2 q2
    assume p1: "(\<And>q2. q2 \<in> Q2 \<Longrightarrow>
              LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q2 w2 q' \<Longrightarrow>
              \<Delta>2 \<subseteq> \<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3 \<Longrightarrow>
              (\<And>\<Delta>1 \<Delta>2 q w q'.
                  \<Delta>1 \<subseteq> \<Delta>2 \<longrightarrow>
                  LTS_is_reachable \<Delta>1 q w q' \<longrightarrow> LTS_is_reachable \<Delta>2 q w q') \<Longrightarrow>
              LTS_is_reachable \<Delta>2 q2 w2 q')" and
           p2: "LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q2 (a # w2) q'" and
           p3: "q2 \<in> Q2"
    from p2 LTS_is_reachable_concat obtain qi where
    p4: "LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q2 [a] qi" and
    p5: "LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) qi w2 q'" by auto 
    from p4 obtain \<alpha> where "(q2, \<alpha>, qi) \<in> (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) \<and> a \<in> \<alpha>"
      by auto
    from q_q' \<Delta>1_in_Q1 \<Delta>2_in_Q2 \<Delta>1_\<Delta>2_Q1_Q2 p3
    have p6: "qi \<in> Q2"
      using Q1_Q2_noempty \<open>(q2, \<alpha>, qi) \<in> \<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3 \<and> a \<in> \<alpha>\<close> by blast 
    have p7: "(q2, \<alpha>, qi) \<in> \<Delta>2 \<and> a \<in> \<alpha>"
      using Q1_Q2_noempty \<Delta>1_\<Delta>2_Q1_Q2 \<Delta>1_in_Q1 \<open>(q2, \<alpha>, qi) \<in> \<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3 \<and> a \<in> \<alpha>\<close> p3 by fastforce
    from this have con3: "LTS_is_reachable \<Delta>2 q2 [a] qi" 
      by auto 
    from p1[of qi, OF p6 p5 subset\<Delta> LTS_is_reachable_subset] have
     con4: "LTS_is_reachable \<Delta>2 qi w2 q'" by auto
    from con3 con4 LTS_is_reachable_concat 
    show "LTS_is_reachable \<Delta>2 q2 (a # w2) q'" by auto
  qed
  have subset\<Delta>1: "\<Delta>1 \<subseteq> (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3)"
    by blast
  have q2_in_Q1: "q1 \<in> Q1"
    using \<open>LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q w1 q1 \<and> LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q2 w2 q' \<and> w = w1 @ [a] @ w2 \<and> q1 \<in> Q1 \<and> q2 \<in> Q2 \<and> (q1, \<alpha>, q2) \<in> \<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3 \<and> a \<in> \<alpha>\<close> by blast
  from this have re1: "LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q w1 q1 = 
        LTS_is_reachable \<Delta>1 q w1 q1"
    apply (auto)
    apply (insert subset\<Delta>1 LTS_is_reachable_subset)
    defer
    apply auto 
    apply (induction w1 arbitrary: q)
    apply simp
  proof -
    fix a w1 q
    assume p1: "(\<And>q. q1 \<in> Q1 \<Longrightarrow>
             LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q w1 q1 \<Longrightarrow>
             \<Delta>1 \<subseteq> \<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3 \<Longrightarrow>
             (\<And>\<Delta>1 \<Delta>2 q w q'.
                 \<Delta>1 \<subseteq> \<Delta>2 \<longrightarrow>
                 LTS_is_reachable \<Delta>1 q w q' \<longrightarrow> LTS_is_reachable \<Delta>2 q w q') \<Longrightarrow>
             LTS_is_reachable \<Delta>1 q w1 q1)" and
           p2: "q1 \<in> Q1" and
           p3: "LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q (a # w1) q1"

    from this p3 LTS_is_reachable_concat 
    obtain qi where
     p4: "LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) q [a] qi" and
     p5: "LTS_is_reachable (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) qi w1 q1"
      by auto
    from p4 obtain \<alpha> where "(q, \<alpha>, qi) \<in> (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3) \<and> a \<in> \<alpha>"
      by auto
    from this in_\<Delta>123 have con1: "qi \<in> (Q1 \<union> Q2)" 
      by blast
    have con2: "qi \<in> Q1" 
    proof (rule ccontr)
    assume "qi \<notin> Q1"
    from this con1 have "qi \<in> Q2" by auto
    from in_\<Delta>123 have in_\<Delta>123': "(\<And>q \<alpha> q'.
      (q, \<alpha>, q') \<in> \<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3 \<longrightarrow> (q \<in> Q2 \<or> q \<in> Q1) \<and> (q' \<in> Q2 \<or> q' \<in> Q1))"
      by auto
    have qi_q1: "qi \<in> Q2 \<and> q1 \<in> Q1"
      using \<open>qi \<in> Q2\<close> q2_in_Q1 by auto
    from Q1_Q2_noempty have Q2_Q1_noempty: "Q2 \<inter> Q1 = {}" by auto
    from LTS_is_reachable_disjoint_aux[of Q2 Q1 "\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3" qi q1 w1,
              OF Q2_Q1_noempty in_\<Delta>123' qi_q1 p5] 
  obtain q1' q2' \<alpha>' where
  " q1' \<in> Q2 \<and> q2' \<in> Q1 \<and>
   (q1', \<alpha>', q2') \<in> (\<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3)" by blast
  from this  \<Delta>1_in_Q1 \<Delta>2_in_Q2 \<Delta>1_\<Delta>2_Q1_Q2 
  show "False"
    using Q1_Q2_noempty by blast
  qed
  have p7: "(q, \<alpha>, qi) \<in> \<Delta>1 \<and> a \<in> \<alpha>"
  using Q1_Q2_noempty \<Delta>1_\<Delta>2_Q1_Q2 \<Delta>2_in_Q2 \<open>(q, \<alpha>, qi) \<in> \<Delta>1 \<union> \<Delta>2 \<union> \<Delta>3 \<and> a \<in> \<alpha>\<close> \<open>qi \<in> Q1\<close> by auto  
    
  from this have con3: "LTS_is_reachable \<Delta>1 q [a] qi"
    by auto 
   
  from p1[of qi, OF q2_in_Q1 p5 subset\<Delta>1 LTS_is_reachable_subset] have
     con4: "LTS_is_reachable \<Delta>1 qi w1 q1" by auto
  from con3 con4 LTS_is_reachable_concat 
  show "LTS_is_reachable \<Delta>1 q (a # w1) q1" by auto
qed
  from re1 re2 re0 show ?thesis
    apply simp
    using Q1_Q2_noempty \<Delta>1_in_Q1 \<Delta>2_in_Q2 by fastforce
qed


        
    
    
  



      

      
  
    


lemma LTS_is_reachable_onestep [simp]: 
 "LTS_is_reachable \<Delta> q w q' \<and> (q', \<sigma>, q'') \<in> \<Delta> \<and> a \<in> \<sigma> \<longrightarrow> 
  LTS_is_reachable \<Delta> q (w @ [a]) q''"
  by auto

text \<open> Unreachability is often interesting as well.  \<close>

definition LTS_is_unreachable where
   "LTS_is_unreachable \<Delta> q q' \<longleftrightarrow> \<not>(\<exists> w . LTS_is_reachable \<Delta> q w q')"



lemma LTS_is_unreachable_not_refl [simp] :
   "\<not>(LTS_is_unreachable \<Delta> q q)"
proof -
  have "LTS_is_reachable \<Delta> q [] q " by simp
  thus "\<not>(LTS_is_unreachable \<Delta> q q)"
    by (metis LTS_is_unreachable_def)
qed

lemma LTS_is_unreachable_reachable_start :
assumes unreach_q_q': "LTS_is_unreachable \<Delta> q q'" 
    and reach_q_q'': "LTS_is_reachable \<Delta> q w q''" 
shows "LTS_is_unreachable \<Delta> q'' q'"
proof (rule ccontr)
  assume "\<not> (LTS_is_unreachable \<Delta> q'' q')"
  then obtain w' where 
                       reach_q''_q': "LTS_is_reachable \<Delta> q'' w' q'"
    by (auto simp add: LTS_is_unreachable_def)
  
  from reach_q_q'' reach_q''_q' have
    reach_q_q' : "LTS_is_reachable \<Delta> q (w @ w') q'" 
        by (auto simp add: LTS_is_reachable_concat)
 
  from reach_q_q' unreach_q_q' show "False"
    by (metis LTS_is_unreachable_def)
qed
      
lemma LTS_is_unreachable_reachable_end :
   "\<lbrakk>LTS_is_unreachable \<Delta> q q'; LTS_is_reachable \<Delta> q'' w q'\<rbrakk> \<Longrightarrow>
    LTS_is_unreachable \<Delta> q q''"
by (metis LTS_is_unreachable_def LTS_is_unreachable_reachable_start)



subsection  \<open> Reachablity on Graphs  \<close> 

definition LTS_forget_labels_pred :: "('a set \<Rightarrow> bool) \<Rightarrow> ('q, 'a) LTS \<Rightarrow> ('q \<times> 'q) set" where
  "LTS_forget_labels_pred P \<Delta> = {(q, q') . \<exists> \<sigma>. \<sigma> \<noteq> {} \<and> (q, \<sigma>, q') \<in> \<Delta> \<and> P \<sigma>}"

definition LTS_forget_labels :: "('q, 'a) LTS \<Rightarrow> ('q \<times> 'q) set" where
  "LTS_forget_labels \<Delta> = {(q, q') . \<exists>\<sigma>. \<sigma> \<noteq> {} \<and> (q, \<sigma>, q') \<in> \<Delta>}"

lemma LTS_forget_labels_alt_def :
  "LTS_forget_labels \<Delta> = LTS_forget_labels_pred (\<lambda>\<sigma>. True) \<Delta>"
unfolding LTS_forget_labels_def LTS_forget_labels_pred_def
  by simp



lemma [simp]: "(\<exists>l\<in>lists {\<sigma>. P \<sigma>}. inPath w l) \<longrightarrow> 
               P \<sigma> \<longrightarrow> a \<in> \<sigma> \<longrightarrow>
               (\<exists>l\<in>lists {\<sigma>. P \<sigma>}. inPath (w @ [a]) l)"
  apply (induction w)
  apply (metis Cons_in_lists_iff append.left_neutral inPath.simps(2) mem_Collect_eq)
  apply auto
  apply (metis Cons_in_lists_iff inPath.elims(2) in_listsI list.distinct(1) list.inject mem_Collect_eq) 
  by ( metis Cons_in_lists_iff inPath.elims(2) 
       inPath.simps(2) in_lists_conv_set 
       list.distinct(1) mem_Collect_eq)



lemma rtrancl_LTS_forget_labels_pred :
  "(rtrancl (LTS_forget_labels_pred (\<lambda>_.True) \<Delta>) =
   {(q, q'). (\<exists> w. LTS_is_reachable \<Delta> q w q')})"
   (is "?ls = ?rs")

proof (intro set_eqI)
  fix qq' :: "('a \<times> 'a)"
  obtain q q' where qq'_eq : "qq' = (q, q')" by (cases qq', auto)

  have imp1 : "(q, q') \<in> ?ls \<Longrightarrow> (q,q') \<in> ?rs" 
  proof (induct rule: rtrancl_induct)
    case base thus ?case 
      apply simp
      apply (rule exI [where x = "[]"])
      apply auto
      done
  next
    case (step q' q'')
    then obtain w \<sigma> a where
      qq'_ind : "LTS_is_reachable \<Delta> q w q'" and
      q'q''_ind: "(q', \<sigma>, q'') \<in> \<Delta> \<and> \<sigma> \<noteq> {}" and
      a_\<sigma>: "a \<in> \<sigma>" 
      unfolding LTS_forget_labels_pred_def 
      by auto
    hence "LTS_is_reachable \<Delta> q (w @ [a]) q''" 
      by auto
    hence "\<exists> w. LTS_is_reachable \<Delta> q w q''" 
      by blast
    thus ?case by simp
  qed

  have imp2 : "\<And>w. \<lbrakk>LTS_is_reachable \<Delta> q w q'\<rbrakk> 
      \<Longrightarrow> (q,q') \<in> ?ls" 
  proof -
    fix w show "\<lbrakk>LTS_is_reachable \<Delta> q w q'\<rbrakk> 
         \<Longrightarrow> (q,q') \<in> ?ls"
    proof (induct w arbitrary: q)
      case Nil thus ?case by simp
    next
      case (Cons a w)
      then obtain q'' \<sigma> where
         in_D: "(q, \<sigma>, q'') \<in> \<Delta> \<and> \<sigma> \<noteq> {} \<and> a \<in> \<sigma>" and
         in_trcl: "(q'', q') \<in> rtrancl (LTS_forget_labels_pred (\<lambda>_.True) \<Delta>)"
        by auto
      from in_D have in_D': "(q, q'') \<in> (LTS_forget_labels_pred (\<lambda>_.True) \<Delta>)" 
        unfolding LTS_forget_labels_pred_def by auto

      note converse_rtrancl_into_rtrancl [OF in_D' in_trcl]
      thus ?case by auto
    qed
  qed

  from imp1 imp2 qq'_eq show "(qq' \<in> ?ls) = (qq' \<in> ?rs)" by auto
qed

definition pred_\<Delta> where "pred_\<Delta> P \<Delta> = {(q,\<sigma>,q'). (q,\<sigma>,q') \<in> \<Delta> \<and> P \<sigma>}"



lemma rtrancl_LTS_forget_labels_pre :
  "rtrancl (LTS_forget_labels \<Delta>) =
   rtrancl (LTS_forget_labels_pred (\<lambda> _.True) \<Delta>)"
  by (simp add: LTS_forget_labels_alt_def)
  

lemma rtrancl_LTS_forget_labels :
  "rtrancl (LTS_forget_labels \<Delta>) =
   {(q, q'). (\<exists>w. LTS_is_reachable \<Delta> q w q')}"
  apply (auto simp add: rtrancl_LTS_forget_labels_pre rtrancl_LTS_forget_labels_pred)
  done
  



definition LTS_rename_forget_labels :: "('q \<Rightarrow> 'q2) \<Rightarrow> ('q, 'a) LTS \<Rightarrow> 
   ('q2 \<times> 'q2) set" where
"LTS_rename_forget_labels f \<Delta> = {(f q, f q') | q \<sigma> q'. (q, \<sigma>, q') \<in> \<Delta>}"



subsection \<open> Restricting and extending the transition relation  \<close>

lemma LTS_is_path_mono : 
  "\<lbrakk>\<Delta> \<subseteq> \<Delta>'; LTS_is_path \<Delta> q \<pi>\<rbrakk> \<Longrightarrow> LTS_is_path \<Delta>' q \<pi>"
by (induct \<pi> arbitrary: q, auto)

lemma LTS_is_reachable_mono : 
  "\<lbrakk>\<Delta> \<subseteq> \<Delta>'; LTS_is_reachable \<Delta> q w q'\<rbrakk> \<Longrightarrow> LTS_is_reachable \<Delta>' q w q'"
  apply (induct w arbitrary: q, auto)
  by (meson LTS_is_reachable_subset subsetD)

subsection  \<open> Reachablity on Graphs  \<close> 





subsection \<open> Restricting and extending the transition relation  \<close>


subsection \<open> Products \<close>

definition LTS_product :: "('p,'a) LTS \<Rightarrow> ('q,'a) LTS \<Rightarrow> ('p*'q,'a) LTS" where
  "LTS_product \<Delta>1 \<Delta>2 = 
   {((p,q), \<sigma>, (p',q')) | p p' \<sigma>1 \<sigma>2 \<sigma> q q'. (p, \<sigma>1, p') \<in> \<Delta>1 \<and> (q, \<sigma>2, q') \<in> \<Delta>2 
     \<and> \<sigma>1 \<inter> \<sigma>2 = \<sigma>}"

lemma LTS_product_elem :
  "((p,q), \<sigma>, (p',q')) \<in> LTS_product \<Delta>1 \<Delta>2 = (\<exists> \<sigma>1 \<sigma>2. ((p,\<sigma>1,p') \<in> \<Delta>1 \<and> 
               (q,\<sigma>2,q') \<in> \<Delta>2 \<and> \<sigma>1 \<inter> \<sigma>2 = \<sigma>))"
  apply (auto simp add: LTS_product_def)
  done

lemma LTS_product_alt_def [simp] :
  "x \<in> LTS_product \<Delta>1 \<Delta>2 = (\<exists> \<sigma>1 \<sigma>2. \<sigma>1 \<inter> \<sigma>2 = fst (snd x)  \<and>
   ((fst (fst x),\<sigma>1, fst (snd (snd x))) \<in> \<Delta>1 \<and> 
    (snd (fst x),\<sigma>2, snd (snd (snd x))) \<in> \<Delta>2))"
  apply (cases x)
  apply (case_tac a)
  apply (simp add: LTS_product_elem)
  by auto

  

definition LTS_product_path1 where 
           "LTS_product_path1 \<pi> = map (% x. (fst x, fst (snd x))) \<pi>"
definition LTS_product_path2 where 
           "LTS_product_path2 \<pi> = map (% x. (fst x, snd (snd x))) \<pi>"



lemma LTS_product_path1_L [simp]: "LTS_path_L (LTS_product_path1 \<pi>) = LTS_path_L \<pi>"
  by  (simp add: LTS_product_path1_def LTS_path_L_def)

lemma LTS_product_path2_L [simp]: "LTS_path_L (LTS_product_path2 \<pi>) = LTS_path_L \<pi>"
  by  (simp add: LTS_product_path2_def LTS_path_L_def)

lemma LTS_product_path1_S: "LTS_path (LTS_product_path1 \<pi>) = map fst (LTS_path \<pi>)"
  by  (simp add: LTS_product_path1_def LTS_path_def)

lemma LTS_product_path2_S: "LTS_path (LTS_product_path2 \<pi>) = map snd (LTS_path \<pi>)"
  by  (simp add: LTS_product_path2_def LTS_path_def)

lemma LTS_product_path1_last_S: "LTS_path_last_S (fst pq) (LTS_product_path1 \<pi>) = fst (LTS_path_last_S pq \<pi>)"
  by (metis LTS_path_last_S_def LTS_product_path1_S last_map list.simps(3) list.map(2))

lemma LTS_product_path2_last_S: "LTS_path_last_S (snd pq) (LTS_product_path2 \<pi>) = snd (LTS_path_last_S pq \<pi>)"
  by (metis LTS_path_last_S_def LTS_product_path2_S last_map list.simps(3) list.map(2))

lemma LTS_is_reachable_product :
   "LTS_is_reachable (LTS_product \<Delta>1 \<Delta>2) pq w pq' \<longleftrightarrow>
    (LTS_is_reachable \<Delta>1 (fst pq) w (fst pq') \<and>
     LTS_is_reachable \<Delta>2 (snd pq) w (snd pq'))"
  apply (induct w arbitrary: pq)
  apply (auto)
  by blast



end








