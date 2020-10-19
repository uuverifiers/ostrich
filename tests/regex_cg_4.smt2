(set-logic QF_S)

(declare-fun x_7 () String)
(declare-fun x_10 () String)

(assert (= x_7 (str.replace_cg_all "HelloWorld" (re.range "e" "e") (str.to.re "a"))))
(assert (= x_7 "HolloWorld"))

(check-sat)
