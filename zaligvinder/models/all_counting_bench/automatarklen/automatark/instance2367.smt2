(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{5}$|^\d{5}-\d{4}$
(assert (not (str.in_re X (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
