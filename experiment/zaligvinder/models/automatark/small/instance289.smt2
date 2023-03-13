(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Supervisor\s+User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Supervisor") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}")))))
; ^([a-z0-9]{32})$
(assert (str.in_re X (re.++ ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
