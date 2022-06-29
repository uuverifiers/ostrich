
(declare-const w Int)

(assert (= "123" (str.from_int w)))

(check-sat)
