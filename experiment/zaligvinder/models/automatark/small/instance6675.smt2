(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; config\x2E180solutions\x2Ecom\dStable\s+Host\u{3a}\x7D\x7C
(assert (not (str.in_re X (re.++ (str.to_re "config.180solutions.com") (re.range "0" "9") (str.to_re "Stable") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:}|\u{0a}")))))
; ^\$?(\d{1,3},?(\d{3},?)*\d{3}(\.\d{0,2})?|\d{1,3}(\.\d{0,2})?|\.\d{1,2}?)$
(assert (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re ",")) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^(010|011|012)[0-9]{7}$
(assert (str.in_re X (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}01") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))))
(check-sat)
