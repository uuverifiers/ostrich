;test regex ([A-Z][A-Z_]+)_YR(\d{2})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.range "A" "Z") (re.+ (re.union (re.range "A" "Z") (str.to_re "_")))) (re.++ (str.to_re "_") (re.++ (str.to_re "Y") (re.++ (str.to_re "R") ((_ re.loop 2 2) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)