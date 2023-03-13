(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AInformationwww\x2Ezhongsou\x2EcomLitequick\x2Eqsrch\x2Ecom
(assert (not (str.in_re X (str.to_re "Host:Informationwww.zhongsou.comLitequick.qsrch.com\u{0a}"))))
; ^\w+(([-+']|[-+.]|\w+))*@\w+([-.]\w+)*\.\w+([-.]\w+)*$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "-") (str.to_re "+") (str.to_re "'") (str.to_re "-") (str.to_re "+") (str.to_re "."))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ (re.union (str.to_re "-") (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re ".") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ (re.union (str.to_re "-") (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "\u{0a}")))))
; ^http\://www.[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}/$
(assert (not (str.in_re X (re.++ (str.to_re "http://www") re.allchar (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "/\u{0a}")))))
(check-sat)
