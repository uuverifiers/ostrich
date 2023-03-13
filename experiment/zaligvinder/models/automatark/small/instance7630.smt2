(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-7]{3})$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "7")) (str.to_re "\u{0a}"))))
(check-sat)
