(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0]?[1-9]|[1-2][0-3])(:)([0-5][0-9]))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))))
; ^([EV])?\d{3,3}(\.\d{1,2})?(, *([EV])?\d{3,3}(\.\d{1,2})?)*$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "E") (str.to_re "V"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.* (re.++ (str.to_re ",") (re.* (str.to_re " ")) (re.opt (re.union (str.to_re "E") (str.to_re "V"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))))) (str.to_re "\u{0a}"))))
(check-sat)
