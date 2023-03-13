(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\x3F[0-9a-z]{32}D/U
(assert (str.in_re X (re.++ (str.to_re "/?") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "D/U\u{0a}"))))
(check-sat)
