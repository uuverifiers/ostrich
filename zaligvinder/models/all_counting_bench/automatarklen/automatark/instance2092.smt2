(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z]{3}(\d|[A-Z]){8,12}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) ((_ re.loop 8 12) (re.union (re.range "0" "9") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
