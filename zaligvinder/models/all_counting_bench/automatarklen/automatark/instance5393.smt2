(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[+-]?\d*(([,.]\d{3})+)?([,.]\d+)?([eE][+-]?\d+)?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.* (re.range "0" "9")) (re.opt (re.+ (re.++ (re.union (str.to_re ",") (str.to_re ".")) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.opt (re.++ (re.union (str.to_re ",") (str.to_re ".")) (re.+ (re.range "0" "9")))) (re.opt (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Host\x3A\dKeylogger.*Onetrustyfiles\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "Keylogger") (re.* re.allchar) (str.to_re "Onetrustyfiles.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
