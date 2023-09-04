;test regex ((?:[ \n\r]|^)\w+(?:;[\w.-]+){6}(?:[ \n\r]|&))
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (str.to_re " ") (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "")) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ ((_ re.loop 6 6) (re.++ (str.to_re ";") (re.+ (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.union (str.to_re ".") (str.to_re "-")))))) (re.union (re.union (str.to_re " ") (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "&")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)