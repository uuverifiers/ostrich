(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AUser-Agent\u{3a}Host\x3APortScaner
(assert (not (str.in_re X (str.to_re "Host:User-Agent:Host:PortScaner\u{0a}"))))
; Toolbar\s+wwwProbnymomspyo\u{2f}zowy
(assert (not (str.in_re X (re.++ (str.to_re "Toolbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "wwwProbnymomspyo/zowy\u{0a}")))))
; ^(([a-zA-Z]{3})?([0-9]{4}))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z")))) ((_ re.loop 4 4) (re.range "0" "9"))))))
(check-sat)
