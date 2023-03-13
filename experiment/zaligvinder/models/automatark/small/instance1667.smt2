(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\#?[A-Fa-f0-9]{3}([A-Fa-f0-9]{3})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "#")) ((_ re.loop 3 3) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (re.opt ((_ re.loop 3 3) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
