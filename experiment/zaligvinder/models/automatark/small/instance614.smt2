(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}panda\u{2f}\u{3f}u\u{3d}[a-z0-9]{32}/U
(assert (not (str.in_re X (re.++ (str.to_re "//panda/?u=") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; /filename=[^\n]*\u{2e}fon/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".fon/i\u{0a}"))))
(check-sat)
