;test regex (0*)([1-9]{0,4}[vr]?)((-s)?+([0]{0,2}))?+([1-9][vr])?
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (str.to_re "0")) (re.++ (re.++ ((_ re.loop 0 4) (re.range "1" "9")) (re.opt (re.union (str.to_re "v") (str.to_re "r")))) (re.++ (re.+ (re.opt (re.++ (re.+ (re.opt (re.++ (str.to_re "-") (str.to_re "s")))) ((_ re.loop 0 2) (str.to_re "0"))))) (re.opt (re.++ (re.range "1" "9") (re.union (str.to_re "v") (str.to_re "r")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)