(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(-?\$?([1-9]\d{0,2}(,\d{3})*|[1-9]\d*|0|)(.\d{1,2})?|\(\$?([1-9]\d{0,2}(,\d{3})*|[1-9]\d*|0|)(.\d{1,2})?\))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "-")) (re.opt (str.to_re "$")) (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (str.to_re "0")) (re.opt (re.++ re.allchar ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (str.to_re "(") (re.opt (str.to_re "$")) (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (str.to_re "0")) (re.opt (re.++ re.allchar ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re ")"))) (str.to_re "\u{0a}")))))
(check-sat)
