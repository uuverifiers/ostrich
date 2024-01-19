(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3})$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
; User-Agent\x3A[^\n\r]*HTTP_RAT_
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "HTTP_RAT_\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
