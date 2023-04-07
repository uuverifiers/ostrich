;test regex [a-z]+[a-z\\d]+{3,}\\@[a-z]+\\.[a-z]+
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.range "a" "z")) (re.++ (re.++ (re.* (re.+ (re.union (re.range "a" "z") (re.union (str.to_re "\\") (str.to_re "d"))))) ((_ re.loop 3 3) (re.+ (re.union (re.range "a" "z") (re.union (str.to_re "\\") (str.to_re "d")))))) (re.++ (str.to_re "\\") (re.++ (str.to_re "@") (re.++ (re.+ (re.range "a" "z")) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.+ (re.range "a" "z")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)