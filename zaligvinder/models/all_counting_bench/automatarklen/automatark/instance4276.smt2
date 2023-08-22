(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-z]{2}\d{9}[Gg][Bb])|(\d{12})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "z")) ((_ re.loop 9 9) (re.range "0" "9")) (re.union (str.to_re "G") (str.to_re "g")) (re.union (str.to_re "B") (str.to_re "b"))) (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
