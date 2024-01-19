(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0-9])|([0-1][0-9])|([2][0-3])):?([0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.range "0" "9") (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.opt (str.to_re ":")) (str.to_re "\u{0a}") (re.range "0" "5") (re.range "0" "9"))))
; ^(\$\ |\$)?((0|00|[1-9]\d*|([1-9]\d{0,2}(\,\d{3})*))(\.\d{1,4})?|(\.\d{1,4}))$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$ ")) (re.union (re.++ (re.union (str.to_re "0") (str.to_re "00") (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 4) (re.range "0" "9"))))) (re.++ (str.to_re ".") ((_ re.loop 1 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; [A-Za-z]{2}[0-9]{1,6}|[0-9]{1,8}
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ ((_ re.loop 1 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
