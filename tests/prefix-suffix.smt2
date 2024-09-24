(set-logic QF_S)

; UNSAT

(declare-fun a () String)
(declare-fun b () String)

(assert (not (=> (and (str.prefixof a b) (str.suffixof b a)) (= a b))))

(check-sat)
