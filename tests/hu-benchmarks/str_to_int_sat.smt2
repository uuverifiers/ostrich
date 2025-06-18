
(declare-const w Int)
(declare-const x String)

(assert (= w (str.to.int x)))
(assert (str.in_re x (re.+ (str.to_re "4"))))
(check-sat)
(get-model)
