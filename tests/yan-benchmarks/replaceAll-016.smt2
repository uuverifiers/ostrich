(declare-const x String)
(declare-const y String)
(declare-const z String)
(declare-const w String)
(declare-const v String)

(assert (str.in.re x (re.* (str.to.re "ab"))))
(assert (str.in.re y (re.* (str.to.re "c"))))
(assert (str.in.re z (str.to.re "cccc")))
(assert (str.in.re w (re.++ (str.to.re "01") (re.* (str.to.re "01")))))
(assert (str.in.re v (str.to.re "c")))

(assert (= z (str.replaceallre x (str.to.re "abab") y)))
(assert (= y (str.replaceallre w (str.to.re "01") v)))

(check-sat)
