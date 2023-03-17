;test regex L(IF|PA\d{1,}(\.\d{1,}){0,1}) {1,}(\d{1,}(\.\d{1,}){0,}){0,1}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "L") (re.++ (re.union (re.++ (str.to_re "I") (str.to_re "F")) (re.++ (str.to_re "P") (re.++ (str.to_re "A") (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) ((_ re.loop 0 1) (re.++ (str.to_re ".") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))))))))) (re.++ (re.++ (re.* (str.to_re " ")) ((_ re.loop 1 1) (str.to_re " "))) ((_ re.loop 0 1) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (re.* (re.++ (str.to_re ".") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))))) ((_ re.loop 0 0) (re.++ (str.to_re ".") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)