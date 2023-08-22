(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/\d{2,4}\.xap$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re ".xap/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
