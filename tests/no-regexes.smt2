
    (set-logic QF_S)

    (define-funs-rec ((isempty ((x String) (y String)) Bool)) (
                     ; def isempty
                     (and (= (seq-head x) (_ bv48 8)) ; '0'
                          (= (seq-head y) (_ bv49 8)) ; '1'
                          (isempty (seq-tail x) (seq-tail y)))
                    ))

    (declare-fun x () String)
    (declare-fun y () String)

    (assert (isempty x y))

    (check-sat)

