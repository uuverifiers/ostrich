
(declare-const w String)

(assert (= (- 1) (str.to.int w)))
(assert (str.in_re w (re.+ (re.range "0" "9"))))

(check-sat)
