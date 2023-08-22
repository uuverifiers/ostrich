(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; IP\d+horoscopefowclxccdxn\u{2f}uxwn\.ddy
(assert (str.in_re X (re.++ (str.to_re "IP") (re.+ (re.range "0" "9")) (str.to_re "horoscopefowclxccdxn/uxwn.ddy\u{0a}"))))
; WindowsFrom\x3A\x2FCU1\-extreme\x2Ebiz
(assert (not (str.in_re X (str.to_re "WindowsFrom:/CU1-extreme.biz\u{0a}"))))
; /^allhttp\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (not (str.in_re X (re.++ (str.to_re "/allhttp|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
