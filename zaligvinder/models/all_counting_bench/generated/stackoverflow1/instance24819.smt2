;test regex [A-Z0-9-_]+_\d+-\d{6}\.txt
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "-") (str.to_re "_"))))) (re.++ (str.to_re "_") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "t") (re.++ (str.to_re "x") (str.to_re "t")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)