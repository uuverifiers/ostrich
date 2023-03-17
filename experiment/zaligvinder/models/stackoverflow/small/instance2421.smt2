;test regex ^[a-zA-Z]{3,9}\.(com|au|org)[^a-zA-Z]
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 3 9) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re ".") (re.++ (re.union (re.union (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m"))) (re.++ (str.to_re "a") (str.to_re "u"))) (re.++ (str.to_re "o") (re.++ (str.to_re "r") (str.to_re "g")))) (re.inter (re.diff re.allchar (re.range "a" "z")) (re.diff re.allchar (re.range "A" "Z")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)