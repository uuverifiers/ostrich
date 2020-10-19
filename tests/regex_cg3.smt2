(set-logic QF_S)

(declare-fun x0 () String)

(declare-fun y1 () String)
(declare-fun z1 () String)
(declare-fun x1 () String)

(declare-fun y2 () String)
(declare-fun z2 () String)
(declare-fun x2 () String)

(declare-fun y3 () String)
(declare-fun z3 () String)
(declare-fun x3 () String)

(assert (str.in.re x0 (str.to.re "abc")))
(assert (= y1 (str.replace_cg_all x0 (re.range "c" "c") (str.to.re "0"))))
(assert (= z1 (str.replace_cg_all x0 (re.range "c" "c") (str.to.re "1"))))
(assert (= x1 (str.++ y1 z1)))

(assert (= y2 (str.replace_cg_all x1 (re.range "b" "b") (str.to.re "0"))))
(assert (= z2 (str.replace_cg_all x1 (re.range "b" "b") (str.to.re "1"))))
(assert (= x2 (str.++ y2 z2)))

(assert (= y3 (str.replace_cg_all x2 (re.range "a" "a") (str.to.re "0"))))
(assert (= z3 (str.replace_cg_all x2 (re.range "a" "a") (str.to.re "1"))))
(assert (= x3 (str.++ y3 z3)))

(assert (str.in.re x3 (str.to.re "000001010011100101110111")))

(check-sat)
