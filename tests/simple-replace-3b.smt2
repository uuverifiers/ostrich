(set-logic QF_S)

(declare-const a String)
(declare-const b String)
(declare-fun x_7 () String)
(declare-fun x_10 () String)

(assert (= x_7 (str.replace x_10 "e" "X")))
(assert (str.in.re x_7 (re.++ re-full-set
                              (str.to.re "e")
                              re-full-set)))

(check-sat)
(get-model)

