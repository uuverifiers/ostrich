(declare-const w String)

(assert (str.in.re w (re.from.str "abc(?!x)q")))
(assert (str.in.re w (re.* (re.union (str.to.re "a") (str.to.re "b") (str.to.re "c") (str.to.re "q")))))

(check-sat)
