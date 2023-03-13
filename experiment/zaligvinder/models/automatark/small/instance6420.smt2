(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (([2-9]{1})([0-9]{2})([0-9]{3})([0-9]{4}))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9")))))
(check-sat)
