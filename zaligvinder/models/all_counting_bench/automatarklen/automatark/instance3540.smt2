(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[A-Z]{3}[G|A|F|C|T|H|P]{1}[A-Z]{1}\d{4}[A-Z]{1}$/;
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 3 3) (re.range "A" "Z")) ((_ re.loop 1 1) (re.union (str.to_re "G") (str.to_re "|") (str.to_re "A") (str.to_re "F") (str.to_re "C") (str.to_re "T") (str.to_re "H") (str.to_re "P"))) ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z")) (str.to_re "/;\u{0a}")))))
; ^(((0|((\+)?91(\-)?))|((\((\+)?91\)(\-)?)))?[7-9]\d{9})?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (re.union (re.++ (str.to_re "(") (re.opt (str.to_re "+")) (str.to_re "91)") (re.opt (str.to_re "-"))) (str.to_re "0") (re.++ (re.opt (str.to_re "+")) (str.to_re "91") (re.opt (str.to_re "-"))))) (re.range "7" "9") ((_ re.loop 9 9) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Host\x3A\dKeylogger.*Onetrustyfiles\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "Keylogger") (re.* re.allchar) (str.to_re "Onetrustyfiles.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
