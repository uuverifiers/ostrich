(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^-?[0-9]{0,2}(\.[0-9]{1,2})?$|^-?(100)(\.[0]{1,2})?$
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "-")) ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (re.opt (str.to_re "-")) (str.to_re "100") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (str.to_re "0")))) (str.to_re "\u{0a}"))))))
(check-sat)
