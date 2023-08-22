(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; encoder\s%3fsearchresltX-Mailer\x3A
(assert (str.in_re X (re.++ (str.to_re "encoder") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "%3fsearchresltX-Mailer:\u{13}\u{0a}"))))
; /\u{2e}hlp([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.hlp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^(#){1}([a-fA-F0-9]){6}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "#")) ((_ re.loop 6 6) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
