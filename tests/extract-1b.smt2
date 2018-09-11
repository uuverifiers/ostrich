(set-logic QF_S)

; transducer extracting the string in between the 0th and 1st '='

(set-option :parse-transducers true)

(define-funs-rec ((extract1st ((x String) (y String)) Bool)
                  (extract1st_2 ((x String) (y String)) Bool)
                  (extract1st_3 ((x String) (y String)) Bool)) (

    ; extract1st
    (or (and (= x "") (= y ""))
        (and (not (= x ""))
             (not (= (str.head x) (char.from-int 61)))  ; not '='
             (extract1st (str.tail x) y))
        (and (not (= x ""))
             (= (str.head x) (char.from-int 61))        ; '='
             (extract1st_2 (str.tail x) y)))

    ; extract1st_2
    (or (and (= x "") (= y ""))
        (and (not (= x "")) (not (= y ""))
             (= (str.head x) (str.head y))
             (not (= (str.head x) (char.from-int 61)))  ; not '='
             (extract1st_2 (str.tail x) (str.tail y)))
        (and (not (= x ""))
             (= (str.head x) (char.from-int 61))        ; '='
             (extract1st_3 (str.tail x) y)))

    ; extract1st_3
    (or (and (= x "") (= y ""))
        (and (not (= x ""))
             (extract1st_3 (str.tail x) y)))

))

(declare-fun x0 () String)
(declare-fun x1 () String)
(declare-fun x2 () String)
(declare-fun x3 () String)
(declare-fun x4 () String)
(declare-fun s0 () String) ; source variable

(assert (str.in.re s0 (re.* (re.charrange (char.from-int 120) (char.from-int 122)))))
(assert (str.in.re x0 (re.* (re.union (re.charrange (char.from-int 120) (char.from-int 122)) (str.to.re "=")))))

(assert (extract1st x0 x1))
(assert (= x2 (str.++ x1 s0)))

(assert (not (str.in.re x2 (re.* (re.charrange (char.from-int 120) (char.from-int 122))))))

(check-sat)

