(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^5[1-5][0-9]{14}$
(assert (str.in_re X (re.++ (str.to_re "5") (re.range "1" "5") ((_ re.loop 14 14) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; User-Agent\x3AX-Mailer\u{3a}HWAEHost\x3AHost\x3AHost\u{3a}StableUser-Agent\x3AUser-Agent\x3Awww\u{2e}navisearch\u{2e}net
(assert (not (str.in_re X (str.to_re "User-Agent:X-Mailer:\u{13}HWAEHost:Host:Host:StableUser-Agent:User-Agent:www.navisearch.net\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
