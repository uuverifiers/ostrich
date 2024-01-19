(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^(\d{2}.\d{3}.\d{3}/\d{4}-\d{2})|(\d{14})$)|(^(\d{3}.\d{3}.\d{3}-\d{2})|(\d{11})$)
(assert (str.in_re X (re.union (re.++ (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 11 11) (re.range "0" "9"))) (str.to_re "\u{0a}")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 14 14) (re.range "0" "9")))))
; ^\d{8,8}$|^[SC]{2,2}\d{6,6}$
(assert (not (str.in_re X (re.union ((_ re.loop 8 8) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "S") (str.to_re "C"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
