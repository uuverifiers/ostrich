(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^100$|^0$|^[1-9]{0,1}[0-9]{0,1}$|^[1-9]{0,1}[0-9]{0,1}\.[0-9]{1,3}$
(assert (not (str.in_re X (re.union (str.to_re "100") (str.to_re "0") (re.++ (re.opt (re.range "1" "9")) (re.opt (re.range "0" "9"))) (re.++ (re.opt (re.range "1" "9")) (re.opt (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
