(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}[^\n\r]*pgwtjgxwthx\u{2f}byb\.xky[^\n\r]*source%3Dultrasearch136%26campaign%3Dsnap
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "pgwtjgxwthx/byb.xky") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "source%3Dultrasearch136%26campaign%3Dsnap\u{0a}")))))
; Host\x3A\x2Fta\x2FNEWS\x2Fyayad\x2Ecom
(assert (not (str.in_re X (str.to_re "Host:/ta/NEWS/yayad.com\u{13}\u{0a}"))))
; CUSTOM\swww\x2Elocators\x2Ecom\d+Seconds\-
(assert (not (str.in_re X (re.++ (str.to_re "CUSTOM") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.locators.com") (re.+ (re.range "0" "9")) (str.to_re "Seconds-\u{0a}")))))
; &
(assert (not (str.in_re X (str.to_re "&\u{0a}"))))
; ^\$([0]|([1-9]\d{1,2})|([1-9]\d{0,1},\d{3,3})|([1-9]\d{2,2},\d{3,3})|([1-9],\d{3,3},\d{3,3}))([.]\d{1,2})?$|^\(\$([0]|([1-9]\d{1,2})|([1-9]\d{0,1},\d{3,3})|([1-9]\d{2,2},\d{3,3})|([1-9],\d{3,3},\d{3,3}))([.]\d{1,2})?\)$|^(\$)?(-)?([0]|([1-9]\d{0,6}))([.]\d{1,2})?$
(assert (str.in_re X (re.union (re.++ (str.to_re "$") (re.union (str.to_re "0") (re.++ (re.range "1" "9") ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.opt (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "9") (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (str.to_re "($") (re.union (str.to_re "0") (re.++ (re.range "1" "9") ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.opt (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "9") (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re ")")) (re.++ (re.opt (str.to_re "$")) (re.opt (str.to_re "-")) (re.union (str.to_re "0") (re.++ (re.range "1" "9") ((_ re.loop 0 6) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
