(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}b\u{2f}shoe\u{2f}[0-9]{3,5}$/U
(assert (str.in_re X (re.++ (str.to_re "//b/shoe/") ((_ re.loop 3 5) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
; /^\/\d{8,11}\/1[34]\d{8}\.pdf$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 8 11) (re.range "0" "9")) (str.to_re "/1") (re.union (str.to_re "3") (str.to_re "4")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re ".pdf/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
