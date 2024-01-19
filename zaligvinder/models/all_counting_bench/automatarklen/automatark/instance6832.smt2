(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{2}-\d{2})*$
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
