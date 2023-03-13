(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-z0-9]{12}\.txt$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 12 12) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".txt/U\u{0a}"))))
(check-sat)
