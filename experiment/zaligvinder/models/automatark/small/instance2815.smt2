(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; StarLoggerCookie\u{3a}Host\x3APRODUCEDwebsearch\.getmirar\.com
(assert (str.in_re X (str.to_re "StarLoggerCookie:Host:PRODUCEDwebsearch.getmirar.com\u{0a}")))
; ^(([0-9])|([0-1][0-9])|([2][0-3])):(([0-9])|([0-5][0-9]))$
(assert (str.in_re X (re.++ (re.union (re.range "0" "9") (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.union (re.range "0" "9") (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; /\)\r\nHost\u{3a}\u{20}[a-z\d\u{2e}\u{2d}]{6,32}\r\nCache\u{2d}Control\u{3a}\u{20}no\u{2d}cache\r\n\r\n$/
(assert (str.in_re X (re.++ (str.to_re "/)\u{0d}\u{0a}Host: ") ((_ re.loop 6 32) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re "\u{0d}\u{0a}Cache-Control: no-cache\u{0d}\u{0a}\u{0d}\u{0a}/\u{0a}"))))
(check-sat)
