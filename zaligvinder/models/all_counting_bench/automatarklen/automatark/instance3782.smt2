(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (CREATE|ALTER) +(PROCEDURE|PROC|FUNCTION|VIEW) *(\[(.*)\]|(.*))
(assert (not (str.in_re X (re.++ (re.union (str.to_re "CREATE") (str.to_re "ALTER")) (re.+ (str.to_re " ")) (re.union (str.to_re "PROCEDURE") (str.to_re "PROC") (str.to_re "FUNCTION") (str.to_re "VIEW")) (re.* (str.to_re " ")) (re.union (re.++ (str.to_re "[") (re.* re.allchar) (str.to_re "]")) (re.* re.allchar)) (str.to_re "\u{0a}")))))
; ^(GIR|[A-Z]\d[A-Z\d]??|[A-Z]{2}\d[A-Z\d]??)[ ]??(\d[A-Z]{2})$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "GIR") (re.++ (re.range "A" "Z") (re.range "0" "9") (re.opt (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.range "0" "9") (re.opt (re.union (re.range "A" "Z") (re.range "0" "9"))))) (re.opt (str.to_re " ")) (str.to_re "\u{0a}") (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z"))))))
(assert (> (str.len X) 10))
(check-sat)
