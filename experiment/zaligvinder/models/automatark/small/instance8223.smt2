(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/i\.html\?[a-z0-9]+\=[a-zA-Z0-9]{25}/U
(assert (not (str.in_re X (re.++ (str.to_re "//i.html?") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 25 25) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; Ready\s+Eye.*http\x3A\x2F\x2Fsupremetoolbar
(assert (str.in_re X (re.++ (str.to_re "Ready") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Eye") (re.* re.allchar) (str.to_re "http://supremetoolbar\u{0a}"))))
(check-sat)
