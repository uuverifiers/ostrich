;test regex .*(\d{6,}|2[5-9]\d{3,}|[3-9]\d{4,}).* 19.*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.union (re.++ (re.* (re.range "0" "9")) ((_ re.loop 6 6) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.++ (re.range "5" "9") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9")))))) (re.++ (re.range "3" "9") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re " ") (re.++ (str.to_re "19") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)