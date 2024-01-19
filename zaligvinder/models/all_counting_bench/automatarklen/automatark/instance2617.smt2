(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^R(\d){8}
(assert (not (str.in_re X (re.++ (str.to_re "R") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; X-Mailer\u{3a}[^\n\r]*Host\x3A\s+cyber@yahoo\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "X-Mailer:\u{13}") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "cyber@yahoo.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
