(set-logic QF_S)

; SAT

(declare-fun x0 () String)
(declare-fun x1 () String)

(assert (str.prefixof x0 x1))
(assert (str.in.re x0 (re.* (re.charrange (char.from-int 70) (char.from-int 80)))))
(assert (str.in.re x1 (re.* (re.charrange (char.from-int 80) (char.from-int 90)))))

(assert (not (= (str.len x0) 0)))
(assert (not (= (str.len x1) 0)))

(check-sat)
