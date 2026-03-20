(set-logic QF_S)
(set-option :parse-transducers true)

(define-fun-rec Lose ((x String) (y String)) Bool
  (or
    (and (= x "") (= y ""))
    (and
      (not (= x ""))
      (Lose (str.tail x) y)
    )
    (and
      (not (= x ""))
      (not (= y ""))
      (= (str.head x) (str.head y))
      (Lose (str.tail x) (str.tail y))
    )
  )
)

(declare-fun x () String)
(declare-fun y () String)

(assert (= x "abc"))
(assert (Lose x y))

(check-sat)
