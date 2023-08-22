;test regex $([1-9]\d{8,})|([3-9]\d{7})|(2[1-9]\d{6})|(20[2-9]\d{5})|(201[6-9]\d{4})|(2015[1-9]\d{3})|(201509\d\d)|(201508[3-9]\d)|(2015082[1-9])
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "") (re.++ (re.range "1" "9") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 8 8) (re.range "0" "9"))))) (re.++ (re.range "3" "9") ((_ re.loop 7 7) (re.range "0" "9")))) (re.++ (str.to_re "2") (re.++ (re.range "1" "9") ((_ re.loop 6 6) (re.range "0" "9"))))) (re.++ (str.to_re "20") (re.++ (re.range "2" "9") ((_ re.loop 5 5) (re.range "0" "9"))))) (re.++ (str.to_re "201") (re.++ (re.range "6" "9") ((_ re.loop 4 4) (re.range "0" "9"))))) (re.++ (str.to_re "2015") (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (str.to_re "201509") (re.++ (re.range "0" "9") (re.range "0" "9")))) (re.++ (str.to_re "201508") (re.++ (re.range "3" "9") (re.range "0" "9")))) (re.++ (str.to_re "2015082") (re.range "1" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)