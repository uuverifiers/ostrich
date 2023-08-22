(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}b\u{2f}pkg\u{2f}T202[0-9a-z]{10}/U
(assert (str.in_re X (re.++ (str.to_re "//b/pkg/T202") ((_ re.loop 10 10) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
