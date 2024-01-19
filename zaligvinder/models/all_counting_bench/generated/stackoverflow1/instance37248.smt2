;test regex "DB_TABLE_[a-zA-Z]{3}\\.\\w+\\s*\\=\\s*([0-9]+|(\'(\\s*\\w+\\s*)+\'))"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "D") (re.++ (str.to_re "B") (re.++ (str.to_re "_") (re.++ (str.to_re "T") (re.++ (str.to_re "A") (re.++ (str.to_re "B") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (re.++ (str.to_re "_") (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "w")) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.++ (str.to_re "\\") (re.++ (str.to_re "=") (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.++ (re.union (re.+ (re.range "0" "9")) (re.++ (str.to_re "\u{27}") (re.++ (re.+ (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "w")) (re.++ (str.to_re "\\") (re.* (str.to_re "s")))))))) (str.to_re "\u{27}")))) (str.to_re "\u{22}")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)