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

(define-funs-rec ((simple  ((x String) (y String)) Bool)
                  (state1  ((x String) (y String)) Bool)
                  (state2  ((x String) (y String)) Bool)
                  (state3  ((x String) (y String)) Bool)
                  (state4  ((x String) (y String)) Bool)
                  (state5  ((x String) (y String)) Bool)) (

                  ; definition of simple
                  (and (= (seq-head x) (_ bv104 8)) ; 'h'
                       (= (seq-head y) (_ bv119 8)) ; 'w'
                       (state1 (seq-tail x) (seq-tail y)))

                  ; definition of state1
                  (and (= (seq-head x) (_ bv101 8)) ; 'e'
                       (= (seq-head y) (_ bv111 8)) ; 'o'
                       (state2 (seq-tail x) (seq-tail y)))

                  ; definition of state2
                  (and (= (seq-head x) (_ bv108 8)) ; 'l'
                       (= (seq-head y) (_ bv114 8)) ; 'r'
                       (state3 (seq-tail x) (seq-tail y)))

                  ; definition of state3
                  (and (= (seq-head x) (_ bv108 8)) ; 'l'
                       (= (seq-head y) (_ bv108 8)) ; 'l'
                       (state4 (seq-tail x) (seq-tail y)))

                  ; definition of state4
                  (and (= (seq-head x) (_ bv111 8)) ; 'o'
                       (= (seq-head y) (_ bv100 8)) ; 'd'
                       (state5 (seq-tail x) (seq-tail y)))

                  ; definition of state5
                  (and (= x "") (= y ""))
))

(declare-fun x0 () String)
(declare-fun x1 () String)
(declare-fun x2 () String)
(declare-fun x3 () String)
(declare-fun x4 () String)
(declare-fun s0 () String) ; source variable

; unsat?
(assert (toUpper x2 x3))
(assert (= x0 (str.++ "he" s0 "o")))
(assert (= x2 (str.++ x0 x1)))
(assert (not (str.in.re x4 (re.++ (re.++ (re.+ (re.range "a" "z")) (str.to.re " ")) (re.+ (re.range "A" "Z"))))))
(assert (= x4 (str.++ x2 " " x3)))
(assert (simple x0 x1))

(check-sat)
