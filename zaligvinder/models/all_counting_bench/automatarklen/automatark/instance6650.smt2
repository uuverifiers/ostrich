(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^fastddos\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (str.in_re X (re.++ (str.to_re "/fastddos|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}"))))
; ^(27|0)[0-9]{9}
(assert (str.in_re X (re.++ (re.union (str.to_re "27") (str.to_re "0")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; PALTALKSubject\x3A\x7D\x7BUser\x3A
(assert (str.in_re X (str.to_re "PALTALKSubject:}{User:\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
