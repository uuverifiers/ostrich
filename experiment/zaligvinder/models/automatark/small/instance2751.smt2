(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Validation of Mexican RFC for tax payers (individuals)
(assert (str.in_re X (str.to_re "Validation of Mexican RFC for tax payers individuals\u{0a}")))
; /[a-zA-Z0-9]\/[a-f0-9]{5}\.swf[\u{22}\u{27}]/
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (str.to_re "/") ((_ re.loop 5 5) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".swf") (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "/\u{0a}"))))
; welcome\s+Host\x3A\s+ThistoIpHost\x3Abadurl\x2Egrandstreetinteractive\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "welcome") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ThistoIpHost:badurl.grandstreetinteractive.com\u{0a}"))))
(check-sat)
