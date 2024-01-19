(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (CZ-?)?[0-9]{8,10}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "CZ") (re.opt (str.to_re "-")))) ((_ re.loop 8 10) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
