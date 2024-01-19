(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; from\s+\x2Fdss\x2Fcc\.2_0_0\.[^\n\r]*uploadServer
(assert (str.in_re X (re.++ (str.to_re "from") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/dss/cc.2_0_0.") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "uploadServer\u{0a}"))))
; /gate\u{2e}php\u{3f}reg=[a-zA-Z]{15}/U
(assert (str.in_re X (re.++ (str.to_re "/gate.php?reg=") ((_ re.loop 15 15) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
