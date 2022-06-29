
(declare-const w Int)

(assert (= "123a" (str.from_int w)))

(check-sat)
