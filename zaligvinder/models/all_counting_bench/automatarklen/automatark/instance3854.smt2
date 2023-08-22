(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\.{1}
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re ".")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
