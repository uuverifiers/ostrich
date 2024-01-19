(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\(0?[1-9][0-9]\))|(0?[1-9][0-9]))[ -.]?([1-9][0-9]{3})[ -.]?([0-9]{4})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "(") (re.opt (str.to_re "0")) (re.range "1" "9") (re.range "0" "9") (str.to_re ")")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9") (re.range "0" "9"))) (re.opt (re.range " " ".")) (re.opt (re.range " " ".")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}") (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
