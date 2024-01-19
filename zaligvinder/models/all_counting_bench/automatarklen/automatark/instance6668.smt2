(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9]*|\d*\.\d{1}?\d*)$
(assert (str.in_re X (re.++ (re.union (re.* (re.range "0" "9")) (re.++ (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")) (re.* (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
