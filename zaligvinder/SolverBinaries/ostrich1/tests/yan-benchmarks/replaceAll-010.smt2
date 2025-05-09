(declare-const x String)
(declare-const y String)
(declare-const z String)
(declare-const w String)
(declare-const v String)

(assert (= x (str.replace_re_longest_all y (str.to.re "a") z)))
(assert (= y (str.replace_re_longest_all w (str.to.re "1") v)))

(assert (str.in.re y (re.++ (re.* (str.to.re "a")) (re.* (str.to.re "b")))))
(assert (str.in.re z (str.to.re "1")))
(assert (str.in.re x (re.++ (str.to.re "1111") (re.* (str.to.re "1")))))
(assert (str.in.re w (re.++ (str.to.re "1") (re.* (str.to.re "11")))))

(check-sat)
