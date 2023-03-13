(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[a-z]{5}\d=_\d_/C
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 5 5) (re.range "a" "z")) (re.range "0" "9") (str.to_re "=_") (re.range "0" "9") (str.to_re "_/C\u{0a}"))))
(check-sat)
