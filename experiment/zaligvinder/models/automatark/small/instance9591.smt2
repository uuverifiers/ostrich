(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; BysooTBUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "BysooTBUser-Agent:\u{0a}"))))
; /\u{2e}pui([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.pui") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^[0-9]{5}([\s-]{1}[0-9]{4})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)