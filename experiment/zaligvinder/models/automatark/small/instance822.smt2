(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([6011]{4})([0-9]{12})$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (str.to_re "6") (str.to_re "0") (str.to_re "1"))) ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
