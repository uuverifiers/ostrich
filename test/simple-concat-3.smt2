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

(declare-fun x0 () String)
(declare-fun x1 () String)
(declare-fun x2 () String)
(declare-fun x3 () String)
(declare-fun x4 () String)
(declare-fun s0 () String) ; source variable

(assert (str.in.re x0 (re.+ (re.range "a" "z"))))
(assert (toUpper x0 x1))
(assert (= x3 (str.++ x1 x2)))
(assert (str.in.re x3 (re.+ (re.range "a" "z"))))

(check-sat)
