(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\d+\.compress.*sidebar\.activeshopper\.com
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re ".compress") (re.* re.allchar) (str.to_re "sidebar.activeshopper.com\u{0a}"))))
; /z\d{1,3}/Pi
(assert (not (str.in_re X (re.++ (str.to_re "/z") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "/Pi\u{0a}")))))
; /filename\=[a-z0-9]{24}\.jar/H
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 24 24) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".jar/H\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
