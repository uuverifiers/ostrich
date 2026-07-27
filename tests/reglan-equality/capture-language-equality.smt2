(set-logic QF_S)

(declare-const r1 RegLan)
(declare-const r2 RegLan)

; Both patterns describe {"ab"}, but group 1 captures different strings.
(assert (= r1
  (re.++ ((_ re.capture 1) (str.to_re "a"))
         (str.to_re "b"))))
(assert (= r2
  ((_ re.capture 1) (str.to_re "ab"))))

(assert (= r1 r2))
(assert (distinct
  ((_ str.extract 1) "ab" r1)
  ((_ str.extract 1) "ab" r2)))

(check-sat)
