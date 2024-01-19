;test regex @"^(((\d-)?\d{3}-)?(\d{3}-\d{4})|\d{7}|\d{10})$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "@") (str.to_re "\u{22}")) (re.++ (str.to_re "") (re.union (re.union (re.++ (re.opt (re.++ (re.opt (re.++ (re.range "0" "9") (str.to_re "-"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-")))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))))) ((_ re.loop 7 7) (re.range "0" "9"))) ((_ re.loop 10 10) (re.range "0" "9"))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)