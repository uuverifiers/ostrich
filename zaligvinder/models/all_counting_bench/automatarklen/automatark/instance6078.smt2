(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]\:\\.*|^\\\\.*
(assert (not (str.in_re X (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":\u{5c}") (re.* re.allchar)) (re.++ (str.to_re "\u{5c}\u{5c}") (re.* re.allchar) (str.to_re "\u{0a}"))))))
; ^[A-Z].*$
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (re.* re.allchar) (str.to_re "\u{0a}")))))
; ShadowNet\s+AID\x2FUser-Agent\x3AFen\u{ea}treEye\x2Fdss\x2Fcc\.2_0_0\.
(assert (str.in_re X (re.++ (str.to_re "ShadowNet") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "AID/User-Agent:Fen\u{ea}treEye/dss/cc.2_0_0.\u{0a}"))))
; ^(([0-9]{3})[-]?)*[0-9]{6,7}$
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")))) ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
