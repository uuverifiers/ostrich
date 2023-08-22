(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; TOOLBAR\s+dist\x2Eatlas\x2Dia\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "TOOLBAR") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "dist.atlas-ia.com\u{0a}")))))
; /[0-9A-Z]{8}\u{3a}bpass\u{0a}/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "Z"))) (str.to_re ":bpass\u{0a}/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
