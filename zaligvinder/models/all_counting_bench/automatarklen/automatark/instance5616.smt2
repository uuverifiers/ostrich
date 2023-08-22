(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; from\s+\x2Fdss\x2Fcc\.2_0_0\.[^\n\r]*uploadServer
(assert (not (str.in_re X (re.++ (str.to_re "from") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/dss/cc.2_0_0.") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "uploadServer\u{0a}")))))
; ^([A-Z]{2}?(\d{7}))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 7 7) (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
