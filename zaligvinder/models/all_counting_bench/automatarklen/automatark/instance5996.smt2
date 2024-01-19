(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\w+\u{0d}\u{0a}subject=GhostVoice
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0d}\u{0a}subject=GhostVoice\u{0a}"))))
; Points\d+Host\u{3a}\stoBasicwww\x2Ewebcruiser\x2Ecc
(assert (not (str.in_re X (re.++ (str.to_re "Points") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "toBasicwww.webcruiser.cc\u{0a}")))))
; ^\d{3}-\d{2}-\d{4}$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[-]?\d*(\.\d*)$
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}.") (re.* (re.range "0" "9")))))
; securityOmFkbWluADROARad\x2Emokead\x2Ecom\x3C\x2Fchat\x3E
(assert (str.in_re X (str.to_re "securityOmFkbWluADROARad.mokead.com</chat>\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
