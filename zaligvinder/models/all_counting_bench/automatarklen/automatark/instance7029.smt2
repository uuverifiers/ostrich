(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SecureNet.*\x2Fsearchfast\x2F
(assert (str.in_re X (re.++ (str.to_re "SecureNet") (re.* re.allchar) (str.to_re "/searchfast/\u{0a}"))))
; wjpropqmlpohj\u{2f}lo\s+media\x2Edxcdirect\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "wjpropqmlpohj/lo") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "media.dxcdirect.com\u{0a}"))))
; ^(http\://){1}(((www\.){1}([a-zA-Z0-9\-]*\.){1,}){1}|([a-zA-Z0-9\-]*\.){1,10}){1}([a-zA-Z]{2,6}\.){1}([a-zA-Z0-9\-\._\?\,\'/\\\+&%\$#\=~])*
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "http://")) ((_ re.loop 1 1) (re.union ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) (str.to_re "www.")) (re.+ (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "."))))) ((_ re.loop 1 10) (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "."))))) ((_ re.loop 1 1) (re.++ ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "."))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "?") (str.to_re ",") (str.to_re "'") (str.to_re "/") (str.to_re "\u{5c}") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "=") (str.to_re "~"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
