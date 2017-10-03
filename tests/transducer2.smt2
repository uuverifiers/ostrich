(set-logic QF_S)

; to-uppercase transducer

(define-fun-rec toUpper ((x String) (y String)) Bool
  (or (and (= x "") (= y ""))
      (and (= (seq-head y)
              (ite (and (bvule (_ bv97 8) (seq-head x))   ; 'a'
                        (bvule (seq-head x) (_ bv122 8))) ; 'z'
                   (bvsub (seq-head x) (_ bv32 8))        ; 'a' -> 'A', etc.
                   (seq-head x)))
           (toUpper (seq-tail x) (seq-tail y))))
)

(declare-fun x () String)
(declare-fun y () String)

(assert (= x "Hello World"))
(assert (toUpper x y))
(assert (not (= y "HELLO WORLD")))

(check-sat)
