
(declare-const w Int)

(assert (= w (str.to.int "-42")))
(assert (not (= w (- 1))))
(check-sat)
