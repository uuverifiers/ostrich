(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^<!--\s+[\w]{52,}\s+-->\r\n/smi
(assert (str.in_re X (re.++ (str.to_re "/<!--") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "-->\u{0d}\u{0a}/smi\u{0a}") ((_ re.loop 52 52) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))
(assert (> (str.len X) 10))
(check-sat)
