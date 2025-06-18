

(declare-const R RegLan)
(declare-const x String)

(assert (= R (re.* (re.range "a" "z"))))
(assert (str.in_re x R))

(check-sat)
