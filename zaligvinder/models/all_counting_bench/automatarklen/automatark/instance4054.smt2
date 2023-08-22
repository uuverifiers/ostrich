(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([+]|00)39)?((3[1-6][0-9]))(\d{7})$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "+") (str.to_re "00")) (str.to_re "39"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}3") (re.range "1" "6") (re.range "0" "9"))))
(assert (> (str.len X) 10))
(check-sat)
