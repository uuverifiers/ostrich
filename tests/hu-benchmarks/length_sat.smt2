; sat
(declare-fun x ()String)

(declare-const len_x Int)

(assert (= len_x (str.len x)))
(assert (< 1 len_x))


(check-sat)
(get-model)