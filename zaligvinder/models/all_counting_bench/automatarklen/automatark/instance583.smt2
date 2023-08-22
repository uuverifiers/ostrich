(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; StarLoggerCookie\u{3a}Host\x3APRODUCEDwebsearch\.getmirar\.com
(assert (not (str.in_re X (str.to_re "StarLoggerCookie:Host:PRODUCEDwebsearch.getmirar.com\u{0a}"))))
; about\d+yxegtd\u{2f}efcwgHost\x3ATPSystemwww\x2Ee-finder\x2Ecc
(assert (str.in_re X (re.++ (str.to_re "about") (re.+ (re.range "0" "9")) (str.to_re "yxegtd/efcwgHost:TPSystemwww.e-finder.cc\u{0a}"))))
; ^(http|https|ftp|ftps)\://([a-zA-Z0-9\-]+)(\.[a-zA-Z0-9\-]+)*(\.[a-zA-Z]{2,3})(:[0-9]*)?(/[a-zA-Z0-9_\-]*)*(\.?[a-zA-Z0-9#]{1,10})?([\?][a-zA-Z0-9\-\._\,\'\+&%\$#\=~]*)?$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "http") (str.to_re "https") (str.to_re "ftp") (str.to_re "ftps")) (str.to_re "://") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))))) (re.opt (re.++ (str.to_re ":") (re.* (re.range "0" "9")))) (re.* (re.++ (str.to_re "/") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))))) (re.opt (re.++ (re.opt (str.to_re ".")) ((_ re.loop 1 10) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "#"))))) (re.opt (re.++ (str.to_re "?") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re ",") (str.to_re "'") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "=") (str.to_re "~"))))) (str.to_re "\u{0a}.") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z")))))))
(assert (> (str.len X) 10))
(check-sat)
