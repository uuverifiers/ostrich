;test regex "^([0]{1,}[0-9a-z].*|.*[a-z].*)$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.union (re.++ (re.++ (re.* (str.to_re "0")) ((_ re.loop 1 1) (str.to_re "0"))) (re.++ (re.union (re.range "0" "9") (re.range "a" "z")) (re.* (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.range "a" "z") (re.* (re.diff re.allchar (str.to_re "\n")))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)