;test regex [A-Z]+ [A-Z0-9\\/]{2,20} - [A-Z][a-z]+ [0-9]{4}
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.range "A" "Z")) (re.++ (str.to_re " ") (re.++ ((_ re.loop 2 20) (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "\\") (str.to_re "/"))))) (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re " ") (re.++ (re.range "A" "Z") (re.++ (re.+ (re.range "a" "z")) (re.++ (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)