;test regex ^\d{5}(-\d{5})?(,\d{5}(-\d{5})?)*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.opt (re.++ (str.to_re "-") ((_ re.loop 5 5) (re.range "0" "9")))) (re.* (re.++ (str.to_re ",") (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (str.to_re "-") ((_ re.loop 5 5) (re.range "0" "9")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)