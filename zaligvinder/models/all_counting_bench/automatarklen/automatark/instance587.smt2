(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ok\*\-\*PasswordAgent\x3Cchat\x3E
(assert (str.in_re X (str.to_re "ok*-*PasswordAgent<chat>\u{1b}\u{0a}")))
; ('{2})*([^'\r\n]*)('{2})*([^'\r\n]*)('{2})*
(assert (not (str.in_re X (re.++ (re.* ((_ re.loop 2 2) (str.to_re "'"))) (re.* (re.union (str.to_re "'") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.* ((_ re.loop 2 2) (str.to_re "'"))) (re.* (re.union (str.to_re "'") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.* ((_ re.loop 2 2) (str.to_re "'"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
