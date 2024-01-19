;test regex (ART\D\d{4}(.*?)\DAND)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "R") (re.++ (str.to_re "T") (re.++ (re.diff re.allchar (re.range "0" "9")) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.diff re.allchar (re.range "0" "9")) (re.++ (str.to_re "A") (re.++ (str.to_re "N") (str.to_re "D"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)