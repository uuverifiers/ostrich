;test regex 0*([5-9]\d*|[1-9]\d+)\d{2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (str.to_re "0")) (re.++ (re.union (re.++ (re.range "5" "9") (re.* (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.+ (re.range "0" "9")))) ((_ re.loop 2 2) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)