(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([-]?[0-9]?(\.[0-9]{0,2})?)$|^([-]?([1][0-1])(\.[0-9]{0,2})?)$|^([-]?([1][0-3](\.[0]{0,2})))$
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "-")) (re.opt (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (re.opt (str.to_re "-")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "1") (re.range "0" "1")) (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "-")) (str.to_re "1") (re.range "0" "3") (str.to_re ".") ((_ re.loop 0 2) (str.to_re "0")))))))
(assert (> (str.len X) 10))
(check-sat)
