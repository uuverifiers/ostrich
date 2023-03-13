(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z]{2}|[A-Z]\d|\d[A-Z])[1-9](\d{1,3})?$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (re.range "A" "Z")) (re.++ (re.range "A" "Z") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "A" "Z"))) (re.range "1" "9") (re.opt ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
