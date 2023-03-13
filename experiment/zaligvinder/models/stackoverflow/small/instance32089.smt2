;test regex ((^|\.)((25[0-5]_*)|(2[0-4]\d_*)|(1\d\d_*)|([1-9]?\d_*))){4}_*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 4 4) (re.++ (re.union (str.to_re "") (str.to_re ".")) (re.union (re.union (re.union (re.++ (str.to_re "25") (re.++ (re.range "0" "5") (re.* (str.to_re "_")))) (re.++ (str.to_re "2") (re.++ (re.range "0" "4") (re.++ (re.range "0" "9") (re.* (str.to_re "_")))))) (re.++ (str.to_re "1") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.* (str.to_re "_")))))) (re.++ (re.opt (re.range "1" "9")) (re.++ (re.range "0" "9") (re.* (str.to_re "_"))))))) (re.* (str.to_re "_"))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)