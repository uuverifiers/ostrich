(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /z\x3D[A-Z0-9%]{700}/i
(assert (not (str.in_re X (re.++ (str.to_re "/z=") ((_ re.loop 700 700) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "%"))) (str.to_re "/i\u{0a}")))))
; ^[a-z\.]*\s?([a-z\-\']+\s)+[a-z\-\']+$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "a" "z") (str.to_re "."))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "'"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.+ (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "'"))) (str.to_re "\u{0a}")))))
; /5FDC81917DE08A41A6AC(E9B8ECA1EE.8|.98ECB1EEA8E)/smi
(assert (not (str.in_re X (re.++ (str.to_re "/5FDC81917DE08A41A6AC") (re.union (re.++ (str.to_re "E9B8ECA1EE") re.allchar (str.to_re "8")) (re.++ re.allchar (str.to_re "98ECB1EEA8E"))) (str.to_re "/smi\u{0a}")))))
; Test\d+TencentTravelerWebConnLibHost\x3Awww\x2Ee-finder\x2Ecc
(assert (str.in_re X (re.++ (str.to_re "Test") (re.+ (re.range "0" "9")) (str.to_re "TencentTravelerWebConnLibHost:www.e-finder.cc\u{0a}"))))
; (Word1|Word2).*?(10|[1-9])
(assert (str.in_re X (re.++ (re.* re.allchar) (re.union (str.to_re "10") (re.range "1" "9")) (str.to_re "\u{0a}Word") (re.union (str.to_re "1") (str.to_re "2")))))
(check-sat)
