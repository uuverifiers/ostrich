;test regex ^1?8\d{2}.*|1?[2-9]\d{7}|\d{5}.*
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "1")) (re.++ (str.to_re "8") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.* (re.diff re.allchar (str.to_re "\n"))))))) (re.++ (re.opt (str.to_re "1")) (re.++ (re.range "2" "9") ((_ re.loop 7 7) (re.range "0" "9"))))) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.* (re.diff re.allchar (str.to_re "\n")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)