;test regex (ExtnTinNo=)(["'][^"']*?)\d{4}["']
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "E") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ (str.to_re "n") (re.++ (str.to_re "T") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "N") (re.++ (str.to_re "o") (str.to_re "=")))))))))) (re.++ (re.++ (re.union (str.to_re "\u{22}") (str.to_re "\u{27}")) (re.* (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.diff re.allchar (str.to_re "\u{27}"))))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re "\u{22}") (str.to_re "\u{27}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)