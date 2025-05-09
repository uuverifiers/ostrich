
(declare-const w Int)

(assert (= w (str.to.int "42")))
(check-sat)
