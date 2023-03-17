;test regex r'\D(\d{9}[\dXx])(?:$|\D)'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "\u{27}") (re.++ (re.diff re.allchar (re.range "0" "9")) (re.++ (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.union (re.range "0" "9") (re.union (str.to_re "X") (str.to_re "x")))) (re.++ (re.union (str.to_re "") (re.diff re.allchar (re.range "0" "9"))) (str.to_re "\u{27}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)