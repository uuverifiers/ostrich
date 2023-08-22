(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[a-z0-9]{32}\/[a-z0-9]{32}\.jnlp/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".jnlp/U\u{0a}")))))
; /\u{25}3D$/Im
(assert (str.in_re X (str.to_re "/%3D/Im\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
