(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{3c}meta\u{20}name\u{3d}\u{22}token\u{22}\u{20}content\u{3d}\u{22}\u{a4}[A-F\d]{168}\u{a4}\u{22}\u{2f}\u{3e}$/
(assert (str.in_re X (re.++ (str.to_re "/<meta name=\u{22}token\u{22} content=\u{22}\u{a4}") ((_ re.loop 168 168) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "\u{a4}\u{22}/>/\u{0a}"))))
(check-sat)
