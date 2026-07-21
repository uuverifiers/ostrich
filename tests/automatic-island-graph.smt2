(set-logic QF_S)
(set-option :parse-transducers true)
(define-funs-rec (
     (extract0 ((x String) (y String)) Bool)
     (extract0_1 ((x String) (y String)) Bool)
     (extract0_2 ((x String) (y String)) Bool)
     (extract0_drain ((x String) (y String)) Bool)
  )(
    ; extract0
    (or
        (and (= x "") (= y ""))
        (and (not (= x ""))
             (= (str.head x) (char.from-int (str.to_code "p")))
          (extract0_drain (str.tail x) y)
        )
        (and (not (= x "")) (not (= y ""))
             (not (= (str.head x) (char.from-int (str.to_code "p"))))
             (= (str.head_code x) (str.head_code y))
          (extract0_1 (str.tail x) (str.tail y))
        )
    )
    ; extract0_1
    (or
        (and (= x "") (= y ""))
        (and (not (= x ""))
          (extract0_2 (str.tail x) y)
        )
    )
    ; extract0_2
    (or
        (and (= x "") (= y ""))
        (and (not (= x ""))
          (extract0 (str.tail x) y)
        )
    )
    ; extract0_drain
    (or
        (and (= x "") (= y ""))
        (and (not (= x ""))
          (extract0_drain (str.tail x) y)
        )
    )
  )
)

(define-funs-rec (
     (extract1 ((x String) (y String)) Bool)
     (extract1_1 ((x String) (y String)) Bool)
     (extract1_2 ((x String) (y String)) Bool)
     (extract1_drain ((x String) (y String)) Bool)
  )(
    ; extract1
    (or
        (and (= x "") (= y ""))
        (and (not (= x ""))
          (extract1_1 (str.tail x) y)
        )
    )
    ; extract1_1
    (or
        (and (= x "") (= y ""))
        (and (not (= x ""))
             (= (str.head x) (char.from-int (str.to_code "p")))
          (extract1_drain (str.tail x) y)
        )
        (and (not (= x "")) (not (= y ""))
             (not (= (str.head x) (char.from-int (str.to_code "p"))))
             (= (str.head_code x) (str.head_code y))
          (extract1_2 (str.tail x) (str.tail y))
        )
    )
    ; extract1_2
    (or
        (and (= x "") (= y ""))
        (and (not (= x ""))
          (extract1 (str.tail x) y)
        )
    )
    ; extract1_drain
    (or
        (and (= x "") (= y ""))
        (and (not (= x ""))
          (extract1_drain (str.tail x) y)
        )
    )
  )
)

(define-funs-rec (
     (extract2 ((x String) (y String)) Bool)
     (extract2_1 ((x String) (y String)) Bool)
     (extract2_2 ((x String) (y String)) Bool)
     (extract2_drain ((x String) (y String)) Bool)
  )(
    ; extract2
    (or
        (and (= x "") (= y ""))
        (and (not (= x ""))
          (extract2_1 (str.tail x) y)
        )
    )
    ; extract2_1
    (or
        (and (= x "") (= y ""))
        (and (not (= x ""))
          (extract2_2 (str.tail x) y)
        )
    )
    ; extract2_2
    (or
        (and (= x "") (= y ""))
        (and (not (= x ""))
             (= (str.head x) (char.from-int (str.to_code "p")))
          (extract2_drain (str.tail x) y)
        )
        (and (not (= x "")) (not (= y ""))
             (not (= (str.head x) (char.from-int (str.to_code "p"))))
             (= (str.head_code x) (str.head_code y))
          (extract2 (str.tail x) (str.tail y))
        )
    )
    ; extract2_drain
    (or
        (and (= x "") (= y ""))
        (and (not (= x ""))
          (extract2_drain (str.tail x) y)
        )
    )
  )
)

(declare-fun varout () String)
(assert (let ((a!1 (re.* (re.union (re.union (str.to_re "a") (str.to_re "b"))
                           (str.to_re "p")))))
  (str.in_re varout a!1)))
(declare-fun varin () String)
(assert (let ((a!1 (re.* (re.union (re.union (str.to_re "a") (str.to_re "b"))
                           (str.to_re "p")))))
  (str.in_re varin a!1)))
(declare-fun rem () String)
(declare-fun out1a () String)
(declare-fun out2a () String)
(declare-fun rem1 () String)
(declare-fun out1 () String)
(declare-fun out2 () String)
(declare-fun isin () Bool)
(declare-fun isout () Bool)
(assert (let ((a!1 (str.in_re out2a (re.* (re.union (str.to_re "a") (str.to_re "b")))))
      (a!2 (str.in_re out1a (re.* (re.union (str.to_re "a") (str.to_re "b")))))
      (a!3 (str.in_re rem1 (re.* (re.union (str.to_re "a") (str.to_re "b")))))
      (a!4 (str.in_re out2 (re.* (re.union (str.to_re "a") (str.to_re "b")))))
      (a!5 (str.in_re out1 (re.* (re.union (str.to_re "a") (str.to_re "b")))))
      (a!6 (str.in_re rem (re.* (re.union (str.to_re "a") (str.to_re "b")))))
      (a!7 (re.++ (re.* (re.union (str.to_re "a") (str.to_re "b")))
                  (re.* (str.to_re "p")))))
  (or (and (= rem1 (str.++ "a" rem))
           true
           (= out1a (str.++ out1 "a"))
           (= out1a (str.++ "ab" out2a))
           a!1
           a!2
           a!3
           a!4
           a!5
           a!6
           (extract0 varin rem1)
           (extract1 varin out1)
           (extract2 varin out2)
           (str.in_re out2 a!7)
           isin
           (extract0 varout rem)
           (str.in_re rem a!7)
           (extract1 varout out1a)
           (str.in_re out1a a!7)
           (extract2 varout out2a)
           (str.in_re out2a a!7)
           isout))))
(assert (=> isin (str.in_re varin (re.from_automaton "automaton value_124 {
  init q0;
  q0 -> q4 [97,97];
  q0 -> q4 [98,98];
  q0 -> q4 [112,112];
  q4 -> q1 [97,97];
  q4 -> q2 [98,98];
  q4 -> q5 [112,112];
  q5 -> q3 [97,97];
  q5 -> q1 [98,98];
  q5 -> q2 [112,112];
  q3 -> q3 [97,97];
  q3 -> q3 [98,98];
  q3 -> q3 [112,112];
  q2 -> q2 [97,97];
  q2 -> q2 [98,98];
  q2 -> q2 [112,112];
  q1 -> q0 [97,97];
  q1 -> q2 [98,98];
  q1 -> q3 [112,112];
  accepting q0,q4,q5,q2;
}
"))))
(assert (=> isout (str.in_re varout (re.from_automaton "automaton value_125 {
  init q0;
  q0 -> q1 [97,97];
  q0 -> q1 [98,98];
  q0 -> q1 [112,112];
  q1 -> q2 [97,97];
  q1 -> q3 [98,98];
  q1 -> q4 [112,112];
  q4 -> q5 [97,97];
  q4 -> q2 [98,98];
  q4 -> q3 [112,112];
  q5 -> q5 [97,97];
  q5 -> q5 [98,98];
  q5 -> q5 [112,112];
  q3 -> q3 [97,97];
  q3 -> q3 [98,98];
  q3 -> q3 [112,112];
  q2 -> q0 [97,97];
  q2 -> q3 [98,98];
  q2 -> q5 [112,112];
  accepting q5,q2;
}
"))))
(check-sat)
