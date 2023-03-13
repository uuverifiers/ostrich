(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\$\ |\$)?((0|00|[1-9]\d*|([1-9]\d{0,2}(\,\d{3})*))(\.\d{1,4})?|(\.\d{1,4}))$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$ ")) (re.union (re.++ (re.union (str.to_re "0") (str.to_re "00") (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 4) (re.range "0" "9"))))) (re.++ (str.to_re ".") ((_ re.loop 1 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^(\d{5}-\d{4}|\d{5})$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
