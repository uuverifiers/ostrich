(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ToolbarUser-Agent\x3Awww\x2Ewebcruiser\x2EccDaemonUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "ToolbarUser-Agent:www.webcruiser.ccDaemonUser-Agent:\u{0a}"))))
; /[a-z]=[a-f0-9]{98}/P
(assert (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (str.to_re "=") ((_ re.loop 98 98) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/P\u{0a}"))))
; xbqyosoe\u{2f}cpvmdll\x3F
(assert (not (str.in_re X (str.to_re "xbqyosoe/cpvmdll?\u{0a}"))))
(check-sat)
