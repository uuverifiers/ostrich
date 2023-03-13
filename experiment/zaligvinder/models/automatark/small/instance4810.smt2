(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[0-9a-fA-F]{8}[a-z]{6}.php/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) ((_ re.loop 6 6) (re.range "a" "z")) re.allchar (str.to_re "php/\u{0a}"))))
(check-sat)
