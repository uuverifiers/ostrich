(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^5[1-5][0-9]{14}$
(assert (not (str.in_re X (re.++ (str.to_re "5") (re.range "1" "5") ((_ re.loop 14 14) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^(http\://){1}(((www\.){1}([a-zA-Z0-9\-]*\.){1,}){1}|([a-zA-Z0-9\-]*\.){1,10}){1}([a-zA-Z]{2,6}\.){1}([a-zA-Z0-9\-\._\?\,\'/\\\+&%\$#\=~])*
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "http://")) ((_ re.loop 1 1) (re.union ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) (str.to_re "www.")) (re.+ (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "."))))) ((_ re.loop 1 10) (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "."))))) ((_ re.loop 1 1) (re.++ ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "."))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "?") (str.to_re ",") (str.to_re "'") (str.to_re "/") (str.to_re "\u{5c}") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "=") (str.to_re "~"))) (str.to_re "\u{0a}")))))
; \\red([01]?\d\d?|2[0-4]\d|25[0-5])\\green([01]?\d\d?|2[0-4]\d|25[0-5])\\blue([01]?\d\d?|2[0-4]\d|25[0-5]);
(assert (str.in_re X (re.++ (str.to_re "\u{5c}red") (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re "\u{5c}green") (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re "\u{5c}blue") (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re ";\u{0a}"))))
; ^01[0-2]\d{8}$
(assert (str.in_re X (re.++ (str.to_re "01") (re.range "0" "2") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^\d{2,6}-\d{2}-\d$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}")))))
(check-sat)
