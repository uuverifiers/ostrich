(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(http\://){1}(((www\.){1}([a-zA-Z0-9\-]*\.){1,}){1}|([a-zA-Z0-9\-]*\.){1,10}){1}([a-zA-Z]{2,6}\.){1}([a-zA-Z0-9\-\._\?\,\'/\\\+&%\$#\=~])*
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "http://")) ((_ re.loop 1 1) (re.union ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) (str.to_re "www.")) (re.+ (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "."))))) ((_ re.loop 1 10) (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "."))))) ((_ re.loop 1 1) (re.++ ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "."))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "?") (str.to_re ",") (str.to_re "'") (str.to_re "/") (str.to_re "\u{5c}") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "=") (str.to_re "~"))) (str.to_re "\u{0a}"))))
; Host\x3AHost\u{3a}fhfksjzsfu\u{2f}ahm\.uqsHost\x3Afowclxccdxn\u{2f}uxwn\.ddy
(assert (not (str.in_re X (str.to_re "Host:Host:fhfksjzsfu/ahm.uqsHost:fowclxccdxn/uxwn.ddy\u{0a}"))))
; Spy\dccecaedbebfcaf\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Spy") (re.range "0" "9") (str.to_re "ccecaedbebfcaf.com\u{0a}"))))
(check-sat)
