(set-logic QF_SLIA)

(declare-const w String)
(declare-const lower String)
(declare-const upper String)

(assert (= lower "a"))
(assert (= upper "c"))
(assert (str.in_re w (re.range lower upper)))

(check-sat)
