
(declare-const w String)

(assert (= w (int.to.str 42)))
(assert (str.in_re w (re.* (re.range "2" "4"))))
(check-sat)
