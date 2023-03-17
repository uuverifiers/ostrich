;test regex ^[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}_Basecall_2D_(.*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ (str.to_re "4") (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ (re.union (str.to_re "89") (re.union (str.to_re "a") (str.to_re "b"))) (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 12 12) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re "_") (re.++ (str.to_re "B") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (str.to_re "_") (re.++ (str.to_re "2") (re.++ (str.to_re "D") (re.++ (str.to_re "_") (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)