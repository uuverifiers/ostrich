(*  Title:       Labelled Transition Systems
    Authors:     Thomas Tuerk <tuerk@in.tum.de>
*)

 (* Labeled transition systems implementation *)

theory LTS_Impl
imports Main "../LTS_set" "LTSSpec" "Collections.Collections"
        "../../General/Accessible"
begin

subsubsection \<open> Reachability \<close>


fun (in StdCommonLTS) is_reachable_impl where
   "is_reachable_impl l q [] Q = Q q"
 | "is_reachable_impl l q (\<sigma> # w) Q = 
      (succ_bex sat l (\<lambda>q''. is_reachable_impl l q'' w Q) q \<sigma>)"



end


