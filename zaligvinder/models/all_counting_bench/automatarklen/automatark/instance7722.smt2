(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ('{2})*([^'\r\n]*)('{2})*([^'\r\n]*)('{2})*
(assert (str.in_re X (re.++ (re.* ((_ re.loop 2 2) (str.to_re "'"))) (re.* (re.union (str.to_re "'") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.* ((_ re.loop 2 2) (str.to_re "'"))) (re.* (re.union (str.to_re "'") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.* ((_ re.loop 2 2) (str.to_re "'"))) (str.to_re "\u{0a}"))))
; /\u{2e}fon([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.fon") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
