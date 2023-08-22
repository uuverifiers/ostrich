;test regex ^[\w.+-]{2,}\@(DOMAIN1|DOMAIN2)\.[a-z]{2,6}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (re.* (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.union (str.to_re ".") (re.union (str.to_re "+") (str.to_re "-"))))) ((_ re.loop 2 2) (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.union (str.to_re ".") (re.union (str.to_re "+") (str.to_re "-")))))) (re.++ (str.to_re "@") (re.++ (re.union (re.++ (str.to_re "D") (re.++ (str.to_re "O") (re.++ (str.to_re "M") (re.++ (str.to_re "A") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (str.to_re "1"))))))) (re.++ (str.to_re "D") (re.++ (str.to_re "O") (re.++ (str.to_re "M") (re.++ (str.to_re "A") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (str.to_re "2")))))))) (re.++ (str.to_re ".") ((_ re.loop 2 6) (re.range "a" "z"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)