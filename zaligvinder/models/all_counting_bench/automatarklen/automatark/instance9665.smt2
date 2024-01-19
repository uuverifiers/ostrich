(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[A-Z]{6}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 6 6) (re.range "A" "Z")) (str.to_re "/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
