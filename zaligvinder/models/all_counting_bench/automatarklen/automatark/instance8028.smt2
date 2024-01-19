(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Za-z]$
(assert (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (str.to_re "\u{0a}"))))
; ^(\d{3}-\d{3}-\d{4})*$
(assert (not (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
