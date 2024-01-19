(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\+?972(\-)?0?[23489]{1}(\-)?[^0\D]{1}\d{6}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "+")) (str.to_re "972") (re.opt (str.to_re "-")) (re.opt (str.to_re "0")) ((_ re.loop 1 1) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "8") (str.to_re "9"))) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.comp (re.range "0" "9")))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
