(set-logic QF_S)

(declare-const a String)
(declare-const b String)
(declare-fun x_7 () String)
(declare-fun x_10 () String)

(assert (= x_10 (str.++ a b)))
(assert (or (= x_7 (str.replace x_10 "e" "a"))
            (= x_7 (str.replaceall x_10 "e" "a"))))
(assert (str.in.re x_10 (str.to.re "Hello")))
(assert (str.in.re x_7 (str.to.re  "Hollo")))

(check-sat)
(get-model)
