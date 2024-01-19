(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/\?[a-f0-9]{32}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//?") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
