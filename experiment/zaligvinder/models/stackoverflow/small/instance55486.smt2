;test regex $MY_VAR =~ ^[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "M") (re.++ (str.to_re "Y") (re.++ (str.to_re "_") (re.++ (str.to_re "V") (re.++ (str.to_re "A") (re.++ (str.to_re "R") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re "~") (str.to_re " "))))))))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 8 8) (re.union (re.range "A" "F") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "0" "9"))) (re.++ (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "A" "F") (re.range "0" "9"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)