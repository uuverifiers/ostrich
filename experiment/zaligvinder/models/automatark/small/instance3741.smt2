(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\w+www.*ToolbartheServer\x3Awww\x2Esearchreslt\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www") (re.* re.allchar) (str.to_re "ToolbartheServer:www.searchreslt.com\u{0a}")))))
; /[^\n -~\r]{4}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (str.to_re "\u{0a}") (re.range " " "~") (str.to_re "\u{0d}"))) (str.to_re "/P\u{0a}")))))
; ^(\d{5}-\d{4}|\d{5})$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
