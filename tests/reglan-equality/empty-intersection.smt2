(set-logic QF_S)
(set-info :status sat)

; The two singleton languages are disjoint.
(assert
  (= re.none
     (re.inter (str.to_re "a") (str.to_re "b"))))

(check-sat)
