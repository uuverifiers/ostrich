;test regex U[0-9,A-F]{4}.pdf
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "U") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.union (str.to_re ",") (re.range "A" "F")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "p") (re.++ (str.to_re "d") (str.to_re "f"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)