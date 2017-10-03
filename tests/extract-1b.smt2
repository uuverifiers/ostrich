(set-logic QF_S)

; transducer extracting the string in between the 0th and 1st '='
(define-funs-rec ((extract1st ((x String) (y String)) Bool)
                  (extract1st_2 ((x String) (y String)) Bool)
                  (extract1st_3 ((x String) (y String)) Bool)) (

    ; extract1st
    (or (and (= x "") (= y ""))
        (and (not (= (seq-head x) (_ bv61 8)))  ; not '='
             (extract1st (seq-tail x) y))
        (and (= (seq-head x) (_ bv61 8))        ; '='
             (extract1st_2 (seq-tail x) y)))

    ; extract1st_2
    (or (and (= x "") (= y ""))
        (and (= (seq-head x) (seq-head y))
             (not (= (seq-head x) (_ bv61 8)))  ; not '='
             (extract1st_2 (seq-tail x) (seq-tail y)))
        (and (= (seq-head x) (_ bv61 8))        ; '='
             (extract1st_3 (seq-tail x) y)))

    ; extract1st_3
    (or (and (= x "") (= y ""))
        (extract1st_3 (seq-tail x) y))

))

(declare-fun x0 () String)
(declare-fun x1 () String)
(declare-fun x2 () String)
(declare-fun x3 () String)
(declare-fun x4 () String)
(declare-fun s0 () String) ; source variable

(assert (str.in.re s0 (re.* (re.range "x" "z"))))
(assert (str.in.re x0 (re.* (re.union (re.range "x" "z") (str.to.re "=")))))

(assert (extract1st x0 x1))
(assert (= x2 (str.++ x1 s0)))

(assert (not (str.in.re x2 (re.* (re.range "x" "z")))))

(check-sat)

