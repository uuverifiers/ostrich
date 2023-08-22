(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/\d{4}\/\d{7}$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
