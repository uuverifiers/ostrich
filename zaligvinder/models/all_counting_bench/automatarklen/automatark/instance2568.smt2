(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/elections\.php\?([a-z0-9]+\u{3d}\d{1,3}\&){9}[a-z0-9]+\u{3d}\d{1,3}$/U
(assert (str.in_re X (re.++ (str.to_re "//elections.php?") ((_ re.loop 9 9) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "&"))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
; YWRtaW46cGFzc3dvcmQ[^\n\r]*DA[^\n\r]*Host\x3Awww\x2Ee-finder\x2Ecc
(assert (not (str.in_re X (re.++ (str.to_re "YWRtaW46cGFzc3dvcmQ") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "DA") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:www.e-finder.cc\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
