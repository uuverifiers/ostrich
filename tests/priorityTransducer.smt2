(set-logic QF_S)

; Transducer extracting the captured string for the regex (a*)a*

(set-option :parse-transducers true)

(define-funs-rec ((extr ((x String) (y String)) Bool)
                  (extr1 ((x String) (y String)) Bool)
                  (extr2 ((x String) (y String)) Bool)) (

        ; definition of extr: choose whether to leave the capture group or not
         (or (extr1 x y)
             (and (not (exists ((z String)) (extr1 x z)))
                  (extr2 x y)))

        ; definition of extr1: capture
           (and (not (= x "")) (not (= y ""))
                          (= (str.head x) (char.from-int 97)) ; 'a'
                          (= (str.head y) (char.from-int 97)) ; 'a'
                          (extr (str.tail x) (str.tail y)))

        ; definition of extr2: do not capture
        (or
             (and (= x "") (= y ""))
             (and (not (= x ""))
                          (= (str.head x) (char.from-int 97)) ; 'a'
                          (extr2 (str.tail x) y))
         )))

(declare-const x String)
(declare-const y String)

(assert (extr x y))
(assert (str.in.re x ((_ re.^ 7) (str.to.re "a"))))
(assert (str.in.re y ((_ re.^ 5) (str.to.re "a"))))

(check-sat)
