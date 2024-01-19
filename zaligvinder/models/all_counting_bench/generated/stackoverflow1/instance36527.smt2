;test regex "^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.+ (re.union (str.to_re "_") (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))))) (re.++ (re.* (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.+ (re.union (str.to_re "_") (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-"))))))))) (re.++ (str.to_re "@") (re.++ (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (re.* (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9"))))))) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.* (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)