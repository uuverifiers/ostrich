(declare-fun x () String)
(declare-fun y1 () String)
(declare-fun y2 () String)


(assert (= x ( str.++ ( str.++ "te" y1 ) ( str.++ "st" y2 ) ) ) )


(check-sat)
