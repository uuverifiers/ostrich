(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Test\d+TencentTravelerWebConnLibHost\x3Awww\x2Ee-finder\x2Ecc
(assert (not (str.in_re X (re.++ (str.to_re "Test") (re.+ (re.range "0" "9")) (str.to_re "TencentTravelerWebConnLibHost:www.e-finder.cc\u{0a}")))))
; ^[a-zA-Z0-9._%-]+@[a-zA-Z0-9._%-]+\.[a-zA-Z]{2,4}\s*$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "%") (str.to_re "-"))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "%") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
