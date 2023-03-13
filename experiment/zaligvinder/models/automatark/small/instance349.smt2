(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d* \d*\/{1}\d*$|^\d*$
(assert (not (str.in_re X (re.union (re.++ (re.* (re.range "0" "9")) (str.to_re " ") (re.* (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re "/")) (re.* (re.range "0" "9"))) (re.++ (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ^[1-9]\d*\.?[0]*$
(assert (str.in_re X (re.++ (re.range "1" "9") (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (str.to_re "0")) (str.to_re "\u{0a}"))))
(check-sat)
