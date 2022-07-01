
(declare-const w Int)

(assert (= "0" (str.from_int w)))

(check-sat)
