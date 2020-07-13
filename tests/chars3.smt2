(set-logic QF_)

(declare-fun Constructed_Argument () String)

(assert (let ((a!1 (to_real (str.indexof Constructed_Argument
                                 (str.++ (seq.unit #x2d) (seq.unit #x2d))
                                 0))))
  (= a!1 (- 1.0))))

(check-sat)
