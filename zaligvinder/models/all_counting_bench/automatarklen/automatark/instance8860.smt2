(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^http\://www.[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}/$
(assert (str.in_re X (re.++ (str.to_re "http://www") re.allchar (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
