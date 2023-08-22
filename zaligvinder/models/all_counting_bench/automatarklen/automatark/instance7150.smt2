(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z]{2}[0-9]{6}[A-DFM]{1}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "D") (str.to_re "F") (str.to_re "M"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
