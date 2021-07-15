(set-logic QF_S)

(declare-const x String)

(assert (not (and
   (= (str.at "012" (- 1)) "")
   (= (str.at "012" 0) "0")

   (= (str.at "012" (- (str.len "012") 1)) "2")
   (= (str.at "012" (- (str.len "012") 2)) "1")
   (= (str.at "012" (- (str.len "012") 0)) "")
   (distinct (str.at "000" (- (str.len "000") 5)) "0")
)))

(check-sat)
