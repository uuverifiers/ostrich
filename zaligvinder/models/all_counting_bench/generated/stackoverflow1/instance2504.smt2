;test regex ^[A-Za-z]{1}\d+.$*[0-9]$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.+ (re.range "0" "9")) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.* (str.to_re "")) (re.range "0" "9"))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)