(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\.iggsey\.com\sX-Mailer\u{3a}[^\n\r]*on\x3Acom\x3E2\x2E41Client
(assert (not (str.in_re X (re.++ (str.to_re "www.iggsey.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "X-Mailer:\u{13}") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "on:com>2.41Client\u{0a}")))))
; ^[0-9]{2}
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; My\x2Fdesktop\x2FWinSessionHost\u{3a}OnlineTPSystem\x7D\x7C
(assert (not (str.in_re X (str.to_re "My/desktop/WinSessionHost:OnlineTPSystem}|\u{0a}"))))
(check-sat)
