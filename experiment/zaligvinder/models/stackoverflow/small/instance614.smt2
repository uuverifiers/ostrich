;test regex C\d\[\d{2}\]-[A-Z]W\d{2}-MP\d{3}\[-[A-Z]\]\[[a-z]\]
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "C") (re.++ (re.range "0" "9") (re.++ (str.to_re "[") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "]") (re.++ (str.to_re "-") (re.++ (re.range "A" "Z") (re.++ (str.to_re "W") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (str.to_re "M") (re.++ (str.to_re "P") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "[") (re.++ (str.to_re "-") (re.++ (re.range "A" "Z") (re.++ (str.to_re "]") (re.++ (str.to_re "[") (re.++ (re.range "a" "z") (str.to_re "]"))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)