(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((IT|LV)-?)?[0-9]{11}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "IT") (str.to_re "LV")) (re.opt (str.to_re "-")))) ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
