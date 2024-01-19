(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$
(assert (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9") (str.to_re "\u{0a}"))))
; ^(([1-9])|(0[1-9])|(1[0-2]))\/(([0-9])|([0-2][0-9])|(3[0-1]))\/(([0-9][0-9])|([1-2][0,9][0-9][0-9]))$
(assert (not (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.range "0" "9") (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.union (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") (re.union (str.to_re "0") (str.to_re ",") (str.to_re "9")) (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; (\+)?([-\._\(\) ]?[\d]{3,20}[-\._\(\) ]?){2,10}
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "+")) ((_ re.loop 2 10) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "(") (str.to_re ")") (str.to_re " "))) ((_ re.loop 3 20) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "(") (str.to_re ")") (str.to_re " "))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
