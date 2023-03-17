;test regex ^ATCO-CIF(\d\d)(\d\d)(.{32})(.{16})(\d{8})(\d{4,6})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "-") (re.++ (str.to_re "C") (re.++ (str.to_re "I") (re.++ (str.to_re "F") (re.++ (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ ((_ re.loop 32 32) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 16 16) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 8 8) (re.range "0" "9")) ((_ re.loop 4 6) (re.range "0" "9")))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)