(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /php\?jnlp\=[a-f0-9]{10}($|\u{2c})/U
(assert (str.in_re X (re.++ (str.to_re "/php?jnlp=") ((_ re.loop 10 10) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ",/U\u{0a}"))))
(check-sat)
