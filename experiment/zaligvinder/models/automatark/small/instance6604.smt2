(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(102[0-3]|10[0-1]\d|[1-9][0-9]{0,2}|0)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "102") (re.range "0" "3")) (re.++ (str.to_re "10") (re.range "0" "1") (re.range "0" "9")) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))) (str.to_re "0")) (str.to_re "\u{0a}")))))
(check-sat)
