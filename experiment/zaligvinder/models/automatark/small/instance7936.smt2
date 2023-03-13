(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{2}(\u{2e})(\d{3})(-\d{3})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
