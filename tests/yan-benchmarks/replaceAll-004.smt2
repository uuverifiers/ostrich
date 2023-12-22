(declare-const x String)
(declare-const y String)
(declare-const z String)

(assert (= x (str.replace_re_longest_all y (str.to.re "a") z)))

(assert (str.in.re y (re.++ (re.* (str.to.re "a")) (re.* (str.to.re "b")))))
(assert (str.in.re z (str.to.re "1")))
(assert (str.in.re x (re.++ (str.to.re "1111") (re.* (str.to.re "1")))))

(check-sat)
