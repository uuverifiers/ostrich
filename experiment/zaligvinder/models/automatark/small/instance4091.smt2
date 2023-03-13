(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-hA-H]{1}[1-8]{1})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (re.range "a" "h") (re.range "A" "H"))) ((_ re.loop 1 1) (re.range "1" "8"))))))
(check-sat)
