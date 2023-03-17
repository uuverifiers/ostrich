;test regex "^[\\w\\d_\\.]+@([a-z]+\\.)+[a-z]{2,3}$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.+ (re.union (str.to_re "\\") (re.union (str.to_re "w") (re.union (str.to_re "\\") (re.union (str.to_re "d") (re.union (str.to_re "_") (re.union (str.to_re "\\") (str.to_re ".")))))))) (re.++ (str.to_re "@") (re.++ (re.+ (re.++ (re.+ (re.range "a" "z")) (re.++ (str.to_re "\\") (re.diff re.allchar (str.to_re "\n"))))) ((_ re.loop 2 3) (re.range "a" "z"))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)