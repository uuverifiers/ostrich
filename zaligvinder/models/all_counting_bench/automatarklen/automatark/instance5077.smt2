(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; hirmvtg\u{2f}ggqh\.kqhSurveillanceHost\x3A
(assert (str.in_re X (str.to_re "hirmvtg/ggqh.kqh\u{1b}Surveillance\u{13}Host:\u{0a}")))
; ^[a-zA-Z0-9]+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; www\x2Ewebcruiser\x2Eccgot
(assert (str.in_re X (str.to_re "www.webcruiser.ccgot\u{0a}")))
; ^([a-z0-9]{32})$
(assert (not (str.in_re X (re.++ ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; From\x3A.*Host\x3A\s+Downloadfowclxccdxn\u{2f}uxwn\.ddy
(assert (not (str.in_re X (re.++ (str.to_re "From:") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Downloadfowclxccdxn/uxwn.ddy\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
