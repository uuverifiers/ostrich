(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{3d}\u{0a}$/P
(assert (str.in_re X (str.to_re "/=\u{0a}/P\u{0a}")))
; ^[0-9]{2}
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
