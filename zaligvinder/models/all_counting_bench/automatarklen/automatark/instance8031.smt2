(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/\d{9,10}\/1\/1\d{9}\.pdf$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 9 10) (re.range "0" "9")) (str.to_re "/1/1") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re ".pdf/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
