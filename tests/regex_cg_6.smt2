(declare-const x String)
(declare-const y String)

(assert (= y (str.replace_cg x
                             (re.+? (re.range "a" "a"))
                             (str.to.re "b"))))

(assert (str.in.re y (re.* (re.range "b" "c"))))

(check-sat)
(get-model)
