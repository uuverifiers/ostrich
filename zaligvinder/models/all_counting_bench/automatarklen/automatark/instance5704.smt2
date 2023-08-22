(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d{2}[.]{1}\d{2}[.]{1}[0-9A-Za-z]{1}
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 1) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
