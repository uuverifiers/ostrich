(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; UI2AgentConnectedDesktopSubject\x3Aixqshv\u{2f}qzccsactualnames\.com
(assert (not (str.in_re X (str.to_re "UI2AgentConnectedDesktopSubject:ixqshv/qzccsactualnames.com\u{0a}"))))
; /\u{28}\u{3f}\u{3d}[^)]{300}/
(assert (str.in_re X (re.++ (str.to_re "/(?=") ((_ re.loop 300 300) (re.comp (str.to_re ")"))) (str.to_re "/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
