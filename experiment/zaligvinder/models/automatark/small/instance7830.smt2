(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(GB)?([0-9]{9})$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "GB")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
