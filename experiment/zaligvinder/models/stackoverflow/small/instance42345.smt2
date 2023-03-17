;test regex \w{3,}(cagccgctgcccatttg)\w{3,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))) (re.++ (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.++ (str.to_re "c") (re.++ (str.to_re "c") (re.++ (str.to_re "g") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.++ (str.to_re "g") (re.++ (str.to_re "c") (re.++ (str.to_re "c") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (str.to_re "g"))))))))))))))))) (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)