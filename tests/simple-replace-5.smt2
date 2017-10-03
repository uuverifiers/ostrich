(set-logic QF_S)

(declare-fun x_7 () String)
(declare-fun x_10 () String)

(assert (= x_10 "This is a very long sentence with <code>code</code>"))
(assert (= x_7 (str.replaceall x_10 "<code>" "")))

(check-sat)
(get-model)

