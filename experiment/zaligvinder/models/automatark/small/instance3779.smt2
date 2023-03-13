(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename\=[a-z0-9]{24}\.jar/H
(assert (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 24 24) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".jar/H\u{0a}"))))
(check-sat)
