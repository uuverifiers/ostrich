(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(192\.168\.[0-9]|[1-9][0-9]|[1-2][0-5][0-5]\.[0-9]|[1-9][0-9]|[1-2][0-5][0-5])$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "192.168.") (re.range "0" "9")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") (re.range "0" "5") (re.range "0" "5") (str.to_re ".") (re.range "0" "9")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") (re.range "0" "5") (re.range "0" "5"))) (str.to_re "\u{0a}")))))
; c\.goclick\.com[^\n\r]*is\s+URLBlaze
(assert (not (str.in_re X (re.++ (str.to_re "c.goclick.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "is") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "URLBlaze\u{0a}")))))
; adserver\.warezclient\.com530Host\x3A
(assert (str.in_re X (str.to_re "adserver.warezclient.com530Host:\u{0a}")))
; ^(\d){2}-(\d){2}-(\d){2}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; [^A-Za-z0-9]
(assert (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
