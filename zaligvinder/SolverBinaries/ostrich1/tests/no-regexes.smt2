
    (set-logic QF_S)

    (set-option :parse-transducers true)

    (define-funs-rec ((isempty ((x String) (y String)) Bool)) (
                     ; def isempty
                     (and (not (= x "")) (not (= y ""))
                          (= (str.head x) (char.from-int 48)) ; '0'
                          (= (str.head y) (char.from-int 49)) ; '1'
                          (isempty (str.tail x) (str.tail y)))
                    ))

    (declare-fun x () String)
    (declare-fun y () String)

    (assert (isempty x y))

    (check-sat)

