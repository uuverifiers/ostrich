;test regex if($_ =~ /\d{1}\.\d{2}\W\/)/g
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "i") (re.++ (str.to_re "f") (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "_") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re "~") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.diff re.allchar (str.to_re "_"))))) (str.to_re "/")))))))))))) (re.++ (str.to_re "/") (str.to_re "g")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)