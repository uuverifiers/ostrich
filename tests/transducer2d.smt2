(set-logic QF_S)

; to-uppercase transducer

(set-option :parse-transducers true)

(define-fun-rec toUpper ((x String) (y String)) Bool
  (or (and (= x "") (= y ""))
      (and (not (= x "")) (not (= y ""))
           (= (char.code (str.head y))
              (ite (and (<= 97 (char.code (str.head x)))   ; 'a'
                        (<= (char.code (str.head x)) 122)) ; 'z'
                   (- (char.code (str.head x)) 32)         ; 'a' -> 'A', etc.
                   (char.code (str.head x))))
           (toUpper (str.tail x) (str.tail y))))
)

(declare-fun x () String)
(declare-fun y () String)

(assert (= x "Hello World"))
(assert (toUpper x y))
; (assert (= y "HELLO WORLD"))

(check-sat)
