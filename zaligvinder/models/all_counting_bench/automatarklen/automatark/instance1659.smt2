(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(-|\+)?(((100|((0|[1-9]{1,2})(\.[0-9]+)?)))|(\.[0-9]+))%?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.union (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))) (str.to_re "100") (re.++ (re.union (str.to_re "0") ((_ re.loop 1 2) (re.range "1" "9"))) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))))) (re.opt (str.to_re "%")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
