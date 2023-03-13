(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{1,3}\.\d{1,4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^(\d{5}-\d{4}|\d{5})$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
