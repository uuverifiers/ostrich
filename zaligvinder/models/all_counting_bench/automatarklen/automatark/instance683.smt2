(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; StarLoggerCookie\u{3a}Host\x3APRODUCEDwebsearch\.getmirar\.com
(assert (str.in_re X (str.to_re "StarLoggerCookie:Host:PRODUCEDwebsearch.getmirar.com\u{0a}")))
; Ts2\x2F\s+insert.*Host\u{3a}HELOHourssurvey\.asp\?nUserId=
(assert (str.in_re X (re.++ (str.to_re "Ts2/") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "insert") (re.* re.allchar) (str.to_re "Host:HELOHourssurvey.asp?nUserId=\u{0a}"))))
; /\/[a-f0-9]{32}\.jar/
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".jar/\u{0a}"))))
; ^1+0+$
(assert (str.in_re X (re.++ (re.+ (str.to_re "1")) (re.+ (str.to_re "0")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
