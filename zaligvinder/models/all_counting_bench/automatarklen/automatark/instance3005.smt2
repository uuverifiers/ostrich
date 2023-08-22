(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ProtoSubject\u{3a}source\=IncrediFindProjectAgentHost\x3AHost\x3AHost\x3A
(assert (not (str.in_re X (str.to_re "ProtoSubject:source=IncrediFindProjectAgentHost:Host:Host:\u{0a}"))))
; /^stop\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (str.in_re X (re.++ (str.to_re "/stop|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}"))))
; /\u{2e}rjs([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.rjs") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
