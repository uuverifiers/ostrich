(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([9]{1})([234789]{1})([0-9]{8})$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "9")) ((_ re.loop 1 1) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
