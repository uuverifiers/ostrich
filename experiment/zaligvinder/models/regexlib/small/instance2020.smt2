;test regex ^(\+86)(13[0-9]|145|147|15[0-3,5-9]|18[0,2,5-9])(\d{8})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "+") (str.to_re "86")) (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "13") (re.range "0" "9")) (str.to_re "145")) (str.to_re "147")) (re.++ (str.to_re "15") (re.union (re.range "0" "3") (re.union (str.to_re ",") (re.range "5" "9"))))) (re.++ (str.to_re "18") (re.union (str.to_re "0") (re.union (str.to_re ",") (re.union (str.to_re "2") (re.union (str.to_re ",") (re.range "5" "9"))))))) ((_ re.loop 8 8) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)