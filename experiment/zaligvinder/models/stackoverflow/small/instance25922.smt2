;test regex "[A-Z]{6,6}[A-Z2-9][A-NP-Z0-9]([A-Z0-9]{3,3}){0,1}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 6 6) (re.range "A" "Z")) (re.++ (re.union (re.range "A" "Z") (re.range "2" "9")) (re.++ (re.union (re.range "A" "N") (re.union (re.range "P" "Z") (re.range "0" "9"))) (re.++ ((_ re.loop 0 1) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "0" "9")))) (str.to_re "\u{22}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)