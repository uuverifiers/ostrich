(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z0-9]{5})$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
