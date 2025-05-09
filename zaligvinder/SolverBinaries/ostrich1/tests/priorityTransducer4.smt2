(set-logic QF_S)

; Transducer extracting the captured string for the regex ([ab]*)b[ab]*

(set-option :parse-transducers true)

(define-funs-rec ((extr ((x String) (y String)) Bool)
                  (extr1 ((x String) (y String)) Bool)
                  (extr2 ((x String) (y String)) Bool)
                  (extr3 ((x String) (y String)) Bool)) (

        ; lazy matching: extract the shortest match
         (or (extr2 x y)
             (and (not (exists ((z String)) (extr2 x z)))
                  (extr1 x y)))

        ; definition of extr1: capture
           (and (not (= x "")) (not (= y ""))
                (>= (str.head_code x) (str.to_code "a")) ; [ab]
                (<= (str.head_code x) (str.to_code "b"))
                (= (str.head y) (str.head x)) ; 'a'
                (extr (str.tail x) (str.tail y)))

        ; definition of extr2: do not capture
           (and (not (= x ""))
                (= (str.head_code x) (str.to_code "b"))
                (extr3 (str.tail x) y))

        ; definition of extr3: do not capture
        (or (and (= x "") (= y ""))
            (and (not (= x ""))
                 (>= (str.head_code x) (str.to_code "a")) ; [ab]
                 (<= (str.head_code x) (str.to_code "b"))
                 (extr3 (str.tail x) y))
         )))

(declare-const x String)
(declare-const y String)

(assert (extr x y))
(assert (str.in.re x (re.++ (re.+ (re.range "a" "b")) (str.to.re "babababa"))))
(assert (str.in.re y (re.+ (re.range "a" "b"))))
(assert (str.contains y "b"))     ; makes it unsat

(check-sat)
