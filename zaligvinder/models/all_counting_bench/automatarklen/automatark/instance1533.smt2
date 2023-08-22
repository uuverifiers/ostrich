(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x0D\x0ACurrent\x2EearthlinkSpyBuddy
(assert (str.in_re X (str.to_re "\u{0d}\u{0a}Current.earthlinkSpyBuddy\u{0a}")))
; /\u{2e}hpj([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.hpj") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /\r\n\r\nsession\u{3a}\d{1,7}$/
(assert (not (str.in_re X (re.++ (str.to_re "/\u{0d}\u{0a}\u{0d}\u{0a}session:") ((_ re.loop 1 7) (re.range "0" "9")) (str.to_re "/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
