(declare-const x String)
(declare-const y String)
(declare-const z String)

(assert (str.in.re x (re.* (str.to.re "ab"))))
(assert (str.in.re y (re.* (str.to.re "c"))))
(assert (str.in.re z (str.to.re "cccc")))
(assert (= z (str.replaceallre x (str.to.re "ab") y)))

(check-sat)
