(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]{0,1})([0-9]{1})(\.[0-9])?$
(assert (str.in_re X (re.++ (re.opt (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
