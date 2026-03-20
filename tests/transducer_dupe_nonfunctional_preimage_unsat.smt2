(set-logic QF_S)
(set-option :parse-transducers true)

; Parser-friendly finite-state encoding of a duplicating benchmark on the
; concrete alphabet used below. Each consumed letter is copied once, and may
; also be emitted one extra time by a helper state.
(define-funs-rec ((Dupe ((x String) (y String)) Bool)
                  (DupeA ((x String) (y String)) Bool)
                  (DupeB ((x String) (y String)) Bool)
                  (DupeC ((x String) (y String)) Bool)) (
  (or
    (and (= x "") (= y ""))

    (and
      (not (= x ""))
      (not (= y ""))
      (= (str.head x) (char.from-int 97))
      (= (str.head y) (char.from-int 97))
      (Dupe (str.tail x) (str.tail y))
    )
    (and
      (not (= x ""))
      (not (= y ""))
      (= (str.head x) (char.from-int 98))
      (= (str.head y) (char.from-int 98))
      (Dupe (str.tail x) (str.tail y))
    )
    (and
      (not (= x ""))
      (not (= y ""))
      (= (str.head x) (char.from-int 99))
      (= (str.head y) (char.from-int 99))
      (Dupe (str.tail x) (str.tail y))
    )

    (and
      (not (= x ""))
      (not (= y ""))
      (= (str.head x) (char.from-int 97))
      (= (str.head y) (char.from-int 97))
      (DupeA (str.tail x) (str.tail y))
    )
    (and
      (not (= x ""))
      (not (= y ""))
      (= (str.head x) (char.from-int 98))
      (= (str.head y) (char.from-int 98))
      (DupeB (str.tail x) (str.tail y))
    )
    (and
      (not (= x ""))
      (not (= y ""))
      (= (str.head x) (char.from-int 99))
      (= (str.head y) (char.from-int 99))
      (DupeC (str.tail x) (str.tail y))
    )
  )

  (and
    (not (= y ""))
    (= (str.head y) (char.from-int 97))
    (Dupe x (str.tail y))
  )

  (and
    (not (= y ""))
    (= (str.head y) (char.from-int 98))
    (Dupe x (str.tail y))
  )

  (and
    (not (= y ""))
    (= (str.head y) (char.from-int 99))
    (Dupe x (str.tail y))
  )
))

(declare-fun x () String)
(declare-fun y () String)

(assert (= x "abc"))
(assert (= y "aacb"))
(assert (Dupe x y))

(check-sat)
